UPDATE COM_FINVI_OASIS_RESTRICTIONS_{PP_TenantName}.DIALER_COUNTER 
	SET DIALER_RESULT_ID=NULL
	WHERE DIALER_RESULT_ID IN (SELECT DIALER_RESULT_ID FROM ETL_OASIS_DATA_MIG_{PP_TenantName}.ETL_WRK_CALLHIST_DIALER_COUNTER )