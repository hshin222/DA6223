This assignment is to prepare a tidy data set that can be used for later analysis.  
The data set contains data collected from the accelerometers from the Samsung Galaxy S smartphone. 
Source of the data: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

SAS was used for creating this tidy data set.  

1. Set the libname "da" to my homework directory, "c:/da6223/HW4"
2. Import text files into SAS./
	- All text data files were read into SAS using the Data steps and INFILE statement. 
	- The INPUT Statement had to be set additional field in order to get the last variable, var561, of the x_train.txt (7,352 records) and
	  x_test.txt (2,947 records) files in a proper format. By specifying the END= option as var562, this last variable specified was not 
	  written to the data set.
	
3. Incorporate the variable names available in features.txt in the data sets
	- Of 561 variables, only the 66 variables containing mean() and std() were extracted. 
	- Replaced the special characters "()" to "" and "-" to "_" using the TRANWRD function
	  and removed any extra space in the feature names using the COMPRESS function.
	- Added the new variable, dataset, to indicate "TRAIN" or "TEST" data. 
	- Used two macros (&keep_list, &rename_list) to store variable names, rename the generic variable names
	  to the appropriate features.
4. Merge 3 files to create a complete TRAIN data set: subjectID, x_train, and y_train.
5. Repeat the steps 2-4 to create a complete TEST data set. 
6. Combine the TRAIN and TEST data sets using the APPEND procedure.

7. Remove the dataset field.
8. Sort the data set by subjectID and then actlabnumb (Activity Label Number).
9. Get the mean of each variable by subjectID and aclabelnum and then save the result using PROC MEAN. 
	Note that a macro, &aggr_list, was created and used to specify all 66 variables.
10. Add the activity labels for the actlabnum fields: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, and LAYING.
11. To prepare for a data dictionary, use PROC CONTENT of the data file and keep "name" (field name) and "varnum" (position of each field).
12. Sort the resulting file by varnum using linguistic collation as the varnum field is a character field but we wanted to sort it as a numeric field. 
13. Create a data dictionary similar to the str() function in R from SAS DICTIONARY table.  
14. Export the data dictionary 
15. Export the tidy data set as a tab-delimited text file. 
 

The Data Dictionary of the text file exported. 


varnum	name	type	length
1	activitylabel	char	20
2	subjectID	num	8
3	actlabelnum	num	8
4	tBodyAcc_mean_X	num	8
5	tBodyAcc_mean_Y	num	8
6	tBodyAcc_mean_Z	num	8
7	tBodyAcc_std_X	num	8
8	tBodyAcc_std_Y	num	8
9	tBodyAcc_std_Z	num	8
10	tGravityAcc_mean_X	num	8
11	tGravityAcc_mean_Y	num	8
12	tGravityAcc_mean_Z	num	8
13	tGravityAcc_std_X	num	8
14	tGravityAcc_std_Y	num	8
15	tGravityAcc_std_Z	num	8
16	tBodyAccJerk_mean_X	num	8
17	tBodyAccJerk_mean_Y	num	8
18	tBodyAccJerk_mean_Z	num	8
19	tBodyAccJerk_std_X	num	8
20	tBodyAccJerk_std_Y	num	8
21	tBodyAccJerk_std_Z	num	8
22	tBodyGyro_mean_X	num	8
23	tBodyGyro_mean_Y	num	8
24	tBodyGyro_mean_Z	num	8
25	tBodyGyro_std_X	num	8
26	tBodyGyro_std_Y	num	8
27	tBodyGyro_std_Z	num	8
28	tBodyGyroJerk_mean_X	num	8
29	tBodyGyroJerk_mean_Y	num	8
30	tBodyGyroJerk_mean_Z	num	8
31	tBodyGyroJerk_std_X	num	8
32	tBodyGyroJerk_std_Y	num	8
33	tBodyGyroJerk_std_Z	num	8
34	tBodyAccMag_mean	num	8
35	tBodyAccMag_std	num	8
36	tGravityAccMag_mean	num	8
37	tGravityAccMag_std	num	8
38	tBodyAccJerkMag_mean	num	8
39	tBodyAccJerkMag_std	num	8
40	tBodyGyroMag_mean	num	8
41	tBodyGyroMag_std	num	8
42	tBodyGyroJerkMag_mean	num	8
43	tBodyGyroJerkMag_std	num	8
44	fBodyAcc_mean_X	num	8
45	fBodyAcc_mean_Y	num	8
46	fBodyAcc_mean_Z	num	8
47	fBodyAcc_std_X	num	8
48	fBodyAcc_std_Y	num	8
49	fBodyAcc_std_Z	num	8
50	fBodyAccJerk_mean_X	num	8
51	fBodyAccJerk_mean_Y	num	8
52	fBodyAccJerk_mean_Z	num	8
53	fBodyAccJerk_std_X	num	8
54	fBodyAccJerk_std_Y	num	8
55	fBodyAccJerk_std_Z	num	8
56	fBodyGyro_mean_X	num	8
57	fBodyGyro_mean_Y	num	8
58	fBodyGyro_mean_Z	num	8
59	fBodyGyro_std_X	num	8
60	fBodyGyro_std_Y	num	8
61	fBodyGyro_std_Z	num	8
62	fBodyAccMag_mean	num	8
63	fBodyAccMag_std	num	8
64	fBodyBodyAccJerkMag_mean	num	8
65	fBodyBodyAccJerkMag_std	num	8
66	fBodyBodyGyroMag_mean	num	8
67	fBodyBodyGyroMag_std	num	8
68	fBodyBodyGyroJerkMag_mean	num	8
69	fBodyBodyGyroJerkMag_std	num	8
