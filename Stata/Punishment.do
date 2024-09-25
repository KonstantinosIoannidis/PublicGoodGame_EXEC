* Tobit regressions of the effect of punishment (Table A1) *
eststo hypo: quietly ///
tobit contribution treatment_punish if treatment_real == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo hypo_beliefs: quietly ///
tobit contribution treatment_punish belief_contribution if treatment_real == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo hypo_beliefs_controls: quietly ///
tobit contribution treatment_punish belief_contribution gender language trust risk if treatment_real == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo real: quietly ///
tobit contribution treatment_punish if treatment_real == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo real_beliefs: quietly ///
tobit contribution treatment_punish belief_contribution if treatment_real == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo real_beliefs_controls: quietly ///
tobit contribution treatment_punish belief_contribution gender language trust risk if treatment_real == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
esttab hypo hypo_beliefs hypo_beliefs_controls real real_beliefs real_beliefs_controls using "../Tex/tobit_punishments.tex", ///
mlabels("Contribution" "Contribution" "Contribution" "Contribution" "Contribution" "Contribution") ///
indicate(Controls = gender language trust risk) starlevels(* 0.10 ** 0.05 *** 0.01) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) obslast replace type b(%10.3f) ///
addnotes("Controls: gender, age, language, income maximisation, trust, risk." ///
"Standard errors clustered at matching group level in parentheses." ///
"\sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)".)

* Generate total punishment assigned *
egen punish_used_group = mean(punish_used), by(id_group)
* Generate total punishment expected *
egen punish_expected_group = mean(belief_punish), by(id_group)
* Beliefs about contributions *
bysort treatment_real: ranksum belief_contribution if completed == 1, by(treatment_punish)
// * Actual VS expected punishments *
// bysort treatment_real: signrank punish_used_group = punish_expected_group if completed & treatment_punish & id_in_group == 1
// * Beliefs about punishment between real and hypo *
// ranksum punish_expected if treatment_punish == 1 & completed == 1, by(treatment_real)
// ranksum punish_expected_group if treatment_punish == 1 & completed == 1 & id_in_group == 1, by(treatment_real)
* Drop temporary variables *
drop punish_used_group punish_expected_group _est*
sort id_sub
