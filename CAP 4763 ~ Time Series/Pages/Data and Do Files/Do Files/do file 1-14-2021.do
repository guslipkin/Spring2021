*Population Regression Function Demonstration

clear
set seed 14599 // set the seed for the random number generator
set obs 2000 // A population of 2000

*Generate three random exogenous variables that are the csouses
gen w=runiform(20,90)
gen q=rnormal(0,10)
gen z=rnormal(0,20)


gen x=round(10+.8*w+.6*q,10) // x is caused by w and q
gen y=10+4*w-0.03*w^2+.7*z //y is caused by w and z

*So, x and y are not causally linked at all!!!

egen ymean=mean(y), by(x) // calculating E(Y|X)

gen residual=y-ymean // the population residual

scatter y ymean x, sort m(oh i) c(i l)
/* Some things to note:
1) X is predictive of Y, but not a cause of Y
2) If you manipulate X to "cause" more Y, you will be disappointed!!!
3) If you use X to forecast Y, but change w or z in the process, there
	is no reason to expect the structure underlying the prediction to
	continue to hold!
*/

STOP

gen random=runiform()
gen sample=0
replace sample=1 if random<0.05
scatter y x if sample==1, m(oh)

regress y x if sample==1
predict py if sample==1 // predicted value based on regression
predict sampleres if sample==1, residual // sample residuals
scatter y ymean py x if sample==1 , sort m(oh i i) c(i l l)
*Our predictions are off because we made a specificstion error!
scatter sampleres x if sample==1
scatter sampleres py if sample==1

gen x2=x^2
regress y x x2 if sample==1
predict py2 if sample==1 // predicted value based on regression
predict sampleres2 if sample==1, residual // sample residuals
scatter y ymean py py2 x if sample==1 , sort m(oh i i i) c(i l l l)
scatter sampleres2 x if sample==1
scatter sampleres2 py2 if sample==1
*The approximation of the PRF is much better now.
**This is still purely predictive, beware using it for changing actions!







