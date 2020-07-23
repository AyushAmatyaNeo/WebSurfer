DECLARE
    P_EMPLOYEE_ID HRIS_ATTENDANCE.EMPLOYEE_ID%TYPE  :=NULL;
    P_LEAVE_ID HRIS_LEAVE_MASTER_SETUP.LEAVE_ID%TYPE:=23;  
  V_TOTAL_NO_OF_DAYS         NUMBER;
  V_TOTAL_NO_OF_PENALTY_DAYS NUMBER;
  V_IS_ASSIGNED              CHAR(1 BYTE);
  V_TOTAL_NO_OF_ENCASH         NUMBER;
  v_functional_type_id         NUMBER;
  v_travel_increment_old          NUMBER;
  v_travel_increment_new          NUMBER;
BEGIN

if P_LEAVE_ID is not null 
then

  FOR leave_addition IN
  (SELECT LA.EMPLOYEE_ID,
    LA.LEAVE_ID,
    SUM(LA.NO_OF_DAYS) AS NO_OF_DAYS from 
    HRIS_EMPLOYEE_LEAVE_ADDITION LA
    LEFT JOIN HRIS_EMPLOYEE_WORK_DAYOFF WD ON(WD.ID=LA.WOD_ID)
    LEFT JOIN HRIS_EMPLOYEE_WORK_HOLIDAY WH ON(WH.ID=LA.WOH_ID)
    LEFT JOIN HRIS_TRAINING_MASTER_SETUP tms ON (TMS.TRAINING_ID=LA.TRAINING_ID)
   GROUP BY LA.EMPLOYEE_ID,
    LA.LEAVE_ID
  )
  LOOP
    SELECT (
      CASE
        WHEN COUNT(*)>0
        THEN 'Y'
        ELSE 'N'
      END)
    INTO V_IS_ASSIGNED
    FROM HRIS_EMPLOYEE_LEAVE_ASSIGN
    WHERE EMPLOYEE_ID = leave_addition.EMPLOYEE_ID
    AND LEAVE_ID      = leave_addition.LEAVE_ID;
    IF(V_IS_ASSIGNED  ='Y')THEN
      UPDATE HRIS_EMPLOYEE_LEAVE_ASSIGN
      SET TOTAL_DAYS   = leave_addition.NO_OF_DAYS
      WHERE EMPLOYEE_ID= leave_addition.EMPLOYEE_ID
      AND LEAVE_ID     = leave_addition.LEAVE_ID;
    ELSE
      INSERT
      INTO HRIS_EMPLOYEE_LEAVE_ASSIGN
        (
          EMPLOYEE_ID,
          LEAVE_ID,
          TOTAL_DAYS,
          BALANCE,
          CREATED_DT
        )
        VALUES
        (
          leave_addition.EMPLOYEE_ID,
          leave_addition.LEAVE_ID,
          leave_addition.NO_OF_DAYS,
          0,
          TRUNC(SYSDATE)
        );
    END IF;
  END LOOP;
  --





  FOR leave_assign IN
  (SELECT A.*
    FROM HRIS_EMPLOYEE_LEAVE_ASSIGN A
    JOIN HRIS_LEAVE_MASTER_SETUP L
    ON (A.LEAVE_ID     = L.LEAVE_ID)
    WHERE L.IS_MONTHLY = 'N'
    AND (A.EMPLOYEE_ID =
      CASE
        WHEN P_EMPLOYEE_ID IS NOT NULL
        THEN P_EMPLOYEE_ID
      END
    OR P_EMPLOYEE_ID IS NULL)
    AND (A.LEAVE_ID   =
      CASE
        WHEN P_LEAVE_ID IS NOT NULL
        THEN P_LEAVE_ID
      END
    OR P_LEAVE_ID IS NULL)
  )
  LOOP
    BEGIN
      SELECT NVL(SUM(R.NO_OF_DAYS/(
        CASE
          WHEN R.HALF_DAY IN ('F','S')
          THEN 2
          ELSE 1
        END)),0) AS TOTAL_NO_OF_DAYS
      INTO V_TOTAL_NO_OF_DAYS
      FROM HRIS_EMPLOYEE_LEAVE_REQUEST R
      WHERE R.STATUS IN('AP','CP','CR')
      AND R.EMPLOYEE_ID = leave_assign.EMPLOYEE_ID
      AND R.LEAVE_ID    = leave_assign.LEAVE_ID
      GROUP BY R.EMPLOYEE_ID ,
        R.LEAVE_ID;
    EXCEPTION
    WHEN no_data_found THEN
      V_TOTAL_NO_OF_DAYS:=0;
    END;
    BEGIN
      SELECT NVL(SUM(NO_OF_DAYS),0)
      INTO V_TOTAL_NO_OF_PENALTY_DAYS
      FROM HRIS_EMPLOYEE_PENALTY_DAYS PD
      WHERE PD.EMPLOYEE_ID = leave_assign.EMPLOYEE_ID
      AND PD.LEAVE_ID      = leave_assign.LEAVE_ID;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_TOTAL_NO_OF_PENALTY_DAYS:=0;
    END;


    BEGIN
SELECT
     SUM(SLC.ENCASH_DAYS) AS TOTAL_NO_OF_ENCASH
      INTO V_TOTAL_NO_OF_ENCASH
      FROM Hris_Emp_Self_Leave_Closing SLC
      WHERE SLC.STATUS IN('E')
      AND SLC.EMPLOYEE_ID = leave_assign.EMPLOYEE_ID
      AND SLC.LEAVE_ID    = leave_assign.LEAVE_ID
      GROUP BY SLC.EMPLOYEE_ID ,
        SLC.LEAVE_ID;
        EXCEPTION
    WHEN NO_DATA_FOUND THEN
      V_TOTAL_NO_OF_ENCASH:=0;
    END;





    UPDATE HRIS_EMPLOYEE_LEAVE_ASSIGN
    SET BALANCE       = TOTAL_DAYS+CASE WHEN PREVIOUS_YEAR_BAL IS NULL THEN 0 ELSE PREVIOUS_YEAR_BAL END - (V_TOTAL_NO_OF_DAYS+V_TOTAL_NO_OF_PENALTY_DAYS+V_TOTAL_NO_OF_ENCASH)
    WHERE EMPLOYEE_ID = leave_assign.EMPLOYEE_ID
    AND LEAVE_ID      = leave_assign.LEAVE_ID;
  END LOOP;
  
  
  
  end if;
END;

