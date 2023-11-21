** Generate variables **
* Generate total punishment assigned *
egen punish_used_group = mean(punish_used), by(id_group)
* Generate total punishment expected *
egen punish_expected_group = mean(belief_punish), by(id_group)
** Tests (Observation 1) **
* Beliefs about contributions *
bysort treatment_real: ranksum belief_contribution if completed == 1, by(treatment_punish)
* Actual VS expected punishments *
bysort treatment_real: signrank punish_used_group = punish_expected_group if completed & treatment_punish & id_in_group == 1
* Actual punishment higher in hypo than real *
ranksum punish_used_group if treatment_punish == 1 & completed == 1 & id_in_group == 1, by(treatment_real)
* Beliefs about punishment between real and hypo *
ranksum punish_expected_group if treatment_punish == 1 & completed == 1, by(treatment_real)
* Drop temporary variables *
drop punish_used_group punish_expected_group
sort id_sub

** Tobit regressions of punishment (Table 3) **
* Generate contributions of other group members *
gen contribution_1 = contribution[_n+1] if id_in_group == 1, after(contribution)
replace contribution_1 = contribution[_n+1] if id_in_group == 2
replace contribution_1 = contribution[_n-2] if id_in_group == 3
gen contribution_2 = contribution[_n+2] if id_in_group == 1, after(contribution_1)
replace contribution_2 = contribution[_n-1] if id_in_group == 2
replace contribution_2 = contribution[_n-1] if id_in_group == 3
* Generate deviations of other contribution to own *
gen neg_dev_1 = contribution - contribution_1 if contribution > contribution_1, after(contribution_1)
replace neg_dev_1 = 0 if neg_dev_1 == .
gen neg_dev_2 = contribution - contribution_2 if contribution > contribution_2, after(contribution_2)
replace neg_dev_2 = 0 if neg_dev_2 == .
gen pos_dev_1 = contribution_1 - contribution if contribution < contribution_1, after(contribution_1)
replace pos_dev_1 = 0 if pos_dev_1 == .
gen pos_dev_2 = contribution_2 - contribution if contribution < contribution_2, after(contribution_2)
replace pos_dev_2 = 0 if pos_dev_2 == .
* Reshape dataset *
expand 2
gen replication = (_n>996)
sort id_sub
generate punishment = .
replace punishment = punish_2 if id_in_group == 1 & replication == 1
replace punishment = punish_3 if id_in_group == 1 & replication == 0
replace punishment = punish_3 if id_in_group == 2 & replication == 1
replace punishment = punish_1 if id_in_group == 2 & replication == 0
replace punishment = punish_1 if id_in_group == 3 & replication == 1
replace punishment = punish_2 if id_in_group == 3 & replication == 0
replace punishment = -punishment
generate belief_punishment = .
replace belief_punishment = belief_punish_2 if id_in_group == 1 & replication == 1
replace belief_punishment = belief_punish_3 if id_in_group == 1 & replication == 0
replace belief_punishment = belief_punish_3 if id_in_group == 2 & replication == 1
replace belief_punishment = belief_punish_1 if id_in_group == 2 & replication == 0
replace belief_punishment = belief_punish_1 if id_in_group == 3 & replication == 1
replace belief_punishment = belief_punish_2 if id_in_group == 3 & replication == 0
label variable belief_punishment "Expected punishment"
* Generate positive deviations *
generate pos_dev = ., before(pos_dev_1)
replace pos_dev = pos_dev_1 if replication == 1
replace pos_dev = pos_dev_2 if replication == 0
label variable pos_dev "Abs. positive deviation"
* Generate negative deviations *
generate neg_dev = ., before(neg_dev_1)
replace neg_dev = neg_dev_1 if replication == 1
replace neg_dev = neg_dev_2 if replication == 0
label variable neg_dev "Abs. negative deviation"
* Generate deviation in single variable *
gen deviation = pos_dev
replace deviation  = -neg_dev if neg_dev >0
* Tobit regressions *
eststo m1: quietly ///
tobit punishment treatment_real group_contribution_avg neg_dev pos_dev belief_contribution belief_punishment if treatment_punish == 1 & completed, vce(cluster id_group) ll(0) ul(10) 
eststo m2: quietly ///
tobit punishment treatment_real group_contribution_avg neg_dev pos_dev belief_contribution belief_punishment gender age language income_max trust risk instruction if treatment_punish == 1 & completed, vce(cluster id_group) ll(0) ul(10) 
esttab m1 m2, ///
mlabels("Punishment" "Punishment") ///
indicate(Controls = gender age language income_max trust risk instruction) starlevels(* 0.10 ** 0.05 *** 0.01) se pr2 label nonumber nonotes noomitted eqlabel("") nobaselevels b(3) obslast replace type ///
addnotes( ///
"Controls: gender, age, language, income maximisation, trust, risk, understanding " ///
"Std. Err. adjusted for 166 subject clusters in parentheses" ///
"\sym{*} \(p<0.10\), \sym{**} \(p<0.05\), \sym{***} \(p<0.01\)")

** Graph of punishment function (Figure 2) **
twoway ///
	(scatter punishment deviation if treatment_real == 0 & punishment > 0, mcolor(navy)) ///
	(scatter punishment deviation if treatment_real == 1 & punishment > 0, mcolor(orange)) ///
	(lowess punishment deviation if treatment_real == 0, lcolor(navy%50)) ///
	(lowess punishment deviation if treatment_real == 1, lcolor(orange%50)) ///
	if treatment_punish == 1 & completed == 1, ///
	ylabel(, nogrid) ///
	ytitle("Punishment assigned (maximum of 10 points)") ///	
	xtitle("Deviation from own contribution") ///
	legend(order(1 "Hypothetical" 2 "Incentivised") position(bottom) rows(1)) /// 
	name("Figure2")
gr_edit .style.editstyle boxstyle(shadestyle(color(white))) editcopy
gr_edit style.editstyle boxstyle(linestyle(color(white))) editcopy