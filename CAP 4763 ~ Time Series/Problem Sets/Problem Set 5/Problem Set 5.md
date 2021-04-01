**Problem Set 5**

**Gus Lipkin**

**CAP 4763 Time Series Modelling and Forecasting**



# Table of Contents

|                           Section                            |
| :----------------------------------------------------------: |
|            [**3 Static Model**](#3-Static-Model)             |
|                          [3a](#3a)                           |
|                          [3b](#3b)                           |
|                          [3c](#3c)                           |
|                          [3d](#3d)                           |
|                          [3e](#3e)                           |
| [**4 Finite Distributed Lag Model**](#4-Finite-Distributed-Lag-Model) |
|                          [4a](#4a)                           |
|                          [4b](#4b)                           |
|                          [4d](#4d)                           |
|                          [4e](#4e)                           |
|                [**Appendix A**](#Appendix-A)                 |
|                [**Appendix B**](#Appendix-B)                 |

<div style="page-break-after: always; break-after: page;"></div>

# Introduction

blah blah blah

# GSREG, Rolling Window, and Choosing Models

> 3-6

## GSREG

​	Because GSREG runs through every possible combination of variables fed to it up to a maximum number of variables per regression, it is necessary to limit the number of variables. How these variables are chosen is up to the person running the analysis. When I ran mine, I decided to include the first, third, sixth, ninth, twelfth, and twenty-fourth lags of each differenced variable for `lnflnonfarm`, `lnfllf`,  and `lnusepr`. I also fixed the monthly indicators for January, March, June, and September. I chose to include all variables because while one variable may not have as heavy an influence, it is important to consider everything and conduct an analysis before dismissing any variables. I chose the lags and monthly indicators I did because while the data is monthly, I wanted to reduce the amount of variations that GSREG needs to go through without removing too many data points and without keeping too many variables that would cause the command to take too long to run. As for the twenty-fourth lag, I thought that there was a chance that long-term change would provide a grounding-point for the model.

# Using the Best Model to Forecast January 2020

> 7



# Point and Interval Forecasts

> 8



# Illustrations and Interpretations of the Models

> 9-10



# Conclusion



<div style="page-break-after: always; break-after: page;"></div>

# Appendix A (Code)

```
clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 5"
import delimited "Assignment_1_Monthly.txt"

rename lnu02300000 us_epr
rename flnan fl_nonfarm
rename fllfn fl_lf
rename flbppriv fl_bp
rename date datestring

log using "Problem Set 5", replace

gen datec=date(datestring, "YMD")
gen date=mofd(datec)
gen month=month(datec)
format date %tm

tsset date

gen lnusepr=log(us_epr)
gen lnflnonfarm=log(fl_nonfarm)
gen lnfllf=log(fl_lf)
gen lnflbp=log(fl_bp)

*1
drop if !tin(1990m1,2019m12)

*2
tsset date
tsappend, add(1)
replace month=month(dofm(date)) if month==.

*3
gen m1=0
replace m1=1 if month==1
gen m2=0
replace m2=1 if month==2
gen m3=0
replace m3=1 if month==3
gen m4=0
replace m4=1 if month==4
gen m5=0
replace m5=1 if month==5
gen m6=0
replace m6=1 if month==6
gen m7=0
replace m7=1 if month==7
gen m8=0
replace m8=1 if month==8
gen m9=0
replace m9=1 if month==9
gen m10=0
replace m10=1 if month==10
gen m11=0
replace m11=1 if month==11

gen dlnflnonfarm=d.lnflnonfarm
gen l1dlnflnonfarm=l1d.lnflnonfarm
gen l2dlnflnonfarm=l2d.lnflnonfarm
gen l3dlnflnonfarm=l3d.lnflnonfarm
gen l4dlnflnonfarm=l4d.lnflnonfarm
gen l5dlnflnonfarm=l5d.lnflnonfarm
gen l6dlnflnonfarm=l6d.lnflnonfarm
gen l7dlnflnonfarm=l7d.lnflnonfarm
gen l8dlnflnonfarm=l8d.lnflnonfarm
gen l9dlnflnonfarm=l9d.lnflnonfarm
gen l10dlnflnonfarm=l10d.lnflnonfarm
gen l11dlnflnonfarm=l11d.lnflnonfarm
gen l12dlnflnonfarm=l12d.lnflnonfarm
gen l24dlnflnonfarm=l24d.lnflnonfarm

gen dlnfllf=d.lnfllf
gen l1dlnfllf=l1d.lnfllf
gen l2dlnfllf=l2d.lnfllf
gen l3dlnfllf=l3d.lnfllf
gen l4dlnfllf=l4d.lnfllf
gen l5dlnfllf=l5d.lnfllf
gen l6dlnfllf=l6d.lnfllf
gen l7dlnfllf=l7d.lnfllf
gen l8dlnfllf=l8d.lnfllf
gen l9dlnfllf=l9d.lnfllf
gen l10dlnfllf=l10d.lnfllf
gen l11dlnfllf=l11d.lnfllf
gen l12dlnfllf=l12d.lnfllf
gen l24dlnfllf=l24d.lnfllf

gen dlnusepr=d.lnusepr
gen l1dlnusepr=l1d.lnusepr
gen l2dlnusepr=l2d.lnusepr
gen l3dlnusepr=l3d.lnusepr
gen l4dlnusepr=l4d.lnusepr
gen l5dlnusepr=l5d.lnusepr
gen l6dlnusepr=l6d.lnusepr
gen l7dlnusepr=l7d.lnusepr
gen l8dlnusepr=l8d.lnusepr
gen l9dlnusepr=l9d.lnusepr
gen l10dlnusepr=l10d.lnusepr
gen l11dlnusepr=l11d.lnusepr
gen l12dlnusepr=l12d.lnusepr
gen l24dlnusepr=l24d.lnusepr


gsreg dlnflnonfarm l1dlnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l9dlnflnonfarm ///
      l12dlnflnonfarm l24dlnflnonfarm ///
	  l1dlnfllf l3dlnfllf l6dlnfllf l9dlnfllf ///
      l12dlnfllf l24dlnfllf ///
	  l1dlnusepr l3dlnusepr l6dlnusepr l9dlnusepr ///
      l12dlnusepr l24dlnusepr if tin(1990m1,2019m12), ///
	ncomb(1,6) aic outsample(24) fix(m1 m3 m6 m9) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnrer) replace


*5
/* 
Best model
reg dlnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm 
	l24dlnfllf l6dlnusepr m1 m3 m6 m9
*/
scalar drop _all
quietly forval w=48(12)144 {
gen pred=.
gen nobs=.
	forval t=529/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l3d.lnflnonfarm l6d.lnflnonfarm l12d.lnflnonfarm l24d.lnflnonfarm ///
		l24d.lnfllf l6d.lnusepr m1 m3 m6 m9 ///
		if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnflnonfarm)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs108 = 108 
RWminobs108 = 108 
RWrmse108 = .00388844
*/

/*
Smallest / best model
reg dlnflnonfarm l12dlnflnonfarm m1 m3 m6 m9
*/
scalar drop _all
quietly forval w=48(12)144 {
gen pred=.
gen nobs=.
	forval t=529/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnflnonfarm l12dlnflnonfarm m1 m3 m6 m9 ///
		if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnflnonfarm)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs120 = 120 
RWminobs120 = 120 
RWrmse120 = .00423688

*/

/*
Best medium length model
reg dlnflnonfarm l3dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm l6dlnusepr
	m1 m3 m6 m9
*/
scalar drop _all
quietly forval w=48(12)144 {
gen pred=.
gen nobs=.
	forval t=529/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnflnonfarm l3dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm l6dlnusepr ///
		m1 m3 m6 m9 ///
		if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnflnonfarm)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs108 = 108 
RWminobs108 = 108 
RWrmse108 = .00406403
*/

*6
/*
RWmaxobs108 = 108 
RWminobs108 = 108 
RWrmse108 = .00388844
*/
scalar drop _all
quietly forval w=156(12)156 {
gen pred=.
gen nobs=.
	forval t=432/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l3d.lnflnonfarm l6d.lnflnonfarm l12d.lnflnonfarm l24d.lnflnonfarm ///
		l24d.lnfllf l6d.lnusepr m1 m3 m6 m9 ///
		if date>=wstart & date<=wend
	replace nobs=e(N) if date==`t'
	predict ptemp
	replace pred=ptemp if date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnflnonfarm)^2
}
summ nobs // checking all had a full window
*get error info for normal interval
summ errsq
scalar rwrmse=r(mean)^0.5
scalar list rwrmse
gen res=(d.lnflnonfarm-pred)
_pctile res, percentile(2.5,97.5)
return list

*8
*Normal
predict temp if tin(2020m1,2020m1)
replace pred=temp if tin(2020m1,2020m1)
drop temp
gen pnonfarm=exp(l.lnflnonfarm+pred+(rwrmse^2)/2)
gen ubound=exp(l.lnflnonfarm+pred+1.96*rwrmse+(rwrmse^2)/2)
gen lbound=exp(l.lnflnonfarm+pred-1.96*rwrmse+(rwrmse^2)/2)
list month pnonfarm lbound ubound if tin(2020m1,2020m1)
tsline pnonfarm lbound ubound fl_nonfarm if tin(2019m1,2020m1), tline(2019m12) saving("Nonfarm_Normal", replace)

*Empirical
drop res
gen res=(d.lnflnonfarm-pred)
gen expres=exp(res)
summ expres
scalar meanexpres=r(mean)
gen pnonfarme=exp(l.lnflnonfarm+pred)*meanexpres
_pctile res, percentile(2.5,97.5)
return list
gen lbounde=exp(l.lnflnonfarm+pred+r(r1))*meanexpres
gen ubounde=exp(l.lnflnonfarm+pred+r(r2))*meanexpres
list month pnonfarme lbounde ubounde if tin(2020m1,2020m1)
tsline pnonfarme lbounde ubounde fl_nonfarm if tin(2019m1,2020m1), ///
	tline(2019m12) saving("Nonfarm_Epirical", replace)

*9	
tsline pnonfarm pnonfarme fl_nonfarm lbound lbounde ubound ubounde ///
 if tin(2019m1,2020m1), tline(2019m12) saving("Normal_vs_Empirical", replace)
 
translate "Problem Set 5.smcl" "Problem Set 5.txt", replace
log close
```

<div style="page-break-after: always; break-after: page;"></div>

# Appendix B (STATA Output)

```
                                                       ___  ____  ____  ____  ____(R)
                                                      /__    /   ____/   /   ____/   
                                                     ___/   /   /___/   /   /___/    
                                                       Statistics/Data analysis      
      
      -------------------------------------------------------------------------------
            name:  <unnamed>
             log:  /Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Probl
      > em Sets/Problem Set 5/Problem Set 5.smcl
        log type:  smcl
       opened on:  31 Mar 2021, 19:29:06
      
     1 . 
     2 . gen datec=date(datestring, "YMD")
      
     3 . gen date=mofd(datec)
      
     4 . gen month=month(datec)
      
     5 . format date %tm
      
     6 . 
     7 . tsset date
              time variable:  date, 1939m1 to 2020m12
                      delta:  1 month
      
     8 . 
     9 . gen lnusepr=log(us_epr)
      (108 missing values generated)
      
    10 . gen lnflnonfarm=log(fl_nonfarm)
      
    11 . gen lnfllf=log(fl_lf)
      (444 missing values generated)
      
    12 . gen lnflbp=log(fl_bp)
      (588 missing values generated)
      
    13 . 
    14 . *1
    15 . drop if !tin(1990m1,2019m12)
      (624 observations deleted)
      
    16 . 
    17 . *2
    18 . tsset date
              time variable:  date, 1990m1 to 2019m12
                      delta:  1 month
      
    19 . tsappend, add(1)
      
    20 . replace month=month(dofm(date)) if month==.
      (1 real change made)
      
    21 . 
    22 . *3
    23 . gen m1=0
      
    24 . replace m1=1 if month==1
      (31 real changes made)
      
    25 . gen m2=0
      
    26 . replace m2=1 if month==2
      (30 real changes made)
      
    27 . gen m3=0
      
    28 . replace m3=1 if month==3
      (30 real changes made)
      
    29 . gen m4=0
      
    30 . replace m4=1 if month==4
      (30 real changes made)
      
    31 . gen m5=0
      
    32 . replace m5=1 if month==5
      (30 real changes made)
      
    33 . gen m6=0
      
    34 . replace m6=1 if month==6
      (30 real changes made)
      
    35 . gen m7=0
      
    36 . replace m7=1 if month==7
      (30 real changes made)
      
    37 . gen m8=0
      
    38 . replace m8=1 if month==8
      (30 real changes made)
      
    39 . gen m9=0
      
    40 . replace m9=1 if month==9
      (30 real changes made)
      
    41 . gen m10=0
      
    42 . replace m10=1 if month==10
      (30 real changes made)
      
    43 . gen m11=0
      
    44 . replace m11=1 if month==11
      (30 real changes made)
      
    45 . 
    46 . gen dlnflnonfarm=d.lnflnonfarm
      (2 missing values generated)
      
    47 . gen l1dlnflnonfarm=l1d.lnflnonfarm
      (2 missing values generated)
      
    48 . gen l2dlnflnonfarm=l2d.lnflnonfarm
      (3 missing values generated)
      
    49 . gen l3dlnflnonfarm=l3d.lnflnonfarm
      (4 missing values generated)
      
    50 . gen l4dlnflnonfarm=l4d.lnflnonfarm
      (5 missing values generated)
      
    51 . gen l5dlnflnonfarm=l5d.lnflnonfarm
      (6 missing values generated)
      
    52 . gen l6dlnflnonfarm=l6d.lnflnonfarm
      (7 missing values generated)
      
    53 . gen l7dlnflnonfarm=l7d.lnflnonfarm
      (8 missing values generated)
      
    54 . gen l8dlnflnonfarm=l8d.lnflnonfarm
      (9 missing values generated)
      
    55 . gen l9dlnflnonfarm=l9d.lnflnonfarm
      (10 missing values generated)
      
    56 . gen l10dlnflnonfarm=l10d.lnflnonfarm
      (11 missing values generated)
      
    57 . gen l11dlnflnonfarm=l11d.lnflnonfarm
      (12 missing values generated)
      
    58 . gen l12dlnflnonfarm=l12d.lnflnonfarm
      (13 missing values generated)
      
    59 . gen l24dlnflnonfarm=l24d.lnflnonfarm
      (25 missing values generated)
      
    60 . 
    61 . gen dlnfllf=d.lnfllf
      (2 missing values generated)
      
    62 . gen l1dlnfllf=l1d.lnfllf
      (2 missing values generated)
      
    63 . gen l2dlnfllf=l2d.lnfllf
      (3 missing values generated)
      
    64 . gen l3dlnfllf=l3d.lnfllf
      (4 missing values generated)
      
    65 . gen l4dlnfllf=l4d.lnfllf
      (5 missing values generated)
      
    66 . gen l5dlnfllf=l5d.lnfllf
      (6 missing values generated)
      
    67 . gen l6dlnfllf=l6d.lnfllf
      (7 missing values generated)
      
    68 . gen l7dlnfllf=l7d.lnfllf
      (8 missing values generated)
      
    69 . gen l8dlnfllf=l8d.lnfllf
      (9 missing values generated)
      
    70 . gen l9dlnfllf=l9d.lnfllf
      (10 missing values generated)
      
    71 . gen l10dlnfllf=l10d.lnfllf
      (11 missing values generated)
      
    72 . gen l11dlnfllf=l11d.lnfllf
      (12 missing values generated)
      
    73 . gen l12dlnfllf=l12d.lnfllf
      (13 missing values generated)
      
    74 . gen l24dlnfllf=l24d.lnfllf
      (25 missing values generated)
      
    75 . 
    76 . gen dlnusepr=d.lnusepr
      (2 missing values generated)
      
    77 . gen l1dlnusepr=l1d.lnusepr
      (2 missing values generated)
      
    78 . gen l2dlnusepr=l2d.lnusepr
      (3 missing values generated)
      
    79 . gen l3dlnusepr=l3d.lnusepr
      (4 missing values generated)
      
    80 . gen l4dlnusepr=l4d.lnusepr
      (5 missing values generated)
      
    81 . gen l5dlnusepr=l5d.lnusepr
      (6 missing values generated)
      
    82 . gen l6dlnusepr=l6d.lnusepr
      (7 missing values generated)
      
    83 . gen l7dlnusepr=l7d.lnusepr
      (8 missing values generated)
      
    84 . gen l8dlnusepr=l8d.lnusepr
      (9 missing values generated)
      
    85 . gen l9dlnusepr=l9d.lnusepr
      (10 missing values generated)
      
    86 . gen l10dlnusepr=l10d.lnusepr
      (11 missing values generated)
      
    87 . gen l11dlnusepr=l11d.lnusepr
      (12 missing values generated)
      
    88 . gen l12dlnusepr=l12d.lnusepr
      (13 missing values generated)
      
    89 . gen l24dlnusepr=l24d.lnusepr
      (25 missing values generated)
      
    90 . 
    91 . 
    92 . gsreg dlnflnonfarm l1dlnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l9dlnflnonfar
      > m ///
      >       l12dlnflnonfarm l24dlnflnonfarm ///
      >           l1dlnfllf l3dlnfllf l6dlnfllf l9dlnfllf ///
      >       l12dlnfllf l24dlnfllf ///
      >           l1dlnusepr l3dlnusepr l6dlnusepr l9dlnusepr ///
      >       l12dlnusepr l24dlnusepr if tin(1990m1,2019m12), ///
      >         ncomb(1,6) aic outsample(24) fix(m1 m3 m6 m9) ///
      >         samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnrer) r
      > eplace
      ----------------------------------------------------
      Total Number of Estimations: 31179
      ----------------------------------------------------
      ----------------------------------------------------
      Warning: Estimation could take about 10 minutes 
      ----------------------------------------------------
       
      Computing combinations...
      Preparing regression list...
      Doing regressions...
      Saving results...
      file gsreg_dlnrer.dta saved
      ----------------------------------------------------
      Best estimation in terms of -1 aic -1 bic -1 rmse_out 
      Estimation number 19215
      ----------------------------------------------------
      
            Source |       SS           df       MS      Number of obs   =       312
      -------------+----------------------------------   F(10, 301)      =    192.38
             Model |  .027480005        10     .002748   Prob > F        =    0.0000
          Residual |  .004299465       301  .000014284   R-squared       =    0.8647
      -------------+----------------------------------   Adj R-squared   =    0.8602
             Total |   .03177947       311  .000102185   Root MSE        =    .00378
      
      -------------------------------------------------------------------------------
      --
         dlnflnonfarm |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interva
      > l]
      ----------------+--------------------------------------------------------------
      --
                   m1 |  -.0068526   .0013736    -4.99   0.000    -.0095558   -.00414
      > 94
                   m3 |   .0009126   .0008591     1.06   0.289    -.0007781    .00260
      > 33
                   m6 |  -.0044233   .0010173    -4.35   0.000    -.0064252   -.00242
      > 14
                   m9 |  -.0008321   .0008569    -0.97   0.332    -.0025184    .00085
      > 41
       l3dlnflnonfarm |   .0992292   .0282426     3.51   0.001     .0436512    .15480
      > 71
       l6dlnflnonfarm |   .0741191   .0284776     2.60   0.010     .0180786    .13015
      > 96
      l12dlnflnonfarm |   .5446389    .067997     8.01   0.000     .4108292    .67844
      > 87
      l24dlnflnonfarm |   .1684682   .0598024     2.82   0.005     .0507844     .2861
      > 52
           l24dlnfllf |  -.1553647   .0508596    -3.05   0.002    -.2554501   -.05527
      > 93
           l6dlnusepr |   .1231808   .0528785     2.33   0.020     .0191224    .22723
      > 92
                _cons |   .0014172   .0003147     4.50   0.000     .0007979    .00203
      > 65
      -------------------------------------------------------------------------------
      --
      
    93 . 
      end of do-file
      
    94 . do "/var/folders/2l/fbt5472n7ks1xr82m33g3shw0000gn/T//SD13269.000000"
      
    95 . *5
    96 . /* 
      > Best model
      > reg dlnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l12dlnflnonfarm l24dlnflnonfar
      > m 
      >         l24dlnfllf l6dlnusepr m1 m3 m6 m9
      > */
    97 . scalar drop _all
      
    98 . quietly forval w=48(12)144 {
      
    99 . scalar list
      RWmaxobs144 =        144
      RWminobs144 =        144
       RWrmse144 =  .00396645
      RWmaxobs132 =        132
      RWminobs132 =        132
       RWrmse132 =  .00390407
      RWmaxobs120 =        120
      RWminobs120 =        120
       RWrmse120 =  .00388926
      RWmaxobs108 =        108
      RWminobs108 =        108
       RWrmse108 =  .00388844
      RWmaxobs96 =         96
      RWminobs96 =         96
        RWrmse96 =  .00403691
      RWmaxobs84 =         84
      RWminobs84 =         84
        RWrmse84 =  .00406426
      RWmaxobs72 =         72
      RWminobs72 =         72
        RWrmse72 =  .00411873
      RWmaxobs60 =         60
      RWminobs60 =         60
        RWrmse60 =  .00431692
      RWmaxobs48 =         48
      RWminobs48 =         48
        RWrmse48 =  .00460352
      
   100 . /*
      > RWmaxobs108 = 108 
      > RWminobs108 = 108 
      > RWrmse108 = .00388844
      > */
   101 . 
   102 . /*
      > Smallest / best model
      > reg dlnflnonfarm l12dlnflnonfarm m1 m3 m6 m9
      > */
   103 . scalar drop _all
      
   104 . quietly forval w=48(12)144 {
      
   105 . scalar list
      RWmaxobs144 =        144
      RWminobs144 =        144
       RWrmse144 =  .00431666
      RWmaxobs132 =        132
      RWminobs132 =        132
       RWrmse132 =  .00426742
      RWmaxobs120 =        120
      RWminobs120 =        120
       RWrmse120 =  .00423688
      RWmaxobs108 =        108
      RWminobs108 =        108
       RWrmse108 =  .00428159
      RWmaxobs96 =         96
      RWminobs96 =         96
        RWrmse96 =  .00436091
      RWmaxobs84 =         84
      RWminobs84 =         84
        RWrmse84 =  .00439555
      RWmaxobs72 =         72
      RWminobs72 =         72
        RWrmse72 =  .00443487
      RWmaxobs60 =         60
      RWminobs60 =         60
        RWrmse60 =  .00453048
      RWmaxobs48 =         48
      RWminobs48 =         48
        RWrmse48 =  .00458215
      
   106 . /*
      > RWmaxobs120 = 120 
      > RWminobs120 = 120 
      > RWrmse120 = .00423688
      > 
      > */
   107 . 
   108 . /*
      > Best medium length model
      > reg dlnflnonfarm l3dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm l6dlnusepr
      >         m1 m3 m6 m9
      > */
   109 . scalar drop _all
      
   110 . quietly forval w=48(12)144 {
      
   111 . scalar list
      RWmaxobs144 =        144
      RWminobs144 =        144
       RWrmse144 =  .00412303
      RWmaxobs132 =        132
      RWminobs132 =        132
       RWrmse132 =  .00407538
      RWmaxobs120 =        120
      RWminobs120 =        120
       RWrmse120 =  .00406735
      RWmaxobs108 =        108
      RWminobs108 =        108
       RWrmse108 =  .00406403
      RWmaxobs96 =         96
      RWminobs96 =         96
        RWrmse96 =  .00419684
      RWmaxobs84 =         84
      RWminobs84 =         84
        RWrmse84 =  .00423362
      RWmaxobs72 =         72
      RWminobs72 =         72
        RWrmse72 =  .00429113
      RWmaxobs60 =         60
      RWminobs60 =         60
        RWrmse60 =  .00448591
      RWmaxobs48 =         48
      RWminobs48 =         48
        RWrmse48 =  .00478837
      
   112 . /*
      > RWmaxobs108 = 108 
      > RWminobs108 = 108 
      > RWrmse108 = .00406403
      > */
   113 . 
   114 . *6
   115 . /*
      > RWmaxobs108 = 108 
      > RWminobs108 = 108 
      > RWrmse108 = .00388844
      > */
   116 . scalar drop _all
      
   117 . quietly forval w=156(12)156 {
      
   118 . summ nobs // checking all had a full window
      
          Variable |        Obs        Mean    Std. Dev.       Min        Max
      -------------+---------------------------------------------------------
              nobs |        289    135.2561    32.98122         47        156
      
   119 . *get error info for normal interval
   120 . summ errsq
      
          Variable |        Obs        Mean    Std. Dev.       Min        Max
      -------------+---------------------------------------------------------
             errsq |        288     .000015    .0000471   1.10e-12   .0005431
      
   121 . scalar rwrmse=r(mean)^0.5
      
   122 . scalar list rwrmse
          rwrmse =  .00387308
      
   123 . gen res=(d.lnflnonfarm-pred)
      (73 missing values generated)
      
   124 . _pctile res, percentile(2.5,97.5)
      
   125 . return list
      
      scalars:
                       r(r1) =  -.0074653569608927
                       r(r2) =  .0065394379198551
      
   126 . 
   127 . *8
   128 . *Normal
   129 . predict temp if tin(2020m1,2020m1)
      (option xb assumed; fitted values)
      (360 missing values generated)
      
   130 . replace pred=temp if tin(2020m1,2020m1)
      (0 real changes made)
      
   131 . drop temp
      
   132 . gen pnonfarm=exp(l.lnflnonfarm+pred+(rwrmse^2)/2)
      (72 missing values generated)
      
   133 . gen ubound=exp(l.lnflnonfarm+pred+1.96*rwrmse+(rwrmse^2)/2)
      (72 missing values generated)
      
   134 . gen lbound=exp(l.lnflnonfarm+pred-1.96*rwrmse+(rwrmse^2)/2)
      (72 missing values generated)
      
   135 . list month pnonfarm lbound ubound if tin(2020m1,2020m1)
      
           +----------------------------------------+
           | month   pnonfarm     lbound     ubound |
           |----------------------------------------|
      361. |     1   9001.077   8933.007   9069.667 |
           +----------------------------------------+
      
   136 . tsline pnonfarm lbound ubound fl_nonfarm if tin(2019m1,2020m1), tline(2019m12
      > ) saving("Nonfarm_Normal", replace)
      (file Nonfarm_Normal.gph saved)
      
   137 . 
   138 . *Empirical
   139 . drop res
      
   140 . gen res=(d.lnflnonfarm-pred)
      (73 missing values generated)
      
   141 . gen expres=exp(res)
      (73 missing values generated)
      
   142 . summ expres
      
          Variable |        Obs        Mean    Std. Dev.       Min        Max
      -------------+---------------------------------------------------------
            expres |        288    .9997746    .0038735   .9777296   1.023579
      
   143 . scalar meanexpres=r(mean)
      
   144 . gen pnonfarme=exp(l.lnflnonfarm+pred)*meanexpres
      (72 missing values generated)
      
   145 . _pctile res, percentile(2.5,97.5)
      
   146 . return list
      
      scalars:
                       r(r1) =  -.0074653569608927
                       r(r2) =  .0065394379198551
      
   147 . gen lbounde=exp(l.lnflnonfarm+pred+r(r1))*meanexpres
      (72 missing values generated)
      
   148 . gen ubounde=exp(l.lnflnonfarm+pred+r(r2))*meanexpres
      (72 missing values generated)
      
   149 . list month pnonfarme lbounde ubounde if tin(2020m1,2020m1)
      
           +----------------------------------------+
           | month   pnonfa~e    lbounde    ubounde |
           |----------------------------------------|
      361. |     1   8998.981   8932.051   9058.022 |
           +----------------------------------------+
      
   150 . tsline pnonfarme lbounde ubounde fl_nonfarm if tin(2019m1,2020m1), ///
      >         tline(2019m12) saving("Nonfarm_Epirical", replace)
      (file Nonfarm_Epirical.gph saved)
      
   151 . 
   152 . *9      
   153 . tsline pnonfarm pnonfarme fl_nonfarm lbound lbounde ubound ubounde ///
      >  if tin(2019m1,2020m1), tline(2019m12) saving("Normal_vs_Empirical", replace)
      (file Normal_vs_Empirical.gph saved)
      
   154 .  
```

