* Time Series Modeling and Forecasting
* Spring 2021

clear
set more off

*set the working directory to wherever you have the data"
cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Pages/Data and Do Files/Data"

*import the data
**we will be using data on the US Federal Budget
**Talk about FRED***

*I prefer csv. But FRED offers excel or tabl delimited, which is txt.
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
generate datec=date(datestring,"YMD")
gen date=qofd(datec)
format date %tq
tsset date

*generate real gdp per capita
generate rgdppc=gdp/(pop*gdpdef/100)

*generate a variable equal to the ratio of federal recepits to expenditures
gen reratio=fedrcpt/fedexp



/*The next stuff is not needed for the current lesson
So I have commented it out

*Let us start by looking at the data
twoway (tsline reratio) (tsline rgdppc)
*this timeseries figure is not very useful

*this one is better
twoway (tsline reratio) (tsline rgdppc, yaxis(2))

*look at a smaller window
twoway (tsline reratio) (tsline rgdppc, yaxis(2)) if tin(2005q1,)

**These are time series. Stop here and talk about time series, 10.1 and 10.2

*regression of the reratio on real gdp per capita
reg reratio rgdppc
*This is a static regression model.
*Though maybe not one that makes much sense.


We do need the log versions created below
*/ 

*Since both are striclty positive, use logs?
*generate the natural logs of the receipt to expenditure ratio
**and real gdp per capita
gen lnreratio=ln(reratio)
gen lnrgdppc=ln(rgdppc)

/*
As of here, variables are loaded and/or created.
So, I am commenting out what need not be repeated for the current lesson.


twoway (tsline lnreratio) (tsline lnrgdppc, yaxis(2))

*regression of the reratio on real gdp per capita, in logs
reg lnreratio lnrgdppc



*2-2-2021 Spurrious Correlation 1, Trends, Seasonal Effects

*recall this plot
twoway (tsline lnreratio) (tsline lnrgdppc, yaxis(2))

*recall this regression
reg lnreratio lnrgdppc

*Interpretation? 
*BUT, are they correlated just because both are trending?
**Could be a purely spurious correlation
*go to https://www.tylervigen.com/spurious-correlations


*Time Trends

***Detrend them both an see how the detrended versions correlate
reg lnreratio date
predict reslnreratio, resid
*reslnreratio is the part of lnreratio independent of the time trend 

reg lnrgdppc date
predict reslnrgdppc, resid
*reslnrgdppc is the part of lnrgdppc independent of the time trend

twoway (tsline reslnreratio) (tsline reslnrgdppc, yaxis(2))
*not much apparent long term relationship
reg reslnreratio reslnrgdppc
*Interpretation


*We could have detrended just by adding a time trend to the regression
reg lnreratio lnrgdppc date

*Same coefficient
*What to make of the differences in R-Squared?

*Could also detrend by differencing.
**Work through the math here!!!!
reg d.lnreratio d.lnrgdppc
*Results differ. Why? Come back to this latter...


*Seasonal Effects

*Look at the detrended time series again, shorter span
twoway (tsline reslnreratio) (tsline reslnrgdppc, yaxis(2)) if tin(2005q1,2019q3)
*What about the apparent seasonal effects?

*Add quarterly indicators to deal with seasonality
*/
generate quarter=quarter(datec)
/*
reg lnreratio lnrgdppc i.quarter date

*Look at detrended data
reg lnreratio date i.quarter
predict reslnreratio2, resid
*reslnreratio2 is the part of lnreratio independent of time trend & quarter
reg lnrgdppc date i.quarter
predict reslnrgdppc2, resid
*reslnrgdppc2 is the part of lnrgdppc independent of time trend & quarter

*Is there any sort of temporal pattern in these residuals?
twoway (tsline reslnreratio2) (tsline reslnrgdppc2, yaxis(2)) if tin(2005q1,2019q3)
*If so, what can we do to capture it?


*Dynamic Effects: Lags, Cycles

*Finite Distributed Lag Models

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
*Why different numbers of observations?



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


STOP

*2-4-2021

*Recall we were looking at models like this
reg lnreratio l(0,1,4).lnrgdppc date i.quarter

/*Why did I pick these lage?
Do we have a reasonable theory or expectation about what the short 
and long run dynamics should look like?*/

*What are the statistical properties of this model??
*Standard errors are WRONG

**Would it be better still would be to use robust standard errors???
reg lnreratio l(0,1,4).lnrgdppc date i.quarter, robust

/*NO!!! Lack of independence between residuals must be dealt with*/

*Must study strong versus weak dependence before moving on

*Talk about the problem of highly persistent time series

*Introduce random walk, and random walk with drift

****Run I(1) simulation at this point 

*Talk about covariance stationarity and Weak Dependence here.


*We argues running robust standard errors would not fix this model:
*reg lnreratio l(0,1,4).lnrgdppc date i.quarter
*what to do?
*Let us look, informally now, for persistence, by correlation with the past year
*Recall that with random walk, the correlation with the last year was 1

corr lnreratio l.lnreratio lnrgdppc l.lnrgdppc
*reratio: somewhat strong correlation between this year and last
*gdp: looks much like a random walk!

*What about for differenced data?
corr d.lnreratio ld.lnreratio d.lnrgdppc ld.lnrgdppc
*Not like a random walk in either case

*So, DIFFERENCE before the regression
*NOT
reg lnreratio l(0/4).lnrgdppc date i.quarter
*Instead 
reg d.lnreratio l(0/4)d.lnrgdppc date i.quarter

*Note the pronounced difference! Spurrious correlation!
*Also, not the time trend appears to do nothing now. Why?

reg d.lnreratio l(0/4)d.lnrgdppc i.quarter

*It is a much more sound statistical model.
*Still not right, but better statisticaly.
*R-squared low, not very predictive, even if statistics were solved.
*Soon we will see a natural way to possibly improve that.



tsline rgdppc if tin(2005q1,2019q3)

*Then talk about the math of AR and MA processes


*/



*Material for 2-16


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
**Examine the AC PAC
ac lnreratio if tin(1980q1,2019q3)
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

**CLASSWORK
*So, how many lags?
*Need to difference?
**Examine the AC PAC
ac lnrgdp if tin(1980q1,2019q3)
pac lnrgdp if tin(1980q1,2019q3)
**Looks like 1? VERY strong AR(1).
**I(1)
**So, need to difference
pac d.lnrgdp if tin(1980q1,2019q3)

*How to test formally if I(1)?
reg d.lnrgdp l.lnreratio date if tin(1980q1,2019q3)
*Can't quite reject Ho I(1)
*But: t-dist not right is it is I(1), so...

*Dickey Fuller Test
dfuller lnrgdp if tin(1980q1,2019q3), trend regress
dfuller lnrgdp if tin(1980q1,2019q3), trend lags(4) regress
*Rejection of Ho I(1) is borderline... BUT...
*Even if not I(1), STILL rho is 0.91, pretty long lasting impacts
**Good idea to work with first differenced data

*End for 2-16



*Start for 2-18-2021

*Let us consider some ARDL Models:
estimates clear
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.quarter date if tin(1980q1,2019q3)
eststo model1
reg d.lnreratio l(1/4)d.lnreratio i.quarter date if tin(1980q1,2019q3)
eststo model2
reg d.lnreratio l(1/4)d.lnreratio l(0/1)d.lnrgdp i.quarter date if tin(1980q1,2019q3)
eststo model3
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.quarter if tin(1980q1,2019q3)
eststo model4
esttab model* using models.rtf, se stat(r2 N) replace

*How to select the best model? Come back to that later.

*Do we still have serial correlation in the residuals?
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.quarter if tin(1980q1,2019q3)
predict res if e(sample)==1, residual
ac res
pac res
*Looks like we are OK here. How to check formally?
 
**In the spirit of:
reg res l(1/12).res l(1/4)d.lnreratio l(0/4)d.lnrgdp i.q if tin(1980q1,2019q3)
testparm l(1/12).res
*Is P(F) Small? If not, can we fail to reject null of no Serial Corr?


**Breusch–Godfrey test
***Alternative using an LM test, don't need extra steps
reg d.lnreratio l(1/4)d.lnreratio l(0/4)d.lnrgdp i.q if tin(1980q1,2019q3)
estat bgodfrey, lag(1/12)
*Tests cumulative through lags
*Does appear to have remaining serial correlation

reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp i.quarter if tin(1980q1,2019q3)
estat bgodfrey, lag(1/12)
*Now appears dynamically complete. But, not parsimonious...
drop res
predict res if e(sample)==1, residual
pac res

*End for 2-18-2021

tabulate quarter
gen q1=0
replace q1=1 if quarter==1
gen q2=0
replace q2=1 if quarter==2
gen q3=0
replace q3=1 if quarter==3
gen q4=0
replace q4=1 if quarter==4
*look at data

drop q1 q2 q3 q4

*Nore could have done this another way:
tabulate quarter, generate(q) 
*Look at data

reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp q3 if tin(1980q1,2019q3)
estat bgodfrey, lag(1/12)
*What about this one?


*End for 2-18-2021




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

