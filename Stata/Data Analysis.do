** Prepare raw experimental data **
import delimited "../Data/Experimental Data.csv", encoding(UTF-8) clear
run "../Stata/Prepare Data.do"

** Demographics (Table 1) **
tabstat payoff_total payoff_bonus age gender language risk trust income_max instruction if completed == 1, by(treatment) format(%3.2f)

** Results **
* PGG without punishment (subsection 3.1) *
do "../Stata/PGG_standard".do"
* PGG with punishment (subsection 3.2) *
do "../Stata/PGG_punish".do"


** Appendix **
* Effect of punishment (appendix A.1) *
do "../Stata/Punishment".do"
* Effect of punishment (appendix A.2) *
do "../Stata/Attrition".do"

