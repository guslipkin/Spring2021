* Time Series Modeling and Forecasting
* Spring 2020

clear
set more off

*set the working directory to wherever you have the data"
cd "C:\Users\jdewey\Documents\A S20 Time Series\data and do files"

*import the data
**we will be using data on the US Federal Budget
**Talk about FRED***

import delimited "Federal_Government_Budget_Quarterly.txt"

rename b230rc0q173sbea population
*population, thousands

rename gdpdef_20191220 gdpdef
*100 in 2012

rename na000283q fedexp
*Current expenditures, millions

rename na000304q fedrcpt
*Current receipts, millions

rename na000334q_20191220 gdp
*GDP, millions

rename observation_date datestring
gen datec=date(datestring,"YMD")
gen date=qofd(datec)
format date %tq
tsset date

*generate variable
generate rgdppc=gdp/(pop*gdpdef/100)
gen reratio=fedrcpt/fedexp
gen lnreratio=ln(reratio)
gen lnrgdppc=ln(rgdppc)
generate quarter=quarter(datec)

gen q1=0
replace q1=1 if quarter==1
gen q2=0
replace q2=1 if quarter==2
gen q3=0
replace q3=1 if quarter==3
gen q4=0
replace q4=1 if quarter==4


gen dlnreratio=d.lnreratio // gsreg and asreg do not like time series operators

gen l1dlnreratio=l1d.lnreratio 
gen l2dlnreratio=l2d.lnreratio
gen l3dlnreratio=l3d.lnreratio
gen l4dlnreratio=l4d.lnreratio
gen l5dlnreratio=l5d.lnreratio
gen l6dlnreratio=l6d.lnreratio
gen l7dlnreratio=l7d.lnreratio
gen l8dlnreratio=l8d.lnreratio

gen l1dlnrgdppc=l1d.lnrgdppc  
gen l2dlnrgdppc=l2d.lnrgdppc
gen l3dlnrgdppc=l3d.lnrgdppc
gen l4dlnrgdppc=l4d.lnrgdppc
 
  
/*Last time, we ran this search
gsreg dlnreratio l1dlnreratio l2dlnreratio l3dlnreratio l4dlnreratio ///
	l5dlnreratio l6dlnreratio l7dlnreratio l8dlnreratio /// 
	l1dlnrgdppc l2dlnrgdppc l3dlnrgdppc l4dlnrgdppc if tin(1980q1, 2019q3), ///
	ncomb(1,8) aic outsample(10) fix(q2 q4) samesample ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) results(gsreg_dlnrer) replace	
  
We decided to look at results file for models worth comparing further
We will just do these four to keep it simple for class, should do more

	1: 1,2,6,8,10,13 
	2: 1,2,3,6,8,10,13
	15: 1,2,6,8,10
	26: 1,2,6,8,13

reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 , the one from before
reg d.lnreratio l(4,6,8)d.lnreratio l(3)d.lnrgdp q2 q4 , gsreg #1
reg d.lnreratio l(1,4,6,8)d.lnreratio l(3)d.lnrgdp q2 q4, gsreg #2
reg d.lnreratio l(4,6,8)d.lnreratio q2 q4, gsreg #15
reg d.lnreratio l(4,6)d.lnreratio l(3)d.lnrgdp q2 q4 , gsreg #26

How are we going to cross validate and select from these?

*Discussion on rolling window estimates

*/


summ date
/**date from -52 to 238
examing at most a 20 year window means 80 0bservations
plus the longest lag plus one for difference before our first prediction
1980q1 is date=80, we will make it our first forecast */


*Rolling window program
scalar drop _all
quietly forval w=16(4)80 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=80/238 { 
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
	reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4  ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnreratio)^2 // generating squared errors
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
quietly forval w=16(4)80 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=80/238 { 
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
	reg d.lnreratio l(4,6,8)d.lnreratio l(3)d.lnrgdp q2 q4   ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnreratio)^2 // generating squared errors
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
quietly forval w=16(4)80 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=80/238 { 
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
	reg d.lnreratio l(1,4,6,8)d.lnreratio l(3)d.lnrgdp q2 q4  ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnreratio)^2 // generating squared errors
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
quietly forval w=16(4)80 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=80/238 { 
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
	reg d.lnreratio l(4,6,8)d.lnreratio q2 q4   ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnreratio)^2 // generating squared errors
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
quietly forval w=16(4)80 { 
/* w=small(inc)large
small is the smallest window
inc is the window size increment
large is the largest window.
(large-small)/inc must be an interger */
gen pred=. // out of sample prediction
gen nobs=. // number of observations in the window for each forecast point		
	forval t=80/238 { 
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
	reg d.lnreratio l(1,4,6)d.lnreratio l(3)d.lnrgdp q2 q4  ///
		if date>=wstart & date<=wend // restricts the model to the window
	replace nobs=e(N) if date==`t' // number of observations used
	predict ptemp // temporary predicted values
	replace pred=ptemp if date==`t' // saving the single forecast value
	drop ptemp wstart wend // clear these to prepare for the next loop
	}
gen errsq=(pred-d.lnreratio)^2 // generating squared errors
summ errsq // getting the mean of the squared errors
scalar RWrmse`w'=r(mean)^.5 // getting the rmse for window width i
summ nobs // getting min and max obs used
scalar RWminobs`w'=r(min) // in obs used in the window width
scalar RWmaxobs`w'=r(max) // max obs used in the window width
drop errsq pred nobs // clearing for the next loop
}
scalar list // list the RMSE and min and max obs for each window width
*End of rolling window program



*The last one is the best one, very slighty. Really not much difference
*At a window of about 12 years (48 quarters)
*RMSERW about 0.036

