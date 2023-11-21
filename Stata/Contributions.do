** Contribution graph (Figure 1) **
preserve
** Store aggregate values **
statsby n=r(N) hicorr=r(ub) meancorr=r(mean) locorr=r(lb) if completed == 1, by(treatment) clear : ci mean contribution
replace treatment = 7 if treatment == 4
replace treatment = 5 if treatment == 3
replace treatment = 3 if treatment == 2
replace meancorr = round(meancorr, 0.01)
** Create graph
twoway ///
	(bar meancorr treatment if treatment == 1, color(navy%75)) ///
	(bar meancorr treatment if treatment == 3, color(orange%75)) ///
	(bar meancorr treatment if treatment == 5, color(navy%100)) ///
	(bar meancorr treatment if treatment == 7, color(orange%100)) ///
	(scatter meancorr treatment, msymbol(none) mlabel(meancorr) mlabposition(12)) ///
	(rcap hicorr locorr treatment, color(black%50)), ///
	ylabel(0 2 4 6 8 10, nogrid) ///
	legend(off) ///
	xlabel(1 "Hypo-NoPunish" 3 "Real-NoPunish" 5 "Hypo-Punish" 7 "Real-Punish", noticks) ///
	   ytitle("Contributions out of 20 tokens endowment") ///	
	   xtitle("Treatment") ///
	   title("") name("Figure1")
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
gr_edit .note.text = {}
gr_edit .note.text.Arrpush Lines in each bar indicate 95% confidence intervals 
restore

** Result 1 **
* Ranksum tests *
bysort treatment_punish: ranksum contribution if completed == 1, by(treatment_real)
* Tobit regressions of hypo vs real (Table 2a)
eststo nopunish: tobit contribution treatment_real if treatment_punish == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo nopunish_beliefs: tobit contribution treatment_real belief_contribution if treatment_punish == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo nopunish_beliefs_controls: tobit contribution treatment_real belief_contribution gender age language income_max trust risk instruction if treatment_punish == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo punish: tobit contribution treatment_real if treatment_punish == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo punish_beliefs: tobit contribution treatment_real belief_contribution if treatment_punish == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo punish_beliefs_controls: tobit contribution treatment_real belief_contribution gender age language income_max trust risk instruction if treatment_punish == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
esttab nopunish nopunish_beliefs nopunish_beliefs_controls punish punish_beliefs punish_beliefs_controls, star(* 0.10 ** 0.05 *** 0.01) ///
indicate(Controls = gender age language income_max trust risk instruction) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) obslast replace type b(%10.3f) ///
addnotes( ///
"Standard errors clustered at participant level in parentheses" ///
"Controls: gender, age, language, income maximisation, trust, risk, understanding" ///
"Significant levels: \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")

** Result 2 **
* Ranksum tests *
bysort treatment_real: ranksum contribution if completed == 1, by(treatment_punish)
* Tobit regressions of punish vs no punish (Table 2b)
eststo hypo: tobit contribution treatment_punish if treatment_real == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo hypo_beliefs: tobit contribution treatment_punish belief_contribution if treatment_real == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo hypo_beliefs_controls: tobit contribution treatment_punish belief_contribution gender age language income_max trust risk instruction if treatment_real == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo real: tobit contribution treatment_punish if treatment_real == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo real_beliefs: tobit contribution treatment_punish belief_contribution if treatment_real == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
eststo real_beliefs_controls: tobit contribution treatment_punish belief_contribution gender age language income_max trust risk instruction if treatment_real == 1 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
esttab hypo hypo_beliefs hypo_beliefs_controls real real_beliefs real_beliefs_controls, star(* 0.10 ** 0.05 *** 0.01) ///
indicate(Controls = gender age language income_max trust risk instruction) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) obslast replace type b(%10.3f) ///
addnotes( ///
"Standard errors clustered at participant level in parentheses" ///
"Controls: gender, age, language, income maximisation, trust, risk, understanding" ///
"Significant levels: \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")
