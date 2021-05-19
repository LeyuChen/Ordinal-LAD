* Supporting material to:
* Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2021). 
* "Robust Ranking of Happiness Outcomes: A Median Regression Perspective". 

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

********************  Part 1. Inputs Definition  **************************
use "GSS_working.dta"

keep if year==1972 |_Iyear_1974==1 | _Iyear_1976==1 | _Iyear_1978==1 | _Iyear_1980==1 | _Iyear_1982==1 | _Iyear_1984==1 | _Iyear_1986==1 | _Iyear_1988==1 |  _Iyear_1990==1 |  _Iyear_1991==1 | _Iyear_1993==1 | _Iyear_1994==1 | _Iyear_1996==1 | _Iyear_1998==1 | _Iyear_2000==1 | _Iyear_2002==1 | _Iyear_2004==1 | _Iyear_2006==1 

drop if year ==1973 | year ==1975 | year ==1977 | year ==1983 | year ==1985 | year ==1987 | year ==1989 
drop _Iyear_1973 _Iyear_1975 _Iyear_1977 _Iyear_1983 _Iyear_1985 _Iyear_1987 _Iyear_1989 

gen y = hppy 
gen x1 = inc_pm_n  

global other_x age age2 dgr fem  mrd _Iyear_1974 _Iyear_1976 _Iyear_1978 _Iyear_1980 _Iyear_1982 _Iyear_1984 _Iyear_1986 _Iyear_1988 _Iyear_1990 _Iyear_1991 _Iyear_1993 _Iyear_1994 _Iyear_1996 _Iyear_1998 _Iyear_2000 _Iyear_2002 _Iyear_2004 _Iyear_2006

gen weights = wt_correction 

***********************  Part 2. Estimation  ******************************
global all_x x1 $other_x
global function logit probit
eststo clear

foreach func in $function {
oglm y $all_x [pw=weights], link(`func') hetero($all_x)
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

export delimited hppy inc_pm_n age age2 dgr fem  mrd  _Iyear* wt_correction year using "GSS_working_even.csv", nolabel replace
