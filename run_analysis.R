run_analysis <- function(){
    
    ##  This function reads and combines multiple text files into tidy data sets,
    ##  satisfying the following steps (which are not performed sequentially)
    
    ## STEP 1:  Merges the training and the test sets to create one data set.
    ## STEP 2:  Extracts only the measurements on the mean and standard deviation for each measurement. 
    ## STEP 3:  Uses descriptive activity names to name the activities in the data set
    ## STEP 4:  Appropriately labels the data set with descriptive variable names. 
    ## STEP 5:  From the data set in step 4, creates a second, independent tidy data set
    ##          with the average of each variable for each activity and each subject.
    
    ##  base_path describes where the directory "UCI HAR Dataset" is located
    base_path <- "/Users/nick/Documents/Data Science/JHU-data-sci/UCI HAR Dataset"
    ##  NOTE: if the directory UCI HAR dataset is already in your working directory,
    ##  please set the above line to be:
    ## base_path <- "UCI HAR Dataset"
    
    
    ##  Load "features.txt", which has the list of all variable names in the second column
    features <- read.table(paste(base_path, "features.txt",sep = "/"),
                           col.names = c("index","var_names"))
    
    ##  Certain characters should not be in variable names in R,
    ##  including "("  ")"  "," and "-"
    ##  This line of code removes those characters from the feature variable names
    features$var_names <- gsub('\\(|\\)|-|,', '', features$var_names)
    
    ##  Read the activity labels so that the indices 1-6 in y_test and y_train
    ##  can be associated with the correct activity
    activity_labels <- read.table(paste(base_path,"activity_labels.txt",sep = "/"),
                                  col.names = c("levels","labels"))

    ##  Read the subject numbers and bind them together vertically
    subject_test <- read.table(paste(base_path,"test/subject_test.txt",sep="/"),
                               col.names = "subject")
    subject_train <- read.table(paste(base_path,"train/subject_train.txt",sep="/"),
                               col.names = "subject")
    subject <- rbind(subject_test,subject_train)
    
    ##  Read the activity labels from y_test and y_train
    ##  and bind them together vertically using rbind
    y_test <- read.table(paste(base_path, "test/y_test.txt",sep = "/"),
                         col.names = "activity")
    y_train <- read.table(paste(base_path, "train/y_train.txt",sep = "/"),
                          col.names = "activity")
    y <- rbind(y_test,y_train)
    
    ## Use the descriptive activity names from activity_labels to turn
    ## the less descriptive 1-6 in y$activity into the more descriptive
    ## WALKING, WALKING_UPSTAIRS, etc. (satisfying STEP 3)
    y$activity <- factor(y$activity,
                         levels = activity_labels$levels,
                         labels = activity_labels$labels)
    
    ##  Now that we have the column names, we can read the data from X_test and X_train
    ##  and label the columns appropriately using features.txt
    ##  By naming the columns (using col.names) with the descriptions from features.txt
    ##  the variables all have been appropriately labeled (satisfying STEP 4)
    X_test <- read.table(paste(base_path, "test/X_test.txt",sep = "/"),
                         col.names = features$var_names)
    X_train <- read.table(paste(base_path, "train/X_train.txt",sep = "/"),
                          col.names = features$var_names)
    
    ## Bind X_test and X_train vertically using rbind.
    X <- rbind(X_test,X_train)
    ## Note that it's important to bind X_test and X_train in the same order as we did
    ## for y_test and y_train, since we will next be binding these horizontally.
    ## This way, each row will corresponds to a single measurement.

    ## Merge subject, y and X using cbind to make a single data set (satisfying STEP 1)
    activity_data <- cbind(subject,y,X)
    
    ## Now, we need to select only variables associated with the mean and standard deviations
    ## To do this efficiently, we can use the dplyr library
    library(dplyr)
    
    ## We need to load the data into a data frame tbl
    activity_tbl <- tbl_df(activity_data)
    
    ## To avoid confusion, we can remove the original data frame from the workspace
    rm("activity_data")
    
    ## For our tidy data set, we will keep only the mean and standard deviation for each measurement
    ## In "features_info.txt", these quantities are described as having variable names containing
    ## "mean" and "std", respectively. We will select only these columns to satisfy STEP 2
    ## (along with the subject index and the activity names!)
    activity_tbl <- select(activity_tbl, subject, activity, contains("mean"), contains("std"))
    
    ## At this point in the code, activity_tbl satisfies STEPS 1-4
    ## Now, we need a second tidy data set with the average of each variable
    ## for each activity and for each test subject. We will use some dplyr commands!
    ## First, we group by subject and activity, then we summarise_each using mean
    ## (Be careful of the British spelling for summarise!)
    
    activity_summary <- activity_tbl %>%
        group_by(subject,activity) %>%
        summarise_each(funs(mean))
    
    ## activity_summary thus satisfies STEP 5, completing the assignment
    ## so this function writes a text file of the activity summary
    write.table(activity_summary,file = "activity_summary.txt",row.names = FALSE)
    
    ## the output for this function is the data table activity_summary
    activity_summary
}