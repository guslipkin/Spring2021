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


*Start here 3-10-2020

*recall this picture (trend lines added)
twoway (tsline reratio) (lfit reratio date) ///
 (tsline rgdppc, yaxis(2)) (lfit rgdppc date, yaxis(2)) if tin(1980q1,2019q3)

*Some review 
*Last time, based on Cross Validation and IC
*we arrived at this model for a point forecast:
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)

*How did we get an interval forecast?
predict pdlnreratio
gen ubpdlnreratio=pdlnreratio+1.96*e(rmse)
gen lbpdlnreratio=pdlnreratio-1.96*e(rmse)
tsline pdlnreratio lbpd ubpd d.lnreratio if tin(2016q1,2019q3)

*This is what we introduced  before break
*But... it leaves out uncertainty about the forecast value itself

reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2017q4)
predict stderrpdlnreratio, stdp
gen varfcst=e(rmse)^2+stderrpdlnreratio^2
gen stderrfcst=varfcst^.5

*to go directly to this
predict stderrfcst2, stdf
*but, you need to understand what it is!

gen difference=stderrfcst-stderrfcst2
summ difference

drop difference stderrfcst varfcst stderrpdlnreratio ///
       pdlnreratio ubpdlnreratio ubpdlnreratio


*Look at out of sample prediction interval, with right std error
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2017q4)
predict pdlnreratioout
predict stdfpdlnout, stdf
gen ubpdlnout=pdlnreratioout+1.96*stdfpdlnout
gen lbpdlnout=pdlnreratioout-1.96*stdfpdlnout
tsline pdlnreratioout lbpdlnout ubpdlnout d.lnreratio if tin(2016q1,2019q3)

*Now, how to transform this back to reratio?
gen preratioout=exp(l.lnreratio+pdlnreratioout)*exp((e(rmse)^2)/2)
gen ubpout=exp(l.lnreratio+pdlnreratioout+1.96*stdfpdlnout)*exp((e(rmse)^2)/2)
gen lbpout=exp(l.lnreratio+pdlnreratioout-1.96*stdfpdlnout)*exp((e(rmse)^2)/2)
/*remember, there was another way to do this that did not
assume normality. Review it in the book and last do file. */

tsline preratioout lbpout ubpout reratio if tin(2016q1,2019q3)



*What did we gain from using the natural log?
*Really, need a new model search, but for this purpose,
*we will just use the same lag structure
reg d.reratio l(1,4,6,8)d.reratio l(1/4)d.rgdppc q2 q4 if tin(1980q1,2017q4)
predict pdreratioout2
predict stdfreout, stdf
 
*Now, how to transform this back to reratio?
gen preratioout2=l.reratio+pdreratioout2
gen ubpout2=preratioout2+1.96*stdfreout
gen lbpout2=preratioout2-1.96*stdfreout
tsline preratioout2 lbpout2 ubpout2 reratio if tin(2016q1,2019q3)
*This is surely simpler. How does it compare?

tsline preratioout2 preratioout reratio if tin(2016q1,2019q3)
*Not much difference here

gen mseout1=(preratioout-reratio)^2 if tin(2018q1,2019q3)
gen mseout2=(preratioout2-reratio)^2 if tin(2018q1,2019q3)
summ mseout1 mseout2
*The second is slightly more accurate out of sample
*Two questions:
*	1) Why bother with the log transform in general?
*	2) Why would we EXPECT the two to be very close in this particular case??


STOP

*Start here 3-12-2020

*What if we don't want to make assume normality?
***Empirical forecast interval

reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2017q4)
*already have predicted value from above
*predict pdlnreratioout
predict pres if tin(1980q1,2017q4), residual
_pctile pres, percentile(2.5,97.5)
return list
gen lbpdlnoute=pdlnreratioout+r(r1)
gen ubpdlnoute=pdlnreratioout+r(r2)

*Now, how to transform this back to reratio?
gen exppres=exp(pres) if tin(1980q1,2017q4)
summ exppres
gen preratiooute=exp(l.lnreratio+pdlnreratioout)*r(mean)
gen ubpoute=exp(l.lnreratio+pdlnreratioout+ubpdlnoute)*r(mean)
gen lbpoute=exp(l.lnreratio+pdlnreratioout+lbpdlnoute)*r(mean)
tsline preratiooute lbpoute ubpoute reratio if tin(2016q1,2019q3)


*None of the comparisons above are completely "fair"
*we did not update the model each time with the most current information set
*AND the standard errors are not estimated out of sample!


****************************************************

*Before, we arrived at this model for a point forecast:
*reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)

/* Up to now, we have looked over a small set of models
Let us consider automating the search over many models
GSREG will search over many lags of independent and dependent variables
Need to give it some crieteria to rank models
We will use a weighted average of AIC, BIC, and out of sample RMSE
Also, GSREG does not get factor notation or time series operators
*/

******run ssc install gsreg *****

gen dlnreratio=d.lnreratio // gsreg does not like time series operators

gen l1dlnreratio=l1d.lnreratio // could use its dlag command for these
gen l2dlnreratio=l2d.lnreratio
gen l3dlnreratio=l3d.lnreratio
gen l4dlnreratio=l4d.lnreratio
gen l5dlnreratio=l5d.lnreratio
gen l6dlnreratio=l6d.lnreratio
gen l7dlnreratio=l7d.lnreratio
gen l8dlnreratio=l8d.lnreratio

gen l1dlnrgdppc=l1d.lnrgdppc // could use ilag option for these, but... 
gen l2dlnrgdppc=l2d.lnrgdppc
gen l3dlnrgdppc=l3d.lnrgdppc
gen l4dlnrgdppc=l4d.lnrgdppc


/*Here is the command we will run:
gsreg dlnreratio l1dlnreratio l2dlnreratio l3dlnreratio l4dlnreratio ///
	l5dlnreratio l6dlnreratio l7dlnreratio l8dlnreratio /// 
	l1dlnrgdppc l2dlnrgdppc l3dlnrgdppc l4dlnrgdppc if tin(1980q1, 2019q3), ///
	replace ncomb(1,8) aic outsample(10) fix(q2 q4) ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) samesample results(gsreg_dlnrer)

	What are these things?
	fix?  ***** why did I fix q2 and a4? *********
	ncomb?
	dlags?
	ilags?
	aic?
	outsample?
	nindex?
	samesample?
	results?
	-0.3, -0.3 -0.4?

GSREG vs Stepwise?
1) Out of sample or IC selection (canned stepwise routine does not have it)
2) Checks all subsets (time and compute intensive) 
*/
  
  
gsreg dlnreratio l1dlnreratio l2dlnreratio l3dlnreratio l4dlnreratio ///
	l5dlnreratio l6dlnreratio l7dlnreratio l8dlnreratio /// 
	l1dlnrgdppc l2dlnrgdppc l3dlnrgdppc l4dlnrgdppc if tin(1980q1, 2019q3), ///
	replace ncomb(1,8) aic outsample(10) fix(q2 q4) ///
	nindex( -0.3 aic -0.3 bic -0.4 rmse_out) samesample results(gsreg_dlnrer)
	
  
/*Look at results file for models worth comparing further
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

run ssc install asreg

*/

asreg dlnreratio l1dlnreratio l4dlnreratio l6dlnreratio l8dlnreratio  ///
	l1dlnrgdp l2dlnrgdp l3dlnrgdppc l4dlnrgdppc  q2 q4 , ///
	window(date 40) min(40) fit
*Browse here
gen ressq1=_res^2
drop _*

asreg dlnreratio l4dlnreratio l6dlnreratio l8dlnreratio ///
	l3dlnrgdp  q2 q4 , ///
	window(date 40) min(40) fit
gen ressq2=_res^2
drop _*

asreg dlnreratio l1dlnreratio l4dlnreratio l6dlnreratio l8dlnreratio ///
	l3dlnrgdp  q2 q4 , ///
	window(date 40) min(40) fit
gen ressq3=_res^2
drop _*

asreg dlnreratio l4dlnreratio l6dlnreratio l8dlnreratio ///
	q2 q4 , ///
	window(date 40) min(40) fit
gen ressq4=_res^2
drop _*

asreg dlnreratio l4dlnreratio l6dlnreratio ///
	l3dlnrgdp  q2 q4 , ///
	window(date 40) min(40) fit
gen ressq5=_res^2
drop _*

summ ressq* 

















Other procedures?












*TOPICS THAT REMAIN:
*How to search a large number of models?
*How do we choose the right window?
*What if we need to forecast more than one period ahead?
*Fan charts
*What if we want to forecast more than one variable?


