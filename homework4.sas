/*********************************************************************************/
/** DA 6223: Data Analytics Tools & Techniques                                   */
/** Homework #4                                                                  */
/** Date: 07/09/2018                                                             */   
/** Hejin Shin                                                                   */
/*-------------------------------------------------------------------------------*/
/** 1. Import the data sets into SAS                                             */
/** 2. Merges the training and the test sets to create one data set.             */                                                                               
/** 3. Extracts only the measurements on the mean and standard deviation         */
/**    for each measurement.                                                     */                                                        
/** 4. Uses descriptive activity names to name the activities in the data set    */                                                                         
/** 5. Appropriately labels the data set with descriptive variable names.        */                                                                        
/** 6. From the data set in step 4, creates a tidy data set                      */
/**    with the average of each variable for each activity and each subject.     */
/** 7. Export the tidy data set as a tab-delimited text file                     */
/*-------------------------------------------------------------------------------*/

/* set LIBNAME as "da" in my homework working directory */
LIBNAME da 'c:\da6223\hw4';run;
/*-------------------*/
/* the TRAIN dataset */
/*-------------------*/

/* import x_train.txt into SAS */
FILENAME test 'C:\DA6223\UCI HAR Dataset\train\X_train.txt';
DATA da.x_train ;
INFILE test  LRECL=32767 TRUNCOVER END = var562;
INPUT var1-var562 8.;
RUN;

/* import the file features.txt into SAS */
FILENAME features 'C:\DA6223\UCI HAR Dataset\features.txt';
DATA da.features;
   INFILE features lrecl=32767 TRUNCOVER ;
   INPUT  var1  var2 $40. ;
RUN;

/* select only variables containing the mean() or std() features*/ 
PROC SQL;
  CREATE TABLE da.feat_vars 
  AS SELECT * FROM da.features
  WHERE lowcase(var2) LIKE  '%mean()%' OR lowcase(var2) LIKE '%std()%';
QUIT;
 
/* import subject.txt */
FILENAME subtest 'C:\DA6223\UCI HAR Dataset\train\subject_train.txt';
DATA da.subject_train;
 LENGTH dataset $5.;
 INFILE subtest lrecl=32767 truncover ;
 INPUT  subjectID ;
 dataset="TRAIN";
RUN;
 
/*import features.txt */
DATA da.features_mean_std;
 LENGTH vnum1 $6.;
 SET da.features;
 WHERE LOWCASE(var2) CONTAINS 'mean()' or LOWCASE(var2) CONTAINS 'std()';
 var2=TRANWRD(var2,'()','');
 var2=COMPRESS(tranwrd(var2, '-','_'));
 vnum1="var"||TRIM(LEFT(var1));
 DROP var1;
RUN;

/* get the variable names in macro, keep_list */
PROC SQL NOPRINT;
SELECT vnum1
     INTO :keep_list SEPARATED BY " "
FROM da.features_mean_std;
QUIT;

/* keep only the variables containing mean() or std()  */
DATA da.x_train;
SET da.x_train;
KEEP &keep_list;
RUN;

/* Get the variable names from the feature file */
PROC SQL NOPRINT;
	SELECT CATX('=', vnum1,var2)
	INTO :rename_list SEPARATED BY ' '
	FROM da.features_mean_std;

/* rename the variables to the ones in feature.txt */
DATA da.x_train;
	SET da.x_train;
	RENAME &rename_list;
RUN;
 
/* import activity_labels.txt */
FILENAME act 'C:\DA6223\UCI HAR Dataset\activity_labels.txt';
DATA da.actlabels;
   INFILE act lrecl=32767 truncover;
   INPUT  actlabelnum activitylabel $20. ;
RUN;

/* read y_train.txt into SAS */
FILENAME tr 'C:\DA6223\UCI HAR Dataset\train\y_train.txt';
DATA da.y_train ;
	INFILE tr LRECL=32767 TRUNCOVER;
	INPUT actlabelnum 3.;
RUN;

/* merge subjectID, x_train, and y_train */
DATA da.train_merge; 
	MERGE da.subject_train da.x_train  da.y_train;
RUN;

/*-------------------*/
/* the TEST dataset  */
/*-------------------*/

/* import x_test.txt into SAS */
FILENAME test 'C:\DA6223\UCI HAR Dataset\test\X_test.txt';
DATA da.x_test ;
	INFILE test  LRECL=32767 TRUNCOVER END = var562;
	INPUT var1-var562 8.;
run;

/* import subject.txt */
FILENAME subtest 'C:\DA6223\UCI HAR Dataset\test\subject_test.txt';
DATA da.subject_test;
 	LENGTH dataset $5.;
 	INFILE subtest lrecl=32767 truncover ;
 	INPUT  subjectID ;
 	dataset="TEST";
RUN;

 /*keep only the variables containing mean() and std() */
DATA da.x_test;
	SET da.x_test;
	KEEP &keep_list;
RUN;

/* rename the variables using feature names */
DATA da.x_test;
	SET da.x_test;
	RENAME &rename_list;
RUN;

/* import y_test.txt into SAS */  
FILENAME tr 'C:\DA6223\UCI HAR Dataset\test\y_test.txt';
DATA da.y_test ;
	INFILE tr LRECL=32767 TRUNCOVER;
	INPUT actlabelnum 3.;
RUN;

/* merge subjectID, x_test, and y_test */
DATA da.test_merge; 
	MERGE da.subject_test da.x_test  da.y_test;
RUN;

/* combine the TEST and TRAIN datasets into da.all_data */
PROC APPEND DATA=da.train_merge BASE=da.all_data;RUN;
PROC APPEND DATA=da.test_merge  BASE=da.all_data;RUN;

/* drop the variable dataset */
DATA da.all_data2;
	SET da.all_data;
	DROP dataset ;
RUN;

/* get the feature names containing mean() and std() as a macro, aggr_list */
PROC SQL NOPRINT;
	SELECT var2
    INTO :aggr_list SEPARATED BY " "
	FROM da.features_mean_std;
QUIT;

/* sort da.all_data2 by subjectID actlabelnum */
PROC SORT DATA=da.all_data2 OUT=da.all_data2srt;
	BY subjectID actlabelnum;
RUN;

/* get the mean of each variable by subjectID and aclabelnum and save the result in da.all_data2means */
PROC MEANS DATA=da.all_data2srt NOPRINT;
	BY subjectID actlabelnum;
	VAR &aggr_list;
	OUTPUT OUT=da.all_data2means (DROP=_FREQ_ _TYPE_) MEAN=;
RUN;

/*get the activity label for the da.all_data2means */
PROC SQL;
	CREATE TABLE da.allactlabel_merg 
	AS SELECT b.activitylabel, a.*  
	FROM da.all_data2means a, da.actlabels b
	WHERE a.actlabelnum=b.actlabelnum 
	ORDER BY b.actlabelnum, subjectID;
QUIT;

/* get the variable names and their order number */
PROC CONTENTS
	DATA=da.allactlabel_merg NOPRINT
	OUT=data_info(KEEP=name varnum);
RUN;  

/* sort the variable name by variable number using linguistic sort order */
PROC SORT DATA=data_info OUT=da.tidydata_vars
	SORTSEQ=LINGUISTIC (NUMERIC_COLLATION=ON);
	BY varnum;
RUN;

/* create a data dictionary similar to R's str() */
PROC SQL;
	CREATE TABLE da.data_dict 
	AS SELECT varnum, name, type, length 
	FROM DICTIONARY.COLUMNS 
	WHERE UPCASE(LIBNAME)="DA" AND LOWCASE(MEMNAME)="allactlabel_merg"; 
QUIT; 

/* export data dictionary as a text file */
PROC EXPORT DATA= da.data_dict 
            OUTFILE= "C:\DA6223\HW4\data_dict.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;

/* export the final data as a tab-delimited text file */
PROC EXPORT DATA= da.allactlabel_merg 
            OUTFILE= "C:\DA6223\HW4\final_data.txt" 
            DBMS=TAB REPLACE;
     PUTNAMES=YES;
RUN;
 
