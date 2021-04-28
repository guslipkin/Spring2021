# Problem Set 6

> Corrections are <u>underlined</u>. All corrections are from the official solutions.

## ARDL

<img src="/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 6/ardl.png" alt="ardl" style="zoom:50%;" />

## AR

<img src="/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 6/ar.png" alt="ar" style="zoom:50%;" />

## Discussion

​	The ARDL model is much more "linear" than the AR model. While they both have the same general model, it looks like the AR model drew much more from the peak in 2019 than the ARDL did. I think this is because the AR model is only using nonfarm data so it's much more likely to replicate itself while the ARDL which uses more than one variable.

<u>The-3 sigma interval corresponds to a 99.7% CI under the assumption the errors are normal, and such an interval would contain the actual outcome at least 89% of the time regardless of the underlying distribution. Hence, regardless of the actual distribution, it is unlikely employment will lie outside of the 3-sigma band.</u>

<u>Since the dynamic forecasting method is more subject to compounding errors, we would expect the forecast interval to be wider, but it is not. From the direct estimate of the 6 month change, the RMSE (for the log change) was 0.0115. From the dynamic model, 6 months out it was 0.0079 (adding the successive MSEs and taking the square root). This seems too low! What follows was not really required for full credit, but is worth thinking through carefully.</u>

<u>I ran the rolling window procedure for the entire sample period, using the OLS version of the model, to get the RMSE for forecasting the log change out one period. The RMSE was 0.0048. So, 6 months out, rmse should be about 0.0048*6^.5=0.0118. This is higher than 0.0115 from estimating the 6 month change directly, as it should be. And that does not even factor in what would happen if we ran through this 6 times dynamically with Rolling window, which would likely give a yet larger RMSE due to compounding the modeling error component, not just the residual component. The true RMSE would be even higher.</u>

<u>So, at the 6-month mark, the dynamic approach is underestimating the 95% ci upper bound by a factor BIGGER than exp(2*(0.0118-0.0079)) = 1.0078, and the lower interval lower by a factor smaller than 1/1.0078. With employment at the end of 2019 at 9.204 M, the CI upper bound should be at least 0.072M higher and the lower bound at least 0.072 lower.</u>

<u>Bottom line: is the CI is quite a bit too small with the dynamic technique! A quick dynamic forecast is fine if the stakes are low, and the fanchart is very suggestive. However, if the stakes are high, take the time to find the best model for the times of interest and use rolling window estimation and validation.</u>

