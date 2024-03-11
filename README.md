# LewisFlaxFrostStress
R and SAS script for Gossweiler et al 2023, "Survival analysis of freezing stress in the North American native perennial flax, Linum lewisii Pursh"

This repository contains all the R and SAS scripts to reproduce results and figures. 
Figures 1-5 and S1-2 all have similarly named R scripts that were used to create them. 

'sample scripts Gossweiler et al 2024.sas' serves as a simplified example of the code used for SAS analyses in this paper.

The code within 'FreezeCombinedOutput.sas' contains the all analyses performed in SAS 9.4. This was the script of primary use, and has not been parsed out for simple use. This exists for transparency, components of the SAS analyses can be found in the respective 'Height' , 'Survival', and 'Correlation' scripts. Data transformation steps may exist within each step and each requires data files which may be better illustrated within the SAS and R Markdown file.
