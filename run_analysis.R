setwd("C:/Users/seanpalicki/Desktop/Cleaning_Data_Assignment/UCI HAR Dataset")

#### Read Data
## Global Data
features <- read.table("features.txt")
activity_labels <- read.table("activity_labels.txt")

## Train Data
train_x <- read.table("train/X_train.txt")
train_y <- read.table("train/y_train.txt")
train_subject <- read.table("train/subject_train.txt")

## Test Data
test_x <- read.table("test/X_test.txt")
test_y <- read.table("test/y_test.txt")
test_subject <- read.table("test/subject_test.txt")

## Total Data Sets
total.x <- rbind(train_x, test_x)
total.y <- rbind(train_y, test_y)
total.subject <- rbind(train_subject, test_subject)

## Name Activities Data Set
total.y.name <- merge(total.y, activity_labels, by="V1")

## Appropriately Label Variables
colnames(total.y.name) <- c("activity", "activityname")
colnames(total.subject) <- "subject"
colnames(total.x) <- features[,2]

## Select Only Mean and Standard Deviation
featuresMSTD <- grep(".*mean.*|.*std.*", features[,2], value=T)
featuresMSTD <- as.vector(featuresMSTD)
total.x.m.std <- total.x[,featuresMSTD]

## Approriately Label Variables Even More
colnames(total.x.m.std) <- tolower(names(total.x.m.std))
colnames(total.x.m.std) <- gsub("-", "_", names(total.x.m.std))
colnames(total.x.m.std) <- gsub(",", "_", names(total.x.m.std))
colnames(total.x.m.std) <- gsub("\\(\\)", "", names(total.x.m.std))

## Bind Subject-Activity Data with Measurement Data
tot.df <- cbind(total.subject, total.y.name)
tot.df <- cbind(tot.df, total.x.m.std)

tot.df$subject <- as.factor(tot.df$subject)
tot.df$activity <- as.factor(tot.df$activity)

## Load the Magic of Dplyr

library(dplyr)

## Make Dataframe with averages across all measures for subject and activity
# Dplyr Rocks!

subj.act.av <- tot.df %>% 
        group_by(subject, activity, activityname) %>% 
        summarise_each(funs(mean(.,na.rm=T)))

write.table(subj.act.av, "subject_act_avg.csv")












