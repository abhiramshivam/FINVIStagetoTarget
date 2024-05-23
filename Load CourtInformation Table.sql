INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.COURTINFORMATION
(
	UUID,
	CASENUMBER,
	FILEDATE,
	NAME,
	CITY,
	STATEREFID,
	COUNTY,
	ZIPCODE,
	DISTRICT,
	DIVISION,
	ADDRESSLINE1,
	ADDRESSLINE2,
	PHONE,
	WEBSITE,
	MIGRATION_SOURCE_ID	
)
SELECT 
	SYS_GUID() AS UUID,
	a.ARENLGLCASENUMDS AS CASENUMBER,
	a.ARENLGLFILEDATEDS AS FILEDATE,
	a.ARENLGLCRTNAMEDS AS NAME,
	a.ARENLGLCRTCITYDS AS CITY,
	S.ID AS STATEREFID,
	a.ARENLGLCRTCOUNTYDS AS COUNTY,
	a.ARENLGLCRTZIPDS AS ZIPCODE,
	a.ARENLGLCRTDISTRICTDS AS DISTRICT,
	a.ARENLGLCRTDIVISIONDS AS DIVISION,
	a.ARENLGLCRTADR1DS AS ADDRESSLINE1,
	a.ARENLGLCRTADR2DS AS ADDRESSLINE2,
	a.ARENLGLCRTPHONEDS AS PHONE,
	a.ARENLGLCRTURLDS AS WEBSITE,
	a.CONSUMERID AS MIGRATION_SOURCE_ID	
FROM 
	ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PARTY_INFO a
	INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.CUSTOMER b ON a.CONSUMERID=b.MIGRATION_SOURCE_ID
	LEFT OUTER JOIN COM_FINVI_OASIS_STATIC_DATA_{PP_TenantName}.STATE S ON S.CODE=A.ARENLGLCRTSTDS
WHERE a.ARENDECEASED = 'Y'