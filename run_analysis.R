# libraries
library(reshape)
library(reshape2)

# load features and activities
features <- read.csv("features.txt",sep=" ",header=FALSE,col.names=c("feature_id","caption"))
activity_labels <- read.csv("activity_labels.txt",sep=" ",header=FALSE,col.names=c("activity_id","activity_descr"))

# load training data
trainSubject <- read.csv("train\\subject_train.txt",header=FALSE,col.names="subject_id")
trainActivity <- merge(read.csv("train\\y_train.txt",header=FALSE,col.names="activity_id"),activity_labels)
trainInfo <- cbind(trainSubject,trainActivity)
# this function run nicely on an 8Gb machine, if less memory available, use a smaller buffersize
trainSet <- read.fwf("train\\X_train.txt",widths=rep(16,561),buffersize=1000)
# add features to data set columnn names
names(trainSet) <- features$caption
# filter out mean and std information
smallTrainSet <- trainSet[,grep("-mean\\(\\)|-std\\(\\)",names(trainSet))]

# load test data
testSubject <- read.csv("test\\subject_test.txt",header=FALSE,col.names="subject_id")
testActivity <- merge(read.csv("test\\y_test.txt",header=FALSE,col.names="activity_id"),activity_labels)
testInfo <- cbind(testSubject,testActivity)
# this function run nicely on an 8Gb machine, if less memory available, use a smaller buffersize
testSet <- read.fwf("test\\X_test.txt",widths=rep(16,561),buffersize=1000)
# add features to data set columnn names
names(testSet) <- features$caption
# filter out mean and std information
smallTestSet <- testSet[,grep("-mean\\(\\)|-std\\(\\)",names(testSet))]

# combine data sets
fullInfo <- rbind(trainInfo,testInfo)
fullSet <- rbind(smallTrainSet,smallTestSet)
data <- cbind(fullInfo,fullSet)

# melt data to do analysis
tidyData <- melt(data,id=c("subject_id","activity_descr"),measure.vars=c(4:69))

# get means per subject and activity
tidyDataMeans <- dcast(tidyData, subject_id + activity_descr ~ variable,mean)

# export data
write.table(tidyDataMeans,"tidyDataMeans.txt",,row.names=FALSE)