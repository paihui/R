#============================================================
# Demo1 : ºô­¶ª¦ÂÎ
#============================================================

#¦w¸Ë®M¥ó
install.packages("xml2")
install.packages("rvest")


#¤Þ¥Î®M¥ó•ç”¨
library(xml2)
library(rvest)

#³]©w§ì¨úªººô§} : ¥xÆW»È¦æ¶×²v¸ê®Æ
rateurl <-"http://rate.bot.com.tw/xrt"

#§ì¨úºô­¶
ratepage <- read_html(rateurl,encoding="UTF-8")

#±N§ì¨ìªººô­¶Àx¦s
setwd("C:/BigDataSpark/R")
write_xml(ratepage,file="ratepage.txt")

#Âà½X
ratepage %>% iconv(from = 'UTF-8', to = 'UTF-8')
ratepage

#¨ú¥X¶×²v¤é´Á,¹ô§O¤Î¶×²v

#¨ú¥X¤é´Á¨ÃÂà¦¨¤é´Á®æ¦¡
time <-  ratepage %>% html_nodes('.time') %>% html_text()
time <- as.Date(time)

#¨ú¥X¹ô§O
cury <- ratepage %>% html_nodes('tbody') %>% html_nodes('.print_show') %>% html_text()
cury
#±N¤£¥²­nªº¦r¤¸²¾°£
replacePunctuation <- function(x) { gsub("[[:punct:]]+", " ", x) }
sapply(cury,replacePunctuation)
#body > div.page-wrapper > main > div:nth-child(4) > table > tbody > tr:nth-child(1) > td:nth-child(3)

#¨ú¥X¶×²v
rate <- ratepage  %>% html_nodes('tbody > tr:nth-child(n) > td:nth-child(3)') %>% html_text()
rate

#±N¸ê®Æ¦s¶idataframe
datarate <- data.frame(¤é´Á=time,¹ô§O=cury, ¶×²v=rate)

#ÀËµø¸ê®Æ      
View(datarate)
