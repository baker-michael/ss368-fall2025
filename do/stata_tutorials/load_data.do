/*
Author: Baker, Michael
Date: 28 Aug 2025 

Purpose: demonstrate how to use .do-files and load data 

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

log using "log/load_data.log", text

*----------------------------------------------
* LOADING A DATASET 
*----------------------------------------------

* load and save a training dataset
sysuse auto, clear 
save "${main}/auto.dta" /// saves to current directory 

* load a dataset - equivalent methods
use "${main}/auto.dta", clear 

clear
use "auto.dta" 

* absolute versus relative file paths - absolute is the full path, relative is based on your current directory 

*** absolute 
use "${main}/auto.dta", clear 

*** relative 
use "auto.dta", clear 

* load only certain variables 
use make price foreign using "auto.dta", clear 

* load all variables, but restrict to only foreign cars 
use * using "${main}/auto.dta" if foreign == 1, clear 

* limiting the dataset to certain variables and restricting to only foreign cars 
use make price foreign using "${main}/auto.dta" if foreign == 1, clear 

* label a variable
label var foreign "indicator: foreign cars"



*-------------------------------------
* CLOSE LOG 
*-------------------------------------

log close 
clear all
