# 2021-02-16 Time Series Classwork

```
ac lnrgdp if tin(1980q1,2019q3)
```

![image-20210216180348087](/Users/guslipkin/Library/Application Support/typora-user-images/image-20210216180348087.png)


```
pac lnrgdp if tin(1980q1,2019q3)
```

![image-20210216180411967](/Users/guslipkin/Library/Application Support/typora-user-images/image-20210216180411967.png)


```
pac d.lnrgdp if tin(1980q1,2019q3)
```

![image-20210216180455128](/Users/guslipkin/Library/Application Support/typora-user-images/image-20210216180455128.png)

Strong year-over-year correlation



```
reg d.lnrgdp l.lnreratio date if tin(1980q1,2019q3)
```

| Source     | SS                | df        | MS      Number of obs   =      | 159       |
| ---------- | ----------------- | --------- | ------------------------------ | --------- |
|            | F(2, 156)       = | 0.11      |                                |           |
| Model      | .000174096        | 2         | .000087048   Prob > F        = | 0.8978    |
| Residual   | .12591447         | 156       | .000807144   R-squared       = | 0.0014    |
|            | Adj R-squared   = | -0.0114   |                                |           |
| Total      | .126088566        | 158       | .000798029   Root MSE        = | .02841    |
|            |                   |           |                                |           |
| D.lnrgdppc | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|            |                   |           |                                |           |
| lnreratio  |                   |           |                                |           |
| L1.        | -.0092021         | .0200453  | -0.46   0.647    -.0487974     | .0303932  |
|            |                   |           |                                |           |
| date       | -6.21e-06         | .0000495  | -0.13   0.900    -.0001039     | .0000915  |
| _cons      | .0033183          | .0085325  | 0.39   0.698    -.0135358      | .0201724  |

Need to difference this one then take the seasonal difference of the differences

> ```
> gen z=d.lnrgdppc - l4d.lnrgdppc
> ```


dfuller lnrgdp if tin(1980q1,2019q3), trend regress
```

| Dickey-Fuller test for unit root                   Number of obs   =       159 |
| ------------------------------------------------------------ |
| Interpolated Dickey-Fuller ---------                         |
| Test         1% Critical       5% Critical      10% Critical |
| Statistic           Value             Value             Value |
| Z(t)             -4.297            -4.020            -3.442            -3.142 |
| MacKinnon approximate p-value for Z(t) = 0.0032              |
|                                                              |
| D.lnrgdppc       Coef.   Std. Err.      t    P>t     [95% Conf. Interval] |
| lnrgdppc                                                     |
| L1.   -.2129173   .0495536    -4.30   0.000    -.3107998   -.1150347 |
| _trend     .000911   .0002178     4.18   0.000     .0004807    .0013412 |
| _cons    .4367175   .1007428     4.33   0.000     .2377216    .6357134 |
|                                                              |


```
dfuller lnrgdp if tin(1980q1,2019q3), trend lags(4) regress
```

| Augmented Dickey-Fuller test for unit root         Number of obs   =       159 |
| ------------------------------------------------------------ |
| Interpolated Dickey-Fuller ---------                         |
| Test         1% Critical       5% Critical      10% Critical |
| Statistic           Value             Value             Value |
| Z(t)             -2.920            -4.020            -3.442            -3.142 |
| MacKinnon approximate p-value for Z(t) = 0.1560              |
|                                                              |
| D.lnrgdppc       Coef.   Std. Err.      t    P>t     [95% Conf. Interval] |
| lnrgdppc                                                     |
| L1.   -.0564162   .0193235    -2.92   0.004    -.0945935   -.0182389 |
| LD.   -.0608648   .0490022    -1.24   0.216    -.1576782    .0359487 |
| L2D.   -.0530661   .0472079    -1.12   0.263    -.1463344    .0402023 |
| L3D.   -.1106043   .0465007    -2.38   0.019    -.2024754   -.0187331 |
| L4D.    .8195014   .0458889    17.86   0.000      .728839    .9101639 |
| _trend     .000236   .0000851     2.77   0.006     .0000678    .0004041 |
| _cons    .1168117   .0390729     2.99   0.003     .0396156    .1940078 |
|                                                              |


```