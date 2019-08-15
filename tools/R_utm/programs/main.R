libname <- "stringr"
if(!require(libname, character.only=T)){
  install.packages("tidyverse")
  library(libname, character.only=T)
}
library("dplyr")
library("tidyr")
library("readr")
libname <- "googlesheets"
if(!require(libname, character.only=T)){
  install.packages(libname, character.only=T)
  library(libname, character.only=T)
}
libname <- "ssh"
if(!require(libname, character.only=T)){
  install.packages(libname, character.only=T)
  library(libname, character.only=T)
}
libname <- "here"
if(!require(libname, character.only=T)){
  install.packages(libname, character.only=T)
  library(libname, character.only=T)
}
inputStr <- function(obj_name, str_prompt){
  temp <- readline(prompt=str_prompt)
  assign(obj_name, temp, env=.GlobalEnv)
}
# Get project path
os <- .Platform$OS.type  # mac or windows
#if (os == "unix"){
#  parent_path <- "/Users/admin/Documents/GitHub/utm"
#} else if (OS == "windows"){
#  parent_path <- "//aronas/Datacenter/Users/ohtsuka/2019年度/20190809"
#} else {
#  print("ERROR: OS could not be identified")
#}
parent_path <- here()
# Get URL list
address_list <- read.csv(str_c(parent_path, "/ext/sinet.txt"), header=T, as.is=T)
# Get PC information
gs_auth()
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
rm(ssh_password)
save(list="dhcp_raw", file=(str_c(parent_path, "/dhcp_raw.Rda")))
save(list="sinet_table", file=(str_c(parent_path, "/sinet_table.Rda")))
# Get Static IP list
static_ip <- read.csv(str_c(parent_path, "/ext/static_ip.csv"), as.is=T)
