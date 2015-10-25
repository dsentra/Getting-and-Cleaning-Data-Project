library(reshape2)


# 1. Merge the training and the test sets to create one data set

# read data into data frames
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
featureNames <- read.table("./UCI HAR Dataset/features.txt")

names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

# combine files into one dataset
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)


# 2.Extracts the mean and standard deviation for each measurement.


# Identify the "mean()" or "std()"
meanstdcols <- grepl("mean\\(\\)", names(combined)) |
  grepl("std\\(\\)", names(combined))

meanstdcols[1:2] <- TRUE
combined <- combined[, meanstdcols]



# 3. Uses descriptive activity names to name the activities in the data set.
# 4. Appropriately labels the data set with descriptive activity names.  

# convert the activity column from integer to factor
combined$activity <- factor(combined$activity, labels=c("Walking",
                                                        "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))


# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.

# create the tidy data set
combinedata <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(combinedata, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.table(tidy, file = "./tidy.txt")