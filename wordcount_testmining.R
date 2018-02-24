#============================================================
# Demo2 : 中文text mining 及 視覺化(word cloud)
#============================================================

#------------------------------------------------------
#step1 : 利用抓取的網頁內容分析文字
#------------------------------------------------------

#安裝套件
install.packages("xml2")
install.packages("rvest")


#引用套件
library(xml2)
library(rvest)


#設定抓取的網址 : 水果日報: 郭董砸2千億赴美蓋廠
linkrul1<-"http://www.appledaily.com.tw/appledaily/article/headline/20170219/37557058/%E9%83%AD%E8%91%A3%E7%A0%B82%E5%8D%83%E5%84%84%E8%B5%B4%E7%BE%8E%E8%93%8B%E5%BB%A0"

#轉碼
apple <- read_html(linkrul1,encoding="UTF-8")
setwd("C:/BigDataSpark/R")
write_xml(apple,file="applenews.txt")

apple %>% iconv(from = 'UTF-8', to = 'UTF-8')

#取得網頁內文
newstext <- apple %>% html_nodes('.articulum.trans') %>% html_nodes('p') %>% html_text()
#將不必要的字元移除



#------------------------------------------------------
#step2 : text mining
#------------------------------------------------------

install.packages("jiebaR")

library(jiebaRD)
library(jiebaR)

#設定切詞器
cutter <- worker()
cutter["郭董砸2千億赴美蓋廠"]

new_user_word(cutter,"2千億","n")

#將取得的文章內容進行斷詞
countWord <- segment(newstext, cutter)

#將不要的字移除
countWord<-filter_segment(countWord,c("的","在","了","很","是","等","較"))

#依每個詞統計出現次數
tablemx <- table(countWord)

#轉成矩陣格式
tablemx <- as.matrix(tablemx)

#排序
sortdata <- sort(rowSums(tablemx), decreasing = TRUE)

#轉成dataframe格式
df <- data.frame(word = names(sortdata), freq = sortdata)
head(df)

#------------------------------------------------------
#step3 將上述結果視覺化 - 文字雲
#------------------------------------------------------

install.packages("wordcloud")

library(RColorBrewer)
library(wordcloud)

#wordcloud(words = df$word, freq = df$freq, min.freq = 3,max.words=10, rot.per=0.35,colors=brewer.pal(8, "Dark2"))


#----------------------------------------------

