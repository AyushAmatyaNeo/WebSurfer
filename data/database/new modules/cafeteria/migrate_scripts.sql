INSERT INTO HRIS_CAFETERIA_TIME_CODE
(
TIME_ID,
TIME_NAME, 
REMARKS,
CREATED_BY,
CREATED_DATE,
COMPANY_ID
)
SELECT 
TIME_CODE,
TIME_EDESC,
REMARKS,
1,
CREATED_DATE,
COMPANY_CODE
FROM 
scp0218.HR_TIME_CODE
;


INSERT INTO HRIS_CAFETERIA_MENU_SETUP
(
MENU_ID,
MENU_NAME, 
QUANTITY,
RATE,
REMARKS,
CREATED_BY,
CREATED_DATE,
COMPANY_ID
)
SELECT 
MENU_CODE,
MENU_EDESC,
QUANTITY,
RATE,
REMARKS,
1,
CREATED_DATE,
COMPANY_CODE
FROM 
scp0218.HR_MENU_MASTER_SETUP
;


INSERT INTO HRIS_CAFETERIA_MENU_TIME_MAP(
MAP_ID,
MENU_ID,
TIME_ID,
CREATED_BY,
CREATED_DATE,
COMPANY_CODE,
"TYPE"
)
SELECT
ROWNUM,
MENU_CODE,
TIME_CODE,
1,
TRUNC(SYSDATE),
1,
'SCP'
FROM SCP0218.HR_MENU_MAP;


