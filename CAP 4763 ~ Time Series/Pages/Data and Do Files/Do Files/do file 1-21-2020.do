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

*generate real gdp per capita
generate rgdppc=gdp/(pop*gdpdef/100)

*generate a variable equal to the ratio of federal recepits to expenditures
gen reratio=fedrcpt/fedexp

*Let us start by looking at the data
twoway (tsline reratio) (tsline rgdppc)
*this timeseries figure is not very useful

*this one is better
twoway (tsline reratio) (tsline rgdppc, yaxis(2))

*look at a smaller window
twoway (tsline reratio) (tsline rgdppc, yaxis(2)) if tin(2005q1,2019q3)

*regression of the reratio on real gdp per capita
reg reratio rgdppc
*This is a static regression model.
*Though maybe not one that makes much sense.

*Since both are striclty positive, use logs?
*generate the natural logs of the receipt to expenditure ratio
**and real gdp per capita
gen lnreratio=ln(reratio)
gen lnrgdppc=ln(rgdppc)

twoway (tsline lnreratio) (tsline lnrgdppc, yaxis(2))

*regression of the reratio on real gdp per capita, in logs
reg lnreratio lnrgdppc


*Interpretation? 
*BUT, are they correlated just because both are trending?
**Could be a purely spurious correlation
***Detrend them both an see how the detrended versions correlate


reg lnreratio date
predict reslnreratio, resid
*reslnreratio is the part of lnreratio independent of the time trend 

reg lnrgdppc date
predict reslnrgdppc, resid
*reslnrgdppc is the part of lnrgdppc independent of the time trend

reg reslnreratio reslnrgdppc

*We could have detrended just by adding a time trend to the regression
reg lnreratio lnrgdppc date

*What to make of the differences in R-Squared?

*Could also detrend by differencing. Work through the math
reg d.lnreratio d.lnrgdppc

*Results differ. Why? Come back to this latter...

*Look at the detrended time series
scatter reslnreratio reslnrgdppc
twoway (tsline reslnreratio) (tsline reslnrgdppc, yaxis(2))
twoway (tsline reslnreratio) (tsline reslnrgdppc, yaxis(2)) if tin(2005q1,2019q3)


*Add quarterly indicators to deal with seasonality
generate quarter=quarter(datec)

reg lnreratio lnrgdppc i.quarter date

*Look at detrended data
reg lnreratio date i.quarter
predict reslnreratio2, resid
*reslnreratio2 is the part of lnreratio independent of time trend & quarter
reg lnrgdppc date i.quarter
predict reslnrgdppc2, resid
*reslnrgdppc2 is the part of lnrgdppc independent of time trend & quarter

scatter reslnreratio2 reslnrgdppc2
twoway (tsline reslnreratio2) (tsline reslnrgdppc2, yaxis(2))
twoway (tsline reslnreratio2) (tsline reslnrgdppc2, yaxis(2)) if tin(2005q1,2019q3)



*So far, we have only looked at static models.
*Might effects build, or at least change, over time?
*What about dynamic models?

reg lnreratio lnrgdppc l.lnrgdppc date i.quarter
*How many lags?

reg lnreratio lnrgdppc l.lnrgdppc l2.lnrgdppc l3.lnrgdppc l4.lnrgdppc date i.quarter
*Why at least 4 lags?

*Easier way to specify the lags
reg lnreratio l(0/4).lnrgdppc date i.quarter

*Short run and long run effects?

reg lnreratio l(0/4,8,12).lnrgdppc date i.quarter
*Huh?

*Make a neat table to compare models.
*Use this where applicable for homework.
*If you have not already done so, make sure you are online and
*enter this in the command line:
*ssc install estout

*Now, run each model you want to compare and store the results
reg lnreratio l(0).lnrgdppc date i.quarter
eststo lnreratio1
reg lnreratio l(0/4).lnrgdppc date i.quarter
eststo lnreratio2
reg lnreratio l(0/8).lnrgdppc date i.quarter
eststo lnreratio3
reg lnreratio l(0,1,4,8).lnrgdppc date i.quarter
eststo lnreratio4

*Now the table:
esttab lnreratio*

*Different date ranges? Generally, want to compare on the same data

estimates clear
reg lnreratio l(0/8).lnrgdppc date i.quarter if tin(1980q1,2019q3)
eststo lnreratio1
reg lnreratio l(0/4).lnrgdppc date i.quarter if tin(1980q1,2019q3)
eststo lnreratio2
reg lnreratio l(0,1,4,8).lnrgdppc date i.quarter if tin(1980q1,2019q3)
eststo lnreratio3
esttab lnreratio*

*How to get the table into a useful format?
esttab lnreratio* using "lnreratio models.rtf", replace
*Can enter options to change what is there or how it looks.

/*Do we have a reasonable theory or expectation about what the short 
and long run dynamics should look like?*/

**Would it be better still would be to use robust standard errors???
reg lnreratio l(0,1,4) lnrgdppc date i.quarter
reg lnreratio l(0,1,4) lnrgdppc date i.quarter, robust

/*Problem, we have not yet dealt with serial correlation!
Standard errors are wrong!
Lack of independence between residuals has to be dealt with*/

*Need to study strong versus weak dependence before moving on

****Run I(1) simulation at this point 

STOP

*Lets recall the problem with persistent time series
gen ry=rnormal()
gen rx=rnormal()
gen x=rx if [_n]==1
replace x=l.x+rx if [_n]>1
gen y=ry if [_n]==1
replace y=l.y+ry if [_n]>1
reg y x
tsline y x
drop rx ry x y



*recall this picture (trend lines added)
twoway (tsline reratio) (lfit reratio date) ///
 (tsline rgdppc, yaxis(2)) (lfit rgdppc date, yaxis(2)) if tin(1980q1,2019q3)

*Maybe today's budget position depends on where we were yesterday?
**That is, the budget position can be thought of as an autoregressive process

reg lnreratio l.lnreratio if tin(1980q1,2019q3)
*Above was AR(1). Next is AR(4)
reg lnreratio l(1/4).lnreratio if tin(1980q1,2019q3)
*Can keep going...
reg lnreratio l(1/8).lnreratio if tin(1980q1,2019q3)
reg lnreratio l(1/12).lnreratio if tin(1980q1,2019q3)


*So, how many lags?
*Need to difference?
**Examine the PAC
pac lnreratio if tin(1980q1,2019q3)
**Looks like 1? VERY strong AR(1).
**I(1)
**So, need to difference
pac d.lnreratio if tin(1980q1,2019q3)

*How to test formally if I(1)?
reg d.lnreratio l.lnreratio date if tin(1980q1,2019q3)
*Can't quite reject Ho I(1)
*But: t-dist not right is it is I(1), so...

*Dickey Fuller Test
dfuller lnreratio if tin(1980q1,2019q3), trend regress
dfuller lnreratio if tin(1980q1,2019q3), trend lags(4) regress
*Rejection of Ho I(1) is borderline... BUT...
*Even if not I(1), STILL rho is 0.91, pretty long lasting impacts
**Good idea to work with first differenced data



*Let us consider some ARDL Models:
estimates clear
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.q date if tin(1980q1,2019q3)
eststo model1
reg d.lnreratio l(1/4)d.lnreratio i.q date if tin(1980q1,2019q3)
eststo model2
reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp i.q date if tin(1980q1,2019q3)
eststo model3
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.quarter if tin(1980q1,2019q3)
eststo model4
esttab model* using models.rtf, se stat(r2 N) replace

*How to select the best model? Come back to that later.

*Do we still have serial correlation in the residuals?
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.quarter if tin(1980q1,2019q3)
predict res if e(sample)==1, residual
pac res
*Looks like we are OK here. How to check formally?
 
**In the spirit of:
reg res l(1/12).res l(1/4)d.lnreratio l(0/4)d.lnrgdp i.q if tin(1980q1,2019q3)
testparm l(1/12).res
*Is P(F) Small? If not, can we fail to reject null of no Serial Corr?


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

reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)
bgodfrey, lag(1/12)
*What about this one?

*Updated to here Spring 2020




*Last time, had arrived at a "dynamicaly complete" model
*No strong evidence remaining of serial correlation
*As a result std errors, etc... were probably OK
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.q date if tin(1980q1,2017q4)

*Here is another candidate:
tab quarter
gen q1=0
replace q1=1 if quarter==1
gen q2=0
replace q2=1 if quarter==2
gen q3=0
replace q3=1 if quarter==3
gen q4=0
replace q4=1 if quarter==4

reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp q3 if tin(1980q1,2017q4)
*How to decide which among candidate models is best?
*We will revisit this again and again.
*For now, consider role of domain knowledge and joing hypothesis tests
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 date if tin(1980q1,2017q4)
*suppose there is reason to think only one lag of gdp would matter (there is)
*and only Fall would differ from Winter
testparm l2d.lnrgdppc l3d.lnrgdppc l4d.lnrgdppc q2 q4 date
*No evidence any of these matter

*Is it free of serial correlation?
reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp q3 if tin(1980q1,2017q4)
estat bgodfrey , lag(1/12)
predict ressimple, residual
pac ressimple
*appears to be

*Note, if you do this other than very sparingly, it will lead to overfitting
*But, should not ignore subject matter knowledge, either
*Want a fit measure that guards well against overfitting
*Will get to that later

*What if we NEED a version that is not dynamically complete?
reg d.lnreratio l.d.lnrgdp q2 q3 q4 date  if tin(1980q1,2015q4)
*Does this suffer serial correlation?
estat bgodfrey, lag(1/12)
predict resstatic, residual
pac resstatic
*Looks like there is serial correlation!
*What to do if we really want this particular model?
*(Why  might we want this particular model?)


*use robust SE
newey d.lnreratio l.d.lnrgdp q2 q3 q4 date if tin(1980q1,2015q4), lag(4)
***What the heck is the Newey West Variace Estimator????
**How many lags for Newey? 0.75*151^(1/3)=3.99
**some arguments to err on the high side
newey d.lnreratio l.d.lnrgdp q2 q3 q4 date if tin(1980q1,2015q4), lag(8)

*Take away: Sometimes want models that still have serial correlation,
**must then allow for serial correlation, use Newey
***Estimates can be inefficient! Book talks about improving efficiency




*Previously, we got to this as possibly a reasonable model
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 date if tin(1980q1,2017q4)
*or this
reg d.lnreratio l(1/4)d.lnreratio l(0/1)d2.lnrgdp q3 if tin(1980q1,2017q4)

*The second is simpler, and testing showed the excluded variables did not
**yield statistically significant explanatory power.
**But, suppose you did not have prior reason to think it made sense to drop them?
**Then you need an empirical way to choose the best Model.
*Compare AIC, BIC, LOOCV, and K-Fold Cross validation (say 10-fold)

crossfold reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4), k(10)
*For now, average the 10 in some way is probably easiest to do
*To average, first square each, then average, then take the square root. Why??

loocv reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4)
	
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4)	
estat ic

crossfold reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp q3 ///
	if tin(1980q1,2017q4) , k(10)

loocv reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp q3 ///
	if tin(1980q1,2017q4)

reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp q3 ///
	if tin(1980q1,2017q4)
estat ic

*By these empirical measures, designed to guard against overfitting
**the simpler model appears better



**But, is this better model suitable for a forecast????
***Can't use the contemporaneous value of lnrgdppc!
**So, have to estimate a new model to fit time t based only on what
***was known at t-1

reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 ///
	if tin(1980q1,2017q4)

*How do we know, having dropped the contemporaneous X, more lags would not matter?
*Or other quarter effects?
*Need to try many models and choose the one that fits best,
* guarding against over-fitting
****REMEMBER: You must ensure the models are all fit on the same
****number of observations for the comparisons to be valid!
****Since both variables extened well before 1980, we are OK.
****In other cases, you will have to limit the first year accordingly.

crossfold reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4), k(10)

loocv reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4)
	
reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4)	
estat ic

crossfold reg d.lnreratio l(1/4)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4), k(10)

loocv reg d.lnreratio l(1/4)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4)
	
reg d.lnreratio l(1/4)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 date ///
	if tin(1980q1,2017q4)	
estat ic


crossfold reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 ///
	if tin(1980q1,2017q4) , k(10)

loocv reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 ///
	if tin(1980q1,2017q4)

reg d.lnreratio l(1/4)d.lnreratio l(1)d.lnrgdp q3 if tin(1980q1,2017q4)
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

