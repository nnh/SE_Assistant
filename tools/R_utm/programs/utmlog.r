kIpAddr <- paste0("(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])", "\\", ".){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])")
kDhcp_header <- c("IP", "v2", "MAC-Address", "Hostname", "v5", "v6", "v7", "VCI", "v9", "v10", "Expiry")
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
bbb <- function(input_file){
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
        print(temp_ip)
        print(temp_hostname)
        if (identical(temp_hostname, character(0))){
          # dynamic
#        print(str_log)
          temp_hostname <- filter(df_dhcp, IP==temp_ip)$Hostname
        }
      }
    }
  }
}
# Format DHCP list
list_dhcp_raw <- read_lines_raw(dhcp_raw[[2]])
list_dhcp <- lapply(list_dhcp_raw, rawToChar)
list_dhcp <- lapply(list_dhcp, function(x){str_split_fixed(x, pattern="\t", 11)})
# Remove the space before the IP address
for (i in 1:length(list_dhcp)){
  list_dhcp[[i]][1] <- trimws(list_dhcp[[i]][1])
}
df_dhcp <- data.frame(matrix(unlist(list_dhcp), nrow=length(list_dhcp), byrow=T), stringsAsFactors=F)
colnames(df_dhcp) <- kDhcp_header
# read utm log
input_path <- str_c(parent_path, "/input")
file_list <- list.files(input_path)
input_file_path <- str_c(input_path, "/", file_list)
log_list <- sapply(input_file_path, ReadLog)
for (i in 1:length(log_list)){
  print(file_list[i])
  temp <- str_replace_all(log_list[[i]], pattern='\"', replacement="")
  bbb(temp)
}
#str_subset(log_list[[1]][1], "###.*###")
#str_subset(log_list[[1]][2], "###")
#str_extract(log_list[[1]][1], pattern="###.*###")
# /^(([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([1-9]?[0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
