clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Final Exam"
log using "Final Exam.smcl", replace
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

gen Total = total
gen Construct = construct
gen Leisure = leisure
gen Manufacture = manufacture

/*
gen withMarchTotal = Total
replace Total=. if tin(2021m3,)
*/

tsset Date
tsappend, add(12)
replace month=month(dofm(Date))

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


summ construct leisure manufacture total
summ lnConstruct lnLeisure lnManufacture lnTotal

tsline lnConstruct lnLeisure, saving(lnConstructLeisure_tsline.gph, replace)
tsline lnManufacture, saving(lnManufacture_tsline.gph, replace)
graph combine lnConstructLeisure_tsline.gph lnManufacture_tsline.gph, ///
	saving(lnConstructLeisure, replace)
graph export "lnConstructLeisure-Manufacture_tsline.png", replace

tsline lnTotal, saving(lnTotal_tsline.gph, replace)
tsline d.lnTotal, saving(dlnTotal_tsline.gph, replace)
graph combine Total_tsline.gph dlnTotal_tsline.gph, saving(lnTotal-Total, replace)
graph export "lnTotal-dlnTotal_tsline.png", replace

ac lnTotal, saving(lnTotal_ac, replace)
pac lnTotal, saving(lnTotal_pac, replace)
graph combine lnTotal_ac.gph lnTotal_pac.gph, saving(lnTotal_ac_pac, replace)
graph export "lnTotal_ac_pac.png", replace
dfuller lnTotal, trend regress

ac lnConstruct, saving(lnConstruct_ac, replace)
pac lnConstruct, saving(lnConstruct_pac, replace)
graph combine lnConstruct_ac.gph lnConstruct_pac.gph, saving(lnConstruct_ac_pac, replace)
graph export "lnConstruct_ac_pac.png", replace
dfuller lnConstruct, trend regress

ac lnLeisure, saving(lnLeisure_ac, replace)
pac lnLeisure, saving(lnLeisure_pac, replace)
graph combine lnLeisure_ac.gph lnLeisure_pac.gph, saving(lnLeisure_ac_pac, replace)
graph export "lnLeisure_ac_pac.png", replace
dfuller lnLeisure, trend regress

ac lnManufacture, saving(lnManufacture_ac, replace)
pac lnManufacture, saving(lnManufacture_pac, replace)
graph combine lnManufacture_ac.gph lnManufacture_pac.gph, saving(lnManufacture_ac_pac, replace)
graph export "lnManufacture_ac_pac.png", replace
dfuller lnManufacture, trend regress

quietly reg l(12,24)d.Construct l(12,24)d.Leisure l(12,24)d.Manufacture
testparm l(12,24)d.Construct l(12,24)d.Leisure l(12,24)d.Manufacture

newey d.lnTotal l(0/3,12,24)d.Construct l(0/3,12,24)d.Manufacture l(0/3,12,24)d.Leisure, lag(24)
test ld.Construct + ld.Construct + l2d.Construct + l3d.Construct + l12d.Construct + l24d.Construct ///
	== d.Manufacture + ld.Manufacture + l2d.Manufacture + l3d.Manufacture + ///
		l12d.Manufacture + l24d.Manufacture
test d.Construct + ld.Construct + l2d.Construct + l3d.Construct + l12d.Construct + l24d.Construct ///
	== d.Leisure + ld.Leisure + l2d.Leisure + l3d.Leisure + l12d.Leisure + l24d.Leisure
test d.Leisure + ld.Leisure + l2d.Leisure + l3d.Leisure + l12d.Leisure + l24d.Leisure ///
	== d.Manufacture + ld.Manufacture + l2d.Manufacture + l3d.Manufacture + ///
		l12d.Manufacture + l24d.Manufacture

*------------------------------------------------------------------------------*
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
quietly reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
estat ic

loocv reg d.lnTotal l(1/3,12,24)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
quietly reg d.lnTotal l(1/3,12,24)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
estat ic

loocv reg d.lnTotal l(1/3)d.lnTotal l(1/3)d.lnConstruct l(1/3)d.lnLeisure ///
	l(1/3)d.lnManufacture m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
quietly reg d.lnTotal l(1/3)d.lnTotal l(1/3)d.lnConstruct l(1/3)d.lnLeisure ///
	l(1/3)d.lnManufacture m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
estat ic

loocv reg d.lnTotal l(1/3,12,24)d.lnTotal l(1/3,12,24)d.lnConstruct ///
	l(1/3,12,24)d.lnLeisure l(1/3)d.lnManufacture m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
quietly reg d.lnTotal l(1/3,12,24)d.lnTotal l(1/3,12,24)d.lnConstruct ///
	l(1/3,12,24)d.lnLeisure l(1/3)d.lnManufacture m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
estat ic

*Lowest rmse (1)
reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=12(12)180 {
gen pred=.
gen nobs=.
	forval t=544/734 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnTotal)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list

/*
RWmaxobs12 =         12
RWminobs12 =         12
RWrmse12 =   .0132376
*/

*lowest AIC and BIC (3)
reg d.lnTotal l(1/3)d.lnTotal l(1/3)d.lnConstruct l(1/3)d.lnLeisure ///
	l(1/3)d.lnManufacture m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11
scalar drop _all
quietly forval w=3(3)180 {
gen pred=.
gen nobs=.
	forval t=544/734 { 
	gen wstart=`t'-`w'
	gen wend=`t'-1
	reg d.lnTotal l(1/3)d.lnTotal l(1/3)d.lnConstruct l(1/3)d.lnLeisure ///
		l(1/3)d.lnManufacture m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 ///
		if Date>=wstart & Date<=wend
	replace nobs=e(N) if Date==`t'
	predict ptemp
	replace pred=ptemp if Date==`t'
	drop ptemp wstart wend
	}
gen errsq=(pred-d.lnTotal)^2
summ errsq
scalar RWrmse`w'=r(mean)^.5
summ nobs
scalar RWminobs`w'=r(min)
scalar RWmaxobs`w'=r(max)
drop errsq pred nobs
}
scalar list
/*
RWmaxobs12 =         12
RWminobs12 =         12
RWrmse12 =   .0132376
*/


* Going with model 1 because average RWrmse is lower across window sizes
scalar rwrmse = .0132376
reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(,2021m3)
predict pd
gen pflcount=exp((rwrmse^2)/2)*exp(l.lnTotal+pd) if Date==tm(2021m4)
gen ub1=exp((rwrmse^2)/2)*exp(l.lnTotal+pd+1*rwrmse) if Date==tm(2021m4)
gen lb1=exp((rwrmse^2)/2)*exp(l.lnTotal+pd-1*rwrmse) if Date==tm(2021m4)
gen ub2=exp((rwrmse^2)/2)*exp(l.lnTotal+pd+2*rwrmse) if Date==tm(2021m4)
gen lb2=exp((rwrmse^2)/2)*exp(l.lnTotal+pd-2*rwrmse) if Date==tm(2021m4)
gen ub3=exp((rwrmse^2)/2)*exp(l.lnTotal+pd+3*rwrmse) if Date==tm(2021m4)
gen lb3=exp((rwrmse^2)/2)*exp(l.lnTotal+pd-3*rwrmse) if Date==tm(2021m4)
drop pd

replace pflcount=Total if Date==tm(2021m3)
replace ub1=Total if Date==tm(2021m3)
replace ub2=Total if Date==tm(2021m3)
replace ub3=Total if Date==tm(2021m3)
replace lb1=Total if Date==tm(2021m3)
replace lb2=Total if Date==tm(2021m3)
replace lb3=Total if Date==tm(2021m3)

twoway (tsrline ub3 ub2 if tin(2020m4,2021m4), ///
	recast(rarea) fcolor(orange) fintensity(20) lwidth(none) ) ///
	(tsrline ub2 ub1 if tin(2020m4,2021m4), ///
	recast(rarea) fcolor(green) fintensity(40) lwidth(none) ) ///
	(tsrline ub1 pflcount if tin(2020m4,2021m4), ///
	recast(rarea) fcolor(purple) fintensity(65) lwidth(none) ) ///
	(tsrline pflcount lb1 if tin(2020m4,2021m4), ///
	recast(rarea) fcolor(purple) fintensity(65) lwidth(none) ) ///
	(tsrline lb1 lb2 if tin(2020m4,2021m4), ///
	recast(rarea) fcolor(green) fintensity(40) lwidth(none) ) ///
	(tsrline lb2 lb3 if tin(2020m4,2021m4), ///
	recast(rarea) fcolor(orange) fintensity(20) lwidth(none) ) ///
	(tsline Total pflcount if tin(2020m4,2021m4) , ///
	lcolor(gs12 pink) lwidth(medthick medthick) ///
	lpattern(solid longdash)), scheme(s1mono) legend(off)
graph export "TotalFan1.png", replace

* More than 1 step
arima d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(1990m1,2021m3)
predict pnonfarm, dynamic(tm(2021m3))
predict mse, mse dynamic(mofd(tm(2021m4)))
gen totmse = mse if Date==tm(2021m4)
replace totmse = l.totmse+mse if Date>tm(2021m4)
gen pnonfarma = Total if Date==tm(2021m3)
replace pnonfarma = l.pnonfarma*exp(pnonfarm+mse/2) if Date>tm(2021m3)

gen ub1a = pnonfarma*exp(totmse^.5)
gen ub2a = pnonfarma*exp(2*totmse^.5)
gen ub3a = pnonfarma*exp(3*totmse^.5)
gen lb1a = pnonfarma/exp(totmse^.5)
gen lb2a = pnonfarma/exp(2*totmse^.5)
gen lb3a = pnonfarma/exp(3*totmse^.5)

replace ub1a=Total if Date == tm(2021m3)
replace ub2a=Total if Date == tm(2021m3)
replace ub3a=Total if Date == tm(2021m3)
replace lb1a=Total if Date == tm(2021m3)
replace lb2a=Total if Date == tm(2021m3)
replace lb3a=Total if Date == tm(2021m3)

twoway (tsrline ub3a ub2a if tin(2019m1,2022m3), ///
	recast(rarea) fcolor(red) fintensity(20) lwidth(none) ) ///
	(tsrline ub2a ub1a if tin(2019m1,2022m3), ///
	recast(rarea) fcolor(yellow) fintensity(40) lwidth(none) ) ///
	(tsrline ub1a pnonfarma if tin(2019m1,2022m3), ///
	recast(rarea) fcolor(blue) fintensity(65) lwidth(none) ) ///
	(tsrline pnonfarma lb1a if tin(2019m1,2022m3), ///
	recast(rarea) fcolor(blue) fintensity(65) lwidth(none) ) ///
	(tsrline lb1a lb2a if tin(2019m1,2022m3), ///
	recast(rarea) fcolor(yellow) fintensity(40) lwidth(none) ) ///
	(tsrline lb2a lb3a if tin(2019m1,2022m3), ///
	recast(rarea) fcolor(red) fintensity(20) lwidth(none) ) ///
	(tsline Total pnonfarma if tin(2019m1,2022m3) , ///
	lcolor(gs12 pink) lwidth(medthick medthick) ///
	lpattern(solid longdash)) , scheme(s1mono) legend(off)
graph export "TotalFan12.png", replace

scalar rmse_mod1 = .0132376
reg d.lnTotal l(1/3)d.lnTotal m1 m2 m3 m4 m5 m6 m7 m8 m9 m10 m11 if tin(1990m1,2021m3)
predict plTotal
predict temp if tin(2021m3,2021m3)
replace plTotal=temp if tin(2021m3,2021m3)
drop temp
gen pTotal=exp(l.lnTotal+plTotal+(rmse_mod1^2)/2)
gen lbTotal=exp(l.lnTotal+plTotal-1.96*rmse_mod1+(rmse_mod1^2)/2)
gen ubTotal=exp(l.lnTotal+plTotal+1.96*rmse_mod1+(rmse_mod1^2)/2)

gen res=(d.lnTotal-plTotal)
gen expres=exp(res)
summ expres
scalar meanexpres=r(mean)
gen epTotal=exp(l.lnTotal+plTotal)*meanexpres
_pctile res, percentile(2.5,97.5)
return list
gen elbTotal=exp(l.lnTotal+plTotal+r(r1))*meanexpres
gen eubTotal=exp(l.lnTotal+plTotal+r(r2))*meanexpres
	
tsline Total pTotal elbTotal eubTotal lbTotal ubTotal if tin(2019m1,2021m4), ///
	scheme(s1mono) tline(2021m3, lcolor(gs4)) ///
	lpattern(solid solid longdash longdash shortdash shortdash) ///
	lcolor(dkorange gs5 gs10 gs10 dkorange%60 dkorange%60) ///
	lwidth(medthick medthick medium medium)
graph export "interval_tsline.png", replace
	
histogram expres, normal kdensity saving(residuals.gph, replace)
graph export "residuals.png", replace

log close
translate "Final Exam.smcl" "Final Project.txt", replace
