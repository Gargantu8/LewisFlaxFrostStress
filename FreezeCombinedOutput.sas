/* Height Data Analysis Start below */
PROC IMPORT OUT= WORK.height  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="V_DS_Final2"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit;
ods trace off;
ods select all/* exclude IntPlot (persist) BoxPlot (persist)*/;
ods listing close;
ods html path='C:\Users\Fleur\Documents\Thesis Files\Freeze Study\' file='HeightAnalysisAR.xls' style=default;

ods html file="Flax Height resid Analysis.htm" path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight\FixedResid" gpath="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight\FixedResid";

proc sort data=height;
by Sample_Number rep treat Time;
run;
proc mixed cl covtest data=height PLOTS=ResidualPanel(UNPACKBOX);
class rep treat Time;
model Total_HeightRegBrady = treat | Time /outp=resid2 ddfm=satterth; /* the | symbol will model model main effects and interactions (useful for 3way+ interactions.  outp tests residuals (ddfm determines degrees of freedom*/
random rep;
repeated Time/subject=rep*treat type=ar(1) rcorr; /* un ins unstuctured as the correlations between and amoung weeks may have different covariance?' */
by Sample_Number;
run;

/* Start box cox and shapiro wilks and boxcox below ##############################*/*//;
proc sort data=resid2;
by Sample_Number;
run;


proc univariate data=resid2 normal;
var resid;
by Sample_Number;
run;
quit;

/* Heritability For 2WP analysis and DOT  */ 
/* Not used in published article */
PROC IMPORT OUT= WORK.height  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="Sheet1"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit;
proc sort data=height;
by Accession rep ;
run;
proc mixed data =height;
class rep Accession;
model HeightDOT =  ;
random rep Accession;
run;
quit;
*/ End Heritability analysis /*

*/plotting the residual means DO NOT USE
ods html file="Flax Height Analysis2.htm" path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight" gpath="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight";
*proc means data=resid2; 
*class treat Time;
*var Resid;
*by Sample_Number;
*OUTPUT Out=resid2means MEAN=Average;
*run;

*title "Flax Height(in cm)";
*proc sgplot data=resid2means;
*xaxis type = discrete;
*series x=Time y=Average/ GROUP= treat;
*By Sample_Number;

*run;
*quit;
*/ ;

/*end Plotting Heritability */



ods html file="Flax Height TRANSresidAnalysis.htm" path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight\FixedResid" gpath="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight\FixedResid";
ods html path='C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SASHeight\FixedResid' file='HeightAnalysisARResidAdj.xls' style=default;
proc transreg data=height plots=box;
model BoxCox (Total_HeightRegBrady) = class(rep treat treat*Time Time);
by Sample_Number;
/*output out=height2;*/
run; 
/*proc sort data=height2;
by Sample_Number rep treat Time;
run;*/

%macro datatransform (sample, lambda);
data height;
set height;
if Sample_Number = &sample and &lambda ^= 0 then t_height=((Total_HeightRegBrady**(&lambda))-1)/&lambda;
run;
%mend;
%datatransform(1, 0.25); 
%datatransform(2,1);
%datatransform(3,1);
%datatransform(4,1.5);
%datatransform(5,0.75);
%datatransform(6,1.5);
%datatransform(7,0);
%datatransform(8,1);
%datatransform(9,1.25);
%datatransform(10,1);
%datatransform(11,0);
%datatransform(12,1.75);
%datatransform(13,0.5);
%datatransform(14,0.75)
%datatransform(15,0.75);
%datatransform(16,0.25);
%datatransform(17,0.75);
%datatransform(18,0.75);
%datatransform(19,1.25);
%datatransform(20,1);
%datatransform(21,0.75);
%datatransform(22,0.5);
%datatransform(23,0.75);
%datatransform(24,0.5);
%datatransform(25,0.5);
%datatransform(26,1);
%datatransform(27,0.75);
%datatransform(28,0.25);
%datatransform(29,1);
%datatransform(30,1.75);
%datatransform(31,1.5);
%datatransform(32,-0.5);
%datatransform(33,2.25);
%datatransform(34,0.75);
%datatransform(35,2);
%datatransform(36,0.75);
%datatransform(37,0.75);
%datatransform(38,0.5);
%datatransform(39,0);
%datatransform(40,1.25);
%datatransform(41,0.25);
%datatransform(42,0.25);
%datatransform(43,0.25);
%datatransform(44,2);
%datatransform(45,1.25);
%datatransform(46,1);

proc mixed cl covtest data=height PLOTS=ResidualPanel(UNPACKBOX);
class rep treat Time;
model t_height = treat | Time /outp=resid3 ddfm=satterth; /* the | symbol will model model main effects and interactions (useful for 3way+ interactions.  outp tests residuals (ddfm determines degrees of freedom*/
random rep;
repeated Time/subject=rep*treat type=ar(1) rcorr; /* un ins unstuctured as the correlations between and amoung weeks may have different covariance?' */
by Sample_Number;
run;
proc univariate data=resid3 normal plot;
var resid;
by Sample_Number;
probplot resid /normal noframe;
run;

quit;

/* end box cox */


/*proc transpose data= height out=height_wide(drop=_name_ _LABEL_);
by Sample_Number rep treat;
var Total_HeightRegBrady;
id Time;
run;*/


/* Data transformation steps for height avg plots in R. Input file can be made from R code found in parent folder */
PROC IMPORT OUT= WORK.HeightAvg  /* SAS dataset name */
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\HeightAvg.xlsx" /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="Sheet1"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit;
proc sort data = Heightavg;
by Sample_Number treat Time;
run;
proc transpose data = Heightavg out=Heightavg_wide(drop=_name_ _LABEL_);
by Sample_Number treat;
var Total_HeightRegBrady;
id Time;
run;
proc export data=Heightavg_wide
outfile="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\Heightavg_wide.csv" /* input data set filepath */
            DBMS=csv 
replace; run;
/* end data transformation steps*/

/* End Height Data Analysis */





/* Survival Data Analysis  start below*/

/*Mixed model data analysis Did not use as switched to cox phreg model*/
/*PROC IMPORT OUT= WORK.survival  /* SAS dataset name */
  /*          DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
    /*        DBMS=XLSX REPLACE;
     SHEET="Vert_HeightSomeBlanks"; /* input dataset tab in excel sheet */
    /* GETNAMES=YES;
RUN;
quit;
proc sort data = survival;
by Sample_Number rep treat Time;
run;
/*for wide survival data, only use to better check raw data for errors. start transpose below until "run." 
proc transpose data = survival out=survival_wide(drop=_name_ _LABEL_);
by Sample_Number rep treat;
var SurvivalRegulated;
id Time;
run;
*/
/* proc glimmix data = survival;
class treat Sample_Number rep Time; /*discrete input variables*/
/* model SurvivalRegulated (Descending) = Sample_Number treat Sample_Number*treat / dist=binary ddfm=satherth;
random rep;
random Time/ type=ar(1) subject=Sample_Number*treat*rep;
run;
quit;
*/


/* Start Cox survival data analysis below ####################################3*/

data work.cox;
infile "/Users\Fleur\Documents\Thesis Files\Freeze Study\trialcoxNO.csv"
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
            DATAFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="V_DS_Final"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit;
/*ods html path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SurvivalSAS\Final draft\" style=default;
quit; */
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
ods excel file="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SurvivalSAS\Final draft\SurvivalCoxSummaryCUMHAZref45EfronFinal.xlsx";/* html path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SurvivalSAS\Final draft\" file="SurvivalCoxSummaryCUMHAZref45.xlsx" style=default; */

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
            OUTFILE= "C:\Users\Fleur\Documents\Thesis Files\Freeze Study                                                                
\SurvivalSAS\survandcumhazNOoutliers.xls"                                                                                                                   
            DBMS=EXCEL LABEL REPLACE;                                                                                                   
     SHEET="Cox";                                                                                                                       
RUN;     */


/*ods html path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SurvivalSAS\Final draft" file='SurvivalCoxSummaryCUMHAZref45.xlsx' style=default; */
/* End Survival Data Analysis */ 

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


/* For setting without reference of Maple Grove sample '45'  below    */
ods html path="C:\Users\Fleur\Documents\Thesis Files\Freeze Study\SurvivalSAS\" file='SurvivalCoxSummaryCUMHAZnoREF.xls' style=minimal;
data cox;
set cox (drop=rep Freeze_Damage);
run;
proc sort data=cox;
by Time;
run;
data cox2;
set cox (drop=treat);
run;

proc phreg data=cox plots(overlay)=survival;
class Sample_Number;
model treat*SurvivalRegulated(1)=Sample_Number;
baseline covariates=cox2 out=Estimate3 CUMHAZ=_ALL_ survival=_all_/ rowid=Sample_Number;
hazardratio Sample_Number / diff=DISTINCT cl=BOTH;
by Time;
run;
proc print data=Estimate3;
run;
quit;

