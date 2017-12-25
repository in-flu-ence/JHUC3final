# Getting and Cleaning Data Course Project Final Assignment - Dec, 2017
**Purpose** To collect, work with, and clean the given dataset into a tidy data format for future analysis.

## Input Data
The input data set is based on the Human Activity Recognition Using Smartphones Data set. This data set can be downloaded from the instructments

The description of the relevant files can be found in the README.txt within the dataset zip file.

In this exercise, the following files will be used.
- X_train.txt
- y_train.txt
- subject_train.txt
- X_text.txt
- y_text.txt
- subject_test.txt
- feature.txt
- activity_lables.txt

## Data Processing
The required data are pre-processed, cleaned and transformed to the required format. Details are discussed in CodeBook.md.

The following steps are conducted in a nutshell:
- Data Loading
- Data Cleaning & Transformation
- Data Filtering
- Data Merging
- Final Data Transformation to Required Format

## Executable Code
The following file is delivered for reproduction and reference.
- run_analysis.R (The entire code on all the data processing steps described in CodeBook.md)

## Final Data
The following dataframes are created from the executable code
- result (This is the tidy data table showing the corresponding value for a specific activity and subject with respect to a measurement)
- avgresult (This is the derived table showing the average value of each activity and subject part on the different measurements)

## Reference
- Hadley Wickham (2014), Tidy Data, Journal of Statistical Software.
