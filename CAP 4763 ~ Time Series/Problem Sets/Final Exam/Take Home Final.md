# Part 1

# Part 2

## Differencing, Log Transforms, and Month Dummies

### Differencing

> Construct
> <img src="lnConstruct_ac_pac.png" alt="lnConstruct_ac_pac" style="zoom:50%;" />
>
> Both first lags are high which means we should difference.


> Leisure
> <img src="lnLeisure_ac_pac.png" alt="lnLeisure_ac_pac" style="zoom:50%;" />
>
> Both first lags are high which means we should difference.

> Manufacture
> <img src="lnManufacture_ac_pac.png" alt="lnManufacture_ac_pac" style="zoom:50%;" />
>
> Both first lags are high which means we should difference.

> Total
> <img src="lnTotal_ac_pac.png" alt="lnTotal_ac_pac" style="zoom:50%;" />
>
> Both first lags are high which means we should difference.

### Log Transforms

​	Log transforms make the data not have any values less than zero and forces the data into a normal distribution. It also transforms the data so it has proportional changes rather than absolute changes so that any changes over time can be reported as a percent change.

### Month Dummies

​	There's not any reason to not include month dummies. If your data is monthly or any other form of seasonal, it will help your models because they're now identified to a particular season. If your data isn't seasonal, they won't have any effect.

## Content Knowledge and Model Searches

### Content Knowledge

​	Content knowledge can speed up the model selection process because you may already have an idea of what variables or lags have an effect on the dependent variable. For example, hourly wages and hours scheduled per week are probably a very good indication of monthly wages.

### GSREG

​	Global search regression takes all the variables you feed it and runs a regression for any combination of the variables. This is a powerful tool to fine-tune your models, but without filtering the variables through content knowledge, it could take a very long time to run. Rather than just taking the highest scoring model, you should then examine common features of the highest scoring models on the basis of AIC, BIC, and out of sample root mean square error, and choose the most parsimonious one.

### What's wrong with *stepwise* model selection?

​	It's prone to over fitting because it has bad predictive properties. Instead you should use out of sample fitting because it protects against over fitting. Over fitting is caused by dropping the most insignifcant each step which may include variables that should be included in the model but are not relevant on their own.

## Choosing Models



