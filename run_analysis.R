# cleaningdata
labels <- read.table(".\\UCI HAR Dataset\\features.txt")
test<-labels[,2]
testData <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
testSub <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
testLabel<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
colnames(testData)<- as.character(test)
colnames(testLabel) <- c("label")
colnames(testSub) <- c("subject")
testData$subject <-testSub$subject
testData$label <-testLabel$label
trainData <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
trainSub <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
trainLabel<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
colnames(trainData)<- as.character(test)
colnames(trainLabel) <- c("label")
colnames(trainSub) <- c("subject")
trainData$subject <-trainSub$subject
trainData$label <-trainLabel$label
merged<- rbind(testData,trainData)
matches <- grep("(mean\\(|std\\(|subject|label)", colnames(merged), ignore.case = TRUE )
merged <-merged[,c(matches)]
activityLabels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")
for (i in 1:nrow(merged))
{
  current <- merged$label[i]
  merged$label[i]<-as.character(activityLabels[current,2])
}
colnames(merged) <- gsub("-", ".", names(merged))
colnames(merged) <- gsub("^t", "Time", names(merged))
colnames(merged) <- gsub("^f", "Frequency", names(merged))
colnames(merged) <- gsub("label", "Activity", names(merged))
merged <- group_by(merged, subject, Activity)
summary <- summarise_each(merged, funs(mean))
print(summary)
