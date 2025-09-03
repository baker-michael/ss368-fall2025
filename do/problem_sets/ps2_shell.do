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
* IMPORT DATA
*-------------------------------------

* IMPORT DATA 
use "https://raw.githubusercontent.com/baker-michael/ss368-fall2025/main/dta/ps2/ps2_replication_data.dta", clear

describe 

/* notes: 
- This dataset has missing data. As a result, the sample means and regression coefficients in each row/column are based on a changing number of observations. This is not good practice in general, but to replicate the results of the paper we will not change how missing values are handled. 

- As is common with survey data, producing accurate statistics requires the use of survey weights. There are different types of weights. In this case, the survey weights are probability weights to account for the sampling design of the survey. 

	- You will have to attach [pw = svy_weight] to any command where you are calculating statistics for the survey sample. Not all of the commands in stata support probability weights. Note: this adjustment is only required for the survey sample. When calculating statistics for the full sample, you do not need to use survey weights. 
	
	- Example 1: Calculate the mean and standard deviation with survey weights. Save the mean and survey weight to locals.  
	
		mean female if treatment & survey_sample [pw = svy_weight]
		local mn_female = _b[female]
		estat sd 
		local sd_female = r(sd)[1,1]
		
		* Alternatively, you could use the collapse command. summarize and tabstat will not accept probability weights 
		
	- Example 2: Estimate a regression with survey weights 
	
		reg female treatment if survey_sample [pw = svy_weight]

- To reproduce results from the paper, you will have to use clustered standard errors. For now you do not need to understand clustered standard errors, but essentially clustering allows the unobservable error to be correlated within a household. 
	
	- Example with clustered standard errors: 
	
		reg female treatment, vce(cluster hh_id)
		
- To replicate the results, you must include the following controls in the regressions. For now, you don't need to worry about these controls. Suffice to say that even within this randomized trial, some factors still need to be accounted for to ensure all-else-equal comparisons. 
	
	- For the full sample: `hh_size' `lottery_draw' (see macros below)
	
	- For the survey sample: `svy_controls' (see macros below)

*/

*-------------------------------------
* SET MACROS 
*-------------------------------------
* these are the specific variables that are used to produce Table 1 and Table 2

* SAMPLE CHARACTERISTICS 

*** both samples
local base female younger english zip_msa

local gov prenany_tanf_bin prenany_snap_bin prenany_tanf_hh_amt prenany_snap_hh_amt

*** survey sample only
local race_svy race_white race_black race_hisp 

local emp_income_svy emp_hrs_nowork fpl_cat_l_50 

local diag_svy dia_dx ast_dx hbp_dx emp_dx dep_dx

* OUTCOMES 

*** insurance - full sample 
local ins_fs ohp_all_ever_admin ohp_std_ever_admin ohp_all_mo_admin ohp_all_end_admin

*** insurance - survey sample 
local ins_svy ohp_all_ever_survey ohp_std_ever_survey ohp_all_mo_survey ohp_all_end_survey

*** healthcare utilization - survey sample only 
local util_svy rx_any doc_any er_any hosp_any

*** health - full sample 
local health_fs postn_alive 

*** health - survey sample 
local health_svy health_genflip_bin notbaddays_tot notbaddays_ment nodep_screen
* note: the results reported in the paper use notbaddays_tot as the measure for physical. notbaddays_phys is the "days poor physical or mental health did not impair usual  activity, past 30 days"

* REGRESSION CONTROLS 

*** for full sample
local hh_size nnnnumhh_li_2 nnnnumhh_li_3

local lottery_draw llldraw_lot_2 llldraw_lot_3 llldraw_lot_4 llldraw_lot_5 llldraw_lot_6 llldraw_lot_7 llldraw_lot_8

*** for survey sample 
local svy_controls ddddraw_sur_2 ddddraw_sur_3 ddddraw_sur_4 ddddraw_sur_5 ddddraw_sur_6 ddddraw_sur_7 dddnumhh_li_2 dddnumhh_li_3 ddddraXnum_2_2 ddddraXnum_2_3 ddddraXnum_3_2 ddddraXnum_3_3 ddddraXnum_4_2 ddddraXnum_5_2 ddddraXnum_6_2 ddddraXnum_7_2

*-------------------------------------
* SUMMARY STATISTICS - TABLE 1
*-------------------------------------



*-------------------------------------
* REGRESSION TABLE - TABLE 2
*-------------------------------------



log close 
clear all 