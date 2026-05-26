** Farah abdel-Jawad **
/* 
PROJECT: Somalia Capstone Project

PURPOSE: To apply inverse probability weighting to correct for non-response bias in the survey sample. To use regressions to predict survey participation based on gender and location (by district), then generating the weights. To tun weighted cross-tabulations and mean comparisons for important variables.

INPUT:    full_contact.dta  (full contact list including non-respondents)

OUTPUT:   full_contact_weighted.dta or full_contact_weighted.csv
*/

use "full_contact.dta", clear

* Keep only sampled individuals (drop those never contacted)
drop if sampled == 0

***Step 1: Estimate probability of survey response
*Logistic regression predicting survey participation from gender and location
logit surveyed i.female i.location
predict phat, pr

*Generate inverse probability weights (higher weight = less likely to respond)
gen ipw = 1 / phat

***Step 2: Declare survey design with IPW weights
svyset [pw=ipw]

***Step 3: Weighted cross-tabulations
* Healthcare and public services preferences
svy: tab mch_funder        // Who funds nearest maternal health clinic?
svy: tab hc_pref           // Healthcare scenario preference
svy: tab school_pref       // School scenario preference
svy: tab willing_insurance10  // Willing to pay 10% income for health insurance?

*Trust in diff govs
svy: tab trust_dist        // Trust in district government
svy: tab trust_fms         // Trust in federal member state
svy: tab trust_fgs         // Trust in federal government

***Step 4: Tax willingness by gender
svy: tab tax_willing
svy: tab tax_willing gender
svy: mean tax_willing, over(gender)

*Test whether willingness to pay taxes differs significantly by gender
test _b[c.tax_willing@0bn.gender] = _b[c.tax_willing@1.gender]

***Step 5: Clan taxation analysis
svy: tab clan_tax
svy: tab clan_tax gender

*Test whether age differs between those who do/don't pay clan tax
svy: mean age, over(clan_tax)
test _b[c.age@0bn.clan_tax] = _b[c.age@1.clan_tax]

*Test whether income differs between those who do/don't pay clan tax
destring income_mid, replace
svy: mean income_mid, over(clan_tax)
test _b[c.income_mid@0bn.clan_tax] = _b[c.income_mid@1.clan_tax]

*Clan tax by gender subgroups and frequency
svy: tab clan_tax_allmen
svy: tab clan_tax_female
svy: tab clan_tax_freq
svy: tab clan_tax_freq gender

***Step 6: Likelihood of receiving clan financial support
svy: tab csupp_likely

***Step 7: Export weighted dataset
save "full_contact_weighted.dta", replace
export delimited using "full_contact_weighted.csv", replace
