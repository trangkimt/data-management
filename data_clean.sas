/*********************SAS Data Cleaning Template**********************/
/*********************************************************************/
/****************This is a standard code to do cleaning***************/ 
/****************recoding, generating summary tables******************/

/**********STEP 0: Create Libraries and Directories and Macros********/
/******************Macros help create relative information where******/
/******************you might be re-running same code with*************/
/******************different data sets or locations.******************/
libname lib base "C:/"; 

%let in=location;
%let out=location2;

/***********STEP 1: Import raw files. Insert relative location********/
/***********and file name in the datafile line************************/
options validvarname=v7;
proc import datafile="&in/filename.csv"
	dbms=csv out=dat replace;
	guessingrows=max;
run; 

/***********STEP 2: This is a step to merge files**********************/
data merge;
	set dat dat2;
run;

/************STEP 3: Explore data. Run various summary statements*******/
/******************to look at your data*********************************/
proc contents data=merge varnum; 
run;

proc print data=merge (obs=20);
run; 

/*****Run tables to look at all possible values in variables************/
/*****Can export a pdf as reference*************************************/
ods pdf file="&out/datavalues.pdf" bookmarklist=hide ;
proc freq data=merge nlevels;
	tables v1 v2 v3 / nocum nopercent nocol norow;
run; 
ods pdf close;

/**********STEP 4: Recode to data dictionary*****************************/
/******************You can clean up values by converting*****************/
/******************them to standardized formats**************************/
data merge_recode;
	set merge;
	length v1 $20 v2 v3 $7; 
	if v1="kan" then v1_r="Kansas";
		else if v1="mo" then v1_r="Missouri";
		else v1_r=v1;
        if v2="BLANK" then v2_r="Missing";
        	else if v2="unknown" then v2_r="Missing";
        	else v2_r=v2;
run; 

/***Create a proc format for a variable*/
proc format;
	value $fmt "0 to 11 Months"="0-5"
        		"1"="0-5"
        		"6"="6-12"
        		"BLANK"="Missing"
        		other="13+";
run;

/***********STEP 6: Prepare and export final data set*********************/
data dat_final(rename=(v1_r=v1 v2_r=v2 v3_r=v3));
	set merge_recode;
	keep v1 v2 v3;
run; 

/* Export data set */
proc export data=dat_final outfile="&out/filename_clean.csv"
	dbms=csv replace;
run; 

/************STEP 7: Prepare Summary Reports*****************************/
ods excel file="&out/datsummary.xlsx"
	options(sheet_name="Summary" sheet_interval="none" embedded_titles="yes"); 
ods noproctitle;
title "Title"; 
proc freq data=dat_final;
	format v1 $fmt.;
	tables v1 v2 v3 /nocum nopercent;
run; 

proc freq data=dat_final;
	where v1="Kansas" or v2="Missing";
	tables v1*v2/nocum nopercent nocol norow;
	by v1;
run; 

