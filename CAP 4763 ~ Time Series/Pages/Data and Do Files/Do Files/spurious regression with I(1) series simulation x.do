*Spurious regression with I(1) series simulation
***must set difference to 0 or 1 where x and y are defined below
***must enter values for x and y drift where they are defined

clear
tempname spuriousdemo
postfile `spuriousdemo' rmse rmsecv using "spurious demo results.dta", replace
quietly {
forvalues i = 1/100 {
clear
set obs 50
generate ydrift=0
generate xdrift=0
generate ry = rnormal()
generate rx = rnormal()
generate yu=ry if [_n]==1
generate xu=rx if [_n]==1
replace yu=ydrift+yu[_n-1]+ry if [_n]>1
replace xu=xdrift+xu[_n-1]+rx if [_n]>1
generate t=[_n]
tsset t
gen y=d0.yu
gen x=d0.xu
loocv reg y x
post `spuriousdemo' (`=e(rmse)') (`=r(rmse)')
}
}
postclose `spuriousdemo'


clear
use "spurious demo results.dta"

stop
gen t=beta/se
gen significant=0
replace significant=1 if abs(t)>2
tab significant
hist t

