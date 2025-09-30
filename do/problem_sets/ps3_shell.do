/*
Author:        						            
Date: 

Purpose: 

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP
cd "<insert your directory>"

qui cap log close ps3
log using "./log/ps3.log", text replace name(ps3)

*----------------------------------
* NO. 3 ACS DATA
*----------------------------------

* INSTRUCTIONS: Import your ACS data here (store in the raw_dta folder)
use "./raw_dta/<your acs data>.dta", clear 

mdesc 

* INSTRUCTIONS: Drop all individuals: (1) who are younger than 18 or older than 64; or (2) who are active duty servicemembers or training for the National Guard or Reserves (see vetstatd). 



*** Q: How many observations remain? 



*** Q: How many individuals does this sample represent in the population? 



* INSTRUCTIONS: Create an indicator equal to one if an individual is a veteran and zero otherwise. 



*** Q: What share of the population are veterans? 



*** Q: What share are post-9/11 veterans? 



*** Q: What share of veterans served in the post-9/11 period? 



*** Q: What is the average income for post-9/11 veterans in 2023?



*** Q: What is the average income for non-veterans in 2023? 



* COMMIT

* INSTRUCTIONS: For the remainder of the analysis, exclude veterans who did not serve in the post-9/11 period



* INSTRUCTIONS: Estimate the short model by OLS (see problem set, 3.iv), using heteroskedasticity-robust standard errors 



*** Q: Describe how your estimates of beta_0 and beta_1 relate to the means calculated previously.



*** Q: Interpret the coefficient estimate of beta_1 in context 



*** Q: Describe the direction of bias in beta_1 if male, an indicator equal to one for men and zero from women, is an omitted variable in the short regression. Is the coefficient on veteran status upward or downward biased?  



* INSTRUCTIONS: Estimate the long model by OLS (see problem set, 3.vi)



*** Q: Interpret the coefficient estimate on beta_2_long in context. 



*** Q: Consider the change in your estimate of the effect of veteran status on income from the short model to the long model. What does this suggest about the plausibility of the zero conditional mean in the short model?



*** INSTRUCTIONS: Manually calculate the omitted variable bias and show that it is equal to the difference in beta_1 between the short and long regressions. 



* INSTRUCTIONS: estimate a model where the relationship between veteran status and income varies by sex. 



*** Q: Is thereevidence that the effect of veteran status varies by sex?



* COMMIT

*----------------------------------
* NO. 4
*----------------------------------

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/CEOSAL2.DTA", clear 

* INSTRUCTIONS: estimate a model relating annual salary to firm sales and market value. Make the model of the constant elasticity variety (log-log) for both independent variables.



*** Q: Interpret the coefficient on log(sales). 



* INSTRUCTIONS: Add profits to the model from part (a).



*** Q: Why can this variable not be included in logarithmic form? 



*** Q: Would you say that these firm performance variables explain most of the variation in CEO salaries? 



*** Q: Interpret the coefficient on $profits$.



* INSTRUCTIONS: Add the variable ceoten to the model in part (c).



*** Q: What is the estimated percentage return for another year of CEO tenure, holding other factors fixed? 



* COMMIT

*----------------------------------
* NO. 5
*----------------------------------

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/gpa2.dta", clear 

* Q5.a/b. - Show that the FWL theorem holds using the model provided (see problem set, no. 5). Show that if you adjust for the degrees of freedom in the original model, the standard errors are the same as well. Assume constant variance (homoskedasticity). 



*** Q: Briefly explain how the partialling out interpretation of OLS estimates in multiple linear regression in light of this result. 



* COMMIT

*----------------------------------
* NO. 6 
*----------------------------------

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/BWGHT.DTA", clear 

* INSTRUCTIONS: Run a simple regression of bwght on cigs to obtain the slope coefficient



* INSTRUCTIONS: Run the long regression of bwght on cigs and faminc to obtain the slope coefficients



* INSTRUCTIONS: Run the simple regression of faminc on cigs to obtain the slope coefficient



* INSTRUCTIONS: Calculate the OVB and show that it is equal to the difference between the coefficients on cigs from the short and long regression 



*** Q: Explain how the sign of the omitted variable bias is determined by the relationship between bwght, cigs, and faminc and how that relates to the regression coefficients in part (d). 



* COMMIT

*----------------------------------
* NO. 7
*----------------------------------

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/LAWSCH85.DTA", clear 

* INSTRUCTIONS: Regress log(salary) on LSAT, GPA, log(libvol), log(cost), and rank. 



*** Q: For which of the regressors can you reject the null hypothesis of no effect? 



* INSTRUCTIONS: Test whether the characteristics of the incoming class, LSAT and GPA are jointly significant by conducting an F-test. 



*** Q: Should clsize and faculty be added to the regression? Conduct a test to support your argument. 



* COMMIT

log close ps3 
clear all
