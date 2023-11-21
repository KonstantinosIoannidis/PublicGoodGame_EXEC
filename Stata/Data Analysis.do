** Prepare raw experimental data **
import delimited "..\Data\Experimental Data.csv", encoding(UTF-8) clear
run "..\Stata\Prepare Data.do"

** Demographics **
tabstat payoff_total payoff_bonus age gender language risk trust income_max instruction if completed == 1, by(treatment) format(%3.2f)

** Results **
do "..\Stata\Contributions".do"
do "..\Stata\Punishments".do"

** Appendix **
do "..\Stata\Complete-Incomplete".do"

