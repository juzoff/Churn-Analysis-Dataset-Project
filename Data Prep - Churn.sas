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

/* Attribute type */
proc contents data=churn_csv_renamed;
run;


/* Missing values - Numerical Variables*/
proc means data=churn_csv_renamed nmiss;
run;


/* Analyze missing values for categorical variables */
proc freq data=churn_csv_renamed;
    tables Churn 
           Intl_Plan 
           Phone 
           State 
           VMail_Plan / missing;
run;


/* Find max, min, mean and standard deviation of numerical attributes. */
proc means data=churn_csv_renamed n mean std min max;
run;


/*--------OUTLIER----------------------------*/

#State
/* Generate frequency distribution for 'State' */
proc freq data=churn_csv_renamed;
    tables State / out=state_freq;
run;

/* Print the frequency distribution */
proc print data=state_freq;
    title "Frequency Distribution of State";
run;

/* Calculate mean and standard deviation of the frequencies */
proc means data=state_freq noprint;
    var count;
    output out=state_stats mean=mean_freq std=std_freq;
run;

/* Identify outliers based on frequencies */
data state_outliers;
    set state_freq;
    if _n_ = 1 then set state_stats;
    if count > mean_freq + 2*std_freq or count < mean_freq - 2*std_freq;
run;

/* Print the identified outliers */
proc print data=state_outliers;
    title "Outliers in State Based on Frequency Distribution";
run;


#Area Code
proc freq data=churn_csv_renamed;
    tables 'Area Code'n / out=area_code_freq;
run;

proc print data=area_code_freq;
    title "Frequency Distribution of Area Code";
run;

proc means data=area_code_freq noprint;
    var count;
    output out=area_code_stats mean=mean_freq std=std_freq;
run;

data area_code_outliers;
    set area_code_freq;
    if _n_ = 1 then set area_code_stats;
    if count > mean_freq + 2*std_freq or count < mean_freq - 2*std_freq;
run;

proc print data=area_code_outliers;
    title "Outliers in Area Code Based on Frequency Distribution";
run;


proc contents data=churn_csv_renamed;
run;


/*----------------NUMERIC ATTRIBUTE & CORRELATIONS WITH CLASS --------------------*/

#Account Length & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_y_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Plot a histogram of the 'Account Length' attribute for the 'yes' class */
proc sgplot data=churn_csv_y_yes;
    title "Histogram of 'Account Length' for Churn 'yes'";
    histogram Account_Length / binwidth=10;
    xaxis label="Account Length";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_y_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Account Length' attribute for the 'no' class */
proc sgplot data=churn_csv_y_no;
    title "Histogram of 'Account Length' for Churn 'no'";
    histogram Account_Length / binwidth=10;
    xaxis label="Account Length";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Account Length between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Account_Length;
run;

/* ANOVA for Account Length by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Account_Length = Churn; /* Test differences in Account Length by Churn */
    title "ANOVA for Account Length by Churn Status";
run;


#CustServ Calls & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_y_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Plot a histogram of the 'CustServ_Calls' attribute for the 'yes' class */
proc sgplot data=churn_csv_y_yes;
    title "Histogram of 'CustServ_Calls' for Churn 'yes'";
    histogram CustServ_Calls / binwidth=1;
    xaxis label="CustServ_Calls";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_y_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'CustServ_Calls' attribute for the 'no' class */
proc sgplot data=churn_csv_y_no;
    title "Histogram of 'CustServ_Calls' for Churn 'no'";
    histogram CustServ_Calls / binwidth=1;
    xaxis label="CustServ_Calls";
    yaxis label="Frequency";
run;

/* T-test for comparing means of CustServ_Calls between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var CustServ_Calls;
run;

/* ANOVA for CustServ_Calls by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model CustServ_Calls = Churn; /* Test differences in CustServ_Calls by Churn */
    title "ANOVA for CustServ_Calls by Churn Status";
run;



#Day Calls & Class 
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_y_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Plot a histogram of the 'Day_Calls' attribute for the 'yes' class */
proc sgplot data=churn_csv_y_yes;
    title "Histogram of 'Day_Calls' for Churn 'yes'";
    histogram Day_Calls / binwidth=1;
    xaxis label="Day_Calls";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_y_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Day_Calls' attribute for the 'no' class */
proc sgplot data=churn_csv_y_no;
    title "Histogram of 'Day_Calls' for Churn 'no'";
    histogram Day_Calls / binwidth=1;
    xaxis label="Day_Calls";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Day_Calls between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Day_Calls;
run;

/* ANOVA for Day_Calls by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Day_Calls = Churn; /* Test differences in Day_Calls by Churn */
    title "ANOVA for Day_Calls by Churn Status";
run;


#Day Charge & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_y_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Plot a histogram of the 'Day_Charge' attribute for the 'yes' class */
proc sgplot data=churn_csv_y_yes;
    title "Histogram of 'Day_Charge' for Churn 'yes'";
    histogram Day_Charge / binwidth=1;
    xaxis label="Day_Charge";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_y_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Day_Charge' attribute for the 'no' class */
proc sgplot data=churn_csv_y_no;
    title "Histogram of 'Day_Charge' for Churn 'no'";
    histogram Day_Charge / binwidth=1;
    xaxis label="Day_Charge";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Day_Charge between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Day_Charge;
run;

/* ANOVA for Day_Charge by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Day_Charge = Churn; /* Test differences in Day_Charge by Churn */
    title "ANOVA for Day_Charge by Churn Status";
run;


#Day Mins & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_y_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Plot a histogram of the 'Day_Mins' attribute for the 'yes' class */
proc sgplot data=churn_csv_y_yes;
    title "Histogram of 'Day_Mins' for Churn 'yes'";
    histogram Day_Mins / binwidth=1;
    xaxis label="Day_Mins";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_y_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Day_Mins' attribute for the 'no' class */
proc sgplot data=churn_csv_y_no;
    title "Histogram of 'Day_Mins' for Churn 'no'";
    histogram Day_Mins / binwidth=1;
    xaxis label="Day_Mins";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Day_Mins between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Day_Mins;
run;

/* ANOVA for Day_Mins by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Day_Mins = Churn; /* Test differences in Day_Mins by Churn */
    title "ANOVA for Day_Mins by Churn Status";
run;



#Eve Calls & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_y_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Plot a histogram of the 'Eve_Calls' attribute for the 'yes' class */
proc sgplot data=churn_csv_y_yes;
    title "Histogram of 'Eve_Calls' for Churn 'yes'";
    histogram Eve_Calls / binwidth=1;
    xaxis label="Eve_Calls";
    yaxis label="Frequency";
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_y_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Eve_Calls' attribute for the 'no' class */
proc sgplot data=churn_csv_y_no;
    title "Histogram of 'Eve_Calls' for Churn 'no'";
    histogram Eve_Calls / binwidth=1;
    xaxis label="Eve_Calls";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Eve_Calls between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Eve_Calls;
run;

/* ANOVA for Eve_Calls by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Eve_Calls = Churn; /* Test differences in Eve_Calls by Churn */
    title "ANOVA for Eve_Calls by Churn Status";
run;


#Eve Charge & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_eve_charge_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_eve_charge_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Eve_Charge' attribute for the 'yes' class */
proc sgplot data=churn_csv_eve_charge_yes;
    title "Histogram of 'Eve_Charge' for Churn 'yes'";
    histogram Eve_Charge / binwidth=1;
    xaxis label="Eve_Charge";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Eve_Charge' attribute for the 'no' class */
proc sgplot data=churn_csv_eve_charge_no;
    title "Histogram of 'Eve_Charge' for Churn 'no'";
    histogram Eve_Charge / binwidth=1;
    xaxis label="Eve_Charge";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Eve_Charge between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Eve_Charge;
run;

/* ANOVA for Eve_Charge by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Eve_Charge = Churn; /* Test differences in Eve_Charge by Churn */
    title "ANOVA for Eve_Charge by Churn Status";
run;


#Eve Mins & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_eve_mins_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_eve_mins_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Eve_Mins' attribute for the 'yes' class */
proc sgplot data=churn_csv_eve_mins_yes;
    title "Histogram of 'Eve_Mins' for Churn 'yes'";
    histogram Eve_Mins / binwidth=1;
    xaxis label="Eve_Mins";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Eve_Mins' attribute for the 'no' class */
proc sgplot data=churn_csv_eve_mins_no;
    title "Histogram of 'Eve_Mins' for Churn 'no'";
    histogram Eve_Mins / binwidth=1;
    xaxis label="Eve_Mins";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Eve_Mins between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Eve_Mins;
run;

/* ANOVA for Eve_Mins by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Eve_Mins = Churn; /* Test differences in Eve_Mins by Churn */
    title "ANOVA for Eve_Mins by Churn Status";
run;


#Intl Calls & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_intl_calls_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_intl_calls_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Intl_Calls' attribute for the 'yes' class */
proc sgplot data=churn_csv_intl_calls_yes;
    title "Histogram of 'Intl_Calls' for Churn 'yes'";
    histogram Intl_Calls / binwidth=1;
    xaxis label="Intl_Calls";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Intl_Calls' attribute for the 'no' class */
proc sgplot data=churn_csv_intl_calls_no;
    title "Histogram of 'Intl_Calls' for Churn 'no'";
    histogram Intl_Calls / binwidth=1;
    xaxis label="Intl_Calls";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Intl_Calls between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Intl_Calls;
run;

/* ANOVA for Intl_Calls by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Intl_Calls = Churn; /* Test differences in Intl_Calls by Churn */
    title "ANOVA for Intl_Calls by Churn Status";
run;


#Intl Charge & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_intl_charge_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_intl_charge_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Intl_Charge' attribute for the 'yes' class */
proc sgplot data=churn_csv_intl_charge_yes;
    title "Histogram of 'Intl_Charge' for Churn 'yes'";
    histogram Intl_Charge / binwidth=1;
    xaxis label="Intl_Charge";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Intl_Charge' attribute for the 'no' class */
proc sgplot data=churn_csv_intl_charge_no;
    title "Histogram of 'Intl_Charge' for Churn 'no'";
    histogram Intl_Charge / binwidth=1;
    xaxis label="Intl_Charge";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Intl_Charge between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Intl_Charge;
run;

/* ANOVA for Intl_Charge by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Intl_Charge = Churn; /* Test differences in Intl_Charge by Churn */
    title "ANOVA for Intl_Charge by Churn Status";
run;


#Intl Mins & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_intl_mins_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_intl_mins_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Intl_Mins' attribute for the 'yes' class */
proc sgplot data=churn_csv_intl_mins_yes;
    title "Histogram of 'Intl_Mins' for Churn 'yes'";
    histogram Intl_Mins / binwidth=1;
    xaxis label="Intl_Mins";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Intl_Mins' attribute for the 'no' class */
proc sgplot data=churn_csv_intl_mins_no;
    title "Histogram of 'Intl_Mins' for Churn 'no'";
    histogram Intl_Mins / binwidth=1;
    xaxis label="Intl_Mins";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Intl_Mins between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Intl_Mins;
run;

/* ANOVA for Intl_Mins by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Intl_Mins = Churn; /* Test differences in Intl_Mins by Churn */
    title "ANOVA for Intl_Mins by Churn Status";
run;


#Night Calls & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_night_calls_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_night_calls_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Night_Calls' attribute for the 'yes' class */
proc sgplot data=churn_csv_night_calls_yes;
    title "Histogram of 'Night_Calls' for Churn 'yes'";
    histogram Night_Calls / binwidth=1;
    xaxis label="Night_Calls";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Night_Calls' attribute for the 'no' class */
proc sgplot data=churn_csv_night_calls_no;
    title "Histogram of 'Night_Calls' for Churn 'no'";
    histogram Night_Calls / binwidth=1;
    xaxis label="Night_Calls";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Night_Calls between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Night_Calls;
run;

/* ANOVA for Night_Calls by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Night_Calls = Churn; /* Test differences in Night_Calls by Churn */
    title "ANOVA for Night_Calls by Churn Status";
run;


#Night Charge & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_night_charge_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_night_charge_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Night_Charge' attribute for the 'yes' class */
proc sgplot data=churn_csv_night_charge_yes;
    title "Histogram of 'Night_Charge' for Churn 'yes'";
    histogram Night_Charge / binwidth=1;
    xaxis label="Night_Charge";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Night_Charge' attribute for the 'no' class */
proc sgplot data=churn_csv_night_charge_no;
    title "Histogram of 'Night_Charge' for Churn 'no'";
    histogram Night_Charge / binwidth=1;
    xaxis label="Night_Charge";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Night_Charge between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Night_Charge;
run;

/* ANOVA for Night_Charge by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Night_Charge = Churn; /* Test differences in Night_Charge by Churn */
    title "ANOVA for Night_Charge by Churn Status";
run;


#Night Mins & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_night_mins_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_night_mins_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Night_Mins' attribute for the 'yes' class */
proc sgplot data=churn_csv_night_mins_yes;
    title "Histogram of 'Night_Mins' for Churn 'yes'";
    histogram Night_Mins / binwidth=10;
    xaxis label="Night_Mins";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Night_Mins' attribute for the 'no' class */
proc sgplot data=churn_csv_night_mins_no;
    title "Histogram of 'Night_Mins' for Churn 'no'";
    histogram Night_Mins / binwidth=10;
    xaxis label="Night_Mins";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Night_Mins between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Night_Mins;
run;

/* ANOVA for Night_Mins by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Night_Mins = Churn; /* Test differences in Night_Mins by Churn */
    title "ANOVA for Night_Mins by Churn Status";
run;


#VMail Message & Class
/* Filter the dataset to include only observations where the churn status is 'yes' */
data churn_csv_vmail_message_yes;
    set churn_csv_renamed;
    where Churn = 'yes';
run;

/* Filter the dataset to include only observations where the churn status is 'no' */
data churn_csv_vmail_message_no;
    set churn_csv_renamed;
    where Churn = 'no';
run;

/* Plot a histogram of the 'Vmail_Message' attribute for the 'yes' class */
proc sgplot data=churn_csv_vmail_message_yes;
    title "Histogram of 'Vmail_Message' for Churn 'yes'";
    histogram Vmail_Message / binwidth=1;
    xaxis label="Vmail_Message";
    yaxis label="Frequency";
run;

/* Plot a histogram of the 'Vmail_Message' attribute for the 'no' class */
proc sgplot data=churn_csv_vmail_message_no;
    title "Histogram of 'Vmail_Message' for Churn 'no'";
    histogram Vmail_Message / binwidth=1;
    xaxis label="Vmail_Message";
    yaxis label="Frequency";
run;

/* T-test for comparing means of Vmail_Message between the two Churn classes */
proc ttest data=churn_csv_renamed;
    class Churn;
    var Vmail_Message;
run;

/* ANOVA for Vmail_Message by Churn status */
proc glm data=churn_csv_renamed;
    class Churn; /* Churn status is the categorical variable */
    model Vmail_Message = Churn; /* Test differences in Vmail_Message by Churn */
    title "ANOVA for Vmail_Message by Churn Status";
run;


/*----------------CATEGORICAL ATTRIBUTE & CORRELATIONS WITH CLASS --------------------*/
#State & Class
/* Contingency Table for State and Churn Status */
proc freq data=churn_csv_renamed;
    tables State*Churn / chisq;
    title "Contingency Table for State and Churn Status";
run;

/* Chi-Square Test for State and Churn Status */
proc freq data=churn_csv_renamed;
    tables State*Churn / chisq expected;
    title "Chi-Square Test for State and Churn Status";
run;


#Area_Code & Class
/* Contingency Table for Area_Code and Churn */
proc freq data=churn_csv_renamed;
    tables Area_Code*Churn / chisq;
    title "Contingency Table for Area_Code and Churn Status";
run;

/* Chi-Square Test for Area_Code and Churn */
proc freq data=churn_csv_renamed;
    tables Area_Code*Churn / chisq expected;
    title "Chi-Square Test for Area_Code and Churn Status";
run;


#Phone & Class
/* Contingency Table for Phone and Churn */
proc freq data=churn_csv_renamed;
    tables Phone*Churn / chisq;
    title "Contingency Table for Phone and Churn Status";
run;

/* Chi-Square Test for Phone and Churn */
proc freq data=churn_csv_renamed;
    tables Phone*Churn / chisq expected;
    title "Chi-Square Test for Phone and Churn Status";
run;


#Intl_Plan & Class
/* Contingency Table for Intl_Plan and Churn */
proc freq data=churn_csv_renamed;
    tables Intl_Plan*Churn / chisq;
    title "Contingency Table for Intl_Plan and Churn Status";
run;

/* Chi-Square Test for Intl_Plan and Churn */
proc freq data=churn_csv_renamed;
    tables Intl_Plan*Churn / chisq expected;
    title "Chi-Square Test for Intl_Plan and Churn Status";
run;


#Vmail_Plan
/* Contingency Table for Vmail_Plan and Churn */
proc freq data=churn_csv_renamed;
    tables Vmail_Plan*Churn / chisq;
    title "Contingency Table for Vmail_Plan and Churn Status";
run;

/* Chi-Square Test for Vmail_Plan and Churn */
proc freq data=churn_csv_renamed;
    tables Vmail_Plan*Churn / chisq expected;
    title "Chi-Square Test for Vmail_Plan and Churn Status";
run;


/*----------------------NUMERIC ATTRIBUTE CORRELATIONS ------- --------------------*/

/* Perform Correlation Analysis for Specified Numerical Variables */
proc corr data=churn_csv_renamed nosimple;
    var Account_Length CustServ_Calls Day_Calls Day_Charge Day_Mins
        Eve_Calls Eve_Charge Eve_Mins Intl_Calls Intl_Charge
        Intl_Mins Night_Calls Night_Charge Night_Mins Vmail_Message;
    title "Correlation Analysis between Account_Length, CustServ_Calls, Day_Calls, Day_Charge, Day_Mins, Eve_Calls, Eve_Charge, Eve_Mins, Intl_Calls, Intl_Charge, Intl_Mins, Night_Calls, Night_Charge, Night_Mins, and Vmail_Message";
run;


/*----------------------CATEGORICAL ATTRIBUTE CORRELATIONS ------- --------------------*/
#State & Area Code
/* Contingency Table and Chi-Square Test for State and Area_Code */
proc freq data=churn_csv_renamed;
    tables State*Area_Code / chisq;
    title "Contingency Table and Chi-Square Test for State and Area_Code";
run;


#State & Phone
/* Contingency Table and Chi-Square Test for State and Phone */
proc freq data=churn_csv_renamed;
    tables State*Phone / chisq;
    title "Contingency Table and Chi-Square Test for State and Phone";
run;


#State & Intl_Plan
/* Contingency Table and Chi-Square Test for State and Intl_Plan */
proc freq data=churn_csv_renamed;
    tables State*Intl_Plan / chisq;
    title "Contingency Table and Chi-Square Test for State and Intl_Plan";
run;


#State & Vmail_Plan
/* Contingency Table and Chi-Square Test for State and Vmail_Plan */
proc freq data=churn_csv_renamed;
    tables State*Vmail_Plan / chisq;
    title "Contingency Table and Chi-Square Test for State and Vmail_Plan";
run;


#Area Code & Intl_Plan
/* Contingency Table and Chi-Square Test for Area_Code and Intl_Plan */
proc freq data=churn_csv_renamed;
    tables Area_Code*Intl_Plan / chisq;
    title "Contingency Table and Chi-Square Test for Area_Code and Intl_Plan";
run;


#Area Code & Vmail_Plan
/* Contingency Table and Chi-Square Test for Area_Code and Vmail_Plan */
proc freq data=churn_csv_renamed;
    tables Area_Code*Vmail_Plan / chisq;
    title "Contingency Table and Chi-Square Test for Area_Code and Vmail_Plan";
run;


#Intl_Plan & Vmail_Plan
/* Contingency Table and Chi-Square Test for Intl_Plan and Vmail_Plan */
proc freq data=churn_csv_renamed;
    tables Intl_Plan*Vmail_Plan / chisq;
    title "Contingency Table and Chi-Square Test for Intl_Plan and Vmail_Plan";
run;


/*----------------------CATEGORICAL & NUMERICAL ATTRIBUTE CORRELATIONS ------- --------------------*/
#Account Length & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Account_Length by State";
    vbox Account_Length / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Account_Length = State;
    title "ANOVA for Account_Length by State";
run;


#Account Length & Area Code 
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Account_Length by Area_Code";
    vbox Account_Length / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Account_Length = Area_Code;
    title "ANOVA for Account_Length by Area_Code";
run;


#Account Length & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Account_Length by Intl_Plan";
    vbox Account_Length / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Account_Length = Intl_Plan;
    title "ANOVA for Account_Length by Intl_Plan";
run;


#Account Length & Vmail_Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Account_Length by Vmail_Plan";
    vbox Account_Length / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Account_Length = Vmail_Plan;
    title "ANOVA for Account_Length by Vmail_Plan";
run;


#CustServ Calls & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of CustServ_Calls by State";
    vbox CustServ_Calls / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model CustServ_Calls = State;
    title "ANOVA for CustServ_Calls by State";
run;


#CustServ Calls & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of CustServ_Calls by Area_Code";
    vbox CustServ_Calls / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model CustServ_Calls = Area_Code;
    title "ANOVA for CustServ_Calls by Area_Code";
run;


#CustServ Calls & Intl_Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of CustServ_Calls by Intl_Plan";
    vbox CustServ_Calls / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model CustServ_Calls = Intl_Plan;
    title "ANOVA for CustServ_Calls by Intl_Plan";
run;


#CustServ Calls & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of CustServ_Calls by Vmail_Plan";
    vbox CustServ_Calls / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model CustServ_Calls = Vmail_Plan;
    title "ANOVA for CustServ_Calls by Vmail_Plan";
run;


#Day Calls & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Calls by State";
    vbox Day_Calls / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Day_Calls = State;
    title "ANOVA for Day_Calls by State";
run;


#Day Calls & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Calls by Area_Code";
    vbox Day_Calls / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Day_Calls = Area_Code;
    title "ANOVA for Day_Calls by Area_Code";
run;


#Day Calls & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Calls by Intl_Plan";
    vbox Day_Calls / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Day_Calls = Intl_Plan;
    title "ANOVA for Day_Calls by Intl_Plan";
run;


#Day Calls & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Calls by Vmail_Plan";
    vbox Day_Calls / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Day_Calls = Vmail_Plan;
    title "ANOVA for Day_Calls by Vmail_Plan";
run;


#Day Charge & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Charge by State";
    vbox Day_Charge / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Day_Charge = State;
    title "ANOVA for Day_Charge by State";
run;


#Day Charge & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Charge by Area_Code";
    vbox Day_Charge / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Day_Charge = Area_Code;
    title "ANOVA for Day_Charge by Area_Code";
run;


#Day Charge & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Charge by Intl_Plan";
    vbox Day_Charge / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Day_Charge = Intl_Plan;
    title "ANOVA for Day_Charge by Intl_Plan";
run;


#Day Charge & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Charge by Vmail_Plan";
    vbox Day_Charge / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Day_Charge = Vmail_Plan;
    title "ANOVA for Day_Charge by Vmail_Plan";
run;


#Day Mins & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Mins by State";
    vbox Day_Mins / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Day_Mins = State;
    title "ANOVA for Day_Mins by State";
run;


#Day Mins & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Mins by Area_Code";
    vbox Day_Mins / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Day_Mins = Area_Code;
    title "ANOVA for Day_Mins by Area_Code";
run;


#Day Mins & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Mins by Intl_Plan";
    vbox Day_Mins / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Day_Mins = Intl_Plan;
    title "ANOVA for Day_Mins by Intl_Plan";
run;


#Day Mins & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Day_Mins by Vmail_Plan";
    vbox Day_Mins / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Day_Mins = Vmail_Plan;
    title "ANOVA for Day_Mins by Vmail_Plan";
run;


#Eve Calls & State  - Checkpoint
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Calls by State";
    vbox Eve_Calls / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Eve_Calls = State;
    title "ANOVA for Eve_Calls by State";
run;


#Eve Calls & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Calls by Area_Code";
    vbox Eve_Calls / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Eve_Calls = Area_Code;
    title "ANOVA for Eve_Calls by Area_Code";
run;


#Eve Calls & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Calls by Intl_Plan";
    vbox Eve_Calls / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Eve_Calls = Intl_Plan;
    title "ANOVA for Eve_Calls by Intl_Plan";
run;


#Eve Calls & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Calls by Vmail_Plan";
    vbox Eve_Calls / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Eve_Calls = Vmail_Plan;
    title "ANOVA for Eve_Calls by Vmail_Plan";
run;


#Eve Charge & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Charge by State";
    vbox Eve_Charge / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Eve_Charge = State;
    title "ANOVA for Eve_Charge by State";
run;


#Eve Charge & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Charge by Area_Code";
    vbox Eve_Charge / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Eve_Charge = Area_Code;
    title "ANOVA for Eve_Charge by Area_Code";
run;


#Eve Charge & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Charge by Intl_Plan";
    vbox Eve_Charge / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Eve_Charge = Intl_Plan;
    title "ANOVA for Eve_Charge by Intl_Plan";
run;


#Eve Charge & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Charge by Vmail_Plan";
    vbox Eve_Charge / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Eve_Charge = Vmail_Plan;
    title "ANOVA for Eve_Charge by Vmail_Plan";
run;


#Eve Mins & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Mins by State";
    vbox Eve_Mins / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Eve_Mins = State;
    title "ANOVA for Eve_Mins by State";
run;


#Eve Mins & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Mins by Area_Code";
    vbox Eve_Mins / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Eve_Mins = Area_Code;
    title "ANOVA for Eve_Mins by Area_Code";
run;


#Eve Mins & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Mins by Intl_Plan";
    vbox Eve_Mins / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Eve_Mins = Intl_Plan;
    title "ANOVA for Eve_Mins by Intl_Plan";
run;


#Eve Mins & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Eve_Mins by Vmail_Plan";
    vbox Eve_Mins / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Eve_Mins = Vmail_Plan;
    title "ANOVA for Eve_Mins by Vmail_Plan";
run;


#Intl Calls & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Calls by State";
    vbox Intl_Calls / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Intl_Calls = State;
    title "ANOVA for Intl_Calls by State";
run;


#Intl Calls & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Calls by Area_Code";
    vbox Intl_Calls / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Intl_Calls = Area_Code;
    title "ANOVA for Intl_Calls by Area_Code";
run;


#Intl Calls & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Calls by Intl_Plan";
    vbox Intl_Calls / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Intl_Calls = Intl_Plan;
    title "ANOVA for Intl_Calls by Intl_Plan";
run;


#Intl Calls & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Calls by Vmail_Plan";
    vbox Intl_Calls / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Intl_Calls = Vmail_Plan;
    title "ANOVA for Intl_Calls by Vmail_Plan";
run;


#Intl Charge & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Charge by State";
    vbox Intl_Charge / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Intl_Charge = State;
    title "ANOVA for Intl_Charge by State";
run;


#Intl Charge & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Charge by Area_Code";
    vbox Intl_Charge / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Intl_Charge = Area_Code;
    title "ANOVA for Intl_Charge by Area_Code";
run;


#Intl Charge & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Charge by Intl_Plan";
    vbox Intl_Charge / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Intl_Charge = Intl_Plan;
    title "ANOVA for Intl_Charge by Intl_Plan";
run;


#Intl Charge & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Charge by Vmail_Plan";
    vbox Intl_Charge / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Intl_Charge = Vmail_Plan;
    title "ANOVA for Intl_Charge by Vmail_Plan";
run;


# Intl Mins & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Mins by State";
    vbox Intl_Mins / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Intl_Mins = State;
    title "ANOVA for Intl_Mins by State";
run;


# Intl Mins & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Mins by Area_Code";
    vbox Intl_Mins / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Intl_Mins = Area_Code;
    title "ANOVA for Intl_Mins by Area_Code";
run;


# Intl Mins & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Mins by Intl_Plan";
    vbox Intl_Mins / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Intl_Mins = Intl_Plan;
    title "ANOVA for Intl_Mins by Intl_Plan";
run;


# Intl Mins & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Intl_Mins by Vmail_Plan";
    vbox Intl_Mins / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Intl_Mins = Vmail_Plan;
    title "ANOVA for Intl_Mins by Vmail_Plan";
run;


#Night Calls & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Calls by State";
    vbox Night_Calls / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Night_Calls = State;
    title "ANOVA for Night_Calls by State";
run;


#Night Calls & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Calls by Area_Code";
    vbox Night_Calls / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Night_Calls = Area_Code;
    title "ANOVA for Night_Calls by Area_Code";
run;


#Night Calls & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Calls by Intl_Plan";
    vbox Night_Calls / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Night_Calls = Intl_Plan;
    title "ANOVA for Night_Calls by Intl_Plan";
run;


#Night Calls & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Calls by Vmail_Plan";
    vbox Night_Calls / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Night_Calls = Vmail_Plan;
    title "ANOVA for Night_Calls by Vmail_Plan";
run;


# Night Charge & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Charge by State";
    vbox Night_Charge / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Night_Charge = State;
    title "ANOVA for Night_Charge by State";
run;


# Night Charge & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Charge by Area_Code";
    vbox Night_Charge / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Night_Charge = Area_Code;
    title "ANOVA for Night_Charge by Area_Code";
run;


# Night Charge & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Charge by Intl_Plan";
    vbox Night_Charge / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Night_Charge = Intl_Plan;
    title "ANOVA for Night_Charge by Intl_Plan";
run;


# Night Charge & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Charge by Vmail_Plan";
    vbox Night_Charge / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Night_Charge = Vmail_Plan;
    title "ANOVA for Night_Charge by Vmail_Plan";
run;


# Night Mins & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Mins by State";
    vbox Night_Mins / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Night_Mins = State;
    title "ANOVA for Night_Mins by State";
run;


# Night Mins & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Mins by Area_Code";
    vbox Night_Mins / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Night_Mins = Area_Code;
    title "ANOVA for Night_Mins by Area_Code";
run;


# Night Mins & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Mins by Intl_Plan";
    vbox Night_Mins / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Night_Mins = Intl_Plan;
    title "ANOVA for Night_Mins by Intl_Plan";
run;


# Night Mins & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Night_Mins by Vmail_Plan";
    vbox Night_Mins / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Night_Mins = Vmail_Plan;
    title "ANOVA for Night_Mins by Vmail_Plan";
run;


# Vmail_Message & State
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Vmail_Message by State";
    vbox Vmail_Message / category=State;
run;

proc glm data=churn_csv_renamed;
    class State;
    model Vmail_Message = State;
    title "ANOVA for Vmail_Message by State";
run;


# Vmail_Message & Area Code
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Vmail_Message by Area_Code";
    vbox Vmail_Message / category=Area_Code;
run;

proc glm data=churn_csv_renamed;
    class Area_Code;
    model Vmail_Message = Area_Code;
    title "ANOVA for Vmail_Message by Area_Code";
run;


# Vmail_Message & Intl Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Vmail_Message by Intl_Plan";
    vbox Vmail_Message / category=Intl_Plan;
run;

proc glm data=churn_csv_renamed;
    class Intl_Plan;
    model Vmail_Message = Intl_Plan;
    title "ANOVA for Vmail_Message by Intl_Plan";
run;


# Vmail_Message & Vmail Plan
proc sgplot data=churn_csv_renamed;
    title "Box Plot of Vmail_Message by Vmail_Plan";
    vbox Vmail_Message / category=Vmail_Plan;
run;

proc glm data=churn_csv_renamed;
    class Vmail_Plan;
    model Vmail_Message = Vmail_Plan;
    title "ANOVA for Vmail_Message by Vmail_Plan";
run;


*----------------------------/*Determine whether the dataset has an imbalanced class distribution (same proportion of records of different types or not) and do you need to balance the dataset.*/-------------------*
/* Count the number of records for each class */
proc freq data=churn_csv_renamed;
    tables Churn / nocum nopercent;
    title "Class Distribution of Churn";
run;

/* Visualize class distribution */
proc sgplot data=churn_csv_renamed;
    vbar Churn / datalabel;
    title "Class Distribution of Churn";
run;
