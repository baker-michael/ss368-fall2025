/*
Author: Mike Baker         						            
Date: 20 Aug 2025 

Purpose: create visualizations to demonstrate the law of large numbers and the central limit theorem

*/

*****************************************************************
* PRELIMINARIES
*****************************************************************

clear all
qui cap restore

* DIRECTORY SETUP - file paths for log and output files 
/*
cd ""
global log ""
global output ""
*/

qui cap log close lln_clt_demo
log using "${log}/lln_clt_demo.log", text replace name(lln_clt_demo)

*-----------------------------------------------
* LAW OF LARGE NUMBERS
*-----------------------------------------------
/* simulation: 
- draw 100 samples of different sample sizes
- for each sample, calculate the sample mean
- plot the distribution of sample means (the sampling distribution)
*/

* setting the seed ensures the results are repoducible, otherwise the random number generation will produce slightly different results each time 
set seed 7645

* setting the number of samples to 100 
local num_samples = 100

* looping through different sample sizes 
foreach sample_size in 100 500 1000 10000 100000 {
	
	* results are saved in a matrix and then converted to a dta 
	matrix sample_means_size_`sample_size' = J(`num_samples', 1, .)

	forvalues i = 1/`num_samples' {
		
		clear
		qui set obs `sample_size'
		
		gen rand = runiform(0,1)
		
		qui sum rand 
		
		matrix sample_means_size_`sample_size'[`i', 1] = `r(mean)'
		
		drop rand 
		
	}

	* convert matrix to dta 
	clear 
	qui svmat sample_means_size_`sample_size', names(sample_mean)
	
	* plot histogram
	
	*** create labels for the horizontal axis
	qui mylabels 0.4(0.05)0.6, myscale(@) local(xlabels)
	qui mylabels 0.4(0.025)0.6, myscale(@) local(xmlabels)
	
	*** format presentation of sample size and number of samples 
	local f_sample_size = string(`sample_size', "%9.0fc")
	local f_num_samples = string(`num_samples', "%9.0fc")
	
	local ymax = 25
	
	* #delimit - changing the delimiter makes it easier to read the graph command 
	* histogram plots the sampling distribution, pci adds a line at the pop. mean, scatteri adds the label population mean 
	* i recommend exporting graphs as .svg's - most compatible/fastest way to retain high-quality graphics 
	#delimit ; 
	twoway histogram sample_mean1, frequency color(orange) gap(10) ||
	pci 0 0.5 `ymax' 0.5, lcolor(black) lpattern(dash) ||
	scatteri `ymax' 0.5 "Population Mean", msymbol(i) mlabcolor(black) mlabposition(3) ||,
	title("Distribution of Sample Means")
	subtitle("N = `f_sample_size', No. of Samples = `f_num_samples'")
	ylabel(, angle(0)) xtitle("Sample Means")
	xlabel(`xlabels') xmtick(`xmlabels') 
	ytitle("Frequency")
	legend(off);
	graph export "${output}/lln_samples_means_`num_samples'_samples_size_`sample_size'.svg", width(1600) fontface("Times New Roman") replace; 
	#delimit cr 
}

*-----------------------------------------------
* CENTRAL LIMIT THEOREM
*-----------------------------------------------

* setting the seed ensures the results are repoducible, otherwise the random number generation will produce slightly different results each time 
set seed 5673

* setting the sample size to 1,000
local sample_size = 1000

* looping through different number of samples 
foreach num_samples in 100 500 1000 10000 {
	
	* results are saved in a matrix and then converted to a dta 
	matrix sample_means_size_`sample_size' = J(`num_samples', 1, .)

	forvalues i = 1/`num_samples' {
		
		clear
		qui set obs `sample_size'
		
		gen rand = runiform(0,1)
		
		qui sum rand 
		
		matrix sample_means_size_`sample_size'[`i', 1] = `r(mean)'
		
		drop rand 
		
	}

	* convert matrix to dta 
	clear 
	qui svmat sample_means_size_`sample_size', names(sample_mean)

	* plot histogram
	
	*** create labels for the horizontal axis
	qui mylabels 0.45(0.025)0.55, myscale(@) local(xlabels)
	qui mylabels 0.45(0.0125)0.55, myscale(@) local(xmlabels)
	
	*** format presentation of sample size and number of samples 
	local f_sample_size = string(`sample_size', "%9.0fc")
	local f_num_samples = string(`num_samples', "%9.0fc")
	
	local ymax = 55

	qui sum sample_mean1
	local mean_val = `r(mean)'
	local sd_val = `r(sd)'
	local min_val = `r(min)'
	local max_val = `r(max)'
	
	* #delimit - changing the delimiter makes it easier to read the graph command 
	* histogram plots the sampling distribution, function plots the normal distribution, pci adds a line at the pop. mean, scatteri adds the label population mean 
	* i recommend exporting graphs as .svg's - most compatible/fastest way to retain high-quality graphics 
	#delimit ;
	twoway histogram sample_mean1, density color(orange) gap(10) ||
	function normalden(x, `mean_val', `sd_val'), range(`min_val' `max_val') lcolor(red) ||
	pci 0 0.5 `ymax' 0.5, lcolor(black) lpattern(dash) ||
	scatteri `ymax' 0.5 "Population Mean", msymbol(i) mlabcolor(black) mlabposition(3) ||,
	title("Distribution of Sample Means")
	subtitle("N = `f_sample_size', No. of Samples = `f_num_samples'")
	ylabel(, angle(0)) xtitle("Sample Means")
	xlabel(`xlabels') xmtick(`xmlabels') 
	ytitle("Density")
	legend(off);
	graph export "${output}/clt_samples_means_`num_samples'_samples_size_`sample_size'.svg", width(1600) fontface("Times New Roman") replace; 
	#delimit cr 
}

log close lln_clt_demo
clear all 
