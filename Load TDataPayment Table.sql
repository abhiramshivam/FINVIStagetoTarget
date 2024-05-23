INSERT INTO COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_PAYMENT
(
	PAYMENT_AMOUNT,
	EFFECTIVE_DATE,
	POSTED_DATE,
	MANUAL_ALLOCATION,
	VERSION,
	PAYMENT_METHOD_ID,
	PROCESSING_REQUIRED,
	TRANSACTION_PENDING,
	AUTO_DEPOSIT,
	IS_OVERPAYMENT,
	"TYPE",
	PAYMENT_TYPE_INT,
	PAYMENT_TYPE_SCODE,
	PAYMENT_UUID,
	CONSUMER_UUID,
	DIRECTED_INDICATOR,
	PAID_TO,
	PROCESSING_MODE_INT,
	PAYMENT_TYPE_SCODE_UUID,
	PAYMENT_INITIATION_ACCOUNT,
	PAYMENT_IMPORT,
	MIG_SRC_TRAN_ID,
	PAYMENT_METHOD,
	BATCH_UUID,
	MIG_SRC_ACCT_ID,
	CREATE_DATE,
	MODIFIED_ON,
	CREATE_BY,
	MODIFIED_BY,
	TRANSACTION_SOURCE
)
WITH CTE AS
(
	SELECT
		NVL(th.PRNAPPLYAMT,0) +
		NVL( th.LI4BALAPPLYAMT,0) +
		NVL( th.LI3BALAPPLYAMT,0) +
		NVL( th.INTAPPLYAMT,0) +
		NVL( th.AININTAPPLYAMT,0) AS PAYMENT_AMOUNT ,
		th.AFTREFFDTE + 0.5 AS EFFECTIVE_DATE,
		th.AFTRACCTDTE + 0.5 AS POSTED_DATE,
		0 AS MANUAL_ALLOCATION,
		0 AS VERSION,
		(SELECT MAX(PAYMENT_METHOD_ID) FROM COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_PAYMENT_METHOD WHERE TYPE = 101 AND PAYMENT_TYPE_SCODE = 502 AND CREATE_BY = '00u6g7u0kpXl40szn4h7') AS PAYMENT_METHOD_ID,
		0 AS PROCESSING_REQUIRED,
		0 AS TRANSACTION_PENDING,
		0 AS AUTO_DEPOSIT,
		0 AS IS_OVERPAYMENT,
		100 AS "TYPE",
		101 AS PAYMENT_TYPE_INT,
		502 AS PAYMENT_TYPE_SCODE,
		LOWER(
				SUBSTR(th.UUID,1,8) || '-' ||
				SUBSTR(th.UUID,9,4) || '-' ||
				SUBSTR(th.UUID,13,4) || '-' ||
				SUBSTR(th.UUID,17,4) || '-' ||
				SUBSTR(th.UUID,21)
			) AS PAYMENT_UUID,
		LOWER(
				SUBSTR(CN.UUID,1,8) || '-' ||
				SUBSTR(CN.UUID,9,4) || '-' ||
				SUBSTR(CN.UUID,13,4) || '-' ||
				SUBSTR(CN.UUID,17,4) || '-' ||
				SUBSTR(CN.UUID,21)
			) AS CONSUMER_UUID,
		0 AS DIRECTED_INDICATOR,
		1 AS PAID_TO,
		1 AS PROCESSING_MODE_INT,
		LOWER(
			SUBSTR(ajcr.UUID,1,8) || '-' ||
			SUBSTR(ajcr.UUID,9,4) || '-' ||
			SUBSTR(ajcr.UUID,13,4) || '-' ||
			SUBSTR(ajcr.UUID,17,4) || '-' ||
			SUBSTR(ajcr.UUID,21))
		AS PAYMENT_TYPE_SCODE_UUID,
	    dt.ACCOUNT_UUID AS PAYMENT_INITIATION_ACCOUNT,
		0 AS PAYMENT_IMPORT,
		th.SOURCETRANSACTIONID AS MIGRATION_SOURCE_ID,
		th.AFTRTYP AS PAYMENT_METHOD,
		th.ACCOUNTID,
		SYSDATE AS CREATE_DATE,
		SYSDATE AS MODIFIED_ON,
	    (SELECT IDPUSERID FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ WHERE USERNAME = 'etlmigrationuser@finvi.com') AS CREATE_BY,
	    (SELECT IDPUSERID FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ WHERE USERNAME = 'etlmigrationuser@finvi.com') AS MODIFIED_BY,
		'AGENT_PORTAL' AS TRANSACTION_SOURCE,
		 CEIL(ROWNUM/1000) rno_batch
	FROM
		(
			SELECT a.* , SYS_GUID() UUID
			FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_STG_TRAN_HIST a
		) th,	
		COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.account aa,
		COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.responsible r,
		COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.responsibleindex ri,
		COM_FINVI_OASIS_STATIC_DATA_{PP_TenantName}.RELATIONSHIP_TYPE rirt,
		COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.customer cn,
		COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_ACCOUNT dt,
		COM_FINVI_OASIS_TRANSACTIONCODES_{PP_TenantName}.AJ_CORE_TRANSACTION_CODE ajcr
	WHERE
		th.ACCOUNTID=aa.MIGRATION_SOURCE_ID
		AND aa.ACCOUNTNUM=r.ACCOUNTNUM
		AND r.RESPONSIBLEID=ri.RESPONSIBLEID
		AND ri.customerinfoid=cn.customerid
		AND rirt.ID = r.RELATIONSHIPTYPEID AND rirt.NAME  = 'Primary'
		AND aa.MIGRATION_SOURCE_ID= dt.MIG_SRC_ACCT_ID
		AND ajcr.CODE = th.AFTRTYP
		AND ajcr.TRANSACTION_TYPE NOT IN ('Adjustment','Reversal')
)
SELECT CTE.PAYMENT_AMOUNT,
CTE.EFFECTIVE_DATE,
CTE.POSTED_DATE,
CTE.MANUAL_ALLOCATION,
CTE.VERSION,
CTE.PAYMENT_METHOD_ID,
CTE.PROCESSING_REQUIRED,
CTE.TRANSACTION_PENDING,
CTE.AUTO_DEPOSIT,
CTE.IS_OVERPAYMENT,
CTE.TYPE,
CTE.PAYMENT_TYPE_INT,
CTE.PAYMENT_TYPE_SCODE,
CTE.PAYMENT_UUID,
CTE.CONSUMER_UUID,
CTE.DIRECTED_INDICATOR,
CTE.PAID_TO,
CTE.PROCESSING_MODE_INT,
CTE.PAYMENT_TYPE_SCODE_UUID,
CTE.PAYMENT_INITIATION_ACCOUNT,
CTE.PAYMENT_IMPORT,
CTE.MIGRATION_SOURCE_ID,
CTE.PAYMENT_METHOD,
DB.UUID AS BATCH_UUID,
CTE.ACCOUNTID,
CTE.CREATE_DATE,
CTE.MODIFIED_ON,
CTE.CREATE_BY,
CTE.MODIFIED_BY,
CTE.TRANSACTION_SOURCE
FROM CTE
INNER JOIN COM_FINVI_OASIS_MACRO_ACCOUNT_{PP_TenantName}.T_DATA_BATCH DB
	ON TO_CHAR(CTE.RNO_BATCH) || '-Payment' = DB.COMMENT_								-- Converted TO TO_CHAR
WHERE DB.IS_DELETED <> '1'
AND DB.CREATED_BY = (SELECT IDPUSERID FROM COM_FINVI_OASIS_ACCOUNT_{PP_TenantName}.user_ WHERE USERNAME = 'etlmigrationuser@finvi.com')