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

* drop Tampa and Atlanta 
drop if inlist(city,"Tampa","Atlanta")
*** note: the above is equivalent to: drop if city=="Tampa" | city=="Atlanta" // but inlist() is easier 

tab city,m

* create indicators for host race/sex 
gen host_race_black = host_race=="BLACK"
gen host_race_white = host_race=="WHITE"
gen host_race_hisp = host_race=="HISPANIC"
gen host_race_asian = host_race=="ASIAN"
gen host_race_mult = host_race=="MULTIPLE"  
gen host_race_msg = missing(host_race)

gen host_sex_male = host_sex=="M"
gen host_sex_female = host_sex=="F"
gen host_sex_msg = missing(host_sex)

* create indicators for guest race/sex
gen guest_race_black = guest_race=="black"
gen guest_race_white = guest_race=="white" 

gen guest_sex_male = guest_sex=="male" 
gen guest_sex_female = guest_sex=="female"

*---------------------------------------------------------
* CREATE SUMMARY STATISTICS TABLE (TABLE 1)
*---------------------------------------------------------

* host demographic characteristics
local host_demo_char host_race_white host_race_black host_race_hisp host_race_asian host_race_mult host_race_msg host_sex_female host_sex_male host_sex_msg 

* listing characteristics
local listing_char price bedrooms bathrooms number_of_reviews

* additional host characteristics
local host_char multiple_listings any_black_guest

* location characteristics
local location_char tract_listings black_proportion

tabstat `host_demo_char' `listing_char' `host_char' `location_char', stats(mean sd min p25 p75 max N) c(stats) varwidth(20)

foreach var in `host_demo_char' `listing_char' `host_char' `location_char' {
	di "-----------------------------"
	di "Two-Sample t-test - `var':"
	* conduct t-test // qui is short for quietly, which suppresses output
	qui ttest `var', by(guest_race_white)
	* display key values 
	di "Raw Difference: `r(mu_diff)'"
	di "t-stat: `r(t)'"
	di "p-value: `r(p)'"
	* note: we can also test for a two-sample difference in means using regression: 
	di "Regression Difference in Means:"
    reg `var' guest_race_black
	di "-----------------------------"
}

* COMMIT 

*---------------------------------------------------------
* CREATE MAIN RESULTS TABLE (TABLE 2)
*---------------------------------------------------------

* note: dv is missing for 157 obs, driving discrepancy in no. of obs between sumstats and regression tables 

* create log price variable
gen log_price = ln(price)

*** col. 1 - no controls
reg yes guest_race_black, vce(cluster name_by_city)

***** calc. depvar mean for white guests
qui sum yes if e(sample) & guest_race_white==1 
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

*** calc. percentage effect 
local percentage_effect = string(round(((_b[guest_race_black]/`r(mean)')*100),0.01), "%6.2f")
di "Percentage Effect: " `percentage_effect' "%"

*** col. 2 - controlling for host race and gender 
reg yes guest_race_black host_race_black host_sex_male, vce(cluster name_by_city)

***** calc. depvar mean for white guests 
qui sum yes if e(sample) & guest_race_white==1 
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

*** calc. percentage effect 
local percentage_effect = string(round(((_b[guest_race_black]/`r(mean)')*100),0.01), "%6.2f")
di "Percentage Effect: " `percentage_effect' "%"

*** col. 3 - controlling for other characteristics 
reg yes guest_race_black host_race_black host_sex_male multiple_listings shared_property ten_reviews log_price, vce(cluster name_by_city)

***** calc. depvar mean for white guests 
qui sum yes if e(sample) & guest_race_white==1 
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

*** calc. percentage effect 
local percentage_effect = string(round(((_b[guest_race_black]/`r(mean)')*100),0.01), "%6.2f")
di "Percentage Effect: " `percentage_effect' "%"

*---------------------------------------------------------
* TABLE 2 - EXTENSIONS AND TEACHING NOTES
*---------------------------------------------------------

* why are we dropping obs in col. 3?
mdesc yes guest_race_black host_race_black host_sex_male multiple_listings shared_property ten_reviews log_price

* teaching note: you should set the sample for you main regression and then report summary statistics for that sample. You should keep the sample the same as you change specifications 

*** to do this, run col. 3 spec 
reg yes guest_race_black host_race_black host_sex_male multiple_listings shared_property ten_reviews log_price, vce(cluster name_by_city)
gen sample = e(sample)

*** now produce sumstats/recreate table 

* teaching note: standard errors 

*** we know the LPM violates homoskedasticity, must use heteroskedasticity-robust se's at a minimum 

reg yes guest_race_black

reg yes guest_race_black, r
*** in this case there isn't much difference in using the robust standard errors 

*** the authors cluster se's at the level of name_by_city. Essentially this allows for the errors to be correlated within a name by city group (e.g., Tanisha in LA). The key assumption now is that we are randomly sampling clusters. For inference, the number of clusters, not the number of observations, is what matters

reg yes guest_race_black, vce(cluster name_by_city)

* teaching note: fixed effects 

*** how do implement fixed effects in Stata?
*** suppose we want to look within cities 

* make a numeric city variable
encode city, gen(city_num)

fre city_num 

*** insert the fixed effects directly - okay if there aren't very many OR if we care about the coefficients 
*** select the "base" city (Dallas) - o.w. Stata will select the base city for you 
fvset base 2 city_num 
reg yes guest_race_black i.city_num, vce(cluster name_by_city)

*** absorb - if there are many fixed effects or if you don't care about the coefficients 
reghdfe yes guest_race_black, absorb(city_num) vce(cluster name_by_city)

* teaching note: lpm vs. logit/probit 
*** note: the lpm is approximating the average partial effect

* LPM
reg yes guest_race_black, vce(cluster name_by_city)
local ape_lpm = round(_b[guest_race_black],0.001)

* Logistic Regression
logit yes guest_race_black, vce(cluster name_by_city)

* Take average marginal effects
margins, dydx(*) 
local ape_logit = round(r(b)[1,1],0.001)
	
* Probit Regression
probit yes guest_race_black, cluster(name_by_city)

* Take average marginal effects
margins, dydx(*) 
local ape_probit = round(r(b)[1,1],0.001)

* comparison of results
di "Avg. Partial Effect, LPM: " `ape_lpm'
di "Avg. Partial Effect, Logit: " `ape_logit'
di "Avg. Partial Effect, Probit: " `ape_probit'

*-------------------------------------
* FIGURE 2 - RESPONSE RATES BY GUEST RACE 
*-------------------------------------

tab host_response if missing(graph_bins),m 

#delimit ;
graph bar (sum) guest_race_black guest_race_white,
over(graph_bins, gap(200))
legend(label(1 "Guest is African-American") label(2 "Guest is White")) ylabel(0(300)1200, angle(0)) legend(symxsize(*0.5) symysize(*0.5) row(1) pos(12) ring(0));
graph export "./output/figure2.svg", width(1600) fontface("Times New Roman") replace;
#delimit cr

*-------------------------------------
* TABLE 3 - INTERACTIONS
*-------------------------------------

* create interaction
gen guest_host_black = guest_race_black*host_race_black
label var guest_host_black "Guest is African American * Host is African American"

*** col. 1 - all hosts 
reg yes guest_race_black host_race_black guest_host_black, vce(cluster name_by_city)

***** calc. depvar mean for white guests 
qui sum yes if e(sample) & guest_race_white==1
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

***** combined treatment effect for Black hosts 
lincom guest_race_black + guest_host_black

*** col. 2 - male hosts 
reg yes guest_race_black host_race_black guest_host_black if host_sex_male==1, vce(cluster name_by_city)

***** calc. depvar mean for white guests 
qui sum yes if e(sample) & guest_race_white==1
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

***** combined treatment effect for Black hosts 
lincom guest_race_black + guest_host_black

*** col. 3 - female hosts 
reg yes guest_race_black host_race_black guest_host_black if host_sex_female==1, vce(cluster name_by_city)

***** calc. depvar mean for white guests 
qui sum yes if e(sample) & guest_race_white==1
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

***** combined treatment effect for Black hosts 
lincom guest_race_black + guest_host_black

*** col. 4 - other hosts 
reg yes guest_race_black host_race_black guest_host_black if host_sex_msg==1, vce(cluster name_by_city)

***** calc. depvar mean for white guests 
qui sum yes if e(sample) & guest_race_white==1
local dv_mean = string(round(`r(mean)',0.001), "%6.3f")
di "Mean Response Rate (White Guests): " `dv_mean'

***** combined treatment effect for Black hosts 
lincom guest_race_black + guest_host_black

*-------------------------------------
* TABLE 4 - RESPONSE RATES BY RACE AND GENDER OF HOSTS AND GUESTS
*-------------------------------------

* note: have to account for missing responses to replicate results of paper 
qui gen yes_temp = yes
qui replace yes_temp = 0 if missing(yes)

foreach host_sex in host_sex_male host_sex_female {
	foreach host_race in host_race_white host_race_black {
		foreach guest_sex in guest_sex_male guest_sex_female {
			foreach guest_race in guest_race_white guest_race_black {
				di "-----------------------------"
				di "Host: `host_sex' `host_race'"
				di "Guest: `guest_sex' `guest_race'"
				* calculate positive response rate
				qui proportion yes_temp if `host_sex'==1 & `host_race'==1 & `guest_sex'==1 & `guest_race'==1
				di "Share Accepted: " r(table)[1,2]
				di "-----------------------------"
			}
		}
	}
}
drop yes_temp 

log close
clear all
