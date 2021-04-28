*Problem Set 4 Solution

clear
set more off
cd "C:\Users\jdewey\Documents\A S20 Time Series\Problem Sets\"
log using "Problem Set 4 Work", replace


** data prep
import delimited using "us and florida economic time series.txt" 
rename observation_date datestring
gen dateday=date(datestring,"YMD")
gen date=mofd(dateday)
format date %tm
tsset date
generate month=month(dateday)
keep if tin(1990m1,2019m12)
rename flbppriv fl_bp
rename fllfn fl_lf
rename flnan fl_nonfarm
rename lnu02300000_20200110 us_epr
gen lnflnonfarm=ln( fl_nonfarm)
gen lnfllf=ln( fl_lf)
gen lnusepr = ln(us_epr)
gen lnflbp=ln( fl_bp)

tsappend, add(1)
replace month=month(dofm(date)) if month==.




*fit and evaluate models
*Note I restricted estimation to year>1989 so the same observations are
* compared for all models by dropping earlier years above


*Model 1
set seed 22045 // to  make sure the same folds are used for each model
crossfold reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf ///
	l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date , k(10)
scalar define k=10
matrix kSSE=r(est)'*r(est)
scalar krmse1=(el(kSSE,1,1)/k)^.5
matrix drop kSSE
scalar drop k	
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf ///
	l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date
scalar loormse1=r(rmse)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf ///
	l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date 
estat ic
scalar aic1=(el(r(S),1,5))
scalar bic1=(el(r(S),1,6))
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf ///
	l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date if tin(1991m1,2018m12)
scalar NVar1=e(df_m)
predict res, residual
predict pdln1
predict stdf1, stdf
gen ressq=res^2
summ ressq if tin(2018q1,2018q4)
scalar osrmse1=r(mean)^0.5
drop res ressq
gen ubdln1=pdln1+1.96*stdf1
gen lbdln1=pdln1-1.96*stdf1
twoway (tsline d.lnflnonfarm if tin(2018m1,2019m12)) ///
	(tsline pdln1 ubdln1 lbdln1 if tin(2019m1,2019m12) ) , ///
	saving(m1tslines, replace)





*Model 2	
set seed 22045 // to  make sure the same folds are used for each model
crossfold reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf ///
	l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date , k(10)
scalar define k=10
matrix kSSE=r(est)'*r(est)
scalar krmse2=(el(kSSE,1,1)/k)^.5
matrix drop kSSE
scalar drop k	
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf ///
	l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date 
scalar loormse2=r(rmse)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr ///
	l(1/2)d.lnflbp i.month date 
estat ic
scalar aic2=(el(r(S),1,5))
scalar bic2=(el(r(S),1,6))
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr ///
	l(1/2)d.lnflbp i.month date if tin(1991m1,2018m12)
scalar NVar2=e(df_m)
predict res, residual
predict pdln2
predict stdf2, stdf
gen ressq=res^2
summ ressq if tin(2018q1,2018q4)
scalar osrmse2=r(mean)^0.5
drop res ressq
gen ubdln2=pdln2+1.96*stdf2
gen lbdln2=pdln2-1.96*stdf2
twoway (tsline d.lnflnonfarm if tin(2018m1,2019m12)) ///
	(tsline pdln2 ubdln2 lbdln2 if tin(2019m1,2019m12) ) , ///
	saving(m2tslines, replace)



*Model 3
set seed 22045 // to  make sure the same folds are used for each model
crossfold reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf ///
	l(1/2,12)d.lnflbp i.month date , k(10)
scalar define k=10
matrix kSSE=r(est)'*r(est)
scalar krmse3=(el(kSSE,1,1)/k)^.5
matrix drop kSSE
scalar drop k	
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf ///
	l(1/2,12)d.lnflbp i.month date
scalar loormse3=r(rmse)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf ///
	l(1/2,12)d.lnflbp i.month date 
estat ic
scalar aic3=(el(r(S),1,5))
scalar bic3=(el(r(S),1,6))
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf ///
	l(1/2,12)d.lnflbp i.month date if tin(1991m1,2018m12)
scalar NVar3=e(df_m)
predict res, residual
predict pdln3
predict stdf3, stdf
gen ressq=res^2
summ ressq if tin(2018q1,2018q4)
scalar osrmse3=r(mean)^0.5
drop res ressq
gen ubdln3=pdln3+1.96*stdf3
gen lbdln3=pdln3-1.96*stdf3
twoway (tsline d.lnflnonfarm if tin(2018m1,2019m12)) ///
	(tsline pdln3 ubdln3 lbdln3 if tin(2019m1,2019m12) ) , ///
	saving(m3tslines, replace)


*Model 4
set seed 22045 // to  make sure the same folds are used for each model
crossfold reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf ///
	l(1/2,12,24)d.lnusepr i.month , k(10)
scalar define k=10
matrix kSSE=r(est)'*r(est)
scalar krmse4=(el(kSSE,1,1)/k)^.5
matrix drop kSSE
scalar drop k	
loocv reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf ///
	l(1/2,12,24)d.lnusepr i.month
scalar loormse4=r(rmse)
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf ///
	l(1/2,12,24)d.lnusepr i.month 
estat ic
scalar aic4=(el(r(S),1,5))
scalar bic4=(el(r(S),1,6))
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf ///
	l(1/2,12,24)d.lnusepr i.month if tin(1991m1,2018m12)
scalar NVar4=e(df_m)
predict res, residual
predict pdln4
predict stdf4, stdf
gen ressq=res^2
summ ressq if tin(2018q1,2018q4)
scalar osrmse4=r(mean)^0.5
drop res ressq
gen ubdln4=pdln4+1.96*stdf4
gen lbdln4=pdln4-1.96*stdf4
twoway (tsline d.lnflnonfarm if tin(2018m1,2019m12)) ///
	(tsline pdln4 ubdln4 lbdln4 if tin(2019m1,2019m12) ) ///
	, saving(m4tslines, replace)


matrix M1=(NVar1,aic1,bic1,krmse1,loormse1,osrmse1)
matrix M2=(NVar2,aic2,bic2,krmse2,loormse2,osrmse2)
matrix M3=(NVar3,aic3,bic3,krmse3,loormse3,osrmse3)
matrix M4=(NVar4,aic4,bic4,krmse4,loormse4,osrmse4)
matrix MStats=(M1\M2\M3\M4)
matrix colnames MStats=NVar AIC BIC RMSE10F RMSENF RMSEOS 
matrix rownames MStats=Model1 Model2 Model3 Model4 
matrix list MStats

graph combine m1tslines.gph m2tslines.gph m3tslines.gph m4tslines.gph , ///
	saving(mtslines, replace)


*Going to go with model 3

drop pdl* ub* lb* stdf*
scalar drop _all
	
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf ///
	l(1/2,12)d.lnflbp i.month date 
predict pdln
predict stdf
scalar rmse=e(rmse)
gen corrnorm=exp((rmse^2)/2)
predict res
gen expres=exp(res)
summ expres
gen corremp=r(mean)


gen pyn=corrnorm*exp(l.lnflnon+pdln)
gen ubyn=corrnorm*exp(l.lnflnon+pdln+1.96*rmse)
gen lbyn=corrnorm*exp(l.lnflnon+pdln-1.96*rmse)
twoway (tsline fl_nonfarm if tin(2018m1,2019m12)) ///
	(tsline pyn ubyn lbyn if tin(2019m1,2019m12) ) ///
	, saving(m3ynorm, replace)


_pctile res, percentiles(2.5,97.5)
gen pye=corremp*exp(l.lnflnon+pdln)
gen ubye=corremp*exp(l.lnflnon+pdln+r(r2))
gen lbye=corremp*exp(l.lnflnon+pdln+r(r1))
twoway (tsline fl_nonfarm if tin(2018m1,2019m12)) ///
	(tsline pye ubye lbye if tin(2019m1,2019m12) ) ///
	, saving(m3yemp, replace)

graph combine m3ynorm.gph m3yemp.gph , ///
	saving(m3yen, replace)


gen fub=ubye if tin(2020m1,)
gen flb=lbye if tin(2020m1,)
gen fcst=pye if tin(2020m1,)
replace fcst=fl_non if tin(2019m12,2019m12)
replace fub=fl_non if tin(2019m12,2019m12)
replace flb=fl_non if tin(2019m12,2019m12)

tsline fl_nonfarm fub flb fcst if tin(2019m1,2020m1) , saving(fcst, replace)

list fcst fub flb if date==tm(2020m1)

log close







