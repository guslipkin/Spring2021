* Time Series Modeling and Forecasting


*Do file on ARIMA and Dynamic Forecasting

clear
set more off

*set the working directory to wherever you have the data"
cd "C:\Users\jdewey\Documents\A S21 Time Series\data and do files"

*import the data
import delimited "Federal_Government_Budget_Quarterly.txt"

rename observation_date datestring
gen dated=date(datestring,"YMD") // generating daily date
gen date=qofd(dated) // generating monthly date
format date %tq // formatting date to display as 1980q1 for quarter 1 1980, etc
tsset date // telling stata date is the time index
tsappend, add(16) // adding four years to forecast
generate quarter=quarter(dofq(date)) // generating numeric quarter, 1-4
tab quarter, generate(q) // convenient way to make quarter dummies, q

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

*generate variables
generate rgdppc=gdp/(pop*gdpdef/100)
gen reratio=fedrcpt/fedexp
gen lnreratio=ln(reratio)
gen lnrgdppc=ln(rgdppc)



* -  AR models and the arima command

*Estimating AR models using arima
*arima d.lnreratio l(1/8)d.lnreratio i.quarter if tin(1970q1,2019q3)
*ARIMA does not like factor variable notation
arima d.lnreratio l(1/8)d.lnreratio q2 q3 q4  if tin(1970q1,2019q3)
*But for standard errors, that is the same as:
regress d.lnreratio l(1/8)d.lnreratio q2 q3 q4  if tin(1970q1,2019q3)
*This gives almost the same thing:
arima d.lnreratio q2 q3 q4 if tin(1970q1,2019q3), ar(1/8)
*Why the difference?

*Another way to get the last result:
arima lnreratio q2 q3 q4 if tin(1970q1,2019q3), arima(8,1,0)

*Note you can do this:
arima d.lnreratio l(1,2,4,6,8)d.lnreratio q2 q3 q4 if tin(1970q1,2019q3)
*or this
arima d.lnreratio q2 q3 q4 if tin(1970q1,2019q3), ar(1,2,4,6,8)
*which are basically like this:
regress d.lnreratio l(1,4,6,8)d.lnreratio q2 q3 q4 if tin(1970q1,2019q3)
*But  " ,arima(p,d,q))  does not give the same flexibility


*What about using the MA part?
arima d.lnreratio q2 q3 q4 if tin(1970q1,2019q3), ar(1/8) ma(1/8)
*What to make of this? be very parsimonious with such models
arima d.lnreratio q2 q3 q4 if tin(1970q1,2019q3), ar(1,2,4,6,8) ma(1/2)
*Look at the standard errors for the MA part -- be careful!




*Using ARIMA for dynamic forecasting - Model Comparison

*Suppose we want to forecast 4 years ahead, 16 quarters
**It is a bad idea to do it this way, but, lets do it anyway

***Let us compare two models

arima d.lnreratio l(1/8)d.lnreratio q2 q3 q4 if tin(1970q1,2015q3)
predict pdlny1 , dynamic(qofd(tq(2015q4)))  // starts dynamics 2015q4
gen plny1=lnreratio if date<tq(2015q4)
replace plny1=l.plny1+pdlny1 if date>tq(2015q3)
replace plny1=. if date<tq(2015q4)
gen abserr1=abs(lnreratio-plny1) if date>tq(2015q3)

arima d.lnreratio l(1,2,4,6,8)d.lnreratio q2 q4 if tin(1970q1,2015q3)
predict pdlny2 , dynamic(qofd(tq(2015q4)))  // starts dynamics 2015q4
gen plny2=lnreratio if date<tq(2015q4)
replace plny2=l.plny2+pdlny2 if date>tq(2015q3)
replace plny2=. if date<tq(2015q4)
gen abserr2=abs(lnreratio-plny2) if date>tq(2015q3)

summarize abserr1 abserr2

*2 looks better, slightly, but this is not rolling window!



*Mini Lecture 3 - Making a fan chart to evaluate fit

*Making a visual to show the model's accuracy

arima d.lnreratio l(1,2,4,6,8)d.lnreratio q2 q4 if tin(1970q1,2015q3)
predict pdlny , dynamic(qofd(tq(2015q4)))  // starts dynamics 2015q4
predict mse, mse

gen py=reratio if date<tq(2015q4)
replace py=l.py*exp(pdlny+mse/2) if date>tq(2015q3)
replace py=. if date<tq(2015q3)

gen totmse=mse if date==tq(2015q4)
replace totmse=l.totmse+mse if date>tq(2015q4)

gen ub2=py*exp(2*totmse^.5) if date>tq(2015q3)
gen lb2=py/exp(2*totmse^.5) if date>tq(2015q4)
replace ub2=reratio if date==tq(2015q3)
replace lb2=reratio if date==tq(2015q3)


twoway (tsrline ub2 lb2 if tin(2015q3,2019q3), ///
			recast(rarea) fcolor(gs6) fintensity(10) lwidth(none) ) ///
	(tsline reratio if tin(2004q1,2015q3), lcolor(gs6) lwidth(thick) ) ///
	(tsline py if tin(2015q3,2019q3), lcolor(gs6) lwidth(thick) ) ///
	(scatter reratio date if tin(2015q4,2019q3) ,  ms(o) ) , ///
	scheme(s1mono) legend(off) tline(2015q3) ///
	title("Federal Revenue to Expenditure Ratio"  ///
	"Four Year Quarterly Forecast Accuracy") legend(off) ///
	xtitle("") ylabel(,grid) ///
	note("Launch date is 2015q3, interval is 2 sigma") ///
	saving("Evaluation Chart", replace)


*Dynamic Arima Forecast Fan Chart

drop pdlny mse py totmse ub2 lb2

arima d.lnreratio l(1,2,4,6,8)d.lnreratio q2 q4 if tin(1970q1,2019q3)
predict pdlny , dynamic(qofd(tq(2019q4)))  // starts dynamics 2019q4
predict mse, mse dynamic(qofd(tq(2019q4))) // variance of forecast each period

gen py=reratio if date==tq(2019q3) // last known point to start fan chart
replace py=l.py*exp(pdlny+mse/2) if date>tq(2019q3) // moves ahead recursively

/*treating errors as realizations of independent shocks,
the varianve of a forecast at h is the sum of the variaces of all the prior
forecasts of d.lny (since we keep adding up) and the current one. So: */
gen totmse=mse if date==tq(2019q4)
replace totmse=l.totmse+mse if date>tq(2019q4)

*Use this for the fan chart bounds:
gen ub1=py*exp(totmse^.5)
gen ub2=py*exp(2*totmse^.5)
gen ub3=py*exp(3*totmse^.5)
gen lb1=py/exp(totmse^.5)
gen lb2=py/exp(2*totmse^.5)
gen lb3=py/exp(3*totmse^.5)

replace ub1=reratio if date==tq(2019q3)
replace ub2=reratio if date==tq(2019q3)
replace ub3=reratio if date==tq(2019q3)
replace lb1=reratio if date==tq(2019q3)
replace lb2=reratio if date==tq(2019q3)
replace lb3=reratio if date==tq(2019q3)


twoway (tsrline ub3 ub2 if tin(2019q3,), ///
	recast(rarea) fcolor(blue) fintensity(5) lwidth(none) ) ///
	(tsrline ub2 ub1 if tin(2019q3,), ///
	recast(rarea) fcolor(blue) fintensity(15) lwidth(none) ) ///
	(tsrline ub1 py if tin(2019q3,), ///
	recast(rarea) fcolor(blue) fintensity(35) lwidth(none) ) ///
	(tsrline py lb1 if tin(2019q3,), ///
	recast(rarea) fcolor(blue) fintensity(35) lwidth(none) ) ///
	(tsrline lb1 lb2 if tin(2019q3,), ///
	recast(rarea) fcolor(blue) fintensity(15) lwidth(none) ) ///
	(tsrline lb2 lb3 if tin(2019q3,), ///
	recast(rarea) fcolor(blue) fintensity(5) lwidth(none) ) ///
	(tsline reratio py if tin(2005q1,) , ///
	lcolor(gs6 gs12) lwidth(thick thick) ), scheme(s1mono) legend(off) ///
	title("Federal Revenue to Expenditure Ratio"  ///
	"Four Year Quarterly Forecast Fan Chart") legend(off) ///
	xtitle("") ylabel(,grid) ///
	note("Launch date is 2019q3" "Bands at 1, 2, and 3 sigma") ///
	saving("Fan Chart", replace)

STOP	
	
* Seasonal Differencing and AR - the Math

	
	
* Seasonal Differencing and AR models in Stata


/*Another way of making multiplicative seasonal adjustments:
Seasonal differencing of log variables*/

*Work through the math first

reg s4d.lnreratio l(1,2,4,6,8)s4d.lnreratio if tin(1970q1,2019q3)
reg s4d.lnreratio l(1,2,4,6,8)s4d.lnreratio q2 q4 if tin(1970q1,2019q3)
*quarter dummies don't add much
*would not expect them to

/*"Compare" AR and SAR models
Note: The DV is different.
Can't compare AIC/BIC, etc... until appropriately transformed */

drop pdlny1 pdlny2 plny1 plny2 abserr1 abserr2

arima d.lnreratio l(1,2,4,6,8)d.lnreratio q2 q4 if tin(1970q1,2015q3)
predict pdlny1 , dynamic(qofd(tq(2015q4)))  // starts dynamics 2015q4
gen plny1=lnreratio if date<tq(2015q4)
replace plny1=l.plny1+pdlny1 if date>tq(2015q3)
gen abserr1=abs(lnreratio-plny1) if date>tq(2015q3)
replace plny1=. if date<tq(2015q4)

arima s4d.lnreratio l(1,2,4,6,8)s4d.lnreratio if tin(1970q1,2015q3)
predict ps4dlny2 , dynamic(qofd(tq(2015q4)))  // starts dynamics 2019q4
gen plny2=lnreratio if date<tq(2015q4)
replace plny2=l.plny2+ps4dlny2+l4d.plny2 if date>tq(2015q3)
gen abserr2=abs(lnreratio-plny2) if date>tq(2015q3)
replace plny2=. if date<tq(2015q4)

summ abserr1 abserr2
	
*First looks better
**Log y with seasonal dummies is simple and typically as good or better
***mention sarima option


	
