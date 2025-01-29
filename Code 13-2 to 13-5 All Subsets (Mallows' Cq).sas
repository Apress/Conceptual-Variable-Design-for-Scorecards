%LET EM_PROPERTY_MODELSPERLEVEL = 10; 	/*Number of models to show per level*/
%LET EM_PROPERTY_MININPUTS      = 1; 	/*Minimum number of inputs*/
%LET EM_PROPERTY_MAXINPUTS      = MAX;	/*Max number of inputs*/
%LET MDL=&EM_NODEID.;					/*Use the node ID as identifier for output tables*/
%LET LIB=&EM_LIB.;						/*Default Diagram library*/

/*------------------------------------------------------------------------------
  		--- Set the EM_REGISTER macro for chart generation
------------------------------------------------------------------------------*/  
%EM_REGISTER(KEY=ASSESS,TYPE=DATA);
%EM_REGISTER(KEY=MALLOWS_CQ,TYPE=DATA);

/*------------------------------------------------------------------------------
  		--- Set start and stop parameters
------------------------------------------------------------------------------*/ 
** stop=maxinputs value or count(# interval inputs);
%LET STOP=%SCAN(&EM_PROPERTY_MAXINPUTS. %NLIST(%EM_INTERVAL_INPUT),
                %EVAL((%INDEX(%UPCASE(&EM_PROPERTY_MAXINPUTS.),MAX)>0)+1));
** start=min(max(mininput value,1),stop);
%LET START=%SYSFUNC(MIN(%SYSFUNC(MAX(&EM_PROPERTY_MININPUTS.,1)),&STOP.));
 
ODS LISTING CLOSE;
ODS OUTPUT BESTSUBSETS=WORK.SCORE
       RESPONSEPROFILE=WORK.PROFILE;
/*------------------------------------------------------------------------------
  		--- Execute logistic regression with the "SCORE" option for all subsets
------------------------------------------------------------------------------*/
PROC LOGISTIC DATA=&EM_IMPORT_DATA. DES NAMELEN=200;
   MODEL %EM_BINARY_TARGET=%EM_INTERVAL_INPUT / SELECTION=SCORE
                                                BEST=&EM_PROPERTY_MODELSPERLEVEL.
                                                START=&START.
                                                STOP=&STOP.;
RUN;
/*------------------------------------------------------------------------------
  		--- Estimate Mallows Cq
------------------------------------------------------------------------------*/
PROC SQL;
CREATE TABLE &EM_LIB..MALLOWS_CQ_&MDL.
AS
	SELECT
	VARIABLESINMODEL AS MDLCOV 'Model Covariates'
	,NUMBEROFVARIABLES AS INPUT_COUNT
	,SCORECHISQ AS SQ 'Sq'
	,SP-SCORECHISQ+2*NUMBEROFVARIABLES-P+1 AS CQ 'Cq'
	,NUMBEROFVARIABLES+1 AS CQ_CRITERION LABEL='Cq Criterion'
	FROM
	WORK.SCORE A
	,(
	SELECT
	MAX(SCORECHISQ) AS SP
	,MAX(NUMBEROFVARIABLES) AS P
	FROM WORK.SCORE) B
	;
QUIT;
/*------------------------------------------------------------------------------
  		--- Sort by number of inputs and Cq
------------------------------------------------------------------------------*/ 
PROC SORT
		DATA=&EM_LIB..MALLOWS_CQ_&MDL.
		THREADS
		SORTSIZE=MAX;
	BY
		INPUT_COUNT
		CQ;
RUN;
/*------------------------------------------------------------------------------
  		--- Models numbered by complexity
------------------------------------------------------------------------------*/  
DATA &EM_USER_MALLOWS_CQ.;
	RETAIN BEST;
	SET
		&EM_LIB..MALLOWS_CQ_&MDL. END=LAST;
	BY
		INPUT_COUNT;
	IF FIRST.INPUT_COUNT THEN
		BEST=0;
	BEST+1;
RUN;
 
ODS LISTING;
/*------------------------------------------------------------------------------
  		--- Generate output charts
------------------------------------------------------------------------------*/   
%EM_REPORT(KEY=MALLOWS_CQ,
           DESCRIPTION=ALL SUBSETS REGRESSION ASSESSMENT BY MODEL COMPLEXITY (MALLOS CQ),
           GROUP=BEST,
           VIEWTYPE=LINEPLOT,
           X=INPUT_COUNT,
           Y1=CQ,
		   Y2=CQ_CRITERION,
           AUTODISPLAY=Y);

/*---------------------------------------------------------------------------------------------------------------------------------
 		--- Select best model based on Mallows criterion
----------------------------------------------------------------------------------------------------------------------------------*/
PROC SQL;
SELECT
MDLCOV INTO :SIGNIFICANT
FROM &LIB..MALLOWS_CQ_&MDL.
WHERE CQ<=CQ_CRITERION
AND CQ=(SELECT MIN(CQ) FROM &LIB..MALLOWS_CQ_&MDL. WHERE CQ<=CQ_CRITERION)
;
QUIT;
 
/*------------------------------------------------------------------------------
  		--- Run Logistic Regression with best subset
------------------------------------------------------------------------------*/	
PROC LOGISTIC
	DATA=&EM_IMPORT_DATA.
	NAMELEN=200
	;
	MODEL  %EM_BINARY_TARGET (EVENT='1')=  &SIGNIFICANT.
	/
	LINK=GLOGIT
	CLPARM=WALD
	TECH=NEWTON
	;
RUN;
ODS OUTPUT
	TYPE3=&LIB..T3_ALLSUBSETS_&MDL.
;
 
/*---------------------------------------------------------------------------------------------------------------------------------
		--- Applied code in order to set the new metadata|--
----------------------------------------------------------------------------------------------------------------------------------*/
%LET VARLIST= &SIGNIFICANT.;
 
%LET VARLIST=%ENQUOTE(&VARLIST.,SEPARATOR=);
%METADATA(NEWROLE=REJECTED,WHERE=NAME NOT IN (&VARLIST.) AND UPCASE(ROLE)='INPUT');

 
 
 
 
 
 
 
