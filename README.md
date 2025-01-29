# ConceptualVariableDesign
Accompanying Material for the Book: Conceptual Variable Design for Scorecards 1st Edition.

All codes beginning with "Code" correspond to the codes presented in the book.
Please notice that for Univariable Analysis, ICRM and All-Subsets are covered by multiple code illustrations in the book. That's why I've included the multiple references for each of them in the corresponding names.
Also notice that I have included additional material that is not referenced in the book, but that you may find useful in your modeling endevaours.

EM Start Code.sas: Contains the start-up macros needed for metadata operations within Enterprise Miner.

Greenacre's_Method.sas: The Greenacre's Method is mentioned in the book, however no explanation or details are given. To use it in your diagrams please follow these instructions:
  1 Add and connect a new SAS Code node to your diagram (place it in a pertinent level of your analysis).
  2 In the SAS Code node properties click over "Variables". A new window will pop-up.
  3 In the new window set the variable property "USE" to "No" for all variables other than the nominal variable you want to analyze and the target variable.
  Considerations: The code is supposed to work in a loop fashion over multiple nominal variables, however, I haven't been able to use this feature properly. So, to analyze multiple nominal variables, simply add sequential SAS Code Nodes using the Greenacre's method and      repeat steps 2 and 3 for each corresponding variable.
  
Null Level Auto-Detection (NLAD).sas: The NLAD code is an experimental code that can perform a null analysis on all explanatory variables in the ABT, automatically rejecting all variables that fall below a pre-specified null level cutoff.





