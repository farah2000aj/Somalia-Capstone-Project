** Farah abdel-Jawad **
/* 
PROJECT: Somalia Capstone Project

PURPOSE: Load raw survey data and drop admin/randomization variables that are not needed for analysis. Produces a clean .dta file ready for weighting and visualization.

INPUT:    cati_final_gu.dta  (raw survey data, N=882)

OUTPUT:   clean_cati_final_gu.dta
*/

clear
use "cati_final_gu.dta"

* Drop enumerator ID, consent flag, and all randomization-order variables (used for survey design only)

drop enum_name consent ///
     mch_funder_rand hc_pref_rand school_pref_rand ///
     trust_dist_rand trust_fms_rand trust_fgs_rand ///
     tax_willing_rand clan_tax_female_rand ///
     csupp_subclan_rand csupp_connection_rand csupp_need_rand ///
     csupp_severity_rand csupp_fundsavail_rand csupp_age_rand ///
     csupp_gender_rand csupp_likely_rand ///
     trust_dc_rand trust_hir_rand trust_gal_rand trust_punt_rand ///
     trust_sws_rand trust_fgspres_rand trust_imam_rand trust_aqil_rand

save "clean_cati_final_gu.dta", replace
