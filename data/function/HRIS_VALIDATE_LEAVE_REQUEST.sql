create or replace FUNCTION HRIS_VALIDATE_LEAVE_REQUEST(
    P_EMPLOYEE_ID HRIS_EMPLOYEE_LEAVE_REQUEST.EMPLOYEE_ID%TYPE,
    P_START_DATE HRIS_EMPLOYEE_LEAVE_REQUEST.START_DATE%TYPE,
    P_END_DATE HRIS_EMPLOYEE_LEAVE_REQUEST.END_DATE%TYPE )
  RETURN VARCHAR2
AS
  V_MONTH_FROM_DATE      DATE;
  V_MONTH_TO_DATE        DATE;
  V_OVERLAPPING_LEAVE_NO NUMBER:=0;
BEGIN
  SELECT FROM_DATE,
    TO_DATE
  INTO V_MONTH_FROM_DATE,
    V_MONTH_TO_DATE
  FROM HRIS_MONTH_CODE
  WHERE TRUNC(SYSDATE) BETWEEN FROM_DATE AND TO_DATE;
  --
  IF(TRUNC(P_START_DATE)<TRUNC(V_MONTH_FROM_DATE)) THEN
    RETURN 'Leave Request to previous month is not allowed.';
  END IF;
--
SELECT COUNT(*)
INTO V_OVERLAPPING_LEAVE_NO
FROM HRIS_EMPLOYEE_LEAVE_REQUEST
WHERE ((TRUNC(P_START_DATE) BETWEEN START_DATE AND END_DATE)
OR (TRUNC(P_END_DATE) BETWEEN START_DATE AND END_DATE))
AND STATUS= 'AP' ;
--
IF(V_OVERLAPPING_LEAVE_NO >0) THEN
  RETURN 'Leave Request is overlapping other leave request.';
END IF;
END;