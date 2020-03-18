
**************************************************
* SUD Recovery Predictors - Missing Data Patterns
* Author: David Aaby
* Updated: March 17 2020
**************************************************

clear all 
capture log close
set more off

/*****************

3 Year (FUP1)
3.5 Year (FUP2)
4 Year (FUP3)
5 Year (FUP4)
6 Year (FUP5)
8 Year (FUP6)
10 Year (FUP7)
11 Year (FUP8)
12 Year (FUP9)
13 Year (FUP10)
14 Year (FUP11)
15 Year (FUP12)
16 Year (FUP13)

******************/


*************************
* set working directory *
*************************

cd "P:\Products\Papers\Kid's Papers\Kid's SUD Recovery Predictors\Analysis\NJP-SUD-Recovery-Predictors"


*************
* load data *
*************

use "data\SUD_Recov_Pred_WIDE.dta", clear  


mvpatterns subdsm9 subdsm10 subdsm11 subdsm12 subdsm13

*NOTE: FUP10 is the aids subsample


mvpatterns subdsm9 subdsm11 subdsm12 subdsm13

* Amelie wants to go back to FUP 7? *
mvpatterns subdsm7 subdsm8 subdsm9 subdsm10 subdsm11 subdsm12 subdsm13

gen subdsm_prev = .
	replace subdsm_prev = 1 if subdsm0 == 1 | subdsm1 == 1 | subdsm2 == 1 | subdsm3 == 1 | subdsm4 == 1 | subdsm5 == 1 | subdsm6 == 1


gen complete1 = 1 if subdsm9 !=. & subdsm10 !=. & subdsm11 !=. & subdsm12 !=. & subdsm13 !=. 
gen complete2 = 1 if subdsm9 !=. & subdsm11 !=. & subdsm12 !=. & subdsm13 !=. 


count if complete1 == 1 & (subdsm9==0 & subdsm10==0 & subdsm11==0 & subdsm12==0 & subdsm13==0)
count if complete1 == 1 & (subdsm9==1 | subdsm10==1 | subdsm11==1 | subdsm12==1 | subdsm13==1)










