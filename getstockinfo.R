# 載入套件
#install.packages("rvest")

# 引用套件
library(rvest)

#設定檔案要儲存的路徑
setwd("C:/R")

#================================================
#處理日期的function : 將民國日期轉成西元日期後回傳
#================================================
CNV_DATE <- function(colDate){
  
  #要修改的位置設定
  count <- 1
  tempDate <- colDate
  
  for( i in colDate)
  {
    
    x <- i
    
    #將民國的日期用 / 切割出年月日 (106/09/01 轉成 2017-09-01)
    tmpY <- strsplit(x,"/")[[1]][1]
    Y <- as.integer(tmpY)+1911
    M <-strsplit(x,"/")[[1]][2]
    D <-strsplit(x,"/")[[1]][3]
    tempDate[count] <- paste(Y, M, D, sep = "-")
    count <- count +1
  }
  return(tempDate)
}


#================================================
# 在此這定要抓的股票代號,年份,月份
#================================================

#股票代號
stockNo <- "0050"

#年
y <- c(2016:2017) #也可用此方式設定 c(2015,2016,2017)

#月份
m <- c("01","02","03","04","05","06","07","08","09","10","11","12")




#================================================
#組合要去台灣證交所抓股價的網址
#================================================
ur11 <- "http://www.twse.com.tw/exchangeReport/STOCK_DAY?response=html&date="
ur12 <- "&stockNo="
url3 <- stockNo
urlSet <- rbind()

for( i in y)
{

  for( j in m)
  {
    link <- paste(ur11,i, j, "01", ur12,url3,sep = "")
    urlSet <- rbind(urlSet,link)
  }
}




#================================================
#開始抓資料並儲存成 csv
#檔案欄位 : 日期(Date) 開盤價(O)	最高價(H)	最低價(L)	收盤價(C) 成交張數(v)
#================================================
table <- rbind()

for( i in urlSet)
{

  ur1 <- i
  
  page.source <- read_html(ur1)
  colDate <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(1)') %>% html_text()
  newDate <- CNV_DATE(colDate)
  
  colO <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(4)') %>% html_text()
  colO <- as.numeric(colO)
  
  colH <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(5)') %>% html_text()
  colH <- as.numeric(colH)
  
  colL <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(6)') %>% html_text()
  colL <- as.numeric(colL)
  
  colC <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(7)') %>% html_text()
  colC <- as.numeric(colC)
  
  colV <- page.source  %>% html_nodes('body > div > table > tbody > tr:nth-child(n) > td:nth-child(9)') %>% html_text()
  colV <- sub(",","",colV)
  colV <- as.numeric(colV)
  
  tempTable <- cbind(newDate,colO,colH,colL,colC,colV)
  table2df <- as.data.frame(tempTable,stringsAsFactors = FALSE)
  table <- rbind(table,table2df)
}  

#加上欄位名稱
colnames(table) <- c("Date","O","H","L","C","V")

#寫入csv
write.table(table, file = paste(stockNo,".csv",sep = ""), sep = ",",row.names = FALSE)

#View(table)



