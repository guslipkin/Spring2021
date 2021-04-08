# Final Project Deliverable 2

## Number of Employees

```
reg d.lnCount l(12,24,36,48)d.lnCount // .01637
scalar drop _all
quietly forval w=12(12)144 {
gen pred=.
gen nobs=.
	forval t=421/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l12dlnCount l24dlnCount l36dlnCount l48dlnCount ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs132 =        132
RWminobs132 =         12
RWrmse132 =   .0172128
*/
```

```
reg d.lnCount l(12,36)d.lnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=12(12)144 {
gen pred=.
gen nobs=.
	forval t=409/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l12dlnCount l36dlnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs144 =        144
RWminobs144 =         12
RWrmse144 =  .01777071
*/
```

I'm debating between the two. I'm also not sure if I should try and find another one that has more explanatory variables.

## Weekly Earnings

```
reg d.lnWeeklyEarnings l3d.lnWeeklyEarnings l5d.lnWeeklyEarnings l7d.lnWeeklyEarnings
scalar drop _all
quietly forval w=12(12)84 {
gen pred=.
gen nobs=.
	forval t=622/733 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnWeeklyEarnings l3dlnWeeklyEarnings l5dlnWeeklyEarnings l7dlnWeeklyEarnings ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnWeeklyEarnings)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs84 =         84
RWminobs84 =          2
RWrmse84 =  .05250414
*/
```



## Code

```
clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Final Project"
*log using "Final Project.smcl", replace
import delimited "TS2020_Final_Project_txt2/TS2020_Final_Project_Monthly.txt"
rename smu12455400500000001 Count
rename smu12455400500000002 WeekHours
rename smu12455400500000003 HourlyEarnings
rename smu12455400500000011 WeeklyEarnings
rename smu12455400800000001 ServiceCount


label variable Count "Count"
label variable WeekHours "WeekHours"
label variable HourlyEarnings "HourlyEarnings"
label variable WeeklyEarnings "WeeklyEarnings"
label variable ServiceCount "ServiceCount"


gen datec=date(date, "YMD")
gen Date=mofd(datec)
gen month=month(datec)
format Date %tm
tsset Date

gen lnCount = ln(Count)
gen lnWeekHours = ln(WeekHours)
gen lnHourlyEarnings = ln(HourlyEarnings)
gen lnWeeklyEarnings = ln(WeeklyEarnings)
gen lnServiceCount = ln(ServiceCount)

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
gen m12=0
replace m12=1 if month==12

gen dlnCount=d.lnCount
gen l1dlnCount=l1d.lnCount
gen l2dlnCount=l2d.lnCount
gen l3dlnCount=l3d.lnCount
gen l4dlnCount=l4d.lnCount
gen l5dlnCount=l5d.lnCount
gen l6dlnCount=l6d.lnCount
gen l7dlnCount=l7d.lnCount
gen l8dlnCount=l8d.lnCount
gen l9dlnCount=l9d.lnCount
gen l10dlnCount=l10d.lnCount
gen l11dlnCount=l11d.lnCount
gen l12dlnCount=l12d.lnCount
gen l24dlnCount=l24d.lnCount
gen l36dlnCount=l36d.lnCount
gen l48dlnCount=l48d.lnCount

gen dlnWeekHours=d.lnWeekHours
gen l1dlnWeekHours=l1d.lnWeekHours
gen l2dlnWeekHours=l2d.lnWeekHours
gen l3dlnWeekHours=l3d.lnWeekHours
gen l4dlnWeekHours=l4d.lnWeekHours
gen l5dlnWeekHours=l5d.lnWeekHours
gen l6dlnWeekHours=l6d.lnWeekHours
gen l7dlnWeekHours=l7d.lnWeekHours
gen l8dlnWeekHours=l8d.lnWeekHours
gen l9dlnWeekHours=l9d.lnWeekHours
gen l10dlnWeekHours=l10d.lnWeekHours
gen l11dlnWeekHours=l11d.lnWeekHours
gen l12dlnWeekHours=l12d.lnWeekHours
gen l24dlnWeekHours=l24d.lnWeekHours
gen l36dlnWeekHours=l36d.lnWeekHours
gen l48dlnWeekHours=l48d.lnWeekHours

gen dlnHourlyEarnings=d.lnHourlyEarnings
gen l1dlnHourlyEarnings=l1d.lnHourlyEarnings
gen l2dlnHourlyEarnings=l2d.lnHourlyEarnings
gen l3dlnHourlyEarnings=l3d.lnHourlyEarnings
gen l4dlnHourlyEarnings=l4d.lnHourlyEarnings
gen l5dlnHourlyEarnings=l5d.lnHourlyEarnings
gen l6dlnHourlyEarnings=l6d.lnHourlyEarnings
gen l7dlnHourlyEarnings=l7d.lnHourlyEarnings
gen l8dlnHourlyEarnings=l8d.lnHourlyEarnings
gen l9dlnHourlyEarnings=l9d.lnHourlyEarnings
gen l10dlnHourlyEarnings=l10d.lnHourlyEarnings
gen l11dlnHourlyEarnings=l11d.lnHourlyEarnings
gen l12dlnHourlyEarnings=l12d.lnHourlyEarnings
gen l24dlnHourlyEarnings=l24d.lnHourlyEarnings
gen l36dlnHourlyEarnings=l36d.lnHourlyEarnings
gen l48dlnHourlyEarnings=l48d.lnHourlyEarnings

gen dlnWeeklyEarnings=d.lnWeeklyEarnings
gen l1dlnWeeklyEarnings=l1d.lnWeeklyEarnings
gen l2dlnWeeklyEarnings=l2d.lnWeeklyEarnings
gen l3dlnWeeklyEarnings=l3d.lnWeeklyEarnings
gen l4dlnWeeklyEarnings=l4d.lnWeeklyEarnings
gen l5dlnWeeklyEarnings=l5d.lnWeeklyEarnings
gen l6dlnWeeklyEarnings=l6d.lnWeeklyEarnings
gen l7dlnWeeklyEarnings=l7d.lnWeeklyEarnings
gen l8dlnWeeklyEarnings=l8d.lnWeeklyEarnings
gen l9dlnWeeklyEarnings=l9d.lnWeeklyEarnings
gen l10dlnWeeklyEarnings=l10d.lnWeeklyEarnings
gen l11dlnWeeklyEarnings=l11d.lnWeeklyEarnings
gen l12dlnWeeklyEarnings=l12d.lnWeeklyEarnings
gen l24dlnWeeklyEarnings=l24d.lnWeeklyEarnings
gen l36dlnWeeklyEarnings=l36d.lnWeeklyEarnings
gen l48dlnWeeklyEarnings=l48d.lnWeeklyEarnings

gen dlnServiceCount=d.lnServiceCount
gen l1dlnServiceCount=l1d.lnServiceCount
gen l2dlnServiceCount=l2d.lnServiceCount
gen l3dlnServiceCount=l3d.lnServiceCount
gen l4dlnServiceCount=l4d.lnServiceCount
gen l5dlnServiceCount=l5d.lnServiceCount
gen l6dlnServiceCount=l6d.lnServiceCount
gen l7dlnServiceCount=l7d.lnServiceCount
gen l8dlnServiceCount=l8d.lnServiceCount
gen l9dlnServiceCount=l9d.lnServiceCount
gen l10dlnServiceCount=l10d.lnServiceCount
gen l11dlnServiceCount=l11d.lnServiceCount
gen l12dlnServiceCount=l12d.lnServiceCount
gen l24dlnServiceCount=l24d.lnServiceCount
gen l36dlnServiceCount=l36d.lnServiceCount
gen l48dlnServiceCount=l48d.lnServiceCount

/*
The project is to forecast the March non-seasonally adjusted estimates of average weekly earnings and total employment for private employers (total private) for a Florida MSA of your choice and write up a professional report on your forecast.
*/
/* Count and WeeklyEarnings */

summ Count WeekHours HourlyEarnings WeeklyEarnings ServiceCount
summ lnCount lnWeekHours lnHourlyEarnings lnWeeklyEarnings lnServiceCount

ac lnCount, saving(lnCount_ac, replace)
pac lnCount, saving(lnCount_pac, replace)
graph combine lnCount_ac.gph lnCount_pac.gph, saving(lnCount_ac_pac, replace)
graph export "lnCount_ac_pac.png", replace
** Probably need to difference

ac lnWeeklyEarnings, saving(lnWeeklyEarnings_ac, replace)
pac lnWeeklyEarnings, saving(lnWeeklyEarnings_pac, replace)
graph combine lnWeeklyEarnings_ac.gph lnWeeklyEarnings_pac.gph, saving(lnWeeklyEarnings_ac_pac, replace)
graph export "lnWeeklyEarnings_ac_pac.png", replace
** Probably need to differencen b

*starter models for count
*I used a pair plot to examine the rise and fall of variables with respect to each other
reg d.lnCount l(12,24,36,48)d.lnCount // .01637
scalar drop _all
quietly forval w=12(12)144 {
gen pred=.
gen nobs=.
	forval t=421/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l12dlnCount l24dlnCount l36dlnCount l48dlnCount ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs132 =        132
RWminobs132 =         12
RWrmse132 =   .0172128
*/

reg d.lnCount l(5,12,24,36,48)d.lnCount l(5)d.lnWeekHours m5 // .01711
scalar drop _all
quietly forval w=12(12)84 {
gen pred=.
gen nobs=.
	forval t=641/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l5dlnCount l12dlnCount l24dlnCount l36dlnCount l48dlnCount l5dlnWeekHours m5 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs84 =         84
RWminobs84 =         23
RWrmse84 =  .01950911
*/

/*
gsreg dlnCount l1dlnCount l2dlnCount l3dlnCount l4dlnCount l5dlnCount l6dlnCount ///
	l7dlnCount l8dlnCount l9dlnCount l10dlnCount l11dlnCount l12dlnCount ///
	l24dlnCount l36dlnCount l48dlnCount ///
	if tin(1990m1,2021m1), ///
	ncomb(1,12) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnCount) replace
*/
	
*gsreg suggestions
reg d.lnCount l12d.lnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=12(12)144 {
gen pred=.
gen nobs=.
	forval t=385/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l12dlnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs144 =        144
RWminobs144 =         12
RWrmse144 =  .01824906
*/

reg d.lnCount l(12,36)d.lnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=12(12)144 {
gen pred=.
gen nobs=.
	forval t=409/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l12dlnCount l36dlnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs144 =        144
RWminobs144 =         12
RWrmse144 =  .01777071
*/

/*
gsreg dlnCount l1dlnCount l2dlnCount l3dlnCount l4dlnCount l5dlnCount l6dlnCount ///
	l7dlnCount l8dlnCount l9dlnCount l10dlnCount l11dlnCount l12dlnCount ///
	l24dlnCount l36dlnCount ///
	l1dlnWeekHours l2dlnWeekHours l3dlnWeekHours l4dlnWeekHours l5dlnWeekHours l6dlnWeekHours ///
	l7dlnWeekHours l8dlnWeekHours l9dlnWeekHours l10dlnWeekHours l11dlnWeekHours l12dlnWeekHours ///
	l24dlnWeekHours l36dlnWeekHours ///
	l1dlnHourlyEarnings l2dlnHourlyEarnings l3dlnHourlyEarnings l4dlnHourlyEarnings ///
	l5dlnHourlyEarnings l6dlnHourlyEarnings ///
	l7dlnHourlyEarnings l8dlnHourlyEarnings l9dlnHourlyEarnings l10dlnHourlyEarnings ///
	l11dlnHourlyEarnings l12dlnHourlyEarnings ///
	l24dlnHourlyEarnings l36dlnHourlyEarnings ///
	l1dlnWeeklyEarnings l2dlnWeeklyEarnings l3dlnWeeklyEarnings l4dlnWeeklyEarnings ///
	l5dlnWeeklyEarnings l6dlnWeeklyEarnings ///
	l7dlnWeeklyEarnings l8dlnWeeklyEarnings l9dlnWeeklyEarnings l10dlnWeeklyEarnings ///
	l11dlnWeeklyEarnings l12dlnWeeklyEarnings ///
	l24dlnWeeklyEarnings l36dlnWeeklyEarnings ///
	if tin(2011m1,2021m1), ///
	ncomb(1,4) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnCount_Full) replace
*/
	
reg d.lnCount l4d.lnWeekHours l9d.lnWeekHours l8d.lnHourlyEarnings m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=12(12)84 {
gen pred=.
gen nobs=.
	forval t=624/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnCount l4dlnWeekHours l9dlnWeekHours l8dlnHourlyEarnings m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnCount)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs12 =         12
RWminobs12 =          2
RWrmse12 =   .0176238
*/

	
*starter models for weekly earnings
reg d.lnWeeklyEarnings l1d.lnWeekHours ld.lnHourlyEarnings
scalar drop _all
quietly forval w=12(12)84 {
gen pred=.
gen nobs=.
	forval t=616/733 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnWeeklyEarnings l1dlnWeekHours l1dlnHourlyEarnings ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnWeeklyEarnings)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs60 =         60
RWminobs60 =          2
RWrmse60 =  .06145693
*/

/*
gsreg dlnWeeklyEarnings l1dlnWeeklyEarnings l2dlnWeeklyEarnings l3dlnWeeklyEarnings ///
	l4dlnWeeklyEarnings l5dlnWeeklyEarnings l6dlnWeeklyEarnings ///
	l7dlnWeeklyEarnings l8dlnWeeklyEarnings l9dlnWeeklyEarnings l10dlnWeeklyEarnings ///
	l11dlnWeeklyEarnings l12dlnWeeklyEarnings ///
	l24dlnWeeklyEarnings l36dlnWeeklyEarnings ///
	if tin(2011m1,2021m1), ///
	ncomb(1,12) aic outsample(24) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnWeeklyEarnings) replace
*/
	
reg d.lnWeeklyEarnings l3d.lnWeeklyEarnings l5d.lnWeeklyEarnings m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=12(12)84 {
gen pred=.
gen nobs=.
	forval t=620/733 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnWeeklyEarnings l3dlnWeeklyEarnings l5dlnWeeklyEarnings m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnWeeklyEarnings)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs84 =         84
RWminobs84 =          2
RWrmse84 =  .06004448
*/

reg d.lnWeeklyEarnings l3d.lnWeeklyEarnings l5d.lnWeeklyEarnings l7d.lnWeeklyEarnings
scalar drop _all
quietly forval w=12(12)84 {
gen pred=.
gen nobs=.
	forval t=622/733 {  
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnWeeklyEarnings l3dlnWeeklyEarnings l5dlnWeeklyEarnings l7dlnWeeklyEarnings ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnWeeklyEarnings)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs84 =         84
RWminobs84 =          2
RWrmse84 =  .05250414
*/

/*
gsreg dlnCount l1dlnCount l2dlnCount l3dlnCount l4dlnCount l5dlnCount l6dlnCount ///
	l7dlnCount l8dlnCount l9dlnCount l10dlnCount l11dlnCount l12dlnCount l24dlnCount ///
	l1dlnWeekHours l2dlnWeekHours l3dlnWeekHours l4dlnWeekHours l5dlnWeekHours l6dlnWeekHours ///
	l7dlnWeekHours l8dlnWeekHours l9dlnWeekHours l10dlnWeekHours l11dlnWeekHours l12dlnWeekHours l24dlnWeekHours ///
	l1dlnHourlyEarnings l2dlnHourlyEarnings l3dlnHourlyEarnings l4dlnHourlyEarnings ///
	l5dlnHourlyEarnings l6dlnHourlyEarnings ///
	l7dlnHourlyEarnings l8dlnHourlyEarnings l9dlnHourlyEarnings l10dlnHourlyEarnings ///
	l11dlnHourlyEarnings l12dlnHourlyEarnings l24dlnHourlyEarnings ///
	l1dlnWeeklyEarnings l2dlnWeeklyEarnings l3dlnWeeklyEarnings l4dlnWeeklyEarnings ///
	l5dlnWeeklyEarnings l6dlnWeeklyEarnings ///
	l7dlnWeeklyEarnings l8dlnWeeklyEarnings l9dlnWeeklyEarnings l10dlnWeeklyEarnings ///
	l11dlnWeeklyEarnings l12dlnWeeklyEarnings l24dlnWeeklyEarnings if tin(2011m1,2021m1), ///
	ncomb(1,4) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnWeeklyEarnings_Full) replace
*/

*log close
```

## Log File

```
                                                       ___  ____  ____  ____  ____(R)
                                                      /__    /   ____/   /   ____/   
                                                     ___/   /   /___/   /   /___/    
                                                       Statistics/Data analysis      
      
      -------------------------------------------------------------------------------
            name:  <unnamed>
             log:  /Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Probl
      > em Sets/Final Project/Final Project.smcl
        log type:  smcl
       opened on:   8 Apr 2021, 17:47:08
      
     1 . import delimited "TS2020_Final_Project_txt2/TS2020_Final_Project_Monthly.txt"
      (6 vars, 374 obs)
      
     2 . rename smu12455400500000001 Count
      
     3 . rename smu12455400500000002 WeekHours
      
     4 . rename smu12455400500000003 HourlyEarnings
      
     5 . rename smu12455400500000011 WeeklyEarnings
      
     6 . rename smu12455400800000001 ServiceCount
      
     7 . 
     8 . 
     9 . label variable Count "Count"
      
    10 . label variable WeekHours "WeekHours"
      
    11 . label variable HourlyEarnings "HourlyEarnings"
      
    12 . label variable WeeklyEarnings "WeeklyEarnings"
      
    13 . label variable ServiceCount "ServiceCount"
      
    14 . 
    15 . 
    16 . gen datec=date(date, "YMD")
      
    17 . gen Date=mofd(datec)
      
    18 . gen month=month(datec)
      
    19 . format Date %tm
      
    20 . tsset Date
              time variable:  Date, 1990m1 to 2021m2
                      delta:  1 month
      
    21 . 
    22 . gen lnCount = ln(Count)
      
    23 . gen lnWeekHours = ln(WeekHours)
      (252 missing values generated)
      
    24 . gen lnHourlyEarnings = ln(HourlyEarnings)
      (252 missing values generated)
      
    25 . gen lnWeeklyEarnings = ln(WeeklyEarnings)
      (252 missing values generated)
      
    26 . gen lnServiceCount = ln(ServiceCount)
      
    27 . 
    28 . gen m1=0
      
    29 . replace m1=1 if month==1
      (32 real changes made)
      
    30 . gen m2=0
      
    31 . replace m2=1 if month==2
      (32 real changes made)
      
    32 . gen m3=0
      
    33 . replace m3=1 if month==3
      (31 real changes made)
      
    34 . gen m4=0
      
    35 . replace m4=1 if month==4
      (31 real changes made)
      
    36 . gen m5=0
      
    37 . replace m5=1 if month==5
      (31 real changes made)
      
    38 . gen m6=0
      
    39 . replace m6=1 if month==6
      (31 real changes made)
      
    40 . gen m7=0
      
    41 . replace m7=1 if month==7
      (31 real changes made)
      
    42 . gen m8=0
      
    43 . replace m8=1 if month==8
      (31 real changes made)
      
    44 . gen m9=0
      
    45 . replace m9=1 if month==9
      (31 real changes made)
      
    46 . gen m10=0
      
    47 . replace m10=1 if month==10
      (31 real changes made)
      
    48 . gen m11=0
      
    49 . replace m11=1 if month==11
      (31 real changes made)
      
    50 . gen m12=0
      
    51 . replace m12=1 if month==12
      (31 real changes made)
      
    52 . 
    53 . gen dlnCount=d.lnCount
      (1 missing value generated)
      
    54 . gen l1dlnCount=l1d.lnCount
      (2 missing values generated)
      
    55 . gen l2dlnCount=l2d.lnCount
      (3 missing values generated)
      
    56 . gen l3dlnCount=l3d.lnCount
      (4 missing values generated)
      
    57 . gen l4dlnCount=l4d.lnCount
      (5 missing values generated)
      
    58 . gen l5dlnCount=l5d.lnCount
      (6 missing values generated)
      
    59 . gen l6dlnCount=l6d.lnCount
      (7 missing values generated)
      
    60 . gen l7dlnCount=l7d.lnCount
      (8 missing values generated)
      
    61 . gen l8dlnCount=l8d.lnCount
      (9 missing values generated)
      
    62 . gen l9dlnCount=l9d.lnCount
      (10 missing values generated)
      
    63 . gen l10dlnCount=l10d.lnCount
      (11 missing values generated)
      
    64 . gen l11dlnCount=l11d.lnCount
      (12 missing values generated)
      
    65 . gen l12dlnCount=l12d.lnCount
      (13 missing values generated)
      
    66 . gen l24dlnCount=l24d.lnCount
      (25 missing values generated)
      
    67 . gen l36dlnCount=l36d.lnCount
      (37 missing values generated)
      
    68 . gen l48dlnCount=l48d.lnCount
      (49 missing values generated)
      
    69 . 
    70 . gen dlnWeekHours=d.lnWeekHours
      (253 missing values generated)
      
    71 . gen l1dlnWeekHours=l1d.lnWeekHours
      (254 missing values generated)
      
    72 . gen l2dlnWeekHours=l2d.lnWeekHours
      (255 missing values generated)
      
    73 . gen l3dlnWeekHours=l3d.lnWeekHours
      (256 missing values generated)
      
    74 . gen l4dlnWeekHours=l4d.lnWeekHours
      (257 missing values generated)
      
    75 . gen l5dlnWeekHours=l5d.lnWeekHours
      (258 missing values generated)
      
    76 . gen l6dlnWeekHours=l6d.lnWeekHours
      (259 missing values generated)
      
    77 . gen l7dlnWeekHours=l7d.lnWeekHours
      (260 missing values generated)
      
    78 . gen l8dlnWeekHours=l8d.lnWeekHours
      (261 missing values generated)
      
    79 . gen l9dlnWeekHours=l9d.lnWeekHours
      (262 missing values generated)
      
    80 . gen l10dlnWeekHours=l10d.lnWeekHours
      (263 missing values generated)
      
    81 . gen l11dlnWeekHours=l11d.lnWeekHours
      (264 missing values generated)
      
    82 . gen l12dlnWeekHours=l12d.lnWeekHours
      (265 missing values generated)
      
    83 . gen l24dlnWeekHours=l24d.lnWeekHours
      (277 missing values generated)
      
    84 . gen l36dlnWeekHours=l36d.lnWeekHours
      (289 missing values generated)
      
    85 . gen l48dlnWeekHours=l48d.lnWeekHours
      (301 missing values generated)
      
    86 . 
    87 . gen dlnHourlyEarnings=d.lnHourlyEarnings
      (253 missing values generated)
      
    88 . gen l1dlnHourlyEarnings=l1d.lnHourlyEarnings
      (254 missing values generated)
      
    89 . gen l2dlnHourlyEarnings=l2d.lnHourlyEarnings
      (255 missing values generated)
      
    90 . gen l3dlnHourlyEarnings=l3d.lnHourlyEarnings
      (256 missing values generated)
      
    91 . gen l4dlnHourlyEarnings=l4d.lnHourlyEarnings
      (257 missing values generated)
      
    92 . gen l5dlnHourlyEarnings=l5d.lnHourlyEarnings
      (258 missing values generated)
      
    93 . gen l6dlnHourlyEarnings=l6d.lnHourlyEarnings
      (259 missing values generated)
      
    94 . gen l7dlnHourlyEarnings=l7d.lnHourlyEarnings
      (260 missing values generated)
      
    95 . gen l8dlnHourlyEarnings=l8d.lnHourlyEarnings
      (261 missing values generated)
      
    96 . gen l9dlnHourlyEarnings=l9d.lnHourlyEarnings
      (262 missing values generated)
      
    97 . gen l10dlnHourlyEarnings=l10d.lnHourlyEarnings
      (263 missing values generated)
      
    98 . gen l11dlnHourlyEarnings=l11d.lnHourlyEarnings
      (264 missing values generated)
      
    99 . gen l12dlnHourlyEarnings=l12d.lnHourlyEarnings
      (265 missing values generated)
      
   100 . gen l24dlnHourlyEarnings=l24d.lnHourlyEarnings
      (277 missing values generated)
      
   101 . gen l36dlnHourlyEarnings=l36d.lnHourlyEarnings
      (289 missing values generated)
      
   102 . gen l48dlnHourlyEarnings=l48d.lnHourlyEarnings
      (301 missing values generated)
      
   103 . 
   104 . gen dlnWeeklyEarnings=d.lnWeeklyEarnings
      (253 missing values generated)
      
   105 . gen l1dlnWeeklyEarnings=l1d.lnWeeklyEarnings
      (254 missing values generated)
      
   106 . gen l2dlnWeeklyEarnings=l2d.lnWeeklyEarnings
      (255 missing values generated)
      
   107 . gen l3dlnWeeklyEarnings=l3d.lnWeeklyEarnings
      (256 missing values generated)
      
   108 . gen l4dlnWeeklyEarnings=l4d.lnWeeklyEarnings
      (257 missing values generated)
      
   109 . gen l5dlnWeeklyEarnings=l5d.lnWeeklyEarnings
      (258 missing values generated)
      
   110 . gen l6dlnWeeklyEarnings=l6d.lnWeeklyEarnings
      (259 missing values generated)
      
   111 . gen l7dlnWeeklyEarnings=l7d.lnWeeklyEarnings
      (260 missing values generated)
      
   112 . gen l8dlnWeeklyEarnings=l8d.lnWeeklyEarnings
      (261 missing values generated)
      
   113 . gen l9dlnWeeklyEarnings=l9d.lnWeeklyEarnings
      (262 missing values generated)
      
   114 . gen l10dlnWeeklyEarnings=l10d.lnWeeklyEarnings
      (263 missing values generated)
      
   115 . gen l11dlnWeeklyEarnings=l11d.lnWeeklyEarnings
      (264 missing values generated)
      
   116 . gen l12dlnWeeklyEarnings=l12d.lnWeeklyEarnings
      (265 missing values generated)
      
   117 . gen l24dlnWeeklyEarnings=l24d.lnWeeklyEarnings
      (277 missing values generated)
      
   118 . gen l36dlnWeeklyEarnings=l36d.lnWeeklyEarnings
      (289 missing values generated)
      
   119 . gen l48dlnWeeklyEarnings=l48d.lnWeeklyEarnings
      (301 missing values generated)
      
   120 . 
   121 . gen dlnServiceCount=d.lnServiceCount
      (1 missing value generated)
      
   122 . gen l1dlnServiceCount=l1d.lnServiceCount
      (2 missing values generated)
      
   123 . gen l2dlnServiceCount=l2d.lnServiceCount
      (3 missing values generated)
      
   124 . gen l3dlnServiceCount=l3d.lnServiceCount
      (4 missing values generated)
      
   125 . gen l4dlnServiceCount=l4d.lnServiceCount
      (5 missing values generated)
      
   126 . gen l5dlnServiceCount=l5d.lnServiceCount
      (6 missing values generated)
      
   127 . gen l6dlnServiceCount=l6d.lnServiceCount
      (7 missing values generated)
      
   128 . gen l7dlnServiceCount=l7d.lnServiceCount
      (8 missing values generated)
      
   129 . gen l8dlnServiceCount=l8d.lnServiceCount
      (9 missing values generated)
      
   130 . gen l9dlnServiceCount=l9d.lnServiceCount
      (10 missing values generated)
      
   131 . gen l10dlnServiceCount=l10d.lnServiceCount
      (11 missing values generated)
      
   132 . gen l11dlnServiceCount=l11d.lnServiceCount
      (12 missing values generated)
      
   133 . gen l12dlnServiceCount=l12d.lnServiceCount
      (13 missing values generated)
      
   134 . gen l24dlnServiceCount=l24d.lnServiceCount
      (25 missing values generated)
      
   135 . gen l36dlnServiceCount=l36d.lnServiceCount
      (37 missing values generated)
      
   136 . gen l48dlnServiceCount=l48d.lnServiceCount
      (49 missing values generated)
      
   137 . 
   138 . /*
      > The project is to forecast the March non-seasonally adjusted estimates of ave
      > rage weekly earnings and total employment for private employers (total privat
      > e) for a Florida MSA of your choice and write up a professional report on you
      > r forecast.
      > */
   139 . /* Count and WeeklyEarnings */
   140 . 
   141 . summ Count WeekHours HourlyEarnings WeeklyEarnings ServiceCount
      
          Variable |        Obs        Mean    Std. Dev.       Min        Max
      -------------+---------------------------------------------------------
             Count |        374    14.18556    6.880684        5.3         28
         WeekHours |        122    36.86967    3.804193       28.3       45.8
      HourlyEarn~s |        122    19.70344    2.910126      15.01       24.6
      WeeklyEarn~s |        122    719.7972    84.82529     503.79      916.1
      ServiceCount |        374    10.40455    5.940013        3.9       22.8
      
   142 . summ lnCount lnWeekHours lnHourlyEarnings lnWeeklyEarnings lnServiceCount
      
          Variable |        Obs        Mean    Std. Dev.       Min        Max
      -------------+---------------------------------------------------------
           lnCount |        374      2.5174    .5398403   1.667707   3.332205
       lnWeekHours |        122    3.602049    .1041722   3.342862   3.824284
      lnHourlyEa~s |        122    2.969891     .148565   2.708717   3.202746
      lnWeeklyEa~s |        122     6.57194    .1198394   6.222159   6.820126
      lnServiceC~t |        374     2.16967    .5975865   1.360977    3.12676
      
   143 . 
   144 . ac lnCount, saving(lnCount_ac, replace)
      (file lnCount_ac.gph saved)
      
   145 . pac lnCount, saving(lnCount_pac, replace)
      (file lnCount_pac.gph saved)
      
   146 . graph combine lnCount_ac.gph lnCount_pac.gph, saving(lnCount_ac_pac, replace)
      (file lnCount_ac_pac.gph saved)
      
   147 . graph export "lnCount_ac_pac.png", replace
      (file /Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets
      > /Final Project/lnCount_ac_pac.png written in PNG format)
      
   148 . ** Probably need to difference
   149 . 
   150 . ac lnWeeklyEarnings, saving(lnWeeklyEarnings_ac, replace)
      (file lnWeeklyEarnings_ac.gph saved)
      
   151 . pac lnWeeklyEarnings, saving(lnWeeklyEarnings_pac, replace)
      (file lnWeeklyEarnings_pac.gph saved)
      
   152 . graph combine lnWeeklyEarnings_ac.gph lnWeeklyEarnings_pac.gph, saving(lnWeek
      > lyEarnings_ac_pac, replace)
      (file lnWeeklyEarnings_ac_pac.gph saved)
      
   153 . graph export "lnWeeklyEarnings_ac_pac.png", replace
      (file /Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets
      > /Final Project/lnWeeklyEarnings_ac_pac.png written in PNG format)
      
   154 . ** Probably need to differencen b
   155 . 
   156 . *starter models for count
   157 . *I used a pair plot to examine the rise and fall of variables with respect to
      >  each other
   158 . reg d.lnCount l(12,24,36,48)d.lnCount // .01637
      
            Source |       SS           df       MS      Number of obs   =       325
      -------------+----------------------------------   F(4, 320)       =     16.54
             Model |  .017539188         4  .004384797   Prob > F        =    0.0000
          Residual |  .084856979       320  .000265178   R-squared       =    0.1713
      -------------+----------------------------------   Adj R-squared   =    0.1609
             Total |  .102396167       324  .000316038   Root MSE        =    .01628
      
      ------------------------------------------------------------------------------
         D.lnCount |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
           lnCount |
             L12D. |   .3609966   .0621085     5.81   0.000      .238804    .4831893
             L24D. |    .137848   .0617615     2.23   0.026      .016338     .259358
             L36D. |  -.0160136   .0614584    -0.26   0.795    -.1369272       .1049
             L48D. |   .1265117   .0585322     2.16   0.031     .0113551    .2416683
                   |
             _cons |   .0017116   .0009853     1.74   0.083    -.0002269    .0036502
      ------------------------------------------------------------------------------
      
   159 . scalar drop _all
      
   160 . quietly forval w=12(12)144 {
      
   161 . scalar list
      RWmaxobs144 =        144
      RWminobs144 =         12
       RWrmse144 =   .0172276
      RWmaxobs132 =        132
      RWminobs132 =         12
       RWrmse132 =   .0172128
      RWmaxobs120 =        120
      RWminobs120 =         12
       RWrmse120 =  .01721825
      RWmaxobs108 =        108
      RWminobs108 =         12
       RWrmse108 =  .01723674
      RWmaxobs96 =         96
      RWminobs96 =         12
        RWrmse96 =  .01722006
      RWmaxobs84 =         84
      RWminobs84 =         12
        RWrmse84 =  .01726063
      RWmaxobs72 =         72
      RWminobs72 =         12
        RWrmse72 =  .01722377
      RWmaxobs60 =         60
      RWminobs60 =         12
        RWrmse60 =   .0173443
      RWmaxobs48 =         48
      RWminobs48 =         12
        RWrmse48 =  .01755803
      RWmaxobs36 =         36
      RWminobs36 =         12
        RWrmse36 =  .01805924
      RWmaxobs24 =         24
      RWminobs24 =         12
        RWrmse24 =   .0185871
      RWmaxobs12 =         12
      RWminobs12 =         12
        RWrmse12 =  .02320505
      
   162 . /*
      > RWmaxobs132 =        132
      > RWminobs132 =         12
      > RWrmse132 =   .0172128
      > */
   163 . 
   164 . reg d.lnCount l(5,12,24,36,48)d.lnCount l(5)d.lnWeekHours m5 // .01711
      
            Source |       SS           df       MS      Number of obs   =       116
      -------------+----------------------------------   F(7, 108)       =      5.94
             Model |  .012171566         7  .001738795   Prob > F        =    0.0000
          Residual |   .03162877       108  .000292859   R-squared       =    0.2779
      -------------+----------------------------------   Adj R-squared   =    0.2311
             Total |  .043800336       115  .000380872   Root MSE        =    .01711
      
      ------------------------------------------------------------------------------
         D.lnCount |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
           lnCount |
              L5D. |  -.1231921   .0845717    -1.46   0.148     -.290828    .0444438
             L12D. |   .5811114   .1685831     3.45   0.001     .2469504    .9152724
             L24D. |  -.1196017   .1627467    -0.73   0.464    -.4421938    .2029904
             L36D. |   .2532303   .1742525     1.45   0.149    -.0921684    .5986291
             L48D. |   .1341638   .1858633     0.72   0.472    -.2342495    .5025771
                   |
       lnWeekHours |
              L5D. |   .0170123   .0364906     0.47   0.642    -.0553184     .089343
                   |
                m5 |   .0067588   .0061605     1.10   0.275    -.0054524    .0189699
             _cons |   .0004279   .0018229     0.23   0.815    -.0031854    .0040412
      ------------------------------------------------------------------------------
      
   165 . scalar drop _all
      
   166 . quietly forval w=12(12)84 {
      
   167 . scalar list
      RWmaxobs84 =         84
      RWminobs84 =         23
        RWrmse84 =  .01950911
      RWmaxobs72 =         72
      RWminobs72 =         23
        RWrmse72 =  .01949719
      RWmaxobs60 =         60
      RWminobs60 =         23
        RWrmse60 =   .0199438
      RWmaxobs48 =         48
      RWminobs48 =         23
        RWrmse48 =  .02035982
      RWmaxobs36 =         36
      RWminobs36 =         23
        RWrmse36 =  .02138785
      RWmaxobs24 =         24
      RWminobs24 =         23
        RWrmse24 =  .02268585
      RWmaxobs12 =         12
      RWminobs12 =         12
        RWrmse12 =  .05004898
      
   168 . /*
      > RWmaxobs84 =         84
      > RWminobs84 =         23
      > RWrmse84 =  .01950911
      > */
   169 . 
   170 . /*
      > gsreg dlnCount l1dlnCount l2dlnCount l3dlnCount l4dlnCount l5dlnCount l6dlnCo
      > unt ///
      >         l7dlnCount l8dlnCount l9dlnCount l10dlnCount l11dlnCount l12dlnCount 
      > ///
      >         l24dlnCount l36dlnCount l48dlnCount ///
      >         if tin(1990m1,2021m1), ///
      >         ncomb(1,12) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 
      > m12) ///
      >         samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnCount)
      >  replace
      > */
   171 .         
   172 . *gsreg suggestions
   173 . reg d.lnCount l12d.lnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
      
            Source |       SS           df       MS      Number of obs   =       361
      -------------+----------------------------------   F(12, 348)      =      6.91
             Model |  .022616974        12  .001884748   Prob > F        =    0.0000
          Residual |  .094871179       348  .000272618   R-squared       =    0.1925
      -------------+----------------------------------   Adj R-squared   =    0.1647
             Total |  .117488153       360  .000326356   Root MSE        =    .01651
      
      ------------------------------------------------------------------------------
         D.lnCount |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
           lnCount |
             L12D. |   .1748571   .0594184     2.94   0.003     .0579928    .2917215
                   |
                m1 |  -.0099477   .0043004    -2.31   0.021    -.0184056   -.0014897
                m2 |   .0009939   .0042297     0.23   0.814    -.0073251    .0093129
                m3 |   .0030247   .0042759     0.71   0.480    -.0053851    .0114345
                m4 |  -.0071933   .0042648    -1.69   0.093    -.0155814    .0011948
                m5 |  -.0098194   .0043178    -2.27   0.024    -.0183118   -.0013271
                m6 |  -.0133285   .0043874    -3.04   0.003    -.0219576   -.0046994
                m7 |  -.0091828   .0042967    -2.14   0.033    -.0176336    -.000732
                m8 |  -.0017998   .0042632    -0.42   0.673    -.0101846     .006585
                m9 |   -.006737   .0042824    -1.57   0.117    -.0151597    .0016858
               m10 |   .0062149   .0042795     1.45   0.147    -.0022021    .0146319
               m11 |   .0042124   .0042811     0.98   0.326    -.0042078    .0126325
             _cons |   .0072199   .0030452     2.37   0.018     .0012306    .0132093
      ------------------------------------------------------------------------------
      
   174 . scalar drop _all
      
   175 . quietly forval w=12(12)144 {
      
   176 . scalar list
      RWmaxobs144 =        144
      RWminobs144 =         12
       RWrmse144 =  .01824906
      RWmaxobs132 =        132
      RWminobs132 =         12
       RWrmse132 =  .01832173
      RWmaxobs120 =        120
      RWminobs120 =         12
       RWrmse120 =  .01833557
      RWmaxobs108 =        108
      RWminobs108 =         12
       RWrmse108 =  .01841089
      RWmaxobs96 =         96
      RWminobs96 =         12
        RWrmse96 =  .01836974
      RWmaxobs84 =         84
      RWminobs84 =         12
        RWrmse84 =  .01849267
      RWmaxobs72 =         72
      RWminobs72 =         12
        RWrmse72 =  .01861349
      RWmaxobs60 =         60
      RWminobs60 =         12
        RWrmse60 =  .01911515
      RWmaxobs48 =         48
      RWminobs48 =         12
        RWrmse48 =  .01922268
      RWmaxobs36 =         36
      RWminobs36 =         12
        RWrmse36 =  .01991683
      RWmaxobs24 =         24
      RWminobs24 =         12
        RWrmse24 =  .02022186
      RWmaxobs12 =         12
      RWminobs12 =         12
        RWrmse12 =  .02009249
      
   177 . /*
      > RWmaxobs144 =        144
      > RWminobs144 =         12
      > RWrmse144 =  .01824906
      > */
   178 . 
   179 . reg d.lnCount l(12,36)d.lnCount m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
      
            Source |       SS           df       MS      Number of obs   =       337
      -------------+----------------------------------   F(13, 323)      =      5.68
             Model |  .019946057        13  .001534312   Prob > F        =    0.0000
          Residual |  .087185203       323  .000269923   R-squared       =    0.1862
      -------------+----------------------------------   Adj R-squared   =    0.1534
             Total |  .107131259       336  .000318843   Root MSE        =    .01643
      
      ------------------------------------------------------------------------------
         D.lnCount |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
           lnCount |
             L12D. |   .1849403   .0636401     2.91   0.004      .059739    .3101417
             L36D. |   -.049332   .0606582    -0.81   0.417    -.1686671    .0700031
                   |
                m1 |  -.0073418   .0044769    -1.64   0.102    -.0161493    .0014658
                m2 |   .0022711   .0043559     0.52   0.602    -.0062984    .0108407
                m3 |   .0043593    .004416     0.99   0.324    -.0043285    .0130471
                m4 |  -.0065438   .0043922    -1.49   0.137    -.0151847     .002097
                m5 |  -.0089215   .0045194    -1.97   0.049    -.0178126   -.0000304
                m6 |  -.0133453   .0046241    -2.89   0.004    -.0224425    -.004248
                m7 |  -.0085154    .004457    -1.91   0.057    -.0172839    .0002531
                m8 |  -.0004554    .004392    -0.10   0.917    -.0090959    .0081852
                m9 |  -.0056625   .0044299    -1.28   0.202    -.0143775    .0030526
               m10 |   .0071688   .0044386     1.62   0.107    -.0015635    .0159011
               m11 |   .0042074   .0044259     0.95   0.343    -.0044998    .0129146
             _cons |   .0067355   .0031722     2.12   0.034     .0004948    .0129762
      ------------------------------------------------------------------------------
      
   180 . scalar drop _all
      
   181 . quietly forval w=12(12)144 {
      
   182 . scalar list
      RWmaxobs144 =        144
      RWminobs144 =         12
       RWrmse144 =  .01777071
      RWmaxobs132 =        132
      RWminobs132 =         12
       RWrmse132 =  .01782557
      RWmaxobs120 =        120
      RWminobs120 =         12
       RWrmse120 =  .01785253
      RWmaxobs108 =        108
      RWminobs108 =         12
       RWrmse108 =  .01794692
      RWmaxobs96 =         96
      RWminobs96 =         12
        RWrmse96 =  .01793358
      RWmaxobs84 =         84
      RWminobs84 =         12
        RWrmse84 =  .01803355
      RWmaxobs72 =         72
      RWminobs72 =         12
        RWrmse72 =  .01807408
      RWmaxobs60 =         60
      RWminobs60 =         12
        RWrmse60 =  .01843535
      RWmaxobs48 =         48
      RWminobs48 =         12
        RWrmse48 =  .01835092
      RWmaxobs36 =         36
      RWminobs36 =         12
        RWrmse36 =  .01863303
      RWmaxobs24 =         24
      RWminobs24 =         12
        RWrmse24 =   .0196745
      RWmaxobs12 =         12
      RWminobs12 =         12
        RWrmse12 =  .01880291
      
   183 . /*
      > RWmaxobs144 =        144
      > RWminobs144 =         12
      > RWrmse144 =  .01777071
      > */
   184 . 
   185 . /*
      > gsreg dlnCount l1dlnCount l2dlnCount l3dlnCount l4dlnCount l5dlnCount l6dlnCo
      > unt ///
      >         l7dlnCount l8dlnCount l9dlnCount l10dlnCount l11dlnCount l12dlnCount 
      > ///
      >         l24dlnCount l36dlnCount ///
      >         l1dlnWeekHours l2dlnWeekHours l3dlnWeekHours l4dlnWeekHours l5dlnWeek
      > Hours l6dlnWeekHours ///
      >         l7dlnWeekHours l8dlnWeekHours l9dlnWeekHours l10dlnWeekHours l11dlnWe
      > ekHours l12dlnWeekHours ///
      >         l24dlnWeekHours l36dlnWeekHours ///
      >         l1dlnHourlyEarnings l2dlnHourlyEarnings l3dlnHourlyEarnings l4dlnHour
      > lyEarnings ///
      >         l5dlnHourlyEarnings l6dlnHourlyEarnings ///
      >         l7dlnHourlyEarnings l8dlnHourlyEarnings l9dlnHourlyEarnings l10dlnHou
      > rlyEarnings ///
      >         l11dlnHourlyEarnings l12dlnHourlyEarnings ///
      >         l24dlnHourlyEarnings l36dlnHourlyEarnings ///
      >         l1dlnWeeklyEarnings l2dlnWeeklyEarnings l3dlnWeeklyEarnings l4dlnWeek
      > lyEarnings ///
      >         l5dlnWeeklyEarnings l6dlnWeeklyEarnings ///
      >         l7dlnWeeklyEarnings l8dlnWeeklyEarnings l9dlnWeeklyEarnings l10dlnWee
      > klyEarnings ///
      >         l11dlnWeeklyEarnings l12dlnWeeklyEarnings ///
      >         l24dlnWeeklyEarnings l36dlnWeeklyEarnings ///
      >         if tin(2011m1,2021m1), ///
      >         ncomb(1,4) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) 
      > ///
      >         samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnCount_
      > Full) replace
      > */
   186 .         
   187 . reg d.lnCount l4d.lnWeekHours l9d.lnWeekHours l8d.lnHourlyEarnings m1 m2 m3 m
      > 4 m5 m6 m7 m8 m9 m10 m11
      
            Source |       SS           df       MS      Number of obs   =       112
      -------------+----------------------------------   F(14, 97)       =      3.24
             Model |  .013917393        14    .0009941   Prob > F        =    0.0003
          Residual |  .029798432        97    .0003072   R-squared       =    0.3184
      -------------+----------------------------------   Adj R-squared   =    0.2200
             Total |  .043715825       111  .000393836   Root MSE        =    .01753
      
      ------------------------------------------------------------------------------
         D.lnCount |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
       lnWeekHours |
              L4D. |  -.0013847   .0384012    -0.04   0.971    -.0776005     .074831
              L9D. |   .0397686   .0385964     1.03   0.305    -.0368346    .1163718
                   |
      lnHourlyEa~s |
              L8D. |   -.039029   .0414024    -0.94   0.348    -.1212014    .0431433
                   |
                m1 |  -.0097045   .0078517    -1.24   0.219    -.0252879    .0058789
                m2 |   .0000949   .0079445     0.01   0.990    -.0156727    .0158626
                m3 |   -.004712   .0083585    -0.56   0.574    -.0213013    .0118773
                m4 |  -.0273667   .0081729    -3.35   0.001    -.0435876   -.0111459
                m5 |  -.0076836   .0081259    -0.95   0.347    -.0238112     .008444
                m6 |   -.020254   .0081465    -2.49   0.015    -.0364227   -.0040854
                m7 |  -.0130812   .0081852    -1.60   0.113    -.0293265    .0031642
                m8 |   .0041701   .0081051     0.51   0.608    -.0119164    .0202565
                m9 |  -.0089171   .0082764    -1.08   0.284    -.0253435    .0075093
               m10 |   .0153608   .0081153     1.89   0.061    -.0007459    .0314674
               m11 |   .0040463   .0079619     0.51   0.612    -.0117559    .0198485
             _cons |   .0094122   .0056462     1.67   0.099    -.0017939    .0206183
      ------------------------------------------------------------------------------
      
   188 . scalar drop _all
      
   189 . quietly forval w=12(12)84 {
      
   190 . scalar list
      RWmaxobs84 =         84
      RWminobs84 =          2
        RWrmse84 =  .01847546
      RWmaxobs72 =         72
      RWminobs72 =          2
        RWrmse72 =  .01855448
      RWmaxobs60 =         60
      RWminobs60 =          2
        RWrmse60 =  .01850723
      RWmaxobs48 =         48
      RWminobs48 =          2
        RWrmse48 =  .01850217
      RWmaxobs36 =         36
      RWminobs36 =          2
        RWrmse36 =  .01942535
      RWmaxobs24 =         24
      RWminobs24 =          2
        RWrmse24 =  .02208272
      RWmaxobs12 =         12
      RWminobs12 =          2
        RWrmse12 =   .0176238
      
   191 . /*
      > RWmaxobs12 =         12
      > RWminobs12 =          2
      > RWrmse12 =   .0176238
      > */
   192 . 
   193 . /*---------------------------------------------------------------------------
      > -*/
   194 .         
   195 . *starter models for weekly earnings
   196 . reg d.lnWeeklyEarnings l1d.lnWeekHours ld.lnHourlyEarnings
      
            Source |       SS           df       MS      Number of obs   =       120
      -------------+----------------------------------   F(2, 117)       =      1.48
             Model |   .00720643         2  .003603215   Prob > F        =    0.2317
          Residual |  .284697808       117  .002433315   R-squared       =    0.0247
      -------------+----------------------------------   Adj R-squared   =    0.0080
             Total |  .291904237       119  .002452977   Root MSE        =    .04933
      
      ------------------------------------------------------------------------------
      D.           |
      lnWeeklyEa~s |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
       lnWeekHours |
               LD. |  -.1344969    .105932    -1.27   0.207    -.3442897    .0752959
                   |
      lnHourlyEa~s |
               LD. |   .0732899   .1167768     0.63   0.531    -.1579805    .3045603
                   |
             _cons |   .0016809   .0045103     0.37   0.710    -.0072515    .0106133
      ------------------------------------------------------------------------------
      
   197 . scalar drop _all
      
   198 . quietly forval w=12(12)84 {
      
   199 . scalar list
      RWmaxobs84 =         84
      RWminobs84 =          2
        RWrmse84 =  .06184586
      RWmaxobs72 =         72
      RWminobs72 =          2
        RWrmse72 =  .06163593
      RWmaxobs60 =         60
      RWminobs60 =          2
        RWrmse60 =  .06145693
      RWmaxobs48 =         48
      RWminobs48 =          2
        RWrmse48 =  .06185207
      RWmaxobs36 =         36
      RWminobs36 =          2
        RWrmse36 =  .06201342
      RWmaxobs24 =         24
      RWminobs24 =          2
        RWrmse24 =  .06223845
      RWmaxobs12 =         12
      RWminobs12 =          2
        RWrmse12 =  .06581989
      
   200 . /*
      > RWmaxobs60 =         60
      > RWminobs60 =          2
      > RWrmse60 =  .06145693
      > */
   201 . 
   202 . /*
      > gsreg dlnWeeklyEarnings l1dlnWeeklyEarnings l2dlnWeeklyEarnings l3dlnWeeklyEa
      > rnings ///
      >         l4dlnWeeklyEarnings l5dlnWeeklyEarnings l6dlnWeeklyEarnings ///
      >         l7dlnWeeklyEarnings l8dlnWeeklyEarnings l9dlnWeeklyEarnings l10dlnWee
      > klyEarnings ///
      >         l11dlnWeeklyEarnings l12dlnWeeklyEarnings ///
      >         l24dlnWeeklyEarnings l36dlnWeeklyEarnings ///
      >         if tin(2011m1,2021m1), ///
      >         ncomb(1,12) aic outsample(24) ///
      >         samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnWeekly
      > Earnings) replace
      > */
   203 .         
   204 . reg d.lnWeeklyEarnings l3d.lnWeeklyEarnings l5d.lnWeeklyEarnings m1 m2 m3 m4 
      > m5 m6 m7 m8 m9 m10 m11
      
            Source |       SS           df       MS      Number of obs   =       116
      -------------+----------------------------------   F(13, 102)      =      2.22
             Model |  .062824046        13  .004832619   Prob > F        =    0.0134
          Residual |  .221893915       102  .002175431   R-squared       =    0.2207
      -------------+----------------------------------   Adj R-squared   =    0.1213
             Total |  .284717961       115  .002475808   Root MSE        =    .04664
      
      ------------------------------------------------------------------------------
      D.           |
      lnWeeklyEa~s |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
      lnWeeklyEa~s |
              L3D. |   -.230666   .0948354    -2.43   0.017    -.4187716   -.0425604
              L5D. |  -.1701094   .0948714    -1.79   0.076    -.3582864    .0180676
                   |
                m1 |  -.0129295   .0212711    -0.61   0.545    -.0551207    .0292616
                m2 |   .0230655   .0211959     1.09   0.279    -.0189765    .0651074
                m3 |  -.0120234   .0220335    -0.55   0.586    -.0557268      .03168
                m4 |   .0106776   .0218502     0.49   0.626    -.0326621    .0540173
                m5 |   .0379684   .0215915     1.76   0.082    -.0048583    .0807952
                m6 |   .0272323   .0215653     1.26   0.210    -.0155424    .0700069
                m7 |  -.0216364   .0213979    -1.01   0.314     -.064079    .0208063
                m8 |   .0154331   .0210082     0.73   0.464    -.0262366    .0571028
                m9 |   .0206819    .021546     0.96   0.339    -.0220544    .0634182
               m10 |   .0210709   .0217906     0.97   0.336    -.0221507    .0642924
               m11 |   .0089656   .0216561     0.41   0.680    -.0339891    .0519203
             _cons |  -.0075658   .0151177    -0.50   0.618    -.0375517    .0224201
      ------------------------------------------------------------------------------
      
   205 . scalar drop _all
      
   206 . quietly forval w=12(12)84 {
      
   207 . scalar list
      RWmaxobs84 =         84
      RWminobs84 =          2
        RWrmse84 =  .06004448
      RWmaxobs72 =         72
      RWminobs72 =          2
        RWrmse72 =   .0605325
      RWmaxobs60 =         60
      RWminobs60 =          2
        RWrmse60 =  .06068574
      RWmaxobs48 =         48
      RWminobs48 =          2
        RWrmse48 =  .06037733
      RWmaxobs36 =         36
      RWminobs36 =          2
        RWrmse36 =  .06130591
      RWmaxobs24 =         24
      RWminobs24 =          2
        RWrmse24 =  .06544875
      RWmaxobs12 =         12
      RWminobs12 =          2
        RWrmse12 =  .07012904
      
   208 . /*
      > RWmaxobs84 =         84
      > RWminobs84 =          2
      > RWrmse84 =  .06004448
      > */
   209 . 
   210 . reg d.lnWeeklyEarnings l3d.lnWeeklyEarnings l5d.lnWeeklyEarnings l7d.lnWeekly
      > Earnings
      
            Source |       SS           df       MS      Number of obs   =       114
      -------------+----------------------------------   F(3, 110)       =      4.04
             Model |  .027592174         3  .009197391   Prob > F        =    0.0091
          Residual |  .250484433       110  .002277131   R-squared       =    0.0992
      -------------+----------------------------------   Adj R-squared   =    0.0747
             Total |  .278076607       113  .002460855   Root MSE        =    .04772
      
      ------------------------------------------------------------------------------
      D.           |
      lnWeeklyEa~s |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
      -------------+----------------------------------------------------------------
      lnWeeklyEa~s |
              L3D. |  -.2446256   .0905231    -2.70   0.008    -.4240211   -.0652301
              L5D. |  -.1957955   .0901769    -2.17   0.032    -.3745049   -.0170861
              L7D. |   .0649411   .0912448     0.71   0.478    -.1158846    .2457668
                   |
             _cons |   .0027599   .0044776     0.62   0.539    -.0061138    .0116335
      ------------------------------------------------------------------------------
      
   211 . scalar drop _all
      
   212 . quietly forval w=12(12)84 {
      
   213 . scalar list
      RWmaxobs84 =         84
      RWminobs84 =          2
        RWrmse84 =  .05250414
      RWmaxobs72 =         72
      RWminobs72 =          2
        RWrmse72 =  .05277312
      RWmaxobs60 =         60
      RWminobs60 =          2
        RWrmse60 =  .05308846
      RWmaxobs48 =         48
      RWminobs48 =          2
        RWrmse48 =  .05299891
      RWmaxobs36 =         36
      RWminobs36 =          2
        RWrmse36 =  .05349229
      RWmaxobs24 =         24
      RWminobs24 =          2
        RWrmse24 =  .05283688
      RWmaxobs12 =         12
      RWminobs12 =          2
        RWrmse12 =  .06056213
      
   214 . /*
      > RWmaxobs84 =         84
      > RWminobs84 =          2
      > RWrmse84 =  .05250414
      > */
   215 . 
   216 . /*
      > gsreg dlnCount l1dlnCount l2dlnCount l3dlnCount l4dlnCount l5dlnCount l6dlnCo
      > unt ///
      >         l7dlnCount l8dlnCount l9dlnCount l10dlnCount l11dlnCount l12dlnCount 
      > l24dlnCount ///
      >         l1dlnWeekHours l2dlnWeekHours l3dlnWeekHours l4dlnWeekHours l5dlnWeek
      > Hours l6dlnWeekHours ///
      >         l7dlnWeekHours l8dlnWeekHours l9dlnWeekHours l10dlnWeekHours l11dlnWe
      > ekHours l12dlnWeekHours l24dlnWeekHours ///
      >         l1dlnHourlyEarnings l2dlnHourlyEarnings l3dlnHourlyEarnings l4dlnHour
      > lyEarnings ///
      >         l5dlnHourlyEarnings l6dlnHourlyEarnings ///
      >         l7dlnHourlyEarnings l8dlnHourlyEarnings l9dlnHourlyEarnings l10dlnHou
      > rlyEarnings ///
      >         l11dlnHourlyEarnings l12dlnHourlyEarnings l24dlnHourlyEarnings ///
      >         l1dlnWeeklyEarnings l2dlnWeeklyEarnings l3dlnWeeklyEarnings l4dlnWeek
      > lyEarnings ///
      >         l5dlnWeeklyEarnings l6dlnWeeklyEarnings ///
      >         l7dlnWeeklyEarnings l8dlnWeeklyEarnings l9dlnWeeklyEarnings l10dlnWee
      > klyEarnings ///
      >         l11dlnWeeklyEarnings l12dlnWeeklyEarnings l24dlnWeeklyEarnings if tin
      > (2011m1,2021m1), ///
      >         ncomb(1,4) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) 
      > ///
      >         samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnWeekly
      > Earnings_Full) replace
      > */
   217 . 
   218 . log close
            name:  <unnamed>
             log:  /Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Probl
      > em Sets/Final Project/Final Project.smcl
        log type:  smcl
       closed on:   8 Apr 2021, 17:48:56
      -------------------------------------------------------------------------------
```

