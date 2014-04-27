These variables are taken directly from the original data source (see `README.md` for details). 

The variables used in the dataset aggregates.csv are as follows:
* user.id: The ID of the user, taken from the files y_test / y_train
* activity: the activity being performed

Additionally, the dataframe containing the combined raw test and raw training data contains the variable:
* src: indicates whether the data came from the test dataset or the training dataset

Note that the combined raw dataframe is never written to disk; uncomment the line at the end of `run_analysis.R` if you wish to write it out and examine it.