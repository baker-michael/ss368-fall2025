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

*----------------------------------------------
* SET UP FOLDER STRUCTURE 
*----------------------------------------------

/* recommended folder structure 

do - stores all .do files 
log - stores all .log files 
output - stores all output
raw_dta - stores raw (unaltered) datasets
dta - stores altered/cleaned datasets 

for large projects, you can create additional sub-folders within each, but this is the bare minimum. 
*/

* create the folder structure in your current working directory
*** mkdir creates a folder on your computer 
*** you would only run this once per project 
mkdir do 
mkdir log
mkdir output 
mkdir raw_dta 
mkdir dta


*-------------------------------------
* SET UP LOG 
*-------------------------------------

log using "log/<lastname>_<firstname>_ps<number>_final.log", text

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
