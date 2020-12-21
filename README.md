# Getting and Cleaning Data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project:

 https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  

You should create one R script called run_analysis.R that does the following. 

1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for each measurement. 

3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names. 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!

---

# Code Description

Read in the Activity Labels and Features description files and save them to 'activities' and 'features' respectively.
```R
activities <- read.table("./data/activity_labels.txt", header=FALSE, sep="")
features <- read.table("./data/features.txt", header=FALSE, sep="")
```
Read in all of the data for the test group.
```R
## Read test data
testSubject <- read.table("./data/test/subject_test.txt", header=FALSE, sep="")
testActivity <- read.table("./data/test/y_test.txt", header=FALSE, sep="")
testData <- read.table("./data/test/X_test.txt", header=FALSE, sep="")
```
Combine the test group data tables using cbind() and then remove the old tables which are no longer needed using rm().
```R
## Combine test data tables by column and remove old tables from memory
testSet <- cbind(testSubject, testActivity, testData)
rm(testSubject, testActivity, testData)
```
Read in all of the data for the train group.
```R
## Read train data
trainSubject <- read.table("./data/train/subject_train.txt", header=FALSE, sep="")
trainActivity <- read.table("./data/train/y_train.txt", header=FALSE, sep="")
trainData <- read.table("./data/train/X_train.txt", header=FALSE, sep="")
```
Combine the train group data tables using cbind() and then remove the old tables which are no longer needed using rm().
```R
## Combine train data tables by column and remove old tables from memory
trainSet <- cbind(trainSubject, trainActivity, trainData)
rm(trainSubject, trainActivity, trainData)
```
Use rbind() to combine the test and train data groups together.
```R
## Combine test and train data tables by row and remove old tables from memory
completeSet <- rbind(testSet, trainSet)
rm(testSet, trainSet)
```
Add descriptive column names, using **Subject** for the first column, **Activity** for the second column, and the contents of 'features' for the remaining columns. The next line replaces the Activity ID with the Activity name, using 'activities' as a lookup table.
```R
## Add descriptive column names and replace activity codes with activity name
names(completeSet) <- c("Subject", "Activity", as.character(features[,2]))
completeSet[,2] <- activities[completeSet[,2],2]
rm(activities, features)
```
Use grepl() to isolate the columns whose names include the text "mean" or "std", as well as the first two columns (**Subject** and **Activity**), reducing the number of variables from 561 to 88 in the adjusted data table.
```R
## Subset the Data Set to include only columns with mean or std data
completeSet <- completeSet[grepl("subject|activity|std|mean", names(completeSet), ignore.case = TRUE)]
```
Finally, the dplyr functions group_by() and summarize_each() are used to group data by Subject and Activity, and then build a new table (**tidyData**) by taking the mean of each group. This reduces the number of observations down to 180 (30 subjects by 6 activities each).
```R
## Condense the data set by averaging the data for each Subject by each Activity
tidyData<- completeSet %>% group_by(Subject,Activity) %>% summarize_each(funs(mean))
```
