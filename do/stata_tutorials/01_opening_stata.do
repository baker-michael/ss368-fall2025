/* 
this do file includes all the commands from 01-opening-stata tutorial

setup: 
- do a find and replace (Ctrl + H) and replace all instances of <your current directory here> with the file path to your current directory 
*/

* clear results window
cls 

*----------------------------------------------
* SETTING DIRECTORIES
*----------------------------------------------

* check current directory
pwd 

* change to new directory
cd "<your current directory here>"

* set the current directory as a global macro - allows you to use absolute file paths, but makes it easy to change if you move the project to a new folder
* if you moved the project to a new folder, you would only need to change the file path here 
global main "<your current directory here>"

di "${main}"

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
