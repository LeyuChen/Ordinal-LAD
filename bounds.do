* Supporting material to:
* Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2022). 
* "Parametric and Semiparametric Median Ranking of Discrete Ordinal Outcomes". 

* This code produces heteroskedastic ordered probit and logit estimates 
* that are used to construct the bounds for the ordinal discrete choice 
* median regression model estimation. The results are stored in 'logitse.xlsx'
* and 'probitse.xlsx' files.
*
* y       : vector of individual responses
* x1      : the specific regressor with respect to which 
*           scale normalization is imposed
* other_x : covariates which are used in the model, excluding x1.  
*           Note that other_x should not contain the intercept term.
* weights : vector of sampling weights 

clear all
macro drop _all
pwd
********************  Part 1. Inputs Definition  **************************
use "GSS_working.dta"
*use "/Volumes/oparina$/COPS/codes_log inc_strata sample/GSS_working.dta"
 
gen y = hppy 
gen x1 = inc_pm_n  

global other_x age age2 fem lefths bach grad mrd dvrcd widowed black other_r unempl nonlf  _Iyear_2002 _Iyear_2004 _Iyear_2006 _Iyear_2008 _Iyear_2010 _Iyear_2012 _Iyear_2014 _Iyear_2016 _Iyear_2018

gen weights = wt_correction 

***********************  Part 2. Estimation  ******************************
global all_x x1 $other_x

global function logit probit
eststo clear

foreach func in $function {
oglm y $all_x [pw=weights], link(`func') hetero($all_x)
eststo `func', title("`func' results")

local ftest
foreach var in $all_x {
local ftest `ftest' [lnsigma]`var'
}
test `ftest'

set more off
global varlist2 

disp "$varlist2"
disp "$other_x"
forvalues i=1 / `e(k_aux)' {
global varlist2 $varlist2 cut`i'
}

local bounds 
foreach var in $other_x {
local bounds `bounds' (`var'_r: _b[`var']/_b[x1])
}
foreach var in $varlist2 {
local bounds `bounds' (`var'_r: _b[/`var']/_b[x1])
}
nlcom `bounds'

mata: B = st_matrix("r(b)")'
mata: SE = sqrt(diagonal(st_matrix("r(V)")))
mata: RES = B, SE
mata: st_matrix("RES",RES) 
putexcel set `func'se, replace
putexcel A1 = matrix(RES)
putexcel close
}

esttab,   se stats(r2 N  N_cntr, label("R2" "Observations" "Countries") fmt(%9.2f 0  0)) nogaps label nodepvar nonumber star(* 0.1 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f) 
esttab using "ordered_estimates.csv", se stats(r2 N  N_cntr, label("R2" "Observations" "Countries") fmt(%9.2f 0  0)) nogaps label nodepvar nonumber star(* 0.1 ** 0.05 *** 0.01) b(%12.3f) se(%12.3f)  replace
