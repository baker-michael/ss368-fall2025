* Author: 
* Date: 

* purpose: 

*-------------------------------------
* SET DIRECTORIES 
*-------------------------------------

* set your directory 
cd "<your file path here>"

/* create folders for do, log, output, raw_dta, dta - you only do this the first time you start a project
mkdir do 
mkdir log
mkdir output 
*/

*-------------------------------------
* SET UP LOG 
*-------------------------------------

log using "log/<lastname>_<firstname>_ps<number>_final.log", text

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




* Q: Create a histogram for mrate and prate. Do not worry about formatting - use Stata's default selections. After creating the histogram, save using: graph export "<your output file path>.svg", width(1600) fontface("Times New Roman") replace





* Q: Create a scatterplot with prate on the vertical axis and mrate on the horitzontal axis. Do not worry about formatting - use Stata's default selections. After creating the graph, save using: graph export "<your output file path>.svg", width(1600) fontface("Times New Roman") replace




*-------------------------------------
* CALCULATE OLS ESTIMATES MANUALLY
*-------------------------------------

* Regression model: participation rate = intercept + beta_hat * match rate + u

* Q: Calculate the coefficient estimates for the intercept and beta_hat manually using the formulas derived in class













* Q: Calculate the residuals/prediction errors (u_hat). What is the sum of the residuals? 








* Q: Calculate the covariance between the residuals and mrate. Does this mean that the zero conditional mean holds? 







* Q: Calculate the standard error of the slope coefficient (beta_hat). 













* Q: Explain how the standard error relates to the sampling distribution of beta_hat.







* Q: Calculate the R-squared 








*-------------------------------------
* OLS REGRESSION & INTERPRETATION
*-------------------------------------
* now use Stata's regress command to perform an OLS regression 



* Q: Interpret the intercept in this model. 



* Q: Interpret the coefficient estimate on mrate 



* Q: What is R-squared measuring? How does it relate to the whether the regression estimates have a causal interpretation? 




* Q: now add ltotemp as a control on the right-hand side. Interpret the coefficient estimate on ltotemp. 



log close 
clear all 