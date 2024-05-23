INSERT INTO COM_FINVI_OASIS_RESTRICTIONS_{PP_TenantName}.TIMING_RESTRICTION
(
	ID,
	RESTRICTION_MAPPING_ID,
	START_TIMING,
	END_TIMING
)
SELECT  
	SYS_GUID() AS ID,
	RM.ID AS RESTRICTION_MAPPING_ID,
	RS.START_TIMING,
	RS.END_TIMING  
FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_RESTRICTION RS
	JOIN  COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMER C ON RS.CONSUMER_ID = C.MIGRATION_SOURCE_ID
	JOIN COM_FINVI_OASIS_RESTRICTIONS_{PP_TenantName}.COMMUNICATION_RESTRICTION CM ON CM.CUSTOMER_ID = C.UUID
	JOIN COM_FINVI_OASIS_RESTRICTIONS_{PP_TenantName}.RESTRICTION_MAPPING RM ON RM.COMMUNICATION_RESTRICTION_ID = CM.ID
WHERE RS.TIME_ZONE IS NOT NULL AND RS.START_TIMING  IS NOT NULL AND RS.END_TIMING IS NOT NULL