UPDATE COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMER cus 
SET cus.LITIGIOUSID = 
(
	SELECT lit.ID 
	FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.LITIGIOUSINFORMATION lit
	WHERE lit.CUSTOMERID = cus.CUSTOMERID
)
WHERE 
	cus.ISLITIGIOUS = 1
	AND cus.MIGRATION_SOURCE_ID IN (SELECT CONSUMERID FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PARTY_INFO par)