%LET DIR=/ebn/warehouse/Modelos/Output_Logs;	/*If GENERATEOUTPUT=N then you must define the output path*/
%LET CUTOFF=0.25;						/*Recommended significance for univariable analysis*/
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
%LET DATETIMESTAMP 	= &DATESTAMP._&TIMESTAMP3;
  
OPTIONS SYMBOLGEN MPRINT MLOGIC;
 
%MACRO M_UNIVARIABLE(
 DSNAME=
,DEPENDENT=
,COVAR=
,NOMINAL=
,DUMMY=
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
	DM LOG "CLEAR" CONTINUE;/*clear current log*/
	DM 'ODSRESULTS' CLEAR;/*Clear current results*/
	%IF %UPCASE(&GENERATEOUTPUT.)=N %THEN
	     %DO;
	           PROC PRINTTO
	                FILE="&OUTPUT_PRINTTO."
	                LOG="&LOG_PRINTTO."
	                NEW;
	           RUN;
	
	           ODS RESULTS OFF;
	           ODS OUTPUT CLOSE;
	           ODS HTML CLOSE; 
	           /*ODS LISTING CLOSE;*//*Only in SAS Base*/
	     %END;
	/*------------------------------------------------------------------------------
  			--- Initialize macro variables
  	------------------------------------------------------------------------------*/
	%LET VDATA		=&DSNAME.;
	%LET VDEPENDENT	=&DEPENDENT.;
	%LET VCOVAR		=&COVAR.;
	%LET VDUMMY		=&NOMINAL.;
	%LET VLIB		=&LIB.;
	%LET VPART_COL	=&PARTITION_COL.;
	%LET VPART_VAL	=&PARTITION_VAL.;
	%LET N			=%SYSFUNC(COUNTW(&VCOVAR.));
	%LET N_REJECT	=;
	%LET REFERENCES	=;
	%LET REF		=;
	/*------------------------------------------------------------------------------
  			--- Get reference category for nominal variables
 	------------------------------------------------------------------------------*/
	%LET K=1;
	%DO %WHILE (%SCAN(&VDUMMY.,&K.,' ') NE );
	     %LET NOM_VAR=%SCAN(&VDUMMY.,&K.,' ');
	     PROC SQL THREADS  OUTOBS=1 NOPRINT;
	           SELECT
	           &NOM_VAR.
	           ,COUNT(1) AS FREQ
	           INTO
	           :REF
	           ,:X
	           FROM  &VDATA.
	           WHERE &NOM_VAR. IS NOT NULL
	           GROUP BY
	           &NOM_VAR.
	           ORDER BY
	           CALCULATED FREQ DESC
	           ;
	     QUIT;
	     %LET REFERENCES=%STR(&REFERENCES.|%QCMPRES(&REF.));
	     %LET K=%EVAL(&K.+1);
	%END;
 
	%LET VREF=&REFERENCES.;
	/*------------------------------------------------------------------------------
  			--- Create Results Tables
  	------------------------------------------------------------------------------*/
	PROC SQL; CREATE TABLE UNIVARIABLE_MODELS(
	VARIABLE   CHAR(200)
	,G              NUM
	,P_VAL          NUM
	)
	;
	QUIT;
	/*------------------------------------------------------------------------------
	  		--- Get total number of rows
	------------------------------------------------------------------------------*/
	PROC SQL;
		SELECT
		COUNT(1)
		INTO
		:NUMROWS
		FROM &VDATA.
		;
	QUIT;
	/*------------------------------------------------------------------------------
	  		--- Start Main Loop
	------------------------------------------------------------------------------*/
	%METADATA();
	%DO I=1 %TO &N. %BY 1;
    	%LET VAL = %SCAN(&VCOVAR.,&I.);
    /*------------------------------------------------------------------------------
    		--- Check if the class statement applies
 	------------------------------------------------------------------------------*/
		%LET VCLASS=;
     	%IF %LENGTH(&VDUMMY.)>0 %THEN
        	%DO;
	            %LET ND=%SYSFUNC(COUNTW(&VDUMMY.));
	            %DO I1=1 %TO &ND. %BY 1;
	                 %LET CL = %SCAN(&VDUMMY.,&I1.,' ');
	                  %LET RF = %QSCAN(&VREF.,&I1.,'|');
	                 %IF &CL.=&VAL. %THEN
	                 %LET VCLASS=%STR(CLASS &CL. (PARAM=REF REF="%QCMPRES(&RF.)"););
           %END;
        %END;
     /*------------------------------------------------------------------------------
    		--- Select the Validation SQL statement based on the type of variable
 	------------------------------------------------------------------------------*/
		%IF %LENGTH(&VCLASS.)>0 %THEN
			%DO;
				%LET SQL=0;
			%END;
		%ELSE
			%DO;
				%LET SQL=%STR(SUM(CASE WHEN &VAL. =0 THEN 1 ELSE 0 END)/&NUMROWS.);
			%END;
    /*------------------------------------------------------------------------------
       		--- Check if the variable has enough information to proceed
     ------------------------------------------------------------------------------*/
	    PROC SQL NOPRINT;
            SELECT
             SUM(CASE WHEN &VAL. IS NULL THEN 1 ELSE 0 END)/&NUMROWS. AS NULLS
            ,&SQL. AS ZEROS
            ,COUNT(DISTINCT &VAL. ) AS VALUES
            INTO
            :PNULL
            ,:PZERO
            ,:NCATEGORIES
            FROM &VDATA.
            ;
	    QUIT;
 
		%IF (&PNULL.<0.8 AND &PZERO.<0.8 AND &NCATEGORIES.>1)  %THEN
			%DO;
			     /*------------------------------------------------------------------------------
			       		--- Check for partition
			     ------------------------------------------------------------------------------*/
			     %LET VPART=;
			     %IF %LENGTH(&VPART_COL.)>0 %THEN
			           %LET VPART=%STR(WHERE &VPART_COL. = "&VPART_VAL." ;);
			     /*------------------------------------------------------------------------------
			       		--- Run the Logistic Regression
			     ------------------------------------------------------------------------------*/
			     TITLE1 "Run Logistic Regression for covariate &VAL. " FONT='arial/bo' JUSTIFY=LEFT;
			
			     PROC LOGISTIC
			           DATA=&VDATA.
			           NAMELEN=200
			           ;
			           &VPART.
			           &VCLASS.
			           MODEL  &VDEPENDENT. (EVENT='1') =  &VAL.
			                /
			           ITPRINT
			           TECH=NEWTON
			           MAXITER=1000
			           ;
					   ODS OUTPUT
		         			FITSTATISTICS=&VAL._FS;
			     RUN;

			     /*------------------------------------------------------------------------------
			       		--- Save Results (Temporarily)
			     ------------------------------------------------------------------------------*/
			     %IF %LENGTH(&VCLASS.)>0 %THEN
			           %LET VCLASSX=CLASSVAL0;
			     %ELSE
			           %LET VCLASSX=%STR("");
			
			           PROC SQL NOPRINT;
				           INSERT INTO UNIVARIABLE_MODELS
				           SELECT
				           "&VAL." AS VARIABLE
				           ,ABS(INTERCEPTONLY-INTERCEPTANDCOVARIATES) AS G
				           ,1-PROBCHI(ABS(INTERCEPTONLY-INTERCEPTANDCOVARIATES),1,0) AS P_VAL
				           FROM
				           &VAL._FS
				           WHERE MONOTONIC()=3
				           ;
			          QUIT;
					/*------------------------------------------------------------------------------
					    	--- Save Results Permanently and Replace
					------------------------------------------------------------------------------*/
					PROC SQL;
						CREATE TABLE &VLIB..UNIVARIABLE_MODELS_&MDL.
						AS
						SELECT
						*
						FROM
						UNIVARIABLE_MODELS;
					QUIT;
			%END;
		%ELSE
				%DO;
						%LET VARLIST=%ENQUOTE(&VAL.,SEPARATOR=);
						%METADATA(NEWROLE=REJECTED,APPEND=Y,WHERE=(NAME IN (&VARLIST.) AND UPCASE(ROLE)='INPUT'));	
				%END;
	%END;
	/*------------------------------------------------------------------------------
	    	--- Save Results Permanently
	------------------------------------------------------------------------------*/
	PROC SQL;
	CREATE TABLE &VLIB..UNIVARIABLE_MODELS_&MDL.
	AS
	SELECT
	*
	FROM
	UNIVARIABLE_MODELS;
	QUIT;
	
	TITLE1 "Variables to be included in the 1st Multivariable model" FONT='arial/bo' JUSTIFY=LEFT;
	
	PROC SQL;
	     SELECT * FROM &LIB..UNIVARIABLE_MODELS_&MDL.
	     WHERE P_VAL<&CUTOFF.
	     ORDER BY P_VAL
	     ;
	QUIT;
 
	TITLE1 "Variables to be rejected" FONT='arial/bo' JUSTIFY=LEFT;
	
	PROC SQL;
	     SELECT * FROM &LIB..UNIVARIABLE_MODELS_&MDL.
	     WHERE P_VAL>=&CUTOFF.
	     ORDER BY P_VAL
	     ;
	QUIT;															  	
	/*--------------------------------------------------------------------------------------------------
			--- Query the significant variables
	---------------------------------------------------------------------------------------------------*/
	TITLE1 "Final Selection" FONT='arial/bo' JUSTIFY=LEFT;
	
	PROC SQL;
		SELECT
		VARIABLE INTO :SIGNIFICANT SEPARATED BY " "
		FROM &LIB..UNIVARIABLE_MODELS_&MDL.
		WHERE P_VAL<&CUTOFF.;
	QUIT;
	/*---------------------------------------------------------------------------------------------------
			--- Reset metadata with significant variables at a 0.25 level
	---------------------------------------------------------------------------------------------------*/
	DATA UNIVARIABLE_MODELS;
		SET &LIB..UNIVARIABLE_MODELS_&MDL. (WHERE=(P_VAL>=&CUTOFF.));
		COUNTER=_N_;
	RUN;
 
	PROC SQL; SELECT COUNT(1) INTO :N_REJECT FROM UNIVARIABLE_MODELS; QUIT;

	%IF &N_REJECT.>0 %THEN
		%DO;
			%DO I=1 %TO &N_REJECT. %BY 1;
				PROC SQL; SELECT VARIABLE INTO :NOSIGNIFICANT FROM UNIVARIABLE_MODELS WHERE COUNTER=&I.; QUIT;
				%LET VARLIST=%ENQUOTE(&NOSIGNIFICANT.,SEPARATOR=);
				%METADATA(NEWROLE=REJECTED,APPEND=Y,WHERE=(NAME IN (&VARLIST.) AND UPCASE(ROLE)='INPUT'));
			%END;
		%END;
	/*------------------------------------------------------------------------------
			--- Reset sas Parameters (only in SAS Base)
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
	%PUT >>>  STATUS: Univariable Analysis macro terminated  <<<;
	%PUT >>>  PROCESS: &N. Variables processed  <<<;
	%PUT >>>  CYCLES: &N. Regressions carried out  <<<;
	%PUT >>>  TIME: Started at &START. and terminated at &END.   <<<;
	%PUT >>>  ELAPSED: &ELAPSED.  <<<;

 %MEND M_UNIVARIABLE;
 
 

%M_UNIVARIABLE
(
DSNAME=&EM_IMPORT_DATA.
,DEPENDENT=%EM_BINARY_TARGET
,COVAR= %EM_BINARY_INPUT %EM_INTERVAL_INPUT %EM_NOMINAL_INPUT
,NOMINAL=%EM_NOMINAL_INPUT
,LIB=&LIB.
,PARTITION_COL=
,PARTITION_VAL=
,MDL=&MDL.
,GENERATEOUTPUT=&GENERATEOUTPUT.
,LOG_PRINTTO=&DIR./&DATETIMESTAMP._&USER._UA_LOG_&MDL..LOG
,OUTPUT_PRINTTO=&DIR./&DATETIMESTAMP._&USER._UA_OUTPUT_&MDL..OUT
)
;

