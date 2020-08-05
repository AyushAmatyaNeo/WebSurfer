CREATE OR REPLACE PROCEDURE HRIS_TRAVEL_REQUEST_PROC(
    P_TRAVEL_ID HRIS_EMPLOYEE_TRAVEL_REQUEST.TRAVEL_ID%TYPE,
    P_LINK_TO_SYNERGY CHAR := 'N')
AS
  V_FROM_DATE HRIS_EMPLOYEE_TRAVEL_REQUEST.FROM_DATE%TYPE;
  V_TO_DATE HRIS_EMPLOYEE_TRAVEL_REQUEST.TO_DATE%TYPE;
  V_EMPLOYEE_ID HRIS_EMPLOYEE_TRAVEL_REQUEST.EMPLOYEE_ID%TYPE;
  V_STATUS HRIS_EMPLOYEE_TRAVEL_REQUEST.STATUS%TYPE;
  V_REQUESTED_AMOUNT HRIS_EMPLOYEE_TRAVEL_REQUEST.REQUESTED_AMOUNT%TYPE;
  V_SETTLEMENT_AMOUNT FLOAT;
  V_REQUEST_TYPE HRIS_EMPLOYEE_TRAVEL_REQUEST.REQUESTED_TYPE%TYPE;
  --
  V_LINK_TRAVEL_TO_SYNERGY HRIS_PREFERENCES.VALUE%TYPE;
  V_FORM_CODE HRIS_PREFERENCES.VALUE%TYPE;
  V_DR_ACC_CODE HRIS_PREFERENCES.VALUE%TYPE;
  V_CR_ACC_CODE HRIS_PREFERENCES.VALUE%TYPE;
  V_EXCESS_CR_ACC_CODE HRIS_PREFERENCES.VALUE%TYPE;
  V_LESS_DR_ACC_CODE HRIS_PREFERENCES.VALUE%TYPE;
  --
  V_COMPANY_CODE VARCHAR2(255 BYTE);
  V_BRANCH_CODE  VARCHAR2(255 BYTE);
  V_CREATED_BY   VARCHAR2(255 BYTE):='ADMIN';
  V_VOUCHER_NO   VARCHAR2(255 BYTE);
BEGIN
  BEGIN
    SELECT TR.FROM_DATE ,
      TR.TO_DATE,
      TR.EMPLOYEE_ID,
      TR.STATUS,
      TR.REQUESTED_AMOUNT,
      TR.REQUESTED_TYPE,
      C.COMPANY_CODE,
      C.COMPANY_CODE
      ||'.01',
      C.LINK_TRAVEL_TO_SYNERGY,
      C.FORM_CODE,
      C.DR_ACC_CODE,
      C.CR_ACC_CODE,
      C.EXCESS_CR_ACC_CODE,
      C.LESS_DR_ACC_CODE
    INTO V_FROM_DATE,
      V_TO_DATE,
      V_EMPLOYEE_ID,
      V_STATUS,
      V_REQUESTED_AMOUNT,
      V_REQUEST_TYPE,
      V_COMPANY_CODE,
      V_BRANCH_CODE,
      V_LINK_TRAVEL_TO_SYNERGY,
      V_FORM_CODE,
      V_DR_ACC_CODE,
      V_CR_ACC_CODE,
      V_EXCESS_CR_ACC_CODE,
      V_LESS_DR_ACC_CODE
    FROM HRIS_EMPLOYEE_TRAVEL_REQUEST TR
    JOIN HRIS_EMPLOYEES E
    ON (TR.EMPLOYEE_ID = E.EMPLOYEE_ID )
    JOIN HRIS_COMPANY C
    ON (E.COMPANY_ID= C.COMPANY_ID)
    WHERE TRAVEL_ID =P_TRAVEL_ID;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT('NO DATA FOUND FOR ID =>'|| P_TRAVEL_ID);
    RETURN;
  END;
  --
  IF V_STATUS IN ('AP','C') AND V_FROM_DATE <TRUNC(SYSDATE) THEN
    HRIS_REATTENDANCE(V_FROM_DATE,V_EMPLOYEE_ID,V_TO_DATE);
  END IF;
  --
END;