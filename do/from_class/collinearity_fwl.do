/*
Author: Mike Baker         						            
Date: 01 Feb 2025 / update: 23 Sep 2025

Purpose: demonstrate (1) how Stata handles perfect collinearity and (2) the Frisch-Waugh-Lovell Theorem in multiple linear regression

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP
* cd "<insert your directory here>"

qui cap log close collinearity_fwl
log using "./log/collinearity_fwl.log", text replace name(collinearity_fwl)

*----------------------------------
* PERFECT COLLINEARITY
*----------------------------------
* goal: see how Stata deals with instances of perfect collinearity 

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/WAGE1.DTA", clear

* create a male indicator, a female indicator is already in the data
gen male = !female 
/* equivalent code 
gen male = female!=1

OR 

gen male = 0 
replace male = 1 if female==0 
*/


* making updates to this file 

reg lwage educ female

* if we try to add both male and female to the regression, Stata will drop one of them due to perfect collinearity
reg lwage educ female male

* create a linear transformation of experience 
gen exper2 = 10*exper + 500

reg lwage exper

* when we include experience and a linear transformation of experience, one is dropped due to perfect collinearity
reg lwage exper exper2

* create a quadratic experience term 
gen exper_sq = exper^2

* the quadratic transform does not have the issue of perfect collinearity 
reg lwage exper exper_sq

* code note: rather than generate a new variable for experience squared, we could just type: 
reg lwage c.exper##c.exper

/* addtl code notes 
- the ## tells Stata to include experience and experience squared. Alternatively, we could type: 
reg lwage exper c.exper#c.exper

- the c. notation tells Stata that exper is a continuous variable. if instead you are working with indicator variables, you use the notation i. For example, we haven't worked with indicators yet, but I include an interaction between experience and sex by estimating the following
reg lwage exper i.female#c.exper
*/

* bottom line: if Stata is dropping variables for collinearity, you should pause and consider why that is. Select the variables you want included and properly specify the model. 

*----------------------------------
* FWL DEMO
*----------------------------------
* goal: see the frisch-waugh-lovell theorem in action

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/WAGE1.DTA", clear

* suppose we are interested in understanding the effect of education on the wage, holding experience and job tenure constant 

reg lwage educ exper tenure
* capture degrees of freedom (dof) to correclty calculate standard errors below 
*** dof = N (no. of obs) - k (no. of regressors) - 1 (accounts for intercept parameter)
local dof = `e(N)' - 3 - 1 

* the FWL theorem says we can obtain the estimate of the coefficient on education in a three-step process

*** (1) regress educ on the other controls and save the residuals 
reg educ exper tenure
predict educ_r, resid 

*** (2) regress log(wage) on the other controls and save the residuals 
reg lwage exper tenure
predict lwage_r, resid 

*** (3) regress the residualized log(wage) on the residuals from the first step regression 
*** note: to get the correct se's we have to use the degrees of freedom from the initial/long regression (N-k-1)
reg lwage_r educ_r, dof(`dof')

* note: we used homoskedastic se's throughout as it makes the se calculations easier.

log close collinearity_fwl 
clear all 
