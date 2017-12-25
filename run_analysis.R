require(dplyr)
require(tidyr)
require(reshape2)

## Loading datasets
xtrain = read.table("data/X_train.txt")
xtest = read.table("data/X_test.txt")
ytrain = read.table("data/y_train.txt")
ytest = read.table("data/y_test.txt")
strain = read.table("data/subject_train.txt")
stest = read.table("data/subject_test.txt")
feature = read.table("data/features.txt")
activity = read.table("data/activity_labels.txt")

## Creating a feature list for merging & break it down into variables
feature <- separate(feature, V2, into=c("measurement","aggregation","axis"), sep="-")
feature <- filter(feature, aggregation== "mean()" | aggregation=="std()")
feature$aggregation <- sub("\\()","",feature$aggregation)
feature <- separate(feature, measurement, into=c("domain", "measurement"), sep="(?<=^[tf])")
feature$measurement <- sub("BodyBody", "Body", feature$measurement)
feature <- separate(feature, measurement, into=c("reference", "measurement"), sep="(?<=Gravity|Body)")
feature <- separate(feature, measurement, into=c("signal", "magnitude"), sep="(Mag)")
feature[!is.na(feature$magnitude), "axis"] <- "M"
feature <- subset(feature, select = -magnitude)
feature$V1 <- paste0('V', feature$V1)

## Rename the column names in y sets and the subject sets in avoid duplicate names in merge
colnames(ytrain) <- "activity"
colnames(ytest) <- "activity"
colnames(strain) <- "subject"
colnames(stest) <- "subject"

## Merging all datasets into 1 single set
mergedtrain <- cbind(xtrain,ytrain, strain)
mergedtest <- cbind(xtest,ytest, stest)
fullset <- rbind(mergedtrain, mergedtest)

## Remove temporary dataframe to reduce memory use
rm(xtrain, xtest, ytrain, ytest, strain, stest, mergedtrain, mergedtest)

## Select only the mean and standard deviation for each measurement
## as well as the activity and subject
resultset <- select(fullset, c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 
                               240:241, 253:254, 266:271, 345:350, 424:429, 503:504, 516:517, 
                               529:530, 542:543, 562:563))

resultmelt <- melt(resultset, id=c("activity", "subject"))

## Merging processed feature list with melt result table
result <- merge(resultmelt, feature, by.x = "variable", by.y = "V1")
result <- merge(result, activity, by.x = "activity", by.y = "V1")
result <- result[, c(10,3,5,6,7,8,9,4)]
colnames(result)[1] <- "activity"
result <- mutate_at(result, c(1,3,4,5,6,7), funs(tolower))

## Remove all temporary data frame to minimise memory use
rm(fullset, resultset, resultmelt, feature, activity)

## Create a second table computing the average of each variable for respective activity and subject
avgresult <- dcast(result, activity + subject ~ domain + reference + signal + aggregation + axis, mean)
