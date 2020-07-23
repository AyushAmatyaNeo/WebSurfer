create or replace PROCEDURE HRIS_WOD_OT_ADDITION(
    P_ID HRIS_EMPLOYEE_WORK_DAYOFF.ID%TYPE)
AS
  V_OVERTIME_ID HRIS_OVERTIME.OVERTIME_ID%TYPE;
  V_EMPLOYEE_ID HRIS_EMPLOYEE_WORK_HOLIDAY.EMPLOYEE_ID%TYPE ;
  V_RECOMMENDED_BY HRIS_EMPLOYEE_WORK_HOLIDAY.RECOMMENDED_BY%TYPE ;
  V_APPROVED_BY HRIS_EMPLOYEE_WORK_HOLIDAY.APPROVED_BY%TYPE;
  V_REQUESTED_DT HRIS_EMPLOYEE_WORK_HOLIDAY.REQUESTED_DATE%TYPE;
  V_FROM_DATE HRIS_EMPLOYEE_WORK_HOLIDAY.FROM_DATE%TYPE;
  V_TO_DATE HRIS_EMPLOYEE_WORK_HOLIDAY.TO_DATE%TYPE;
  V_STATUS        CHAR(2 BYTE)      :='AP';
  V_DESCRIPTION   VARCHAR2(255 BYTE):='THIS IS WOD OT.';
  V_TOTAL_HOUR    NUMBER ;
  V_DIFF          NUMBER;
  V_DETAIL_ID     NUMBER;
  V_START_TIME    DATE ;
  V_END_TIME      DATE ;
  V_DETAIL_STATUS CHAR(1 BYTE):='E';
BEGIN
  BEGIN
    SELECT EMPLOYEE_ID,
      RECOMMENDED_BY,
      APPROVED_BY,
      REQUESTED_DATE,
      FROM_DATE,
      TO_DATE
    INTO V_EMPLOYEE_ID,
      V_RECOMMENDED_BY,
      V_APPROVED_BY,
      V_REQUESTED_DT,
      V_FROM_DATE,
      V_TO_DATE
    FROM HRIS_EMPLOYEE_WORK_DAYOFF
    WHERE ID = P_ID;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT('No WOH found for '||P_ID);
  END;
  V_DIFF :=TRUNC(V_TO_DATE)-TRUNC(V_FROM_DATE);
  FOR i                   IN 0..V_DIFF
  LOOP
    SELECT NVL(MAX(OVERTIME_ID),1)+1 INTO V_OVERTIME_ID FROM HRIS_OVERTIME;
    SELECT NVL(MAX(DETAIL_ID),1)+1 INTO V_DETAIL_ID FROM HRIS_OVERTIME_DETAIL;
    BEGIN
      SELECT (
        CASE
          WHEN AD.OVERALL_STATUS = 'WD'
          THEN AD.IN_TIME
          ELSE S.START_TIME
        END),
        (
        CASE
          WHEN AD.OVERALL_STATUS ='WD'
          THEN AD.OUT_TIME
          ELSE S.END_TIME
        END),
        (
        CASE
          WHEN AD.OVERALL_STATUS ='WD'
          THEN AD.TOTAL_HOUR
          ELSE S.TOTAL_WORKING_HR
        END)
      INTO V_START_TIME,
        V_END_TIME,
        V_TOTAL_HOUR
      FROM HRIS_ATTENDANCE_DETAIL AD
      JOIN HRIS_SHIFTS S
      ON (AD.SHIFT_ID        =S.SHIFT_ID)
      WHERE AD.ATTENDANCE_DT = TRUNC(V_FROM_DATE)+i
      AND AD.EMPLOYEE_ID     =V_EMPLOYEE_ID
      AND AD.OVERALL_STATUS IN ( 'WD','VP');
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      CONTINUE;
    END;
    IF(V_START_TIME IS NOT NULL AND V_END_TIME IS NOT NULL ) THEN
      INSERT
      INTO HRIS_OVERTIME
        (
          OVERTIME_ID,
          EMPLOYEE_ID,
          OVERTIME_DATE,
          REQUESTED_DATE,
          DESCRIPTION,
          STATUS,
          RECOMMENDED_BY,
          RECOMMENDED_DATE,
          APPROVED_BY,
          APPROVED_DATE,
          TOTAL_HOUR,
          WOD_ID
        )
        VALUES
        (
          V_OVERTIME_ID,
          V_EMPLOYEE_ID,
          V_FROM_DATE+i,
          V_REQUESTED_DT,
          V_DESCRIPTION,
          V_STATUS,
          V_RECOMMENDED_BY,
          V_REQUESTED_DT,
          V_APPROVED_BY,
          V_REQUESTED_DT,
          V_TOTAL_HOUR,
          P_ID
        );
      INSERT
      INTO HRIS_OVERTIME_DETAIL
        (
          DETAIL_ID,
          OVERTIME_ID,
          START_TIME,
          END_TIME,
          STATUS,
          TOTAL_HOUR,
          WOD_ID
        )
        VALUES
        (
          V_DETAIL_ID,
          V_OVERTIME_ID,
          V_START_TIME,
          V_END_TIME,
          V_DETAIL_STATUS,
          V_TOTAL_HOUR,
          P_ID
        );
    END IF;
  END LOOP;
END;