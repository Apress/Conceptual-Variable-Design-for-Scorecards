%LET DIR=/warehouse/Models/Output_Logs;	/*If GENERATEOUTPUT=N then you must define the output path*/
%LET VIF=3;								/*VIF cutoff point for analysis*/
%LET LIB=&EM_LIB.;						/*Default Diagram library*/
%LET MDL=&EM_NODEID.;					/*Use the node ID as identifier for output tables*/
%LET USER=&SYSUSERID.;					/*User ID*/
%LET GENERATEOUTPUT=N;					/*N: Don't generate EM output, Y: Generate EM output*/
/*------------------------------------------------------------------------------
  --- Timestamp format for log and output
------------------------------------------------------------------------------*/
%LET DATESTART  	= %SYSFUNC(DATE());
%LET DATESTAMP  	= %SYSFUNC(SUM(&DATESTART.),YYMMDDN8.);
%LET TIMESTART  	= %SYSFUNC(TIME());
%LET TIMESTAMP  	= %STR(%SYSFUNC(SUM(&TIMESTART.),TIME8.0));
%LET TIMESTAMP2 	= %SYSFUNC(TRANWRD(&TIMESTAMP.,:,));
%LET TIMESTAMP3 	= %SYSFUNC(COMPRESS(&TIMESTAMP2.));
%LET DATETIMESTAMP 	= &DATESTAMP._&TIMESTAMP3.;
 
OPTIONS SYMBOLGEN MPRINT MLOGIC;
 
%MACRO M_ICRM
(
INPUTS=
,TARGET=
,LIB=
,DS=
,VIF=
,PARTITION_COL=
,PARTITION_VAL=
,MDL=
,GENERATEOUTPUT=
,LOG_PRINTTO=
,OUTPUT_PRINTTO=
)
;
	%LET TIMESTART = %SYSFUNC(DATETIME());
	/*------------------------------------------------------------------------------
	  		--- Start opt sas Parameters
	  ------------------------------------------------------------------------------*/
	DM LOG "CLEAR" CONTINUE;/*Clear current log*/
	DM 'ODSRESULTS' CLEAR;	/*Clear current results*/
	%IF %UPCASE(&GENERATEOUTPUT.)=N %THEN
	     %DO;
	           PROC PRINTTO
	                FILE="&OUTPUT_PRINTTO."
	                LOG="&LOG_PRINTTO."
	                NEW;
	           RUN;
	           ODS RESULTS OFF;	/*Stop saving html results*/
	           ODS OUTPUT CLOSE;/*Stop generating output*/
	           ODS HTML CLOSE; 	/*Stop generating html results*/
	           /*ODS LISTING CLOSE;/*stop saving results to listing (Only in SAS Base)*/
	     %END;
	/*------------------------------------------------------------------------------
	       	--- Declare global Collinearity free storage variable
	------------------------------------------------------------------------------*/
	%GLOBAL COLLIN_FREE_INPUTS;
	/*------------------------------------------------------------------------------
			--- Initialize macro variables
	------------------------------------------------------------------------------*/
	%LET CONFLICTS			=;
	%LET FIRST_DOMINANT		=;
	%LET SECOND_DOMINANT	=;
	%LET FIRST_VIF			=;
	%LET SECOND_VIF			=;
	%LET MAXDIM				=;
	%LET FIRST_LOADING		=;
	%LET SECOND_LOADING		=;
	/*------------------------------------------------------------------------------
	       --- Check for partition
	------------------------------------------------------------------------------*/
	%LET VPART=;
	%IF %LENGTH(&PARTITION_COL.)>0 %THEN
	     %LET VPART=%STR(WHERE &PARTITION_COL. = "&PARTITION_VAL." ;);
	/*------------------------------------------------------------------------------------------
			--- Create table with all columns names
	------------------------------------------------------------------------------------------*/
	PROC CONTENTS
	           DATA=&DS.
	           OUT=VARIABLES_NAMES;
	RUN;
	/*------------------------------------------------------------------------------------------
			--- Create table to store interval variables name
	------------------------------------------------------------------------------------------*/	 
	PROC SQL;
		CREATE TABLE NAMES(NAME CHAR(200));
	QUIT;
	/*------------------------------------------------------------------------------------------
			--- Execute loop to populate the NAMES table
	------------------------------------------------------------------------------------------*/	 
	%LET ND=%SYSFUNC(COUNTW(&INPUTS.));
	%LET QUOTE_INPUTS=;
	%DO I1=1 %TO &ND. %BY 1;
		%LET VAR = %SCAN(&INPUTS.,&I1.,' ');
		PROC SQL;
			INSERT INTO NAMES VALUES("&VAR.");
		QUIT;
	%END;
	/*------------------------------------------------------------------------------------------
			--- Create catalog considering only the interval inputs
	------------------------------------------------------------------------------------------*/
	PROC SQL;
	     CREATE TABLE VARIABLES_INPUTS
	     AS
	     SELECT
	     DISTINCT NAME
	     FROM VARIABLES_NAMES
	     WHERE NAME IN (SELECT NAME FROM NAMES)
	     ;
	QUIT;
	/*------------------------------------------------------------------------------------------
			--- Execute initial regression to check for perfect linear combinations
	------------------------------------------------------------------------------------------*/	 
	PROC REG
	     DATA=&DS.
	     PLOTS(MAXPOINTS=NONE)
	     ;
	     &VPART.
	     MODEL &TARGET.=&INPUTS./COLLIN VIF TOL;
	
		ODS OUTPUT
		     COLLINDIAG=CD_REG
		     PARAMETERESTIMATES=PE_REG
		;
	RUN;
	/*------------------------------------------------------------------------------------------
			--- Delete variables that are linear function of other variables 
	------------------------------------------------------------------------------------------*/
	PROC SQL;
		DELETE FROM VARIABLES_INPUTS 
		WHERE COMPRESS(NAME) IN (SELECT COMPRESS(VARIABLE) FROM PE_REG WHERE ESTIMATE=0 OR VARIANCEINFLATION IS NULL);

		SELECT 
		COMPRESS(NAME)
		INTO
		:NEW_INPUTS SEPARATED BY " "
		FROM VARIABLES_INPUTS
		;
	QUIT;
	%LET INPUTS=&NEW_INPUTS.;
	/*------------------------------------------------------------------------------------------
			--- Rerun regression free of linear functions and create collinearity statistics
	------------------------------------------------------------------------------------------*/
	PROC REG
       	DATA=&DS.
       	PLOTS(MAXPOINTS=NONE)
       	;
 		&VPART.
 		MODEL &TARGET.=&INPUTS./COLLIN VIF TOL;

		ODS OUTPUT
		     COLLINDIAG=CD_REG
		     PARAMETERESTIMATES=PE_REG
		;
	RUN;
	/*------------------------------------------------------------------------------------------
			--- Check if the present model has collinearity issues
	------------------------------------------------------------------------------------------*/
	TITLE 'Initial Number of conflicts';
	PROC SQL;
		SELECT
		COUNT(DISTINCT VARIABLE) INTO :CONFLICTS
		FROM PE_REG
		WHERE
		     VARIANCEINFLATION>=&VIF.
		;
	QUIT;
	 
	%LET N=0;
	 
	%IF &CONFLICTS.=0 %THEN
	     %LET COLLIN_FREE_INPUTS=&INPUTS.;
	/*------------------------------------------------------------------------------------------
			--- If that so, initiate main loop
	------------------------------------------------------------------------------------------*/
	%LET K=0;
	%DO %WHILE(&CONFLICTS.>0);
	     /*------------------------------------------------------------------------------------------
	     		--- Get the most conflicting variavle
	     ------------------------------------------------------------------------------------------*/
	     TITLE "The first dominant variable and its VIF";
	     PROC SQL;
	           SELECT
	           COMPRESS(VARIABLE)
	           ,VARIANCEINFLATION
	           INTO
	           :FIRST_DOMINANT
	           ,:FIRST_VIF
	           FROM PE_REG
	           HAVING
	                VARIANCEINFLATION=MAX(VARIANCEINFLATION)
	           ;
	     QUIT;
	     /*------------------------------------------------------------------------------------------
	     		--- Get the maximum loading for this variable and its component (dimension)
	     ------------------------------------------------------------------------------------------*/
	     TITLE "Maximum dimension for the first dominant variable";
	     PROC SQL;
	           SELECT
	           STRIP(PUT(NUMBER,9.)) INTO :MAXDIM
	           FROM CD_REG
	           HAVING
	                &FIRST_DOMINANT.=MAX(&FIRST_DOMINANT.)
	           ;
	     QUIT;
	     TITLE "Loading for the first dominant";
	     PROC SQL;
	           SELECT
	           MAX(&FIRST_DOMINANT.) INTO :FIRST_LOADING
	           FROM CD_REG
	           ;
	     QUIT;
	     /*------------------------------------------------------------------------------------------
	     		--- Transpose the collinearity diagnostics
	     ------------------------------------------------------------------------------------------*/
	     PROC TRANSPOSE
	           DATA=CD_REG
	           OUT=CD_REG_T (DROP=_LABEL_)
	           PREFIX=COMPONENT
	           NAME=INT_VARIABLE
	     ;
	           VAR
	                &INPUTS.
	                ;
	     RUN;
	     /*------------------------------------------------------------------------------------------
	     		--- Get the second greatest loading for that component
	     ------------------------------------------------------------------------------------------*/
	     TITLE "The second dominant variable for the &MAXDIM. component";
	     PROC SQL;
	           SELECT
	           COMPRESS(INT_VARIABLE) INTO :SECOND_DOMINANT
	           FROM CD_REG_T
	           WHERE
	                INT_VARIABLE NE "&FIRST_DOMINANT."
	           HAVING COMPONENT&MAXDIM.=MAX(COMPONENT&MAXDIM.)
	           ;
	     QUIT;
	     /*------------------------------------------------------------------------------------------
	     		--- Get the VIF for the second dominant variable
	     ------------------------------------------------------------------------------------------*/
	     TITLE "VIF for the second dominant variable";
	     PROC SQL;
	           SELECT
	           VARIANCEINFLATION
	           INTO
	           :SECOND_VIF
	           FROM PE_REG
	           WHERE  VARIABLE="&SECOND_DOMINANT."
	           ;
	     QUIT;
	     TITLE "Loading for the second dominant variable for the component &MAXDIM.";
	     PROC SQL;
	           SELECT
	           MAX(COMPONENT&MAXDIM.) INTO :SECOND_LOADING
	           FROM CD_REG_T
	           WHERE
	                INT_VARIABLE NE "&FIRST_DOMINANT."
	           ;
	     QUIT;
	     %IF &FIRST_LOADING.>&SECOND_LOADING. %THEN
	           %LET REJECT=&SECOND_DOMINANT.;
	     %ELSE
	           %LET REJECT=&FIRST_DOMINANT.;
	     /*------------------------------------------------------------------------------------------
	     		--- Get rid off the conflicting variable
	     ------------------------------------------------------------------------------------------*/
	     PROC SQL;
	         DELETE FROM VARIABLES_INPUTS WHERE COMPRESS(NAME)=COMPRESS("&REJECT.");
	         DELETE FROM VARIABLES_INPUTS 
				WHERE COMPRESS(NAME) IN (SELECT COMPRESS(VARIABLE) FROM PE_REG WHERE ESTIMATE=0);
	 
	         SELECT
	           COMPRESS(NAME)
	           INTO
	           :NEW_INPUTS SEPARATED BY " "
	           FROM VARIABLES_INPUTS
	           ;
	     QUIT;
	     %LET INPUTS=&NEW_INPUTS.;
	     /*------------------------------------------------------------------------------------------
	     		--- Run the linear regression and generate the collinearity diagnostics
	     ------------------------------------------------------------------------------------------*/
	     PROC REG
            DATA=&DS.
            PLOTS(MAXPOINTS=NONE)
            ;
           	&VPART.
           	MODEL &TARGET.=&INPUTS./COLLIN VIF TOL;

			ODS OUTPUT
			     COLLINDIAG=CD_REG
			     PARAMETERESTIMATES=PE_REG
			;
		RUN;
	     /*------------------------------------------------------------------------------------------
	     		--- Check if collinearity is still present
	     ------------------------------------------------------------------------------------------*/
	     TITLE 'VARIABLES WITH CONLLINEARITY ISSUES';
	     PROC SQL;
		     SELECT
		     COUNT(DISTINCT VARIABLE) INTO :CONFLICTS
		     FROM PE_REG
		     WHERE
		           VARIANCEINFLATION>=&VIF.
		     ;
	     QUIT;
	 
	     TITLE;
	 
	     %LET N=%EVAL(&N.+1);
		 %LET K=%EVAL(&K.+1);
	%END;
	/*---------------------------------------------------------------------------------------------------------------------------------
			--- Save results to desire location
	----------------------------------------------------------------------------------------------------------------------------------*/
	PROC SQL;
	   CREATE TABLE &EM_LIB..ICRM_RESULTS_&MDL.
	   AS
	   SELECT
		*
	   FROM PE_REG
	   ;
	QUIT;
	 
	PROC SQL;
	   SELECT
		VARIABLE
		INTO
		:INPUTS SEPARATED BY " "
	   FROM PE_REG
	   WHERE VARIANCEINFLATION<&VIF. AND VARIANCEINFLATION IS NOT NULL
	   ;
	QUIT;
	 
	%LET COLLIN_FREE_INPUTS=&INPUTS.;
	/*---------------------------------------------------------------------------------------------------------------------------------
			--- Applied code in order to set the new metadata
	----------------------------------------------------------------------------------------------------------------------------------*/
	%LET VARLIST= &COLLIN_FREE_INPUTS.;
	 
	%LET VARLIST=%ENQUOTE(&VARLIST.,SEPARATOR=);
	%METADATA(NEWROLE=REJECTED,WHERE=(NAME NOT IN (&VARLIST.) AND UPCASE(ROLE)='INPUT' AND UPCASE(LEVEL)='INTERVAL'));
	/*------------------------------------------------------------------------------
			--- Reset sas Parameters (Only in SAS Base)
	------------------------------------------------------------------------------*/
	/*PROC PRINTTO;
	           RUN;
	ODS RESULTS ON;
	ODS OUTPUT;
	ODS HTML;
	ODS LISTING;*/
	/*------------------------------------------------------------------------------
			--- Set timer parameters
	------------------------------------------------------------------------------*/
	%LET TIMEEND 	= %SYSFUNC(DATETIME());
	%LET TIMEDIFF 	= %SYSFUNC(SUM(&&TIMEEND., -&&TIMESTART.));
	%LET ELAPSED 	=  %SYSFUNC(SUM(&TIMEDIFF.), TIME8.);
	%LET START 		= %SYSFUNC(SUM(&TIMESTART.),DATETIME16.);
	%LET END 		= %SYSFUNC(SUM(&TIMEEND.),DATETIME16.);
	/*__________________________________________________________________________________________*/
	%PUT >>>  STATUS: ICRM macro terminated  <<<;
	%PUT >>>  PROCESS: &N. Variables processed  <<<;
	%PUT >>>  CYCLES: &N. Regressions carried out  <<<;
	%PUT >>>  TIME: Started at &START. and terminated at &END.   <<<;
	%PUT >>>  ELAPSED: &ELAPSED.  <<<;
 
%MEND M_ICRM;
 
 
%M_ICRM(
INPUTS=%EM_INTERVAL_INPUT
,TARGET=%EM_BINARY_TARGET
,LIB=&EM_LIB.
,DS=&EM_IMPORT_DATA.
,VIF=&VIF.
,PARTITION_COL=
,PARTITION_VAL=
,MDL=&MDL.
,GENERATEOUTPUT=&GENERATEOUTPUT.
,LOG_PRINTTO=&DIR./&DATETIMESTAMP._&USER._ICRM_LOG_&MDL..LOG
,OUTPUT_PRINTTO=&DIR./&DATETIMESTAMP._&USER._ICRM_OUTPUT_&MDL..OUT
);