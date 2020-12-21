activities <- read.table("./data/activity_labels.txt", header=FALSE, sep="")
features <- read.table("./data/features.txt", header=FALSE, sep="")

## Read test data
testSubject <- read.table("./data/test/subject_test.txt", header=FALSE, sep="")
testActivity <- read.table("./data/test/y_test.txt", header=FALSE, sep="")
testData <- read.table("./data/test/X_test.txt", header=FALSE, sep="")

## Combine test data tables by column and remove old tables from memory
testSet <- cbind(testSubject, testActivity, testData)
rm(testSubject, testActivity, testData)

## Read train data
trainSubject <- read.table("./data/train/subject_train.txt", header=FALSE, sep="")
trainActivity <- read.table("./data/train/y_train.txt", header=FALSE, sep="")
trainData <- read.table("./data/train/X_train.txt", header=FALSE, sep="")

## Combine train data tables by column and remove old tables from memory
trainSet <- cbind(trainSubject, trainActivity, trainData)
rm(trainSubject, trainActivity, trainData)

## Combine test and train data tables by row and remove old tables from memory
completeSet <- rbind(testSet, trainSet)
rm(testSet, trainSet)

## Add descriptive column names and replace activity codes with activity name
names(completeSet) <- c("Subject", "Activity", as.character(features[,2]))
completeSet[,2] <- activities[completeSet[,2],2]
rm(activities, features)

## Subset the Data Set to include only columns with mean or std data
completeSet <- completeSet[grepl("subject|activity|std|mean", names(completeSet), ignore.case = TRUE)]

## Condense the data set by averaging the data for each Subject by each Activity
tidyData<- completeSet %>% group_by(Subject,Activity) %>% summarize_each(funs(mean))
