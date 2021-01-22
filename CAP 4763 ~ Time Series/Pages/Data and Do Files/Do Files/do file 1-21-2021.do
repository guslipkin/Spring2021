
* Time Series Modeling and Forecasting
* Spring 2021
*Work for 1-21-2021

clear
set more off

*set the working directory to wherever you have the data"
cd "C:\Users\jdewey\Documents\A S21 Time Series\data and do files"
*turn on a log file
log using "example 1-21-2020"

*import the data
import delimited "shotgun spread data.csv"

/* Some description of the data

Source: W.F. Rowe and S.R. Hanson(1985). "Range-of-Fire Estimates from
Regression Analysis Applied to the Spreads of Shotgun Pellets Patterns: Results
of a Blind Study," Forensic Science International, Vol. 28, pp. 239-250

Description: Results of an experiment relating the square root of the area
spread of shotgun pellets to range of fire, for shotgun cartridge types.
Residuals show heterogeneity, and can be analyzed by weighted least squares.

Variables/Columns
Cartridge   /* 1=Winchester Western Super X 00, 2=Remington No. 4  */
Range (distance, in feet) 
Square root of spread (inches)

The point? Crime scene analysis. Determine how far away a shooter was 
when a shot was fired.

Is it linear? Does the load matter? Is there an interaction?

*/

*Scatter plot
scatter rtspread range

STOP

*Simple Regression
regress rtspread range
*discuss t-test

*Recall Heteroscedasticity is present
regress rtspread range, robust
*discuss new t-test

*Expain results


*Multiple Regression
regress rtspread c.range##i.win, robust
*Explain results

*Note two additional vars not significant.
*Is the model as a whole significant?
*Give intuition of the F-test

*Do the two new vars add anything together?
testparm i.win i.win#c.range

*If they matter jointly, why not individually?
gen winXrange=win*range
corr win range winXrange

*Discuss variance of coefficient j under Homoscedasticity
*and from there multicollinearity and variance inflation factors
vif

*Does logic imply anything about what to drop?
regress rtspread c.range i.win#c.range, robust


*Examine Residuals
predict prtspread
predict resrtspread, residual
scatter resrtspread prtspread , yline(0)
*does that consitute a pattern?
reg resrtspread c.prtspread##c.prtspread
*is that enough to worry about? What would happen to the model?

regress rtspread c.range##c.range i.win#c.range i.win#c.range#c.range , robust
vif

predict prtspread2
predict resrtspread2, residual
scatter resrtspread2 prtspread2 , yline(0)
*does that consitute a pattern?
reg resrtspread2 c.prtspread2##c.prtspread2

*did we gain enough to justify the complication?


log close
*Print a copy of the work to pdf
**MAKE SURE TO RENAME THESE TO MATCH THE DAYS WORK
translate "work 1-21-2021.smcl" "work 1-21-2021.pdf"


