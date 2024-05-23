INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.INCARCERATEDINFORMATION
(
	ID,
	PENITENTIARY,
	EXPECTEDRELEASEDATE,
	VERIFIEDDATE,
	CUSTOMERID
) 
SELECT 
	SYS_GUID() AS ID,
	a.ARENPRISPENNAME AS PENITENTIARY,
	a.ARENPRISEXPRELDATE + 0.5 AS EXPECTEDRELEASEDATE,
	a.ARENPRISVERDATE + 0.5 AS VERIFIEDDATE,
	B.CUSTOMERID
FROM 
	ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PARTY_INFO a
	INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMER b ON a.CONSUMERID=b.MIGRATION_SOURCE_ID
WHERE a.ARENPRISFLAG = 'Y'