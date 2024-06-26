INSERT INTO ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_WRK_CALLHIST_DIALER_COUNTER
(
	ACCOUNT_ID,
	CONSUMER_ID,
	CREATED_ON,
	MODIFIED_ON,
	ATTEMPT_DATE,
	CALL_ATTEMPT,
	CALL_OVERRIDE,
	CALLBACK_REQUEST,
	RPC_CONTACT,
	MISDIRECTED_CALL,
	PHONENUMBER,
	RESPONSIBLE_ID,
	DIALER_RESULT_ID
)
SELECT  
	ACCOUNT_ID,
	CONSUMER_ID,
	CURRENT_TIMESTAMP AS CREATED_ON,
	CURRENT_TIMESTAMP AS MODIFIED_ON,
	CH.ATTEMPT_DATE,
	CASE WHEN AGENTACTIONCODE  IN ('AM','AD','AL','AC','BE','BC','BN','CN',
		'HA','IA','IW','IL','IO','LM','LL','NA','LB','NV','OL','OT','OH','TZ',
		'TO','UT','UC','UL','HE','WE','DC') THEN 1 ELSE 0 END  CALL_ATTEMPT,
	CASE WHEN AGENTACTIONCODE IN ('TR','BD','BI','BU','IV','FA','IX','IS','IH','IT','TN','LS',
		'TP','RE','TT','TH','3T','NI','CB','WB') THEN 1 ELSE 0 END AS CALL_OVERRIDE,
	CASE WHEN AGENTACTIONCODE IN ('IC','CN','CR') THEN 1 ELSE 0 END AS CALLBACK_REQUEST,
	CWU.IS_RPC  AS RPC_CONTACT,
	CWU.IS_MIS_DIRECTED  AS MISDIRECTED_CALL,
	CH.PHONENUMBER  AS PHONENUMBER,
	RP.RESPONSIBLEID ,
	ROW_NUMBER () over(ORDER BY  RP.RESPONSIBLEID) + 1000000000 AS DIALER_RESULT_ID
FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_CALL_HISTORY CH
	JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNT A ON CH.ACCOUNT_ID = A.MIGRATION_SOURCE_ID
	INNER JOIN COM_FINVI_OASIS_STATIC_DATA_{PP_TenantName}.CALL_WRAP_UP cwu ON cwu.code = ch.CALLOUTCOME 
	JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.RESPONSIBLE RP ON A.ACCOUNTNUM = RP.ACCOUNTNUM