## Codebook for Project Getting and Cleaning Data
========

### Overview

[Source](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) of the original data
         https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%4FUCI%20HAR%20Dataset.zip

## Process

The script `run_analysis.R` performs the following process to clean up the data
and create tiny data sets:

1. Merge the training and test sets to create one data set.

2. Reads `features.txt` and uses only the measurements on the mean and standard
   deviation for each measurement. 

3. Reads `activity_labels.txt` and applies human readable activity names to
   name the activities in the data set.

4. Labels the data set with descriptive names. (Names are converted to lower
   case; underscores and brackets are removed.)

5. Merges the features with activity labels and subject IDs. The result is
   `meanstd_extract`.

6. The average of each measurement for each activity and each subject is merged
   to a second data set. The result is saved as `tidy_data.txt`.
------------------------------

### Variables

- feature_names - table contents of `features.txt` which is name of the columns in data set
- activity_labels - table contents of `activity_labels`
- subject_train - table contents of `train/subject_train.txt`
- activity_train - table contents of `train/y_train.txt`
- feature_train - table contents of `X_train.txt` data values
- subject_test - table contents of `test/subject_test.txt`
- activity_test - table contents of `test/y_test.txt`
- feature_test - table contents of `test/X_test.txt
- subject - combined data of `subject_train`and `subject_test`
- activity - combined data of `activity_train`and `activity_test`
- features - combined data of `feature_train`and `feature_test`
- mergeData - combined data of `subject`,`activity`and `features`

### Output
#### tidy_data.txt

`tidy_data.txt`is a data.frame: 180 obs. of  88 variables
- The first column contains Subject IDs.
- The second column contains activity names.
- The averages for each of the 88 attributes are in column 3-88
