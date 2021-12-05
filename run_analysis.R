# merge the training and the test sets to create one data set
X <- rbind(x_train, x_test)
Y <- rbind(y_train, y_test)
Subject <- rbind(
        subject_train, subject_test
)
Merged_Data <- cbind(
        Subject, Y, X
)

# extract only the measurements on the mean and standard deviation for each measurement
TidyData <- Merged_Data %>% select(
        subject, code, contains("mean"), contains("std")
)

# use desciptive activity names to name the activities in the data set
TidyData$code <- activities[TidyData$code, 2]

# label the data set with descriptive variable names
names(TidyData)[2] = "activity"
names(TidyData) <- gsub("Acc","Accelerometer", names(TidyData))
names(TidyData) <- gsub("Gyro","Gyroscope", names(TidyData))
names(TidyData) <- gsub("BodyBody", "Body", names(TidyData))
names(TidyData) <- gsub("Mag", "Magnitude", names(TidyData))
names(TidyData) <- gsub("^t", "Time", names(TidyData))
names(TidyData) <- gsub("^f", "Frequency", names(TidyData))
names(TidyData) <- gsub("tBody", "TimeBody", names(TidyData))
names(TidyData) <- gsub("-mean()","Mean", names(TidyData), ignore.case=TRUE)
names(TidyData) <- gsub("-std", "STD", names(TidyData), ignore.case=TRUE)
names(TidyData) <- gsub("-freq", "Frequency", names(TidyData), ignore.case=TRUE)
names(TidyData) <- gsub("angle", "Angle", names(TidyData))
names(TidyData) <- gsub("gravity", "Gravity", names(TidyData))

# create a second independent data set with the average of each varibale for each activity and each subject from step 4
FinalData <- TidyData %>%
        group_by(subject, activity) %>%
        summarise_all(list(mean=mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)

