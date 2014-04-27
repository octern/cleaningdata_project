# retrieved data on 4/28/2014 from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

#####
#as suggested in the forums, we shouldn't look at the raw data in "/Inertial Signals", 
#to translate the somewhat abstruse readme file:
#the test/ and train/ directories have the same structure. This is what they contain:
#X_train.txt: a data file with each of the measurements. Labels (which can be used as variable names)
#are found in features.txt
#y_train.txt: the activity being performed in each row. Labels are in activity_labels.txt
#subject_train.txt: the subject providing each row.
#####

# Put this file inside the "UCI HAR Dataset" directory and run with source("run_analysis.R", chdir=TRUE)
# OR, uncomment the line below and enter the absolute path to your copy of the files. 
# setwd("/Users/hibounce/psych/datasci/wearable_analysis/UCI HAR Dataset")

# ********* Q1: Merges the training and the test sets to create one data set

# First, read in the 3 train files and combine them into one data frame. 
# the X file is technically a fixed width file (each variable has the same number of decimal places, and the exponent is zero-padded). Note that positive numbers have two spaces before them, so reading it as a delimited file requires sep="" (generic whitespace), not sep=" ".
# the other two files only have one column each.

#Set this variable to only read n lines of data (for faster testing/debugging). Set to -1 to read the full file.
cnt=-1

testdata<-read.table("test/X_test.txt", nrows=cnt)
testids<-read.table("test/subject_test.txt", nrows=cnt)
testactivities<-read.table("test/y_test.txt", nrows=cnt)
test<-testdata
test$user.id <- testids$V1
test$activity<-testactivities$V1
test$src<-"test"

traindata<-read.table("train/X_train.txt", nrows=cnt)
trainids<-read.table("train/subject_train.txt", nrows=cnt)
trainactivities<-read.table("train/y_train.txt", nrows=cnt)
train<-traindata
train$user.id <- trainids$V1
train$activity<-trainactivities$V1
train$src<-"train"

# merge the files

wd<-rbind(test, train)

# read in the file with the variable labels, and turn it into a vector of names.

# Let's skip to Q4 because it's easier to do this before removing unwanted columns. 
# **********Q4: Appropriately labels the data set with descriptive activity names. 
# as far as I can tell this instruction is incoherent. 
# In https://class.coursera.org/getdata-002/forum/thread?thread_id=28#post-461, David Hood, a community TA,
# states that it should be read as "Appropriately labels the data set with descriptive variable or feature (column) names"

# get the list of column descriptions from features.txt and apply them to the relevant columns.
labels<-read.table("features.txt", colClasses="character")
varnames<-labels$V2
names(wd)<-c(varnames, "user.id", "activity", "src")



# ************ Q2: Extracts only the measurements on the mean and standard deviation for each measurement
# As many people have noted, this instruction is not all that clear.  
# I will take it to mean that we only want variables that include "mean()" or "std()". 

# construct the list of variables - all vars with mean() or std() plus the last 3 vars we added (id, activity, source)

library(stringr)
wanted.vars<-str_detect(varnames, "(mean[()])|(std[()])")
wanted.vars<-c(wanted.vars, c(T,T,T))
fd<-wd[wanted.vars]

# *********Q3: Uses descriptive activity names to name the activities in the data set
# we'll do this by turning the activity variable into a factor.

actlabels<-read.table("activity_labels.txt", stringsAsFactors=F)
fd$activity<-factor(fd$activity, labels=actlabels$V2)

# ********Q5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
# Interpreting this to mean we want one row per subject per activity, not just subject means and activity means.

# use aggregate to get the means for each combination of subject and activity:
# note that this will generate warnings about our two string/factor variables. This is okay. 
# activity is preserved in the new "Group.2" variable, and source is unnecessary since we've collapsed across test and training.

agg<-aggregate(fd, list(fd$user.id, fd$activity), mean)

# now remove the redundant variables from the end and relabel the variables that lost their descriptions.

agg<-agg[c(-69,-70,-71)]
colnames(agg)[1] = "user.id"
colnames(agg)[2] = "activity"

# and turn activity back into a factor. 

agg$activity<-factor(agg$activity, labels=actlabels$V2)

# finally, write the new data file.
write.csv(agg, file="aggregates.csv", row.names=F)

# uncomment the following line if you also want to write out the combined raw datasets:
# write.csv(fd, file="combined_raw.csv, row.names=F)
