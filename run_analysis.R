library(tidyverse)

# load training data from local storage
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# load test data from local storage
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

# join test and training data
x_total <- rbind(x_train, x_test)
y_total <- rbind(y_train, y_test)
subject_total <- rbind(subject_train, subject_test)

# load data description and activity labels
var_names <- read.table("./UCI HAR Dataset/features.txt")
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

# extracts means and standard deviations for each measurement
mean_sd <- var_names[grep("mean\\(\\)|std\\(\\)",var_names[,2]),]
x_total <- x_total[,mean_sd[,1]]

# add descriptive activity names 
colnames(y_total) <- "activity"
y_total$activity_labels <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activity_labels <- y_total[,-1]

# add descriptive variable names.
colnames(x_total) <- var_names[mean_sd[,1],2]

# create second dataset with averages
colnames(subject_total) <- "subject"
total <- cbind(x_total, activity_labels, subject_total)
total_mean <- total %>% group_by(activity_labels, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", 
            row.names = FALSE, col.names = TRUE)
