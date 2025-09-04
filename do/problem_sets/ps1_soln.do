* Author: Mike Baker
* Date: 25 Aug 2025

* purpose: perform exercises from problem set 1 

*-------------------------------------
* SET DIRECTORIES 
*-------------------------------------

* set your directory 
cd "C:\Users\michael.baker\Documents\ss368\ss368-pages\problem_sets\ps1"

/* create folders for do, log, output, raw_dta, dta - you only do this the first time you start a project
mkdir do 
mkdir log
mkdir output 
*/

*-------------------------------------
* SET UP LOG 
*-------------------------------------

log using "log/ps1_solution.log", text

*-------------------------------------
* IMPORT DATA & SUMMARY STATISTICS
*-------------------------------------

* IMPORT DATA 
use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/401K.DTA", clear

describe 

* Situation: we want to estimate the effect of employer match rates (mrate) on employee 401k particpation (prate)

* CONFIRM NO MISSING DATA 

*** you must install using: ssc install mdesc 
*** wasn't necessary here because there were no missing values, but always a good check
mdesc 
*** no missing values 

* SUMMARY STATISTICS 

* Q: Calculate the mean and median for mrate and prate 
sum mrate, d 
di "Mean: 0.73 / Median: 0.46"
sum prate, d
di "Mean: 87.36 / Median: 95.7"

* Q: Create a histogram for mrate and prate. Do not worry about formatting - use Stata's default selections. After creating the histogram, save using: graph export "<your output file path>.svg", width(1600) fontface("Times New Roman") replace

histogram mrate 
graph export "output/histogram_mrate.svg", width(1600) fontface("Times New Roman") replace

histogram prate 
graph export "output/histogram_prate.svg", width(1600) fontface("Times New Roman") replace

* Q: Create a scatterplot with prate on the vertical axis and mrate on the horitzontal axis. Do not worry about formatting - use Stata's default selections. After creating the graph, save using: graph export "<your output file path>.svg", width(1600) fontface("Times New Roman") replace

scatter prate mrate
graph export "output/scatter_prate_mrate.svg", width(1600) fontface("Times New Roman") replace

*-------------------------------------
* CALCULATE OLS ESTIMATES MANUALLY
*-------------------------------------

* Regression model: participation rate = intercept + beta_hat * match rate + u

* Q: Calculate the coefficient estimates for the intercept and beta_hat manually using the formulas derived in class

*** calc. cov(prate, mrate)
corr prate mrate, cov
*** store as a local macro to use later 
local covariance = `r(cov_12)'

*** calc. mean and variance of match rate  
sum mrate,d
local mean_mrate = `r(mean)'
local variance_mrate = `r(Var)'

*** calc. mean of participation rate 
qui sum prate
local mean_prate = `r(mean)'

* manually calculate beta_hat and intercept

*** beta_hat = cov(mrate, prate)/var(mrate)
local beta_hat = `covariance'/`variance_mrate'

*** formatting for display purposes 
local f_beta_hat = string(round(`covariance'/`variance_mrate', .001),"%9.3fc")
di "Slope Coefficient (Beta Hat): `f_beta_hat'"

*** intercept = (mn of prate) - `beta_hat'*(mean of mrate)
local intercept = `mean_prate'-`beta_hat'*`mean_mrate'

*** formatting for display purposes 
local f_intercept = string(round(`mean_prate'-`beta_hat'*`mean_mrate', .001),"%9.3fc")
di "Intercept: `f_intercept'"

* Q: Calculate the residuals/prediction errors (u_hat). What is the sum of the residuals? 
gen u_hat = prate - `intercept' - `beta_hat'*mrate 

egen tot_u_hat = total(u_hat)

di tot_u_hat 
drop tot_u_hat 

* A: The residuals sum to zero. This is true by definition as long as we include an intercept.

* Q: Calculate the covariance between the residuals and mrate. Does this mean that the zero conditional mean holds? 
corr mrate u_hat, cov 

* A: The covariances is approximately zero. This is mechanical. OLS residuals will always be uncorrelated with the right-hand side variables. This does not mean the zero conditional mean holds because the zero conditional mean refers to the relationship between u and x, not u_hat and x.

* Q: Calculate the standard error of the slope coefficient (beta_hat). 

*** get number of observations 
qui count 
local N = `r(N)'

*** calc. sum of squared residuals (SSR)
egen ssr = total(u_hat^2)

*** est. the population variance using the residuals  
local pop_variance_est = (1/(`N'-2))*ssr

*** get the standard deviation of indep. var.
qui sum mrate
local sd_mrate = `r(sd)'

local se_beta_hat = sqrt(1/(`N'-1))*sqrt(`pop_variance_est')/`sd_mrate'
local f_se_beta_hat = string(round(`se_beta_hat', .001),"%9.3fc")
di "Standard Error: `f_se_beta_hat'"

* Q: Explain how the standard error relates to the sampling distribution of beta_hat.

* A: The sampling variance, and therefore the standard error, is a measure of the dispersion of beta_hat across repeated samples from the population. Given a single estimate of beta, we use the standard error to quantify the remaining uncertainty about the true value of beta in the population.

* Q: Calculate the R-squared 

*** calculate the sum of squares total (SST)
egen sst = total((prate - `mean_prate')^2)

*** calc. R-squared: 1 - (ssr/sst)
local r2 = 1-(ssr/sst)
local f_r2 = string(round(`r2', .001),"%9.3fc")

di "R-squared: `f_r2'"

*** summarizing our manual calculations
di "Summary of Estimates"
di "Intercept: `f_intercept'"
di "Slope Coefficient (Beta Hat): `f_beta_hat'"
di "Std. Error of Beta Hat: `f_se_beta_hat'"
di "R-squared: `f_r2'"

*-------------------------------------
* OLS REGRESSION & INTERPRETATION
*-------------------------------------
* now use Stata's regress command to perform an OLS regression 

reg prate mrate

* Q: Interpret the intercept in this model. 

* A: Says that the participate rate in cases where the match rate is zero is predicted to be ~83%

* Q: Interpret the coefficient estimate on mrate 

* A: Says that increasing the match rate by 1 is predicted to increase the participation rate by 5.9 p.p.

* Q: What is R-squared measuring? How does it relate to the whether the regression estimates have a causal interpretation? 

* A: R-squared measures how much of the variation in participation rates is explained by match rates. It is a purely statistical measure and does not bear on whether the estimate on mrate on a causal interpretation. Prediction and causal estimation are fundamentally different problems. A causal interpretation is based on whether the zero conditional mean assumption holds.

* Q: now add ltotemp as a control on the right-hand side. Interpret the coefficient estimate on ltotemp. 
reg prate mrate

* A: The estimate implies that a 1-percent increase in the number of employees is associated with a participation rate that is 2.3 p.p. lower 

* scatter plot of the data and the line of best fit
twoway scatter prate mrate || lfit prate mrate
graph export "output/regression_plot.svg", width(1600) fontface("Times New Roman") replace

log close 
clear all 