# RStudio - Menu - Session - Set Working Directory - To Project Directory を実行してください
# CTCAEV4とV5の比較
# readxlのインストールが必要
# install.packages('readxl')
# initialize ------
Sys.setenv("TZ" = "Asia/Tokyo")
if (!exists("parent_path")) {
  parent_path <- getwd()
}
library("readxl")
# ファイル名の設定
kCtcae_v4 <- "CTCAEv4J_20170912.xlsx"
kCtcae_v5 <- "CTCAEv5J_20180730.xlsx"
kColnames <- c("sortID", "Code", "SOC", "S0CJ", "Team", "TeamJ", "Grade1Raw", "Grade1", "Grade2Raw", "Grade2",
                   "Grade3Raw", "Grade3", "Grade4Raw", "Grade4",  "Grade5Raw", "Grade5", "AETerm", "AETermJ")
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

# compare ------
## x %in% y ベクトルyに対しベクトルxの全ての要素を調べ、yの中に存在すればTRUEを返す
# V5で削除されたコード
df_del <- subset(ctcae_v4, !(ctcae_v4$Code %in% ctcae_v5$Code))
# V5で追加されたコード
df_add <- subset(ctcae_v5, !(ctcae_v5$Code %in% ctcae_v4$Code))
# 追加削除以外のコード
df_mod_v4 <- subset(ctcae_v4, ctcae_v4$Code %in% ctcae_v5$Code)
# 変更情報格納列の作成
for (i in 1:length(Colnames_mod)){
  df_mod_v4[, Colnames_mod[i]] <- NA
}
for (i in 1:nrow(df_mod_v4)) {
  df_mod_v5 <- subset(ctcae_v5, Code == df_mod_v4[i, "Code"])
  # Codeより後ろでV4にあった列を確認する
  for (j in 3:length(kColnames)) {
    temp_v4 <- ifelse(!is.na(df_mod_v4[i, j]), df_mod_v4[i, j], "")
    temp_v5 <- ifelse(!is.na(df_mod_v5[1, j]), df_mod_v5[1, j], "")
    if (temp_v4 != temp_v5) {
      df_mod_v4[i, length(kColnames) +j] <- paste0("V4", "\n", temp_v4, "\n", "V5", "\n", temp_v5)
    }
  }
}
# EXCEL出力

