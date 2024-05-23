INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMERCONTACTADDRESS
(
	UUID,
	CREATEDATE,
	LASTUPDATEDATE,	
	CREATORID,
	LASTUPDATERID,	
	ADDRESS1,
	ADDRESS2,	
	CITY,
	STATEID,
	COUNTRYID,
	POSTALCODE,
	CUSTOMERID,
	HISTORICAL,
	TYPEID,
	SOURCE,
	EXPRESSCONSENT,
	ISDEFAULT,
	SOURCEREFERENCEID
)
SELECT 
	SYS_GUID() AS UUID,
	SYSDATE AS CREATEDATE,
	SYSDATE AS LASTUPDATEDATE,	
    (SELECT ID FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ WHERE USERNAME = 'etlmigrationuser@finvi.com') AS CREATORID,
    (SELECT ID FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ WHERE USERNAME = 'etlmigrationuser@finvi.com') AS LASTUPDATERID,	
	PA.ARENAADR,
	PA.ARENAUNT,
	PA.ARENACTY,
	S.ID,
	S.COUNTRY_ID,
	PA.ARENAZIP,
	B.CUSTOMERID,
	'Y' AS HISTORICAL,
	PA.ARRELTYPID,
	'CLIENT' AS SOURCE,
	'NA' AS EXPRESSCONSENT,
	0 AS ISDEFAULT,
	(SELECT ID FROM COM_FINVI_OASIS_STATIC_DATA_{PP_TenantName}.DEMOGRAPHIC_SOURCE WHERE SOURCE='Client') AS SOURCEREFERENCEID
FROM 
	ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PRTY_PREV_ADDR_INFO PA
	INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMER B ON PA.CONSUMERID = B.MIGRATION_SOURCE_ID
	LEFT OUTER JOIN COM_FINVI_OASIS_STATIC_DATA_{PP_TenantName}.STATE S ON S.CODE = PA.ARENAST
WHERE (PA.ARENAADR IS NOT NULL OR PA.ARENAUNT IS NOT NULL OR PA.ARENACTY IS NOT NULL OR PA.ARENAST IS NOT NULL OR PA.ARENAZIP IS NOT NULL) 