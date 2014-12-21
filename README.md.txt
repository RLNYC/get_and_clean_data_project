The dataset is  data collected from the accelerometers from the Samsung Galaxy S smartphone.

These codes performs the following:
    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


-----------Comments are made for the codes------------------------------------------------------

  ##Check if dataset exits.  If not, downloand and extract the data##
  	library(downloader)
  	url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  	download(url, "dataset.zip", mode="wb")
  	unzip("dataset.zip")
  	unlink(url)
  
  ##Names for the variable in the dataset## 
  	data_rownames <- read.table("./UCI HAR Dataset/features.txt")

  ##Activity lable
  	data_activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
  
  ##Organize subject ID for test dataset
  	id_test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
  	colnames(id_test_subject) <- "subject_ID"
  
  ##Create activity code for test dataset	
  	activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  
  ##Pull in the raw test dataset
  	data_test <- read.table("./UCI HAR Dataset/test/x_test.txt")

  ##labels the data set with descriptive variable names 
  	colnames(data_test) <- data_rownames[,2]
  
  ##Combining test dataset with subject ID and activity code
  	data_test_combined <- cbind(id_test_subject,activity_test,data_test)
  
  ##Organize subject ID for train dataset
  	id_train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
  
  ##labels the data set with descriptive variable names
  	colnames(id_train_subject) <- "subject_ID"

  ##Create activity code for train dataset
  	activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

  ##Pull in the raw train dataset
	data_train <- read.table("./UCI HAR Dataset/train/x_train.txt")

  ##labels the train dataset with descriptive variable names 
  	colnames(data_train) <- data_rownames[,2]
  
  ##Combining test dataset with subject ID and activity code
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
