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
# Get owner from hostname
dynamic_pc <- left_join(sinet_table, df_dhcp, by=c("コンピュータ名"="Hostname"))
dynamic_pc <- select(dynamic_pc, "使用者名", "部署名", "コンピュータ名", "IP", "MAC-Address")



for (i in 1:length(log_list)){
#  print(file_list[i])
#  temp <- str_replace_all(log_list[[i]], pattern='\"', replacement="")
  bbb(temp)
}
