DATA 	SCR_MDL_B_PD_CRD_202301;
		SET SCR_ABT_B_PD_CRD_202301;

	*------------------------------------------------------------*;
	* Variable: I_AGE_YRS;
	*------------------------------------------------------------*;
	LABEL GRP_I_AGE_YRS =
	"Grouped: I_AGE_YRS";
	LABEL WOE_I_AGE_YRS =
	"Weight of Evidence: I_AGE_YRS";

	if MISSING(I_AGE_YRS) then do;
	GRP_I_AGE_YRS = 1;
	WOE_I_AGE_YRS =            0;
	end;
	else if NOT MISSING(I_AGE_YRS) then do;
	if I_AGE_YRS < 27.79 then do;
	GRP_I_AGE_YRS = 2;
	WOE_I_AGE_YRS = -0.820019759;
	end;
	else
	if 27.79 <= I_AGE_YRS AND I_AGE_YRS < 33.76 then do;
	GRP_I_AGE_YRS = 3;
	WOE_I_AGE_YRS =  -0.57582914;
	end;
	else
	if 33.76 <= I_AGE_YRS AND I_AGE_YRS < 40.93 then do;
	GRP_I_AGE_YRS = 4;
	WOE_I_AGE_YRS =  -0.34559292;
	end;
	else
	if 40.93 <= I_AGE_YRS AND I_AGE_YRS < 46.58 then do;
	GRP_I_AGE_YRS = 5;
	WOE_I_AGE_YRS =  -0.06280172;
	end;
	else
	if 46.58 <= I_AGE_YRS AND I_AGE_YRS < 51.91 then do;
	GRP_I_AGE_YRS = 6;
	WOE_I_AGE_YRS = 0.2117495907;
	end;
	else
	if 51.91 <= I_AGE_YRS then do;
	GRP_I_AGE_YRS = 7;
	WOE_I_AGE_YRS = 0.5285673944;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_LOAN_AGE_YRS;
	*------------------------------------------------------------*;
	LABEL GRP_I_LOAN_AGE_YRS =
	"Grouped: I_LOAN_AGE_YRS";
	LABEL WOE_I_LOAN_AGE_YRS =
	"Weight of Evidence: I_LOAN_AGE_YRS";

	if MISSING(I_LOAN_AGE_YRS) then do;
	GRP_I_LOAN_AGE_YRS = 1;
	WOE_I_LOAN_AGE_YRS =            0;
	end;
	else if NOT MISSING(I_LOAN_AGE_YRS) then do;
	if I_LOAN_AGE_YRS < 0.87 then do;
	GRP_I_LOAN_AGE_YRS = 2;
	WOE_I_LOAN_AGE_YRS = 0.1975063315;
	end;
	else
	if 0.87 <= I_LOAN_AGE_YRS AND I_LOAN_AGE_YRS < 1.25 then do;
	GRP_I_LOAN_AGE_YRS = 3;
	WOE_I_LOAN_AGE_YRS =  0.024241468;
	end;
	else
	if 1.25 <= I_LOAN_AGE_YRS then do;
	GRP_I_LOAN_AGE_YRS = 4;
	WOE_I_LOAN_AGE_YRS = -0.114715387;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_MX_DYSPSTDUE_LON_L12M;
	*------------------------------------------------------------*;
	LABEL GRP_I_MX_DYSPSTDUE_LON_L12M =
	"Grouped: I_MX_DYSPSTDUE_LON_L12M";
	LABEL WOE_I_MX_DYSPSTDUE_LON_L12M =
	"Weight of Evidence: I_MX_DYSPSTDUE_LON_L12M";

	if MISSING(I_MX_DYSPSTDUE_LON_L12M) then do;
	GRP_I_MX_DYSPSTDUE_LON_L12M = 1;
	WOE_I_MX_DYSPSTDUE_LON_L12M = 1.5475221976;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_LON_L12M) then do;
	if I_MX_DYSPSTDUE_LON_L12M < 4 then do;
	GRP_I_MX_DYSPSTDUE_LON_L12M = 2;
	WOE_I_MX_DYSPSTDUE_LON_L12M = 0.5427430614;
	end;
	else
	if 4 <= I_MX_DYSPSTDUE_LON_L12M AND I_MX_DYSPSTDUE_LON_L12M < 20 then do;
	GRP_I_MX_DYSPSTDUE_LON_L12M = 3;
	WOE_I_MX_DYSPSTDUE_LON_L12M = -0.137222726;
	end;
	else
	if 20 <= I_MX_DYSPSTDUE_LON_L12M AND I_MX_DYSPSTDUE_LON_L12M < 36 then do;
	GRP_I_MX_DYSPSTDUE_LON_L12M = 4;
	WOE_I_MX_DYSPSTDUE_LON_L12M = -0.815286775;
	end;
	else
	if 36 <= I_MX_DYSPSTDUE_LON_L12M AND I_MX_DYSPSTDUE_LON_L12M < 70 then do;
	GRP_I_MX_DYSPSTDUE_LON_L12M = 5;
	WOE_I_MX_DYSPSTDUE_LON_L12M = -1.458094021;
	end;
	else
	if 70 <= I_MX_DYSPSTDUE_LON_L12M then do;
	GRP_I_MX_DYSPSTDUE_LON_L12M = 6;
	WOE_I_MX_DYSPSTDUE_LON_L12M = -1.641134842;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_MX_DYSPSTDUE_CCR_L12M;
	*------------------------------------------------------------*;
	LABEL GRP_I_MX_DYSPSTDUE_CCR_L12M =
	"Grouped: I_MX_DYSPSTDUE_CCR_L12M";
	LABEL WOE_I_MX_DYSPSTDUE_CCR_L12M =
	"Weight of Evidence: I_MX_DYSPSTDUE_CCR_L12M";

	if MISSING(I_MX_DYSPSTDUE_CCR_L12M) then do;
	GRP_I_MX_DYSPSTDUE_CCR_L12M = 1;
	WOE_I_MX_DYSPSTDUE_CCR_L12M = 0.1302631044;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_CCR_L12M) then do;
	if I_MX_DYSPSTDUE_CCR_L12M < 6 then do;
	GRP_I_MX_DYSPSTDUE_CCR_L12M = 2;
	WOE_I_MX_DYSPSTDUE_CCR_L12M = -0.069299391;
	end;
	else
	if 6 <= I_MX_DYSPSTDUE_CCR_L12M then do;
	GRP_I_MX_DYSPSTDUE_CCR_L12M = 3;
	WOE_I_MX_DYSPSTDUE_CCR_L12M = -0.825656892;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_RISK_LEVEL;
	*------------------------------------------------------------*;
	LABEL GRP_I_RISK_LEVEL =
	"Grouped: I_RISK_LEVEL";
	LABEL WOE_I_RISK_LEVEL =
	"Weight of Evidence: I_RISK_LEVEL";

	if MISSING(I_RISK_LEVEL) then do;
	GRP_I_RISK_LEVEL = 1;
	WOE_I_RISK_LEVEL = 1.3692739662;
	end;
	else if NOT MISSING(I_RISK_LEVEL) then do;
	if I_RISK_LEVEL < 3 then do;
	GRP_I_RISK_LEVEL = 2;
	WOE_I_RISK_LEVEL = 0.9836274885;
	end;
	else
	if 3 <= I_RISK_LEVEL AND I_RISK_LEVEL < 4 then do;
	GRP_I_RISK_LEVEL = 3;
	WOE_I_RISK_LEVEL = -0.171261105;
	end;
	else
	if 4 <= I_RISK_LEVEL AND I_RISK_LEVEL < 11 then do;
	GRP_I_RISK_LEVEL = 4;
	WOE_I_RISK_LEVEL =  -1.32681181;
	end;
	else
	if 11 <= I_RISK_LEVEL then do;
	GRP_I_RISK_LEVEL = 5;
	WOE_I_RISK_LEVEL = -2.804361096;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_NUMDEPEND;
	*------------------------------------------------------------*;
	LABEL GRP_I_NUMDEPEND =
	"Grouped: I_NUMDEPEND";
	LABEL WOE_I_NUMDEPEND =
	"Weight of Evidence: I_NUMDEPEND";

	if MISSING(I_NUMDEPEND) then do;
	GRP_I_NUMDEPEND = 1;
	WOE_I_NUMDEPEND = 0.3222586705;
	end;
	else if NOT MISSING(I_NUMDEPEND) then do;
	if I_NUMDEPEND < 1 then do;
	GRP_I_NUMDEPEND = 2;
	WOE_I_NUMDEPEND = -0.120083215;
	end;
	else
	if 1 <= I_NUMDEPEND AND I_NUMDEPEND < 4 then do;
	GRP_I_NUMDEPEND = 3;
	WOE_I_NUMDEPEND = 0.0707130804;
	end;
	else
	if 4 <= I_NUMDEPEND then do;
	GRP_I_NUMDEPEND = 4;
	WOE_I_NUMDEPEND = 0.1525713223;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SDC_R_CHRG_CRRA_CPM_L12M;
	*------------------------------------------------------------*;
	LABEL GRP_I_SDC_R_CHRG_CRRA_CPM_L12M =
	"Grouped: I_SDC_R_CHRG_CRRA_CPM_L12M";
	LABEL WOE_I_SDC_R_CHRG_CRRA_CPM_L12M =
	"Weight of Evidence: I_SDC_R_CHRG_CRRA_CPM_L12M";

	if MISSING(I_SDC_R_CHRG_CRRA_CPM_L12M) then do;
	GRP_I_SDC_R_CHRG_CRRA_CPM_L12M = 1;
	WOE_I_SDC_R_CHRG_CRRA_CPM_L12M = -0.049928219;
	end;
	else if NOT MISSING(I_SDC_R_CHRG_CRRA_CPM_L12M) then do;
	if I_SDC_R_CHRG_CRRA_CPM_L12M < 5 then do;
	GRP_I_SDC_R_CHRG_CRRA_CPM_L12M = 2;
	WOE_I_SDC_R_CHRG_CRRA_CPM_L12M = -0.064825046;
	end;
	else
	if 5 <= I_SDC_R_CHRG_CRRA_CPM_L12M AND I_SDC_R_CHRG_CRRA_CPM_L12M < 11 then do;
	GRP_I_SDC_R_CHRG_CRRA_CPM_L12M = 3;
	WOE_I_SDC_R_CHRG_CRRA_CPM_L12M = 0.1730589792;
	end;
	else
	if 11 <= I_SDC_R_CHRG_CRRA_CPM_L12M then do;
	GRP_I_SDC_R_CHRG_CRRA_CPM_L12M = 4;
	WOE_I_SDC_R_CHRG_CRRA_CPM_L12M = 0.8322941812;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SDC_R_PAYT_BALT_CLC_L06M;
	*------------------------------------------------------------*;
	LABEL GRP_I_SDC_R_PAYT_BALT_CLC_L06M =
	"Grouped: I_SDC_R_PAYT_BALT_CLC_L06M";
	LABEL WOE_I_SDC_R_PAYT_BALT_CLC_L06M =
	"Weight of Evidence: I_SDC_R_PAYT_BALT_CLC_L06M";

	if MISSING(I_SDC_R_PAYT_BALT_CLC_L06M) then do;
	GRP_I_SDC_R_PAYT_BALT_CLC_L06M = 1;
	WOE_I_SDC_R_PAYT_BALT_CLC_L06M = 1.5475221976;
	end;
	else if NOT MISSING(I_SDC_R_PAYT_BALT_CLC_L06M) then do;
	if I_SDC_R_PAYT_BALT_CLC_L06M < 1 then do;
	GRP_I_SDC_R_PAYT_BALT_CLC_L06M = 2;
	WOE_I_SDC_R_PAYT_BALT_CLC_L06M = 0.2071429694;
	end;
	else
	if 1 <= I_SDC_R_PAYT_BALT_CLC_L06M then do;
	GRP_I_SDC_R_PAYT_BALT_CLC_L06M = 3;
	WOE_I_SDC_R_PAYT_BALT_CLC_L06M = -0.467782127;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SIN_R_BALT_APPR_CLC_L03M;
	*------------------------------------------------------------*;
	LABEL GRP_I_SIN_R_BALT_APPR_CLC_L03M =
	"Grouped: I_SIN_R_BALT_APPR_CLC_L03M";
	LABEL WOE_I_SIN_R_BALT_APPR_CLC_L03M =
	"Weight of Evidence: I_SIN_R_BALT_APPR_CLC_L03M";

	if MISSING(I_SIN_R_BALT_APPR_CLC_L03M) then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L03M = 1;
	WOE_I_SIN_R_BALT_APPR_CLC_L03M = 1.5475221976;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L03M) then do;
	if I_SIN_R_BALT_APPR_CLC_L03M < 1 then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L03M = 2;
	WOE_I_SIN_R_BALT_APPR_CLC_L03M = 0.1694507479;
	end;
	else
	if 1 <= I_SIN_R_BALT_APPR_CLC_L03M then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L03M = 3;
	WOE_I_SIN_R_BALT_APPR_CLC_L03M = -0.489984368;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SIN_R_BALT_APPR_CLC_L13_24;
	*------------------------------------------------------------*;
	LABEL GRP_I_SIN_R_BALT_APPR_CLC_L13_24 =
	"Grouped: I_SIN_R_BALT_APPR_CLC_L13_24";
	LABEL WOE_I_SIN_R_BALT_APPR_CLC_L13_24 =
	"Weight of Evidence: I_SIN_R_BALT_APPR_CLC_L13_24";

	if MISSING(I_SIN_R_BALT_APPR_CLC_L13_24) then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L13_24 = 1;
	WOE_I_SIN_R_BALT_APPR_CLC_L13_24 = 1.5475221976;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L13_24) then do;
	if I_SIN_R_BALT_APPR_CLC_L13_24 < 1 then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L13_24 = 2;
	WOE_I_SIN_R_BALT_APPR_CLC_L13_24 = 0.2512380831;
	end;
	else
	if 1 <= I_SIN_R_BALT_APPR_CLC_L13_24 AND I_SIN_R_BALT_APPR_CLC_L13_24 < 2 then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L13_24 = 3;
	WOE_I_SIN_R_BALT_APPR_CLC_L13_24 = -0.018430934;
	end;
	else
	if 2 <= I_SIN_R_BALT_APPR_CLC_L13_24 then do;
	GRP_I_SIN_R_BALT_APPR_CLC_L13_24 = 4;
	WOE_I_SIN_R_BALT_APPR_CLC_L13_24 = -0.584905201;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SV_R_PAYA_INST_CLC_L12_06;
	*------------------------------------------------------------*;
	LABEL GRP_I_SV_R_PAYA_INST_CLC_L12_06 =
	"Grouped: I_SV_R_PAYA_INST_CLC_L12_06";
	LABEL WOE_I_SV_R_PAYA_INST_CLC_L12_06 =
	"Weight of Evidence: I_SV_R_PAYA_INST_CLC_L12_06";

	if MISSING(I_SV_R_PAYA_INST_CLC_L12_06) then do;
	GRP_I_SV_R_PAYA_INST_CLC_L12_06 = 1;
	WOE_I_SV_R_PAYA_INST_CLC_L12_06 = 1.5475221976;
	end;
	else if NOT MISSING(I_SV_R_PAYA_INST_CLC_L12_06) then do;
	if I_SV_R_PAYA_INST_CLC_L12_06 < -0.01 then do;
	GRP_I_SV_R_PAYA_INST_CLC_L12_06 = 2;
	WOE_I_SV_R_PAYA_INST_CLC_L12_06 =  -0.82237119;
	end;
	else
	if -0.01 <= I_SV_R_PAYA_INST_CLC_L12_06 then do;
	GRP_I_SV_R_PAYA_INST_CLC_L12_06 = 3;
	WOE_I_SV_R_PAYA_INST_CLC_L12_06 =  0.072267225;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: I_QT_R_BALT_APPR_CLC_L12_09;
	*------------------------------------------------------------*;
	LABEL GRP_I_QT_R_BALT_APPR_CLC_L12_09 =
	"Grouped: I_QT_R_BALT_APPR_CLC_L12_09";
	LABEL WOE_I_QT_R_BALT_APPR_CLC_L12_09 =
	"Weight of Evidence: I_QT_R_BALT_APPR_CLC_L12_09";

	if MISSING(I_QT_R_BALT_APPR_CLC_L12_09) then do;
	GRP_I_QT_R_BALT_APPR_CLC_L12_09 = 1;
	WOE_I_QT_R_BALT_APPR_CLC_L12_09 = 1.5475221976;
	end;
	else if NOT MISSING(I_QT_R_BALT_APPR_CLC_L12_09) then do;
	if I_QT_R_BALT_APPR_CLC_L12_09 < 0 then do;
	GRP_I_QT_R_BALT_APPR_CLC_L12_09 = 2;
	WOE_I_QT_R_BALT_APPR_CLC_L12_09 = 0.2799386922;
	end;
	else
	if 0 <= I_QT_R_BALT_APPR_CLC_L12_09 then do;
	GRP_I_QT_R_BALT_APPR_CLC_L12_09 = 3;
	WOE_I_QT_R_BALT_APPR_CLC_L12_09 = -0.437452374;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: N_HOMESTATUS;
	*------------------------------------------------------------*;
	LABEL GRP_N_HOMESTATUS =
	"Grouped: N_HOMESTATUS";
	LABEL WOE_N_HOMESTATUS =
	"Weight of Evidence: N_HOMESTATUS";

	_UFormat200 = put(N_HOMESTATUS,$4.);
	%dmnormip(_UFormat200);
	if MISSING(_UFormat200) then do;
	GRP_N_HOMESTATUS = 3;
	WOE_N_HOMESTATUS =            0;
	end;
	else if NOT MISSING(_UFormat200) then do;
	if (_UFormat200 eq 'A' OR _UFormat200 eq 'F' OR _UFormat200 eq 'O'
	) then do;
	GRP_N_HOMESTATUS = 1;
	WOE_N_HOMESTATUS = -0.208019794;
	end;
	else
	if (_UFormat200 eq 'OTRO' OR _UFormat200 eq 'T'
	) then do;
	GRP_N_HOMESTATUS = 2;
	WOE_N_HOMESTATUS = 0.1844172371;
	end;
	else do;
	GRP_N_HOMESTATUS = 3;
	WOE_N_HOMESTATUS =            0;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: N_FLG_PARTNER;
	*------------------------------------------------------------*;
	LABEL GRP_N_FLG_PARTNER =
	"Grouped: N_FLG_PARTNER";
	LABEL WOE_N_FLG_PARTNER =
	"Weight of Evidence: N_FLG_PARTNER";

	_UFormat200 = put(N_FLG_PARTNER,$1.);
	%dmnormip(_UFormat200);
	if MISSING(_UFormat200) then do;
	GRP_N_FLG_PARTNER = 2;
	WOE_N_FLG_PARTNER = 1.0290462914;
	end;
	else if NOT MISSING(_UFormat200) then do;
	if (_UFormat200 eq 'N' OR _UFormat200 eq 'S'
	) then do;
	GRP_N_FLG_PARTNER = 1;
	WOE_N_FLG_PARTNER = -0.108070169;
	end;
	else do;
	GRP_N_FLG_PARTNER = 2;
	WOE_N_FLG_PARTNER = 1.0290462914;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: N_COLLATERAL_TYPE;
	*------------------------------------------------------------*;
	LABEL GRP_N_COLLATERAL_TYPE =
	"Grouped: N_COLLATERAL_TYPE";
	LABEL WOE_N_COLLATERAL_TYPE =
	"Weight of Evidence: N_COLLATERAL_TYPE";

	_UFormat200 = put(N_COLLATERAL_TYPE,$40.);
	%dmnormip(_UFormat200);
	if MISSING(_UFormat200) then do;
	GRP_N_COLLATERAL_TYPE = 4;
	WOE_N_COLLATERAL_TYPE = -0.304702467;
	end;
	else if NOT MISSING(_UFormat200) then do;
	if (_UFormat200 eq 'AVALES' OR _UFormat200 eq 'CARTAS DE CREDITO STAND BY' OR _UFormat200 eq 'CEDULA HIPOTECARIA' OR _UFormat200 eq 'FONDO SALVADOREÑO DE GARANTIA'
	) then do;
	GRP_N_COLLATERAL_TYPE = 1;
	WOE_N_COLLATERAL_TYPE = 0.5804042306;
	end;
	else
	if (_UFormat200 eq 'ORDEN DE PAGO FONDOS ESTATALES' OR _UFormat200 eq 'ORDEN PAGO PRODUCCION' OR _UFormat200 eq 'ORDEN PAGO SUELDO' OR _UFormat200 eq 'PAGO PERSONAL'
	) then do;
	GRP_N_COLLATERAL_TYPE = 1;
	WOE_N_COLLATERAL_TYPE = 0.5804042306;
	end;
	else
	if (_UFormat200 eq 'PIGNORADA-DEPOSITO DE DINERO' OR _UFormat200 eq 'VALORES DE RESCATE DE SEGURO DE'
	) then do;
	GRP_N_COLLATERAL_TYPE = 1;
	WOE_N_COLLATERAL_TYPE = 0.5804042306;
	end;
	else
	if (_UFormat200 eq 'HIPOTECA ABIERTA' OR _UFormat200 eq 'HIPOTECA CERRADA'
	) then do;
	GRP_N_COLLATERAL_TYPE = 2;
	WOE_N_COLLATERAL_TYPE =   0.22302856;
	end;
	else
	if (_UFormat200 eq 'CARTERA DE PRESTAMOS' OR _UFormat200 eq 'FIANZAS DE BCOS LOC O EXT DE PRA' OR _UFormat200 eq 'FIDUCIARIA' OR _UFormat200 eq 'FONDOS DE GARANTIA, PROGARA, PRO'
	) then do;
	GRP_N_COLLATERAL_TYPE = 3;
	WOE_N_COLLATERAL_TYPE = -0.354034849;
	end;
	else
	if (_UFormat200 eq 'GRUPO SOLIDARIO' OR _UFormat200 eq 'OTRAS' OR _UFormat200 eq 'PRENDA DE DOCUMENTOS (ACCIONES,' OR _UFormat200 eq 'PRENDARIA' OR _UFormat200 eq 'SIN GARANTIA'
	) then do;
	GRP_N_COLLATERAL_TYPE = 3;
	WOE_N_COLLATERAL_TYPE = -0.354034849;
	end;
	else do;
	GRP_N_COLLATERAL_TYPE = 4;
	WOE_N_COLLATERAL_TYPE = -0.304702467;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: N_OCCUPATION;
	*------------------------------------------------------------*;
	LABEL GRP_N_OCCUPATION =
	"Grouped: N_OCCUPATION";
	LABEL WOE_N_OCCUPATION =
	"Weight of Evidence: N_OCCUPATION";

	_UFormat200 = put(N_OCCUPATION,$23.);
	%dmnormip(_UFormat200);
	if MISSING(_UFormat200) then do;
	GRP_N_OCCUPATION = 5;
	WOE_N_OCCUPATION = 0.0670648874;
	end;
	else if NOT MISSING(_UFormat200) then do;
	if (_UFormat200 eq 'FUNCIONARIOS' OR _UFormat200 eq 'OFICIOS' OR _UFormat200 eq 'PROFESIONES'
	) then do;
	GRP_N_OCCUPATION = 1;
	WOE_N_OCCUPATION = -0.261534903;
	end;
	else
	if (_UFormat200 eq 'TECNICOS'
	) then do;
	GRP_N_OCCUPATION = 2;
	WOE_N_OCCUPATION = 0.1151394916;
	end;
	else
	if (_UFormat200 eq 'EDUCACION' OR _UFormat200 eq 'OTROS'
	) then do;
	GRP_N_OCCUPATION = 3;
	WOE_N_OCCUPATION = 0.3004845323;
	end;
	else
	if (_UFormat200 eq 'JUBILADOS / PENSIONADOS'
	) then do;
	GRP_N_OCCUPATION = 4;
	WOE_N_OCCUPATION = 1.6239196883;
	end;
	else do;
	GRP_N_OCCUPATION = 5;
	WOE_N_OCCUPATION = 0.0670648874;
	end;
	end;

	*------------------------------------------------------------*;
	* Variable: N_PROFESION;
	*------------------------------------------------------------*;
	LABEL GRP_N_PROFESION =
	"Grouped: N_PROFESION";
	LABEL WOE_N_PROFESION =
	"Weight of Evidence: N_PROFESION";

	_UFormat200 = put(N_PROFESION,$14.);
	%dmnormip(_UFormat200);
	if MISSING(_UFormat200) then do;
	GRP_N_PROFESION = 4;
	WOE_N_PROFESION =  0.542363078;
	end;
	else if NOT MISSING(_UFormat200) then do;
	if (_UFormat200 eq 'EDUCACION' OR _UFormat200 eq 'OFICIOS' OR _UFormat200 eq 'OTROS'
	) then do;
	GRP_N_PROFESION = 1;
	WOE_N_PROFESION = -0.075436803;
	end;
	else
	if (_UFormat200 eq 'PROFESIONES'
	) then do;
	GRP_N_PROFESION = 2;
	WOE_N_PROFESION = 0.1464903842;
	end;
	else
	if (_UFormat200 eq 'JUBILADO' OR _UFormat200 eq 'TECNICOS'
	) then do;
	GRP_N_PROFESION = 3;
	WOE_N_PROFESION = 0.8286645683;
	end;
	else do;
	GRP_N_PROFESION = 4;
	WOE_N_PROFESION =  0.542363078;
	end;
	end;

	*------------------------------------------------------------*;
	* Special Code Values
	*------------------------------------------------------------*;
	*------------------------------------------------------------*;
	* TOOL: Metadata Node;
	* TYPE: UTILITY;
	* NODE: Meta;
	*------------------------------------------------------------*;
	*------------------------------------------------------------*;
	* TOOL: Scorecard;
	* TYPE: MODEL;
	* NODE: Scorecard17;
	*------------------------------------------------------------*;
	*************************************;
	*** begin scoring code for regression;
	*************************************;

	/*length _WARN_ $4;*/
	/*label _WARN_ = 'Warnings' ;*/
	/**/
	/*length I_KGB_GE60D_N12M $ 12;*/
	/*label I_KGB_GE60D_N12M = 'Into: KGB_GE60D_N12M' ;*/
	*** Target Values;
	array SCORECARD17DRF [2] $12 _temporary_ ('1' '0' );
	label U_KGB_GE60D_N12M = 'Unnormalized Into: KGB_GE60D_N12M' ;
	*** Unnormalized target values;
	ARRAY SCORECARD17DRU[2]  _TEMPORARY_ (1 0);

	drop _DM_BAD;
	_DM_BAD=0;

	*** Check WOE_N_OCCUPATION for missing values ;
	if missing( WOE_N_OCCUPATION ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_AGE_YRS for missing values ;
	if missing( WOE_I_AGE_YRS ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_LOAN_AGE_YRS for missing values ;
	if missing( WOE_I_LOAN_AGE_YRS ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_MX_DYSPSTDUE_LON_L12M for missing values ;
	if missing( WOE_I_MX_DYSPSTDUE_LON_L12M ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_SIN_R_BALT_APPR_CLC_L13_24 for missing values ;
	if missing( WOE_I_SIN_R_BALT_APPR_CLC_L13_24 ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_N_HOMESTATUS for missing values ;
	if missing( WOE_N_HOMESTATUS ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_N_COLLATERAL_TYPE for missing values ;
	if missing( WOE_N_COLLATERAL_TYPE ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_SDC_R_PAYT_BALT_CLC_L06M for missing values ;
	if missing( WOE_I_SDC_R_PAYT_BALT_CLC_L06M ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_RISK_LEVEL for missing values ;
	if missing( WOE_I_RISK_LEVEL ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_MX_DYSPSTDUE_CCR_L12M for missing values ;
	if missing( WOE_I_MX_DYSPSTDUE_CCR_L12M ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_SDC_R_CHRG_CRRA_CPM_L12M for missing values ;
	if missing( WOE_I_SDC_R_CHRG_CRRA_CPM_L12M ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_SIN_R_BALT_APPR_CLC_L03M for missing values ;
	if missing( WOE_I_SIN_R_BALT_APPR_CLC_L03M ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_SV_R_PAYA_INST_CLC_L12_06 for missing values ;
	if missing( WOE_I_SV_R_PAYA_INST_CLC_L12_06 ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_QT_R_BALT_APPR_CLC_L12_09 for missing values ;
	if missing( WOE_I_QT_R_BALT_APPR_CLC_L12_09 ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_N_FLG_PARTNER for missing values ;
	if missing( WOE_N_FLG_PARTNER ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;

	*** Check WOE_I_NUMDEPEND for missing values ;
	if missing( WOE_I_NUMDEPEND ) then do;
	   substr(_warn_,1,1) = 'M';
	   _DM_BAD = 1;
	end;
	*** If missing inputs, use averages;
	if _DM_BAD > 0 then do;
	   _P0 = 0.0875200582;
	   _P1 = 0.9124799418;
	   goto SCORECARD17DR1;
	end;

	*** Compute Linear Predictor;
	drop _TEMP;
	drop _LP0;
	_LP0 = 0;

	***  Effect: WOE_N_OCCUPATION ;
	_TEMP = WOE_N_OCCUPATION ;
	_LP0 = _LP0 + (   -0.50336293490518 * _TEMP);

	***  Effect: WOE_I_AGE_YRS ;
	_TEMP = WOE_I_AGE_YRS ;
	_LP0 = _LP0 + (   -0.47691413825136 * _TEMP);

	***  Effect: WOE_I_LOAN_AGE_YRS ;
	_TEMP = WOE_I_LOAN_AGE_YRS ;
	_LP0 = _LP0 + (   -0.91554624555803 * _TEMP);

	***  Effect: WOE_I_MX_DYSPSTDUE_LON_L12M ;
	_TEMP = WOE_I_MX_DYSPSTDUE_LON_L12M ;
	_LP0 = _LP0 + (   -0.57725162181871 * _TEMP);

	***  Effect: WOE_I_SIN_R_BALT_APPR_CLC_L13_24 ;
	_TEMP = WOE_I_SIN_R_BALT_APPR_CLC_L13_24 ;
	_LP0 = _LP0 + (   -0.31783380514361 * _TEMP);

	***  Effect: WOE_N_HOMESTATUS ;
	_TEMP = WOE_N_HOMESTATUS ;
	_LP0 = _LP0 + (   -0.32113449961759 * _TEMP);

	***  Effect: WOE_N_COLLATERAL_TYPE ;
	_TEMP = WOE_N_COLLATERAL_TYPE ;
	_LP0 = _LP0 + (   -0.31299429998673 * _TEMP);

	***  Effect: WOE_I_SDC_R_PAYT_BALT_CLC_L06M ;
	_TEMP = WOE_I_SDC_R_PAYT_BALT_CLC_L06M ;
	_LP0 = _LP0 + (   -0.19718842178546 * _TEMP);

	***  Effect: WOE_I_RISK_LEVEL ;
	_TEMP = WOE_I_RISK_LEVEL ;
	_LP0 = _LP0 + (   -0.88879443236163 * _TEMP);

	***  Effect: WOE_I_MX_DYSPSTDUE_CCR_L12M ;
	_TEMP = WOE_I_MX_DYSPSTDUE_CCR_L12M ;
	_LP0 = _LP0 + (   -0.12587045345071 * _TEMP);

	***  Effect: WOE_I_SDC_R_CHRG_CRRA_CPM_L12M ;
	_TEMP = WOE_I_SDC_R_CHRG_CRRA_CPM_L12M ;
	_LP0 = _LP0 + (   -0.80207978859531 * _TEMP);

	***  Effect: WOE_I_SIN_R_BALT_APPR_CLC_L03M ;
	_TEMP = WOE_I_SIN_R_BALT_APPR_CLC_L03M ;
	_LP0 = _LP0 + (   -0.17935397469856 * _TEMP);

	***  Effect: WOE_I_SV_R_PAYA_INST_CLC_L12_06 ;
	_TEMP = WOE_I_SV_R_PAYA_INST_CLC_L12_06 ;
	_LP0 = _LP0 + (   -0.30847528993466 * _TEMP);

	***  Effect: WOE_I_QT_R_BALT_APPR_CLC_L12_09 ;
	_TEMP = WOE_I_QT_R_BALT_APPR_CLC_L12_09 ;
	_LP0 = _LP0 + (   -0.58385920297668 * _TEMP);

	***  Effect: WOE_N_FLG_PARTNER ;
	_TEMP = WOE_N_FLG_PARTNER ;
	_LP0 = _LP0 + (   -0.38427564000542 * _TEMP);

	***  Effect: WOE_I_NUMDEPEND ;
	_TEMP = WOE_I_NUMDEPEND ;
	_LP0 = _LP0 + (   -0.50670734743018 * _TEMP);

	*** Naive Posterior Probabilities;
	drop _MAXP _IY _P0 _P1;
	_TEMP =    -2.33069783307268 + _LP0;
	if (_TEMP < 0) then do;
	   _TEMP = exp(_TEMP);
	   _P0 = _TEMP / (1 + _TEMP);
	end;
	else _P0 = 1 / (1 + exp(-_TEMP));
	_P1 = 1.0 - _P0;

	SCORECARD17DR1:


	*** Posterior Probabilities and Predicted Level;
	label P_KGB_GE60D_N12M1 = 'Predicted: KGB_GE60D_N12M=1' ;
	label P_KGB_GE60D_N12M0 = 'Predicted: KGB_GE60D_N12M=0' ;
	P_KGB_GE60D_N12M1 = _P0;
	_MAXP = _P0;
	_IY = 1;
	P_KGB_GE60D_N12M0 = _P1;
	if (_P1 >  _MAXP + 1E-8) then do;
	   _MAXP = _P1;
	   _IY = 2;
	end;
	I_KGB_GE60D_N12M = SCORECARD17DRF[_IY];
	U_KGB_GE60D_N12M = SCORECARD17DRU[_IY];

	*************************************;
	***** end scoring code for regression;
	*************************************;
	*------------------------------------------------------------*;
	* generateScorepoints_note;
	*------------------------------------------------------------*;
	SCORECARD_POINTS = 0;

	*------------------------------------------------------------*;
	* Variable: I_AGE_YRS;
	*------------------------------------------------------------*;
	if MISSING(I_AGE_YRS) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_I_AGE_YRS= 35;
	end;
	else if NOT MISSING(I_AGE_YRS) AND I_AGE_YRS < 27.79 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 23;
	SCR_I_AGE_YRS = 23;
	end;
	else if NOT MISSING(I_AGE_YRS) and 27.79 <= I_AGE_YRS AND I_AGE_YRS < 33.76 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 27;
	SCR_I_AGE_YRS = 27;
	end;
	else if NOT MISSING(I_AGE_YRS) and 33.76 <= I_AGE_YRS AND I_AGE_YRS < 40.93 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 30;
	SCR_I_AGE_YRS = 30;
	end;
	else if NOT MISSING(I_AGE_YRS) and 40.93 <= I_AGE_YRS AND I_AGE_YRS < 46.58 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 34;
	SCR_I_AGE_YRS = 34;
	end;
	else if NOT MISSING(I_AGE_YRS) and 46.58 <= I_AGE_YRS AND I_AGE_YRS < 51.91 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 38;
	SCR_I_AGE_YRS = 38;
	end;
	else if NOT MISSING(I_AGE_YRS) and 51.91 <= I_AGE_YRS then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 42;
	SCR_I_AGE_YRS = 42;
	end;

	*------------------------------------------------------------*;
	* Variable: I_LOAN_AGE_YRS;
	*------------------------------------------------------------*;
	if MISSING(I_LOAN_AGE_YRS) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_I_LOAN_AGE_YRS= 35;
	end;
	else if NOT MISSING(I_LOAN_AGE_YRS) AND I_LOAN_AGE_YRS < 0.87 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 40;
	SCR_I_LOAN_AGE_YRS = 40;
	end;
	else if NOT MISSING(I_LOAN_AGE_YRS) and 0.87 <= I_LOAN_AGE_YRS AND I_LOAN_AGE_YRS < 1.25 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_I_LOAN_AGE_YRS = 35;
	end;
	else if NOT MISSING(I_LOAN_AGE_YRS) and 1.25 <= I_LOAN_AGE_YRS then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_I_LOAN_AGE_YRS = 32;
	end;

	*------------------------------------------------------------*;
	* Variable: I_MX_DYSPSTDUE_LON_L12M;
	*------------------------------------------------------------*;
	if MISSING(I_MX_DYSPSTDUE_LON_L12M) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 60;
	SCR_I_MX_DYSPSTDUE_LON_L12M= 60;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_LON_L12M) AND I_MX_DYSPSTDUE_LON_L12M < 4 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 44;
	SCR_I_MX_DYSPSTDUE_LON_L12M = 44;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_LON_L12M) and 4 <= I_MX_DYSPSTDUE_LON_L12M AND I_MX_DYSPSTDUE_LON_L12M < 20 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_I_MX_DYSPSTDUE_LON_L12M = 32;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_LON_L12M) and 20 <= I_MX_DYSPSTDUE_LON_L12M AND I_MX_DYSPSTDUE_LON_L12M < 36 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 21;
	SCR_I_MX_DYSPSTDUE_LON_L12M = 21;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_LON_L12M) and 36 <= I_MX_DYSPSTDUE_LON_L12M AND I_MX_DYSPSTDUE_LON_L12M < 70 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 10;
	SCR_I_MX_DYSPSTDUE_LON_L12M = 10;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_LON_L12M) and 70 <= I_MX_DYSPSTDUE_LON_L12M then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 7;
	SCR_I_MX_DYSPSTDUE_LON_L12M = 7;
	end;

	*------------------------------------------------------------*;
	* Variable: I_MX_DYSPSTDUE_CCR_L12M;
	*------------------------------------------------------------*;
	if MISSING(I_MX_DYSPSTDUE_CCR_L12M) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_I_MX_DYSPSTDUE_CCR_L12M= 35;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_CCR_L12M) AND I_MX_DYSPSTDUE_CCR_L12M < 6 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 34;
	SCR_I_MX_DYSPSTDUE_CCR_L12M = 34;
	end;
	else if NOT MISSING(I_MX_DYSPSTDUE_CCR_L12M) and 6 <= I_MX_DYSPSTDUE_CCR_L12M then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_I_MX_DYSPSTDUE_CCR_L12M = 32;
	end;

	*------------------------------------------------------------*;
	* Variable: I_RISK_LEVEL;
	*------------------------------------------------------------*;
	if MISSING(I_RISK_LEVEL) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 70;
	SCR_I_RISK_LEVEL= 70;
	end;
	else if NOT MISSING(I_RISK_LEVEL) AND I_RISK_LEVEL < 3 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 60;
	SCR_I_RISK_LEVEL = 60;
	end;
	else if NOT MISSING(I_RISK_LEVEL) and 3 <= I_RISK_LEVEL AND I_RISK_LEVEL < 4 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 30;
	SCR_I_RISK_LEVEL = 30;
	end;
	else if NOT MISSING(I_RISK_LEVEL) and 4 <= I_RISK_LEVEL AND I_RISK_LEVEL < 11 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 1;
	SCR_I_RISK_LEVEL = 1;
	end;
	else if NOT MISSING(I_RISK_LEVEL) and 11 <= I_RISK_LEVEL then do;
	SCORECARD_POINTS = SCORECARD_POINTS + -37;
	SCR_I_RISK_LEVEL = -37;
	end;

	*------------------------------------------------------------*;
	* Variable: I_NUMDEPEND;
	*------------------------------------------------------------*;
	if MISSING(I_NUMDEPEND) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 39;
	SCR_I_NUMDEPEND= 39;
	end;
	else if NOT MISSING(I_NUMDEPEND) AND I_NUMDEPEND < 1 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 33;
	SCR_I_NUMDEPEND = 33;
	end;
	else if NOT MISSING(I_NUMDEPEND) and 1 <= I_NUMDEPEND AND I_NUMDEPEND < 4 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_I_NUMDEPEND = 36;
	end;
	else if NOT MISSING(I_NUMDEPEND) and 4 <= I_NUMDEPEND then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 37;
	SCR_I_NUMDEPEND = 37;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SDC_R_CHRG_CRRA_CPM_L12M;
	*------------------------------------------------------------*;
	if MISSING(I_SDC_R_CHRG_CRRA_CPM_L12M) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 33;
	SCR_I_SDC_R_CHRG_CRRA_CPM_L12M= 33;
	end;
	else if NOT MISSING(I_SDC_R_CHRG_CRRA_CPM_L12M) AND I_SDC_R_CHRG_CRRA_CPM_L12M < 5 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 33;
	SCR_I_SDC_R_CHRG_CRRA_CPM_L12M = 33;
	end;
	else if NOT MISSING(I_SDC_R_CHRG_CRRA_CPM_L12M) and 5 <= I_SDC_R_CHRG_CRRA_CPM_L12M AND I_SDC_R_CHRG_CRRA_CPM_L12M < 11 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 39;
	SCR_I_SDC_R_CHRG_CRRA_CPM_L12M = 39;
	end;
	else if NOT MISSING(I_SDC_R_CHRG_CRRA_CPM_L12M) and 11 <= I_SDC_R_CHRG_CRRA_CPM_L12M then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 54;
	SCR_I_SDC_R_CHRG_CRRA_CPM_L12M = 54;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SDC_R_PAYT_BALT_CLC_L06M;
	*------------------------------------------------------------*;
	if MISSING(I_SDC_R_PAYT_BALT_CLC_L06M) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 43;
	SCR_I_SDC_R_PAYT_BALT_CLC_L06M= 43;
	end;
	else if NOT MISSING(I_SDC_R_PAYT_BALT_CLC_L06M) AND I_SDC_R_PAYT_BALT_CLC_L06M < 1 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_I_SDC_R_PAYT_BALT_CLC_L06M = 36;
	end;
	else if NOT MISSING(I_SDC_R_PAYT_BALT_CLC_L06M) and 1 <= I_SDC_R_PAYT_BALT_CLC_L06M then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_I_SDC_R_PAYT_BALT_CLC_L06M = 32;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SIN_R_BALT_APPR_CLC_L03M;
	*------------------------------------------------------------*;
	if MISSING(I_SIN_R_BALT_APPR_CLC_L03M) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 43;
	SCR_I_SIN_R_BALT_APPR_CLC_L03M= 43;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L03M) AND I_SIN_R_BALT_APPR_CLC_L03M < 1 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_I_SIN_R_BALT_APPR_CLC_L03M = 36;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L03M) and 1 <= I_SIN_R_BALT_APPR_CLC_L03M then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_I_SIN_R_BALT_APPR_CLC_L03M = 32;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SIN_R_BALT_APPR_CLC_L13_24;
	*------------------------------------------------------------*;
	if MISSING(I_SIN_R_BALT_APPR_CLC_L13_24) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 49;
	SCR_I_SIN_R_BALT_APPR_CLC_L13_24= 49;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L13_24) AND I_SIN_R_BALT_APPR_CLC_L13_24 < 1 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 37;
	SCR_I_SIN_R_BALT_APPR_CLC_L13_24 = 37;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L13_24) and 1 <= I_SIN_R_BALT_APPR_CLC_L13_24 AND I_SIN_R_BALT_APPR_CLC_L13_24 < 2 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 34;
	SCR_I_SIN_R_BALT_APPR_CLC_L13_24 = 34;
	end;
	else if NOT MISSING(I_SIN_R_BALT_APPR_CLC_L13_24) and 2 <= I_SIN_R_BALT_APPR_CLC_L13_24 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 29;
	SCR_I_SIN_R_BALT_APPR_CLC_L13_24 = 29;
	end;

	*------------------------------------------------------------*;
	* Variable: I_SV_R_PAYA_INST_CLC_L12_06;
	*------------------------------------------------------------*;
	if MISSING(I_SV_R_PAYA_INST_CLC_L12_06) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 48;
	SCR_I_SV_R_PAYA_INST_CLC_L12_06= 48;
	end;
	else if NOT MISSING(I_SV_R_PAYA_INST_CLC_L12_06) AND I_SV_R_PAYA_INST_CLC_L12_06 < -0.01 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 27;
	SCR_I_SV_R_PAYA_INST_CLC_L12_06 = 27;
	end;
	else if NOT MISSING(I_SV_R_PAYA_INST_CLC_L12_06) and -0.01 <= I_SV_R_PAYA_INST_CLC_L12_06 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_I_SV_R_PAYA_INST_CLC_L12_06 = 35;
	end;

	*------------------------------------------------------------*;
	* Variable: I_QT_R_BALT_APPR_CLC_L12_09;
	*------------------------------------------------------------*;
	if MISSING(I_QT_R_BALT_APPR_CLC_L12_09) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 61;
	SCR_I_QT_R_BALT_APPR_CLC_L12_09= 61;
	end;
	else if NOT MISSING(I_QT_R_BALT_APPR_CLC_L12_09) AND I_QT_R_BALT_APPR_CLC_L12_09 < 0 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 39;
	SCR_I_QT_R_BALT_APPR_CLC_L12_09 = 39;
	end;
	else if NOT MISSING(I_QT_R_BALT_APPR_CLC_L12_09) and 0 <= I_QT_R_BALT_APPR_CLC_L12_09 then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 27;
	SCR_I_QT_R_BALT_APPR_CLC_L12_09 = 27;
	end;

	*------------------------------------------------------------*;
	* Variable: N_HOMESTATUS;
	*------------------------------------------------------------*;
	length _fmtN_HOMESTATUS $200;
	length _normN_HOMESTATUS $32;
	drop _fmtN_HOMESTATUS _normN_HOMESTATUS;
	_fmtN_HOMESTATUS=put(N_HOMESTATUS, $4.);
	%dmnormcp(_fmtN_HOMESTATUS, _normN_HOMESTATUS);
	if MISSING(_normN_HOMESTATUS) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_N_HOMESTATUS = 35;
	end;
	else
	if _normN_HOMESTATUS in ('A'
	, 'F'
	, 'O'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 33;
	SCR_N_HOMESTATUS = 33;
	end;
	else
	if _normN_HOMESTATUS in ('OTRO'
	, 'T'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_N_HOMESTATUS = 36;
	end;
	else do;
	SCORECARD_POINTS = SCORECARD_POINTS + 35;
	SCR_N_HOMESTATUS = 35;
	end;
	drop _normN_HOMESTATUS;

	*------------------------------------------------------------*;
	* Variable: N_FLG_PARTNER;
	*------------------------------------------------------------*;
	length _fmtN_FLG_PARTNER $200;
	length _normN_FLG_PARTNER $32;
	drop _fmtN_FLG_PARTNER _normN_FLG_PARTNER;
	_fmtN_FLG_PARTNER=put(N_FLG_PARTNER, $1.);
	%dmnormcp(_fmtN_FLG_PARTNER, _normN_FLG_PARTNER);
	if MISSING(_normN_FLG_PARTNER) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 46;
	SCR_N_FLG_PARTNER = 46;
	end;
	else
	if _normN_FLG_PARTNER in ('N'
	, 'S'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 33;
	SCR_N_FLG_PARTNER = 33;
	end;
	else do;
	SCORECARD_POINTS = SCORECARD_POINTS + 46;
	SCR_N_FLG_PARTNER = 46;
	end;
	drop _normN_FLG_PARTNER;

	*------------------------------------------------------------*;
	* Variable: N_COLLATERAL_TYPE;
	*------------------------------------------------------------*;
	length _fmtN_COLLATERAL_TYPE $200;
	length _normN_COLLATERAL_TYPE $32;
	drop _fmtN_COLLATERAL_TYPE _normN_COLLATERAL_TYPE;
	_fmtN_COLLATERAL_TYPE=put(N_COLLATERAL_TYPE, $40.);
	%dmnormcp(_fmtN_COLLATERAL_TYPE, _normN_COLLATERAL_TYPE);
	if MISSING(_normN_COLLATERAL_TYPE) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_N_COLLATERAL_TYPE = 32;
	end;
	else
	if _normN_COLLATERAL_TYPE in ('AVALES'
	, 'CARTAS DE CREDITO STAND BY'
	, 'CEDULA HIPOTECARIA'
	, 'FONDO SALVADOREÑO DE GARANTIA'
	, 'ORDEN DE PAGO FONDOS ESTATALES'
	, 'ORDEN PAGO PRODUCCION'
	, 'ORDEN PAGO SUELDO'
	, 'PAGO PERSONAL'
	, 'PIGNORADA-DEPOSITO DE DINERO'
	, 'VALORES DE RESCATE DE SEGURO DE'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 40;
	SCR_N_COLLATERAL_TYPE = 40;
	end;
	else
	if _normN_COLLATERAL_TYPE in ('HIPOTECA ABIERTA'
	, 'HIPOTECA CERRADA'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 37;
	SCR_N_COLLATERAL_TYPE = 37;
	end;
	else
	if _normN_COLLATERAL_TYPE in ('CARTERA DE PRESTAMOS'
	, 'FIANZAS DE BCOS LOC O EXT DE PRA'
	, 'FIDUCIARIA'
	, 'FONDOS DE GARANTIA, PROGARA, PRO'
	, 'GRUPO SOLIDARIO'
	, 'OTRAS'
	, 'PRENDA DE DOCUMENTOS (ACCIONES,'
	, 'PRENDARIA'
	, 'SIN GARANTIA'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 31;
	SCR_N_COLLATERAL_TYPE = 31;
	end;
	else do;
	SCORECARD_POINTS = SCORECARD_POINTS + 32;
	SCR_N_COLLATERAL_TYPE = 32;
	end;
	drop _normN_COLLATERAL_TYPE;

	*------------------------------------------------------------*;
	* Variable: N_OCCUPATION;
	*------------------------------------------------------------*;
	length _fmtN_OCCUPATION $200;
	length _normN_OCCUPATION $32;
	drop _fmtN_OCCUPATION _normN_OCCUPATION;
	_fmtN_OCCUPATION=put(N_OCCUPATION, $23.);
	%dmnormcp(_fmtN_OCCUPATION, _normN_OCCUPATION);
	if MISSING(_normN_OCCUPATION) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_N_OCCUPATION = 36;
	end;
	else
	if _normN_OCCUPATION in ('FUNCIONARIOS'
	, 'OFICIOS'
	, 'PROFESIONES'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 31;
	SCR_N_OCCUPATION = 31;
	end;
	else
	if _normN_OCCUPATION in ('TECNICOS'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_N_OCCUPATION = 36;
	end;
	else
	if _normN_OCCUPATION in ('EDUCACION'
	, 'OTROS'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 39;
	SCR_N_OCCUPATION = 39;
	end;
	else
	if _normN_OCCUPATION in ('JUBILADOS / PENSIONADOS'
	) then do;
	SCORECARD_POINTS = SCORECARD_POINTS + 58;
	SCR_N_OCCUPATION = 58;
	end;
	else do;
	SCORECARD_POINTS = SCORECARD_POINTS + 36;
	SCR_N_OCCUPATION = 36;
	end;
	drop _normN_OCCUPATION;
	*;
	* Assign SCORECARD_BIN values;
	*;
	if SCORECARD_POINTS < 412 then SCORECARD_BIN = 1;
	else if SCORECARD_POINTS < 423 then SCORECARD_BIN = 2;
	else if SCORECARD_POINTS < 434 then SCORECARD_BIN = 3;
	else if SCORECARD_POINTS < 445 then SCORECARD_BIN = 4;
	else if SCORECARD_POINTS < 456 then SCORECARD_BIN = 5;
	else if SCORECARD_POINTS < 467 then SCORECARD_BIN = 6;
	else if SCORECARD_POINTS < 478 then SCORECARD_BIN = 7;
	else if SCORECARD_POINTS < 489 then SCORECARD_BIN = 8;
	else if SCORECARD_POINTS < 500 then SCORECARD_BIN = 9;
	else if SCORECARD_POINTS < 511 then SCORECARD_BIN = 10;
	else if SCORECARD_POINTS < 522 then SCORECARD_BIN = 11;
	else if SCORECARD_POINTS < 533 then SCORECARD_BIN = 12;
	else if SCORECARD_POINTS < 544 then SCORECARD_BIN = 13;
	else if SCORECARD_POINTS < 555 then SCORECARD_BIN = 14;
	else if SCORECARD_POINTS < 566 then SCORECARD_BIN = 15;
	else if SCORECARD_POINTS < 577 then SCORECARD_BIN = 16;
	else if SCORECARD_POINTS < 588 then SCORECARD_BIN = 17;
	else if SCORECARD_POINTS < 599 then SCORECARD_BIN = 18;
	else if SCORECARD_POINTS < 610 then SCORECARD_BIN = 19;
	else if SCORECARD_POINTS < 621 then SCORECARD_BIN = 20;
	else if SCORECARD_POINTS < 632 then SCORECARD_BIN = 21;
	else if SCORECARD_POINTS < 643 then SCORECARD_BIN = 22;
	else if SCORECARD_POINTS < 654 then SCORECARD_BIN = 23;
	else if SCORECARD_POINTS < 665 then SCORECARD_BIN = 24;
	else SCORECARD_BIN = 25;
	/*----------------------------------------------------------------------*/
	/*|Adiciona etiqueta con el rango de calificación|*/
	/*----------------------------------------------------------------------*/
	IF SCORECARD_POINTS<=470 			THEN RANK = 'De 401 a 470';
	ELSE IF 471<=SCORECARD_POINTS<=502 	THEN RANK = 'De 471 a 502';
	ELSE IF 503<=SCORECARD_POINTS<=531 	THEN RANK = 'De 503 a 531';
	ELSE IF 532<=SCORECARD_POINTS<=568 	THEN RANK = 'De 532 a 568';
	ELSE IF 569<=SCORECARD_POINTS<=579 	THEN RANK = 'De 569 a 579';
	ELSE IF 580<=SCORECARD_POINTS<=591 	THEN RANK = 'De 580 a 591';
	ELSE IF 592<=SCORECARD_POINTS<=607 	THEN RANK = 'De 592 a 607';
	ELSE IF 608<=SCORECARD_POINTS 		THEN RANK = 'Mayor de 607';
	/*----------------------------------------------------------------------*/
	/*|Adiciona etiqueta con la calificación en letra|*/
	/*----------------------------------------------------------------------*/
	IF SCORECARD_POINTS<=470 			THEN CALIFICACION = 'F';
	ELSE IF 471<=SCORECARD_POINTS<=502 	THEN CALIFICACION = 'E';
	ELSE IF 503<=SCORECARD_POINTS<=531 	THEN CALIFICACION = 'D';
	ELSE IF 532<=SCORECARD_POINTS<=568 	THEN CALIFICACION = 'C';
	ELSE IF 569<=SCORECARD_POINTS<=579 	THEN CALIFICACION = 'B';
	ELSE IF 580<=SCORECARD_POINTS<=591 	THEN CALIFICACION = 'A';
	ELSE IF 592<=SCORECARD_POINTS<=607 	THEN CALIFICACION = 'AA';
	ELSE IF 608<=SCORECARD_POINTS 		THEN CALIFICACION = 'AAA';
	/*----------------------------------------------------------------------*/
	/*|Adiciona etiqueta con la clasificación Fedecrédito|*/
	/*----------------------------------------------------------------------*/
	IF SCORECARD_POINTS<=470 			THEN CALIFICACION_FEDE = 'Alto Riesgo';
	ELSE IF 471<=SCORECARD_POINTS<=502 	THEN CALIFICACION_FEDE = 'Alto Riesgo';
	ELSE IF 503<=SCORECARD_POINTS<=531 	THEN CALIFICACION_FEDE = 'Alto Riesgo';
	ELSE IF 532<=SCORECARD_POINTS<=568 	THEN CALIFICACION_FEDE = 'Alto Riesgo';
	ELSE IF 569<=SCORECARD_POINTS<=579 	THEN CALIFICACION_FEDE = 'Mediano Riesgo';
	ELSE IF 580<=SCORECARD_POINTS<=591 	THEN CALIFICACION_FEDE = 'Mediano Riesgo';
	ELSE IF 592<=SCORECARD_POINTS<=607 	THEN CALIFICACION_FEDE = 'Bajo Riesgo';
	ELSE IF 608<=SCORECARD_POINTS 		THEN CALIFICACION_FEDE = 'Muy Bajo Riesgo';


	RUN;
