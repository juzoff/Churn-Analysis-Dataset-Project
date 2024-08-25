/* 1.Read the file in SAS and display the contents using the PROC IMPORT and PROC PRINT procedures*/
proc import
/* out keyword is used to name a table*/
out=churn_csv
/* Datafile keyword takes the path of the file from the hard disk*/
datafile ="/home/u63872294/Data/churn.csv"
/* “dbms= csv replace” is telling SAS it is a csv file. */
dbms=csv replace;
/* “Getnames=yes” will use first line of the csv file as column names*/
getnames=yes;
/*Data keyword takes the name of the SAS table imported as heart_csv. Print keyword outputs the contents in Results Viewer */
proc print data=churn_csv (obs=100);
/* using contents procedure to check metadata*/
proc contents data=churn_csv;
/* run keyword will execute the above code lines*/
run;



/*-----------------RENAMING--------------------*/
data churn_csv_renamed;
    set churn_csv;
    /* Rename variables with special characters */
    rename 'Churn?'n = Churn
           'Int''l Plan'n = Intl_Plan
           'VMail Plan'n = VMail_Plan
           'Account Length'n = Account_Length
           'Area Code'n = Area_Code
           'VMail Message'n = VMail_Message
           'Day Mins'n = Day_Mins
           'Day Calls'n = Day_Calls
           'Day Charge'n = Day_Charge
           'Eve Mins'n = Eve_Mins
           'Eve Calls'n = Eve_Calls
           'Eve Charge'n = Eve_Charge
           'Night Mins'n = Night_Mins
           'Night Calls'n = Night_Calls
           'Night Charge'n = Night_Charge
           'Intl Mins'n = Intl_Mins
           'Intl Calls'n = Intl_Calls
           'Intl Charge'n = Intl_Charge
           'CustServ Calls'n = CustServ_Calls;
run;

proc print data=churn_csv_renamed (obs=100);
run;



/* ALL ATTRIBUTES*/
/* Step 1: Load the dataset */
proc import datafile="/home/u63872294/Data/churn_csv_renamed.csv"
    out=ORIGINAL_DATA
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 2: Clean the Churn variable by removing periods and formatting */
data ORIGINAL_DATA;
    set ORIGINAL_DATA;
    Churn = strip(upcase(tranwrd(Churn, '.', ''))); /* Remove periods and format Churn */
run;

/* Step 3: Check the class distribution */
proc freq data=ORIGINAL_DATA;
    tables Churn / out=ClassDist;
run;

/* Step 4: Oversample the minority class ('TRUE') to balance the dataset */
/* First, separate the minority and majority classes */
data Minority Majority;
    set ORIGINAL_DATA;
    if Churn = 'TRUE' then output Minority;
    else if Churn = 'FALSE' then output Majority;
run;

/* Determine the replication factor for oversampling */
proc sql noprint;
    select count(*) into :n_majority from Majority;
    select count(*) into :n_minority from Minority;
quit;

/* Calculate the number of replications needed */
%let rep_factor = %sysevalf((&n_majority / &n_minority), ceil);

/* Perform oversampling on the minority class */
data Minority_Oversampled;
    set Minority;
    do i = 1 to &rep_factor;
        output;
    end;
run;

/* Combine the oversampled minority class with the original majority class */
data BalancedData;
    set Minority_Oversampled Majority;
run;

/* Step 5: Check the new class distribution */
proc freq data=BalancedData;
    tables Churn;
run;

/* Step 6: Sort the balanced dataset by the stratification variable */
proc sort data=BalancedData;
    by Churn;
run;

/* Step 7: Split the balanced dataset into training (70%) and testing (30%) */
proc surveyselect data=BalancedData
    out=TrainData
    samprate=0.7
    seed=12345
    outall;
    strata Churn;
run;

data TrainData TestData;
    set TrainData;
    if selected then output TrainData;
    else output TestData;
run;

/* Step 8: Create a decision tree and generate scoring code */
proc hpsplit data=TrainData maxdepth=10;
    class Churn State Account_Length Area_Code Phone Intl_Plan VMail_Plan;
    model Churn = State Account_Length Area_Code Phone Intl_Plan VMail_Plan
                  VMail_Message Day_Mins Day_Calls Day_Charge Eve_Mins Eve_Calls Eve_Charge
                  Night_Mins Night_Calls Night_Charge Intl_Mins Intl_Calls Intl_Charge CustServ_Calls;
    grow gini;
    prune costcomplexity;
    code file='/home/u63872294/Data/churn_decision_tree_score.sas';
run;

/* Step 9: Score the test dataset */
data ScoredData;
    set TestData;
    %include '/home/u63872294/Data/churn_decision_tree_score.sas';
    /* Use P_ChurnTRUE for predictions */
    if P_ChurnTRUE >= 0.5042 then Predicted_Churn = 'TRUE';
    else Predicted_Churn = 'FALSE';
run;

/* Step 10: Evaluate the performance */
proc freq data=ScoredData;
    tables Churn*Predicted_Churn / norow nocol nopercent chisq;
run;

/* Create confusion matrix and performance metrics */
proc sql;
    create table ConfMatrix as
    select 
        sum(case when Churn='TRUE' and Predicted_Churn='TRUE' then 1 else 0 end) as TP,
        sum(case when Churn='TRUE' and Predicted_Churn='FALSE' then 1 else 0 end) as FN,
        sum(case when Churn='FALSE' and Predicted_Churn='TRUE' then 1 else 0 end) as FP,
        sum(case when Churn='FALSE' and Predicted_Churn='FALSE' then 1 else 0 end) as TN
    from ScoredData;
quit;

proc print data=ConfMatrix;
run;

data Metrics;
    set ConfMatrix;
    Accuracy = (TP + TN) / (TP + TN + FP + FN);
    TPR = TP / (TP + FN); /* Sensitivity or Recall */
    FPR = FP / (FP + TN); /* Fall-out or False Positive Rate */
    Specificity = TN / (TN + FP); /* Specificity or True Negative Rate */
    Precision = TP / (TP + FP); /* Precision */
    F_Measure = 2 * ((Precision * TPR) / (Precision + TPR)); /* F-measure (F1 score) */
    keep Accuracy TPR FPR Specificity Precision F_Measure;
run;

proc print data=Metrics;
run;





/* SELECTED ATTRIBUTES*/
proc import datafile="/home/u63872294/Data/churn_csv_renamed.csv"
    out=ORIGINAL_DATA
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 2: Clean the Churn variable by removing periods and formatting */
data ORIGINAL_DATA;
    set ORIGINAL_DATA;
    Churn = strip(upcase(tranwrd(Churn, '.', ''))); /* Remove periods and format Churn */
run;

/* Step 3: Check the class distribution */
proc freq data=ORIGINAL_DATA;
    tables Churn / out=ClassDist;
run;

/* Step 4: Oversample the minority class ('TRUE') to balance the dataset */
/* First, separate the minority and majority classes */
data Minority Majority;
    set ORIGINAL_DATA;
    if Churn = 'TRUE' then output Minority;
    else if Churn = 'FALSE' then output Majority;
run;

/* Determine the replication factor for oversampling */
proc sql noprint;
    select count(*) into :n_majority from Majority;
    select count(*) into :n_minority from Minority;
quit;

/* Calculate the number of replications needed */
%let rep_factor = %sysevalf((&n_majority / &n_minority), ceil);

/* Perform oversampling on the minority class */
data Minority_Oversampled;
    set Minority;
    do i = 1 to &rep_factor;
        output;
    end;
run;

/* Combine the oversampled minority class with the original majority class */
data BalancedData;
    set Minority_Oversampled Majority;
run;

/* Step 5: Check the new class distribution */
proc freq data=BalancedData;
    tables Churn;
run;

/* Step 6: Sort the balanced dataset by the stratification variable */
proc sort data=BalancedData;
    by Churn;
run;

/* Step 7: Split the balanced dataset into training (70%) and testing (30%) */
proc surveyselect data=BalancedData
    out=TrainData
    samprate=0.7
    seed=12345
    outall;
    strata Churn;
run;

data TrainData TestData;
    set TrainData;
    if selected then output TrainData;
    else output TestData;
run;

/* Step 8: Create a decision tree using selected attributes and generate scoring code */
proc hpsplit data=TrainData maxdepth=10;
    class Churn State Intl_Plan VMail_Plan;
    model Churn = Day_Mins CustServ_Calls Intl_Plan State Intl_Charge Eve_Mins
                  VMail_Plan Intl_Calls Account_Length Night_Mins
                  Night_Charge Intl_Mins Day_Calls;
    grow gini;
    prune costcomplexity;
    code file='/home/u63872294/Data/churn_decision_tree_score_selected.sas';
run;

/* Step 9: Score the test dataset */
data ScoredData;
    set TestData;
    %include '/home/u63872294/Data/churn_decision_tree_score_selected.sas';
    /* Use P_ChurnTRUE for predictions */
    if P_ChurnTRUE >= 0.5042 then Predicted_Churn = 'TRUE';
    else Predicted_Churn = 'FALSE';
run;

/* Step 10: Evaluate the performance */
proc freq data=ScoredData;
    tables Churn*Predicted_Churn / norow nocol nopercent chisq;
run;

/* Create confusion matrix and performance metrics */
proc sql;
    create table ConfMatrix as
    select 
        sum(case when Churn='TRUE' and Predicted_Churn='TRUE' then 1 else 0 end) as TP,
        sum(case when Churn='TRUE' and Predicted_Churn='FALSE' then 1 else 0 end) as FN,
        sum(case when Churn='FALSE' and Predicted_Churn='TRUE' then 1 else 0 end) as FP,
        sum(case when Churn='FALSE' and Predicted_Churn='FALSE' then 1 else 0 end) as TN
    from ScoredData;
quit;

proc print data=ConfMatrix;
run;

data Metrics;
    set ConfMatrix;
    Accuracy = (TP + TN) / (TP + TN + FP + FN);
    TPR = TP / (TP + FN); /* Sensitivity or Recall */
    FPR = FP / (FP + TN); /* Fall-out or False Positive Rate */
    Specificity = TN / (TN + FP); /* Specificity or True Negative Rate */
    Precision = TP / (TP + FP); /* Precision */
    F_Measure = 2 * ((Precision * TPR) / (Precision + TPR)); /* F-measure (F1 score) */
    keep Accuracy TPR FPR Specificity Precision F_Measure;
run;

proc print data=Metrics;
run;

