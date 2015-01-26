### Codebook for run_analysis.r
The run_analysis.r script uses the dataset found at the following web site:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
This script formats the above referenced dataset to be intuitive, tidy and easy to use
by doing the following:
	1. Merges the training and the test sets to create one data set.
	2. Extracts only the measurements on the mean and standard deviation for each measurement.
	3. Uses descriptive activity names to name the activities in the data set.
	4. Appropriately labels the data set with descriptive variable names.
	5. From the data set in step 4, creates a second, independent tidy data set with the
average of each variable for each activity and each subject.

### Source Data
The source data is structured in the following way:
- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

All of this data was transformed into a structured, tidy dataset with the following columns:
- SubjectId - the id of the subject of the tests. An integer number ranging from 1 to 30.
- ActivityLabel - The type of activity. Allowed values: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
- variable - the variable from the original dataset. Restricted to mean and standard deviation. 
- mean - the average value for the variable, summarised by SubjectId and ActivityLabel.
