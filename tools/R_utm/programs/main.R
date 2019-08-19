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
#' @title
#' IntToBitVect
#' @param
#' x : Decimal number or string
#' @return
#' Vector of values converted to binary (8bit)
IntToBitVect <- function(x){
  temp <- rev(as.numeric(intToBits(x))[1:8])
  return(temp)
}
# Constant definition
kTargetLog <- c("Admin and System Events Report without guest",
                "Application and Risk Analysis without guest",
                "Bandwidth and Applications Report without guest",
                "Client Reputation without guest",
                "User Report without guest")
# kIpAddr <- paste0("(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])", "\\", ".){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])")
kIpAddr <- "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"
kDhcp_header <- c("IP", "v2", "MAC-Address", "Hostname", "v5", "v6", "v7", "VCI", "v9", "v10", "Expiry")
# Get project path
os <- .Platform$OS.type  # mac or windows
parent_path <- here()
input_path <- str_c(parent_path, "/input")
ext_path <- str_c(parent_path, "/ext")
# Read utm log
file_list <- list.files(input_path)
target_file_list <- sapply(kTargetLog, GetLogFullName, file_list)
raw_log_list <- sapply(str_c(input_path, "/", target_file_list), ReadLog)
log_obj_name <- make.names(kTargetLog)

AddUserInfo <- function(raw_log){
  input_file <- str_replace_all(raw_log, pattern='\"', replacement="")
  output_file <- input_file
  # eofまで
  for (i in 1:length(input_file)){
    # カンマで分割
    str_log <- unlist(strsplit(input_file[i], ","))
    # Outputs host name if IP address
    temp_row <- str_extract(str_log, kIpAddr)
    # Remove duplicate columns
    temp_ip <- temp_row[!is.na(temp_row)] %>% unique
    # その行にIPアドレスが含まれていたらホスト名と所属を取得する
    if (!(identical(temp_ip, character(0)))){
      temp_ip_row <- filter(private_ip, IP==temp_ip)
      if (nrow(temp_ip_row) == 1){
        output_file[i] <- str_c(output_file[i], ",",temp_ip_row$Hostname, ",", temp_ip_row$User, "," ,temp_ip_row$Department)
      } else if (nrow(temp_ip_row) > 1){
        # 重複ありのとき
      }
    }
  }
  return(output_file)
}
# Get URL list
address_list <- read.csv(str_c(ext_path, "/sinet.txt"), header=T, as.is=T)
# Get PC information
gs_auth(new_user=T, cache=F)
sinet_table <- filter(address_list, ID == "sinet")$Item %>% gs_url %>% gs_read(ws=1)
# Get DHCP list
input_dhcp_login <- filter(address_list, ID == "dhcp")$Item
inputStr("ssh_user", "UTMのユーザー名を入力してください：")
dhcp_login <- str_c(ssh_user, input_dhcp_login)
inputStr("ssh_password", "UTMのパスワードを入力してください：")
session <- ssh_connect(dhcp_login, passwd=ssh_password)
dhcp_raw <- ssh_exec_internal(session, command = "execute dhcp lease-list")
ssh_disconnect(session)
# Format DHCP list
list_dhcp <- read_lines_raw(dhcp_raw[[2]]) %>% lapply(rawToChar) %>% lapply(function(x){str_split_fixed(x, pattern="\t", 11)})
# Remove the space before the IP address
for (i in 1:length(list_dhcp)){
  list_dhcp[[i]][1] <- trimws(list_dhcp[[i]][1])
}
df_dhcp <- unlist(list_dhcp) %>% matrix(nrow=length(list_dhcp), byrow=T) %>% data.frame(stringsAsFactors=F)
colnames(df_dhcp) <- kDhcp_header
# Get owner from hostname
sinet_table <- rename(sinet_table, Hostname="コンピュータ名")
# Check for duplicate hostname
duplicate_hostname <- sinet_table %>% group_by(Hostname) %>% filter(n() > 1) %>% select(Hostname) %>% unique %>% unlist
sinet_table$Duplicate <- ifelse(sinet_table$Hostname %in% duplicate_hostname, T, F)
dynamic_ip <- left_join(sinet_table, df_dhcp, by="Hostname") %>% select(User="使用者名", Department="部署名", "Hostname", "IP", MAC_Address="MAC-Address", "Duplicate")
# Get Static IP list
static_ip <- read.csv(str_c(ext_path, "/static_ip.csv"), as.is=T)
static_ip$Department <- ""
static_ip$Duplicate <- F
static_ip <- static_ip %>% select(User="所有者", "Department", "Hostname", "IP", MAC_Address="MAC.Address", "Duplicate")
private_ip <- bind_rows(static_ip, dynamic_ip)
# Get Whitelist and Blacklist
raw_excluded <- read.csv(str_c(ext_path, "/excluded.csv"), as.is=T)
# ネットワーク部のIP一覧を作成する
excluded <- raw_excluded$IP %>% str_split_fixed(pattern="/", n=2) %>% data.frame(stringsAsFactors=F) %>% cbind(raw_excluded$Description)
colnames(excluded) <- c("IP", "Subnet_mask", "Description")
temp_excluded <- excluded %>% filter(Subnet_mask != "")

for (i in 1:nrow(temp_excluded)){
  output_bit_ip <- rep(NA, 32)
  bit_ip <- temp_excluded[i, "IP"] %>% str_split(pattern="\\." ) %>% unlist %>% lapply(IntToBitVect) %>% unlist
  num_subnet_mask <- as.numeric(temp_excluded[i, "Subnet_mask"])
  bit_subnet <- c(rep(1, num_subnet_mask), rep(0, 32 - num_subnet_mask))
  if (num_subnet_mask >=8){
    output_bit_ip[1:8] <- bit_ip[1:8]
    if (num_subnet_mask >=16){
      output_bit_ip[9:16] <- bit_ip[9:16]
      if (num_subnet_mask >=24){
        output_bit_ip[17:24] <- bit_ip[17:24]
      } else {
        temp_num_subnet <- 24 - num_subnet_mask
        temp_subnet <- bit_ip[17:temp_num_subnet]
        temp_start <- temp_subnet
        temp_start[is.na(temp_start)] <- 0
        temp_end <- temp_subnet
        temp_end[is.na(temp_end)] <- 1
      }
    }
  }
}
# IPテーブルのNAを空白に置換しないと結果が欠落する
#test <- private_ip
#test[is.na(test)] <- ""
# ホスト名などの情報を付与する
output_list <- sapply(raw_log_list, AddUserInfo)
# Delete all objects
rm(list = ls())

