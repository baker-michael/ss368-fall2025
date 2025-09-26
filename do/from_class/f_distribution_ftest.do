/*
Author: Mike Baker         						            
Date: 01 Feb 2025 / update: 26 Sep 2025

Purpose: plot pdf and cdf for F distribution; example of an F test 

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP
* cd "<insert your directory here>"

qui cap log close f_distribution_ftest
log using "./log/f_distribution_ftest.log", text replace name(f_distribution_ftest)

*----------------------------------
* F-DISTRIBUTION
*----------------------------------
/*
F() is the cdf 
Fden() is the pdf 

*/

clear
set obs 1000
generate x = (_n - 500)/50

* generate F- density 
gen Fcdf = F(5,500,x)
gen F = Fden(5,500,x)

drop if !inrange(x,0,5)

* CDF

 * graph setup
local xmax = 5
local xmin = 0
local xskip = 1
local xmskip = `xskip'/2

qui mylabels `xmin'(`xskip')`xmax', myscale(@) local(xlabels) 
qui mylabels `xmin'(`xmskip')`xmax', myscale(@) local(xmlabels) 

local ymax = 1
local ymin = 0
local yskip = 0.1
local ymskip = `yskip'/2
qui mylabels `ymin'(`yskip')`ymax', myscale(@) local(ylabels)
qui mylabels `ymin'(`ymskip')`ymax', myscale(@) local(ymlabels) 
		
#delimit ;
twoway 
line Fcdf x, lcolor(blue) ||,
xtitle("")
xlabels(`xlabels')
xmtick(`xmlabels')
ytitle("P(F {&le} f)")
ylabels(`ylabels',angle(0) glcolor(dimgray) glpattern(dash))
ymtick(`ymlabels')
legend(off) 
graphregion(color(white));
graph export "./output/F_cdf.svg", width(1600) fontface("Times New Roman") replace;
#delimit cr 

* PDF

* graph setup
local ymax = 0.8
local ymin = 0
local yskip = 0.1
local ymskip = `yskip'/2
qui mylabels `ymin'(`yskip')`ymax', myscale(@) local(ylabels)
qui mylabels `ymin'(`ymskip')`ymax', myscale(@) local(ymlabels) 
		
#delimit ;
twoway 
line F x, lcolor(blue) ||,
xtitle("")
xlabels(`xlabels')
xmtick(`xmlabels')
ytitle("Density")
ylabels(`ylabels',angle(0) glcolor(dimgray) glpattern(dash))
ymtick(`ymlabels')
legend(off) 
graphregion(color(white));
graph export "./output/F_pdf.svg", width(1600) fontface("Times New Roman") replace;
#delimit cr 

*----------------------------------
* F-TEST MULTIPLE LINEAR HYPOTHESES
*----------------------------------

* EXAMPLE 1
use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/MLB1.DTA", clear 

*** MANUAL CALCULATION
* unrestricted model 
reg lsalary years gamesyr bavg hrunsyr rbisyr 

local ssr_ur = `e(rss)'
local df_ur = `e(df_r)'

* restricted model 
reg lsalary years gamesyr
local ssr_r = `e(rss)'
local df_r = `e(df_r)'

local q = `df_r'-`df_ur'

local f = ((`ssr_r' - `ssr_ur')/`q')/(`ssr_ur'/`df_ur')
local p = (1-F(`q',`df_ur',`f'))

di "F-statistic: `f'"
di "p-value: `p'"

*** USING STATA BUILT-IN FUNCTION: test 
reg lsalary years gamesyr bavg hrunsyr rbisyr 
test bavg hrunsyr rbisyr 
di "p-value: `r(p)'"

* EXAMPLE 2
use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/jw_datasets/WAGE2.DTA", clear 

* there are some missing values - need to ensure the same sample between regressions
foreach var in lwage educ IQ exper tenure age married black sibs brthord meduc {
	qui drop if missing(`var')
}

*** MANUAL CALCULATION

* unrestricted model 
reg lwage educ IQ exper tenure age married black sibs brthord meduc

local ssr_ur = `e(rss)'
local df_ur = `e(df_r)'

* are the fmaily controls important? 
*** restricted model - omit sibs brthord meduc
reg lwage educ IQ exper tenure age married black

local ssr_r = `e(rss)'
local df_r = `e(df_r)'

local q = `df_r'-`df_ur'

local f = ((`ssr_r' - `ssr_ur')/`q')/(`ssr_ur'/`df_ur')
local p = (1-F(`q',`df_ur',`f'))

di "F-statistic: `f'"
di "p-value: `p'"

*** USING STATA BUILT-IN FUNCTION: test 
reg lwage educ IQ exper tenure age married black sibs brthord meduc
test sibs brthord meduc
di "p-value: `r(p)'"

log close f_distribution_ftest 
clear all 
