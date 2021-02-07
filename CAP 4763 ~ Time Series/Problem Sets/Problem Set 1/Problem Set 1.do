clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 1"

*2b Load the data
import delimited "Assignment_1_Monthly.txt"

rename lnu02300000 us_epr
rename flnan fl_nonfarm
rename fllfn fl_lf
rename flbppriv fl_bp
rename date datestring

*2c Turn on a log file


*2d Generate a monthly date variable (make its display format monthly time, %tm)
gen datec=date(datestring, "YMD")
gen date=mofd(datec)
format date %tm

*2e tsset your data
tsset date

*2f
gen ln_us_epr=log(us_epr)
gen ln_fl_nonfarm=log(fl_nonfarm)
gen ln_fl_lf=log(fl_lf)
gen ln_fl_bp=log(fl_bp)


/*
3a Explain why the size of Florida’s labor force, the prime age employment to population ratio, and
Florida building permits, might be closely related to the number of nonfarm jobs in Florida in a static long run sense. You might want to make some time series plots to give your data context. (Perhaps where one variable is employment and the other, on the other axis, is one of the other variables.)
*/
* THIS SHOULD BE A PARAGRAPH

*3b Estimate the static model relating monthly nonfarm employment in Florida to the other three variables (all in logs) without controlling for seasonal impacts or a time trend.
regress ln_fl_nonfarm ln_fl_lf ln_us_epr ln_fl_bp
rvfplot, yline(0)

*3c Estimate the static model with month indicators and a time trend.
gen month=month(datec)
reg ln_fl_nonfarm ln_fl_lf ln_us_epr ln_fl_bp i.month date

*3d Compare your results from b and c and interpret any differences. What do the seasonal and time trend variables contribute?


*3e Why should you be cautious using the results of these models for testing any hypotheses about the underlying relationships?

*4a Estimate the distributed lag model relating monthly nonfarm employment to lags 0 to 12 of the three predictor variables without month indicators and a time trend.

*4b Estimate the model in (a) but add month indicators and a time trend.

*4d Compare your results from a and c and interpret any differences. What do the seasonal and time trend variables contribute?

*4e Estimate two alternative models that contain month indicators and a time trend but that impose a more parsimonious lag structure for the predictor variables. Explain your choices.
