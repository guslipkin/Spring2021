**Problem Set 1**

**Gus Lipkin**

**CAP 4763 Time Series Modelling and Forecasting**



# Table of Contents


| Section     |
| :---------: |
| [**3 Static Model**](#3-Static-Model) |
| [3a](#3a) |
| [3b](#3b) |
| [3c](#3c) |
| [3d](#3d) |
| [3e](#3e) |
| [**4 Finite Distributed Lag Model**](#4-Finite-Distributed-Lag-Model) |
| [4a](#4a) |
| [4b](#4b) |
| [4d](#4d) |
| [4e](#4e) |
| [**Appendix A**](#Appendix-A) |
| [**Appendix B**](#Appendix-B) |

<div style="page-break-after: always; break-after: page;"></div>

# 3 Static Model

## 3a

> Explain why the size of Florida’s labor force, the prime age employment to population ratio, and Florida building permits, might be closely related to the number of nonfarm jobs in Florida in a static long run sense. You might want to make some time series plots to give your data context. (Perhaps where one variable is employment and the other, on the other axis, is one of the other variables.)

The size of Florida's labor force can only increase for a few reasons. People either grow up and get a job or people move into the state for one reason or another. These would increase the prime age employment to population ratio but those people need places to work. They could either work in construction or any affiliated field which handles building permits or they could work in a building being constructed by the people handling those permits. In the meantime, as farming becomes more efficient and reliant on technology, not as many people are needed to farm the same parcels of land. This leads to more people employed in non-farm jobs.

## 3b
> Estimate the static model relating monthly nonfarm employment in Florida to the other three variables (all in logs) without controlling for seasonal impacts or a time trend.

| Source       | SS                | df        | MS      Number of obs   =      | 396       |
| ------------ | ----------------- | --------- | ------------------------------ | --------- |
|              | F(3, 392)       = | 5972.65   |                                |           |
| Model        | 10.5356085        | 3         | 3.51186951   Prob > F        = | 0.0000    |
| Residual     | .230492978        | 392       | .000587992   R-squared       = | 0.9786    |
|              | Adj R-squared   = | 0.9784    |                                |           |
| Total        | 10.7661015        | 395       | .027255953   Root MSE        = | .02425    |
|              |                   |           |                                |           |
| ln_fl_nonf~m | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|              |                   |           |                                |           |
| ln_fl_lf     | 1.110504          | .0092305  | 120.31   0.000     1.092356    | 1.128651  |
| ln_us_epr    | .6006702          | .047797   | 12.57   0.000     .5066997     | .6946407  |
| ln_fl_bp     | .0516831          | .0028713  | 18.00   0.000     .0460379     | .0573282  |
| _cons        | -11.78364         | .2925244  | -40.28   0.000    -12.35875    | -11.20852 |
|              |                   |           |                                |           |

## 3c
> Estimate the static model with month indicators and a time trend.

| Source       | SS                | df        | MS      Number of obs   =      | 396       |
| ------------ | ----------------- | --------- | ------------------------------ | --------- |
|              | F(15, 380)      = | 2935.69   |                                |           |
| Model        | 10.6739911        | 15        | .711599408   Prob > F        = | 0.0000    |
| Residual     | .092110398        | 380       | .000242396   R-squared       = | 0.9914    |
|              | Adj R-squared   = | 0.9911    |                                |           |
| Total        | 10.7661015        | 395       | .027255953   Root MSE        = | .01557    |
|              |                   |           |                                |           |
| ln_fl_nonf~m | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|              |                   |           |                                |           |
| ln_fl_lf     | .9282631          | .0413265  | 22.46   0.000     .8470059     | 1.00952   |
| ln_us_epr    | .9105558          | .0514333  | 17.70   0.000     .8094263     | 1.011685  |
| ln_fl_bp     | .0466812          | .0021579  | 21.63   0.000     .0424382     | .0509242  |
|              |                   |           |                                |           |
| month        |                   |           |                                |           |
| 2            | .0045623          | .0038378  | 1.19   0.235    -.0029837      | .0121084  |
| 3            | -.001379          | .003839   | -0.36   0.720    -.0089274     | .0061694  |
| 4            | -.0029373         | .0038393  | -0.77   0.445    -.0104863     | .0046116  |
| 5            | -.0142748         | .0038468  | -3.71   0.000    -.0218384     | -.0067112 |
| 6            | -.0356123         | .0038709  | -9.20   0.000    -.0432234     | -.0280012 |
| 7            | -.0519102         | .0038917  | -13.34   0.000    -.0595622    | -.0442582 |
| 8            | -.0380965         | .0038668  | -9.85   0.000    -.0456995     | -.0304936 |
| 9            | -.026004          | .0038581  | -6.74   0.000    -.0335899     | -.0184181 |
| 10           | -.0215894         | .0038763  | -5.57   0.000     -.029211     | -.0139678 |
| 11           | -.0014672         | .0039082  | -0.38   0.708    -.0091517     | .0062173  |
| 12           | .0054514          | .0038735  | 1.41   0.160    -.0021648      | .0130675  |
|              |                   |           |                                |           |
| date         | .0003124          | .0000637  | 4.90   0.000      .000187      | .0004377  |
| _cons        | -10.26323         | .498888   | -20.57   0.000    -11.24416    | -9.282304 |

## 3d
> Compare your results from b and c and interpret any differences. What do the seasonal and time trend variables contribute?

Adding the seasonal and time trend variables transform the data into true time series data and give context to the changes. From both you can see that there is a general increase in nonfarm employment. However, by adding the month indicators, you can see that nonfarm employment decreases ever so slightly from March to November, presumably due to prime farming season.

## 3e
> Why should you be cautious using the results of these models for testing any hypotheses about the underlying relationships?

In time series data, the past affects the future and observations are not independent. Standard error and p-value assume that your data is independent which we just established time series data is not.



# 4 Finite Distributed Lag Model

## 4a
> Estimate the distributed lag model relating monthly nonfarm employment to lags 0 to 12 of the three predictor variables without month indicators and a time trend.

| Source       | SS                | df        | MS      Number of obs   =      | 384       |
| ------------ | ----------------- | --------- | ------------------------------ | --------- |
|              | F(39, 344)      = | 1506.36   |                                |           |
| Model        | 9.45063897        | 39        | .242324076   Prob > F        = | 0.0000    |
| Residual     | .055338456        | 344       | .000160868   R-squared       = | 0.9942    |
|              | Adj R-squared   = | 0.9935    |                                |           |
| Total        | 9.50597742        | 383       | .024819784   Root MSE        = | .01268    |
|              |                   |           |                                |           |
| ln_fl_nonf~m | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|              |                   |           |                                |           |
| ln_fl_lf     |                   |           |                                |           |
| -.           | -.3180953         | .2192272  | -1.45   0.148    -.7492898     | .1130992  |
| L1.          | -.4936055         | .2780395  | -1.78   0.077    -1.040477     | .0532661  |
| L2.          | .3085466          | .27846    | 1.11   0.269     -.239152      | .8562452  |
| L3.          | 1.173922          | .2948363  | 3.98   0.000     .5940134      | 1.753831  |
| L4.          | -.2346487         | .2905929  | -0.81   0.420    -.8062113     | .3369138  |
| L5.          | .2808166          | .2958343  | 0.95   0.343    -.3010552      | .8626884  |
| L6.          | -.2076341         | .3372426  | -0.62   0.539    -.8709511     | .4556829  |
| L7.          | .428488           | .3391507  | 1.26   0.207    -.2385821      | 1.095558  |
| L8.          | .4803611          | .3332665  | 1.44   0.150    -.1751354      | 1.135858  |
| L9.          | .2977526          | .3112925  | 0.96   0.339    -.3145235      | .9100288  |
| L10.         | -.00028           | .3217814  | -0.00   0.999    -.6331867     | .6326267  |
| L11.         | -.5860114         | .3256137  | -1.80   0.073    -1.226456     | .0544331  |
| L12.         | .0176351          | .2499574  | 0.07   0.944    -.4740021      | .5092724  |
|              |                   |           |                                |           |
| ln_us_epr    |                   |           |                                |           |
| -.           | 1.180441          | .1573579  | 7.50   0.000     .8709364      | 1.489946  |
| L1.          | .2435207          | .202013   | 1.21   0.229    -.1538155      | .6408569  |
| L2.          | -.1519264         | .2015081  | -0.75   0.451    -.5482695     | .2444166  |
| L3.          | -.719111          | .2119425  | -3.39   0.001    -1.135977     | -.3022447 |
| L4.          | .1877102          | .2014654  | 0.93   0.352    -.2085489      | .5839692  |
| L5.          | -.1596306         | .206881   | -0.77   0.441    -.5665414     | .2472803  |
| L6.          | .4937537          | .2396216  | 2.06   0.040     .0224458      | .9650615  |
| L7.          | -.3031484         | .236988   | -1.28   0.202    -.7692764     | .1629796  |
| L8.          | -.2995254         | .2312056  | -1.30   0.196    -.7542801     | .1552293  |
| L9.          | .5953076          | .2915942  | 2.04   0.042     .0217756      | 1.16884   |
| L10.         | -.1656984         | .352639   | -0.47   0.639    -.8592984     | .5279015  |
| L11.         | .5326939          | .3523697  | 1.51   0.132    -.1603764      | 1.225764  |
| L12.         | -.4280274         | .2543508  | -1.68   0.093     -.928306     | .0722511  |
|              |                   |           |                                |           |
| ln_fl_bp     |                   |           |                                |           |
| -.           | .0177815          | .0051888  | 3.43   0.001     .0075758      | .0279872  |
| L1.          | .0056999          | .0054688  | 1.04   0.298    -.0050566      | .0164565  |
| L2.          | .0123023          | .0056879  | 2.16   0.031     .0011149      | .0234898  |
| L3.          | -.0005041         | .0058381  | -0.09   0.931    -.0119871     | .0109788  |
| L4.          | -.0040248         | .0058282  | -0.69   0.490    -.0154881     | .0074385  |
| L5.          | .0053648          | .0058106  | 0.92   0.357     -.006064      | .0167937  |
| L6.          | .0122019          | .0057914  | 2.11   0.036     .0008108      | .0235929  |
| L7.          | .0146252          | .0057698  | 2.53   0.012     .0032766      | .0259737  |
| L8.          | .0114715          | .0057663  | 1.99   0.047     .0001299      | .0228131  |
| L9.          | .0100892          | .0057895  | 1.74   0.082    -.0012981      | .0214765  |
| L10.         | -.0077443         | .0056515  | -1.37   0.171    -.0188601     | .0033715  |
| L11.         | -.0129284         | .0055227  | -2.34   0.020    -.0237908     | -.002066  |
| L12.         | -.0156324         | .0052843  | -2.96   0.003    -.0260261     | -.0052388 |
|              |                   |           |                                |           |
| _cons        | -14.00483         | .220126   | -63.62   0.000    -14.43779    | -13.57187 |

## 4b
> Estimate the model in (a) but add month indicators and a time trend.

| Source       | SS                | df        | MS      Number of obs   =      | 384       |
| ------------ | ----------------- | --------- | ------------------------------ | --------- |
|              | F(51, 332)      = | 1880.48   |                                |           |
| Model        | 9.47318331        | 51        | .185748692   Prob > F        = | 0.0000    |
| Residual     | .03279411         | 332       | .000098777   R-squared       = | 0.9966    |
|              | Adj R-squared   = | 0.9960    |                                |           |
| Total        | 9.50597742        | 383       | .024819784   Root MSE        = | .00994    |
|              |                   |           |                                |           |
| ln_fl_nonf~m | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|              |                   |           |                                |           |
| ln_fl_lf     |                   |           |                                |           |
| -.           | .1395258          | .2167149  | 0.64   0.520    -.2867817      | .5658333  |
| L1.          | -.0728475         | .2909974  | -0.25   0.802    -.6452787     | .4995837  |
| L2.          | -.0401378         | .2914261  | -0.14   0.891    -.6134123     | .5331367  |
| L3.          | .4941867          | .3004728  | 1.64   0.101     -.096884      | 1.085257  |
| L4.          | .0243743          | .3032608  | 0.08   0.936    -.5721806      | .6209291  |
| L5.          | -.0515457         | .3007867  | -0.17   0.864    -.6432337     | .5401424  |
| L6.          | .2645611          | .3042172  | 0.87   0.385    -.3338753      | .8629975  |
| L7.          | .3032209          | .3064496  | 0.99   0.323    -.2996069      | .9060486  |
| L8.          | .0945934          | .3058001  | 0.31   0.757    -.5069567      | .6961435  |
| L9.          | -.1097755         | .3559336  | -0.31   0.758    -.8099451     | .590394   |
| L10.         | .1539543          | .375505   | 0.41   0.682    -.5847148      | .8926234  |
| L11.         | -.2776778         | .3787638  | -0.73   0.464    -1.022757     | .4674017  |
| L12.         | -.0112724         | .279864   | -0.04   0.968    -.5618026     | .5392579  |
|              |                   |           |                                |           |
| ln_us_epr    |                   |           |                                |           |
| -.           | .8902343          | .1499136  | 5.94   0.000      .595334      | 1.185135  |
| L1.          | .0725186          | .1976025  | 0.37   0.714    -.3161923      | .4612294  |
| L2.          | .0146862          | .1973291  | 0.07   0.941    -.3734868      | .4028593  |
| L3.          | -.3099001         | .2109421  | -1.47   0.143    -.7248517     | .1050514  |
| L4.          | .137028           | .215249   | 0.64   0.525    -.2863958      | .5604519  |
| L5.          | -.0073661         | .2142714  | -0.03   0.973    -.4288668     | .4141346  |
| L6.          | .0293898          | .2200462  | 0.13   0.894    -.4034709      | .4622504  |
| L7.          | -.1397223         | .2227059  | -0.63   0.531    -.5778149     | .2983702  |
| L8.          | -.0598893         | .2228997  | -0.27   0.788    -.4983631     | .3785844  |
| L9.          | .4823653          | .4060878  | 1.19   0.236    -.3164642      | 1.281195  |
| L10.         | .0335197          | .4684115  | 0.07   0.943     -.887909      | .9549485  |
| L11.         | .4443457          | .4733678  | 0.94   0.349    -.4868327      | 1.375524  |
| L12.         | -.3652099         | .3457533  | -1.06   0.292    -1.045353     | .3149335  |
|              |                   |           |                                |           |
| ln_fl_bp     |                   |           |                                |           |
| -.           | .0174185          | .0043812  | 3.98   0.000        .0088      | .0260369  |
| L1.          | .0097915          | .0047176  | 2.08   0.039     .0005113      | .0190717  |
| L2.          | .005989           | .0048174  | 1.24   0.215    -.0034873      | .0154654  |
| L3.          | .0067099          | .0049382  | 1.36   0.175    -.0030042      | .016424   |
| L4.          | .0015463          | .0049663  | 0.31   0.756    -.0082232      | .0113157  |
| L5.          | .0025978          | .0049914  | 0.52   0.603     -.007221      | .0124166  |
| L6.          | .006001           | .0049798  | 1.21   0.229    -.0037949      | .0157968  |
| L7.          | .0066017          | .0049157  | 1.34   0.180     -.003068      | .0162715  |
| L8.          | -.0015491         | .0049371  | -0.31   0.754     -.011261     | .0081628  |
| L9.          | .0010036          | .0048898  | 0.21   0.838    -.0086153      | .0106225  |
| L10.         | -.0004773         | .0047767  | -0.10   0.920    -.0098737     | .008919   |
| L11.         | -.0083937         | .0046846  | -1.79   0.074     -.017609     | .0008216  |
| L12.         | -.0041455         | .0044702  | -0.93   0.354    -.0129391     | .004648   |
|              |                   |           |                                |           |
| month        |                   |           |                                |           |
| 2            | .0077995          | .0048077  | 1.62   0.106     -.001658      | .017257   |
| 3            | .0052085          | .0041637  | 1.25   0.212    -.0029821      | .0133991  |
| 4            | -.0010198         | .0053356  | -0.19   0.849    -.0115156     | .009476   |
| 5            | -.0012298         | .0047478  | -0.26   0.796    -.0105694     | .0081098  |
| 6            | -.0122415         | .0055844  | -2.19   0.029    -.0232267     | -.0012563 |
| 7            | -.0240128         | .0047031  | -5.11   0.000    -.0332644     | -.0147612 |
| 8            | -.0152756         | .0052483  | -2.91   0.004    -.0255997     | -.0049514 |
| 9            | -.0111308         | .0045365  | -2.45   0.015    -.0200548     | -.0022068 |
| 10           | -.0046899         | .006722   | -0.70   0.486    -.0179129     | .0085332  |
| 11           | .0076979          | .0057763  | 1.33   0.184    -.0036649      | .0190607  |
| 12           | .0151789          | .0059337  | 2.56   0.011     .0035065      | .0268514  |
|              |                   |           |                                |           |
| date         | .0003695          | .000047   | 7.86   0.000      .000277      | .0004619  |
| _cons        | -11.28083         | .391293   | -28.83   0.000    -12.05055    | -10.5111  |
|              |                   |           |                                |           |

## 4d
> Compare your results from a and c and interpret any differences. What do the seasonal and time trend variables contribute?

The model in 4a is accurate to the data it was given but does not make sense and has no practical application because the data is not organized in any way and does not account for the data being time series data.

## 4e
> Estimate two alternative models that contain month indicators and a time trend but that impose a more parsimonious lag structure for the predictor variables. Explain your choices.

### 4e Sampling each quarter

| Source       | SS                | df        | MS      Number of obs   =      | 384       |
| ------------ | ----------------- | --------- | ------------------------------ | --------- |
|              | F(24, 359)      = | 3636.67   |                                |           |
| Model        | 9.46703767        | 24        | .394459903   Prob > F        = | 0.0000    |
| Residual     | .038939751        | 359       | .000108467   R-squared       = | 0.9959    |
|              | Adj R-squared   = | 0.9956    |                                |           |
| Total        | 9.50597742        | 383       | .024819784   Root MSE        = | .01041    |
|              |                   |           |                                |           |
| ln_fl_nonf~m | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|              |                   |           |                                |           |
| ln_fl_lf     |                   |           |                                |           |
| -.           | .2198644          | .118892   | 1.85   0.065    -.0139479      | .4536767  |
| L4.          | .3640379          | .1628088  | 2.24   0.026     .0438591      | .6842168  |
| L8.          | .6241057          | .1697337  | 3.68   0.000     .2903084      | .957903   |
| L12.         | -.3365352         | .1300465  | -2.59   0.010     -.592284     | -.0807864 |
|              |                   |           |                                |           |
| ln_us_epr    |                   |           |                                |           |
| -.           | .8706823          | .0862833  | 10.09   0.000     .7009981     | 1.040367  |
| L4.          | .0186581          | .1180743  | 0.16   0.875     -.213546      | .2508623  |
| L8.          | -.1364675         | .1363531  | -1.00   0.318    -.4046187     | .1316838  |
| L12.         | .4492816          | .1055542  | 4.26   0.000     .2416993      | .6568639  |
|              |                   |           |                                |           |
| ln_fl_bp     |                   |           |                                |           |
| -.           | .0288326          | .0033225  | 8.68   0.000     .0222986      | .0353666  |
| L4.          | .014784           | .0040692  | 3.63   0.000     .0067816      | .0227864  |
| L8.          | .0053046          | .0040599  | 1.31   0.192    -.0026795      | .0132888  |
| L12.         | -.0040886         | .0034865  | -1.17   0.242    -.0109452     | .002768   |
|              |                   |           |                                |           |
| month        |                   |           |                                |           |
| 2            | .003724           | .0027268  | 1.37   0.173    -.0016384      | .0090864  |
| 3            | .003428           | .0030747  | 1.11   0.266    -.0026188      | .0094747  |
| 4            | -.0013812         | .0030302  | -0.46   0.649    -.0073404     | .0045779  |
| 5            | -.0050709         | .003101   | -1.64   0.103    -.0111693     | .0010275  |
| 6            | -.0215379         | .0030889  | -6.97   0.000    -.0276125     | -.0154633 |
| 7            | -.0356678         | .0033321  | -10.70   0.000    -.0422208    | -.0291149 |
| 8            | -.0202856         | .0032905  | -6.16   0.000    -.0267567     | -.0138145 |
| 9            | -.0118143         | .0031977  | -3.69   0.000    -.0181028     | -.0055257 |
| 10           | -.0142884         | .0031129  | -4.59   0.000    -.0204102     | -.0081666 |
| 11           | -.0033333         | .0030634  | -1.09   0.277    -.0093578     | .0026912  |
| 12           | .0070509          | .0028963  | 2.43   0.015      .001355      | .0127468  |
|              |                   |           |                                |           |
| date         | .0004262          | .0000476  | 8.96   0.000     .0003326      | .0005197  |
| _cons        | -10.60852         | .3857432  | -27.50   0.000    -11.36712    | -9.849916 |

### 4e True Quarters

| Source       | SS                | df        | MS      Number of obs   =      | 392       |
| ------------ | ----------------- | --------- | ------------------------------ | --------- |
|              | F(27, 364)      = | 2505.01   |                                |           |
| Model        | 10.2740552        | 27        | .380520563   Prob > F        = | 0.0000    |
| Residual     | .055292923        | 364       | .000151904   R-squared       = | 0.9946    |
|              | Adj R-squared   = | 0.9942    |                                |           |
| Total        | 10.3293481        | 391       | .02641777   Root MSE        =  | .01232    |
|              |                   |           |                                |           |
| ln_fl_nonf~m | Coef.             | Std. Err. | t    P>t     [95% Conf.        | Interval] |
|              |                   |           |                                |           |
| ln_fl_lf     |                   |           |                                |           |
| -.           | .2790757          | .2536131  | 1.10   0.272    -.2196552      | .7778065  |
| L1.          | .2956093          | .3348151  | 0.88   0.378    -.3628055      | .9540241  |
| L2.          | -.2641756         | .3153608  | -0.84   0.403    -.8843334     | .3559822  |
| L3.          | .2832334          | .3167687  | 0.89   0.372     -.339693      | .9061598  |
| L4.          | .3220421          | .2469667  | 1.30   0.193    -.1636186      | .8077029  |
|              |                   |           |                                |           |
| ln_us_epr    |                   |           |                                |           |
| -.           | .869919           | .1763402  | 4.93   0.000     .5231456      | 1.216693  |
| L1.          | -.1508318         | .2303364  | -0.65   0.513    -.6037889     | .3021253  |
| L2.          | .1899043          | .2170821  | 0.87   0.382    -.2369882      | .6167968  |
| L3.          | -.2262386         | .2208671  | -1.02   0.306    -.6605744     | .2080971  |
| L4.          | .3389032          | .1751932  | 1.93   0.054    -.0056147      | .6834212  |
|              |                   |           |                                |           |
| ln_fl_bp     |                   |           |                                |           |
| -.           | .0204443          | .0051347  | 3.98   0.000      .010347      | .0305417  |
| L1.          | .0107528          | .0054657  | 1.97   0.050     4.39e-06      | .0215012  |
| L2.          | .0026867          | .0054899  | 0.49   0.625    -.0081091      | .0134826  |
| L3.          | .0070439          | .0054993  | 1.28   0.201    -.0037706      | .0178583  |
| L4.          | .0071123          | .0051692  | 1.38   0.170     -.003053      | .0172777  |
|              |                   |           |                                |           |
| month        |                   |           |                                |           |
| 2            | .0052225          | .0038186  | 1.37   0.172    -.0022868      | .0127318  |
| 3            | .0086375          | .0041006  | 2.11   0.036     .0005735      | .0167014  |
| 4            | .0012736          | .0046541  | 0.27   0.785    -.0078787      | .0104258  |
| 5            | .0022027          | .0038771  | 0.57   0.570    -.0054216      | .0098269  |
| 6            | -.0193223         | .0040672  | -4.75   0.000    -.0273206     | -.0113241 |
| 7            | -.0362039         | .0038883  | -9.31   0.000    -.0438502     | -.0285575 |
| 8            | -.0245188         | .0043528  | -5.63   0.000    -.0330787     | -.015959  |
| 9            | -.0171602         | .0037189  | -4.61   0.000    -.0244733     | -.0098471 |
| 10           | -.0193132         | .0044175  | -4.37   0.000    -.0280001     | -.0106262 |
| 11           | -.004866          | .0041178  | -1.18   0.238    -.0129637     | .0032317  |
| 12           | .0058531          | .0039007  | 1.50   0.134    -.0018177      | .0135238  |
|              |                   |           |                                |           |
| dateQ        | .0010375          | .0001584  | 6.55   0.000     .0007259      | .001349   |
| _cons        | -10.55687         | .4171884  | -25.30   0.000    -11.37727    | -9.736468 |

### 4e Explanation

​	I was curious to know how sampling lag for a single month from each quarter for a year would compare to generating a new quarter date variable and using that for lag. Unfortunately, I don't think I did it right and I don't know how to get what I want. Instead, what I have for the second chart is quarterly dates but the lagged variables are now only lagged for the first four months of the year.

​	Based on the MSE of each model, the first one is a little bit better but I don't think either is great. 


<div style="page-break-after: always; break-after: page;"></div>

# Appendix A
```
clear
set more off

cd "/Users/guslipkin/Documents/Spring2020/CAP 4763 ~ Time Series/Problem Sets/Problem Set 1"

*2b Load the data
import delimited "Assignment_1_Monthly.txt"

rename lnu02300000 us_epr
rename flnan fl_nonfarm
rename fllfn fl_lf
rename flbppriv fl_bp
rename date datestring

*2c Turn on a log file
log using "Problem Set 1", replace

*2d Generate a monthly date variable (make its display format monthly time, %tm)
gen datec=date(datestring, "YMD")
gen date=mofd(datec)
format date %tm

*2e tsset your data
tsset date

*2f
gen ln_us_epr=log(us_epr)
gen ln_fl_nonfarm=log(fl_nonfarm)
gen ln_fl_lf=log(fl_lf)
gen ln_fl_bp=log(fl_bp)

*3b Estimate the static model relating monthly nonfarm employment in Florida to the other three variables (all in logs) without controlling for seasonal impacts or a time trend.
regress ln_fl_nonfarm ln_fl_lf ln_us_epr ln_fl_bp

*3c Estimate the static model with month indicators and a time trend.
gen month=month(datec)
reg ln_fl_nonfarm ln_fl_lf ln_us_epr ln_fl_bp i.month date

*4a Estimate the distributed lag model relating monthly nonfarm employment to lags 0 to 12 of the three predictor variables without month indicators and a time trend.
regress ln_fl_nonfarm l(0/12).ln_fl_lf l(0/12).ln_us_epr l(0/12).ln_fl_bp

*4b Estimate the model in (a) but add month indicators and a time trend.
regress ln_fl_nonfarm l(0/12).ln_fl_lf l(0/12).ln_us_epr l(0/12).ln_fl_bp i.month date

*4e Estimate two alternative models that contain month indicators and a time trend but that impose a more parsimonious lag structure for the predictor variables. Explain your choices.
regress ln_fl_nonfarm l(0,4,8,12).ln_fl_lf l(0,4,8,12).ln_us_epr l(0,4,8,12).ln_fl_bp i.month date
gen dateQ = qofd(datec)
format dateQ %tq
regress ln_fl_nonfarm l(0/4).ln_fl_lf l(0/4).ln_us_epr l(0/4).ln_fl_bp i.month dateQ

log close
```
# Appendix B

<img src="Problem Set 1.assets/image-20210211193734135.png" alt="image-20210211193734135" style="zoom:67%;" />