
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

mvpatterns subdsm7 subdsm8 subdsm9 subdsm10 subdsm11 
mvpatterns subdsm8 subdsm9 subdsm10 subdsm11 subdsm12 
mvpatterns subdsm9 subdsm10 subdsm11 subdsm12 subdsm13

*NOTE: FUP7, FUP8, FUP10 contain only the aids subsample

* count of non-missing values for subdsm *
egen cnt1 = rownonmiss(subdsm7 subdsm8 subdsm9 subdsm10 subdsm11)  
egen cnt2 = rownonmiss(subdsm8 subdsm9 subdsm10 subdsm11 subdsm12) 
egen cnt3 = rownonmiss(subdsm9 subdsm10 subdsm11 subdsm12 subdsm13) 

tab cnt1
tab cnt2 
tab cnt3

* define complete as having data on 4/5 interviews *
gen complete1 = 1 if cnt1 >=4
gen complete2 = 1 if cnt2 >=4
gen complete3 = 1 if cnt3 >=4

tab complete1
tab complete2
tab complete3

count if complete3==1
count if complete3==. & complete2==1
count if complete1==1 & complete3==. & complete2==.

* we also need to figure out who previously had a SUD in adolescence??
* will need to figure out how to exactly define this. need others to weigh in
* to start, let's pick an age (Leah thinks 19 is ok, since SUD is measured past year) as cut-off
* for baseline, use reported age so we get everyone
* we only need to go through FUP 6, no participants <= 19 at FUP 7 or beyond

clonevar aoi0 = age_base

forvalues i = 0/6 {
	gen adol`i' = 1 if aoi`i' <= 19

}

gen subdsm_adol = .
forvalues i= 0/6 {
	replace subdsm_adol = 1 if subdsm`i' == 1 & adol`i' == 1
}

keep if subdsm_adol == 1

* now check counts for only those with a SUD in adolescence *
count if complete3==1
count if complete3==. & complete2==1
count if complete1==1 & complete3==. & complete2==.

* generate recovery from SUD *
gen subdsm_recov = .
	replace subdsm_recov = 1 if complete3==1 & (subdsm9 == 0 & subdsm10 == 0 & subdsm11 == 0 & subdsm12 == 0 & subdsm13 == 0)
	replace subdsm_recov = 1 if complete3==1 & (subdsm9 == . & subdsm10 == 0 & subdsm11 == 0 & subdsm12 == 0 & subdsm13 == 0)
	replace subdsm_recov = 1 if complete3==1 & (subdsm9 == 0 & subdsm10 == . & subdsm11 == 0 & subdsm12 == 0 & subdsm13 == 0)
	replace subdsm_recov = 1 if complete3==1 & (subdsm9 == 0 & subdsm10 == 0 & subdsm11 == . & subdsm12 == 0 & subdsm13 == 0)
	replace subdsm_recov = 1 if complete3==1 & (subdsm9 == 0 & subdsm10 == 0 & subdsm11 == 0 & subdsm12 == . & subdsm13 == 0)
	replace subdsm_recov = 1 if complete3==1 & (subdsm9 == 0 & subdsm10 == 0 & subdsm11 == 0 & subdsm12 == 0 & subdsm13 == .)

	replace subdsm_recov = 0 if complete3==1 & (subdsm9 == 1 | subdsm10 == 1 | subdsm11 == 1 | subdsm12 == 1 | subdsm13 == 1)

label var subdsm_recov "SUD Recovery"








