%LET varlist=
/*Aqui van las variables*/
;
 
%LET varlist=%enquote(&varlist,separator=);
%metadata(newrole=Rejected,where=(NAME not in (&varlist) and upcase(ROLE)='INPUT'));
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
