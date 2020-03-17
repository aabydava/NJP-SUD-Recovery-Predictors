
********************************************
* SUD Recovery Predictors - Data Preparation
* Author: David Aaby
* Updated: March 17 2020
********************************************

clear all 
capture log close
set more off

**********************************************
*****     STANDARD/METHODS VARIABLES     *****
**********************************************

cd "P:\Products\Papers\Kid's Papers\Kid's SUD Recovery Predictors\Analysis\NJP-SUD-Recovery-Predictors"

**********
* ABSINT *
**********

use "L:\dta\absint_data.dta", clear
keep if permid < 1840
keep permid race deceased dontfup dfup_dt base_dat dob_day dob_mo dob_year fupplan
gen dob_long=mdy(dob_mo,dob_day,dob_year)
format dob_long %d
drop dob_mo dob_day dob_year
ren race race_long
label var dob_long "DOB from Longitudinal Absint"
label var base_dat "baseline date"
label var race_long "Race of Subject from Longitudinal Absint"
sort permid
save "C:\temp\absint.dta", replace


****************
* Baseline Log *
****************

use "J:\dta\njp_interview_log.dta", clear 
drop if permid > 1840
keep permid intake gender aids atdel lg_dob raceself racselfb racselfw racselfh racselfo racfathc age fem male strata blackstr whitestr hispstr wt_N wt_Nc wt_n wt_f wt_W wt_w 
ren age age_base
ren lg_dob dob_base
label var raceself "Hierarchical Self-Identification Race-Baseline"
count
sort permid
save "C:\temp\baselog.dta", replace


*********************
* Fup Interview Log *
*********************

foreach X of numlist 1/4 {
		use 	"L:\dta\NJP_Fup1-4_Interview_Log.dta", clear
		keep    if wave==`X'
		
		*keep youth ONLY*
		keep 	if subject=="Y"
		drop 	if permid>1840
		count
		keep 	permid wave date_beg iv_stat type date_end 	dis_r dis_s			
		gen 	fupdate`X'=date_beg 
		replace fupdate`X'=date_end if date_end~=.
		format 	fupdate`X' %d
		label 	var fupdate`X' "FUP`X' Interview Date"
		drop   date_beg date_end wave
		rename iv_stat iv_stat`X'
		label  var iv_stat`X' "Fup`X': Status of Interview"
		rename type  type`X'
		label  var type`X' "Fup`X': Type of Interview"
		rename dis_r dis_r`X'
		label var dis_r`X' "Fup`X': DIS Module R (Alcohol) Status"
		rename dis_s dis_s`X'
		label var dis_s`X' "Fup`X': DIS Module S (Substance) Status"
		sort    permid
		save   "C:\temp\log`X'.dta", replace
}

foreach X of numlist 5 {
		use "L:\Dta\NJP_Fup`X'_Interview_log.dta", clear 
		keep    if wave==`X'
		
		*keep youth ONLY*
		keep 	if subject=="Y"
		drop 	if permid>1840
		count
		keep 	permid wave date_beg iv_stat type date_end dis_r dis_s ptsd_sample					
		gen 	fupdate`X'=date_beg 
		replace fupdate`X'=date_end if date_end~=.
		format 	fupdate`X' %d
		label 	var fupdate`X' "FUP`X' Interview Date"
		drop   date_beg date_end wave
		rename iv_stat iv_stat`X'
		label  var iv_stat`X' "Fup`X': Status of Interview"
		rename type  type`X'
		label  var type`X' "Fup`X': Type of Interview"
		rename dis_r dis_r`X'
		label var dis_r`X' "Fup`X': DIS Module R (Alcohol) Status"
		rename dis_s dis_s`X'
		label var dis_s`X' "Fup`X': DIS Module S (Substance) Status"
		sort    permid
		save   "C:\temp\log`X'.dta", replace
}
	
	
foreach X of numlist 6 {
	use "L:\Dta\NJP_Fup`X'_Interview_log.dta", clear 
	keep    if wave==`X'
		*keep youth ONLY*
		keep 	if subject=="Y"
		drop 	if permid>1840
		count
		keep 	permid wave date_beg iv_stat type date_end dis_r dis_s					
		gen 	fupdate`X'=date_beg 
		replace fupdate`X'=date_end if date_end~=.
		format 	fupdate`X' %d
		label 	var fupdate`X' "FUP`X' Interview Date"
		drop   date_beg date_end wave
		rename iv_stat iv_stat`X'
		label  var iv_stat`X' "Fup`X': Status of Interview"
		rename type  type`X'
		label  var type`X' "Fup`X': Type of Interview"
		rename dis_r dis_r`X'
		label var dis_r`X' "Fup`X': DIS Module R (Alcohol) Status"
		rename dis_s dis_s`X'
		label var dis_s`X' "Fup`X': DIS Module S (Substance) Status"
		sort    permid
	save   "C:\temp\log`X'.dta", replace
}


foreach X of numlist 7/13 {
	use "H:\Dta\NJP_Fup`X'_Interview_log.dta", clear 
	keep    if wave==`X'
		*keep youth ONLY*
		keep 	if subject=="Y"
		drop 	if permid>1840
		count
		keep 	permid wave date_beg iv_stat type date_end 	dis_r dis_s					
		gen 	fupdate`X'=date_beg 
		replace fupdate`X'=date_end if date_end~=.
		format 	fupdate`X' %d
		label 	var fupdate`X' "FUP`X' Interview Date"
		drop   date_beg date_end wave
		rename iv_stat iv_stat`X'
		label  var iv_stat`X' "Fup`X': Status of Interview"
		rename type  type`X'
		label  var type`X' "Fup`X': Type of Interview"
		rename dis_r dis_r`X'
		label var dis_r`X' "Fup`X': DIS Module R (Alcohol) Status"
		rename dis_s dis_s`X'
		label var dis_s`X' "Fup`X': DIS Module S (Substance) Status"
		
		sort    permid
	save   "C:\temp\log`X'.dta", replace
}


use "c:\temp\log1.dta", clear

forvalues i=2/13 {
	merge 1:1 permid using "c:\temp\log`i'.dta", nogen
}

sort permid


save "C:\temp\log1to13.dta", replace


****************
* Methods Vars *
****************
 
use "L:\Dta\NJP_Methods_Variables_21Jan2016.dta", clear 
drop if permid > 1840
keep   permid aob aob_nr aoi1 aoi1_nr  aoi2 aoi2_nr aoi3 aoi3_nr aoi4 aoi4_nr aoi5 aoi5_nr aoi6 aoi6_nr timecheck_fup1 timecheck_fup2 timecheck_fup3 timecheck_fup4 timecheck_fup5 timecheck_fup6 dnfdate 
sort   permid
save   "C:\temp\method1to6.dta", replace

use    "H:\Dta\NJP_FUP7-13_Methods_Variables_21Jan2016.dta", clear
drop   if permid>1840
keep   permid aoi7 aoi7_nr aoi8 aoi8_nr aoi9 aoi9_nr aoi10 aoi10_nr aoi11 aoi11_nr aoi12 aoi12_nr aoi13 aoi13_nr timecheck_fup7 timecheck_fup8 timecheck_fup9  timecheck_fup10  timecheck_fup11   timecheck_fup12  timecheck_fup13
sort   permid
save  "C:\temp\method7to13.dta", replace


***************
* Incarc Vars *
***************

foreach X of numlist 1/6 {
	use     "L:\Dta\NJP_Incarcerated_Interviews_Fup`X'.dta", clear
	keep    permid prison_int`X' jail_int`X' com`X' incarc`X' place`X' phone`X' 
	sort    permid 
	label   var phone`X' "Fup`X': Phone Interview"
	label   var jail_int`X' "Fup`X': Jail Interview"
	label   var prison_int`X' "Fup`X': Prison Interview"
	save    "C:\temp\incar`X'.dta", replace
}

foreach X of numlist 7/13 {
	use     "H:\dta\NJP_Incarcerated_Interviews_Fup`X'.dta", clear
	keep    permid com`X' incarc`X' place`X' phone`X' 
	sort    permid 
	save    "C:\temp\incar`X'.dta", replace
}


use "C:\temp\incar1.dta", clear

forvalues i=2/13 {
	merge 1:1 permid using "C:\temp\incar`i'.dta", nogen
}

sort    permid
save    "C:\temp\incar.dta", replace



***********************
* Time in Corrections *
***********************

use "L:\Methods\Time_in_corrections\Create Data for Analysis\data\NJP_Time_in_Corrections_365days_FUP_3Apr2019.dta" , clear
keep    if inlist(wave,1,2,3,4,5,6, 7, 8, 9, 10, 11, 12, 13) 
drop    if permid>1840
keep   permid wave tic-inc
reshape wide tic-inc, i(permid) j(wave)
sort   permid
save  "C:\temp\tic1to13.dta", replace



***********************
* Merge Standard Vars *
***********************

use "C:\temp\absint.dta", clear
merge 1:1 permid using  "C:\temp\baselog.dta", nogen
merge 1:1 permid using  "C:\temp\log1to13.dta", nogen
merge 1:1 permid using "C:\temp\method1to6.dta", nogen
merge 1:1 permid using "C:\temp\method7to13.dta", nogen
merge 1:1 permid using "C:\temp\incar.dta", nogen
merge 1:1 permid using "C:\temp\tic1to13.dta", nogen


sort permid
save  "C:\temp\standard.dta", replace


************************************************
* FINAL MERGE WITH DSM IV DIAGNOSTIC VARIABLES *
************************************************

use "L:\Methods\Diagnostic Comparisons\FUPs 1-4 to FUP 5+\Data\DSM4_DX_BASELINE-FUP13_WIDE.dta", clear
merge 1:1 permid using "C:\temp\standard.dta"
keep if _merge==3
drop  _merge



*******************
* Variable Lables *
*******************

foreach X of numlist 1/13 {
	label var  tic`X'             "Fup `X': Days in corrections, past 365 days"
	label var pris`X'             "Fup `X': Days in prison, past 365 days"
	label var jail`X'             "Fup `X': Days in jail, past 365 days"
	label var rel`X'              "Fup `X': Releases from corrections, past 365 days"
	label var relpris`X'          "Fup `X': Releases from prison, past 365 days"
	label var reljail`X'          "Fup `X': Releases from jail, past 365 days"
	label var flag_rec`X'         "Fup `X': Flag: Incomplete record data, collected prior to interview date"
	label var flag_sr`X'          "Fup `X': Flag: self report used to supplement record data, past 365 days"
	label var flag_em`X'          "Fup `X': Flag: Electronic monitoring, past 365 days"
	label var flag_dnc`X'         "Fup `X': Flag: Do not collect institutional data"
	label var checktime`X'        "Fup `X': Number of DAYS between baseline and Time Point"
	label var check_sr`X'         "Fup `X': Number of self-reported days in corrections, past 365 days"
	label var check_rec`X'        "Fup `X': Number of record days in corrections, past 365 days"
	label var check_em`X'         "Fup `X': Maximum possible number of days on electronic monitoring, past 365 days"
	label var inc`X'              "Fup `X': Incarcerated entire past 365"
}


foreach X of numlist 1/13 {
	label var com`X' "Fup `X': Community Interview"
	label var incarc`X' "Fup `X': Incarcerated Interview"
	label var place`X' "Fup `X': Placement Interview"
	label var phone`X' "Fup `X': Phone Interview"
	label var dis_r`X' "Fup`X': DIS Module R (Alcohol)"
	label var dis_s`X' "Fup`X': DIS Module S (Substance)"
}


************************
* SAVE WIDE (FUP) DATA *
************************

save "data\SUD_Recov_Pred_WIDE.dta", replace  


**********************************
*****     LONG FORM DATA     *****
**********************************


use "C:\temp\standard.dta", clear

* NOTE: Some variables names are not ideal for reshaping
* Rename variables to standardized variable names used in long form

foreach FUP of numlist 1/13 {
	rename aoi`FUP'_nr aoi_nr`FUP'
}

clonevar aoi_nr0 = aob_nr
clonevar aoi0 = aob


* Macro for all variable stubs *
local STUBS aoi aoi_nr timecheck_fup prison_int jail_int com incarc place phone time_corr type iv_stat fupdate tic pris jail rel relpris reljail flag_rec flag_sr flag_em flag_dnc checktime check_sr check_rec check_em inc time_pris time_jail rel_corr rel_pris rel_jailflag_norel check_imp 

* Reshape data from wide format to long format *
reshape long `STUBS', i(permid) j(wave)

*Interview date (baseline to fup9) *

gen intdate = base_dat
replace intdate = fupdate if wave > 0
label variable intdate "Interview Date"
drop if intdate==.


*******************
* Variable Labels *
*******************

label var prison_int "Prison Interview"
label var jail_int   "Jail Interview"
label var com        "Community Interview"
label var incarc     "Incarcerated Interview"
label var place 	 "Placement Interview"
label var phone 	 "Phone Interview"
label var aoi 	 	 "True Age at interview"
label var aoi_nr 	 "True Age at interview-Not rounded"
label var timecheck_fup	 "Time between baseline and FUP"
label var fupdate    "Date of Interview"
label var iv_stat   "Status of Interview"
label var type 		"Type of Interview"



label var time_corr "Fup `X':  Days in corrections, 365 days prior to FUP or 90 days prior to baseline"
label var time_pris "Fup `X': Days in prison, 365 days prior to FUP or 90 days prior to baseline"
label var time_jail "Fup `X': Days in jail, 365 days prior to FUP or 90 days prior to baseline"
label var rel_corr  "Fup `X': Releases from corrections, 365 days prior to FUP or 90 days prior to baseline"
label var rel_pris  "Fup `X': Releases from prison, 365 days prior to FUP or 90 days prior to baseline"

save "C:\temp\standard_long.dta", replace


******************************************
* MERGE WITH DSM IV DIAGNOSTIC VARIABLES *
******************************************

use "L:\Methods\Diagnostic Comparisons\FUPs 1-4 to FUP 5+\Data\DSM4_DX_BASELINE-FUP13_LONG.dta", clear
keep permid wave disc dis wmhcidi ptsd_el *dsm
merge 1:1 permid wave using "C:\temp\standard_long.dta"
keep if _merge==3
drop  _merge orig_aspddsm
sort permid wave

notes drop _all
label data "SUD Recovery Predictors - LONG DATA.  Last update:`today' by David Aaby"

*******************
* save final data *
*******************

save "data\SUD_Recov_Pred_LONG.dta", replace           




