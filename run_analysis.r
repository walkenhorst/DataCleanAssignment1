#################################################################################################
##                                                                                             ##
## This script uses the dataset found at the following web site:                               ##
## http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones         ##
## This script formats the above referenced dataset to be intuitive, tidy and easy to use      ##
## by doing the following:                                                                     ##
## 1. Merges the training and the test sets to create one data set.                            ##
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.  ##
## 3. Uses descriptive activity names to name the activities in the data set.                  ##
## 4. Appropriately labels the data set with descriptive variable names.                       ##
## 5. From the data set in step 4, creates a second, independent tidy data set with the        ##
##    average of each variable for each activity and each subject.                             ##
##                                                                                             ##
#################################################################################################


#################################################################################################
##                                                                                             ##
## 1. Merge the training and the test sets to create one data set.                             ##
##                                                                                             ##
#################################################################################################
workingDir = "E:/Users/Jiz/Documents/Study/Coursera/Data Science Specialisation/3. Getting and Cleaning Data/Assignment 1"
setwd(workingDir)
dataDir = paste(workingDir, "UCI HAR Dataset", sep="/")
 # Reference Data file locations
featureLabelsFile = paste(dataDir, "features.txt", sep="/")
activityLabelsFile = paste(dataDir, "activity_labels.txt", sep="/")
 # Training file locations
subjectTrainFile = paste(dataDir, "train/subject_train.txt", sep="/")
activityTrainFile = paste(dataDir, "train/y_train.txt", sep="/")
measurementTrainFile = paste(dataDir, "train/X_train.txt", sep="/")
 # Testing file locations
subjectTestFile = paste(dataDir, "test/subject_test.txt", sep="/")
activityTestFile = paste(dataDir, "test/y_test.txt", sep="/")
measurementTestFile = paste(dataDir, "test/X_test.txt", sep="/")
 # Read datasets in to memory
subVarNames = c("SubjectId")
actVarNames = c("ActivityId")
actLabVarNames = c("ActivityId","ActivityLabel")
featVarNames = c("FeatureId","FeatureName")
 # Reference
featureLabelsData = read.table(featureLabelsFile, sep = " ", col.names=featVarNames)
activityLabelsData = read.table(activityLabelsFile, sep = " ", col.names=actLabVarNames)
 # Construct vector of column names for the measurement data
featureLabels = gsub("[\\(\\),-]", "_", featureLabelsData[,"FeatureName"])

 # Train
subjectTrainData = read.table(subjectTrainFile, sep = " ", col.names=subVarNames)
activityTrainData = read.table(activityTrainFile, sep = " ", col.names=actVarNames)
widths = rep(16, times=561)
#4. Appropriately labels the data set with descriptive variable names. 
measurementTrainData  = read.fwf(measurementTrainFile, header=FALSE, widths=widths, buffersize=1000, col.names=featureLabels)
# object.size(measurementTrainData)

 # Test
subjectTestData = read.table(subjectTestFile, sep = " ", col.names=subVarNames)
activityTestData = read.table(activityTestFile, sep = " ", col.names=actVarNames)
#4. Appropriately labels the data set with descriptive variable names. 
measurementTestData  = read.fwf(measurementTestFile, header=FALSE, widths=widths, buffersize=1000, col.names=featureLabels)

# merge into one data set
subjectData = rbind(subjectTrainData, subjectTestData)
activityData = rbind(activityTrainData, activityTestData)
measurementData = rbind(measurementTrainData, measurementTestData)
subjectMeasurementData = cbind(subjectData, activityData, measurementData)
#3. Uses descriptive activity names to name the activities in the data set
phoneSensorData = merge(x=activityLabelsData, y=subjectMeasurementData, by="ActivityId")

#################################################################################################
##                                                                                             ##
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.  ##
##                                                                                             ##
#################################################################################################
# look for the column names containing "mean" and "std"
colInd = c(grep("_mean__",featureLabels, fixed=F), grep("_std__",featureLabels, fixed=F))
phoneSensorDataMeanStd = phoneSensorData[,c(1:3, colInd+3)]

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# install.packages("reshape2")
# install.packages("plyr")
library(reshape2)
library(plyr)
phoneSensorDataMelt = melt(phoneSensorDataMeanStd, id=c("SubjectId","ActivityLabel"),measure.vars=featureLabels[colInd])
phoneSensorDataFinal = ddply(phoneSensorDataMelt, .(SubjectId,ActivityLabel, variable), summarise, mean=mean(value))

# 6. Write the data to file
destFile = "tidyPhoneSensorData.txt"
write.table(phoneSensorDataFinal, destFile, row.name=FALSE, sep="\t")
