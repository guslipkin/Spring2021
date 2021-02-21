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


log close
