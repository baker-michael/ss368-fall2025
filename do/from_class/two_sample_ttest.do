/*
Author: Mike Baker         						            
Date: 18 Feb 2025 / update: 26 Sep 2025

Purpose: demonstrate two-sample t-test 

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP
* cd "<insert your directory here>"

qui cap log close two_sample_ttest
log using "./log/two_sample_ttest.log", text replace name(two_sample_ttest)

*--------------------------------------------------
* T-TEST - DIFFERENCE IN SAMPLE MEANS
*--------------------------------------------------
* ref: p. 409-410 in Casella and Berger

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/SMOKE.DTA", clear 

*-----------------------------
* NOT ASSUMING EQUAL VARIANCE
*-----------------------------

* MANUAL CALCULATIONS 
gen smc = educ>12 
gen hs = educ==12 

drop if !smc & !hs 

gen smoke = cigs>0

* calculate t-statistic 
qui sum smoke if smc 
local mn_smc = `r(mean)'
local N_smc = `r(N)'
local var_smc = `r(Var)'
qui sum smoke if hs 
local mn_hs = `r(mean)'
local N_hs = `r(N)'
local var_hs = `r(Var)'

* note1: if you calc. the variance of the indicator variable as mu(1-mu), there will be small discrepancies due to the rounding error. The method below is more precise because it's not using the rounded mean to calc. the variance
* note2: we are conducting the test without assuming equal variances. This requires using Satterthwaite's approximation for degrees of freedom 

*** calc. t-stat
local t = (`mn_smc' - `mn_hs')/sqrt((`var_smc'/`N_smc') + (`var_hs'/`N_hs'))

*** calc. Satterthwaite's approximation for degrees of freedom 
local satter_df = ((`var_smc'/`N_smc') + (`var_hs'/`N_hs'))^2/(((`var_smc'/`N_smc')^2/(`N_smc'-1)) + ((`var_hs'/`N_hs')^2/(`N_hs'-1)))
di "`satter_df'"

*** calc. the p-value 
local p = 2*(1-t(`satter_df',abs(`t')))

di "Two-Sample t-test: Unequal Variances"
di "t-stat: `t'"
di "Satterthwaite's approx. df: `satter_df'"
di "p-value: `p'"

* USING STATA'S BUILT-IN FUNCTION: ttest 
ttest smoke, by(smc) unequal reverse

*-----------------------------
* ASSUMING EQUAL VARIANCE
*-----------------------------
* alternatively, we can use regression to test for mean differences across groups. However, note that regression is implicitly assuming equivalent variances across groups.
* the two tests are asymptotically equivalent, but will result in minor differences in small samples  

* MANUAL CALCULATIONS 
*** using the pooled variance estimator 
*** calc. t-stat
local t_reg = (`mn_smc' - `mn_hs')/sqrt(((1/(`N_smc'+`N_hs'-2))*(((`N_smc'-1)*`var_smc') + ((`N_hs'-1)*`var_hs')))*((1/`N_smc')+ (1/`N_hs')))
di "`t_reg'"

*** calc. df 
local df = `N_smc' + `N_hs' - 2

*** calc. p-value 
local p_reg = 2*(1-t(`df',abs(`t_reg')))

di "Two-Sample t-test: Equal Variances (Pooled Variance Estimator)"
di "t-stat: `t_reg'"
di "df: `df'"
di "p-value: `p_reg'"

* REGRESSION ESTIMATE 
reg smoke smc 

* USING STATA'S BUILT-IN FUNCTION: ttest 

* t-test assuming equal variances
ttest smoke, by(smc) reverse

log close two_sample_ttest
clear all 
