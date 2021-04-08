clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Final Project"
log using "Final Project.smcl", replace
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

/*----------------------------------------------------------------------------*/
	
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

log close
translate "Final Project.smcl" "Final Project.txt", replace
