* Time Series Modeling and Forecasting
* Spring 2020

clear
set more off

*set the working directory to wherever you have the data"
cd "C:\Users\jdewey\Documents\A S20 Time Series\data and do files"


** data prep
import delimited using "us and florida economic time series.txt" 
rename observation_date datestring
gen dateday=date(datestring,"YMD") // generating a daily date
gen date=mofd(dateday) // generating a monthly date
format date %tm // formatting dates to display as 1980m1 for Jan 1980
tsset date // tells state that the time index is the monthly date
tsappend, add(3) // adding three months to forecast
generate month=month(dofm(date)) // generating numeric month, 1-12
keep if tin(1988m1,2020m3) // building permit data starts 1988
tab month, generate(m) // convenient way to make month dummies, m
rename flbppriv fl_bp // florida building permits
rename fllfn fl_lf // florida labor force
rename flnan fl_nonfarm // florida non farm employment
rename lnu02300000_20200110 us_epr // us employment to population ratio
gen lnflnonfarm=ln( fl_nonfarm) // taling the log
gen lnfllf=ln( fl_lf) // taking the log
gen lnusepr = ln(us_epr) // taking the log
gen lnflbp=ln( fl_bp) // taking the log



/* Let us forecast 1, 2, 3, and 4 months ahead
Let GSREG find the best for each horizon, ignoring windows for now.
We will hardcode variables to make it easier. */

gen dlnflbp=d.lnflbp 

gen l1dlnflbp=l1d.lnflbp 
gen l2dlnflbp=l2d.lnflbp
gen l3dlnflbp=l3d.lnflbp
gen l4dlnflbp=l4d.lnflbp
gen l12dlnflbp=l12d.lnflbp
gen l24dlnflbp=l24d.lnflbp

gen l1dlnusepr=l1d.lnusepr 
gen l2dlnusepr=l2d.lnusepr
gen l3dlnusepr=l3d.lnusepr
gen l4dlnusepr=l4d.lnusepr
gen l12dlnusepr=l12d.lnusepr 
gen l24dlnusepr=l24d.lnusepr

gen l1dlnflnonfarm=l1d.lnflnonfarm
gen l2dlnflnonfarm=l2d.lnflnonfarm
gen l3dlnflnonfarm=l3d.lnflnonfarm
gen l4dlnflnonfarm=l4d.lnflnonfarm
gen l12dlnflnonfarm=l12d.lnflnonfarm
gen l24dlnflnonfarm=l24d.lnflnonfarm



/*We will keep the search to not many possible covariates for time.
Not adding any lags older than we had before, and keeping
combinations to 6 or less, for time */


/* Not acrually running the GSREG for class, for time
Need to turn this on if you adapt this for another problem

***Notice the nocount option***

*To find the best for h=1
gsreg dlnflbp l1dlnflbp l2dlnflbp l3dlnflbp l4dlnflbp l12dlnflbp ///
	l1dlnflnon l2dlnflnon l3dlnflnon l4dlnflnon l12dlnflnon ///
	l1dlnusepr l2dlnusepr l3dlnusepr l4dlnusepr l12dlnusepr ///
	, nocount ncomb(1,6) aic outsample(24) ///
	fix(md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12) samesample ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) replace


*To find the best for h=2
gsreg dlnflbp l2dlnflbp l3dlnflbp l4dlnflbp l12dlnflbp ///
	l2dlnflnon l3dlnflnon l4dlnflnon l12dlnflnon ///
	l2dlnusepr l3dlnusepr l4dlnusepr l12dlnusepr ///
	, nocount ncomb(1,6) aic outsample(24) ///
	fix(md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12) samesample ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) replace


*To find the best for h=3
gsreg dlnflbp l3dlnflbp l4dlnflbp l12dlnflbp ///
	l3dlnflnon l4dlnflnon l12dlnflnon ///
	l3dlnusepr l4dlnusepr l12dlnusepr ///
	, nocount ncomb(1,6) aic outsample(24) ///
	fix(md2 md3 md4 md5 md6 md7 md8 md9 md10 md11 md12) samesample ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) replace
	
*/

  
/* Here are the ones ranked #1 by gsreg
Really we should take the most promising several and test them further
but for illustration, we will just take the top one for each horizon

For H=1: reg d.lnflbp l(1,2)d.lnflbp l(2,3,12)d.lnflnon l4d.lnusepr md2-12
For H=2: reg d.lnflbp l(3,12)d.lnflbp l(2)d.lnflnon md2-12
For H=3: reg d.lnflbp l(3,12)d.lnflbp md2-12

*/

/*

*What window width? What is the RWRMSE?

summ date if date==tm(1988m1) // date is 336
summ date if date==tm(2019m12) // date is 719
*max window of 20 years, 240 months
*max lags of 12, one difference
*first usable data point is then t = 336+12+1 = 349
* end of first window of 180 is then t = 349+240-1 = 588
*first out of sample prediction is then t = 589

*Rolling window program H=1
scalar drop _all
quietly forval w=48(12)240 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=589/719 { 
	/* t=first/last
	first is the first date for which you want to make a forecast.
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
	reg d.lnflbp l(1,2)d.lnflbp l(2,3,12)d.lnflnon l4d.lnusepr  ///
		m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflbp)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // min obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program

*Rolling window program H=2
scalar drop _all
quietly forval w=48(12)240 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=589/719 { 
	/* t=first/last
	first is the first date for which you want to make a forecast.
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
	reg d.lnflbp l(3,12)d.lnflbp l(2)d.lnflnon  ///
		m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflbp)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // min obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program

*Rolling window program H=3
scalar drop _all
quietly forval w=48(12)240 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=589/719 { 
	/* t=first/last
	first is the first date for which you want to make a forecast.
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
	reg d.lnflbp l(3,12)d.lnflbp l(2)d.lnflnon  ///
		m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnflbp)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // min obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program


*/

*Seems to take 15+ years to flatten in all cases
*Go with 20 years, w=240
* From above output:
scalar rwrmse1=0.152
scalar rwrmse2=0.173
scalar rwrmse3=0.173

*Note that uncertainty did not increase, empirically. from H=2 to H=3
*Not usual, but not impossible.

*Construct normal intervals for each one, 



*H=1
reg d.lnflbp l(1,2)d.lnflbp l(2,3,12)d.lnflnon l4d.lnusepr  ///
		m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if tin(2000m1,2019m12)
predict pd 
gen pflbp=exp((rwrmse1^2)/2)*exp(l.lnflbp+pd) if date==tm(2020m1)
gen ub=exp((rwrmse1^2)/2)*exp(l.lnflbp+pd+2*rwrmse1) if date==tm(2020m1)
gen lb=exp((rwrmse1^2)/2)*exp(l.lnflbp+pd-2*rwrmse1) if date==tm(2020m1)
drop pd

*H=2
reg d.lnflbp l(3,12)d.lnflbp l(2)d.lnflnon  ///
		m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if tin(2000m1,2019m12) 
predict pd  
replace pflbp=exp((rwrmse2^2)/2)*exp(l2.lnflbp+pd) if date==tm(2020m2)
replace ub=exp((rwrmse2^2)/2)*exp(l2.lnflbp+pd+2*rwrmse2) if date==tm(2020m2)
replace lb=exp((rwrmse2^2)/2)*exp(l2.lnflbp+pd-2*rwrmse2) if date==tm(2020m2)
drop pd

*H=3
reg d.lnflbp l(3,12)d.lnflbp  ///
		m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 m12 if tin(2000m1,2019m12)
predict pd 
replace pflbp=exp((rwrmse3^2)/2)*exp(l3.lnflbp+pd) if date==tm(2020m3)
replace ub=exp((rwrmse3^2)/2)*exp(l3.lnflbp+pd+2*rwrmse3) if date==tm(2020m3)
replace lb=exp((rwrmse3^2)/2)*exp(l3.lnflbp+pd-2*rwrmse3) if date==tm(2020m3)
drop pd

gen y=fl_bp if date==tm(2019m12)
replace y=pflbp if date>tm(2019m12)
gen yub=fl_bp if date==tm(2019m12)
replace yub=ub if date>tm(2019m12)
gen ylb=fl_bp if date==tm(2019m12)
replace ylb=lb if date>tm(2019m12)

tsline fl_bp y ylb yub if tin(2019m6,2020m3) , ///
	title("Actual and Forecast Florida Building Permits, Monthly") /// 
	ytitle("New Private Building Permits") xtitle("") ///
	legend(label(1 "Actual") label(2 "Forecast") ///
	label(3 "Lower Bound") label(4 "Upper Bound") )

STOP
	
*What about other degrees of confidence?
*How to construct a fan chart
	
**Recall 68-95-99.7 Rule???

rename yub yub2
rename ylb ylb2

gen ylb1=fl_bp if date==tm(2019m12)
replace ylb1=ylb2*exp((-1+2)*rwrmse1) if date==tm(2020m1)
replace ylb1=ylb2*exp((-1+2)*rwrmse2) if date==tm(2020m2)
replace ylb1=ylb2*exp((-1+2)*rwrmse3) if date==tm(2020m3)

gen yub1=fl_bp if date==tm(2019m12)
replace yub1=yub2*exp((1-2)*rwrmse1) if date==tm(2020m1)
replace yub1=yub2*exp((1-2)*rwrmse2) if date==tm(2020m2)
replace yub1=yub2*exp((1-2)*rwrmse3) if date==tm(2020m3)

gen ylb3=fl_bp if date==tm(2019m12)
replace ylb3=ylb2*exp((-3+2)*rwrmse1) if date==tm(2020m1)
replace ylb3=ylb2*exp((-3+2)*rwrmse2) if date==tm(2020m2)
replace ylb3=ylb2*exp((-3+2)*rwrmse3) if date==tm(2020m3)

gen yub3=fl_bp if date==tm(2019m12)
replace yub3=yub2*exp((3-2)*rwrmse1) if date==tm(2020m1)
replace yub3=yub2*exp((3-2)*rwrmse2) if date==tm(2020m2)
replace yub3=yub2*exp((3-2)*rwrmse3) if date==tm(2020m3)


*Table
list date y ylb3 ylb2 ylb1 yub1 yub2 yub3 if tin(2019m12,2020m3)

*Fan Charts

tsline  fl_bp y ylb3 ylb2 ylb1 yub1 yub2 yub3 ///
	if tin(2019m1,2020m3) , legend(off) ///
	lpattern( solid solid longdash dash shortdash shortdash dash longdash) ///
	lcolor(black blue red orange gray gray orange red) ///
	title("Florida Building Permits"  ///
	"Forecast Fan Chart for 1, 2, and 3 Month Horizons") legend(off) ///
	xtitle("") note("Launch date is 2019m12" "Bands at 1, 2, and 3 sigma")

	
twoway (tsrline yub3 yub2 if tin(2019m1,2020m3), ///
	recast(rarea) fcolor(red) fintensity(5) lwidth(none) ) ///
	(tsrline yub2 yub1 if tin(2019m1,2020m3), ///
	recast(rarea) fcolor(red) fintensity(15) lwidth(none) ) ///
	(tsrline yub1 y if tin(2019m1,2020m3), ///
	recast(rarea) fcolor(red) fintensity(35) lwidth(none) ) ///
	(tsrline y ylb1 if tin(2019m1,2020m3), ///
	recast(rarea) fcolor(red) fintensity(35) lwidth(none) ) ///
	(tsrline ylb1 ylb2 if tin(2019m1,2020m3), ///
	recast(rarea) fcolor(red) fintensity(15) lwidth(none) ) ///
	(tsrline ylb2 ylb3 if tin(2019m1,2020m3), ///
	recast(rarea) fcolor(red) fintensity(5) lwidth(none) ) ///
	(tsline fl_bp y if tin(2019m1,2020m3) , ///
	lcolor(gs6 gs12) lwidth(thick thick) ), scheme(s1mono) legend(off) ///
	title("Florida Building Permits"  ///
	"Forecast Fan Chart for 1, 2, and 3 Month Horizons") legend(off) ///
	xtitle("") ylabel(,grid) ///
	note("Launch date is 2019m12" "Bands at 1, 2, and 3 sigma")

	
log close
	
	
	
	
	
	

