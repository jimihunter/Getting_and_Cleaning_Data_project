#check and install packages
if (!require("data.table")){ 
    install.packages("data.table")
}
if (!require("reshape2")) {
    install.packages("reshape2")
}
if (!require("dplyr")) {
    install.packages("dplyr")
}
#load packages
library(data.table); library(reshape2); library(dplyr)

#create directory if not exist
if (!file.exists("./runData")) {
    dir.create("./runData")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./runData/dataset.zip", method="curl")

unzip(zipfile="./runData/dataset.zip", exdir="./runData")

#reading features and activity data
#column names
feature_names <- read.table("./runData/UCI HAR Dataset//features.txt")
# labels
activity_labels <- read.table("./runData/UCI HAR Dataset//activity_labels.txt", header = FALSE)

#read activity, subject and feature training set into variables
subject_train <- read.table("./runData//UCI HAR Dataset/train//subject_train.txt")
activity_train <- read.table("./runData//UCI HAR Dataset/train/y_train.txt")
feature_train <- read.table("./runData/UCI HAR Dataset/train//X_train.txt")

#read activity, subject and feature test set into variables
subject_test <- read.table("./runData//UCI HAR Dataset/test//subject_test.txt")
activity_test <- read.table("./runData/UCI HAR Dataset/test//y_test.txt")
feature_test <- read.table("./runData//UCI HAR Dataset/test//X_test.txt")

#merge training and test sets
subject <- rbind(subject_train, subject_test); activity <- rbind(activity_train, activity_test)
features <- rbind(feature_train, feature_test)

#column naming in data set
colnames(features) <- t(feature_names[2])
colnames(subject) <- "Subject"; colnames(activity) <- "Activity"

#merge all data into one
mergeData <- cbind(features, activity,subject)

#indices of columns with mean or std
mean_or_sd <- grep(".*Mean.*|.*Std.*",names(mergeData), ignore.case = TRUE)

completeIndices <- c(mean_or_sd, 562,563)

meanstd_extract <- mergeData[,completeIndices]

meanstd_extract$Activity <- as.character(meanstd_extract$Activity)

for (i in 1:6) {
    meanstd_extract$Activity[meanstd_extract$Activity == i] <- as.character(activity_labels[i,2])
}

#factorize the  Activity variable
meanstd_extract$Activity <- as.factor(meanstd_extract$Activity)

#appropriate labels
names(meanstd_extract) <- gsub("^t", "time", names(meanstd_extract))
names(meanstd_extract) <- gsub("^f", "frequency", names(meanstd_extract))
names(meanstd_extract) <- gsub("Acc", "Accelerometer", names(meanstd_extract))
names(meanstd_extract) <- gsub("Gyro", "Gyroscope", names(meanstd_extract))
names(meanstd_extract) <- gsub("Mag", "Magnitude", names(meanstd_extract))
names(meanstd_extract) <- gsub("BodyBody", "Body", names(meanstd_extract))
names(meanstd_extract) <- gsub("tBody", "timeBody", names(meanstd_extract))

#creating tidy data
meanstd_extract$Subject <- as.factor(meanstd_extract$Subject)
meanstd_extract <- data.table(meanstd_extract)

tidy_data <- aggregate(. ~Subject + Activity, meanstd_extract, mean)
tidy_data <- tidy_data[order(tidy_data$Subject, tidy_data$Activity),]
write.table(tidy_data, file="tidy_data.txt", row.names=FALSE)



