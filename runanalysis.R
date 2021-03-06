
fileURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

dataFilecom <- "./C:/Downloads/UCI HAR Dataset.zip"


dirFile <- "./UCI HAR Dataset"


tidyDataFile <- "./tidy-UCI-HAR-dataset.txt"

tidyDataFileAVGtxt <- "./tidy-UCI-HAR-dataset-AVG.txt"


if (file.exists(dataFilecom) == FALSE) 
{
  download.file(fileURL, destfile = dataFilecom)
}


if (file.exists(dirFile) == FALSE) 
{
  unzip(dataFilecom)
}


x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)


x <- rbind(x_train, X_test)
y <- rbind(y_train, y_test)
s <- rbind(subject_train, subject_test)


features <- read.table("./UCI HAR Dataset/features.txt")

names(features) <- c('feat_id', 'feat_name')

index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 
 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))


activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

tidyDataSet <- cbind(s, y, x)
p <- tidyDataSet[, 3:dim(tidyDataSet)[2]] 
tidyDataAVGSet <- aggregate(p,list(tidyDataSet$Subject, tidyDataSet$Activity), mean)

 
names(tidyDataAVGSet)[1] <- "Subject"
names(tidyDataAVGSet)[2] <- "Activity"



write.table(tidyDataSet, tidyDataFile)

write.table(tidyDataAVGSet, tidyDataFileAVGtxt)