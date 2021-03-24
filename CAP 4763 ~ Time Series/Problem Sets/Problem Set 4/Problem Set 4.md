# Problem Set 4

# Gus Lipkin

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

|       |      | df   | AIC            | BIC            | RMSE          | LOORMSE       |
| ----- | ---- | ---- | -------------- | -------------- | ------------- | ------------- |
| Model | 1    | 61   | -3114.0527     | -2875.1644     | **.00341856** | .00380836     |
| Model | 2    | 31   | -3190.9568     | -3068.7301     | .00356652     | .00371849     |
| Model | 3    | 31   | -3115.1451     | -2993.7429     | .00352901     | .00375319     |
| Model | 4    | 33   | **-4236.6004** | **-4097.3209** | .00347889     | **.00355785** |

[blah blah blah]

6. For the best model, transform the values appropriately and prepare a figure with the actual level of nonfarm employment (not the log) for the last 24 months, and for the last 12 months the point forecast and the forecast interval for nonfarm employment. For the interval forecast, assume approximate normality, and use the standard error of the forecast.

<img src="Problem Set 4.assets/predictNonfarm6.png" style="zoom:50%;" />

