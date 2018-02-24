#============================================================
# Demo2 : ����text mining �� ��ı��(word cloud)
#============================================================

#------------------------------------------------------
#step1 : �Q�Χ�����������e���R��r
#------------------------------------------------------

#�w�ˮM��
install.packages("xml2")
install.packages("rvest")


#�ޥήM��
library(xml2)
library(rvest)


#�]�w��������} : ���G���: �����{2�d���u���\�t
linkrul1<-"http://www.appledaily.com.tw/appledaily/article/headline/20170219/37557058/%E9%83%AD%E8%91%A3%E7%A0%B82%E5%8D%83%E5%84%84%E8%B5%B4%E7%BE%8E%E8%93%8B%E5%BB%A0"

#��X
apple <- read_html(linkrul1,encoding="UTF-8")
setwd("C:/BigDataSpark/R")
write_xml(apple,file="applenews.txt")

apple %>% iconv(from = 'UTF-8', to = 'UTF-8')

#���o��������
newstext <- apple %>% html_nodes('.articulum.trans') %>% html_nodes('p') %>% html_text()
#�N�����n���r������



#------------------------------------------------------
#step2 : text mining
#------------------------------------------------------

install.packages("jiebaR")

library(jiebaRD)
library(jiebaR)

#�]�w������
cutter <- worker()
cutter["�����{2�d���u���\�t"]

new_user_word(cutter,"2�d��","n")

#�N���o���峹���e�i���_��
countWord <- segment(newstext, cutter)

#�N���n���r����
countWord<-filter_segment(countWord,c("��","�b","�F","��","�O","��","��"))

#�̨C�ӵ��έp�X�{����
tablemx <- table(countWord)

#�ন�x�}�榡
tablemx <- as.matrix(tablemx)

#�Ƨ�
sortdata <- sort(rowSums(tablemx), decreasing = TRUE)

#�নdataframe�榡
df <- data.frame(word = names(sortdata), freq = sortdata)
head(df)

#------------------------------------------------------
#step3 �N�W�z���G��ı�� - ��r��
#------------------------------------------------------

install.packages("wordcloud")

library(RColorBrewer)
library(wordcloud)

#wordcloud(words = df$word, freq = df$freq, min.freq = 3,max.words=10, rot.per=0.35,colors=brewer.pal(8, "Dark2"))


#----------------------------------------------
