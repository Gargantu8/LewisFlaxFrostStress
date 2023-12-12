/* Start of Correlation testing ######################################## */

PROC IMPORT OUT= WORK.VDS  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="V_DS_Final"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 

proc sort data = VDS;
by Sample_Number treat Time;
run;
proc transpose data = VDS out=VDS_wide(drop=_name_ _LABEL_);
by Sample_Number treat rep;
var SurvivalRegulated;
id Time;
run;

proc export data=VDS_wide
outfile="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\VDS_wide.csv" /* input data set filepath */
            DBMS=csv 
replace; run;

PROC IMPORT OUT= WORK.SurvAvg  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\SurvTry2.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="Sheet 1"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 

proc sort data=SurvAvg ;
by Sample_Number treat Time;
run;
proc transpose data = SurvAvg out=SurvAvg_wide (drop=_name_ _LABEL_) ;
by Sample_Number treat;
var SurvivalRegulated;
id Time;
run;
proc export data=SurvAvg_wide
outfile="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\SurvAvg_wide.csv" /* input data set filepath */
            DBMS=csv 
replace; run;


/* Export to R to get averages easily then reimport to run corr. */

proc export data=Vds_wide
outfile="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\Surv_wide.csv" /* input data set filepath */
            DBMS=csv 
replace; run;

PROC IMPORT OUT= WORK.HeightDiff  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="V_DS_Final"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 

proc sort data=HeightDiff ;
by Sample_Number rep treat Time;
run;
proc transpose data = HeightDiff out=HeightDiff_wide (drop=_name_ _LABEL_) ;
by Sample_Number rep treat;
var Total_HeightRegBrady;
id Time;
run;

data HeightDiff2_wide;
set HeightDiff_wide;
BaselineOne = (_1-_0);
BaselineTwo = (_2-_1);
BaselineThree = (_3-_2);
run;
quit;

proc export data=HeightDiff2_wide
outfile="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\HeightDifAvg_wide.csv" /* input data set filepath */
            DBMS=csv 
replace; run;

/*Start just correlation */
PROC IMPORT OUT= WORK.cortest  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="FullWideAvg"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 


Proc corr data=cortest pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude Hazard _0to1Avg _1to2Avg _2to3Avg HT_0 HT_1 HT_2 HT_3 Freeze_Damage ;
run;
ods output Correlations=cortest;
quit;

/* outlier corr above 1 and 0 Below */
PROC IMPORT OUT= WORK.Lowcortest2  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="LowOutlierSams"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN; quit;
PROC IMPORT OUT= WORK.Highcortest3  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="HighOutlierSams"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 

/* No outlier sheet */
PROC IMPORT OUT= WORK.Midcortest4  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="NoOutliers"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 


Proc corr data=Lowcortest2 pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude _0to1Avg _1to2Avg _2to3Avg SurvAvg_1 SurvAvg_2 SurvAvg_3 Freeze_Damage HT_0 HT_1 HT_2 HT_3 ;
run;
ods output Correlations=Lowcortest2;

Proc corr data=Highcortest3 pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude Freeze_Damage _0to1Avg _1to2Avg _2to3Avg SurvAvg_1 SurvAvg_2 SurvAvg_3 HT_0 HT_1 HT_2 HT_3  ;
run;
ods output Correlations=Highcortest3;

/*no outliers corr test below */
Proc corr data=Midcortest4 pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude SurvAvg_1 SurvAvg_2 SurvAvg_3 Freeze_Damage _0to1Avg _1to2Avg _2to3Avg HT_0 HT_1 HT_2 HT_3 ;
run;
ods output Correlations=Midcortest4;




PROC IMPORT OUT= WORK.only9corr  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="9only"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 
Proc corr data=only9corr pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude Hazard _0to1Avg _1to2Avg _2to3Avg HT_0 HT_1 HT_2 HT_3 ;
run;
ods output Correlations=only9corr;

PROC IMPORT OUT= WORK.only15corr  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="15only"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 
Proc corr data=only15corr pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude Hazard _0to1Avg _1to2Avg _2to3Avg HT_0 HT_1 HT_2 HT_3 ;
run;
ods output Correlations=only15corr;
PROC IMPORT OUT= WORK.only12corr  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Correlation tests\FlaxGeoInfo.xlsx " /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="12only"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit; 
Proc corr data=only12corr pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude Hazard _0to1Avg _1to2Avg _2to3Avg HT_0 HT_1 HT_2 HT_3 ;
run;
ods output Correlations=only12corr;
