# RStudio - Menu - Session - Set Working Directory - To Project Directory を実行してください
# CTCAEV4とV5の比較
# 下記パッケージのインストールが必要
# install.packages('readxl')
# install.packages('openxlsx')
# install.packages('stringi') #全角記号を半角に揃えて比較するためインストール
# initialize ------
Sys.setenv("TZ" = "Asia/Tokyo")
if (!exists("parent_path")) {
  parent_path <- getwd()
}
library("readxl")
library("openxlsx")
library("stringi")
# ファイル名の設定
kCtcae_v4 <- "CTCAEv4J_20170912.xlsx"
kCtcae_v5 <- "CTCAEv5J_20180730.xlsx"
kColnames <- c("sortID", "Code", "SOC", "SOC日本語", "Term", "Term日本語", "Grade1原文", "Grade1", "Grade2原文", "Grade2",
                   "Grade3原文", "Grade3", "Grade4原文", "Grade4",  "Grade5原文", "Grade5", "AETerm", "AETerm日本語")
kColnames_v5 <- c(kColnames, "NavigationalNote", "NavigationalNoteJ")
Colnames_mod <- paste0("変更_", kColnames)
# 入力フォルダの設定
input_path <<- paste0(parent_path, "/input")
# 入力ファイルの設定
ctcae_v4_path <- paste(input_path, kCtcae_v4, sep="/")
ctcae_v5_path <- paste(input_path, kCtcae_v5, sep="/")
# 出力フォルダが存在しなければ作成
output_path <<- paste0(parent_path, "/output")
if (file.exists(output_path) == F) {
  dir.create(output_path)
}
# CTCAEファイル取り込み
raw_ctcae_v4 <- read_excel(ctcae_v4_path, sheet=1, col_names=T, na="")
raw_ctcae_v5 <- read_excel(ctcae_v5_path, sheet=1, col_names=T, na="")
# tibbleが扱いづらいのでdataframeに変換
ctcae_v4 <- data.frame(raw_ctcae_v4)
ctcae_v5 <- data.frame(raw_ctcae_v5)
colnames(ctcae_v4) <- kColnames
colnames(ctcae_v5) <- kColnames_v5
# EXCEL出力の際V5の出力順に戻すためシーケンスをセット
ctcae_v5$sortID <- c(1:nrow(ctcae_v5))
# 変更情報格納列の作成
# V5で追加された列があるためダミー列を追加
ctcae_v4$NavigationalNote <-NA
ctcae_v4$NavigationalNoteJ <-NA
for (i in 1:length(Colnames_mod)){
  ctcae_v4[, Colnames_mod[i]] <- NA
  ctcae_v5[, Colnames_mod[i]] <- NA
}

# compare ------
## x %in% y ベクトルyに対しベクトルxの全ての要素を調べ、yの中に存在すればTRUEを返す
# V5で削除されたコード
df_del <- subset(ctcae_v4, !(ctcae_v4$Code %in% ctcae_v5$Code))
df_del$変更_sortID <- "V5で削除"
# V5で追加されたコード
df_add <- subset(ctcae_v5, !(ctcae_v5$Code %in% ctcae_v4$Code))
df_add$変更_sortID <- "V5で新規追加"
# 追加削除以外のコード
df_mod_v4 <- subset(ctcae_v4, ctcae_v4$Code %in% ctcae_v5$Code)
for (i in 1:nrow(df_mod_v4)) {
  df_mod_v5 <- subset(ctcae_v5, Code == df_mod_v4[i, "Code"])
  # Codeより後ろでV4にあった列を確認する
  for (j in 3:length(kColnames)) {
    temp_v4 <- ifelse(!is.na(df_mod_v4[i, j]), df_mod_v4[i, j], "")
    temp_v5 <- ifelse(!is.na(df_mod_v5[1, j]), df_mod_v5[1, j], "")
    # 空白、改行の除去、全角英数記号は半角に統一して比較
    temp_v4 <- stri_trans_nfkc(temp_v4)
    temp_v5 <- stri_trans_nfkc(temp_v5)
    temp_v4 <- gsub(" ", "", temp_v4)
    temp_v5 <- gsub(" ", "", temp_v5)
    temp_v4 <- gsub("[\r|\n]", "", temp_v4)
    temp_v5 <- gsub("[\r|\n]", "", temp_v5)
    if (temp_v4 != temp_v5) {
      df_mod_v4[i, "変更_sortID"] <- "V4->V5変更あり"
      df_mod_v4[i, length(kColnames_v5) +j] <- paste0("V4", "\n", temp_v4, "\n", "V5", "\n", temp_v5)
    }
  }
}
# EXCEL出力
df_merge_v5 <- rbind(df_mod_v4, df_add)
sortlist <- order(df_merge_v5$sortID)
df_sort_v5 <- df_merge_v5[sortlist, ]
df_merge_v4v5 <- rbind(df_del, df_sort_v5)
df_output <- df_merge_v4v5[ ,c("Code", "SOC日本語", "Term日本語", Colnames_mod)]
wb <- createWorkbook()
addWorksheet(wb, 'Sheet1')
writeData(wb, sheet='Sheet1', x=df_output)
saveWorkbook(wb, paste(output_path, "output.xlsx", sep="/"), overwrite=T)
