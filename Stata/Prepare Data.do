** Label Dataset **
label data "PGG real/hypothetical with/without punishment"

** Recode variables **
* subject index *
generate id_sub = _n, before(participantcode)
* group index *
egen id_group = seq(), block(3)
order id_group, after(id_sub)
* payoff bonus *
gen payoff_bonus = payoff_total - payoff_fixed, after(payoff_total)
* language *
replace language = 0 if language == 2
* gender *
replace gender = 0 if gender == 2
replace gender = 2 if gender == 3
* trust *
replace trust = 0 if trust == 2
* group contribution *
generate group_contribution_avg = group_contributions/3, after(group_contributions)
* treatments *
gen treatment_real = (playertreatment=="real")
gen treatment_punish = (playertreatment_punish == "punish")
egen treatment = group(treatment_punish treatment_real)
order treatment, after(playertreatment)
order treatment_real, after(treatment)
order treatment_punish, after(treatment_real)
drop playertreatment playertreatment_punish
gen completed = (finished == "complete"), after(sessioncode)
drop finished

** Label variables **
label variable id_sub "Subject Index"
label variable participantcode "Participant code"
label variable sessioncode "Session code"
label variable completed "Complete observation"
label variable id_group "Group index"
label variable id_in_group "In in group"
label variable treatment "Treatment"
label variable treatment_real "Treatment real"
label variable treatment_punish "Treatment punishment"
label variable contribution "Contribution"
label variable belief_contribution "Belief contributions"
label variable contribution_others "Others' Contributions"
label variable punish_1 "Punishment player 1"
label variable punish_2 "Punishment player 2"
label variable punish_3 "Punishment player 3"
label variable punish_used "Total punishment assigned"
label variable belief_punish_1 "Belief punishment player 1"
label variable belief_punish_2 "Belief punishment player 2"
label variable belief_punish_3 "Belief punishment player 3"
label variable belief_punish "Expected total punishment"
label variable payoff_bonus_1 "Bonus after Stage 1"
label variable payoff_bonus_2 "Bonus after Stage 2"
label variable payoff_fixed "Participation fee"
label variable payoff_total "Payoff (pounds)"
label variable payoff_bonus "Bonus Payoff (pounds)"
label variable points_1 "Payoff Stage 1 (points)"
label variable points_2 "Payoff Stage 2 (points)"
label variable punish_received "Total punishment received"
label variable punish_points_received "Punishment points received"
label variable group_contributions "Group contributions"
label variable group_contribution_avg "Group average contribution"
label variable group_payoff "Group payoff"
label variable share_total "Individual share"
label variable gender "Gender"
label variable age "Age"
label variable language "English native"
label variable income_max "Money maximizer"
label variable trust "Trust"
label variable risk "Risk aversion"
label variable instruction "Instruction difficulty"
label variable econ_exp "Past economic experiments"

** Label Values **
label define treatments 1 "Hypo-NoPunish" 2 "Real-NoPunish" 3 "Hypo-Punish" 4 "Real-Punish" 
label values treatment treatments
label define treatments_real 1 "Real" 0 "Hypothetical"
label values treatment_real treatments_real
label define treatments_punish 1 "Punishment" 0 "No punishment"
label values treatment_punish treatments_punish
label define completion 1 "Complete" 0 "Incomplete"
label values completed completion
label define genders 1 "Male" 0 "Female" 2 "Other"
label values gender genders
label define languages 1 "English" 0 "Non-English"
label values language languages
label define incomes 1 "Very important" 2 "Important" 3 "Indifferent" 4 "Not important" 5 "Not important at all"
label values income_max incomes
label define trusts 1 "Trust" 0 "Non-trust"
label values trust trusts
label define instructions 1 "Very difficult" 2 "Difficult" 3 "Neutral" 4 "Easy" 5 "Very easy"
label values instruction instructions