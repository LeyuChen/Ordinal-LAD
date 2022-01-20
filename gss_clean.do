* Supporting material to:
* Chen, L. Y., Oparina, E., Powdthavee, N., and Srisuma, S. (2022). 
* "Parametric and Semiparametric Median Ranking of Discrete Ordinal Outcomes". 

* This code produces prepared dataset from the GSS source data


clear
cd "/Users/katya/Desktop/COPS_JEBO_codes" // <- set working directory
#delimit ;

   infix
      year     1 - 20
      form     21 - 40
      realinc  41 - 60
      conrinc  61 - 80
      dateintv 81 - 100
      cohort   101 - 120
      birthmo  121 - 140
      ballot   141 - 160
      sample   161 - 180
      spanint  181 - 200
      health   201 - 220
      happy    221 - 240
      rincome  241 - 260
      id_      261 - 280
      wrkstat  281 - 300
      marital  301 - 320
      childs   321 - 340
      age      341 - 360
      degree   361 - 380
      sex      381 - 400
      race     401 - 420
      hompop   421 - 440
      wtssall  441 - 460
using GSS.dat;

label variable year     "Gss year for this respondent                       ";
label variable form     "Form of split questionnaire asked";
label variable realinc  "Family income in constant $";
label variable conrinc  "Respondent income in constant dollars";
label variable dateintv "Date of interview";
label variable cohort   "Year of birth";
label variable birthmo  "Month in which r was born";
label variable ballot   "Ballot used for interview";
label variable sample   "Sampling frame and method";
label variable spanint  "If no spanish, r could have been interviewed in english";
label variable health   "Condition of health";
label variable happy    "General happiness";
label variable rincome  "Respondents income";
label variable id_      "Respondent id number";
label variable wrkstat  "Labor force status";
label variable marital  "Marital status";
label variable childs   "Number of children";
label variable age      "Age of respondent";
label variable degree   "Rs highest degree";
label variable sex      "Respondents sex";
label variable race     "Race of respondent";
label variable hompop   "Number of persons in household";
label variable wtssall  "Weight variable";


label define gsp001x
   3        "Alternate <z>"
   2        "Alternate <y>"
   1        "Standard <x>"
   0        "No split ques"
;
label define gsp002x
   999999   "No answer"
   999998   "Dont know"
   0        "Not applicable"
;
label define gsp003x
   999999   "No answer"
   999998   "Dont know"
   0        "Not applicable"
;
label define gsp004x
   9999     "No answer"
   0        "Not applicable"
;
label define gsp005x
   9999     "No answer"
   0        "Not applicable"
;
label define gsp006x
   99       "No answer"
   98       "Don't know"
   12       "December"
   11       "November"
   10       "October"
   9        "September"
   8        "August"
   7        "July"
   6        "June"
   5        "May"
   4        "April"
   3        "March"
   2        "February"
   1        "January"
   0        "Not applicable"
;
label define gsp007x
   4        "Ballot d"
   3        "Ballot c"
   2        "Ballot b"
   1        "Ballot a"
   0        "Not applicable"
;
label define gsp008x
   10       "2010 fp"
   9        "2000 fp"
   8        "1990 fp"
   7        "1980 fp blk oversamp"
   6        "1980 fp"
   5        "1980 bfp blk oversamp"
   4        "1970 fp blk oversamp"
   3        "1970 fp"
   2        "1970 bq"
   1        "1960 bq"
;
label define gsp009x
   9        "No answer"
   8        "Dont know"
   2        "Would have been excluded as language problem"
   1        "Could have been interviewed in english"
   0        "Not applicable"
;
label define gsp010x
   9        "No answer"
   8        "Don't know"
   4        "Poor"
   3        "Fair"
   2        "Good"
   1        "Excellent"
   0        "Not applicable"
;
label define gsp011x
   9        "No answer"
   8        "Don't know"
   3        "Not too happy"
   2        "Pretty happy"
   1        "Very happy"
   0        "Not applicable"
;
label define gsp012x
   99       "No answer"
   98       "Don't know"
   13       "Refused"
   12       "$25000 or more"
   11       "$20000 - 24999"
   10       "$15000 - 19999"
   9        "$10000 - 14999"
   8        "$8000 to 9999"
   7        "$7000 to 7999"
   6        "$6000 to 6999"
   5        "$5000 to 5999"
   4        "$4000 to 4999"
   3        "$3000 to 3999"
   2        "$1000 to 2999"
   1        "Lt $1000"
   0        "Not applicable"
;
label define gsp013x
   9        "No answer"
   8        "Other"
   7        "Keeping house"
   6        "School"
   5        "Retired"
   4        "Unempl, laid off"
   3        "Temp not working"
   2        "Working parttime"
   1        "Working fulltime"
   0        "Not applicable"
;
label define gsp014x
   9        "No answer"
   5        "Never married"
   4        "Separated"
   3        "Divorced"
   2        "Widowed"
   1        "Married"
;
label define gsp015x
   9        "Dk na"
   8        "Eight or more"
;
label define gsp016x
   99       "No answer"
   98       "Don't know"
   89       "89 or older"
;
label define gsp017x
   9        "No answer"
   8        "Don't know"
   7        "Not applicable"
   4        "Graduate"
   3        "Bachelor"
   2        "Junior college"
   1        "High school"
   0        "Lt high school"
;
label define gsp018x
   2        "Female"
   1        "Male"
;
label define gsp019x
   3        "Other"
   2        "Black"
   1        "White"
   0        "Not applicable"
;
label define gsp020x
   99       "No answer"
   98       "Don't know"
;


label values form     gsp001x;
label values realinc  gsp002x;
label values conrinc  gsp003x;
label values dateintv gsp004x;
label values cohort   gsp005x;
label values birthmo  gsp006x;
label values ballot   gsp007x;
label values sample   gsp008x;
label values spanint  gsp009x;
label values health   gsp010x;
label values happy    gsp011x;
label values rincome  gsp012x;
label values wrkstat  gsp013x;
label values marital  gsp014x;
label values childs   gsp015x;
label values age      gsp016x;
label values degree   gsp017x;
label values sex      gsp018x;
label values race     gsp019x;
label values hompop   gsp020x;

#delimit cr	

gen hppy=4-happy
drop if hppy < 1
drop if happy < 1
drop if hppy==.
egen t_year=tag(year) 

gen wt=wtssall if sample~=4 & sample~=5 & sample~=7 & spanint~=2
drop if wt==.

* Make adjustments for series breaks (follows Stevenson, B., & Wolfers, J. (2008). Economic Growth and Subjective Well-Being: Reassessing the Easterlin Paradox. Brookings Papers on Economic Activity, 1??7.)
gen MARITAL=marital
gen married=marital==1
gen FORM=form
for any a1 a2: gen X=0
replace a1=1 if (year==1972 & MARITAL==1) | (year==1980 & MARITAL==1 & FORM==3) | (year==1987 & MARITAL==1 & FORM==3)
replace a2=1 if (year==1972) | (year==1985) | (year==1986 & FORM==2) | (year==1987 & FORM==2) | (year==1987 & FORM==3)

gen correction_factor=.
la var correction_factor "Reweighting to correct for series breaks"
levelsof hppy, local(happylevel)
foreach l of local happylevel {
	gen hap`l'=1 if hppy==`l'
	la var hap`l' "Happiness==`l': binary indicator"
	replace hap`l'=0 if hppy~=. & hppy~=`l'
	qui xi: reg hap`l' a1 a2 i.married*i.year [pw=wt]
	local b1=_b[a1]
	local b2=_b[a2]
	predict corrected if hap`l'==1
	replace correction_factor=(corrected-`b1'*a1-`b2'*a2)/corrected if hap`l'==1
	drop corrected
	qui xi: reg hap`l' i.year [pw=wt]
	predict hap`l'_hat_raw if hppy~=., xb
	gen hap`l'_hat_adj=hap`l'_hat_raw-`b1'*a1-`b2'*a2
	qui xi: reg hap`l'_hat_adj i.year [pw=wt]
	predict hap`l'_hat if hap`l'_hat_adj~=.
	la var hap`l'_hat "Corrected proportion choosing `l'"
	table year [aw=wt], c(m hap`l' m hap`l'_hat_raw m hap`l'_hat_adj m hap`l'_hat)
}
gen wt_correction=wt*correction_factor
la var wt_correction "Weight, adjusting for happiness series breaks"

* generate variables for groups and years
drop if year<2000 
drop _Iyear_197* _Iyear_198* _Iyear_199*
drop if marital==9 | degree==9 | degree==8 | realinc==0
drop if age ==98 | age==99
*drop if child==9

gen fem = (sex==2)
gen mrd = (marital==1)
gen dvrcd = (marital==3 | marital==4 )
gen widowed = (marital==2)
gen lefths = (degree==0)
gen bach = (degree==3) 
gen grad =  (degree==4)
gen age2 = age^2 
gen black = (race==2)
gen other_r = (race==3)
gen unempl = (wrkstat==3 | wrkstat==4) // temp not working and unempl
gen nonlf = (wrkstat==5 | wrkstat==6 | wrkstat==7 | wrkstat==8)
*gen chld = (child>0)
* generate income per member
gen inc_pm = realinc/sqrt(hompop)
replace inc_pm = log(inc_pm)

*normilize
sum inc_pm
return list
gen inc_pm_m = r(mean)
gen inc_pm_sd = r(sd)
gen inc_pm_n = (inc_pm-inc_pm_m)/inc_pm_sd

drop _Iyear_2000

keep hppy inc_pm_n age age2 fem lefths bach grad mrd dvrcd widowed black other_r unempl nonlf _Iyear* wt_correction year 
order hppy inc_pm_n age age2 fem lefths bach grad mrd dvrcd widowed black other_r unempl nonlf _Iyear* wt_correction year 
save "GSS_working.dta", replace

sum inc_pm_n, detail
xtile inc_q = inc_pm_n, nq(4)
tab inc_q 

sum age, detail
xtile age_q = age, nq(4)
tab age_q

*drop group
egen group=group(inc_q age_q fem lefths bach grad)
sum group

drop inc_q age_q

keep hppy inc_pm_n age age2 fem lefths bach grad mrd dvrcd widowed black other_r unempl nonlf _Iyear* wt_correction year group
order hppy inc_pm_n age age2 fem lefths bach grad mrd dvrcd widowed black other_r unempl nonlf _Iyear* wt_correction year group

export delimited hppy inc_pm_n age age2 fem lefths bach grad mrd dvrcd widowed black other_r unempl nonlf _Iyear* wt_correction year group  using "GSS_working_even.csv", nolabel replace
