clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 1"

*2b Load the data
import delimited "Assignment_1.csv"

rename lnu02300000 us_epr


*2c Turn on a log file


*2d Generate a monthly date variable (make its display format monthly time, %tm)
generate datec=date(datestring, "YMD")
gen date=mofd(datec)
format date %tm

/*
3a Explain why the size of Florida’s labor force, the prime age employment to population ratio, and
Florida building permits, might be closely related to the number of nonfarm jobs in Florida in a static long run sense. You might want to make some time series plots to give your data context. (Perhaps where one variable is employment and the other, on the other axis, is one of the other variables.)
*/
* THIS SHOULD BE A PARAGRAPH
