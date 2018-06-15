# install.packages("dplyr")
library(dplyr)
# 何階層までグループアドレスをチェックするか
kMaxGroupCount <- 5

Sys.setenv("TZ" = "Asia/Tokyo")
input_path <- "/Users/admin/Desktop/group/input"
output_path <- "/Users/admin/Desktop/group/output"
# 出力フォルダが存在しなければ作成
if (file.exists(output_path) == F) {
  dir.create(output_path)
}
file_list <- list.files(input_path)
for (i in 1:length(file_list)) {
  filepath <- paste(input_path, file_list[i], sep="/")
  # ファイルの1行目がグループ名
  groupname <- readLines(con=filepath, 1)
  groupname <- gsub("(グループ「|」のメンバー)", "", groupname)
  # ファイル名がメールアドレス（@の前まで）
  temp_groupmailaddress <- file_list[i]
  temp_groupmailaddress <- gsub(".csv", "", temp_groupmailaddress)
  # メンバー等はファイルの2行目以降
  temp_csv <- read.csv(filepath, as.is=T, fileEncoding="UTF-8", stringsAsFactors=F, header=T, skip=1)
  temp_csv$groupname <- groupname
  temp_csv$temp_groupmailaddress <- temp_groupmailaddress
  if (i==1) {
    input_csv <- temp_csv
  } else {
    input_csv <- rbind(input_csv, temp_csv)
  }
}
# メールアドレス内のドメイン最頻値をドメインとする
# グループアドレス内のメールアドレスからドメイン部分を取得して格納
input_csv$temp_domains <- gsub("^.*@", "", input_csv$メールアドレス)
# 一番多いドメインをグループアドレスの@以降としてセット
domain <- names(which.max(table(input_csv$temp_domains)))
input_csv$groupmailaddress <- paste(input_csv$temp_groupmailaddress, domain, sep="@")
# グループアドレスxxx@yy.zz.jp一覧を格納
groupmailaddress_table <- names(table(input_csv$groupmailaddress))
# グループのステータス：禁止中は対象外とする
df_edit <- subset(input_csv, input_csv$グループのステータス != "禁止中")
# 不要列を削除、作業用列追加
df_edit <- df_edit[ ,c("groupmailaddress", "メールアドレス", "グループのステータス")]
df_groupmailaddress <- data.frame(matrix(rep(NA, ncol(df_edit)), nrow=1))[numeric(0), ]
# 作業用に空のデータフレームを作成
df_gm_edit <- data.frame(matrix(rep(NA), ncol(df_edit), nrow=1))
names(df_gm_edit) <- names(df_edit)
sortorder <- NA
# グループアドレス内にグループアドレスがある場合、個人メールアドレスに置き換える
for (k in 1:kMaxGroupCount){
  check_mailaddress <- paste0("メールアドレス", k)
  if (k > 1) {
    df_edit[ ,check_mailaddress] <- df_edit[ ,paste0("メールアドレス", k - 1)]
  } else {
    df_edit[ ,check_mailaddress] <- df_edit[ ,"メールアドレス"]
  }
  df_gm_edit[ ,check_mailaddress] <- NA
  # ソート順を格納
  sortorder <- sortorder <- append(sortorder, check_mailaddress)
  # メールアドレスにグループアドレスがあるか判定
  df_groupmailaddress <- subset(df_edit, is.element(df_edit[ ,check_mailaddress], groupmailaddress_table))
  # グループアドレスが無ければ処理終了する
  df_groupmailaddress <- df_groupmailaddress[ ,c("groupmailaddress", check_mailaddress)]
  if (nrow(df_groupmailaddress) == 0){
    break
  }
  names(df_groupmailaddress) <- c("gm_groupmailaddress", "gm_メールアドレス")
  # グループアドレスに対する個人アドレスを抽出する。個人アドレスのステータスは不要なのでNAにする。
  df_address <- left_join(df_groupmailaddress, df_edit, by=c("gm_メールアドレス"="groupmailaddress"))
  df_address$グループのステータス <- NA
  df_address <- df_address[ ,names(df_address) != "メールアドレス"]
  names(df_address) <- names(df_edit)
  for (i in 1:nrow(df_edit)) {
    for (j in 1:nrow(df_address)) {
      if (!is.na(df_edit[i, "groupmailaddress"])){
        if ((df_edit[i, "groupmailaddress"] == df_address[j, "groupmailaddress"]) &&
            (df_edit[i, check_mailaddress] == df_address[j, "メールアドレス"])) {
          df_gm_edit <- rbind(df_gm_edit, df_edit[i, ])
          df_edit[i, ] <- NA
        }
      }
    }
  }
  df_edit <- subset(df_edit, !is.na(df_edit[ ,"groupmailaddress"]))
  df_edit <- rbind(df_edit, df_address)
}
df_gm_edit <- subset(df_gm_edit, !is.na(df_gm_edit[ ,"groupmailaddress"]))
df_edit <- rbind(df_edit, df_gm_edit)
# 昇順でソート
sortorder <- as.character(na.omit(sortorder))
df_sort <- df_edit %>% arrange(groupmailaddress, メールアドレス, get(check_mailaddress))
# 最終メールアドレス列は不要のため削除
df_sort <- df_sort[ ,-ncol(df_sort)]
# 重複しているメールアドレスをまとめる
for (i in 1:nrow(df_sort)) {
  save_mailaddress <- NA
  j <- ncol(df_sort)
  while (j > 0) {
    if (length(grep("メールアドレス", names(df_sort[j]))) > 0) {
      if (!is.na(save_mailaddress) && (df_sort[i, j] == save_mailaddress)) {
        df_sort[i, j] <- NA
      }
      save_mailaddress <- df_sort[i, j]
    }
    j <- j - 1
  }
}
write.csv(df_sort, paste(output_path, "googlegroup.csv", sep="/"), na='""', row.names=F, fileEncoding="CP932")
