# Getting and Cleaning Data - Week 3 Project
This repository contains a single script, run_analysis.R. This function reads multiple text files from the UCI HAR Dataset, which can be found here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The text files that are needed from the dataset are:

* activity_labels.txt
* features.txt
* test/subject_test.txt
* test/X_test.txt
* test/y_test.txt
* train/subject_train.txt
* train/X_train.txt
* train/y_train.txt

The activity_labels.txt file contains a key converting the integers 1-6 into various activities (walking, sitting, standing, etc.) These integers can be found in the files y_test.txt and y_train.txt, where each row in the text file corresponds to one of those six activities. The subject_test.txt and subject_train.txt files have integers 1-30 corresponding to 30 different volunteers, who performed the six activities while wearing a smartphone on the waist. They kept track of what they were doing while the smartphone recorded accelerometer and gyroscope data. Each row in all of the files corresponds to a single measurement, where the row represents the measurement, the "y" file represents the code for the activity, the "subject" file represents the code for the volunteer, and the "X" file has all of the smartphone data.

run_analysis.R uses read.table to read in all of the above text files. Then rbind and cbind create a single data frame of all test and training measurements. The activity integers in the single data frame are replaced by descriptions of the action. The variables in the data frame are all named using the measurement descriptions in features.txt. Only variables which represent a mean or standard deviation for the accelerometer or gyroscope data are kept in the tidy data set. Finally, a second tidy data set is created by averaging all the smartphone recordings grouped by volunteer and activity. With 30 volunteers and 6 distinct activities, this creates a tidy data set with 180 rows.
