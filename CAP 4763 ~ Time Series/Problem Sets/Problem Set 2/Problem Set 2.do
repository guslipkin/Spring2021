clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 2"

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

*3a
corr ln_us_epr l1.ln_us_epr
corr ln_fl_nonfarm l1.ln_fl_nonfarm
corr ln_fl_lf l1.ln_fl_lf
corr ln_fl_bp l1.ln_fl_bp

*3b
ac ln_us_epr, saving(ac_ln_us_epr.gph, replace)
pac ln_us_epr, saving(pac_ln_us_epr.gph, replace)
graph combine ac_ln_us_epr.gph pac_ln_us_epr.gph, saving(combo_ln_us_epr.gph, replace)

ac ln_fl_nonfarm, saving(ac_ln_fl_nonfarm.gph, replace)
pac ln_fl_nonfarm, saving(pac_ln_fl_nonfarm.gph, replace)
graph combine ac_ln_fl_nonfarm.gph pac_ln_fl_nonfarm.gph, saving(combo_ln_fl_nonfarm.gph, replace)

ac ln_fl_lf, saving(ac_ln_fl_lf.gph, replace)
pac ln_fl_lf, saving(pac_ln_fl_lf.gph, replace)
graph combine ac_ln_fl_lf.gph pac_ln_fl_lf.gph, saving(combo_ln_fl_lf.gph, replace)

ac ln_fl_bp, saving(ac_ln_fl_bp.gph, replace)
pac ln_fl_bp, saving(pac_ln_fl_bp.gph, replace)
graph combine ac_ln_fl_bp.gph pac_ln_fl_bp.gph, saving(combo_ln_fl_bp.gph, replace)

*3c
dfuller ln_us_epr, trend regress
dfuller ln_fl_nonfarm, trend regress
dfuller ln_fl_lf, trend regress
dfuller ln_fl_bp, trend regress

*4
regress d.ln_fl_nonfarm l(1/48)d.ln_fl_nonfarm l(12/24)d.ln_us_epr l(1/18, 24)d.ln_fl_lf date
predict res, residual
ac res, saving(p4_ac.gph, replace)
pac res, saving(p4_pac.gph, replace)
graph combine p4_ac.gph p4_pac.gph, saving(p4_combo.gph, replace)
estat bgodfrey, lag(1/48)

*5
reg d.ln_fl_nonfarm l(0/4)d.ln_fl_bp if tin(1948m1,2020m1)
newey d.ln_fl_nonfarm l(0/4)d.ln_fl_bp if tin(1948m1,2020m1), lag(4)

log close
