INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNT_HOLDER_SET 
(
	UUID,
	CREATED_ON
)
SELECT 
	RI.SETID,
	SYSDATE AS CREATED_ON
FROM 
	ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_ACCOUNT_INFO A,
	COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.RESPONSIBLE R,
	COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.RESPONSIBLEINDEX RI
WHERE 
	A.ACCOUNTID=R.MIG_SRC_ACCT_ID
	AND R.RESPONSIBLEID=RI.RESPONSIBLEID