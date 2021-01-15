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


*recall this picture (trend lines added)
twoway (tsline reratio) (lfit reratio date) ///
 (tsline rgdppc, yaxis(2)) (lfit rgdppc date, yaxis(2)) if tin(1980q1,2019q3)

*Need to difference?
**Examine the AC and PAC
pac lnreratio if tin(1980q1,2019q3)
pac lnreratio if tin(1980q1,2019q3)
**Looks like 1? VERY strong AR(1).
**I(1)
**So, need to difference
ac d.lnreratio if tin(1980q1,2019q3)
pac d.lnreratio if tin(1980q1,2019q3)

*How to test formally if I(1)?
*Dickey Fuller Test
dfuller lnreratio if tin(1980q1,2019q3), trend regress
dfuller lnreratio if tin(1980q1,2019q3), trend lags(4) regress
*Rejection of Ho I(1) is borderline... BUT...
*Even if not I(1), STILL rho is 0.91, pretty long lasting impacts
**Good idea to work with first differenced data



*Let us consider an ARDL Model:
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.quarter if tin(1980q1,2019q3)
*Do we still have serial correlation in the residuals?

**Breusch–Godfrey test
***Alternative using an LM test, don't need extra steps
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.q if tin(1980q1,2019q3)
bgodfrey, lag(1/12)
*Tests cumulative through lags
*Does appear to have remaining serial correlation

reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp i.quarter if tin(1980q1,2019q3)
bgodfrey, lag(1/12)
*Now appears dynamically complete. But, not parsimonious...

gen q1=0
replace q1=1 if quarter==1
gen q2=0
replace q2=1 if quarter==2
gen q3=0
replace q3=1 if quarter==3
gen q4=0
replace q4=1 if quarter==4

*A more parsimonious one
reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)
bgodfrey, lag(1/12)

*With Newey-West Standard Errors
newey d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3), lag(4)
newey d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3), lag(8)

*Here as of 2-5-2020

*STOP

*How to decide which among candidate models is best?
*We will revisit this again and again.


*First, consider role of domain knowledge and joing hypothesis tests
reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 date if tin(1980q1,2019q3)

*suppose there is reason to think many of these lags should not matter

testparm l(2,3,5,7)d.lnreratio l(5/8)d.lnrgdppc date q3
*drop these
reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)

*Is it free of serial correlation?
reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)
estat bgodfrey , lag(1/12)
predict res, residual
pac res
*bgpodrey fine, but residual pac ???
drop res

*How does it compare to the parsimonious version from earlier?
reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)
bgodfrey, lag(1/12)
predict res, residual 
pac res
*????
drop res


/*
If you do this other than very sparingly, it will lead to overfitting
But, should not ignore subject matter knowledge, either
Want a fit measure that guards well against overfitting
*/

**We need an empirical way to choose the best Model.
*Compare AIC, BIC, LOOCV, and K-Fold Cross validation (say 10-fold)
*Install crossfold

*ssc install crossfold

*Most complex
crossfold reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3), k(10)
*For now, average the 10 in some way is probably easiest to do
*To average, first square each, then average, then take the square root. Why??

loocv reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3)

reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3)	
estat ic

*Shortened
crossfold reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2019q3), k(10)
loocv reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2019q3)
reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)
estat ic


*Most parsimonious
crossfold reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 ///
	if tin(1980q1,2019q3) , k(10)
loocv reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)
reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)
estat ic


*By these empirical measures, designed to guard against overfitting
**the intermediate model appears better

*Midterm through here
*Updated to here as of 2-10-2020












**But, is this model suitable for a forecast????
***Can't use the contemporaneous value of lnrgdppc!
**So, have to estimate a new model to fit time t based only on what
***was known at t-1

reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)

*How do we know, having dropped the contemporaneous X, more lags would not matter?
*Or other quarter effects?

*Need to try many models and choose the one that fits best,
* guarding against over-fitting
****REMEMBER: You must ensure the models are all fit on the same
****number of observations for the comparisons to be valid!
****Since both variables extened well before 1980, we are OK.
****In other cases, you will have to limit the first year accordingly.

crossfold reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2017q4), k(10)

loocv reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2017q4)
	
reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2017q4)	
estat ic


crossfold reg d.lnreratio l(1/4)d.lnreratio l(1/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2017q4), k(10)

loocv reg d.lnreratio l(1/4)d.lnreratio l(1/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2017q4)
	
reg d.lnreratio l(1/4)d.lnreratio l(1/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2017q4)	
estat ic


crossfold reg d.lnreratio l(1,4,6,8)d.lnreratio l(1)d.lnrgdp q2 q4 ///
	if tin(1980q1,2017q4), k(10)

loocv reg d.lnreratio l(1,4,6,8)d.lnreratio l(1)d.lnrgdp q2 q4 ///
	if tin(1980q1,2017q4)
	
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1)d.lnrgdp q2 q4 ///
	if tin(1980q1,2017q4)	
estat ic




*The more parsimonious still model seems better, at least slightly
*Let's prepare a visual of how it fits

reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 if tin(1980q1,2017q4)
predict pdlnreratio
tsline pdlnreratio d.lnreratio if tin(1980q1,2017q4)
*A closer look at the later years
tsline pdlnreratio d.lnreratio if tin(2000q1,2017q4)

*How does it do when forecasting truly out of sample?
*That is, when we update the predictor variables
*but the model coefficients estiamtes are not updated?
*End fit data at 2015 q4, 2016 q1 - 2017 q3 are out of sample

drop pdlnreratio
reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 if tin(1980q1,2015q4)
predict pdlnreratio
tsline pdlnreratio d.lnreratio if tin(2000q1,2017q4)

*What about the underlying log revenue to expenditure ratio?
gen plnreratio=pdlnreratio+l.lnreratio
tsline plnreratio lnreratio if tin(2000q1,2017q4)
tsline plnreratio lnreratio if tin(2014q1,2017q4)

*What about the untransformed revenue to expenditure ratio?
gen preratio=exp(plnreratio)
tsline preratio reratio if tin(2000q1,2017q4)
tsline preratio reratio if tin(2014q1,2017q4)

*Note: there is something off with out transformation
*The log-nomral distribution is not symmetric
*The mean and median are not the same

*Two ways to fix
reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 if tin(1980q1,2015q4)
gen preratio2=exp((e(rmse)^2)/2)*preratio if tin(1980q1,2015q4)
*That one depends on normality

predict pres if tin(1980q1,2015q4), residual
gen exppres=exp(pres) if tin(1980q1,2015q4)
summ exppres
gen preratio3=r(mean)*preratio
*This one does not depend on normality

gen a=preratio2-preratio if tin(1980q1,2015q4)
gen b=preratio3-preratio if tin(1980q1,2015q4)
gen c=preratio3-preratio2 if tin(1980q1,2015q4)
summ a b c if tin(1980q1,2015q4)

tsline preratio* if tin(1980q1,2015q4)

tsline preratio preratio3 if tin(2016q1,2017q4)

drop preratio preratio2

rename preratio3 preratio_1



*What about Kahlil's question:
*Did all the log transforms buy us anything in this case?

reg d.reratio l(1/4)d.reratio l(1)d.r_gdp_pc q3 if tin(1980q1,2015q4)
predict pdreratio
gen preratio_2=pdreratio+l.reratio

gen diff_sq_1=(preratio_1-reratio)^2 if tin(1980q1,2017q4)
gen diff_sq_2=(preratio_2-reratio)^2 if tin(1980q1,2017q4)
summ diff_sq_1 diff_sq_2 if tin(1980q1,2015q4)
summ diff_sq_1 diff_sq_2 if tin(2016q1,2017q3)

*Here, the two are near identical
*The untransformed model may even be "better"
*Why does it make so little difference here?



*What about confidence intervals?
**For forecast, called forecast interval.

*Assuming normality
reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 if tin(1980q1,2015q4)
gen ubpdlnreratio=pdlnreratio+1.96*e(rmse)
gen lbpdlnreratio=pdlnreratio-1.96*e(rmse)
tsline ubpdlnreratio lbpdlnreratio d.lnreratio if tin(1980q1,2017q4)
tsline ubpdlnreratio lbpdlnreratio d.lnreratio if tin(2010q1,2017q4) 
tsline ubpdlnreratio lbpdlnreratio pdlnreratio d.lnreratio if tin(2016q1,2017q4) 

*this is not quite right, leaves out one source of uncertainty
**uncertainty about the forecast value itself

reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 if tin(1980q1,2015q4)
predict stderrpdlnreratio, stdp
gen varfcst=e(rmse)^2+stderrpdlnreratio^2
gen stderrfcst=varfcst^.5

*to go directly to this
predict stderrfcst2, stdf
*but, you need to understand what it is!

gen difference=stderrfcst-stderrfcst2
summ difference

drop difference stderrfcst2 ubpdlnreratio lbpdlnreratio
gen ubpdlnreratio=pdlnreratio+1.96*stderrfcst
gen lbpdlnreratio=pdlnreratio-1.96*stderrfcst
tsline ubpdlnreratio lbpdlnreratio d.lnreratio if tin(1980q1,2017q4)
tsline ubpdlnreratio lbpdlnreratio d.lnreratio if tin(2010q1,2017q4)

*What if we don't want to make assume normality?
*Empirical forecast interval
drop ubpdlnreratio lbpdlnreratio
_pctile pres, percentile(2.5,97.5)
gen lbpdlnreratio=pdlnreratio+r(r1)
gen ubpdlnreratio=pdlnreratio+r(r2)
tsline ubpdlnreratio lbpdlnreratio d.lnreratio if tin(1980q1,2017q4)
tsline ubpdlnreratio lbpdlnreratio d.lnreratio if tin(2010q1,2017q4)

