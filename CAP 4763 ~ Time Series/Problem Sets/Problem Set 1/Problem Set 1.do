clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 1"

*2a
*Done

*2b Load the data
import delimited "Assignment_1_Monthly.txt"

rename lnu02300000 us_epr
rename flnan fl_nonfarm
rename fllfn fl_lf
rename flbppriv fl_bp
rename date datestring

*2c Turn on a log file
log using "Problem Set 1", replace

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

*3b Estimate the static model relating monthly nonfarm employment in Florida to the other three variables (all in logs) without controlling for seasonal impacts or a time trend.
regress ln_fl_nonfarm ln_fl_lf ln_us_epr ln_fl_bp

*3c Estimate the static model with month indicators and a time trend.
gen month=month(datec)
reg ln_fl_nonfarm ln_fl_lf ln_us_epr ln_fl_bp i.month date

*4a Estimate the distributed lag model relating monthly nonfarm employment to lags 0 to 12 of the three predictor variables without month indicators and a time trend.
regress ln_fl_nonfarm l(0/12).ln_fl_lf l(0/12).ln_us_epr l(0/12).ln_fl_bp

*4b Estimate the model in (a) but add month indicators and a time trend.
regress ln_fl_nonfarm l(0/12).ln_fl_lf l(0/12).ln_us_epr l(0/12).ln_fl_bp i.month date

*4e Estimate two alternative models that contain month indicators and a time trend but that impose a more parsimonious lag structure for the predictor variables. Explain your choices.
regress ln_fl_nonfarm l(0,4,8,12).ln_fl_lf l(0,4,8,12).ln_us_epr l(0,4,8,12).ln_fl_bp i.month date
gen dateQ = qofd(datec)
format dateQ %tq
regress ln_fl_nonfarm l(0/4).ln_fl_lf l(0/4).ln_us_epr l(0/4).ln_fl_bp i.month dateQ


log close
