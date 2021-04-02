log using "Problem Set 3", replace
*1a
clear
set obs 30
gen t=[_n]
tsset t
gen r=rnormal()
gen y=r if t<4
replace y=0.5+0.5*l.y-0.1*l2.y+0.25*l3.y+r if t>=4 
drop r

*model
reg d.y l1d.y
*aic/bic
estat ic
scalar define df1=el(r(S),1,4)
scalar define aic1=el(r(S),1,5)
scalar define bic1=el(r(S),1,6)
*10 fold cv rmse
crossfold reg d.y l1d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse1=(el(kMSE,1,1)/k)^.5
scalar list krmse1
matrix drop kMSE
scalar drop k
*loocv
loocv reg d.y l1d.y
scalar define loormse1=r(rmse)

reg d.y l2d.y
estat ic
scalar define df2=el(r(S),1,4)
scalar define aic2=el(r(S),1,5)
scalar define bic2=el(r(S),1,6)
crossfold reg d.y l2d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse2=(el(kMSE,1,1)/k)^.5
scalar list krmse2
matrix drop kMSE
scalar drop k
loocv reg d.y l2d.y
scalar define loormse2=r(rmse)

reg d.y l3d.y
estat ic
scalar define df3=el(r(S),1,4)
scalar define aic3=el(r(S),1,5)
scalar define bic3=el(r(S),1,6)
crossfold reg d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse3=(el(kMSE,1,1)/k)^.5
scalar list krmse3
matrix drop kMSE
scalar drop k
loocv reg d.y l3d.y
scalar define loormse3=r(rmse)

reg d.y l1d.y l2d.y
estat ic
scalar define df12=el(r(S),1,4)
scalar define aic12=el(r(S),1,5)
scalar define bic12=el(r(S),1,6)
crossfold reg d.y l1d.y l2d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse12=(el(kMSE,1,1)/k)^.5
scalar list krmse12
matrix drop kMSE
scalar drop k
loocv reg d.y l1d.y l2d.y
scalar define loormse12=r(rmse)

reg d.y l1d.y l3d.y
estat ic
scalar define df13=el(r(S),1,4)
scalar define aic13=el(r(S),1,5)
scalar define bic13=el(r(S),1,6)
crossfold reg d.y l1d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse13=(el(kMSE,1,1)/k)^.5
scalar list krmse13
matrix drop kMSE
scalar drop k
loocv reg d.y l1d.y l3d.y
scalar define loormse13=r(rmse)

reg d.y       l2d.y l3d.y
estat ic
scalar define df23=el(r(S),1,4)
scalar define aic23=el(r(S),1,5)
scalar define bic23=el(r(S),1,6)
crossfold reg d.y       l2d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse23=(el(kMSE,1,1)/k)^.5
scalar list krmse23
matrix drop kMSE
scalar drop k
loocv reg d.y       l2d.y l3d.y
scalar define loormse23=r(rmse)

reg d.y l1d.y l2d.y l3d.y
estat ic
scalar define df123=el(r(S),1,4)
scalar define aic123=el(r(S),1,5)
scalar define bic123=el(r(S),1,6)
crossfold reg d.y l1d.y l2d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse123=(el(kMSE,1,1)/k)^.5
scalar list krmse123
matrix drop kMSE
scalar drop k
loocv reg d.y l1d.y l2d.y l3d.y
scalar define loormse123=r(rmse)

matrix drop _all
matrix fit1=(df1,aic1,bic1,krmse1,loormse1)
matrix fit2=(df2,aic2,bic2,krmse2,loormse2)
matrix fit3=(df3,aic3,bic3,krmse3,loormse3)
matrix fit12=(df12,aic12,bic12,krmse12,loormse12)
matrix fit13=(df13,aic13,bic13,krmse13,loormse13)
matrix fit23=(df23,aic23,bic23,krmse23,loormse23)
matrix fit123=(df123,aic123,bic123,krmse123,loormse123)
matrix FIT=fit1\fit2\fit3\fit12\fit13\fit23\fit123
matrix rownames FIT="Model 1" "Model 2" "Model 3" "Model 12" "Model 13" "Model 23" "Model 123"
matrix colnames FIT=df AIC BIC K(10)RMSE LOORMSE
matrix list FIT

*1b
clear
set obs 300
gen t=[_n]
tsset t
gen r=rnormal()
gen y=r if t<4
replace y=0.5+0.5*l.y-0.1*l2.y+0.25*l3.y+r if t>=4 
drop r

*model
reg d.y l1d.y
*aic/bic
estat ic
scalar define df1=el(r(S),1,4)
scalar define aic1=el(r(S),1,5)
scalar define bic1=el(r(S),1,6)
*10 fold cv rmse
crossfold reg d.y l1d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse1=(el(kMSE,1,1)/k)^.5
scalar list krmse1
matrix drop kMSE
scalar drop k
*loocv
loocv reg d.y l1d.y
scalar define loormse1=r(rmse)

reg d.y l2d.y
estat ic
scalar define df2=el(r(S),1,4)
scalar define aic2=el(r(S),1,5)
scalar define bic2=el(r(S),1,6)
crossfold reg d.y l2d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse2=(el(kMSE,1,1)/k)^.5
scalar list krmse2
matrix drop kMSE
scalar drop k
loocv reg d.y l2d.y
scalar define loormse2=r(rmse)

reg d.y l3d.y
estat ic
scalar define df3=el(r(S),1,4)
scalar define aic3=el(r(S),1,5)
scalar define bic3=el(r(S),1,6)
crossfold reg d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse3=(el(kMSE,1,1)/k)^.5
scalar list krmse3
matrix drop kMSE
scalar drop k
loocv reg d.y l3d.y
scalar define loormse3=r(rmse)

reg d.y l1d.y l2d.y
estat ic
scalar define df12=el(r(S),1,4)
scalar define aic12=el(r(S),1,5)
scalar define bic12=el(r(S),1,6)
crossfold reg d.y l1d.y l2d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse12=(el(kMSE,1,1)/k)^.5
scalar list krmse12
matrix drop kMSE
scalar drop k
loocv reg d.y l1d.y l2d.y
scalar define loormse12=r(rmse)

reg d.y l1d.y l3d.y
estat ic
scalar define df13=el(r(S),1,4)
scalar define aic13=el(r(S),1,5)
scalar define bic13=el(r(S),1,6)
crossfold reg d.y l1d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse13=(el(kMSE,1,1)/k)^.5
scalar list krmse13
matrix drop kMSE
scalar drop k
loocv reg d.y l1d.y l3d.y
scalar define loormse13=r(rmse)

reg d.y       l2d.y l3d.y
estat ic
scalar define df23=el(r(S),1,4)
scalar define aic23=el(r(S),1,5)
scalar define bic23=el(r(S),1,6)
crossfold reg d.y       l2d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse23=(el(kMSE,1,1)/k)^.5
scalar list krmse23
matrix drop kMSE
scalar drop k
loocv reg d.y       l2d.y l3d.y
scalar define loormse23=r(rmse)

reg d.y l1d.y l2d.y l3d.y
estat ic
scalar define df123=el(r(S),1,4)
scalar define aic123=el(r(S),1,5)
scalar define bic123=el(r(S),1,6)
crossfold reg d.y l1d.y l2d.y l3d.y
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse123=(el(kMSE,1,1)/k)^.5
scalar list krmse123
matrix drop kMSE
scalar drop k
loocv reg d.y l1d.y l2d.y l3d.y
scalar define loormse123=r(rmse)

matrix drop _all
matrix fit1=(df1,aic1,bic1,krmse1,loormse1)
matrix fit2=(df2,aic2,bic2,krmse2,loormse2)
matrix fit3=(df3,aic3,bic3,krmse3,loormse3)
matrix fit12=(df12,aic12,bic12,krmse12,loormse12)
matrix fit13=(df13,aic13,bic13,krmse13,loormse13)
matrix fit23=(df23,aic23,bic23,krmse23,loormse23)
matrix fit123=(df123,aic123,bic123,krmse123,loormse123)
matrix FIT=fit1\fit2\fit3\fit12\fit13\fit23\fit123
matrix rownames FIT="Model 1" "Model 2" "Model 3" "Model 12" "Model 13" "Model 23" "Model 123"
matrix colnames FIT=df AIC BIC K(10)RMSE LOORMSE
matrix list FIT

*2
clear
cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 3"
import delimited "Assignment_1_Monthly.txt"

rename lnu02300000 us_epr
rename flnan fl_nonfarm
rename fllfn fl_lf
rename flbppriv fl_bp
rename date datestring

*2d Generate a monthly date variable (make its display format monthly time, %tm)
gen datec=date(datestring, "YMD")
gen date=mofd(datec)
format date %tm

*2e tsset your data
tsset date
gen month=month(datec)

*2f
gen lnusepr=log(us_epr)
gen lnflnonfarm=log(fl_nonfarm)
gen lnfllf=log(fl_lf)
gen lnflbp=log(fl_bp)

*model
reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/12)d.lnfllf l(0/12)d.lnusepr l(0/12)d.lnflbp i.month date
*aic/bic
estat ic
scalar define df1=el(r(S),1,4)
scalar define aic1=el(r(S),1,5)
scalar define bic1=el(r(S),1,6)
*10 fold cv rmse
crossfold reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/12)d.lnfllf l(0/12)d.lnusepr l(0/12)d.lnflbp i.month date
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse1=(el(kMSE,1,1)/k)^.5
scalar list krmse1
matrix drop kMSE
scalar drop k
*loocv
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/12)d.lnfllf l(0/12)d.lnusepr l(0/12)d.lnflbp i.month date
scalar define loormse1=r(rmse)

reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/2)d.lnfllf l(0/2)d.lnusepr l(0/2)d.lnflbp i.month date
estat ic
scalar define df2=el(r(S),1,4)
scalar define aic2=el(r(S),1,5)
scalar define bic2=el(r(S),1,6)
crossfold reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/2)d.lnfllf l(0/2)d.lnusepr l(0/2)d.lnflbp i.month date
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse2=(el(kMSE,1,1)/k)^.5
scalar list krmse2
matrix drop kMSE
scalar drop k
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/2)d.lnfllf l(0/2)d.lnusepr l(0/2)d.lnflbp i.month date
scalar define loormse2=r(rmse)

reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/2,12)d.lnfllf l(0/2,12)d.lnflbp i.month date
estat ic
scalar define df3=el(r(S),1,4)
scalar define aic3=el(r(S),1,5)
scalar define bic3=el(r(S),1,6)
crossfold reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/2,12)d.lnfllf l(0/2,12)d.lnflbp i.month date
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse3=(el(kMSE,1,1)/k)^.5
scalar list krmse3
matrix drop kMSE
scalar drop k
loocv reg d.lnflnonfarm l(1/12)d.lnflnonfarm l(0/2,12)d.lnfllf l(0/2,12)d.lnflbp i.month date
scalar define loormse3=r(rmse)

reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month
estat ic
scalar define df4=el(r(S),1,4)
scalar define aic4=el(r(S),1,5)
scalar define bic4=el(r(S),1,6)
crossfold reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month
scalar define k=10
matrix kMSE=r(est)'*r(est)
scalar krmse4=(el(kMSE,1,1)/k)^.5
scalar list krmse4
matrix drop kMSE
scalar drop k
loocv reg d.lnflnonfarm l(1/12,24)d.lnflnonfarm l(1/2,12,24)d.lnfllf l(1/2,12,24)d.lnusepr i.month
scalar define loormse4=r(rmse)

matrix drop _all
matrix fit1=(df1,aic1,bic1,krmse1,loormse1)
matrix fit2=(df2,aic2,bic2,krmse2,loormse2)
matrix fit3=(df3,aic3,bic3,krmse3,loormse3)
matrix fit4=(df4,aic4,bic4,krmse4,loormse4)
matrix FIT=fit1\fit2\fit3\fit4
matrix rownames FIT="Model 1" "Model 2" "Model 3" "Model 4"
matrix colnames FIT=df AIC BIC K(10)RMSE LOORMSE
matrix list FIT

log close
