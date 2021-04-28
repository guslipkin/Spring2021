clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 6"
log using "Problem Set 6", replace
import delimited "Assignment_1_Monthly.txt"

rename lnu02300000 us_epr
rename flnan fl_nonfarm
rename fllfn fl_lf
rename flbppriv fl_bp
rename date datestring

gen datec=date(datestring, "YMD")
gen date=mofd(datec)
gen month=month(datec)
format date %tm

tsset date

gen lnusepr=log(us_epr)
gen lnflnonfarm=log(fl_nonfarm)
gen lnfllf=log(fl_lf)
gen lnflbp=log(fl_bp)

drop if !tin(1990m1,2019m12)

tsset date
tsappend, add(12)
replace month=month(dofm(date))

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

gen dh2lnflnonfarm = lnflnonfarm - l2.lnflnonfarm
gen dh4lnflnonfarm = lnflnonfarm - l4.lnflnonfarm
gen dh6lnflnonfarm = lnflnonfarm - l6.lnflnonfarm

/*
*h=2

gsreg dh2lnflnonfarm l3dlnflnonfarm l6dlnflnonfarm l9dlnflnonfarm ///
	  l3dlnfllf l6dlnfllf l9dlnfllf ///
	  l3dlnusepr l6dlnusepr l9dlnusepr if tin(1990m1,2019m12), ///
	ncomb(1,8) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnh2) replace

/*
dh2lnflnonfarm l6dlnflnonfarm l9dlnflnonfarm l3dlnfllf l6dlnfllf l3dlnusepr l6dlnusepr
	m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
 */

*h=4

gsreg dh4lnflnonfarm l6dlnflnonfarm l9dlnflnonfarm l12dlnflnonfarm ///
	  l6dlnfllf l9dlnfllf l12dlnfllf ///
	  l6dlnusepr l9dlnusepr l12dlnusepr if tin(1990m1,2019m12), ///
	ncomb(1,8) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnh4) replace

/*
dh4lnflnonfarm l6dlnflnonfarm l9dlnflnonfarm l12dlnflnonfarm l6dlnfllf l9dlnfllf
	l6dlnusepr l9dlnusepr m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
*/

*h=6

gsreg dh4lnflnonfarm l6dlnflnonfarm l9dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm ///
	  l6dlnfllf l9dlnfllf l12dlnfllf l24dlnfllf ///
	  l6dlnusepr l9dlnusepr l12dlnusepr l24dlnusepr if tin(1990m1,2019m12), ///
	ncomb(1,8) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnh6) replace

/*
dh6lnflnonfarm l6dlnflnonfarm l9dlnflnonfarm l12dlnflnonfarm l6dlnfllf l9dlnfllf
	l6dlnusepr l9dlnusepr m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
*/

*h2
scalar drop _all
quietly forval w=48(12)180 {
gen pred=.
gen nobs=.
	forval t=565/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l(6,9)d.lnflnonfarm l(3,6)d.lnfllf l(3,6)d.lnusepr ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
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
RWmaxobs96 =         96
RWminobs96 =         96
RWrmse96 =  .00372845
*/
scalar rwrmseH2 = .00372845

*h4
scalar drop _all
quietly forval w=48(12)180 {
gen pred=.
gen nobs=.
	forval t=565/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l(6,9,12)d.lnflnonfarm l(6,9)d.lnfllf l(6,9)d.lnusepr ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
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
RWmaxobs96 =         96
RWminobs96 =         96
RWrmse96 =  .00373399
*/
scalar rwrmseH4 = .00373399

*h6
scalar drop _all
quietly forval w=48(12)180 {
gen pred=.
gen nobs=.
	forval t=565/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l(6,9,12)d.lnflnonfarm l(6,9)d.lnfllf l(6,9)d.lnusepr ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
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
RWmaxobs96 =         96
RWminobs96 =         96
RWrmse96 =  .00373399
*/

scalar rwrmseH2 = .00372845
scalar rwrmseH4 = .00373399
scalar rwrmseH6 = .00373399

*h2
reg dh2lnflnonfarm l(6,9)d.lnflnonfarm l(3,6)d.lnfllf l(3,6)d.lnusepr ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(2012m1,2019m12)
predict pd
gen pflnonfarm=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd) if date==tm(2020m2)
gen ub1=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd+1*rwrmseH2) if date==tm(2020m2)
gen lb1=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd-1*rwrmseH2) if date==tm(2020m2)
gen ub2=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd+2*rwrmseH2) if date==tm(2020m2)
gen lb2=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd-2*rwrmseH2) if date==tm(2020m2)
gen ub3=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd+3*rwrmseH2) if date==tm(2020m2)
gen lb3=exp((rwrmseH2^2)/2)*exp(l2.lnflnonfarm+pd-3*rwrmseH2) if date==tm(2020m2)
drop pd


*h4
reg dh4lnflnonfarm l(6,9,12)d.lnflnonfarm l(6,9)d.lnfllf l(6,9)d.lnusepr ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(2012m1,2019m12) 
predict pd
replace pflnonfarm=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd) if date==tm(2020m4)
replace ub1=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd+1*rwrmseH4) if date==tm(2020m4)
replace lb1=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd-1*rwrmseH4) if date==tm(2020m4)
replace ub2=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd+2*rwrmseH4) if date==tm(2020m4)
replace lb2=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd-2*rwrmseH4) if date==tm(2020m4)
replace ub3=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd+3*rwrmseH4) if date==tm(2020m4)
replace lb3=exp((rwrmseH4^2)/2)*exp(l4.lnflnonfarm+pd-3*rwrmseH4) if date==tm(2020m4)
drop pd

*h6
reg dh6lnflnonfarm l(6,9,12)d.lnflnonfarm l(6,9)d.lnfllf l(6,9)d.lnusepr ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(2012m1,2019m12)
predict pd 
replace pflnonfarm=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd) if date==tm(2020m6)
replace ub1=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd+1*rwrmseH6) if date==tm(2020m6)
replace lb1=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd-1*rwrmseH6) if date==tm(2020m6)
replace ub2=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd+2*rwrmseH6) if date==tm(2020m6)
replace lb2=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd-2*rwrmseH6) if date==tm(2020m6)
replace ub3=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd+3*rwrmseH6) if date==tm(2020m6)
replace lb3=exp((rwrmseH6^2)/2)*exp(l6.lnflnonfarm+pd-3*rwrmseH6) if date==tm(2020m6)
drop pd

replace pflnonfarm=fl_nonfarm if date==tm(2019m12)
replace ub1=fl_nonfarm if date==tm(2019m12)
replace ub2=fl_nonfarm if date==tm(2019m12)
replace ub3=fl_nonfarm if date==tm(2019m12)
replace lb1=fl_nonfarm if date==tm(2019m12)
replace lb2=fl_nonfarm if date==tm(2019m12)
replace lb3=fl_nonfarm if date==tm(2019m12)


*Table
list month pflnonfarm lb3 lb2 lb1 ub1 ub2 ub3 if tin(2019m12,2020m6)
*ARDL Fan Chart
twoway (tsrline ub3 ub2 if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(20) lwidth(none) ) ///
	(tsrline ub2 ub1 if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(40) lwidth(none) ) ///
	(tsrline ub1 pflnonfarm if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(65) lwidth(none) ) ///
	(tsrline pflnonfarm lb1 if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(65) lwidth(none) ) ///
	(tsrline lb1 lb2 if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(40) lwidth(none) ) ///
	(tsrline lb2 lb3 if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(20) lwidth(none) ) ///
	(tsline fl_nonfarm pflnonfarm if tin(2019m1,2020m6) , ///
	lcolor(gs12 teal) lwidth(medthick medthick) ///
	lpattern(solid longdash)) , scheme(s1mono) legend(off) ///
	title("Florida Nonfarm Employment"  ///
	"Forecast Fan Chart for 2, 4, and 6 Month Horizons") legend(off) ///
	xtitle("") ylabel(,grid)  ///
	note("Launch date is 2020m2" "Bands at 1, 2, and 3 sigma") ///
	saving("ardl.gph", replace)
	
graph export "ardl.png", replace
 
/*
Question 2
*/

gsreg dlnflnonfarm l2dlnflnonfarm l4dlnflnonfarm l6dlnflnonfarm ///
	l8dlnflnonfarm l10dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm ///
	l3dlnflnonfarm l5dlnflnonfarm l7dlnflnonfarm l9dlnflnonfarm l11dlnflnonfarm ///
	if tin(1990m1,2019m12), ///
	ncomb(1,8) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnh4) replace
	
/* 
dlnflnonfarm l3dlnflnonfarm l4dlnflnonfarm l5dlnflnonfarm l6dlnflnonfarm 
	l10dlnflnonfarm l12dlnflnonfarm l24dlnflnonfarm
*/


scalar drop _all
quietly forval w=48(12)180 {
gen pred=.
gen nobs=.
	forval t=562/720 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnflnonfarm l(3/6,10,12,24)d.lnflnonfarm ///
		m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
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
RWmaxobs108 =        108
RWminobs108 =        108
RWrmse108 =  .00355344
*/
*/
arima d.lnflnonfarm l(3,4,5,6,10,12,24)d.lnflnonfarm ///
	m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(1990m1,2019m12)
predict pnonfarm, dynamic(tm(2020m1))
predict mse, mse dynamic(mofd(tm(2020m1)))
gen totmse = mse if date==tm(2020m1)
replace totmse = l.totmse+mse if date>tm(2020m1)
gen pnonfarma = fl_nonfarm if date==tm(2019m12)
replace pnonfarma = l.pnonfarma*exp(pnonfarm+mse/2) if date>tm(2019m12)

gen ub1a = pnonfarma*exp(totmse^.5)
gen ub2a = pnonfarma*exp(2*totmse^.5)
gen ub3a = pnonfarma*exp(3*totmse^.5)
gen lb1a = pnonfarma/exp(totmse^.5)
gen lb2a = pnonfarma/exp(2*totmse^.5)
gen lb3a = pnonfarma/exp(3*totmse^.5)

replace ub1a=fl_nonfarm if date == tm(2019m12)
replace ub2a=fl_nonfarm if date == tm(2019m12)
replace ub3a=fl_nonfarm if date == tm(2019m12)
replace lb1a=fl_nonfarm if date == tm(2019m12)
replace lb2a=fl_nonfarm if date == tm(2019m12)
replace lb3a=fl_nonfarm if date == tm(2019m12)

twoway (tsrline ub3a ub2a if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(20) lwidth(none) ) ///
	(tsrline ub2a ub1a if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(40) lwidth(none) ) ///
	(tsrline ub1a pnonfarma if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(65) lwidth(none) ) ///
	(tsrline pnonfarma lb1a if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(65) lwidth(none) ) ///
	(tsrline lb1a lb2a if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(40) lwidth(none) ) ///
	(tsrline lb2a lb3a if tin(2019m1,2020m6), ///
	recast(rarea) fcolor(khaki) fintensity(20) lwidth(none) ) ///
	(tsline fl_nonfarm pnonfarma if tin(2019m1,2020m6) , ///
	lcolor(gs12 teal) lwidth(medthick medthick) ///
	lpattern(solid longdash)) , scheme(s1mono) legend(off) ///
	saving("ar.gph", replace)
	
graph export "ar.png", replace

translate "Problem Set 6.smcl" "Problem Set 6.txt", replace
log close
