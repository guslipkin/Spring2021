# Problem Set 4

# Gus Lipkin

> All corrections are <u>underlined</u>

## Problems

1. Drop any observations after December 2019.

```
drop if tin(2020m1,)
```

2. Refer to homework 3, question 2. Adapt the four models used there so they will be appropriate for making a one period ahead forecast.

```
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/12)d.lnfllf l(1/12)d.lnusepr l(1/12)d.lnflbp i.month date
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2)d.lnfllf l(1/2)d.lnusepr l(1/2)d.lnflbp i.month date
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month
```

3. For each model, calculate the out of sample RMSE for the last year of observations (last 12 observations). To do this, you must not include these observations in the model estimation.

|      | c1        | c2        | c3        | c4        |
| ---- | --------- | --------- | --------- | --------- |
| r1   | .00341856 | .00356652 | .00352901 | .00347889 |

4. For each model, prepare a figure with the actual change in the log of nonfarm employment for the last 24 months, and for the last year the point forecast and the forecast interval, again using the model fit excluding the last 12 months.

<img src="Problem Set 4.assets/predictNonfarm1.png" style="zoom:50%;" />

<img src="Problem Set 4.assets/predictNonfarm2.png" style="zoom:50%;" />

<img src="Problem Set 4.assets/predictNonfarm3.png" style="zoom:50%;" />

<img src="Problem Set 4.assets/predictNonfarm4.png" style="zoom:50%;" />

5. Select the best model for forecasting purposes based on AIC, BIC, LOOCV, and out of sample RMSE for the final year of data. Justify your choice.

|         | df   | AIC            | BIC            | RMSE          | LOORMSE       |
| ------- | ---- | -------------- | -------------- | ------------- | ------------- |
| Model 1 | 61   | -3114.0527     | -2875.1644     | **.00341856** | .00380836     |
| Model 2 | 31   | -3190.9568     | -3068.7301     | .00356652     | .00371849     |
| Model 3 | 31   | -3115.1451     | -2993.7429     | .00352901     | .00375319     |
| Model 4 | 33   | **-4236.6004** | **-4097.3209** | .00347889     | **.00355785** |

​	I chose model four because the AIC, BIC, and LOORMSE were the lowest. The only difference was that the lowest RMSE was model 1. However, the difference in RMSE for model 1 and model 4 is very low so I'm comfortable choosing model 4 over model 3.

6. For the best model, transform the values appropriately and prepare a figure with the actual level of nonfarm employment (not the log) for the last 24 months, and for the last 12 months the point forecast and the forecast interval for nonfarm employment. For the interval forecast, assume approximate normality, and use the standard error of the forecast.

<img src="Problem Set 4.assets/predictNonfarm6.png" style="zoom:50%;" />

7. Now prepare another figure, again for the best model, with the actual level of nonfarm employment for the last 24 months, and for the last 12 months the point forecast and the forecast interval for nonfarm employment. This time, use the empirical approach, based on the data used to fit the model, to construct the forecast interval.

<img src="Problem Set 4.assets/predictNonfarm7.png" style="zoom:50%;" />

8. Run these commands to add January 2020 to the data (for which you will generate a forecast) and fill in the corresponding values for year and month:
   				tsappend, add(1)
      				replace month=month(dofm(date)) if month==.

```
tsappend, add(1)
replace month=month(dofm(date)) if month==.
```

9. Run your selected model on the full sample and use it to forecast January 2020. Create point and

   interval forecasts for the change in the log of non-farm employment. Use the empirical approach.

<img src="Problem Set 4.assets/predictNonfarm9.png" alt="predictNonfarm9" style="zoom:50%;" />

10. Transform the point and interval forecast of the January 2020 change in the log of non-farm employment to create a point and interval forecast of non-farm employment for January 2020.

<img src="Problem Set 4.assets/predictNonfarm10.png" style="zoom:50%;" />

11. Generate a figure showing the last 12 months of non-farm employment and the January 2020 point and interval forecasts. (The figure shows actual for January 2019 through December 2019 and then the point and interval forecast for January 2020.)

<img src="Problem Set 4.assets/predictFlnonfarm11-6548518.png" alt="predictFlnonfarm11" style="zoom:50%;" />

<u>The point forecast is 9093.688, and the empirical interval is 8923.5 to 9215.6.</u>

## Appendix A

```
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
tsline ubnonfarm2 lbnonfarm2 nonfarm2 d.nonfarm2 if tin(2017m12, 2018m12)
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(1/2,12)d.lnfllf l(1/2,12)d.lnflbp i.month date if tin(,2018m12)
predict nonfarm3
gen ubnonfarm3=nonfarm3+1.96*e(rmse)
gen lbnonfarm3=nonfarm3-1.96*e(rmse)
tsline ubnonfarm3 lbnonfarm3 nonfarm3 d.nonfarm3 if tin(2017m12, 2018m12)
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm4
gen ubnonfarm4=nonfarm4+1.96*e(rmse)
gen lbnonfarm4=nonfarm4-1.96*e(rmse)
tsline ubnonfarm4 lbnonfarm4 nonfarm4 d.nonfarm4 if tin(2017m12, 2018m12)

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
predict nonfarm6
predict stdfore6, stdf
gen pnonfarm6=exp(l.lnflnonfarm+nonfarm6)*exp(.5*e(rmse)^2)
gen ubpnonfarm6=exp(l.lnflnonfarm+nonfarm6+1.96*stdfore6)*exp(.5*e(rmse)^2)
gen lbpnonfarm6=exp(l.lnflnonfarm+nonfarm6-1.96*stdfore6)*exp(.5*e(rmse)^2)
tsline ubpnonfarm6 lbpnonfarm6 pnonfarm6 fl_nonfarm if tin(2016m12,2019m12), tline(2018m12)

*7
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm47
predict pres47 if tin(2016m12,2018m12), residual
gen exppres47=exp(pres47) if tin(2016m12,2018m12)
summ exppres47
gen pnonfarm47=r(mean)*exp(l.lnflnonfarm+nonfarm47)
_pctile exppres47, percentile(2.5,97.5) 
gen lbpnonfarm47=r(r1)*exp(l.lnflnonfarm+nonfarm47)
gen ubpnonfarm47=r(r2)*exp(l.lnflnonfarm+nonfarm47)
tsline ubpnonfarm47 lbpnonfarm47 pnonfarm47 fl_nonfarm if tin(2016m12,2019m12), tline(2018m12)

*8
tsappend, add(1)
replace month=month(dofm(date)) if month==.

*9
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm9
predict pres9 if tin(,2019m12), residual
gen exppres9=exp(pres9) if tin(,2019m12)
summ exppres9
gen pnonfarm9=r(mean)*exp(l.lnflnonfarm+nonfarm9)
_pctile exppres9, percentile(2.5,97.5) 
gen lbnonfarm9=r(r1)*exp(l.lnflnonfarm+nonfarm9)
gen ubnonfarm9=r(r2)*exp(l.lnflnonfarm+nonfarm9)
tsline ubnonfarm9 lbnonfarm9  pnonfarm9 fl_nonfarm if tin(2016m12,2020m1), tline(2019m12)

*10
reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month if tin(,2018m12)
predict nonfarm10
predict stdfore10, stdf
gen pnonfarm10=exp(l.lnflnonfarm+nonfarm10)*exp(.5*e(rmse)^2)
gen ubnonfarm10=exp(l.lnflnonfarm+nonfarm10+1.96*stdfore10)*exp(.5*e(rmse)^2)
gen lbnonfarm10=exp(l.lnflnonfarm+nonfarm10-1.96*stdfore10)*exp(.5*e(rmse)^2)
tsline ubnonfarm10 lbnonfarm10 pnonfarm10 fl_nonfarm if tin(2016m12,2020m1), tline(2019m12)

*11
tsline fl_nonfarm if tin(2018m12,2020m1) || tsline  ubnonfarm10 lbnonfarm10 pnonfarm10 if tin(2019m12,), tline(2019m12)

log close
```

## Appendix B

<img src="Problem Set 4.assets/image-20210323212841540.png" alt="image-20210323212841540" style="zoom:50%;" />