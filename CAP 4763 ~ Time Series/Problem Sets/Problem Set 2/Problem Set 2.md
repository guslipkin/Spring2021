## Part A

> 1. Writethemodel $y_t =α+ δt+ ρy_{t-1} + βx_{t-1} + r$ in first differences.

- $\Delta y_t=\delta+\rho\Delta y_{t-1}+\beta\Delta x_{t-1}+\Delta r_t$

> 2. Suppose after first differencing a model is $∆y_t = δ-φ−2φt+ρ∆y_{t-1}+β∆x_{t-1}+∆r_t$. What was it before the first difference was taken? (Hint: both $t$ and $t^2$ are in it.)

- $y_t=\delta t+\varphi t^2+\varphi t-\varphi +\rho y_{t-1}+\beta x_{t-1}+r_t$

> 3. Suppose you are originally interested in the model $y_t=\alpha+\delta t+\rho y_{t-1}+\beta x_{t-1}+r_t$, where $r_t=\gamma r_{t-1} + \varepsilon_t$ and $\varepsilon_t$ is an independent random disturbance. Write the dynamically complete model in first differences. Hint: first substitute to make the model dynamically complete, and then take the first difference.

- $y_t=\alpha+\delta t+\rho y_{t-1}+\beta x_{t-1} + \gamma r_{t-1} + \varepsilon_t$
- $\Delta y_t=\delta+\rho\Delta y_{t-1}+\beta\Delta x_{t-1}+\gamma\Delta r_{t-1} + \Delta\varepsilon_t$



## Part B

3. Evaluate Autocorrelation and Weak Dependence
   1. Obtain the correlation of each variable with its one period lag.

      - | | corr ln_us_epr l1.ln_us_epr |
        |--|----------------------------- |
        | | (obs=875)                     |
        | | L.                            |
        | | ln_us_~r ln_us_~r             |
        | ln_us_epr |                    |
        | -. |   1.0000                  |
        | L1.   | 0.9758   1.0000        |
     
        | . corr ln_fl_nonfarm l1.ln_fl_nonfarm |
     | ------------------------------------- |
        | (obs=983)                             |
     | L.                                    |
        | ln_fl_~m ln_fl_~m                     |
        | ln_fl_nonf~m                          |
        | -.    1.0000                          |
        | L1.    0.9999   1.0000                |
        
        | . corr ln_fl_lf l1.ln_fl_lf |
        | --------------------------- |
        | (obs=539)                   |
        | L.                          |
        | ln_fl_lf ln_fl_lf           |
        | ln_fl_lf                    |
        | -.    1.0000                |
        | L1.    0.9997   1.0000      |
   
      | corr ln_fl_bp l1.ln_fl_bp |
      | ------------------------- |
      | (obs=395)                 |
      | L.                        |
      | ln_fl_bp ln_fl_bp         |
      | ln_fl_bp                  |
      | -.    1.0000              |
      | L1.    0.9470   1.0000    |
   
   2. Obtain the autocorrelogram and partial autocorrelagram for each variable.
   
   3. Conduct the Dickey-Fuller unit root rest for each variable.
   
   4. Interpret these results.

if fuller high, can't reject

