/*
Author: Mike Baker         						            
Date: 23 Oct 2025

Purpose: demonstrate measurement error in dependent and independent variables

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP
* cd "<insert your directory here>"

qui cap log close measurement_error
log using "./log/measurement_error.log", text replace name(measurement_error)

*---------------------------------------------------------
* DEMO 
*---------------------------------------------------------

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/WAGE1.DTA", clear


*--------------------------------
* CONSTRUCT MEASUREMENT ERROR
*--------------------------------

* set seed for reproducibility
set seed 983

* create measurement error in the dependent variable that is uncorrelated with the independent variable (educ)
*-- do this by regression because regression residuals are orthogonal to included regressors by construction
*-- create three errors to see how standard error changes as the error variances gets larger 
forvalues x=2/4 {
    gen w_e_`x' = rnormal(0,`x')
    qui reg w_e_`x' educ
    predict wage_error_`x', resid
    drop w_e_`x'
    * wage_error is now orthogonal to educ

    sum wage_error_`x', d 

    * confirm orthogonality
    corr wage_error_`x' educ 

    gen wage_me_`x' = wage + wage_error_`x'
}

* measurement error in independent variable
*-- classical assumption: error is independent of the true value of education 
gen educ_e = ceil(rnormal(0,2))
reg educ_e educ
predict educ_error, resid
sum educ_error, d

* confirm orthogonality
corr educ_error educ

gen educ_me = educ + educ_error
replace educ_me = 0 if educ_me < 0
replace educ_me = 18 if educ_me > 18

*--------------------------------
* ESTIMATE REGRESSIONS
*--------------------------------

* regression without measurement error 
reg wage educ

* regression with measurement error in dependent variable
*-- we expect no change to coefficient, but larger SEs. We also expect the standard errors to increase by more when the error variance is larger
reg wage_me_2 educ
reg wage_me_3 educ
reg wage_me_4 educ

* measurement error in independent variable
*-- we expect the coefficient estimate to be attenuated (biased toward zero)
reg wage educ_me

log close measurement_error
clear all
