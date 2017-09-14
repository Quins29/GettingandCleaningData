### Prerequisites
## I set my Working directory
# setwd("C:/Collaborateur/BigData/Coursera/Getting and Cleaning Data/Week04/Project")                           # Example of my Working directory

## Load packages
library(data.table)
library(plyr)


### Step 1
# Load this data for comming soon "features" column into "features" variable
features <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/features.txt"), sep = " ")                        

## Load datas of test
X_test <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/test/X_test.txt"), sep = " ")                       # It is a data set of "X_test" set
activities_test <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/test/y_test.txt"), sep = " ")              # I use this data for the activities ID
volunteers_test <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/test/subject_test.txt"), sep = " ")        # I use this data for to identifie the subject who performed the activity
features_test_Colums <- as.character(features$V2)                                                               # I create à data frame with only V2 column of "features" and converted this in character vector
colnames(X_test) <- features_test_Colums                                                                        # I integrate the V2 colums of "features" into "X_test" data frame
X_test[, activity:= activities_test$V1]                                                                         # adding the values from "activities_test" to "X_test" dataset
X_test[, volunteers:= volunteers_test$V1]                                                                       # adding the values from "volunteers_test" to "X_test" dataset

## Load datas of train
X_train <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/train/X_train.txt"), sep = " ")                    # It is a data set of "X_train" set
activities_train <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/train/y_train.txt"), sep = " ")           # I use this data for the activities ID
volunteers_train <- fread(file.path(getwd(), "./Datas/UCI HAR Dataset/train/subject_train.txt"), sep = " ")     # I use this data for to identifie the subject who performed the activity
features_train_Colums <- as.character(features$V2)                                                              # I create à data frame with only V2 column of "features" and converted this in character vector
colnames(X_train) <- features_train_Colums                                                                      # I integrate the V2 colums of "features" into "X_train" data frame
X_train[, activity:= activities_train$V1]                                                                       # adding the values from "activities_train" to X_train dataset
X_train[, volunteers:= volunteers_train$V1]                                                                     # adding the values from "volunteers_train" to X_train dataset

## Merge dual dataframes "X_test" and "X_train" in one variable "DualSet"
DualSet <- rbind(X_test, X_train)


### Step 2
## Exctract all "mean" and "std" columns of data set "DualSet"
mean_std <- DualSet[,grep("mean|std|volunteers|activity", names(DualSet)), with = FALSE]                        # the last argument "with = FALSE" is necessary otherwise it doesn't work 
                                                                                                                # because the class of "mean_std" is "data.table" AND "data.frame" (not only "data.frame")

### Step 3
## Use file "activity_labels.txt" to name activities in the data set "mean_std"
activity_labels <- fread("./Datas/UCI HAR Dataset/activity_labels.txt", sep = " ")
mean_std$activity = activity_labels$V2[match(mean_std$activity, activity_labels$V1)]                            # I rename the ID activities in row "activity" of "mean_std" Data table


### Step 4
## Modify all rows of "mean_std" data set with better names by regular expression
names(mean_std) <- gsub("[a]ctivity", "Activity", names(mean_std))
names(mean_std) <- gsub("[v]olunteers", "Volunteers", names(mean_std))
names(mean_std) <- gsub("-", "", names(mean_std))
names(mean_std) <- gsub("\\(\\)", "", names(mean_std))
names(mean_std) <- gsub("^t", "Time", names(mean_std))
names(mean_std) <- gsub("^f|freq", "Frequency", names(mean_std))
names(mean_std) <- gsub("[Bb]ody[Bb]ody|[Bb]ody", "Body", names(mean_std))
names(mean_std) <- gsub("[Gg]ravity", "Gravity", names(mean_std))
names(mean_std) <- gsub("[Aa]cc", "Accelerometer", names(mean_std))
names(mean_std) <- gsub("[Gg]yro", "Gyroscope", names(mean_std))
names(mean_std) <- gsub("[Jj]erk", "Jerk", names(mean_std))
names(mean_std) <- gsub("[Mm]ag", "Magnitude", names(mean_std))
names(mean_std) <- gsub("[Mm]ean", "Mean", names(mean_std))
names(mean_std) <- gsub("[Ss]td", "StandardDeviation", names(mean_std))
names(mean_std) <- gsub("[X]$", "XAxis", names(mean_std))
names(mean_std) <- gsub("[Y]$", "YAxis", names(mean_std))
names(mean_std) <- gsub("[Z]$", "ZAxis", names(mean_std))


### Step 5
## From "mean_std" data set, I generate a second tiny data set with the average of each variable for each activity and each subject
# Use aggrate fonction who select all columns "*mean" AND "*std" of "Activity" AND "Volunteers" AND calculate mean in each columns
tidyDataSet <- aggregate(. ~Activity + Volunteers, mean_std, mean)                                              

# Write the results of this new data set into this file texte "tidyDataSet.txt"
write.table(tidyDataSet, file = "./Datas/TidyData/tidyDataSet.txt", sep = " ", row.names = FALSE, col.names = TRUE)

