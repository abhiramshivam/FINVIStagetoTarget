INSERT INTO COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNTEXTENSIONCHAR
(
	ACCOUNTNUM, 
	CREATEDATE,
	LASTUPDATEDATE,
	CLIENTDEFINEDCHAR6,
	CLIENTDEFINEDCHAR7,
	CLIENTDEFINEDCHAR9,
	CLIENTDEFINEDCHAR10,
	CLIENTDEFINEDCHAR16,
	CLIENTDEFINEDCHAR8,
	CLIENTDEFINEDCHAR15,
	CLIENTDEFINEDCHAR13,
	CLIENTDEFINEDCHAR14,
	CLIENTDEFINEDCHAR12,
	CLIENTDEFINEDCHAR11,
	CLIENTDEFINEDCHAR1
)
SELECT 
	a.ACCOUNTNUM AS ACCOUNTNUM, 
	SYSDATE AS CREATEDATE,
	SYSDATE AS LASTUPDATEDATE,
	esca.CUSTOMFLD2 AS CLIENTDEFINEDCHAR6,
	esca.CUSTOMFLD3 AS CLIENTDEFINEDCHAR7,
	esca.CUSTOMFLD8 AS CLIENTDEFINEDCHAR9,
	esca.CUSTOMFLD9 AS CLIENTDEFINEDCHAR10,
	esca.CUSTOMFLD15 AS CLIENTDEFINEDCHAR16,
	esca.CUSTOMFLD4 AS CLIENTDEFINEDCHAR8,
	esca.CUSTOMFLD14 AS CLIENTDEFINEDCHAR15,
	esca.CUSTOMFLD12 AS CLIENTDEFINEDCHAR13,
	esca.CUSTOMFLD13 AS CLIENTDEFINEDCHAR14,
	esca.CUSTOMFLD11 AS CLIENTDEFINEDCHAR12,
	esca.CUSTOMFLD10 AS CLIENTDEFINEDCHAR11,
	esca.CUSTOMFLD1 AS CLIENTDEFINEDCHAR1
FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_CUSTOM_ACCOUNT esca
	INNER JOIN COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.ACCOUNT a ON a.MIGRATION_SOURCE_ID = esca.ACCOUNTID 
WHERE CUSTOMFLD1 IS NOT NULL