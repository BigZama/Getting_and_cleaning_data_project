library(dplyr); library(tidyr)
unzip(zipfile = "C:\\Coursera\\dataset.zip", exdir ="C:\\Coursera\\dataset")
pathdata <- file.path("C:\\Coursera\\dataset")
files <- list.files(pathdata, recursive = TRUE)

##Test data
testsubjects <- read.table(file.path(pathdata, files[14]), header = FALSE)
testdata <- read.table(file.path(pathdata, files[15]), header = FALSE)
testlabels <- read.table(file.path(pathdata, files[16]), header = FALSE)

## Training data
trainsubjects <- read.table(file.path(pathdata, files[26]), header = FALSE)
traindata <- read.table(file.path(pathdata, files[27]), header = FALSE)
trainlabels <- read.table(file.path(pathdata, files[28]), header = FALSE)

## Data description (variables names and activity labels)
features <- read.table(file.path(pathdata, files[2]), header = FALSE)
activitylabels <- read.table(file.path(pathdata, files [1]),header = FALSE)

##Test data (naming and merging)
colnames(testsubjects) <- "subjectID"
colnames(testlabels) <- "activityID"
colnames(testdata) <- features[,2]
testset <- cbind(testsubjects, testlabels,testdata)
testset$activityID <- factor(testset$activityID, labels = as.character(activitylabels[,2]))

## Training data (naming and merging)
colnames(trainsubjects) <- "subjectID"
colnames(trainlabels) <- "activityID"
colnames(traindata) <- features[,2]
trainingset <- cbind(trainsubjects, trainlabels,traindata)
trainingset$activityID <- factor(trainingset$activityID, labels = as.character(activitylabels[,2]))


## Combining testset and trainingset

MergedSet <- rbind(trainingset, testset)


## Mean and std subsetting
columns <- colnames(MergedSet)
mean <- grep("mean", columns)
sd <- grep("std", columns)
subject <- grep("subjectID", columns)
activity <- grep("activityID", columns)
meansd <- c(mean, sd, subject, activity)
meansd <- sort(meansd)
MergedSetmeansd <- MergedSet[meansd]

##Average of each variable for each activity and each subject
MergedsetMEAN <- MergedSetmeansd %>% group_by(subjectID, activityID) %>% summarize_each(funs(mean))
write.table(MergedsetMEAN, file = "C:\\Coursera\\dataset\\tidydata.txt")
