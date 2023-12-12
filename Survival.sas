/* Survival Data Analysis  start below*/

/* Start Cox survival data analysis below ####################################3*/

data work.cox;
infile "/Users\Freeze Study\trialcoxNO.csv"
delimiter = ","
missover
dsd
firstobs = 2;

format Cell_Number best12.;
format Sample_Number best12.;
format treat best12.;
format rep best12.;
format SurvivalRegulated best12.;
format Time best12.;

input
Cell_Number $
Sample_Number $
treat $
rep $
SurvivalRegulated $
Time $;

run;

data cox;
set cox;
if Sample_Number="20" then delete;
if Sample_Number="26" then delete;
if Sample_Number="28" then delete;
if Sample_Number="46" then delete;
run;

/*alternative data input Below ######################## 20 26 28 46 already removed from V_DS_Final  ########################*/

PROC IMPORT OUT= WORK.cox  /* SAS dataset name */
            DATAFILE= "C:\Users\Freeze Study\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="V_DS_Final"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit;

data cox;
set cox (drop=rep Freeze_Damage);
run;
proc sort data=cox;
by Time;
run;
data cox2;
set cox (drop=treat);
run;

ods graphics on;
ods excel file="C:\Users\Freeze Study\SurvivalSAS\SurvivalCoxSummaryCUMHAZref45EfronFinal.xlsx";

proc phreg data=cox plots(overlay)=survival;
class Sample_Number(ref='45'); /* rep treat Time PARAM=GLM; */
model treat*SurvivalRegulated(1)=Sample_Number / TIES=Efron;
/*id Sample_Number treat;*/
/* id statement specifies additional variables for identifying observations in the input data and are placed in the out= dataset */
baseline covariates=cox2 out=Estimate3 CUMHAZ=_ALL_ survival=_all_/ rowid=Sample_Number;
hazardratio Sample_Number / diff=DISTINCT cl=BOTH;
by Time;
/* should I consider using the /diradj group= instead of row id "particularly useful  if the model contains a cateforical explanatory variable that represents different treatments of interest" */
/* diradj group=Sample_Number */
/* no we don't */
run;
/* proc print data=Estimate3;
run; */
proc sort data=Estimate3;
by Sample_Number treat Survival Time;
run;
ods excel close;
quit;

/*pull unique rows to eliminate the repeated data. */
data first_unique_rows;
set Estimate3;
by Sample_Number treat Survival Time;
if first.Survival and first.Time; run; 

proc sort data=first_unique_rows;
by Sample_Number Time;
run;

data first_unique_rows;
set first_unique_rows (drop=Total_Dead_Stems Total_Stems Total_HeightRegBrady);
run;

/*PROC EXPORT DATA= WORK.first_unique_rows                                                                                                              
            OUTFILE= "C:\Users\Freeze Study                                                              
\SurvivalSAS\survandcumhazNOoutliers.xls"                                                                                                                   
            DBMS=EXCEL LABEL REPLACE;                                                                                                   
     SHEET="Cox";                                                                                                                       
RUN;     */


/*ods html path="~\Final draft" file='SurvivalCoxSummaryCUMHAZref45.xlsx' style=default; */
/* End Survival Data Analysis */ 
