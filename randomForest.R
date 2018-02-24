
#install.packages("caret")
library(gmodels)
library(randomForest)
library(lattice)
library(ggplot2)
library(caret)

setwd("C:/BigDataSpark/Kaggle/Titanic")

#load train data
train <- read.csv("train.csv", stringsAsFactors=FALSE)
test <- read.csv("test.csv", stringsAsFactors=FALSE)


#check str
str(train)
summary(train)

str(test)
summary(test)

#資料整理

cleanData <- function(data,datatype = "Train") {
  #"Survived",
  features <- c("Pclass",
                "Sex",
                "Age",
                "SibSp",
                "Parch",
                "Embarked")
  
  print(datatype)  
  if (datatype == "Train") {
    features <- c(features,"Survived")
  }
  print(features)
  
  newData <- data[,features]
  
  newData$Age[is.na(newData$Age)] <- median(newData$Age, na.rm=TRUE)
  newData$Embarked[newData$Embarked == ""] <- "S"
  
  newData <- cbind(newData,AgeLevel=newData$Age)
  newData$AgeLevel[newData$Age > 0 & newData$Age <20] <- "child"
  newData$AgeLevel[newData$Age >= 20 & newData$Age <=60] <- "Aut"
  newData$AgeLevel[newData$Age >60] <- "old"
  
  newData$Sex      <- as.factor(newData$Sex)
  newData$Embarked <- as.factor(newData$Embarked)
  newData$AgeLevel <- as.factor(newData$AgeLevel)

  return(newData)
}


# 現有資料train

set.seed(123)
x <- sample(1:nrow(train.data), size = 600, replace = FALSE)
train_train <- train.data[x,]
train_test <- train.data[-x,]


#train_train <- train.data[1:700,]
#train_test <- train.data[701:891,]

train_train_model <- randomForest(cleanData(train_train), as.factor(train_train$Survived), ntree=150, mtry=2,importance=TRUE)

train_pred_data <- predict(train_train_model, cleanData(train_test))


CrossTable(train_test$Survived, train_pred_data,
           prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE,
           dnn = c('actual Survived', 'predicted Survived'))

#-------------------------------------

ctrl <- trainControl(method = "repeatedcv",number = 10, repeats = 10)

grid_rf <- expand.grid(.mtry = c(2, 4, 6))

m_rf <- train(Survived ~ ., cleanData(train_train), method = "rf",
              metric = "Kappa", trControl = ctrl,
              tuneGrid = grid_rf)

modelLookup("C5.0")
modelLookup("rf")
modelLookup("knn")

grid <- expand.grid(.model = "tree",
                    .trials = c(1, 5, 10, 15, 20, 25, 30, 35),
                    .winnow = "FALSE")
m <- train(default ~ ., data = credit, method = "C5.0",
           metric = "Kappa",
           trControl = ctrl,
           tuneGrid = grid)

#-------------------------------------

#  all
train_model <- randomForest(cleanData(train), as.factor(train$Survived), ntree=100,mtry=3,importance=TRUE)

test_data <- cleanData(test,"Test")
pred_data <- predict(train_model,test_data)


# write csv
df_pred <- data.frame(PassengerId=test.data$PassengerId,Survived =pred_data)
write.csv(df_pred,"gender_submission_cady_rf.csv", row.names = F)
