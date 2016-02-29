# features has the meaningful column names that will replace 
# the V1-V561 column names of the training and test datasets.

features <- read.table("./UCI HAR Dataset/features.txt")

# activity_labels.txt:
# V1                 V2
#  1            WALKING
#  2   WALKING_UPSTAIRS
#  3 WALKING_DOWNSTAIRS
#  4            SITTING
#  5           STANDING
#  6             LAYING

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# I will read in and merge the datasets in the test and training folders.
# There are tables of subjects, measurements, and activities in each folder.

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
measurement_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
measurement_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

merged_subject <- rbind(subject_test,subject_train)
# the column name for the subject tables is just V1
colnames(merged_subject) <- "SUBJECT"

merged_measurement <- rbind(measurement_test,measurement_train)
# use the names from features.txt for the column names
colnames(merged_measurement) <- features[,2]

merged_activity <- rbind(activity_test,activity_train)
colnames(merged_activity) <- "ACTIVITY"
# this replaces the activity number with the activity name
merged_activity <- merge(merged_activity,activity_labels,by=1)[,2]

# merge all three into one dataset
merged_tables <- cbind(merged_subject,merged_activity,merged_measurement)
# assignment is to extract "only the measurements on the mean and standard
# deviation for each measurement".  The grep is based on the meaningful
# column names from features.txt that were assigned to merged_measurement.
mean_std_grep <- grep("-mean()|-std()",colnames(merged_tables))
mean_std_table <- merged_tables[,c(1,2,mean_std_grep)]

# the reshape2 package has functions for "melting" and then "casting"
# the melted data. From http://www.statmethods.net/management/reshape.html,
# "Basically, you 'melt' data so that each row is a unique id-variable
# combination.  Then you 'cast' the melted data into any shape you would like."
library(reshape2)
mean_std_melt <- melt(mean_std_table,id.vars=c("SUBJECT","merged_activity"))
mean_each <- dcast(mean_std_melt,SUBJECT + merged_activity ~ variable,mean)

write.table(mean_each,file="./UCI HAR Dataset/tidy_with_means.txt",row.names=FALSE)
mean_each





