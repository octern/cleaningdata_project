##UCI Wearable Dataset
##For Tidy Data project

These files document the construction of a tidy dataset that summarizes the observations in the UCI wearable dataset.
Following is a description of the process for creating the tidy dataset. Note that these are high-level conceptual steps; for more precise details, see run_analysis.R and the comments throughout.

1. retrieve data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip (we downloaded it on Apr 27 2014).
2. create a single dataset for training and a single dataset for test, by merging the accelerometer readings with the subject and activity information.
3. combine the training and test datasets into a single dataset.
4. extract only the variables representing means or standard deviations (only those with "mean()" or "std()" in the name) computed on the raw accelerometer data. 
5. compute the mean of each variable for each combination of subject and activity. Thus the final dataset contains one row per subject per activity, and one column for each of the variables.

Variable names are taken from `features.txt`. For further information on what each variable represents, see `features_info.txt`, both part of the zip file available at the URL above.

If you wish to reprocess the original data, just download the zip file, extract it, and place run_analysis.R in the top-level directory. It must be invoked with `source("run_analysis.R", chdir=TRUE)`, or you can explicitly set the working directory using the instructions on line 14. The tidy data file will be written to a file named aggregates.csv in the same directory.

If you have any questions about this dataset, contact Michael at non@mcohn.net.
