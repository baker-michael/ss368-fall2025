/*
Author: Baker, Michael
Date: 28 Aug 2025 

Purpose: demonstrate how to use .do-files and generate variables in Stata

*/

*-------------------------------------
* SET DIRECTORIES 
*-------------------------------------

* set your directory 
cd "<your file path here>"

* create folders for do, log, output, raw_dta, dta - you only do this the first time you start a project
mkdir do 
mkdir log
mkdir output 
mkdir raw_dta 
mkdir dta

*-------------------------------------
* SET UP LOG 
*-------------------------------------

log using "log/gen_variables.log", text

*-------------------------------------
* IMPORT DATA / EXECUTE ANALYSIS
*-------------------------------------



*-------------------------------------
* CLOSE LOG 
*-------------------------------------

log close 
clear all
