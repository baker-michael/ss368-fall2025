/*
Author: Baker, Michael
Date: 28 Aug 2025 

Purpose: demonstrate how to use .do-files and how to open/orient to data 

*/

*-------------------------------------
* SET DIRECTORIES 
*-------------------------------------

* set your directory 
cd "<your file path here>"

/* create folders for do, log, output, raw_dta, dta - you only do this the first time you start a project
	mkdir do 
	mkdir log
	mkdir output 
	mkdir raw_dta 
	mkdir dta
*/

*-------------------------------------
* SET UP LOG 
*-------------------------------------

log using "log/explore_data.log", text

*-------------------------------------
* IMPORT DATA / EXECUTE ANALYSIS
*-------------------------------------

*----------------------------------------------
* DESCRIBE A DATASET 
*----------------------------------------------

* describe the data 
describe 

* describe without loading into memory 
clear
describe using "${main}/auto.dta"

* describe only certain variables without loading into memory 
describe mpg rep78 foreign using "${main}/auto.dta"

*----------------------------------------------
* VIEWING DATA
*----------------------------------------------

* browse the full dataset 
browse 

* browse only specific columns
browse make price mpg 


mdesc 


*-------------------------------------
* CLOSE LOG 
*-------------------------------------

log close 
clear all
