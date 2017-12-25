# Cookbook

This cookbook defines the different variables and the data processing and 
transformation methodology

## File Structure
Input
- data: File folder containing all the input files
- X_train.txt: Training data set with 561 feature variables and 7352 observations
- y_train.txt: Training data set with 1 activity label and 7352 observations 
- subject_train.txt: Training data set with 1 subject label and 7352 observations
- X_test.txt: Test data set with 561 feature variables and 2947 observations
- y_test.txt: Test data set with 1 activity label and 2947 observations
- subject_test.txt: Test data set with 1 subject label and 2947 observations
- features.txt: Feature data set listing the corresponding 561 features
- activity_labels.txt: Data set listing the corresponding labels for 6 activity categories
- run_analysis.R: The entire data processing code written in R
- README.md: A brief description of the project and instruction for reproducing the result
- CodeBook.md: An user guide on the data structure/labels and the data transformation methodology

## Data Loading
The input files are loaded as dataframes with the following names (preserving the data structure as the input)
- xtrain <- Loaded from X_train.txt
- ytrain <- Loaded from y_train.txt
- strain <- Loaded from subject_train.txt
- xtest <- Loaded from X_test.txt
- ytest <- Loaded from y_test.txt
- stest <- Loaded from subject_test.txt
- feature <- Loaded from feature.txt
- activity <- Loaded from activity.txt

## Data Processing & Transformation
The first stage is to transform the "feature" dataframe. The following transformations are performed to produce the final dataframe.
1. Separate the feature description (Column: V2) into 3 columns ("measurement", "aggregation" & "axis") with a separator of "-".
2. Filter dataframe by aggregation with only "mean()" and "std()".
3. Remove the bracket ("()") in the filtered dataframe aggregation column.
4. Separate the measurement column from step 3 into 2 columns ("domain" & "measurment") by regex separator starting with either "t" or "f".
5. Replace the typo phrase of "BodyBody" as "Body" in the measurement column.
6. Separate the measurement column from step 5 into 2 columns ("reference" & "measurement") by regex separator of either "Gravity" or "Body".
7. Separate the measurment column from step 6 into 2 columns ("signal" & "magnitude") by a regex separator of "Mag".
8. Amend the "axis" column of the feature dataframe with an alphabet "M" for all rows in the magnitude column that are not "NA" (i.e. rows with "Mag" in step 6).
9. Remove the "magnitude" column from the feature dataframe since it is no longer required.
10. Convert the first column (i.e. V1) of the feature dataframe by adding a prefix of "V" to the number (e.g. "5" to "V5").

The second stage is to transform all the remaining input dataframe to the final dataframe requested in this exercise instruction sheet.
1. Convert the first (and only) column name in both ytrain & ytest dataframe to "activity"
2. Convert the first (and only) column name in both strain & stest dataframe to "subject"
3. Merging all training data (xtrain, ytrain, strain) and testing data (xtest, ytest, stest) column wise using cbind()
4. Merging both the merged training and test set in step 3 to one single dataframe ("fullset") row-wise using rbind()
5. Filter dataframe ("fullset") with columns only corresponding to mean & std in the feature dataframe.
6. Reshape the dataframe by activity and subject to create a narrow long dataframe using melt() function.
7. Merge the melt dataframe from step 6 with the feature dataframe.
8. Filtered only required column and rearrange order for the final dataframe ("result")
9. Convert all character columns to lower case.

The third stage is to create a derived dataframe displaying the average of each variable for the respective activity and subject pair.
1. The dataframe is created by using dcast() function on the "result" dataframe.

Removal of any temporary dataframe that is not required as output to minimize memory usage as listed below. (For reproduction, please uncheck the corresponding line.)
- xtrain
- ytrain
- strain
- xtest
- ytest
- stest
- feature
- activity
- mergedtrain
- mergedtest
- fullset
- resultset
- resultmelt

## Variables in Final DataFrames

**DataFrame 1: "result"**

| Column Name   | Description                                                       |
|---------------|-------------------------------------------------------------------|
| activity      | Activity labels (Total: 6 unique categories)                      |
| subject       | Subject id (Total: 30 unique categories)                          |
| domain        | Type of measurement frame: t denotes time/ f denotes frequency    |
| reference     | Point of reference for measurement: body / gravity                |
| signal        | Type of measurement signal (Total: 4 unique categories)<br/> acc: accelerometer<br/> gyro: gyroscope<br/> accjerk: jerk signal from accelerometer<br/> gyrojerk: jerk signal from gyroscope                              |
| aggregation   | Type of aggregation performed: mean / standard deviation (std)    |
| axis          | Axial direction: X, Y, Z or M.<br/> M denotes calculated magnitude measurement using Euclidean norm   |

**DataFrame 2: "avgresult"**

| Column Name         | Description                                                                           |
|---------------------|---------------------------------------------------------------------------------------|
| activity            | Activity labels (Total: 6 unique categories)                                          |
| subject             | Subject id (Total: 30 unique categories)                                              |
| f_body_acc_mean_x\*  | Average value of the measured accelerometer signal mean with reference to the body in the x direction.<br/> \*The subsequent 65 columns are the average value named similarly to f_body_acc_mean_x<br/> (ie. domain_reference_signal_aggregation_axis)                                |

## System Used
R Version (3.4.2)
Linux 64-bit