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

qui cap log close _all 
log using "./log/<lastname>_<firstname>_mlr-lab.log", text replace 

* INSTALL REGHDFE
*** install ftools (remove program if it existed previously)
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

*** install reghdfe 6.x
cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

*---------------------------------------------------------
* IMPORT & PREP DATA 
*---------------------------------------------------------

use "./raw_dta/airbnb_mlr_lab.dta", clear



*---------------------------------------------------------
* CREATE SUMMARY STATISTICS TABLE (TABLE 1)
*---------------------------------------------------------



* COMMIT 

*---------------------------------------------------------
* CREATE MAIN RESULTS TABLE (TABLE 2)
*---------------------------------------------------------

* COMMIT 


*-------------------------------------
* FIGURE 2 - RESPONSE RATES BY GUEST RACE 
*-------------------------------------

* COMMIT

*-------------------------------------
* TABLE 3 - INTERACTIONS
*-------------------------------------

* COMMIT

*-------------------------------------
* TABLE 4 - RESPONSE RATES BY RACE AND GENDER OF HOSTS AND GUESTS
*-------------------------------------

* COMMIT

log close
clear all
