#install.packages("C50")
library(gmodels)
library(C50)

setwd("C:/BigDataSpark/Kaggle/Titanic")

#load train data
train <- read.csv("train.csv", stringsAsFactors=FALSE)
test <- read.csv("test.csv", stringsAsFactors=FALSE)


#check str
str(train)
summary(train)
head(train)

str(test)
summary(test)
head(test)


#資料整理
cleanData <- function(data = data,datatype="") {
  
  #print(str(data))
  features <- c("Pclass",
                "Sex",
                "Age",
                "SibSp",
                "Parch",
                "Embarked",
                "Fare")
  
  #print(features)
  
  if (datatype != "") {
    features <- c(features,"Survived")
  }
  
  #print(features)
  
  newData <- data[,features]
  
  #print(str(newData))
  
  newData$Age[is.na(newData$Age)] <- median(newData$Age, na.rm=TRUE)
  newData$Fare[is.na(newData$Fare)] <- median(newData$Fare, na.rm=TRUE)
  newData$Embarked[newData$Embarked == ""] <- "S"
  
  #print(str(newData$Embarked))
  
  newData <- cbind(newData,AgeLevel=newData$Age)
  newData$AgeLevel[newData$Age > 0 & newData$Age <20] <- "child"
  newData$AgeLevel[newData$Age >= 20 & newData$Age <=60] <- "Aut"
  newData$AgeLevel[newData$Age >60] <- "old"
  
  #print(str(newData$AgeLevel))
  
  newData$Sex      <- as.factor(newData$Sex)
  newData$Embarked <- as.factor(newData$Embarked)
  newData$AgeLevel <- as.factor(newData$AgeLevel)
  
  #print(str(newData$Sex))
  #print(str(newData))
  return(newData)
  
}


# 現有資料train
train_train <- train[1:700,]
train_test <- train[701:891,]

set.seed(123)
x <- sample(1:nrow(train), size = 600, replace = FALSE)
train_train <- train[x,]
train_test <- train[-x,]


train_train_model <-  C5.0(cleanData(train_train),as.factor(train_train$Survived),rules= FALSE)
#summary(train_train_model)
# rules= FALSE TRUE

plot(train_train_model)

train_pred_data <- predict(train_train_model,cleanData(train_test))



CrossTable(train_test$Survived, train_pred_data,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual Survived', 'predicted Survived'))


#------------------------------------
# tune modle
#------------------------------------

library(ggplot2)
library(plyr)
library(caret)

ctrl <- trainControl(method = "repeatedcv",number = 10, repeats = 10)

grid_c50 <- expand.grid(.model = "tree",
                        .trials = c(10, 20, 30, 40),
                        .winnow = "FALSE")

m_c50 <- train(Survived ~ ., data = cleanData(train_train,"M"), method = "C5.0",
               metric = "Kappa", trControl = ctrl,
               tuneGrid = grid_c50)




# all

train_model <- C5.0(cleanData(train),as.factor(train$Survived),trials = 10)

test_pred <- predict(train_model, cleanData(test))

df_pred <- data.frame(PassengerId=test.data$PassengerId,Survived =test_pred)
write.csv(df_pred,"gender_submission_cady_c50.csv", row.names = F)


