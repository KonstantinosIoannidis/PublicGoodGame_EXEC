## Description

This repository includes the data and the Stata code used in Drouvelis M., Ioannidis K., & Kallbekken S. (2024). [Monetary vs. hypothetical incentives: The case of public good games without and with punishment]().

### Abstract

Whether incentives matter for experimental research is one of the main methodological differences between economics and psychology. We study the effect of incentives on eliciting social preferences. To do so, we run two public good game experiments, one standard and one with punishment, varying whether the game is incentivised or hypothetical. We find that incentives affect behaviour in a standard public good game, but not in a public good game with punishment.

### Software

The analysis was conducted using ```Stata 18```.

### Files

The files are stored in two folders: Data, which contains data from the experiment and the meta analysis, and Stata, which contains the Stata code to produce every result in the paper.

1. Data
   * Experimental Data.csv (*The raw data from the experiment in csv format*)
   * Experimental Codebook.md (*Codebook for ```Experimental Data.csv```*)
2. Stata
   * Data Analysis.do (*Calls and executes all other files*)
   * Prepare Data.do (*Cleans raw experimental data and prepares it for analysis*)
   * Contributions.do (*Produces the results of Subsection 3.1, Figure 1 and Tables 2a and 2b*)
   * Punishments.do (*Produces the results of Subsection 3.2, Table 3 and Figure 2*)
   * Complete-Incomplete.do (*Produces results of Appendix A, Table 4*)

### Instructions
To run the code, you only need to run **Data Analysis.do**.

## Contributing

**[Konstantinos Ioannidis](http://konstantinosioannidis.com/)** 
For any questions, please email me here **ioannidis.a.konstantinos@gmail.com**.
