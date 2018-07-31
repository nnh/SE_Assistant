# （処理毎に）下記の手順が必要
# RStudio - Menu - Session - choose Directory
# inputフォルダの親パス を選択
# 例）c:\aaa\bbb\input\に入力ファイルがあればc:\aaa\bbb\を選択
# Constant definition ------
Sys.setenv("TZ" = "Asia/Tokyo")
if (!exists("prt_path")) {
  prt_path <- getwd()
}
# path setting ------
input_path <- paste0(prt_path, "/", "input")
output_path <- paste0(prt_path, "/", "output/")
# 出力フォルダが存在しなければ作成
if (file.exists(output_path) == F) {
  dir.create(output_path)
}
# テキストファイル以外は対象外
file_list <- list.files(input_path, recursive=T, full.names=T, pattern=".txt")
# ファイル名を見出しにする
file_name_list <- list.files(input_path, recursive=T, full.names=F, pattern=".txt")
file_name_list <- paste0("# ", file_name_list)
df <- data.frame(file_name_list, rep(NA, length(file_name_list)))
names(df) <- c("filename", "text")
for (i in 1:length(file_list)) {
  con <- file(file_list[i], encoding="CP932")
  str <- readLines(con, warn=F)
  close(con)
  for (j in 1:length(str)) {
    if (exists("temp_str")) {
      temp_str <- paste0(temp_str, "  ", "\r\n", str[j])
    } else {
      temp_str <- str[j]
    }
  }
  df[i, "text"] <- temp_str
  rm(temp_str)
}
df$filename <- as.character(df$filename)
df$text[df$text=="NA  \r\n"] <- ""
df$text <- as.character(df$text)
#write.table(df, paste(output_path, "test.csv"),
#                      fileEncoding="utf-8", row.names=F)
for (i in 1:length(file_list)) {
  write(df[i, 1], paste(output_path, "test.md"), append=T, sep="\t")
  write(df[i, 2], paste(output_path, "test.md"), append=T, sep="\t")
}
