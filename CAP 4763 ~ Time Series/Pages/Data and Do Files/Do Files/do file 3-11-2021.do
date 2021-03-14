* Time Series Modeling and Forecasting
* Spring 2021

***FORECASTING***

clear
set more off

*set the working directory to wherever you have the data"
*cd "C:\Users\jdewey\Documents\A S21 Time Series\data and do files"

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

*generate the natural logs of the receipt to expenditure ratio
**and real gdp per capita
gen lnreratio=ln(reratio)
gen lnrgdppc=ln(rgdppc)

*Add quarter categorical variable to deal with seasonality
generate quarter=quarter(datec)

*Add quarter dummies
tabulate quarter, generate(q)



/*
Start Here 3-11-2021
We had consiered 3 models:
*/
*Most Complex
reg d.lnreratio l(1/8)d.lnreratio l(0/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)	
*Intermediate
reg d.lnreratio l(1,4,6,8)d.lnreratio l(0/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
*Most parsimonious
reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp if tin(1980q1,2019q3

/*
Concluded intermediate was best by AIC, BIC, N-Fold CV, 10-Fold CV
But, is this model suitable for a forecast????
NO! Why?




















Can't use the contemporaneous value of lnrgdppc!
Have to estimate a new model to fit time t based only on what was known at t-1

We should really go back to the drawing board!!!
For now, start by adapting the previous 3
How? Same code, get rid of lag 0 of lnrgdppc
*/


set seed 8344613 // set seed so cross folds don't change
matrix drop _all // deleting matrices saved in earlier runs
scalar drop _all // deleting scalars from earlier runs


*Big Model

crossfold reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3) , k(10)
*discuss output
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse1=(el(kMSE,1,1)/k)^.5
scalar list krmse1
matrix drop kMSE
scalar drop k

loocv reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
*discuss output
scalar define loormse1=r(rmse)

*get AIC BIC for comparison
reg d.lnreratio l(1/8)d.lnreratio l(1/8)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
estat ic
scalar define df1=el(r(S),1,4)
scalar define aic1=el(r(S),1,5)
scalar define bic1=el(r(S),1,6)

	
*Intermediate model
crossfold reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3), k(10)
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse2=(el(kMSE,1,1)/k)^.5
scalar list krmse2
matrix drop kMSE
scalar drop k

loocv reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
scalar define loormse2=r(rmse)

*get AIC BIC for comparison
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 ///
	if tin(1980q1,2019q3)
estat ic
scalar define df2=el(r(S),1,4)
scalar define aic2=el(r(S),1,5)
scalar define bic2=el(r(S),1,6)


*most parsimonious model
crossfold reg d.lnreratio l(4,8)d.lnreratio l(0,4)d.lnrgdp ///
	if tin(1980q1,2019q3), k(10)
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


*Intermediate still best

*We need a more thorough way to search through possibilities
*We will return to that later.
*For now, let us look at the out of "predictions" of the "best" model

reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q3 q4 if tin(1980q1,2019q3)
predict pdlnreratio

tsline pdlnreratio d.lnreratio if tin(1980q1,2019q3)
tsline pdlnreratio d.lnreratio if tin(2015q1,2019q3)

**this is NOT really a fair representation. Why? 
**Come back to that later, for now...

*What about predicting the reratio itself?
gen plnreratio=l.lnreratio+pdlnreratio
gen preratio=exp(l.lnreratio+pdlnreratio)
tsline preratio reratio if tin(2015q1,2019q3)

*There is a technical probem here regarding log-normal vs normal distributions
*Note: there is something off with our transformation
*The log-nomral distribution is not symmetric
*The mean and median are not the same

*Two ways to fix
*Assume normality
reg d.lnreratio l(1,4,6,8)d.lnreratio l(1/4)d.lnrgdp q2 q4 if tin(1980q1,2019q3)
gen preratio2=exp((e(rmse)^2)/2)*preratio if tin(1980q1,2019q4)

*Empirical
predict pres if tin(1980q1,2019q4), residual
gen exppres=exp(pres) if tin(1980q1,2019q4)
summ exppres
gen preratio3=r(mean)*preratio

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

*Stop here for 3-11-2021

