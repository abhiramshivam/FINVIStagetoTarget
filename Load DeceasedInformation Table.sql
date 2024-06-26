INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.DECEASEDINFORMATION  
(
	ID,
	CITY,
	STATEREFID,
	VERIFIEDDATE,
	COURTINFORMATIONID,
	EXECUTORID,
	CUSTOMERID,
	MIGRATION_SOURCE_ID
)
SELECT 
	SYS_GUID() AS ID,
	PI.ARENDECCITYDS AS CITY,
	ST.ID AS STATEREFID,
	PI.ARENDECVERDATEDS AS VERIFIEDDATE,
	CI.COURTINFORMATIONID,
	EX.EXECUTORID,
	CN.CUSTOMERID,
	PI.CONSUMERID AS MIGRATION_SOURCE_ID
FROM 
	ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PARTY_INFO PI
	INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMER CN ON PI.CONSUMERID = CN.MIGRATION_SOURCE_ID
	LEFT OUTER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.EXECUTOR EX ON PI.CONSUMERID = EX.MIGRATION_SOURCE_ID
	LEFT OUTER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.COURTINFORMATION CI ON PI.CONSUMERID = CI.MIGRATION_SOURCE_ID
	LEFT OUTER JOIN COM_FINVI_OASIS_STATIC_DATA_{PP_TenantName}.STATE ST ON ST.CODE = PI.ARENDECSTATEDS	
WHERE PI.ARENDECEASED = 'Y'