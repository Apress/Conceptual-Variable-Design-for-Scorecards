%LET DIR=/ebn/warehouse/Modelos/Output_Logs;
%LET MIN_NULL_LVL=0.60;					/*Null percentage cutoff (anything above this number will be rejected)*/
%LET NULL_GROUPING_COLS=PERIODO;		/*For stack ABTs the grouping variable for the analysis is reference period*/
FILENAME NULLCODE "&DIR/NULL_ANALYSIS_CODE_&MDL..SAS";  /*SAS PROC SQL code that carries out the null analysis by variable*/
FILENAME MNNLCODE "&DIR/MIN_NULL_LEVEL_CODE_&MDL..SAS"; /*SAS PROC SQL code that selects the minimum null level found across all available periods*/
%LET LIB=&EM_LIB.;						/*Default Diagram library*/
%LET MDL=&EM_NODEID.;					/*Use the node ID as identifier for output tables*/
%LET USER=&SYSUSERID;					/*User ID*/
%LET GENERATEOUTPUT=N;					/*N: Don't generate EM output, Y: Generate EM output*/
/*------------------------------------------------------------------------------
  --- Timestamp format for log and output
------------------------------------------------------------------------------*/
%LET DATESTART  	= %SYSFUNC(DATE());
%LET DATESTAMP  	= %SYSFUNC(SUM(&DATESTART),YYMMDDN8.);
%LET TIMESTART  	= %SYSFUNC(TIME());
%LET TIMESTAMP  	= %STR(%SYSFUNC(SUM(&TIMESTART),TIME8.0));
%LET TIMESTAMP2 	= %SYSFUNC(TRANWRD(&TIMESTAMP,:,));
%LET TIMESTAMP3 	= %SYSFUNC(COMPRESS(&TIMESTAMP2));
%LET DATETIMESTAMP 	= &DATESTAMP._&TIMESTAMP3;
  
OPTIONS SYMBOLGEN MPRINT MLOGIC;
 
%MACRO M_NLAD(
 DSNAME=
,DEPENDENT=
,VARIABLES=
,NULL_GROUPING_COLS=
,LIB=
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
	DM LOG "CLEAR" CONTINUE;/*CLEAR CURRENT LOG*/
	DM 'ODSRESULTS' CLEAR;/*CLEAR CURRENT RESULTS*/
	%IF %UPCASE(&GENERATEOUTPUT)=N %THEN
	     %DO;
	           /*OPTIONS NOSYMBOLGEN NOMPRINT NOMLOGIC;*//*SET NO CODE DEBUGGING*/
	
	           PROC PRINTTO
	                FILE="&OUTPUT_PRINTTO."
	                LOG="&LOG_PRINTTO."
	                NEW;
	           RUN;
	
	           ODS RESULTS OFF;
	           ODS OUTPUT CLOSE;
	           ODS HTML CLOSE; 
	           /*ODS LISTING CLOSE;*/
	     %END;
	/*------------------------------------------------------------------------------
  	--- Define Parameters
  	------------------------------------------------------------------------------*/
	%LET VDATA=&DSNAME.;
	%LET VVARIABLE_NAMES=&VARIABLES.;
	%LET VVARIABLE_NAMES_ENQ=%ENQUOTE(&VARIABLES.,SEPARATOR=);
	%LET VNULL_GRP_COLS=&NULL_GROUPING_COLS.;
	%LET VLIB=&LIB.;
	%LET VPART_COL=&PARTITION_COL.;
	%LET VPART_VAL=&PARTITION_VAL.;
	%LET N_VARS=%SYSFUNC(COUNTW(&VVARIABLE_NAMES.));
	%LET N=0;
	/*---------------------------------------------------------------------------------------------------
	--|Create table with all columns' names
	---------------------------------------------------------------------------------------------------*/
	 PROC CONTENTS
       DATA=&EM_IMPORT_DATA.
       OUT=&EM_LIB..VARIABLES_NAMES_&MDL.;
	RUN;
 	/*---------------------------------------------------------------------------------------------------
	--|Create table with only inputs names
	---------------------------------------------------------------------------------------------------*/
	%LET VVARIABLE_NAMES_ENQ=%ENQUOTE(&VVARIABLE_NAMES.,SEPARATOR=);
	PROC SQL;
	     CREATE TABLE &EM_LIB..VARIABLES_INPUTS_&MDL.
	     AS
	     SELECT
	     DISTINCT NAME
	     FROM &EM_LIB..VARIABLES_NAMES_&MDL.
	     WHERE NAME IN (&VVARIABLE_NAMES_ENQ.)
	     ;
	QUIT;
 	/*---------------------------------------------------------------------------------------------------
	--|Generate the Null level analysis code
	---------------------------------------------------------------------------------------------------*/	
 	DATA _NULL_;
		FILE NULLCODE;
		SET &EM_LIB..VARIABLES_INPUTS_&MDL. END=LAST;
		IF _N_=1 THEN DO;
			PUT "PROC SQL;";
			PUT "	CREATE TABLE &EM_LIB..NULL_ANALYSIS_&MDL.";
			PUT "	AS";
			PUT "	SELECT";
			PUT "	&VNull_Grp_Cols.";
		END;
		IF NOT LAST THEN DO;
			PUT "	,	AVG(IFN(" NAME " IS MISSING,1,0)) AS " NAME;
		END;
		ELSE IF LAST THEN DO;
			PUT "	FROM &EM_IMPORT_DATA.";
			PUT "	GROUP BY ";
			PUT "	&VNull_Grp_Cols.";
			PUT "	ORDER BY";
			PUT "	&VNull_Grp_Cols.;";
			PUT "QUIT;";
		END;
	RUN;
 	/*---------------------------------------------------------------------------------------------------
	--|Invoke and execute the null analysis code and create Null summary table
	---------------------------------------------------------------------------------------------------*/
	%INCLUDE NULLCODE/SOURCE;
  	/*---------------------------------------------------------------------------------------------------
	--|Generate Minimum Null level analysis code
	---------------------------------------------------------------------------------------------------*/
 	DATA _NULL_;
		FILE MNNLCODE;
		SET &EM_LIB..VARIABLES_INPUTS_&MDL. END=LAST;
		IF _N_=1 THEN DO;
			PUT "PROC SQL;";
			PUT "	CREATE TABLE &EM_LIB..MIN_NULL_LEVEL_&MDL.";
			PUT "	AS";
			PUT "	SELECT";
			PUT '	"MIN_NULL_LEVEL" AS SUMMARY';
		END;
		IF NOT LAST THEN DO;
			PUT "	,	MIN(" NAME ") AS " NAME;
		END;
		ELSE IF LAST THEN DO;
			PUT "	FROM &EM_LIB..NULL_ANALYSIS_&MDL.";
			PUT "QUIT;";
		END;
	RUN;
  	/*---------------------------------------------------------------------------------------------------
	--|invoke and execute the Minimum Null level analysis code
	---------------------------------------------------------------------------------------------------*/
	%INCLUDE MNNLCODE/SOURCE;
  	/*---------------------------------------------------------------------------------------------------
	--|Transpose the Minimum Null Level table for further filtering
	---------------------------------------------------------------------------------------------------*/
     PROC TRANSPOSE
       DATA=&EM_LIB..MIN_NULL_LEVEL_&MDL.  (DROP=SUMMARY)
       OUT=&EM_LIB..MIN_NULL_LEVEL_&MDL._T (DROP=_LABEL_)
       NAME=VARIABLE_NAME
	     PREFIX=MIN_NULL_LEVEL
     		;
     	VAR _ALL_;
     run;
  	/*---------------------------------------------------------------------------------------------------
	--|Generate reports with the results from the Null analysis
	---------------------------------------------------------------------------------------------------*/
		title1 "Variables to be rejected due to high null levels" font='arial/bo' justify=left;
		PROC SQL;
			SELECT 
			VARIABLE_NAME
			FROM &EM_LIB..MIN_NULL_LEVEL_&MDL._T 
			WHERE MIN_NULL_LEVEL1>=&MIN_NULL_LVL.
			;
		QUIT;	

		title1 "Variables to be included due to low null levels" font='arial/bo' justify=left;
		PROC SQL;
			SELECT 
			VARIABLE_NAME
			FROM &EM_LIB..MIN_NULL_LEVEL_&MDL._T 
			WHERE MIN_NULL_LEVEL1<&MIN_NULL_LVL.
			;
		QUIT;	
	/*---------------------------------------------------------------------------------------------------
	--|Create catalog table with the list of variables to be rejected
	---------------------------------------------------------------------------------------------------*/
	DATA &EM_LIB..HIGH_NULL_LEVEL_VARS_&MDL.;
		SET &EM_LIB..MIN_NULL_LEVEL_&MDL._T  (WHERE=(MIN_NULL_LEVEL1>=&MIN_NULL_LVL.));
		COUNTER=_N_;
	RUN;
	/*---------------------------------------------------------------------------------------------------
	--|Get total number of variables to be rejected
	---------------------------------------------------------------------------------------------------*/
	PROC SQL; SELECT COUNT(1) INTO :N FROM &EM_LIB..HIGH_NULL_LEVEL_VARS_&MDL.; QUIT;
	/*---------------------------------------------------------------------------------------------------
	--|Reject variables via loop, using the metadata macro
	---------------------------------------------------------------------------------------------------*/
	%IF &N.>0 %THEN
		%DO; 
			%METADATA();
			%DO I=1 %TO &N. %BY 1;
				%LET HIGH_NULL_LVL_VAR=;
				PROC SQL NOPRINT; SELECT VARIABLE_NAME INTO :HIGH_NULL_LVL_VAR FROM &EM_LIB..HIGH_NULL_LEVEL_VARS_&MDL. WHERE COUNTER=&I.; QUIT;
				%LET VAR=%ENQUOTE(&HIGH_NULL_LVL_VAR.,SEPARATOR=);
				%METADATA(NEWROLE=REJECTED,APPEND=Y,WHERE=(NAME IN (&VAR.) AND UPCASE(ROLE)='INPUT'));
			%END; 
		%END; 
	/*------------------------------------------------------------------------------
	--- Reset sas Parameters
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
	%LET TIMEEND = %SYSFUNC(DATETIME());
	%LET TIMEDIFF = %SYSFUNC(SUM(&&TIMEEND, -&&TIMESTART));
	%LET ELAPSED =  %SYSFUNC(SUM(&TIMEDIFF), TIME8.);
	%LET START = %SYSFUNC(SUM(&TIMESTART),DATETIME16.);
	%LET END = %SYSFUNC(SUM(&TIMEEND),DATETIME16.);
	/*__________________________________________________________________________________________*/
	%PUT >>>  STATUS: Null Analysis terminated  <<<;
	%PUT >>>  PROCESS: &n. Variables rejected  <<<;
	%PUT >>>  TIME: Started at &Start. and terminated at &end.   <<<;
	%PUT >>>  ELAPSED: &Elapsed.  <<<;
 %MEND M_NLAD;
 
 
%M_NLAD
(
DSNAME=&EM_IMPORT_DATA.
,DEPENDENT=%EM_BINARY_TARGET
,VARIABLES= %EM_INTERVAL_INPUT
,NULL_GROUPING_COLS=&NULL_GROUPING_COLS.
,LIB=&LIB
,PARTITION_COL=
,PARTITION_VAL=
,MDL=&MDL.
,GENERATEOUTPUT=&GENERATEOUTPUT.
,LOG_PRINTTO=&DIR./&DATETIMESTAMP._&USER._NLAD_log_&MDL..LOG
,OUTPUT_PRINTTO=&DIR./&DATETIMESTAMP._&USER._NLAD_output_&MDL..OUT
)
;
