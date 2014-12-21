  ##Check if data folder exits.  If not, downloand and extract the data
  if(!file.exists("./UCI HAR Dataset")){
    library(downloader)
    url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download(url, "dataset.zip", mode="wb")
    unzip("dataset.zip")
    unlink(url)
  }
  
  ##Names for the variable in the dataset 
  data_rownames <- read.table("./UCI HAR Dataset/features.txt")
  ##Activity lable
  data_activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
  
  ##Organize test dataset
  id_test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  colnames(id_test_subject) <- "subject_ID"
  
  activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  
  data_test <- read.table("./UCI HAR Dataset/test/x_test.txt")
  ##labels the data set with descriptive variable names 
  colnames(data_test) <- data_rownames[,2]
  
  data_test_combined <- cbind(id_test_subject,activity_test,data_test)
  
  ##Organize train dataset
  id_train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  
  ##labels the data set with descriptive variable names
  colnames(id_train_subject) <- "subject_ID"
  
  activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
  data_train <- read.table("./UCI HAR Dataset/train/x_train.txt")
  colnames(data_train) <- data_rownames[,2]
  
  data_train_combined <- cbind(id_train_subject,activity_train,data_train)
  
  ##Merge test and train datasets
  data_merged <- rbind(data_test_combined,data_train_combined)
  
  ##Create a logical vector to keep column containing "mean" and "std"
  column_keep <- grepl("mean",colnames(data_merged))|grepl("std",colnames(data_merged))
  
  ##Keep the first two columns: "subject_ID" and "V1"
  column_keep[1] <- TRUE
  column_keep[2] <- TRUE
  
  ##Create dataset containing only mean and std columns
  data_merged_cleaned <- data_merged[,column_keep]
  
  ##use decriptive names for the activity
  data_merged_cleaned_descr <- merge(data_activity, data_merged_cleaned,by.x="V1",by.y="V1",ALL=TRUE)
  colnames(data_merged_cleaned_descr)[2] <- "Activity"
  data_merged_cleaned_descr$V1 <- NULL
  
  ##Create tidy dataset 
  library(dplyr)
  tidy_data <- data_merged_cleaned_descr %.% group_by(Activity, subject_ID) %.% summarise_each(funs(mean))
  write.table(tidy_data,"tidy_data.txt",row.names=FALSE)