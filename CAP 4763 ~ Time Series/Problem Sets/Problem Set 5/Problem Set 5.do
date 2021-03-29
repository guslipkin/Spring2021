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
gen m12=0
replace m11=1 if month==12

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

/*
gsreg dlnflnonfarm l1dlnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l9dlnflnonfarm ///
      l12dlnflnonfarm l24dlnflnonfarm ///
	  l1dlnfllf l3dlnfllf l6dlnfllf l9dlnfllf ///
      l12dlnfllf l24dlnfllf ///
	  l1dlnusepr l3dlnusepr l6dlnusepr l9dlnusepr ///
      l12dlnusepr l24dlnusepr if tin(1990m1,2019m12), ///
	ncomb(1,6) aic outsample(24) fix(m1 m3 m6 m9 m12) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnrer) replace
*/

*5
/* 
Best model
reg dlnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm 
	l24dlnfllf l6dlnusepr m1 m3 m6 m9 m12
*/
scalar drop _all
quietly forval w=48(12)240 {
gen pred=.
gen nobs=.
	forval t=432/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l3d.lnflnonfarm l6d.lnflnonfarm l12d.lnflnonfarm l24d.lnflnonfarm ///
		l24d.lnfllf l6d.lnusepr m1 m3 m6 m9 m12 ///
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
RWmaxobs156 =        156
RWminobs156 =         47
RWrmse156 =  .00387308
*/

/*
Smallest / best model
reg dlnflnonfarm l12dlnflnonfarm m1 m3 m6 m9 m12
*/
scalar drop _all
quietly forval w=48(12)240 {
gen pred=.
gen nobs=.
	forval t=432/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnflnonfarm l12dlnflnonfarm m1 m3 m6 m9 m12 ///
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
RWmaxobs228 =        228
RWminobs228 =         59
RWrmse228 =  .00407004

*/

/*
Best medium length model
reg dlnflnonfarm l3dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm l6dlnusepr
	m1 m3 m6 m9 m12
*/
scalar drop _all
quietly forval w=48(12)240 {
gen pred=.
gen nobs=.
	forval t=432/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg dlnflnonfarm l3dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm l6dlnusepr ///
		m1 m3 m6 m9 m12 ///
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
RWmaxobs156 =        156
RWminobs156 =         47
RWrmse156 =  .00391717
*/

*6
/*
RWmaxobs156 =        156
RWminobs156 =         47
RWrmse156 =  .00387308
*/
scalar drop _all
quietly forval w=156(12)156 {
gen pred=.
gen nobs=.
	forval t=432/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l3d.lnflnonfarm l6d.lnflnonfarm l12d.lnflnonfarm l24d.lnflnonfarm ///
		l24d.lnfllf l6d.lnusepr m1 m3 m6 m9 m12 ///
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
