* Time Series Modeling and Forecasting
* Spring 2020

clear
set more off

*set the working directory to wherever you have the data"
cd "C:\Users\jdewey\Documents\A S20 Time Series\data and do files"

*import the data
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
gen dated=date(datestring,"YMD")
gen date=qofd(dated)
format date %tq
tsset date

**New and Important!!!!
*Add the date we want to forecast
tsappend, add(1)


*generate variable
generate rgdppc=gdp/(pop*gdpdef/100)
gen reratio=fedrcpt/fedexp
gen lnreratio=ln(reratio)
gen lnrgdppc=ln(rgdppc)

*generate quarterly indicators
replace dated=dofq(date)
generate quarter=quarter(dated)
gen q1=0
replace q1=1 if quarter==1
gen q2=0
replace q2=1 if quarter==2
gen q3=0
replace q3=1 if quarter==3
gen q4=0
replace q4=1 if quarter==4

  
/* After searching through thousands of permutations with gsreg
evaluating on out of sample fit and information criteria
NOT in sample fit
we decided to look further at these more rigorously:
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 , the one from before
reg d.lnreratio l(4,6,8)d.lnreratio l(3)d.lnrgdp q2 q4 , gsreg #1
reg d.lnreratio l(1,4,6,8)d.lnreratio l(3)d.lnrgdp q2 q4, gsreg #2
reg d.lnreratio l(4,6,8)d.lnreratio q2 q4, gsreg #15
reg d.lnreratio l(4,6)d.lnreratio l(3)d.lnrgdp q2 q4 , gsreg #26

Using Rolling Window estimation, we found the last with a window
of 11 years to be the "best".

Now, we will use it to build both normal and empirical point
and interval forecasts for 2019q4. */


/* We are going to run just the inner loop for w=44 to get the 
empirical information needed for the empirical forecast method. */

*Rolling window program - just for w=44
scalar drop _all
quietly forval w=44(4)44 { 
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
}
*End of rolling window program

summ nobs // checking all had a full window
*get error info for normal interval
summ errsq
scalar rwrmse=r(mean)^0.5
scalar list rwrmse


*Construct normal interval
reg d.lnreratio l(4,6)d.lnreratio l(3)d.lnrgdp q2 q4 if tin(2008q4,2019q3)
predict temp if tin(2019q4,2019q4)
replace pred=temp if tin(2019q4,2019q4)
drop temp
gen preration=exp(l.lnreratio+pred+(rwrmse^2)/2)
gen ubn=exp(l.lnreratio+pred+1.96*rwrmse+(rwrmse^2)/2)
gen lbn=exp(l.lnreratio+pred-1.96*rwrmse+(rwrmse^2)/2)
list date preration lbn ubn if tin(2019q4,2019q4)
tsline preratio lbn ubn reratio if tin(2018q1,2019q4)

*Construct empirical interval
gen res=(d.lnreratio-pred)
gen expres=exp(res)
summ expres
scalar meanexpres=r(mean)
gen preratioe=exp(l.lnreratio+pred)*meanexpres
_pctile res, percentile(2.5,97.5)
return list
gen lbe=exp(l.lnreratio+pred+r(r1))*meanexpres
gen ube=exp(l.lnreratio+pred+r(r2))*meanexpres
list date preratioe lbe ube if tin(2019q4,2019q4)
tsline preratioe lbe ube reratio if tin(2018q1,2019q4)

list preration preratioe lbn lbe ubn ube if tin(2019q4,2019q4)

