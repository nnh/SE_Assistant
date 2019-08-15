library("stringr")
library("dplyr")
library("tidyr")
library("readr")
library("googlesheets")
library("ssh")
library("here")
#' @title
#' inputStr
#' @param
#' obj_name : Object name for storing input value
#' str_prompt : String output at the prompt
#' @return
#' No return value
inputStr <- function(obj_name, str_prompt){
  temp <- readline(prompt=str_prompt)
  assign(obj_name, temp, env=.GlobalEnv)
}
#' @title
#' Exit function
#' @description
#' Exit from this program
#' @return
#' No return value
Exit <- function(){
  .Internal(.invokeRestart(list(NULL, NULL), NULL))
}
#' @title
#' ReadLog
#' @param
#' input_file_path : Full path of csv to read
#' @return
#' String vector
ReadLog <- function(input_file_path){
  con <- file(description=input_file_path, open="rt")
  if (os == "unix"){
    lines <- iconv(readLines(con=con, encoding="utf-8"), from ="utf-8",  to = "utf-8")
  } else{
    lines <- iconv(readLines(con=con, encoding="utf-8"), from ="utf-8",  to = "cp932")
  }
  close(con=con)
  return(lines)
}
#' @title
#' GetLogFullName
#' @param
#' target : target file name
#' file_list : file list
#' @return
#' Full name of target file
GetLogFullName <- function(target, file_list){
  temp_idx <- str_which(file_list, target)
  if (length(temp_idx) > 0){
    return(file_list[temp_idx])
  } else {
    stop(str_c(kTargetLog[i], "をダウンロードして再実行してください"))
  }
}
# Constant definition
kTargetLog <- c("Admin and System Events Report without guest",
                "Application and Risk Analysis without guest",
                "Bandwidth and Applications Report without guest",
                "Client Reputation without guest",
                "User Report without guest")
kIpAddr <- paste0("(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])", "\\", ".){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])")
kDhcp_header <- c("IP", "v2", "MAC-Address", "Hostname", "v5", "v6", "v7", "VCI", "v9", "v10", "Expiry")
# Get project path
os <- .Platform$OS.type  # mac or windows
parent_path <- here()
input_path <- str_c(parent_path, "/input")
ext_path <- str_c(parent_path, "/ext")
# Read utm log
file_list <- list.files(input_path)
target_file_list <- sapply(kTargetLog, GetLogFullName, file_list)
input_file_path <- str_c(input_path, "/", target_file_list)
raw_log_list <- sapply(input_file_path, ReadLog)
log_obj_name <- make.names(kTargetLog)

ccc <- function(raw_log){
  input_file <- str_replace_all(raw_log, pattern='\"', replacement="")
  for (i in 1:length(input_file)){
    temp_header <- str_extract(input_file[i], pattern="###.*###")
    if (!is.na(temp_header)){
      header <- temp_header
    } else if (input_file[i] == ""){

    } else {
      str_log <- unlist(strsplit(input_file[i], ","))
      # Outputs host name if IP address
      temp_row <- str_extract(str_log, kIpAddr)
      temp_ip <- temp_row[!is.na(temp_row)]
      # Remove duplicate columns
      temp_ip <- unique(temp_ip)
      if (!(identical(temp_ip, character(0)))){
        # static
        temp_hostname <- filter(static_ip, IP==temp_ip)
        if (identical(temp_hostname, character(0))){
          # dynamic
          temp_hostname <- filter(df_dhcp, IP==temp_ip)$Hostname
        }
        print(temp_hostname)
      }
    }
  }
}
abc <- sapply(raw_log_list, ccc)
# Get URL list
address_list <- read.csv(str_c(ext_path, "/sinet.txt"), header=T, as.is=T)
# Get PC information
gs_auth(new_user=T, cache=F)
sinet_url <- filter(address_list, ID == "sinet")$Item
ss <- gs_url(sinet_url)
sinet_table <- gs_read(ss, ws=1)
# Get DHCP list
input_dhcp_login <- filter(address_list, ID == "dhcp")$Item
inputStr("ssh_user", "UTMのユーザー名を入力してください：")
dhcp_login <- str_c(ssh_user, input_dhcp_login)
inputStr("ssh_password", "UTMのパスワードを入力してください：")
session <- ssh_connect(dhcp_login, passwd=ssh_password)
dhcp_raw <- ssh_exec_internal(session, command = "execute dhcp lease-list")
ssh_disconnect(session)
# Get Static IP list
static_ip <- read.csv(str_c(ext_path, "/static_ip.csv"), as.is=T)
# Delete all objects
rm(list = ls())
