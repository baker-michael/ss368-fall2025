/*
Author: Mike Baker         						            
Date: 01 Feb 2025 / update: 06 Oct 2025

Purpose: demonstrate omitted variable bias 

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP
* cd "<insert your directory here>"

qui cap log close ovb
log using "./log/ovb.log", text replace name(ovb)

*-------------------------------
* OVB DEMO
*-------------------------------

use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/WAGE1.DTA", clear

* calculate the magnitude of OVB from excluding experience 

*** long regression 
reg lwage educ exper, r 
local beta1_long = _b[educ]
local beta2_long = _b[exper]

*** auxiliary regression - experience on education
reg exper educ, r 
local alpha1 = _b[educ]

* OVB 
local ovb = `beta2_long'*`alpha1'
local beta1_short_pred = `beta1_long' + `ovb'

di "OVB: `ovb'"
di "Predicted beta1_short: `beta1_short_pred'"

*** short regression with education only 
reg lwage educ, r

log close ovb 
clear all 
