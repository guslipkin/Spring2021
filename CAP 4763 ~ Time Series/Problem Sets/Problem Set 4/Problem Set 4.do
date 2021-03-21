clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 4"

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
log using "Problem Set 4", replace

*2d Generate a monthly date variable (make its display format monthly time, %tm)
gen datec=date(datestring, "YMD")
gen date=mofd(datec)
gen month=month(datec)
format date %tm

*2e tsset your data
tsset date

*2f
gen lnusepr=log(us_epr)
gen lnflnonfarm=log(fl_nonfarm)
gen lnfllf=log(fl_lf)
gen lnflbp=log(fl_bp)

*1
drop if tin(2020m1,)

*2
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month

*3
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date if tin(,2018m12)
scalar define rmse1=e(rmse)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date if tin(,2018m12)
scalar define rmse2=e(rmse)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date if tin(,2018m12)
scalar define rmse3=e(rmse)
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
scalar define rmse4=e(rmse)

matrix drop _all
matrix row=(rmse1, rmse2, rmse3, rmse4)
matrix RMSE = row
matrix list RMSE

*4
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date if tin(,2018m12)
predict nonfarm1
gen ubnonfarm1=nonfarm1+1.96*e(rmse)
gen lbnonfarm1=nonfarm1-1.96*e(rmse)
tsline ubnonfarm1 lbnonfarm1 nonfarm1 d.nonfarm1 if tin(2017m12, 2018m12)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date if tin(,2018m12)
predict nonfarm2
gen ubnonfarm2=nonfarm2+1.96*e(rmse)
gen lbnonfarm2=nonfarm2-1.96*e(rmse)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date if tin(,2018m12)
predict nonfarm3
gen ubnonfarm3=nonfarm3+1.96*e(rmse)
gen lbnonfarm3=nonfarm3-1.96*e(rmse)
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm4
gen ubnonfarm4=nonfarm4+1.96*e(rmse)
gen lbnonfarm4=nonfarm4-1.96*e(rmse)

*5
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date
estat ic
scalar define df1=el(r(S),1,4)
scalar define aic1=el(r(S),1,5)
scalar define bic1=el(r(S),1,6)
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date
scalar define loormse1=r(rmse)

reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date
estat ic
scalar define df2=el(r(S),1,4)
scalar define aic2=el(r(S),1,5)
scalar define bic2=el(r(S),1,6)
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date
scalar define loormse2=r(rmse)

reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date
estat ic
scalar define df3=el(r(S),1,4)
scalar define aic3=el(r(S),1,5)
scalar define bic3=el(r(S),1,6)
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date
scalar define loormse3=r(rmse)

reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month
estat ic
scalar define df4=el(r(S),1,4)
scalar define aic4=el(r(S),1,5)
scalar define bic4=el(r(S),1,6)
loocv reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month
scalar define loormse4=r(rmse)

matrix drop _all
matrix fit1=(df1,aic1,bic1,rmse1,loormse1)
matrix fit2=(df2,aic2,bic2,rmse2,loormse2)
matrix fit3=(df3,aic3,bic3,rmse3,loormse3)
matrix fit4=(df4,aic4,bic4,rmse4,loormse4)
matrix FIT=fit1\fit2\fit3\fit4
matrix rownames FIT="Model 1" "Model 2" "Model 3" "Model 4"
matrix colnames FIT=df AIC BIC RMSE LOORMSE
matrix list FIT

*6
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm44
gen pnonfarm44=exp(nonfarm44+l.fl_nonfarm)
gen ubpnonfarm44=pnonfarm44+1.96*e(rmse)
gen lbpnonfarm44=pnonfarm44-1.96*e(rmse)
tsline ubpnonfarm44 lbpnonfarm44 pnonfarm44 fl_nonfarm if tin(2016m12,2019m12), tline(2018m12)

*7
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm47
predict pres47 if tin(,2018m12), residual
gen exppres=exp(pres47) if tin(,2018m12)
summ exppres
gen pnonfarm47=r(mean)*pnonfarm44
gen ubpnonfarm47=pnonfarm44+1.96*e(rmse)
gen lbpnonfarm47=pnonfarm44-1.96*e(rmse)
tsline ubpnonfarm47 lbpnonfarm47 pnonfarm47 fl_nonfarm if tin(2016m12,2019m12), tline(2018m12)

*8
tsappend, add(1)
replace month=month(dofm(date)) if month==.

*9
