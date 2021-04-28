*Problem Set 5 Solution

clear
set more off
cd "C:\Users\jdewey\Documents\A S20 Time Series\Problem Sets\"
log using "Problem Set 5 Work", replace


** data prep
import delimited using "us and florida economic time series.txt" 
rename observation_date datestring
gen dateday=date(datestring,"YMD")
gen date=mofd(dateday)
format date %tm
tsset date
tsappend, add(1)
generate month=month(dofm(date))
tabulate month, generate(m)
keep if date>=tm(1990m1)
rename flbppriv fl_bp
rename fllfn fl_lf
rename flnan fl_nonfarm
rename lnu02300000_20200110 us_epr
gen lnflnonfarm=ln( fl_nonfarm)
gen lnfllf=ln( fl_lf)
gen lnusepr = ln(us_epr)
gen lnflbp=ln( fl_bp)

*generate differences and lags thereof for use with gsreg
gen dlnflnonfarm=d.lnflnonfarm
gen ldlnflnonfarm=ld.lnflnonfarm
gen l2dlnflnonfarm=l2d.lnflnonfarm
gen l3dlnflnonfarm=l3d.lnflnonfarm
gen l4dlnflnonfarm=l4d.lnflnonfarm
gen l5dlnflnonfarm=l5d.lnflnonfarm
gen l6dlnflnonfarm=l6d.lnflnonfarm
gen l12dlnflnonfarm=l12d.lnflnonfarm
gen l24dlnflnonfarm=l24d.lnflnonfarm

gen ldlnusepr=ld.lnusepr
gen l2dlnusepr=l2d.lnusepr
gen l3dlnusepr=l3d.lnusepr
gen l4dlnusepr=l4d.lnusepr
gen l12dlnusepr=l12d.lnusepr

gen ldlnflbp=ld.lnflbp
gen l2dlnflbp=l2d.lnflbp
gen l3dlnflbp=l3d.lnflbp
gen l4dlnflbp=l4d.lnflbp
gen l12dlnflbp=l12d.lnflbp

gen ldlnfllf=ld.lnfllf
gen l2dlnfllf=l2d.lnfllf
gen l3dlnfllf=l3d.lnfllf
gen l4dlnfllf=l4d.lnfllf
gen l12dlnfllf=l12d.lnfllf


tab month, generate(m)


*Turn gsreg on by uncommenting it only when you want it to run

/*
gsreg dlnflnonfarm ldlnflnonfarm l2dlnflnonfarm l3dlnflnonfarm ///
	l4dlnflnonfarm l5dlnflnonfarm l6dlnflnonfarm ///
	l12dlnflnonfarm l24dlnflnonfarm ///  
	ldlnfllf l2dlnfllf l3dlnfllf l4dlnfllf l12dlnfllf ///
	ldlnusepr l2dlnusepr l3dlnusepr l4dlnusepr l12dlnusepr ///
	ldlnflbp l2dlnflbp l3dlnflbp l4dlnflbp l12dlnflbp , ///
	nocount results(ps5models2.dta) replace ///
    fix(m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12) ncomb(1,8) ///
	aic outsample(24) nindex( -1 aic -1 bic -1 rmse_out) samesample 
*/

	
	
/*
Checking the gsreg output, the best model with 3, 4, 5, 5, or 7 variables:
GRSEG Rank 1: d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm 
GSREG Rank 2: d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(4)d.lnusepr 
GSREG Rank 4: d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(4)d.lnusepr l(2)d.lnflbp 
GSREG Rank 7: d.lnflnonfarm l(3,12,24)d.lnflnonfarm 
GSREG Rank 37: d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(3)d.lnfllf ///
		l(4)d.lnusepr l(2)d.lnflbp 

AS benchmarks, I also consider:
A purely AR model with all lags of y searched:
	reg d.lnflnonfarm l(1/4,12,24)d.lnflnonfarm 
A model with all the variables searched over:
	reg d.lnflnonfarm l(1/4,12,24)d.lnflnonfarm l(1/4)d.lnfllf 
		l(1/4)d.lnusepr l(1/4)d.lnflbp 
A model with all the variables that most commonly appeared in the top 1000
	reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(2,3)d.lnfllf ///
		l(2,3,4)d.lnusepr l(1,2)d.lnflbp 
*/





************************
*Three benchmark models


*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(1/4,12,24)d.lnflnonfarm l(1/4)d.lnfllf ///
		l(1/4)d.lnusepr l(1/4)d.lnflbp ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program


*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(1/4,12,24)d.lnflnonfarm ///
	md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program



*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(2/4,12,24)d.lnflnonfarm l(2,3)d.lnfllf  ///
		l(2/4)d.lnusepr l(1/2)d.lnflbp ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program



***************************

*Five GSREG models


*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program




*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(4)d.lnusepr ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program




*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm ///
		l(4)d.lnusepr l(2)d.lnflbp ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program




*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(3,12,24)d.lnflnonfarm ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program




*Rolling window program
scalar drop _all
quietly forval w=48(12)180 { 
/* small is the smallest window, inc is the window size increment,
large is the largest window. (large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=565/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'-`w' // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(3)d.lnfllf  ///
		l(4)d.lnusepr l(2)d.lnflbp ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflnonfarm)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program


*/

/* GSREG Model 2 at 8 years is the best, by a hair, on RWRMSE.
Could easily choose GSREG 1, 4, or 7 too.
Run Rolling Window again, just for w=96, for GSREG 2
Don't clear for next loop,  to get info on this model. */

*Rolling window program
scalar drop _all
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	quietly forval t=481/719 { 
	/* first is the first date for which you want to make a forecast.
	first-1 is the end date of the earliest window used to fit the model.
	first-w, where w is the window width, is the date of the first
	observation used to fit the model in the earliest window.
	You must choose first so it is preceded by a full set of
    lags for the model with the longest lag length to be estimated.
	last is  the last observation to be forecast. */
	gen wstart=`t'- 96 // fit window start date
	gen wend=`t'-1 // fit window end date
	/* Enter the regression command immediately below.
	Leave the if statement intact to control the window  */
	reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(4)d.lnusepr ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen res=d.lnflnonfarm-pred
gen errsq=res^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse96=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs96=r(min) // min obs used in the window width
scalar RWmaxobs96=r(max) // max obs used in the window width
*drop errsq pred nobs // clearing for the next loop

scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program


*Forecast from selected model

reg d.lnflnonfarm l(3,4,12,24)d.lnflnonfarm l(4)d.lnusepr ///
		md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12 ///
		if tin(2012m1,2019m12)
predict temp if date==tm(2020m1)
replace pred=temp if date==tm(2020m1)

*Empirical forecast and interval
gen expres=exp(res)
summ expres
gen epy=exp(l.lnflnonfarm+pred)*r(mean)
_pctile res, percentiles(2.5,97.5)
gen eub=epy*exp(r(r2))
gen elb=epy*exp(r(r1))

twoway (scatter fl_nonfarm date if tin(2017m1,2019m12) , m(Oh) ) ///
	(tsline epy eub elb if tin(2017m1,2020m1) , ///
		lpattern(solid dash dash) lcolor(black gs10 gs10) ) , ///
	saving(ps5_fcst, replace) scheme(s1mono) ylabel(,grid) xtitle("") ///
	legend(label(1 "Nonfarm Employment") label(2 "Forecast") ///
		label(3 "95% Upper Bound") label(4 "95% Lower Bound") ) ///
	title("Florida Nonfarm Employment" "One Month Ahead Forecast") ///
	note("1) All forecasts are out of sample based on a 96 month rolling window." ///
	"2) Inteval based on percentiles 2.5 and 97.5 of the empirical forecast error distribution." ///
	"3) Predictors are lags 3, 4, 12, 24 of nonfarm employment and lag 4 of the US emp:pop ratio." )

graph export ps5empfcst.emf, replace

list epy eub elb if date==tm(2020m1)

*Normal forecast and interval
gen npy=exp(l.lnflnonfarm+pred+(RWrmse96^2)/2)
gen nub=npy*exp(1.96*RWrmse96)
gen nlb=npy/exp(1.96*RWrmse96)
	
twoway (scatter fl_nonfarm date if tin(2017m1,2019m12) , m(Oh) ) ///
	(tsline npy nub nlb if tin(2017m1,2020m1) , ///
		lpattern(solid dash dash) lcolor(black gs10 gs10) ) , ///
	saving(ps5_fcst, replace) scheme(s1mono) ylabel(,grid) xtitle("") ///
	legend(label(1 "Nonfarm Employment") label(2 "Forecast") ///
		label(3 "95% Upper Bound") label(4 "95% Lower Bound") ) ///
	title("Florida Nonfarm Employment" "One Month Ahead Forecast") ///
	note("1) All forecasts are out of sample based on a 96 month rolling window." ///
	"2) Inteval based on percentiles +-1.95 RMMSE from the rolling window procedure." ///
	"3) Predictors are lags 3, 4, 12, 24 of nonfarm employment and lag 4 of the US emp:pop ratio." )

graph export ps5normfcst.emf, replace

list npy nub nlb if date==tm(2020m1)


hist res, frac normal scheme(s1mono)  ///
	title("Empirical Forecast Error Distribution") ///
	xtitle("") note("For 96 month rolling window forecasts.")
graph export ps5errdist.emf , replace

summ res
gen nres=(res-r(mean))/r(sd)

qnorm nres, scheme(s1mono)  ///
	title("Quantile-Normal Plot of Forecast Error") ///
	xtitle("Inverse Standard Normal of Residual Percentile") ///
	ytitle("Residual Z-Score") ///
	xlabel(-6(2)4,grid) ylabel(-6(2)4,grid) ///
	note("For 96 month rolling window forecasts.")
graph export ps5qnorm.emf , replace

clear
log close
