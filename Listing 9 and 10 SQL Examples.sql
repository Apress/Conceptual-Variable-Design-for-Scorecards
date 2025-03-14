

--Listing 9-1 Extract from a subset of nested rules used to classify financial products.
CASE 
	WHEN PORTFOLIOTYPE=0 AND USAGE=9 AND UPPER(REGEXP_REPLACE(ACTIVITY, '\s{2,}', ' ')) NOT LIKE '%HOME IMPROVEMNTS%'  	THEN 'Housing'
	WHEN PORTFOLIOTYPE IN (3,8) AND UPPER(REGEXP_REPLACE(ACTIVITY, '\s{2,}', ' ')) NOT LIKE '%HOME IMPROVEMNTS%' 		THEN 'Housing'
	WHEN UPPER(REGEXP_REPLACE(COMMERCIAL_CAMPAIGN, '\s{2,}', ' ')) LIKE '%REAL ESTATE%'   								THEN 'Housing'
	WHEN UPPER(REGEXP_REPLACE(COMMERCIAL_CAMPAIGN, '\s{2,}', ' ')) LIKE '%REAL EST%' 									THEN 'Housing'
	WHEN UPPER(COMMERCIAL_CAMPAIGN) LIKE '%HOUSING%'          															THEN 'Housing'
	WHEN UPPER(COMMERCIAL_CAMPAIGN) LIKE '% HOUSE %'            														THEN 'Housing'
	WHEN UPPER(COMMERCIAL_CAMPAIGN) LIKE '% HOUSE OUTLET %'        														THEN 'Housing'
	WHEN UPPER(COMMERCIAL_CAMPAIGN) LIKE '% MORTGAG. %'        															THEN 'Housing'
	WHEN UPPER(COMMERCIAL_CAMPAIGN) LIKE '% MORTG. %'         															THEN 'Housing'
	WHEN UPPER(COMMERCIAL_CAMPAIGN) LIKE '% MORTGAGE%'         															THEN 'Housing'                                                                                
	WHEN UPPER(REGEXP_REPLACE(ACTIVITY, '\s{2,}', ' ')) LIKE '%HOME IMPROVEMNTS%' 										THEN 'Loan'
	WHEN UPPER(REGEXP_REPLACE(ACTIVITY, '\s{2,}', ' ')) NOT LIKE '%HOME IMPROVEMNTS%' AND UPPER(ACTIVITY) LIKE '% HOUSING %' THEN 'Housing'
	ELSE 'Loan'
END

--Listing 10-1 Base Oracle SQL cursor structure.
DECLARE 
V_REGS NUMBER:=0;
 CURSOR C1 IS 
    SELECT   
        A.ROWID
    ,	B.VARIABLE1
    FROM 	 
     ABT_TABLE      	A
    ,DATA_SOURCE_TABL 	B
    WHERE 
        A.ACCOUNT_KEY=B.ACCOUNT_KEY
    ;
BEGIN
UPDATE ROW_COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	update ABT_TABLE A
		set
            VARIABLE1=B.VARIABLE1
   		WHERE ROWID = B.ROWID;
		 IF MOD(C1%ROWCOUNT,10000) = 0  THEN
		 		  UPDATE ROW_COUNTER SET COUNTER = COUNTER + 10000;    
		          COMMIT;
		 END IF;
		 V_REGS := C1%ROWCOUNT;
	END LOOP;	
	COMMIT;
END;
/	


--Listing 10-2 Hash Outer join DATA Step.
data ABT (DROP=_F _RC)  ;

	 IF 0 THEN 	SET INPUT_TABLE;

     dcl hash hh (hashexp: 16, ordered: 'a');
     dcl hiter hi ('hh');
     hh.definekey ('SUBJECT_ID');
     hh.definedata ('NEW_VARIABLE','_f');
     hh.definedone () ;

     do until (eof2);
           set INPUT_TABLE (KEEP=SUBJECT_ID NEW_VARIABLE) end = eof2;
           _f = .;
           hh.add();
     end;

     do until(eof);
           set ABT end = eof;
           call missing(NEW_VARIABLE);
           if hh.find() = 0 then do;
                _f = 1;
                hh.replace();
                output;
                _f = .;
           end;
           else output;               
     end;

     do _rc = hi.first() by 0 while (_rc = 0);
           if _f ne 1 then do;
           end;
           _rc = hi.next();
     end;

stop;
run;

--Listing 10-3 Improved hash outer join DATA Step.
data ABT (DROP=_F _RC)  ;

     retain timestart;
     timestart=datetime();

	 IF 0 THEN 	SET INPUT_TABLE;

     dcl hash hh (hashexp: 16, ordered: 'a');
     dcl hiter hi ('hh');
     hh.definekey ('SUBJECT_ID');
     hh.definedata ('NEW_VARIABLE','_f');
     hh.definedone () ;

     do until (eof2);
           set INPUT_TABLE (KEEP=SUBJECT_ID NEW_VARIABLE) end = eof2;
           _f = .;
           hh.add();
     end;

     do until(eof);
           set ABT end = eof;
           call missing(NEW_VARIABLE);
           if hh.find() = 0 then do;
                _f = 1;
				HITS+1;
                hh.replace();
                output;
                _f = .;
           end;
           else output;   
        /*____________________________________START_COUNTER___________________________________________________*/           
                 K+1;
                 IF MOD(K,200000)=0 THEN
                       DO;
                            timeEnd = Datetime();
                            timediff = Sum(timeend, -timestart);
                            Elapsed =  put(timediff, Time8.);
                            Start = put(timestart,datetime16.);
                            End = put(timeend,datetime16.);
                            Counter=put(K,comma24.);
                            Hitsf=put(Hits,comma24.);
                            RC02 = DOSUBL(CATX(' ','SYSECHO "R:',Counter,' H:',Hitsf,' E:',Elapsed,'";'));
                       END;
                 DROP TIMESTART TIMEEND TIMEDIFF ELAPSED START END K counter HITS RC02;  
        /*____________________________________END_COUNTER___________________________________________________*/  
     end;
	 
     do _rc = hi.first() by 0 while (_rc = 0);
           if _f ne 1 then do;
           end;
           _rc = hi.next();
     end;
	 
stop;
run;

--Listing 10-4 The hash inner join DATA step
data TARGET_DATA_SOURCE (COMPRESS=no DROP=FLG);

	 dcl hash hh (hashexp: 16,ordered: 'a') ;
	       hh.definekey ('SUBJECT_ID', '_n_') ;
	       HH.DEFINEDATA ('FLG') ;
	       hh.definedone () ;
	 dcl hash hs (hashexp: 16,ordered: 'a') ;
	       hs.definekey ('SUBJECT_ID') ;
	       hs.definedata ('_n_') ;
	       hs.definedone () ;

	 DO UNTIL ( END_LOOKUP ) ;
	       set TARGET_POPULATION (KEEP=SUBJECT_ID) end = end_lookup ;
	       FLG=1;
	       if hs.find() ne 0 then _n_ = 0 ;
	       _n_ ++ 1 ;
	       hs.replace() ;
	       hh.add() ;
	 end ;

	 do until ( end_driver ) ;
	       set DATA_SOURCE ( WHERE=(START_PERIOD<=PERIOD<=END_PERIOD))  end = end_driver ;
	       if hs.find() = 0 then
	       do _n_ = 1 to _n_ ;        
	            hh.find() ;
	            output ;
	       end ;           
	 end ;

	 stop ;
run ;

--Listing 10-5 SELECT correlated subquery.
SELECT
 SUBJECT_ID 
,(
	SELECT 
	SUM/MIN/MAX/AVG(INTERVAL_VARIABLE) 
	FROM DATA_SOURCE B 
	WHERE 
		A.SUBJECT_ID=B.SUBJECT_ID 
	AND PERIOD BETWEEN START_PERIOD AND END_PERIOD
	) AS INPUT_VARIABLE
FROM TARGET_POPULATION/ABT A
;


--Listing 10-6 Applied examples of a SELECT correlated subqueries. (A) Shows an example where only the marital status is being extracted from a catalog with sociodemographic information. (B) Shows an example where the total amount withdrawn from an ATM in the last three months is being extracted from the transactional information of the current account.
SELECT
 SUBJECT_ID 
,(
	SELECT 
	MARITAL_STATUS 
	FROM SOCIODEMOGRAPHIC_CATALOG B 
	WHERE 
		A.SUBJECT_ID=B.SUBJECT_ID 
	) AS N_MARITAL_STATUS
FROM TARGET_POPULATION/ABT A	


SELECT
 SUBJECT_ID 
,(
	SELECT 
	SUM(B.CASH_AMOUNT) 
	FROM TRN_CURRENT_ACCOUNT B 
	WHERE 
		A.SUBJECT_ID=B.SUBJECT_ID 
	AND B.TRN_PERIOD BETWEEN ADD_MONTHS(B.TRN_PERIOD,-3) AND A.REF_PERIOD
	AND B.TRN_CODE='ATM'
	) AS TOTAL_ATM_WDRW_AMOUNT_L03M
FROM TARGET_POPULATION/ABT A

--Listing 10-7 Syntax to create the credit card transactional input at the account level.
CREATE TABLE TRX_INPUT_CC_ACC NOLOGGING STORAGE (INITIAL 2M NEXT 1M) 
AS
SELECT /*+FIRST_ROWS(10000) INDEX(C, INX_TRX_CAT) INDEX(B, INX_MCC) INDEX(A, INX_TRX_MCC)*/
    TO_NUMBER(TO_CHAR(A.TRX_DATE,'YYYYMM'),'999999') AS PERIOD
,   A.ACCOUNT_ID
,   A.TRX_DATE
,   A.TRX_AMOUNT
,   A.MCC
,   A.TRX_CODE
,   B.GENERAL_MCC
,   B.MCC_NAME
,   B.MCC_DESCRIPTION
,   B.EXPENSE_DESC
,   B.EXPENSE_CODE
,   C.TRX_TYPE
,   C.TRX_DIRECTION
,CASE 
        WHEN C.TRX_DESCRIPTION LIKE 'WITHDRAW%' THEN 'ATM'
        ELSE B.EXPENSE_CODE 
 END  AS EXPENSE_TYPE_CODE
,CASE 
        WHEN C.TRX_DESCRIPTION LIKE 'WITHDRAW%' THEN 'CASH WITHDRAW'
        ELSE B.EXPENSE_DESC 
 END  AS EXPENSE_TYPE_DESC
 FROM 
    CC_TRANSACTIONS A
,   MCC_CATALOG B 
,   TRX_CATALOG C
WHERE
    A.MCC = B.MCC (+)
AND A.TRX_CODE = C.TRX_CODE
;		

--Listing 10-8 CURSOR syntax to add the CUSTOMER_ID to the TRX_INPUT_CC_ACC table.
ALTER TABLE TRX_INPUT_CC_ACC ADD CUSTOMER_ID VARCHAR2(50);

DECLARE 
T1 INTEGER:=DBMS_UTILITY.GET_TIME;T2 INTEGER:=0;V_REGS NUMBER:=0;
 CURSOR C1 IS 
    SELECT   /*+ FIRST_ROWS(10000)*/  
       A.ROWID
     , B.CUSTOMER_ID
     FROM 	 
     TRX_INPUT_CC_ACC  A
    ,BRD_CUSTOMER_X_ACCOUNT_CC  B
    WHERE 
        A.ACCOUNT_ID=B.ACCOUNT_ID
    ;
BEGIN
UPDATE COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	
	UPDATE TRX_INPUT_CC_ACC A
		SET
         CUSTOMER_ID= B.CUSTOMER_ID
   		WHERE ROWID = B.ROWID;
   		
		 IF MOD(C1%ROWCOUNT,10000) = 0  THEN
		 		  UPDATE COUNTER SET COUNTER = COUNTER + 10000;    
		          COMMIT;
		 END IF; 
		 V_REGS := C1%ROWCOUNT; 
	END LOOP;	
	COMMIT;
	T2 :=DBMS_UTILITY.GET_TIME;
	DBMS_OUTPUT.PUT_LINE('-- Records Processed: ' ||TO_CHAR(V_REGS,'999,999,999.99'));
	DBMS_OUTPUT.PUT_LINE('-- Elapsed: ' ||TO_CHAR((T2-T1)/100/60,'999,999,999.99'));
END;
/	

--Listing 10-9 CREATE syntax for creating the grouped table TRX_INPUT_CC_ACC_GRP.
CREATE TABLE TRX_INPUT_CC_ACC_GRP
AS
SELECT 
 PERIOD
,ACCOUNT_ID
,EXPENSE_TYPE_CODE
,EXPENSE_TYPE_DESC
,SUM(TRX_AMOUNT) AS  TOT_TRX_AMOUNT
,COUNT(1) 		 AS  TRANSACTIONS
FROM TRX_INPUT_CC_ACC
WHERE 
TRX_TYPE IN (
 'PURCHASE'
,'CASH WITHDRAW'
)
AND TRX_DIRECTION='OUTPUT'
GROUP BY 
 PERIOD
,ACCOUNT_ID
,EXPENSE_TYPE_CODE
,EXPENSE_TYPE_DESC
;	

--Listing 10-10 Steps required to create the transactional base table, or TBT.

--Step 1
CREATE TABLE TIME_PERIOD_CATALOG
AS
SELECT
DISTINCT
PERIOD
FROM 
TRX_INPUT_CC_ACC_GRP  A
ORDER BY 
PERIOD
;
--Step 2
CREATE TABLE ACCOUNT_TIME_PERIOD_CATALOG
AS
SELECT
DISTINCT
 ACCOUNT_ID
,PERIOD
FROM 
TRX_INPUT_CC_ACC_GRP  A
ORDER BY 
 ACCOUNT_ID
,PERIOD
;
--Step 3
CREATE TABLE EXPENSE_TYPE_CATALOG
AS
SELECT
DISTINCT
EXPENSE_TYPE_CODE
FROM 
TRX_INPUT_CC_ACC_GRP  A
ORDER BY 
EXPENSE_TYPE_CODE
;
--Step 4
CREATE TABLE TBT_INPUT_CC_ACC_GRP NOLOGGING STORAGE(INITIAL 2M NEXT 1M)
AS
SELECT
DISTINCT 
 A.PERIOD
,B.ACCOUNT_ID
,C.EXPENSE_TYPE_CODE
,0 TOT_TRX_AMOUNT
,0 TRANSACTIONS
FROM 
 TIME_PERIOD_CATALOG A
,ACCOUNT_TIME_PERIOD_CATALOG B
,EXPENSE_TYPE_CATALOG C
WHERE 
    A.PERIOD>=B.PERIOD
ORDER BY
 A.PERIOD
,B.ACCOUNT_ID
,C.EXPENSE_TYPE_CODE
;

--Listing 10-11 Adding reported transactional information to the TBT via CURSOR
CREATE UNIQUE INDEX INX_TBT_INPUT_CC_ACC_GRP ON  
TBT_INPUT_CC_ACC_GRP(PERIOD,ACCOUNT_ID,EXPENSE_TYPE_CODE) TABLESPACE SC_SASIDX;

CREATE UNIQUE INDEX INX_TRX_INPUT_CC_ACC_GRP 	ON  
TRX_INPUT_CC_ACC_GRP(PERIOD,ACCOUNT_ID,EXPENSE_TYPE_CODE) TABLESPACE SC_SASIDX;

DECLARE 
t1 integer:=dbms_utility.get_time;t2 integer:=0;v_regs number:=0;
 CURSOR C1 IS 
    SELECT   /*+ INDEX(A,INX_TBT_TRX_INPUT_CC_ACC_GRP) INDEX(B, INX_TRX_INPUT_CC_ACC_GRP) FIRST_ROWS(10000) */  
        A.ROWID
    ,   B.TOT_TRX_AMOUNT  
    ,   B.TRANSACTIONS   
    FROM 	 
     TBT_TRX_INPUT_CC_ACC_GRP  A
    ,TRX_INPUT_CC_ACC_GRP  B
    WHERE 
        A.ACCOUNT_ID=B.ACCOUNT_ID
    AND A.PERIOD=B.PERIOD
    AND A.EXPENSE_TYPE_CODE=B.EXPENSE_TYPE_CODE
    ;
BEGIN
UPDATE COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	update TBT_TRX_INPUT_CC_ACC_GRP A
		set
         TOT_TRX_AMOUNT=     B.TOT_TRX_AMOUNT
        ,TRANSACTIONS= B.TRANSACTIONS
   		where rowid = B.rowid;
		 IF MOD(C1%ROWCOUNT,50000) = 0  THEN
		 		  UPDATE COUNTER SET COUNTER = COUNTER + 50000;    
		          COMMIT;
		 END IF;
		 v_regs := c1%rowcount;
	END LOOP;	
	commit;
	T2 :=DBMS_UTILITY.GET_TIME;
	DBMS_OUTPUT.PUT_LINE('-- Records Processed: ' ||TO_CHAR(V_REGS,'999,999,999.99'));
	DBMS_OUTPUT.PUT_LINE('-- Elapsed: ' ||TO_CHAR((T2-T1)/100/60,'999,999,999.99'));
END;
/

--Listing 10-12 CREATE syntax in a nested series of queries for the creation of the base metrics from the TBT, using Oracle’s analytical functions.
--Listing 10-13 Innermost query of Listing 10-12
--Listing 10-14 Second innermost query from the inside out.
--Listing 10-15 Outermost query.

CREATE TABLE OAF_TBT_INPUT_CC_ACC_GRP NOLOGGING STORAGE(INITIAL 2M NEXT 1M)
AS
SELECT
A.*
, CASE WHEN N > 1 THEN DECODE(NVL(R_EXPI_EXPT_LAG01,0),0,0,NVL(R_EXPI_EXPT,0)/NVL(R_EXPI_EXPT_LAG01,0)-1) ELSE 0 END AS MV_R_EXPI_EXPT
, CASE WHEN N > 2 THEN DECODE(NVL(R_EXPI_EXPT_LAG03,0),0,0,NVL(R_EXPI_EXPT,0)/NVL(R_EXPI_EXPT_LAG03,0)-1) ELSE 0 END AS QV_R_EXPI_EXPT
, CASE WHEN N > 5 THEN DECODE(NVL(R_EXPI_EXPT_LAG06,0),0,0,NVL(R_EXPI_EXPT,0)/NVL(R_EXPI_EXPT_LAG06,0)-1) ELSE 0 END AS SV_R_EXPI_EXPT
, CASE WHEN NVL(R_EXPI_EXPT,0) > NVL(R_EXPI_EXPT_LAG01,0)   THEN 1 ELSE 0 END                                         AS IN_R_EXPI_EXPT
, CASE WHEN NVL(R_EXPI_EXPT,0) < NVL(R_EXPI_EXPT_LAG01,0)   THEN 1 ELSE 0 END                                         AS DC_R_EXPI_EXPT
FROM
(
	SELECT
	 A.*
	, ROW_NUMBER() OVER (PARTITION BY ACCOUNT_ID,EXPENSE_TYPE_CODE ORDER BY ACCOUNT_ID,EXPENSE_TYPE_CODE,PERIOD) 		 AS	N
	, LAG(R_EXPI_EXPT,1,0) OVER (PARTITION BY ACCOUNT_ID,EXPENSE_TYPE_CODE ORDER BY ACCOUNT_ID,EXPENSE_TYPE_CODE,PERIOD) AS R_EXPI_EXPT_LAG01
	, LAG(R_EXPI_EXPT,3,0) OVER (PARTITION BY ACCOUNT_ID,EXPENSE_TYPE_CODE ORDER BY ACCOUNT_ID,EXPENSE_TYPE_CODE,PERIOD) AS R_EXPI_EXPT_LAG03
	, LAG(R_EXPI_EXPT,6,0) OVER (PARTITION BY ACCOUNT_ID,EXPENSE_TYPE_CODE ORDER BY ACCOUNT_ID,EXPENSE_TYPE_CODE,PERIOD) AS R_EXPI_EXPT_LAG06 
	FROM 
		(
			SELECT 
			A.*
			,NVL(RATIO_TO_REPORT(TOT_TRX_AMOUNT) OVER (PARTITION BY PERIOD,ACCOUNT_ID),0) AS R_EXPI_EXPT
			FROM 
			TBT_INPUT_CC_ACC_GRP  A
		)   A
) A
;


--Listing 10-16 Conditional grouping function for the I_R_ATM_EXP_TRX_12MB variable.
AVG(CASE 
		WHEN EXPENSE_TYPE_CODE='ATM' 
		AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-12),'YYYYMM') THEN R_EXPI_EXPT 
	END) 	 AS I_R_ATM_EXP_TRX_12MB

--Listing 10-17 Example of a SELECT transposition via conditional grouping functions.
CREATE TABLE ABT_INPUT_VARIABLES_FROM_TBT NOLOGGING STORAGE(INITIAL 2M NEXT 1M)
AS
SELECT
 A.PERIOD
,A.REF_DATE
,A.ACCOUNT_ID
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-0),'YYYYMM')  THEN R_EXPI_EXPT END) 	 AS I_R_ATM_EXP_TRX_00MB
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-12),'YYYYMM') THEN R_EXPI_EXPT END) 	 AS I_R_ATM_EXP_TRX_12MB
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-0),'YYYYMM')  THEN VM_R_EXPI_EXPT END) AS I_MV_R_ATM_EXP_TRX_L01_00
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM')  THEN VM_R_EXPI_EXPT END) AS I_MV_R_ATM_EXP_TRX_L02_01
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-6),'YYYYMM')  THEN VT_R_EXPI_EXPT END) AS I_QV_R_ATM_EXP_TRX_L09_06
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-9),'YYYYMM')  THEN VT_R_EXPI_EXPT END) AS I_QV_R_ATM_EXP_TRX_L12_09
,SUM(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-6),'YYYYMM')  THEN VS_R_EXPI_EXPT END) AS I_SV_R_ATM_EXP_TRX_L12_06
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
												AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN R_EXPI_EXPT END) 	 AS I_AV_R_ATM_EXP_TRX_L03M
,SUM(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
												AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN IN_R_EXPI_EXPT END)  AS I_SIN_R_ATM_EXP_TRX_L03M
,SUM(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
												AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN DC_R_EXPI_EXPT END)  AS I_SDC_R_ATM_EXP_TRX_L03M
FROM 
 ABT A
,OAF_TBT_INPUT_CC_ACC_GRP B
WHERE 
	A.ACCOUNT_ID=B.ACCOUNT_ID
AND B.PERIOD<=A.PERIOD
GROUP BY
 A.PERIOD
,A.REF_DATE
,A.ACCOUNT_ID
;

--Listing 10-18 Conditional grouping function for the I_AV_R_ATM_EXP_TRX_L03M variable
AVG(CASE 
		WHEN EXPENSE_TYPE_CODE='ATM' 
			AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
			AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN R_EXPI_EXPT 
	END) 	 AS I_AV_R_ATM_EXP_TRX_L03M



--Listing 10-19 Example of input variables being added to the ABT via CURSOR.
DECLARE 
T1 INTEGER:=DBMS_UTILITY.GET_TIME;T2 INTEGER:=0;V_REGS NUMBER:=0;
    CURSOR C1 IS 
    SELECT --/*+FIRST_ROWS(1000) INDEX(B,INX_EXT_PMES_CTA_TCNSM)*/
     A.ROWID
    ,A.PERIOD
    ,A.ACCOUNT_ID
    ,B.I_R_ATM_EXP_TRX_00MB
    ,B.I_R_ATM_EXP_TRX_12MB
    ,B.I_MV_R_ATM_EXP_TRX_L01_00
    ,B.I_MV_R_ATM_EXP_TRX_L02_01
    ,B.I_QV_R_ATM_EXP_TRX_L09_06
    ,B.I_QV_R_ATM_EXP_TRX_L12_09
    ,B.I_SV_R_ATM_EXP_TRX_L12_06
    ,B.I_AV_R_ATM_EXP_TRX_L03M
    ,B.I_SIN_R_ATM_EXP_TRX_L03M
    ,B.I_SDC_R_ATM_EXP_TRX_L03M
    FROM 
     ABT A
    ,ABT_INPUT_VARIABLES_FROM_TBT B
    WHERE
        A.ACCOUNT_ID=B.ACCOUNT_ID
    AND B.PERIOD=A.PERIOD
    ;
BEGIN
UPDATE COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	
	UPDATE ABT A
		SET
         I_R_ATM_EXP_TRX_00MB=B.I_R_ATM_EXP_TRX_00MB
        ,I_R_ATM_EXP_TRX_12MB=B.I_R_ATM_EXP_TRX_12MB
        ,I_MV_R_ATM_EXP_TRX_L01_00=B.I_MV_R_ATM_EXP_TRX_L01_00
        ,I_MV_R_ATM_EXP_TRX_L02_01=B.I_MV_R_ATM_EXP_TRX_L02_01
        ,I_QV_R_ATM_EXP_TRX_L09_06=B.I_QV_R_ATM_EXP_TRX_L09_06
        ,I_QV_R_ATM_EXP_TRX_L12_09=B.I_QV_R_ATM_EXP_TRX_L12_09
        ,I_SV_R_ATM_EXP_TRX_L12_06=B.I_SV_R_ATM_EXP_TRX_L12_06
        ,I_AV_R_ATM_EXP_TRX_L03M=B.I_AV_R_ATM_EXP_TRX_L03M
        ,I_SIN_R_ATM_EXP_TRX_L03M=B.I_SIN_R_ATM_EXP_TRX_L03M
        ,I_SDC_R_ATM_EXP_TRX_L03M=B.I_SDC_R_ATM_EXP_TRX_L03M
   		WHERE ROWID = B.ROWID;
   		
		 IF MOD(C1%ROWCOUNT,10000) = 0  THEN
		 		  UPDATE COUNTER SET COUNTER = COUNTER + 10000;    
		          COMMIT;
		 END IF; 
		 V_REGS := C1%ROWCOUNT; 
	END LOOP;	
	COMMIT;
	T2 :=DBMS_UTILITY.GET_TIME;
	DBMS_OUTPUT.PUT_LINE('-- Records Processed: ' ||TO_CHAR(V_REGS,'999,999,999.99'));
	DBMS_OUTPUT.PUT_LINE('-- Elapsed: ' ||TO_CHAR((T2-T1)/100/60,'999,999,999.99'));
END;
/

--Listing 10-20 Example of a PL/SQL to add the input variables to the ABT.
DECLARE 
    V_CURSOR VARCHAR2(30000);
    V_PROCESS_NUMBER NUMBER;
    V_VAR_PREFIX VARCHAR2(50);
    V_SQL_FUNCTION VARCHAR2(100);
    V_PERIOD_LABEL VARCHAR2(50);
    V_SQL_WHERE VARCHAR2(500);
    CURSOR C1 IS 
    SELECT
        PROCESS_NUM
    ,   VAR_PREFIX||'_'   as VAR_PREFIX
    ,	GRP_FUNCTION
    ,	PERIOD_CD
    ,	SQL_WHERE
    FROM  CTRL_CURSOR
    ORDER BY  PROCESS_NUM
    ;
BEGIN
    FOR B IN C1 LOOP
        V_PROCESS_NUMBER:=B.PROCESS_NUM;
        V_VAR_PREFIX:=  B.VAR_PREFIX;
        V_SQL_FUNCTION:=B.GRP_FUNCTION;
        V_PERIOD_LABEL:=B.PERIOD_CD;
        V_SQL_WHERE:=   B.SQL_WHERE;
        V_CURSOR:='
                DECLARE 
                VSQL VARCHAR2(1000);
                VVARIABLE_NAME VARCHAR2(50);
                VPERIOD_EXE NUMBER;
                VDATE_EXE DATE:=SYSDATE;
                VPROCESS INTEGER;
                VELAPSED NUMBER;
                V_REGS NUMBER:=0;
                T1 DATE:=SYSDATE;
                T2 DATE;
                CURSOR C2 IS 
                SELECT /*+FIRST_ROWS(5000)*/
                 A.ROWID
                ,A.PERIOD
                ,A.ACCOUNT_ID
                ,B.EXPENSE_TYPE_CODE
                ,'||''''||V_VAR_PREFIX||''''||'||TRIM(B.EXPENSE_TYPE_CODE)||'||''''||'_EXP_TRX_'||V_PERIOD_LABEL||''''||' AS VAR_NM
                ,'||V_SQL_FUNCTION||' AS METRIC
                FROM 
                 ABT A
                ,ABT_INPUT_VARIABLES_FROM_TBT B
                WHERE 
                    A.ACCOUNT_ID=B.ACCOUNT_ID 
                AND '||V_SQL_WHERE||'
                GROUP BY
                 A.ROWID
                ,A.PERIOD
                ,A.ACCOUNT_ID
                ,B.EXPENSE_TYPE_CODE
                ,'||''''||V_VAR_PREFIX||''''||'||TRIM(B.EXPENSE_TYPE_CODE)||'||''''||'_EXP_TRX_'||V_PERIOD_LABEL||''''||'
                ;
            BEGIN
            UPDATE COUNTER COUNTER = 0;
                COMMIT;
                FOR B IN C2 LOOP
                    VVARIABLE_NAME := B.VAR_NM;
                    VSQL := '||''''||'UPDATE ABT  A 
					SET '||''''||'||VVARIABLE_NAME||'||''''||' = :VMETRIC WHERE  ROWID = :VROWID'||''''||' 
                            ;
                    EXECUTE IMMEDIATE VSQL USING B.METRIC, B.ROWID;
                     IF MOD(C2%ROWCOUNT,5000) = 0  THEN
                        UPDATE COUNTER SET COUNTER = COUNTER + 5000;
                        VPERIODO_EXE:=TO_CHAR(VDATE_EXE,''YYYYMMDD'');
                        VPROCESS:='||V_PROCESS_NUMBER||';
                        T2:=SYSDATE; 
                        VELAPSED:=TO_NUMBER(T2-T1)*1440*60; 
                        V_REGS := C2%ROWCOUNT;
                        UPDATE CTRL_CURSOR
                            SET
                                EXE_PERIOD=VPERIOD_EXE
                               ,EXE_DATE=VDATE_EXE
                               ,ELAPSED=VELAPSED
                               ,ROW_COUNT=V_REGS 
                        WHERE PROCESS_NUM=VPROCESS
                        ;  
                        COMMIT;
                     END IF;
                END LOOP;	
                COMMIT;
            END;';
            EXECUTE IMMEDIATE V_CURSOR;
            COMMIT;    
    END LOOP;      
END;
/    
							