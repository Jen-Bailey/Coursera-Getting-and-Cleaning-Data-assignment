###NOTE: working directory was set, however, this step is omitted from the script
##to avoid disclosing personal identifying information

### load necessary packages
library(dplyr)
library(tidyr)
library(stringr)


###Task 1: combine test and training sets into one data set

##Step 1: read each dataset into R and View to see what they look like
# test data
testSubject <- read.table("test/subject_test.txt")
testData <- read.table("test/X_test.txt")
testNumber <- read.table("test/Y_test.txt")

View(testSubject)
View(testData)
View(testNumber)

#training data
trainSubject <- read.table("train/subject_train.txt")
trainData <- read.table("train/X_train.txt")
trainNumber <- read.table("train/Y_train.txt")

View(trainSubject)
View(trainData)
View(trainNumber)

#meta data
features <- read.table("features.txt", stringsAsFactors = FALSE)
features <- gsub("\\-", "", features[,2])
activityLabels = read.table("activity_labels.txt")

View(features)
View(activityLabels)

##Step 2: Add labels to datasets 
#test data
testSubject <- rename(testSubject, ID = V1)
testNumber <- rename(testNumber, testtype = V1)
colnames(testData) <- features[,2] 

#train data
trainSubject <- rename(trainSubject, ID = V1)
trainNumber <- rename(trainNumber, testtype = V1)
colnames(trainData) <- features[,2] 

#meta data
colnames(activityLabels) <- c('testtype','testlabel')

##Step 3: combine the three test datasets and the three training datasets

#NOTE: I did not find any concrete indication in the documentation that
#came with the data that the rows in the X, Y, and subject files are all 
#appropriately sorted - I am proceding on the assumption that they are, since
#each file has the same number of rows.

testComplete <- cbind(testSubject, testNumber, testData)
trainComplete <- cbind(trainSubject, trainNumber, trainData)
View(testComplete)
View(trainComplete)

##Step 4: merge test and training data
completeData <- rbind(testComplete, trainComplete)
dim(completeData)


###Task 2: extract only the measurements on the mean and std dev for each measurement

meanStdData <- completeData[ ,grepl( "ID|testtype|mean|std" , names(completeData))]
View(meanStdData)


###Task 3: use descriptive activity names to name activities in dataset
meanStdData <- merge(meanStdData, activityLabels, by = "testtype", all = TRUE)

###Task 4: appropriately label dataset w/ descriptive variable labels
##NOTE: dataset already has descriptive labels - this was done under Task 1

###Task 5: save out tidy dataset w/ average of each variable for each activity and each subject
#NOTE function ddply below requires plyr package. plyr is not loaded until now, because
#it masks several functions from dplyr used above. If you do not have the plyr package installed,
#you can install it by removing the "#" from the beginning of #install.packages("plyr").

#install.packages(“plyr”)
library(plyr)
tidyData <-  ddply(meanStdData, .(testlabel, ID), numcolwise(mean))
View(tidyData)

#write data to text file
write.table(tidyData, "tidy_data.txt", row.name=FALSE)
