/* Height Data Analysis Start below */
PROC IMPORT OUT= WORK.height  /* SAS dataset name */
            DATAFILE= "~\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
            DBMS=XLSX REPLACE;
     SHEET="V_DS_Final2"; /* input dataset tab in excel sheet */
     GETNAMES=YES;
RUN;
quit;
ods trace off;
ods select all/* exclude IntPlot (persist) BoxPlot (persist)*/;
ods listing close;
ods html path='~\Freeze Study\' file='HeightAnalysisAR.xls' style=default;

ods html file="Flax Height resid Analysis.htm" path="~\FixedResid" gpath="~\FixedResid";

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
            DATAFILE= "~\FlaxFreezeForAnalysis.xlsx" /* input data set filepath */
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


ods html path='~FixedResid' file='HeightAnalysisARResidAdj.xls' style=default;
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
repeated Time/subject=rep*treat type=ar(1) rcorr;
by Sample_Number;
run;
proc univariate data=resid3 normal plot;
var resid;
by Sample_Number;
probplot resid /normal noframe;
run;

quit;

/* end box cox */


/* Data transformation steps for height avg plots in R. Input file can be made from R code found in parent folder */
PROC IMPORT OUT= WORK.HeightAvg  /* SAS dataset name */
            DATAFILE= "~\HeightAvg.xlsx" /* input data set filepath */
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
outfile="~\Heightavg_wide.csv" /* input data set filepath */
            DBMS=csv 
replace; run;
/* end data transformation steps*/
