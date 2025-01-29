%LET varlist= ;

%LET varlist=%enquote(&varlist,separator=);

%metadata(newrole=Rejected	,where=(NAME NOT IN (&varlist) 	and upcase(ROLE)='INPUT'));