** Complete VS incomplete **
* Table A1 *
bysort treatment: tabstat contribution belief_contribution punish_used belief_punish, by(completed) format(%3.2f) nototal

bysort treatment: ranksum contribution, by(completed)
bysort treatment: ranksum belief_contribution, by(completed)
bysort treatment: ranksum punish_used, by(completed)
bysort treatment: ranksum belief_punish, by(completed)


quietly: tobit contribution treatment_real belief_contribution gender age language income_max trust risk instruction completed if treatment_punish == 0, ll(0) ul(20) vce(cluster id_sub)
test completed = 0

quietly: tobit contribution treatment_real belief_contribution gender age language income_max trust risk instruction completed if treatment_punish == 1, ll(0) ul(20) vce(cluster id_sub)
test completed = 0

quietly: tobit contribution treatment_punish belief_contribution gender age language income_max trust risk instruction completed if treatment_real == 0, ll(0) ul(20) vce(cluster id_sub)
test completed = 0

quietly: tobit contribution treatment_punish belief_contribution gender age language income_max trust risk instruction completed if treatment_real == 1, ll(0) ul(20) vce(cluster id_sub)
test completed = 0