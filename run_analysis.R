## Read the Test Data
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
## Read the Train Data
X_train <- read.table("UCI\ HAR\ Dataset/train/X_train.txt",header =FALSE)
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
## Reading feature and activity_labels
features <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
##1. Merges the training and the test sets to create one data set
## Merging X data and naming variables
X_bind <- rbind(X_test, X_train)
colnames(X_bind) <- features[,2]
## Merging Y data and naming variable
Y_bind <- rbind(Y_test, Y_train)
colnames(Y_bind) <- "activity"
## Merging subject data and naming variable
subject_bind <- rbind(subject_test, subject_train)
colnames(subject_bind) <- "subject"
# Merging all data using c bind
final_merged_data <- cbind(Y_bind, subject_bind, X_bind) 
##2. Extracts only the measurements on the mean and standard deviation for each measurement
MeanStd_col <- grep("mean\\(\\)|std\\(\\)", names(final_merged_data))
final_merged_data <- final_merged_data[,c(MeanStd_col, 1, 2)]
##3. Uses descriptive activity names to name the activities in the data set
final_merged_data$activity <- activity_labels[final_merged_data$activity, 2]
##4. Appropriately labels the data set with descriptive variable names
# t to Time
# Acc to Acceleration
# Gyro to Gyroscope
# f to Frequency
# Mag to Magnitude
# BodyBody to Body
# tBody to TimeBody
names(final_merged_data) <- gsub("^t", "Time", names(final_merged_data))
names(final_merged_data) <- gsub("Acc", "Acceleration", names(final_merged_data))
names(final_merged_data) <- gsub("^Gyro", "Groscope", names(final_merged_data))
names(final_merged_data) <- gsub("^f", "Frequency", names(final_merged_data))
names(final_merged_data) <- gsub("Mag", "Magnitude", names(final_merged_data))
names(final_merged_data) <- gsub("tBody", "TimeBody", names(final_merged_data))

##5. independent tidy data set with the average of each variable for each activity and each subject
tidydata <- final_merged_data %>% 
  group_by(activity, subject) %>% 
  summarise_all(funs(mean))
write.table(tidydata, "./tidydata.txt", row.names = FALSE, quote = FALSE)
