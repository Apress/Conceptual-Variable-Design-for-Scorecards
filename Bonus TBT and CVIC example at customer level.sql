
-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 1
--|ABT: ABT
--|Operation:   Create
--|Description: Add MCC and transaction tpye to credit card transactional table
--|Input:       CC_TRANSACTIONS
--|Output:      TRX_INPUT_CC_ACC
-------------------------------------------------------------------------------------------|
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

-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 1'
--|ABT: ABT
--|Operation:   Create
--|Description: Add customer ID for future grouping operations
--|Input:       BRD_CUSTOMER_X_ACCOUNT_CC
--|Output:      TRX_INPUT_CC_ACC
-------------------------------------------------------------------------------------------|
ALTER TABLE TRX_INPUT_CC_ACC ADD CUSTOMER_ID VARCHAR2(50);

DECLARE 
t1 integer:=dbms_utility.get_time;t2 integer:=0;v_regs number:=0;
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
	
	update TRX_INPUT_CC_ACC A
		set
         CUSTOMER_ID= B.CUSTOMER_ID
   		where rowid = B.rowid;
   		
		 IF MOD(C1%ROWCOUNT,10000) = 0  THEN
		 		  UPDATE COUNTER SET COUNTER = COUNTER + 10000;    
		          COMMIT;
		 END IF; 
		 v_regs := c1%rowcount; 
	END LOOP;	
	commit;
	t2 :=dbms_utility.get_time;
	dbms_output.put_line('-- Registros Procesados: ' ||to_char(v_regs,'999,999,999.99'));
	dbms_output.put_line('-- Tiempo: ' ||to_char((t2-t1)/100/60,'999,999,999.99'));
END;
/	

-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 2
--|ABT: ABT
--|Operation:   Create
--|Description: Create group table at period, account, and expense type level
--|Input:       TRX_INPUT_CC_ACC
--|Output:      TRX_INPUT_CC_CUS_GRP
-------------------------------------------------------------------------------------------|
DROP TABLE FEDESASCOR.FM_TRX_GRP_BY_CNSM_TDC_CTA PURGE;

CREATE TABLE TRX_INPUT_CC_CUS_GRP
AS
SELECT 
 PERIOD
,CUSTOMER_ID
,EXPENSE_TYPE_CODE
,EXPENSE_TYPE_DESC
,SUM(TRX_AMOUNT) AS  TOT_TRX_AMOUNT
,COUNT(1) 		 AS  TRANSACTIONS
FROM TRX_INPUT_CC_ACC A
WHERE 
--Extract only expenses
TRX_TYPE IN (
 'PURCHASE'
,'CASH WITHDRAW'
)
AND TRX_DIRECTION='OUTPUT'
--Limit the extraction to the target population, and analysis timeframe
AND EXISTS(
	SELECT
	*
	FROM ABT B
	WHERE A.CUSTOMER_ID=B.CUSTOMER_ID
)
AND PERIOD BETWEEN INITIAL_TIME AND END_TIME
GROUP BY 
 PERIOD
,CUSTOMER_ID
,EXPENSE_TYPE_CODE
,EXPENSE_TYPE_DESC
;

-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 3
--|ABT: ABT
--|Operation:   Create
--|Description: Create time period catalog
--|Input:       TRX_INPUT_CC_CUS_GRP
--|Output:      TIME_PERIOD_CATALOG
-------------------------------------------------------------------------------------------|
CREATE TABLE TIME_PERIOD_CATALOG
AS
SELECT
DISTINCT
PERIOD
FROM 
TRX_INPUT_CC_CUS_GRP  A
ORDER BY 
PERIOD
;
-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 4
--|ABT: ABT
--|Operation:   Create
--|Description: Create customer, time period catalog
--|Input:       TRX_INPUT_CC_CUS_GRP
--|Output:      CUSTOMER_TIME_PERIOD_CATALOG
-------------------------------------------------------------------------------------------|
CREATE TABLE CUSTOMER_TIME_PERIOD_CATALOG
AS
SELECT
DISTINCT
 CUSTOMER_ID
,PERIOD
FROM 
TRX_INPUT_CC_CUS_GRP  A
ORDER BY 
 CUSTOMER_ID
,PERIOD
;
-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 5
--|ABT: ABT
--|Operation:   Create
--|Description: Create expense type catalog
--|Input:       TRX_INPUT_CC_CUS_GRP
--|Output:      EXPENSE_TYPE_CATALOG
-------------------------------------------------------------------------------------------|
CREATE TABLE EXPENSE_TYPE_CATALOG
AS
SELECT
DISTINCT
EXPENSE_TYPE_CODE
FROM 
TRX_INPUT_CC_CUS_GRP  A
ORDER BY 
EXPENSE_TYPE_CODE
;
-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 6
--|ABT: ABT
--|Operation:   Create
--|Description: Create TBT structure
--|Input:       TIME_PERIOD_CATALOG CUSTOMER_TIME_PERIOD_CATALOG EXPENSE_TYPE_CATALOG
--|Output:      TBT_INPUT_CC_CUS_GRP
-------------------------------------------------------------------------------------------|
CREATE TABLE TBT_INPUT_CC_CUS_GRP NOLOGGING STORAGE(INITIAL 2M NEXT 1M)
AS
SELECT
DISTINCT 
 A.PERIOD
,B.CUSTOMER_ID
,C.EXPENSE_TYPE_CODE
,0 TOT_TRX_AMOUNT
,0 TRANSACTIONS
FROM 
 TIME_PERIOD_CATALOG A
,CUSTOMER_TIME_PERIOD_CATALOG B
,EXPENSE_TYPE_CATALOG C
WHERE 
    A.PERIOD>=B.PERIOD
ORDER BY
 A.PERIOD
,B.CUSTOMER_ID
,C.EXPENSE_TYPE_CODE
;

-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 7
--|ABT: ABT
--|Operation:   Create unique indexes
--|Description: create unique indexes for both, the TBT, and the TRX source table
--|Input:       TBT_INPUT_CC_CUS_GRP(PERIOD,CUSTOMER_ID,EXPENSE_TYPE_CODE) TRX_INPUT_CC_CUS_GRP(PERIOD,CUSTOMER_ID,EXPENSE_TYPE_CODE)
--|Output:      INX_TBT_INPUT_CC_CUS_GRP INX_TRX_INPUT_CC_CUS_GRP
-------------------------------------------------------------------------------------------|
CREATE UNIQUE INDEX INX_TBT_INPUT_CC_CUS_GRP ON  
TBT_INPUT_CC_CUS_GRP(PERIOD,CUSTOMER_ID,EXPENSE_TYPE_CODE) TABLESPACE SC_SASIDX;

CREATE UNIQUE INDEX INX_TRX_INPUT_CC_CUS_GRP 	ON  
TRX_INPUT_CC_CUS_GRP(PERIOD,CUSTOMER_ID,EXPENSE_TYPE_CODE) TABLESPACE SC_SASIDX;


-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 8
--|ABT: ABT
--|Operation:   PL/SQL Cursor
--|Description: Populate TBT with TRX source
--|Input:       TRX_INPUT_CC_CUS_GRP
--|Output:      TBT_TRX_INPUT_CC_CUS_GRP
-------------------------------------------------------------------------------------------|
DECLARE 
t1 integer:=dbms_utility.get_time;t2 integer:=0;v_regs number:=0;
 CURSOR C1 IS 
    SELECT   /*+ INDEX(A,INX_TBT_TRX_INPUT_CC_CUS_GRP) INDEX(B, INX_TRX_INPUT_CC_CUS_GRP) FIRST_ROWS(10000) */  
        A.ROWID
    ,   B.TOT_TRX_AMOUNT  
    ,   B.TRANSACTIONS   
    FROM 	 
     TBT_TRX_INPUT_CC_CUS_GRP  A
    ,TRX_INPUT_CC_CUS_GRP  B
    WHERE 
        A.CUSTOMER_ID=B.CUSTOMER_ID
    AND A.PERIOD=B.PERIOD
    AND A.EXPENSE_TYPE_CODE=B.EXPENSE_TYPE_CODE
    ;
BEGIN
UPDATE COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	update TBT_TRX_INPUT_CC_CUS_GRP A
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
	t2 :=dbms_utility.get_time;
	dbms_output.put_line('-- Registros Procesados: ' ||to_char(v_regs,'999,999,999.99'));
	dbms_output.put_line('-- Tiempo: ' ||to_char((t2-t1)/100/60,'999,999,999.99'));
END;
/


-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 9
--|ABT: ABT
--|Operation:   Create
--|Description: Create base metrics via Oracle's analytical functions using the TBT as input
--|Input:       TBT_TRX_INPUT_CC_CUS_GRP
--|Output:      OAF_TBT_INPUT_CC_CUS_GRP
-------------------------------------------------------------------------------------------|
CREATE TABLE OAF_TBT_INPUT_CC_CUS_GRP NOLOGGING STORAGE(INITIAL 2M NEXT 1M)
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
	, ROW_NUMBER() OVER (PARTITION BY CUSTOMER_ID,EXPENSE_TYPE_CODE ORDER BY CUSTOMER_ID,EXPENSE_TYPE_CODE,PERIOD) 		 AS	N
	, LAG(R_EXPI_EXPT,1,0) OVER (PARTITION BY CUSTOMER_ID,EXPENSE_TYPE_CODE ORDER BY CUSTOMER_ID,EXPENSE_TYPE_CODE,PERIOD) AS R_EXPI_EXPT_LAG01
	, LAG(R_EXPI_EXPT,3,0) OVER (PARTITION BY CUSTOMER_ID,EXPENSE_TYPE_CODE ORDER BY CUSTOMER_ID,EXPENSE_TYPE_CODE,PERIOD) AS R_EXPI_EXPT_LAG03
	, LAG(R_EXPI_EXPT,6,0) OVER (PARTITION BY CUSTOMER_ID,EXPENSE_TYPE_CODE ORDER BY CUSTOMER_ID,EXPENSE_TYPE_CODE,PERIOD) AS R_EXPI_EXPT_LAG06 
	FROM 
		(
			SELECT 
			A.*
			,NVL(RATIO_TO_REPORT(TOT_TRX_AMOUNT) OVER (PARTITION BY PERIOD,CUSTOMER_ID),0) AS R_EXPI_EXPT
			FROM 
			TBT_INPUT_CC_CUS_GRP  A
		)   A
) A
;


-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 10
--|ABT: ABT
--|Operation:   Create
--|Description: Create final explanatory variables via conditional grouping functions, using the TBT with OAFs
--|Input:       OAF_TBT_INPUT_CC_CUS_GRP
--|Output:      ABT_INPUT_VARIABLES_FROM_TBT
-------------------------------------------------------------------------------------------|
CREATE TABLE ABT_INPUT_VARIABLES_FROM_TBT NOLOGGING STORAGE(INITIAL 2M NEXT 1M)
AS
SELECT
 A.PERIOD
,A.REF_DATE
,A.CUSTOMER_ID
,A.ROWID AS ROW_ID
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-0),'YYYYMM')  THEN R_EXPI_EXPT ELSE 0 END) 	 AS I_R_ATM_EXP_TRX_00MB
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-12),'YYYYMM') THEN R_EXPI_EXPT ELSE 0 END) 	 AS I_R_ATM_EXP_TRX_12MB
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-0),'YYYYMM')  THEN VM_R_EXPI_EXPT ELSE 0 END) AS I_MV_R_ATM_EXP_TRX_L01_00
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM')  THEN VM_R_EXPI_EXPT ELSE 0 END) AS I_MV_R_ATM_EXP_TRX_L02_01
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-6),'YYYYMM')  THEN VT_R_EXPI_EXPT ELSE 0 END) AS I_QV_R_ATM_EXP_TRX_L09_06
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-9),'YYYYMM')  THEN VT_R_EXPI_EXPT ELSE 0 END) AS I_QV_R_ATM_EXP_TRX_L12_09
,SUM(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD=TO_CHAR(ADD_MONTHS(A.REF_DATE,-6),'YYYYMM')  THEN VS_R_EXPI_EXPT ELSE 0 END) AS I_SV_R_ATM_EXP_TRX_L12_06
,AVG(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
												AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN R_EXPI_EXPT ELSE 0 END) 	 AS I_AV_R_ATM_EXP_TRX_L03M
,SUM(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
												AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN IN_R_EXPI_EXPT ELSE 0 END)  AS I_SIN_R_ATM_EXP_TRX_L03M
,SUM(CASE WHEN EXPENSE_TYPE_CODE='ATM' AND B.PERIOD BETWEEN TO_CHAR(ADD_MONTHS(A.REF_DATE,-3),'YYYYMM') 
												AND TO_CHAR(ADD_MONTHS(A.REF_DATE,-1),'YYYYMM') THEN DC_R_EXPI_EXPT ELSE 0 END)  AS I_SDC_R_ATM_EXP_TRX_L03M
FROM 
 ABT A
,OAF_TBT_INPUT_CC_CUS_GRP B
WHERE 
	A.CUSTOMER_ID=B.CUSTOMER_ID
AND B.PERIOD<=A.PERIOD
GROUP BY
 A.PERIOD
,A.REF_DATE
,A.CUSTOMER_ID
,A.ROWID
;

-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 11
--|ABT: ABT
--|Operation:   Create
--|Description: Add final explanatory variables to ABT, advanced version, no join needed
--|Input:       ABT_INPUT_VARIABLES_FROM_TBT
--|Output:      ABT
-------------------------------------------------------------------------------------------|
DECLARE 
t1 integer:=dbms_utility.get_time;t2 integer:=0;v_regs number:=0;
    CURSOR C1 IS 
    SELECT --/*+FIRST_ROWS(1000) index(b,INX_EXT_PMES_CTA_TCNSM)*/
     B.ROW_ID
    ,B.PERIOD
    ,B.CUSTOMER_ID
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
    ABT_INPUT_VARIABLES_FROM_TBT B
    ;
BEGIN
UPDATE COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	
	update ABT A
		set
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
   		where rowid = B.ROW_ID;
   		
		 IF MOD(C1%ROWCOUNT,10000) = 0  THEN
		 		  UPDATE COUNTER SET COUNTER = COUNTER + 10000;    
		          COMMIT;
		 END IF; 
		 v_regs := c1%rowcount; 
	END LOOP;	
	commit;
	t2 :=dbms_utility.get_time;
	dbms_output.put_line('-- Registros Procesados: ' ||to_char(v_regs,'999,999,999.99'));
	dbms_output.put_line('-- Tiempo: ' ||to_char((t2-t1)/100/60,'999,999,999.99'));
END;
/



-------------------------------------------------------------------------------------------|
--|Process: TBT creation
--|Step: 11'
--|ABT: ABT
--|Operation:   Create
--|Description: Add final explanatory variables to ABT, simple version, join needed
--|Input:       ABT_INPUT_VARIABLES_FROM_TBT
--|Output:      ABT
-------------------------------------------------------------------------------------------|
DECLARE 
t1 integer:=dbms_utility.get_time;t2 integer:=0;v_regs number:=0;
    CURSOR C1 IS 
    SELECT --/*+FIRST_ROWS(1000) index(b,INX_EXT_PMES_CTA_TCNSM)*/
     A.ROWID
    ,A.PERIOD
    ,A.CUSTOMER_ID
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
        A.CUSTOMER_ID=B.CUSTOMER_ID
    AND B.PERIOD=A.PERIOD
    ;
BEGIN
UPDATE COUNTER SET COUNTER = 0;
    COMMIT;
	FOR B IN C1 LOOP
	
	update ABT A
		set
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
   		where rowid = B.rowid;
   		
		 IF MOD(C1%ROWCOUNT,10000) = 0  THEN
		 		  UPDATE COUNTER SET COUNTER = COUNTER + 10000;    
		          COMMIT;
		 END IF; 
		 v_regs := c1%rowcount; 
	END LOOP;	
	commit;
	t2 :=dbms_utility.get_time;
	dbms_output.put_line('-- Registros Procesados: ' ||to_char(v_regs,'999,999,999.99'));
	dbms_output.put_line('-- Tiempo: ' ||to_char((t2-t1)/100/60,'999,999,999.99'));
END;
/
