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

STOP

/*Start Here 2-27-2020
We had consiered 3 models:
*Most Complex
1) reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3)	
*Intermediate
2) reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2019q3)
*Most parsimonious
3) reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)

and concluded the intermediate one was best by AIC, BIC, N-Fold CV, 10-Fold CV
But, is this model suitable for a forecast????
Can't use the contemporaneous value of lnrgdppc!
Have to estimate a new model to fit time t based only on what was known at t-1

We should really go back to the drawing board,
but we will start by adapting the previous 3*/



*Most complex
set seed 12951
crossfold reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3), k(10)

	*code to average the results from each of the 10 folds
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse=(el(kMSE,1,1)/k)^.5
scalar list krmse
matrix drop kMSE
scalar drop krmse k

loocv reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3)
reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2019q3)	
estat ic

*Shortened
set seed 12951
crossfold reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2019q3), k(10)
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse=(el(kMSE,1,1)/k)^.5
scalar list krmse
matrix drop kMSE
scalar drop krmse k

loocv reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 ///
	if tin(1980q1,2019q3)
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)
estat ic

*Most parsimonious
set seed 12951
crossfold reg d.lnreratio l(4,8)d.lnreratio l(1,4)d.lnrgdp q3 ///
	if tin(1980q1,2019q3) , k(10)
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse=(el(kMSE,1,1)/k)^.5
scalar list krmse
matrix drop kMSE
scalar drop krmse k

loocv reg d.lnreratio l(4,8)d.lnreratio l(1,4)d.lnrgdp q3 if tin(1980q1,2019q3)
reg d.lnreratio l(4,8)d.lnreratio l(1,4)d.lnrgdp q3 if tin(1980q1,2019q3)
estat ic


*Intermediate still best

*We need a more thorough way to search throug possibilities
*We will return to that later.
*For now, let us look at the out of sample performance of the "best" model

reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)
predict pdlnreratio

tsline pdlnreratio d.lnreratio if tin(1980q1,2019q3)
tsline pdlnreratio d.lnreratio if tin(2015q1,2019q3)

**this is not really a fair comparison. Why? 
**Come back to that later, for now...

*What about predicting the reratio itself?
gen preratio=exp(l.lnreratio+pdlnreratio)
tsline preratio reratio if tin(2015q1,2019q3)

*There is a technical probem here regarding log-normal vs normal distributions
*Note: there is something off with our transformation
*The log-nomral distribution is not symmetric
*The mean and median are not the same

*Two ways to fix
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)
gen preratio2=exp((e(rmse)^2)/2)*preratio if tin(1980q1,2019q4)
*That one depends on normality

predict pres if tin(1980q1,2019q4), residual
gen exppres=exp(pres) if tin(1980q1,2019q4)
summ exppres
gen preratio3=r(mean)*preratio
*This one does not depend on normality

tsline preratio preratio2 preratio3 reratio if tin(2015q1,2019q3)

*Can't see much difference

gen a=preratio2-preratio if tin(1980q1,2019q4)
gen b=preratio3-preratio if tin(1980q1,2019q4)
gen c=preratio3-preratio2 if tin(1980q1,2019q4)
summ a b c if tin(1980q1,2019q4)

*there is not much difference to see
*usually, they are close, but can be more different than this


*These are point forecasts. How to get an interval forecast?
*How do we only look at out of sample prediction?
*How do we choose the right window?
*What if we need to forecast more than one period ahead?
*What if we want to forecast more than one variable?
*Take these up after Spring Break

*Stop here for 2-27-2020



















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

