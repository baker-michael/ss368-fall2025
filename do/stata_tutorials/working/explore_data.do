/*
Author: Baker, Michael
Date: 10 Sep 2025 

Purpose: exploring a dataset - basic tools 

*/

*----------------------------------------------
* IMPORT A SYSTEM A DATASET 
*----------------------------------------------

* use a Stata built-in dataset for this exercise
sysuse "auto.dta", clear 

* save the dataset as a temporary file 
*** compress isn't strictly needed here, but it is good practice always to compress data before saving to conserve disk space 
qui compress
*** declare tempfile 
tempfile auto 
save `auto' 

*----------------------------------------------
* DESCRIBE A DATASET 
*----------------------------------------------

* describe the data 
describe 

* describe without loading into memory 
clear
describe using `auto'

* describe only certain variables without loading into memory 
describe mpg rep78 foreign using `auto'

* print a summary overview for each variable 

*** re-load the data 
use `auto', clear 

*** for all variables 
codebook 

*** for specific variables 
codebook mpg 

* look for missing values 

*** requires installation: ssc install mdesc 
mdesc 

*----------------------------------------------
* VIEWING DATA
*----------------------------------------------

* browse the full dataset 
browse 

* change the order of the columns 
order foreign weight price 

browse 

* browse only specific columns
browse make price mpg 

* view data in the results window 
*** limit to make, price, and mpg and only the first 15 observations 
list make price mpg if _n<15

*----------------------------------------------
* CALCULATE SIMPLE STATISTICS
*----------------------------------------------

* summarize: sum is an abbreviation for summarize 

*** simple, all variables: no. obs, mean, std. dev., min, max - will ignore missing values 
sum 

*** specific variables 
sum price 

*** example: save the no. of obs and mean for use later. 
***** see the help file (type help summarize in the command window) > look under "Stored results" 
sum price 
local obs = `r(N)'
local mean = `r(mean)'

*** detailed: adds select percentiles 
sum price, d 

*** example: save the median (or any other percentile) for use later
sum price, d 
local median = `r(p50)'

* tabulate: tab is an abbreviation for tabulate 
*** create a simple frequency table 
tab foreign

*** remove labeling 
tab foreign, nolabel 

*** include missing values 
tab rep78, m 

*** you can also make two-way tables 

***** create a variable that capture above/below median price 
gen g_p50_price = price > `median'

***** create two-way table
tab foreign g_p50_price, m 

clear all
