** Subsection 3.1 **
* Violin plots of contibutions (Figure 1) *
violinplot contribution if treatment_punish == 0 & completed == 1, over(treatment) box vertical fill ylabel(,nogrid) name("Figure1")
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy
graph export "../Graphs/violin_pgg_standard.png", replace
* Ranksum tests (Result 1) *
ranksum contribution if treatment_punish == 0 & completed == 1, by(treatment_real)
* Tobit regressions of hypo vs real (Table 2)
quietly eststo nopunish: tobit contribution treatment_real if treatment_punish == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
quietly eststo nopunish_beliefs: tobit contribution treatment_real belief_contribution if treatment_punish == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
quietly eststo nopunish_beliefs_controls: tobit contribution treatment_real belief_contribution gender age language income_max trust risk instruction if treatment_punish == 0 & completed == 1, ll(0) ul(20) vce(cluster id_sub)
esttab nopunish nopunish_beliefs nopunish_beliefs_controls using "../Tex/tobit_pgg_standard.tex", star(* 0.10 ** 0.05 *** 0.01) ///
indicate(Controls = gender age language income_max trust risk instruction) se r2 label nonumber nonotes noomitted nobaselevels interaction(*) obslast replace type b(%10.3f) ///
addnotes( ///
"Standard errors clustered at participant level in parentheses." ///
"Controls: gender, age, language, income maximisation, trust, risk, understanding." ///
"Significant levels: \sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\).")

drop _est*
