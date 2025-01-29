DATA INIT_CUTOFFS;
	INPUT ATTRIBUTE  LL_REF_VALUE  UP_REF_VALUE ;
	DATALINES;
1 0 6882
2 6229 12560
3 11365 15570
4 14171 17329
5 15679 24546
6 22115 25170
7 22774 41159
8 37238 83379
9 74971 137529
10 124450 1269917
	;
RUN;


PROC OPTMODEL PRINTLEVEL=2;
	ods output
			SolutionSummary=woe.SolutionSummary
			ProblemSummary=woe.ProblemSummary
	;
	/*|-----------------------------------------------------------------------------------|
	--|Define Sets
	|------------------------------------------------------------------------------------|*/
	set <number> variable;
	set <number> Attributes;
	/*|-----------------------------------------------------------------------------------|
	--|Define Numeric Constants
	|------------------------------------------------------------------------------------|*/
	number INT_I_IM_SUM_09{variable};
	number INT_TARGET_SS{variable};
	number LL_REF_VALUE{Attributes};
	number UP_REF_VALUE{Attributes};
	number N_Obs=50494; /*Declare Total Number of Observations*/
	number N_E= 10438;	/*Declare total Number of Events*/
	number N_NE= 40056;	/*Declare Total Number of No Events*/
	number Bins=10;		/*Declare Number of Bins*/
   	number A_ll_0 =0; 	/*Declare Minimum Variable Value*/ 
   	number A_UL_M =1209444.444+1 ; /*Declare Maximum Variable Value*/
	/*|-----------------------------------------------------------------------------------|
	--|Define Data Sources
	|------------------------------------------------------------------------------------|*/
	read data WOE.INT_I_IM_SUM_09 into variable=[id] INT_I_IM_SUM_09 INT_TARGET_SS;
	read data  INIT_CUTOFFS into Attributes=[Attribute] LL_REF_VALUE  UP_REF_VALUE;
	/*|-----------------------------------------------------------------------------------|
	--|Define Model's Parameters
	|------------------------------------------------------------------------------------|*/
	var A_ll{1..Bins};
	var A_ul{1..Bins};
	/*|-----------------------------------------------------------------------------------|
	--|Define Complex Parameter's Functions
	|------------------------------------------------------------------------------------|*/	
	impvar n_Events{i in 1..Bins}=sum{j in 1..N_Obs}(if A_ll[i]<=INT_I_IM_SUM_09[j]<A_UL[i] then INT_TARGET_SS[j] else 0);
	impvar n_NoEvents{i in 1..Bins}=sum{j in 1..N_Obs}((if A_ll[i]<=INT_I_IM_SUM_09[j]<A_UL[i] then 1 else 0)-(if A_ll[i]<=INT_I_IM_SUM_09[j]<A_UL[i] then INT_TARGET_SS[j] else 0));
	impvar n_Observations{i in 1..Bins}=n_Events[i]+n_NoEvents[i];														
	/*|-----------------------------------------------------------------------------------|
	--|Define Model's Constraints
	|------------------------------------------------------------------------------------|*/
	constraint BINS_INITIAL_LOWERLIMIT{i in 1..Bins-1}: 		A_ll[i]>=LL_REF_VALUE[i];
	constraint BINS_INITAL_UPPERLIMIT{i in 1..Bins-1}:			A_Ul[i]<=UP_REF_VALUE[i];
	constraint BINS_EQUALITIY_LAG{i in 1..Bins-1}: 				A_ll[i+1]=A_Ul[i];
   	constraint BINS_POSITIVE_VALUES{i in 1..Bins}: 				A_ll[i]>=0;
   	constraint BINS_UPPERLIMIT_GE_LOWERLIMIT{i in 1..Bins}: 	A_ll[i]<=A_Ul[i];
	constraint BINS_FIRST_LOWERLIMIT{i in 1..1}:  				A_ll[i]=A_ll_0;
	constraint BINS_LAST_UPPERLIMIT{i in Bins..Bins}: 			A_UL[i]=A_UL_M;
	constraint NOEVENTS_MIN_DISTRIBUTION{i in 1..Bins}: 		n_NoEvents[i]/N_NE>=0.01;
	constraint EVENTS_MIN_DISTRIBUTION{i in 1..Bins}: 			n_Events[i]/N_E>=0.01;
	constraint TOTAL_NUM_OF_OBSERVATIONS: 						sum{i in 1..Bins}n_Observations[i]=N_Obs;
	/*|-----------------------------------------------------------------------------------|
	--|Define The Objective Function
	|------------------------------------------------------------------------------------|*/
	MAX Z =sum{i in 1..Bins} log((IF n_NoEvents[i]=0 THEN 1 ELSE n_NoEvents[i])/(if n_Events[i]=0 then 1 else n_Events[i]))*(n_NoEvents[i]/N_NE-n_Events[i]/N_E);
	/*|-----------------------------------------------------------------------------------|
	--|Define Solver Parameters
	|------------------------------------------------------------------------------------|*/	
	expand/solve con obj  FIX ;
	performance nthreads=4;
    solve with nlp
	/
	printfreq=1
	maxiter=10000
	opttol=1e-9
	feastol=1e-6
	soltype=1
	hesstype=full
	maxtime=200
	;
	print 
	 LL_REF_VALUE  
	 UP_REF_VALUE
	 A_ll.sol
	 A_ul.sol
	;
	/*|-----------------------------------------------------------------------------------|
	--|Define Numeric Outputs 
	|------------------------------------------------------------------------------------|*/
	number LL_ATTRI{i in 1..Bins}=A_ll[i].sol;
	number UL_ATTRI{i in 1..Bins}=A_ul[i].sol;
	number total_Obs{i in 1..Bins}=n_Observations[i].sol;
	number Event_Obs{i in 1..Bins}=n_Events[i].sol;
	number NoEvent_Obs{i in 1..Bins}= n_NoEvents[i].sol;
	number D_obs{i in 1..Bins}=n_Observations[i].sol/N_Obs;
	number D_Events{i in 1..Bins}=n_Events[i].sol/N_E;	
	number D_Noevents{i in 1..Bins}=n_NoEvents[i].sol/N_NE;
	number P_Events{i in 1..Bins}=n_Events[i].sol/n_Observations[i].sol;
	number n_WOE{i in 1..Bins}=log((IF n_NoEvents[i].SOL=0 THEN 1 ELSE n_NoEvents[i].SOL)/(if n_Events[i].SOL=0 then 1 else n_Events[i].SOL));
	number n_DNE_DE{i in 1..Bins}=(n_NoEvents[i].sol/N_NE-n_Events[i].sol/N_E);
	number n_IV{i in 1..Bins}=log((IF n_NoEvents[i].SOL=0 THEN 1 ELSE n_NoEvents[i].SOL)/(if n_Events[i].SOL=0 then 1 else n_Events[i].SOL))*(n_NoEvents[i].sol/N_NE-n_Events[i].sol/N_E);
	/*number Obj_Function =sum{i in 1..Bins} log((IF n_NoEvents[i].sol=0 THEN 1 ELSE n_NoEvents[i].sol)/(if n_Events[i].sol=0 then 1 else n_Events[i].sol))*(n_NoEvents[i].sol/N_NE-n_Events[i].sol/N_E);*/
	/*|-----------------------------------------------------------------------------------|
	--|Create Output Data Set 
	|------------------------------------------------------------------------------------|*/
	create data woe.woe_results from [i] 
										Bin_LL=LL_ATTRI
										Bin_UL=UL_ATTRI
										Observations=total_Obs 
										Events=Event_Obs 
										NoEvents=NoEvent_Obs
										Obs_Dist=D_obs
										Event_Dist=D_Events
										NoEvent_Dist=D_Noevents
										Events_Prop=P_Events
										WOE=n_WOE
										DNE_DE=n_DNE_DE
										IV=n_IV
	;
QUIT;