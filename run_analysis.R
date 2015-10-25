library(reshape2)


# read data into data frames
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
feature <- read.table("./UCI HAR Dataset/features.txt")
activities<-read.table("./UCI HAR Dataset/activity_labels.txt")


names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(X_train) <- feature$V2
names(X_test) <- feature$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
mergeData <- rbind(train, test)


# Identify the "mean()" or "std()"
meanstd <- grepl("mean\\(\\)", names(mergeData)) |
  grepl("std\\(\\)", names(mergeData))
meanstd[1:2] <- TRUE
mergeData <- mergeData[, meanstd]


# labels the data set with the activity names.  
mergeData$activity <- factor(mergeData$activity, labels=activities$V2)


# create the tidy data set
FinalMerge <- melt(mergeData, id=c("subjectID","activity"))
tidy <- dcast(FinalMerge, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.table(tidy, file = "./tidy.txt", row.name=FALSE)