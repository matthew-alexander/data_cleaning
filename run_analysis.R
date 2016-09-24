setwd("C:/Users/mda45/OneDrive/Programming/Statistical_Learning/Hopkins_DataScience/hopkinsdatascience_repo/data_cleaning/course_project")

# importing all the relevant data sets
features <- read.table("features.txt", header = FALSE)
activity_labels <- read.table("activity_labels.txt", header = FALSE)
subject_train <- read.table("./train/subject_train.txt", header = FALSE)
x_train <- read.table("./train/X_train.txt", header = FALSE)
y_train <- read.table("./train/y_train.txt", header = FALSE)

subject_test <- read.table("./test/subject_test.txt", header = FALSE)
x_test <- read.table("./test/X_test.txt", header = FALSE)
y_test <- read.table("./test/y_test.txt", header = FALSE)


#renaming the columns
colnames(x_train) <- features[,2]
colnames(x_test) <- features[,2]
colnames(y_train) <- "activity"
colnames(y_test) <- "activity"
colnames(subject_train) <- "subject"
colnames(subject_test) <- "subject"

# combining train and test sets
train <- cbind(subject_train, y_train, x_train)
test <- cbind(subject_test, y_test,x_test)

#Step 1: combining train and test sets
data <- rbind(train, test)

#Step 3: creating descriptive activity labels 
data$activity <- factor(data$activity, labels = activity_labels$V2)

#Step 2: extracting the measurements on the mean and standard deviation for each measurement
features_of_interest <- grep(".*mean.*|.*std.*|.*Mean.*|.*Std.*", features[,2])
data_small <- data[,features_of_interest+2] # this is some adjustment so that the proper indexing is made 
data <- cbind(data$subject, data$activity, data_small)
colnames(data)[1:2] <- c("subject", "activity")

# STEP 4: writing the final data set
write.csv(data, "data_tidy.csv", row.names = FALSE)

# STEP 5: creating the independent dataset, aggregated by mean
mean_aggregation = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)
mean_aggregation[,3:4] <- NULL # these are some meaningless columns that didnt aggregate well
write.csv(mean_aggregation, "data_tidy_means.csv", row.names = FALSE)

