* Time Series Modeling and Forecasting
* Spring 2021

clear
set more off

*set the working directory to wherever you have the data"
cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Pages/Data and Do Files/Do Files"

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


/*
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

*End for 2-16
*/

/*
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

*/

*End for 2-18-2021

/*

*2-23-2021

*Previously, we found this to be appropriately differenced
* and apprarently dynamically complete:

reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp i.quarter if tin(1980q1,2019q3)
estat bgodfrey, lag(1/12)

/*
But maybe not parsimnious. Consider this theoretical model:
For the effect of GDP
	If GDP jumps today, there is an immediate corresponding jump in tax revenue
	Some of that revenue may spill over a quarter.
	For the lagged budget position	
	The best baseline is a year ago, not a quarter ago
	Two years ago may be informative too, since last year may have been a fluke
This story suggests a model something like this
*/

reg d.lnreratio l(4,8)d.lnreratio l(0,1,4,8)d.lnrgdp i.quarter if tin(1980q1,2019q3)
estat bgodfrey, lag(8,12)
*still dynamically complete

*Was the lost explanatory power significant? Test is statistically:
reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp i.quarter if tin(1980q1,2019q3)
testparm l(1/3,5/7)d.lnreratio l(2,3,5/7)d.lnrgdp
*Statistically, yes. Is the complication worth it? Judgement call.


/*This is dynamically complete, but is it the "right" model if you want
to know how a change in gdp changes the budget position over the next 2 years?
Maybe not, because the dynamics are complicated. What is you want ti
evaluate this model:
*/

reg d.lnreratio l(0/4)d.lnrgdp i.quarter if tin(1980q1,2019q3)
estat bgodfrey, lag(8,12)
*NOT dynamically complete!

*Use robust standard errors
newey d.lnreratio l(0/8)d.lnrgdp i.quarter if tin(1980q1,2019q3), lag(8)
*these SEs give Valid CIs.
*note 0.75*159^(1/3) is about 4. Why did I go 8 in the lag() option?


* End for 2-23-2021

*Spring 2021 Midterm through this point



* 3-4-2021

*Choosing the 'Best' Model
*How to decide which among candidate models is best?
*We will revisit this again and again.

*/
tabulate quarter, generate(q) // An alternative way to get quarter inicators
/*
browse // look at data


*Previously we had two dynamically complete models:
*recall this model
reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 if tin(1980q1,2019q3)
estat bgodfrey , lag(8,12)
eststo budget1
*It is dynamically complete. Should look at resicual pac

/*Is it best?
How to make it more parsimonious?
Why does Parsimony matter?

Domain knowledge and joint hypothesis tests are a start
	Suppose you had reason to think lages 2,3,5, and 7 of y less important
	And lags of X after 4 are not important.
	Test that hypothesis */

testparm l(2,3,5,7)d.lnreratio l(5/8)d.lnrgdppc
*No evidence these matter here. 

*So consider this model
reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 if tin(1980q1,2019q3)
estat bgodfrey , lag(8,12)
eststo budget2
*Simpler, still dynamically complete, should look at residual pac


*Now a more extreme case of simplifying
testparm l(1,6)d.lnreratio l(2,3)d.lnrgdppc
*they do 'matter'
*for sake of illustration, drop them anyway 
reg d.lnreratio l(4,8)d.lnreratio l(0,1,4)d.lnrgdp q2 q3 q4   if tin(1980q1,2019q3)
estat bgodfrey, lag(8,12)
*still dynamically complete by this measure, should look at residual pac
*test seasonal adj and ld.lnrdgp
testparm l(1)d.lnrgdppc q2 q3 q4
*so drop them -- THIS IS OVERFITTING BEHAVIOR even though dropping things!!!!!
*but, doing it to illustrate
*result is
reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp  if tin(1980q1,2019q3)
estat bgodfrey, lag(8,12)
*Still dynamically complete by this measure. Should look at residual pac
eststo budget3

*This gives us three models to compare.
*Discuss the options in the esttab command
esttab budget* using "budget models.rtf" , ///
	nogaps scalars(rmse df_m) r2 aic bic replace



/*So, again, Which is best?
Could maybe argue 2 is better than 1 based on content knowledge
	and reasonable joint hypothesis tests.
	If you do this other than very sparingly, it will lead to overfitting
		But, should not ignore subject matter knowledge, either
Model 3 was just manipulated by an arbitrary decision to drop
	some thigns from 2 even though the hypothesis test indicated they mattered
	then some more things based on more hypothesis tests.
Ultimately, we need empirical ways to check models
	that guards against over fitting!

Go to the board and discuss AIC, BIC, LOOCV, K-Fold Cross validation*/


*End 3-4-2021

*/


*3-9-2021

*Install crossfold and loocv
*ssc install crossfold
*ssc install loocv

*Use these to compare the three candidate models
set seed 8344613 // set seed so cross folds don't change

matrix drop _all // deleting matrices saved in earlier runs
scalar drop _all // deleting scalars from earlier runs


*Most complex model
*discuss what all this does
crossfold reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3) , k(10)
*discuss output
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse1=(el(kMSE,1,1)/k)^.5
scalar list krmse1
matrix drop kMSE
scalar drop k

loocv reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
*discuss output
scalar define loormse1=r(rmse)

*get AIC BIC for comparison
reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
estat ic
scalar define df1=el(r(S),1,4)
scalar define aic1=el(r(S),1,5)
scalar define bic1=el(r(S),1,6)

	
*Intermediate model
crossfold reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3), k(10)
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse2=(el(kMSE,1,1)/k)^.5
scalar list krmse2
matrix drop kMSE
scalar drop k

loocv reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
scalar define loormse2=r(rmse)

reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
estat ic
scalar define df2=el(r(S),1,4)
scalar define aic2=el(r(S),1,5)
scalar define bic2=el(r(S),1,6)



*most parsimonious model
crossfold reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp if tin(1980q1,2019q3), k(10)
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse3=(el(kMSE,1,1)/k)^.5
scalar list krmse3
matrix drop kMSE
scalar drop k

loocv reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp if tin(1980q1,2019q3)
scalar define loormse3=r(rmse)

*get AIC BIC for comparison
reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp if tin(1980q1,2019q3)
estat ic
scalar define df3=el(r(S),1,4)
scalar define aic3=el(r(S),1,5)
scalar define bic3=el(r(S),1,6)



matrix drop _all
matrix fit1=(df1,aic1,bic1,krmse1,loormse1)
matrix fit2=(df2,aic2,bic2,krmse2,loormse2)
matrix fit3=(df3,aic3,bic3,krmse3,loormse3)
matrix FIT=fit1\fit2\fit3
matrix rownames FIT="Model 1" "Model 2" "Model 3"
matrix colnames FIT=df AIC BIC K(10)RMSE LOORMSE
matrix list FIT


*By these empirical measures, designed to guard against overfitting
**Models 2 appears best. Why?

*End for 3-9-2021


*Start a newish do file for 3-11-2021

*Moving to Forecasting!

