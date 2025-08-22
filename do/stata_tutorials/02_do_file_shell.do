/*
Author: 
Date: 

Purpose: <briefly describe what this do file does>

*/

* paste the below code into the command window to run your do file once it's complete 
* do "do/<lastname>_<first_name>_ps<number>.do"

*-------------------------------------
* SET DIRECTORIES 
*-------------------------------------

* set your directory 
cd "<your file path here>"

* create folders for do, log, output, raw_dta, dta - you only do this the first time you start a project
mkdir do 
mkdir log
mkdir output /// for saving stored results 
mkdir raw_dta /// for storing raw data
mkdir dta /// for storing dta files you've cleaned constructed

*-------------------------------------
* SET UP LOG 
*-------------------------------------

log using "log/<lastname>_<first_name>_ps<number>_final.log", text

*-------------------------------------
* IMPORT DATA / EXECUTE ANALYSIS
*-------------------------------------

/* GENERAL NOTES ON DO FILES 

- do files should accomplish one main thing - break large tasks into chunks and execute in separate do files 
- if your do file is longer than 200 lines you should separate out the analysis into multiple do files 
- following these guidelines will make your code easier to follow and you will be better able to troubleshoot problems

*/

*-------------------------------------
* CLOSE LOG 
*-------------------------------------

log close 
clear all
