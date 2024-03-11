/* Code samples for Gossweiler et al., 2024 analyses */
/* Growth rate */
proc sort data=raw_data;
by Sample_Number rep treat Time;
run;
proc mixed cl covtest data=raw_data PLOTS=ResidualPanel(UNPACKBOX);
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

proc transreg data=raw_data plots=box;
model BoxCox (Total_HeightRegBrady) = class(rep treat treat*Time Time);
by Sample_Number;
run; 


%macro datatransform (sample, lambda);
data raw_data;
set raw_data;
if Sample_Number = &sample and &lambda ^= 0 then t_height=((Total_HeightRegBrady**(&lambda))-1)/&lambda;
run;
%mend;
%datatransform(1, 0.25); /* Begin Box-Cox tranformations based on residual plots above */
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

proc mixed cl covtest data=raw_data PLOTS=ResidualPanel(UNPACKBOX);
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


/* Survival analysis and curve development */
/* note: filter data for Time=3 only before proceeding */
proc phreg data=raw_data plots(overlay)=survival;
class Sample_Number(ref='45'); 
model treat*SurvivalRegulated(1)=Sample_Number / TIES=Efron;
baseline covariates=cox33 out=Estimate33 CUMHAZ=_ALL_ survival=_all_/ rowid=Sample_Number;
hazardratio Sample_Number / diff=DISTINCT cl=BOTH;
run;
quit;

/* correlation analysis */
Proc corr data=input_data_correlation pearson plots=scatter(nvar=all); 
 Var ElevationM Latitude Longitude _0to1Avg _1to2Avg _2to3Avg SurvAvg_1 SurvAvg_2 SurvAvg_3 Freeze_Damage HT_0 HT_1 HT_2 HT_3 ;
run;
