clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Final Exam"
*log using "Final Exam.smcl", replace
import delimited "SP21Final.csv"

gen datec=date(date, "YMD")
gen Date=mofd(datec)
gen month=month(datec)
format Date %tm
tsset Date

gen lnConstruct = ln(construct)
gen lnLeisure = ln(leisure)
gen lnManufacture = ln(manufacture)
gen lnTotal = ln(total)

gen m1=0
replace m1=1 if month==1
gen m2=0
replace m2=1 if month==2
gen m3=0
replace m3=1 if month==3
gen m4=0
replace m4=1 if month==4
gen m5=0
replace m5=1 if month==5
gen m6=0
replace m6=1 if month==6
gen m7=0
replace m7=1 if month==7
gen m8=0
replace m8=1 if month==8
gen m9=0
replace m9=1 if month==9
gen m10=0
replace m10=1 if month==10
gen m11=0
replace m11=1 if month==11

/*
summ construct leisure manufacture total
summ lnConstruct lnLeisure lnManufacture lnTotal

tsline lnConstruct lnLeisure, saving(lnConstructLeisure_tsline.gph, replace)
tsline lnManufacture, saving(lnManufacture_tsline.gph, replace)
graph combine lnConstructLeisure_tsline.gph lnManufacture_tsline.gph, ///
	saving(lnConstructLeisure, replace)
graph export "lnConstructLeisure-Manufacture_tsline.png", replace

ac lnTotal, saving(lnTotal_ac, replace)
pac lnTotal, saving(lnTotal_pac, replace)
graph combine lnTotal_ac.gph lnTotal_pac.gph, saving(lnTotal_ac_pac, replace)
graph export "lnTotal_ac_pac.png", replace

ac lnConstruct, saving(lnConstruct_ac, replace)
pac lnConstruct, saving(lnConstruct_pac, replace)
graph combine lnConstruct_ac.gph lnConstruct_pac.gph, saving(lnConstruct_ac_pac, replace)
graph export "lnConstruct_ac_pac.png", replace

ac lnLeisure, saving(lnLeisure_ac, replace)
pac lnLeisure, saving(lnLeisure_pac, replace)
graph combine lnLeisure_ac.gph lnLeisure_pac.gph, saving(lnLeisure_ac_pac, replace)
graph export "lnLeisure_ac_pac.png", replace

ac lnTotal, saving(lnTotal_ac, replace)
pac lnTotal, saving(lnTotal_pac, replace)
graph combine lnTotal_ac.gph lnTotal_pac.gph, saving(lnManufacture_ac_pac, replace)
graph export "lnManufacture_ac_pac.png", replace
*/

gen dlnConstruct=d.lnConstruct
gen l1dlnConstruct=l1d.lnConstruct
gen l2dlnConstruct=l2d.lnConstruct
gen l3dlnConstruct=l3d.lnConstruct
gen l12dlnConstruct=l12d.lnConstruct
gen l24dlnConstruct=l24d.lnConstruct

gen dlnLeisure=d.lnLeisure
gen l1dlnLeisure=l1d.lnLeisure
gen l2dlnLeisure=l2d.lnLeisure
gen l3dlnLeisure=l3d.lnLeisure
gen l12dlnLeisure=l12d.lnLeisure
gen l24dlnLeisure=l24d.lnLeisure

gen dlnManufacture=d.lnManufacture
gen l1dlnManufacture=l1d.lnManufacture
gen l2dlnManufacture=l2d.lnManufacture
gen l3dlnManufacture=l3d.lnManufacture
gen l12dlnManufacture=l12d.lnManufacture
gen l24dlnManufacture=l24d.lnManufacture

gen dlnTotal=d.lnTotal
gen l1dlnTotal=l1d.lnTotal
gen l2dlnTotal=l2d.lnTotal
gen l3dlnTotal=l3d.lnTotal
gen l12dlnTotal=l12d.lnTotal
gen l24dlnTotal=l24d.lnTotal


*------------------------------------------------------------------------------*
/*
gsreg dlnTotal dlnConstruct l1dlnConstruct l2dlnConstruct l3dlnConstruct ///
	l12dlnConstruct l24dlnConstruct ///
	dlnLeisure l1dlnLeisure l2dlnLeisure l3dlnLeisure l12dlnLeisure l24dlnLeisure ///
	dlnManufacture l1dlnManufacture l2dlnManufacture l3dlnManufacture ///
	l12dlnManufacture l24dlnManufacture ///
	if tin(1990m1,2021m3), ///
	ncomb(1,6) aic outsample(24) fix(m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11) ///
	samesample nindex( -1 aic -1 bic -1 rmse_out) results(gsreg_dlnTtoal) replace
*/

loocv reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
estat ic

loocv reg d.lnTotal l(1/3,12,24)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
reg d.lnTotal l(1/3,12,24)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
estat ic

loocv reg d.lnTotal l(1/3)d.lnTotal l(1/3)d.lnConstruct l(1/3)d.lnLeisure ///
	l(1/3)d.lnManufacture
reg d.lnTotal l(1/3)d.lnTotal l(1/3)d.lnConstruct l(1/3)d.lnLeisure ///
	l(1/3)d.lnManufacture
estat ic

loocv reg d.lnTotal l(1/3,12,24)d.lnTotal l(1/3,12,24)d.lnConstruct ///
	l(1/3,12,24)d.lnLeisure l(1/3)d.lnManufacture
reg d.lnTotal l(1/3,12,24)d.lnTotal l(1/3,12,24)d.lnConstruct ///
	l(1/3,12,24)d.lnLeisure l(1/3)d.lnManufacture
estat ic
