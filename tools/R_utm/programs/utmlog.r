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



for (i in 1:length(log_list)){
#  print(file_list[i])
#  temp <- str_replace_all(log_list[[i]], pattern='\"', replacement="")
  bbb(temp)
}
