
## Peer graded assignment - Getting & Cleaning data - course project

  library("dplyr")       

  setwd("C:/Users/LotteDerks/OneDrive - LevelUp Group/Documents/R cursus/Getting&Cleaning data")

  ## Download & read data tables

  FileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(FileUrl, destfile = "./SmartphoneData.zip", mode = "wb")
  unzip("./SmartphoneData.zip")

    ## read test data 
    testSet             <- read.table(file.path("UCI HAR Dataset", "test", "X_test.txt"))
    testActivityID      <- read.table(file.path("UCI HAR Dataset", "test", "Y_test.txt")) 
    testSubjectID       <- read.table(file.path("UCI HAR Dataset", "test", "subject_test.txt"))

    ## read train data 
    trainingSet         <- read.table(file.path("UCI HAR Dataset", "train", "X_train.txt"))
    trainingActivityID  <- read.table(file.path("UCI HAR Dataset", "train", "Y_train.txt")) 
    trainingSubjectID   <- read.table(file.path("UCI HAR Dataset", "train", "subject_train.txt"))
    
    ## read features list 
    featuresName        <- read.table(file.path("UCI HAR Dataset", "features.txt")) 
    
    ## read activity labels 
    activityLabels      <- read.table(file.path("UCI HAR Dataset", "activity_labels.txt")) 

    
  ## Merge test & training data tables, based on rows
    
  totalSet          <- rbind(testSet, trainingSet)
  totalActivityID   <- rbind(testActivityID, trainingActivityID)
  totalSubjectID    <- rbind(testSubjectID, trainingSubjectID)
  
  ## add the column names to 'totalSet' data table 
  
  colnames(totalSet)          <- featuresName[, 2]
  
  ## Extract only the columns with measurements on the mean and standard deviation
  
  totalSet <- totalSet %>% select(contains("mean") | contains("std"))
  
  ## Add column names to the other data tables
  
  colnames(totalActivityID)   <- "activity"
  colnames(totalSubjectID)    <- "subject"
  
  
  ## merge the total data tables into one single data table, based on columns
  
  mergedDataTables <- cbind(totalSubjectID, totalActivityID, totalSet)
  
  ## Use descriptive activity names to name the activities in the data set
  
  mergedDataTables$activity <- factor(mergedDataTables$activity, levels = activityLabels[, 1], labels = activityLabels[, 2])
  mergedDataTables$subject <- as.factor(mergedDataTables$subject)
  
  ## Create a new data set with the average of each variable for each activity and each subject.
  
  tidyData <- mergedDataTables %>% group_by(subject, activity) %>% summarise_all(list(mean))
  
  write.table(tidyData, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE) 
  
