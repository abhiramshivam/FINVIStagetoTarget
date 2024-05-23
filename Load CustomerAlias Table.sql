INSERT INTO CUSTOMERALIAS  ( 	ID, 	NAME, 	TYPEID, 	CUSTOMERID, 	INDEXPOSITION ) SELECT DISTINCT  	SYS_GUID() AS ID, 	TRIM(ARENALFNM || ' ' || ARENALLNM) AS NAME,				 	AI.ID AS TYPEID, 	CN.CUSTOMERID, 	0 AS INDEXPOSITION  FROM  	ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_PRTY_ALIASES A 	INNER JOIN COM_FINVI_OASIS_ACCOUNT_DATAMIG.CUSTOMER CN ON A.CONSUMERID = CN.MIGRATION_SOURCE_ID 	LEFT OUTER JOIN COM_FINVI_OASIS_ACCOUNT_DATAMIG.ALIAS_TYPES AI ON A.ARENALFL = AI.CODE  WHERE (A.ARENALFNM IS NOT NULL OR A.ARENALLNM IS NOT NULL)