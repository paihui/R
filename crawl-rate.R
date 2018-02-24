#============================================================
# Demo1 : ��������
#============================================================

#�w�ˮM��
install.packages("xml2")
install.packages("rvest")


#�ޥήM��用
library(xml2)
library(rvest)

#�]�w��������} : �x�W�Ȧ�ײv���
rateurl <-"http://rate.bot.com.tw/xrt"

#�������
ratepage <- read_html(rateurl,encoding="UTF-8")

#�N��쪺�����x�s
setwd("C:/BigDataSpark/R")
write_xml(ratepage,file="ratepage.txt")

#��X
ratepage %>% iconv(from = 'UTF-8', to = 'UTF-8')
ratepage

#���X�ײv���,���O�ζײv

#���X������ন����榡
time <-  ratepage %>% html_nodes('.time') %>% html_text()
time <- as.Date(time)

#���X���O
cury <- ratepage %>% html_nodes('tbody') %>% html_nodes('.print_show') %>% html_text()
cury
#�N�����n���r������
replacePunctuation <- function(x) { gsub("[[:punct:]]+", " ", x) }
sapply(cury,replacePunctuation)
#body > div.page-wrapper > main > div:nth-child(4) > table > tbody > tr:nth-child(1) > td:nth-child(3)

#���X�ײv
rate <- ratepage  %>% html_nodes('tbody > tr:nth-child(n) > td:nth-child(3)') %>% html_text()
rate

#�N��Ʀs�idataframe
datarate <- data.frame(���=time,���O=cury, �ײv=rate)

#�˵����      
View(datarate)