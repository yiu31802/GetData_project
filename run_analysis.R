library(plyr)
library(reshape2)

# 0. Read files from local pathes, and add corresponding row names
trainpath <- "./train/X_train.txt"
trainlabelpath <- "./train/y_train.txt"
trainsubjectpath <- "./train/subject_train.txt"
testpath <- "./test/X_test.txt"
testlabelpath <- "./test/y_test.txt"
testsubjectpath <- "./test/subject_test.txt"
featurespath <- "./features.txt"
activitypath <- "./activity_labels.txt"

trainval <- read.table(file=trainpath, header=FALSE, nrows=8000,
                                            colClasses="numeric", )
trainlabel <- read.table(file=trainlabelpath, header=FALSE, nrows=8000,
                         colClasses="factor", col.names=c("label"))
trainsubject <- read.table(file=trainsubjectpath, header=FALSE, nrows=8000,
                           colClasses="factor", col.names=c("subject"))
traindata <- cbind(trainlabel, trainsubject, trainval)

testval <- read.table(file=testpath, header=FALSE, nrows=8000,
                                            colClasses="numeric")
testlabel <- read.table(file=testlabelpath, header=FALSE, nrows=8000,
                         colClasses="factor", col.names=c("label"))
testsubject <- read.table(file=testsubjectpath, header=FALSE, nrows=8000,
                           colClasses="factor", col.names=c("subject"))
testdata <- cbind(testlabel, testsubject, testval)
features <- read.table(file=featurespath, header=FALSE, nrows=600,
                                           colClasses="character")

activitylabels <- read.table(file=activitypath, header=FALSE, nrows=6,
                                           colClasses="character")

# 1. Merges the training and the test sets to create one data set.
merged <- rbind(traindata, testdata)
names(merged) <- c("label", "subject", features[,2])
# Insert a subject column in all records
# 2. Extracts only the measurements on the mean and standard deviation
#    for each measurement.
filtering <- c(1, 2, grep("std|mean", names(merged))) # Keep the first 2 columns
extracted <- merged[,filtering]

# 3. Uses descriptive activity names to name the activities in the data set
extracted[, 1] <- factor(extracted[, 1], label=activitylabels[1:6,2])

# 4. Appropriately labels the data set with descriptive variable names.
# 4.1 Remove redundancy "BodyBody"
names(extracted) <- gsub(x=names(extracted), pattern="BodyBody",
                         replacement="Body")
# 4.2 Remove 't' at the beggining
names(extracted) <- gsub(x=names(extracted), pattern="^t", replacement="")
# 4.3 Replace 'f' with 'FFT'
names(extracted) <- gsub(x=names(extracted), pattern="^f", replacement="FFT")
# 4.4 Replace 'Acc' with 'Acceleration'
names(extracted) <- gsub(x=names(extracted), pattern="Acc",
                         replacement="Acceleration")
# 4.5 Replace 'Mag' with 'Magnitude'
names(extracted) <- gsub(x=names(extracted), pattern="Mag",
                         replacement="Magnitude")
# 4.6 Remove (), -
names(extracted) <- gsub(x=names(extracted), pattern="\\(\\)", replacement="")
names(extracted) <- gsub(x=names(extracted), pattern="-", replacement="")
# 4.7 Replace 'mean' with 'Mean', 'std' with 'Std'
names(extracted) <- gsub(x=names(extracted), pattern="mean", replacement="Mean")
names(extracted) <- gsub(x=names(extracted), pattern="std", replacement="Std")

# 5. Creates a second, independent tidy data set with the average of each
#    variable for each activity and each subject.
melted <- melt(data=extracted, id=c("label", "subject"))
casted <- dcast(melted, subject + label ~ variable, fun.aggregate=mean)
casted[,1] <- factor(casted[,1], levels=1:30) # To re-define the factor levels
arranged <- arrange(casted, casted$subject) # And order the dataset

# Finally write the table output
write.table(x=arranged, file="dataset.txt", row.name=FALSE)
