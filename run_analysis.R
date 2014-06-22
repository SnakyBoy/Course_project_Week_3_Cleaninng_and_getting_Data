if(!file.exists("data")) { ## checking if the data directory exists if not - then creating it
        dir.create("data")
}

##downloading the dataset [START]

fileURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL,destfile="./data/dataset.zip")
##downloading the dataset [START]

unzip("./data/dataset.zip",exdir="./data") ##extracting the dataset from zipfile 

## merging the test and train data into one data frame (Step 1) [START] 

        testData<-read.table("./data/UCI HAR Dataset/test/X_test.txt") ##getting the test data into a data frame
        
        testSubjectId<-read.table("./data/UCI HAR Dataset/test/subject_test.txt") ##getting test subjectID
        testActivityId<-read.table("./data/UCI HAR Dataset/test/y_test.txt")##getting test activityID
        
        testData$subject<-as.vector(testSubjectId[,1]) ##appending test subjectId to the data frame)
        testData$activity<-as.vector(testActivityId[,1])##appending test activityId to the data frame
                
        
        trainData<-read.table("./data/UCI HAR Dataset/train/X_train.txt") ##getting the train data into a data frame
        trainSubjectId<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")##getting train subjectID
        trainActivityId<-read.table("./data/UCI HAR Dataset/train/y_train.txt")##getting train activityID
        
        
        trainData$subject<-as.vector(trainSubjectId[,1]) ##appending test subjectId to the data frame)
        trainData$activity<-as.vector(trainActivityId[,1])##appending test activityId to the data frame
       
        trainTestData=join(trainData,testData,type="full",match="all") #merging the testing and training data
        
        
## merging the test and train data into one data frame (Step 1) [END]
        
## extracting only the data that contains Mean and Std (Step 2) [START]
        featuresData<-read.table("./data/UCI HAR Dataset/features.txt") ##getting all the features names for creating variables' names
        subjectId<-data.frame(V1=562,V2="subject") ## creating a variables' name for subject ID
        activityId<-data.frame(V1=563,V2="activity") ## creating variables' name for activity ID
        
        
        featuresData<-rbind(featuresData,subjectId) ##appending subjectId to the data frame that contains the variables' names
        featuresData<-rbind(featuresData,activityId)##appending activityId to the data frame that contains the variables' names
        
        featuresData<-as.vector(featuresData[,2]) ##making a vector with variables' names
        ##cleaning all the special characters from varialbles' name list [Start]
        featuresData<-gsub("[[:punct:]]","_",featuresData1) 
        featuresData<-gsub("___","_",featuresData)
        featuresData<-gsub("__","_",featuresData)
        
        ##cleaning all the special characters from variables' name list [End]        
        
        ##assigning descriptive variables' names (step 4) [START]
        featuresData<-gsub("tB","avg_time_B",featuresData) 
        featuresData<-gsub("fB","avg_freq_B",featuresData)
        featuresData<-gsub("tG","avg_time_G",featuresData)
        featuresData<-gsub("fG","avg_freq_G",featuresData)
        ##assigning descriptive variables' names (step 4)  [END]
        
        colnames(trainTestData)<-featuresData
        
        colNumbers<-grep("Mean|mean|std|subject|activity",colnames(trainTestData)) ## extracting column numbers that contain mean or standard deviation (std)
        trainTestDataMeanStd<-trainTestData[,colNumbers]
## extracting only the data that contains mean and Std (Step 2) [END]
  
##assigining descriptive activity names to Activity (Step 3) [START]
        
        activityData<-read.table("./data/UCI HAR Dataset/activity_labels.txt") ## reading activities and its' ID into a data frame
       
        
        for (i in 1:nrow(activityData)) 
                {
                trainTestDataMeanStd$activity<-gsub(i,activityData[i,2],trainTestDataMeanStd$activity)
}
##assigining descriptive activity names to Activity (Step 3) [END]
        


trainTestDataAverages=unique(ddply(trainTestDataMeanStd, .(activity,subject), numcolwise(ave))) ##calculating the averages for each variable and collapsing it according to activity and subject

        write.table(trainTestDataAverages, file = "./data/UCI HAR Dataset/average_mean_std.txt") ## saving the output into a file 

