# ConceptualVariableDesign
Accompanying Material for the Book: Conceptual Variable Design for Scorecards 1st Edition.

All codes beginning with "Listing" correspond to the codes presented in the book.
Please note that the files Listing 13- Univariable Analysis (complete).sas, Listing 14- ICRM (complete).sas, and Listing 16- All Subsets with Mallows' Cq (complete).sas contain the complete version of the corresponding file: Univariable Analysis, ICRM, and All Subsets, presented with multiple figures alongside the explanatory text. 
Note also that I have included additional material (bonus) that is not referenced in the book, but that you may find useful in your modeling endeavors.

Listing 11- Utility Macros for EM Start Code (complete).sas: Contains the start-up macros needed for metadata operations within Enterprise Miner.

Bonus Greenacre's_Method.sas: The Greenacre's Method is mentioned in the book, but no explanation or details are given. To use it in your diagrams, please follow these instructions:
  1 Add and connect a new SAS Code node to your diagram (place it at an appropriate level of your analysis).
  2 In the SAS Code node properties, click on "Variables". A new window will appear.
  3 In the new window, set the "USE" variable property to "No" for all variables other than the nominal variable you want to analyze and the target variable.
  Considerations: The code is supposed to work in a loop over multiple nominal variables, but I wasn't able to use this feature properly. To analyze multiple nominal variables, simply add sequential SAS code nodes using Greenacre's method and repeat steps 2 and 3 for each corresponding variable.
  
Bonus Null Level Auto-Detection (NLAD).sas: The NLAD code is an experimental code that can perform a null analysis on all explanatory variables in the ABT, automatically rejecting those that fall below a pre-specified null level cutoff.





