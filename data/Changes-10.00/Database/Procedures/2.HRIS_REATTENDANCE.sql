create or replace PROCEDURE HRIS_REATTENDANCE(
    P_FROM_ATTENDANCE_DT HRIS_ATTENDANCE.ATTENDANCE_DT%TYPE,
    P_EMPLOYEE_ID HRIS_ATTENDANCE.EMPLOYEE_ID%TYPE:=NULL,
    P_TO_ATTENDANCE_DT DATE                       :=NULL)
AS
  V_TO_ATTENDANCE_DT DATE;
  V_DATE_DIFF        NUMBER;
  --
  V_EMPLOYEE_ID HRIS_EMPLOYEES.EMPLOYEE_ID%TYPE;
  V_IN_TIME HRIS_ATTENDANCE_DETAIL.IN_TIME%TYPE;
  V_OUT_TIME HRIS_ATTENDANCE_DETAIL.OUT_TIME%TYPE;
  V_DIFF_IN_MIN NUMBER;
  --
  V_OVERALL_STATUS HRIS_ATTENDANCE_DETAIL.OVERALL_STATUS%TYPE;
  V_LATE_STATUS HRIS_ATTENDANCE_DETAIL.LATE_STATUS%TYPE:='N';
  V_HALFDAY_FLAG HRIS_ATTENDANCE_DETAIL.HALFDAY_FLAG%TYPE;
  V_HALFDAY_PERIOD HRIS_ATTENDANCE_DETAIL.HALFDAY_PERIOD%TYPE;
  V_GRACE_PERIOD HRIS_ATTENDANCE_DETAIL.GRACE_PERIOD%TYPE;
  V_TWO_DAY_SHIFT HRIS_ATTENDANCE_DETAIL.TWO_DAY_SHIFT%TYPE;
  V_IGNORE_TIME HRIS_ATTENDANCE_DETAIL.IGNORE_TIME%TYPE;
  V_TWO_DAY_SHIFT_AUTO CHAR;
  --
  V_FROM_DATE DATE;
  V_TO_DATE   DATE;
  --
  V_LATE_IN HRIS_SHIFTS.LATE_IN%TYPE;
  V_EARLY_OUT HRIS_SHIFTS.EARLY_OUT%TYPE;
  V_LATE_START_TIME   TIMESTAMP;
  V_EARLY_END_TIME    TIMESTAMP;
  V_TOTAL_WORKING_MIN NUMBER;
  --
  V_LATE_COUNT NUMBER;
  V_SHIFT_ID   NUMBER;
  --
  V_HALF_INTERVAL      DATE;
  v_NEXT_HALF_INTERVAL DATE;
  v_training_id          number;
  v_roaster_shift_id number;
  V_SP_ID HRIS_SPECIAL_ATTENDANCE_ASSIGN.SP_ID%TYPE;
  V_DISPLAY_IN_OUT HRIS_SPECIAL_ATTENDANCE_ASSIGN.DISPLAY_IN_OUT%TYPE;
  V_SHIFT_START_TIME HRIS_SHIFTS.START_TIME%TYPE;
  V_SHIFT_END_TIME HRIS_SHIFTS.END_TIME%TYPE;
  V_TMR_TWO_DAY_SHIFT CHAR(1 BYTE);
  ----------------
  v_travel_id          number;
  V_customizedDayOff VARCHAR2(100);
  V_dayOffTravelAutoAddLeave VARCHAR2(100);
  V_dayOffTrainingAutoAddLeave VARCHAR2(100);
  V_IS_DAYOFF CHAR(1);
BEGIN
  IF P_TO_ATTENDANCE_DT IS NOT NULL THEN
    V_TO_ATTENDANCE_DT  :=P_TO_ATTENDANCE_DT;
  ELSE
    V_TO_ATTENDANCE_DT :=SYSDATE;
  END IF;
  V_DATE_DIFF := TRUNC( V_TO_ATTENDANCE_DT)- TRUNC(P_FROM_ATTENDANCE_DT);
  FOR i                                   IN 0..V_DATE_DIFF
  LOOP
    BEGIN
      SELECT FROM_DATE,
        TO_DATE
      INTO V_FROM_DATE,
        V_TO_DATE
      FROM HRIS_MONTH_CODE
      WHERE TRUNC(P_FROM_ATTENDANCE_DT+i) BETWEEN TRUNC(FROM_DATE) AND TRUNC(TO_DATE);
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20344, 'NO MONTH_CODE FOUND FOR THE DATE');
    END;
    --
    DELETE
    FROM HRIS_ATTENDANCE_DETAIL
    WHERE ATTENDANCE_DT= TRUNC(P_FROM_ATTENDANCE_DT+i)
    AND (EMPLOYEE_ID   =
      CASE
        WHEN P_EMPLOYEE_ID IS NOT NULL
        THEN P_EMPLOYEE_ID
      END
    OR P_EMPLOYEE_ID IS NULL);
    HRIS_PRELOAD_ATTENDANCE(TRUNC(P_FROM_ATTENDANCE_DT+i),P_EMPLOYEE_ID);
    --
    FOR employee IN
    (SELECT       *
    FROM HRIS_ATTENDANCE_DETAIL
    WHERE ATTENDANCE_DT = TRUNC(P_FROM_ATTENDANCE_DT+i)
    AND (EMPLOYEE_ID    =
      CASE
        WHEN P_EMPLOYEE_ID IS NOT NULL
        THEN P_EMPLOYEE_ID
      END
    OR P_EMPLOYEE_ID IS NULL)
    )
    LOOP
      V_DIFF_IN_MIN    :=NULL;
      V_OVERALL_STATUS :=employee.OVERALL_STATUS;
      V_LATE_STATUS    :=employee.LATE_STATUS;
      V_HALFDAY_FLAG   :=employee.HALFDAY_FLAG;
      V_HALFDAY_PERIOD :=employee.HALFDAY_PERIOD;
      V_GRACE_PERIOD   :=employee.GRACE_PERIOD;
      V_TWO_DAY_SHIFT  := employee.TWO_DAY_SHIFT;
      V_IGNORE_TIME    :=employee.IGNORE_TIME;
      V_SHIFT_ID       := employee.SHIFT_ID;
      v_roaster_shift_id := null;

      begin
      select CASE when  shift_id > 0 then shift_id else null end into v_roaster_shift_id
      from HRIS_EMPLOYEE_SHIFT_ROASTER where employee_id=employee.EMPLOYEE_ID and FOR_DATE=employee.ATTENDANCE_DT;
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
          null;
        END;

      --
      DELETE
      FROM HRIS_ATTENDANCE_DETAIL
      WHERE ATTENDANCE_DT= TRUNC(employee.ATTENDANCE_DT)
      AND EMPLOYEE_ID    = employee.EMPLOYEE_ID ;
      --
      if(v_roaster_shift_id is null)then
      V_SHIFT_ID    :=HRIS_BEST_CASE_SHIFT(employee.EMPLOYEE_ID,TRUNC(employee.ATTENDANCE_DT));
      end if;

      IF(V_SHIFT_ID IS NULL)THEN
        V_SHIFT_ID  :=employee.SHIFT_ID;
      ELSE
      select two_day_shift into V_TWO_DAY_SHIFT from hris_shifts where shift_id=V_SHIFT_ID;
      END IF;

      BEGIN
          SELECT TWO_DAY_SHIFT INTO V_TMR_TWO_DAY_SHIFT FROM HRIS_ATTENDANCE_DETAIL WHERE ATTENDANCE_DT = employee.ATTENDANCE_DT+1 and EMPLOYEE_ID = employee.EMPLOYEE_ID;
          EXCEPTION
    WHEN NO_DATA_FOUND THEN
          V_TMR_TWO_DAY_SHIFT:='E';
      END;

      HRIS_PRELOAD_ATTENDANCE(employee.ATTENDANCE_DT,employee.EMPLOYEE_ID,V_SHIFT_ID);
      --
      HRIS_ATTD_IN_OUT(employee.EMPLOYEE_ID,TRUNC(employee.ATTENDANCE_DT),TRUNC(employee.ATTENDANCE_DT+1),V_IN_TIME,V_OUT_TIME,V_TWO_DAY_SHIFT_AUTO,V_SHIFT_ID,V_TMR_TWO_DAY_SHIFT);
      --
      
      --------LOGIC FOR 1st and 3rd sunday DO---------
      SELECT VALUE INTO V_customizedDayOff FROM HRIS_SETTINGS WHERE NAME = 'reatt.customizedDayOff';

      IF (V_customizedDayOff = '1') 
      THEN 
        SELECT HRIS_GET_CUSTOMIZED_DO (employee.EMPLOYEE_ID, employee.ATTENDANCE_DT) INTO V_IS_DAYOFF FROM DUAL;

        IF(V_IS_DAYOFF='Y' AND V_OVERALL_STATUS not in ('HD', 'WD', 'WH', 'TV', 'TN'))
        THEN
            V_OVERALL_STATUS := 'DO';
            UPDATE HRIS_ATTENDANCE_DETAIL
              SET 
                OVERALL_STATUS    = V_OVERALL_STATUS
              WHERE ATTENDANCE_DT = TO_DATE (employee.ATTENDANCE_DT, 'DD-MON-YY')
              AND EMPLOYEE_ID     = employee.EMPLOYEE_ID;
        END IF;
    END IF;
    -------------------------------
    
      IF (V_IGNORE_TIME         ='Y') THEN
        IF V_TWO_DAY_SHIFT_AUTO ='Y' THEN
          HRIS_ATTD_IN_OUT(employee.EMPLOYEE_ID,TRUNC(employee.ATTENDANCE_DT),TRUNC(employee.ATTENDANCE_DT+2),V_IN_TIME,V_OUT_TIME,V_TWO_DAY_SHIFT_AUTO,V_SHIFT_ID,V_TMR_TWO_DAY_SHIFT);
        END IF;
        IF V_IN_TIME IS NOT NULL THEN
          --
          IF V_IN_TIME  = V_OUT_TIME THEN
            V_OUT_TIME := NULL;
          END IF;
          --
          IF V_OUT_TIME IS NOT NULL THEN
            SELECT SUM(ABS(EXTRACT( HOUR FROM DIFF ))*60 + ABS(EXTRACT( MINUTE FROM DIFF )))
            INTO V_DIFF_IN_MIN
            FROM
              (SELECT V_OUT_TIME -V_IN_TIME AS DIFF FROM DUAL
              ) ;
          END IF;
          IF(V_OVERALL_STATUS     ='DO') THEN
            V_OVERALL_STATUS     :='WD';
          ELSIF (V_OVERALL_STATUS ='HD') THEN
            V_OVERALL_STATUS     :='WH';
          ELSIF (V_OVERALL_STATUS ='LV') THEN
            NULL;
          ELSIF (V_OVERALL_STATUS ='TV') THEN
            NULL;
          ELSIF (V_OVERALL_STATUS ='TN') THEN
            NULL;
          ELSIF (V_OVERALL_STATUS = 'AB') THEN
            IF V_HALFDAY_FLAG     ='N' AND (V_HALFDAY_PERIOD IS NOT NULL OR V_GRACE_PERIOD IS NOT NULL) THEN
              V_OVERALL_STATUS   :='LP';
            ELSE
              V_OVERALL_STATUS :='PR';
            END IF;
          END IF;
          UPDATE HRIS_ATTENDANCE_DETAIL
          SET IN_TIME         = V_IN_TIME,
            OUT_TIME          =V_OUT_TIME,
            OVERALL_STATUS    = V_OVERALL_STATUS,
            LATE_STATUS       = V_LATE_STATUS,
            TOTAL_HOUR        = V_DIFF_IN_MIN
          WHERE ATTENDANCE_DT = TO_DATE (employee.ATTENDANCE_DT, 'DD-MON-YY')
          AND EMPLOYEE_ID     = employee.EMPLOYEE_ID;
        END IF;
        CONTINUE;
      END IF;
      --
      IF V_TWO_DAY_SHIFT ='E' THEN
        --
        SELECT LATE_IN,
          EARLY_OUT,
          LATE_START_TIME,
          EARLY_END_TIME,
          EARLY_END_TIME + (LATE_START_TIME -EARLY_END_TIME)/2,
          TOTAL_WORKING_HR
        INTO V_LATE_IN,
          V_EARLY_OUT,
          V_LATE_START_TIME,
          V_EARLY_END_TIME,
          V_HALF_INTERVAL,
          V_TOTAL_WORKING_MIN
        FROM
          (SELECT S.LATE_IN,
            S.EARLY_OUT,
            TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
            ||' '
            ||TO_CHAR(S.START_TIME+((1/1440)*NVL(S.LATE_IN,0)),'HH:MI AM'),'DD-MON-YYYY HH:MI AM') AS LATE_START_TIME,
            TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
            ||' '
            || TO_CHAR(S.END_TIME -((1/1440)*NVL(S.EARLY_OUT,0)),'HH:MI AM'),'DD-MON-YYYY HH:MI AM') AS EARLY_END_TIME,
            S.TOTAL_WORKING_HR
          FROM HRIS_SHIFTS S
          WHERE S.SHIFT_ID=V_SHIFT_ID
          );
        V_NEXT_HALF_INTERVAL:=V_HALF_INTERVAL+1;
        --
        V_EARLY_END_TIME:=V_EARLY_END_TIME+1;
        HRIS_ATTD_IN_OUT(employee.EMPLOYEE_ID,V_HALF_INTERVAL,V_NEXT_HALF_INTERVAL,V_IN_TIME,V_OUT_TIME,V_TWO_DAY_SHIFT_AUTO,V_SHIFT_ID,V_TMR_TWO_DAY_SHIFT);
        --
      END IF;
      --
      IF V_IN_TIME IS NOT NULL THEN
        --
        IF V_IN_TIME  = V_OUT_TIME THEN
          V_OUT_TIME := NULL;
        END IF;
        --
        IF V_OUT_TIME IS NOT NULL THEN
          SELECT SUM(ABS(EXTRACT( HOUR FROM DIFF ))*60 + ABS(EXTRACT( MINUTE FROM DIFF )))
          INTO V_DIFF_IN_MIN
          FROM
            (SELECT V_OUT_TIME -V_IN_TIME AS DIFF FROM DUAL
            ) ;
        END IF;
        --
        BEGIN
          IF V_HALFDAY_PERIOD IS NOT NULL THEN
            SELECT LATE_IN,
              EARLY_OUT,
              TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
              ||' '
              ||TO_CHAR(LATE_START_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
              TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
              ||' '
              ||TO_CHAR(EARLY_END_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
              TOTAL_WORKING_HR
            INTO V_LATE_IN,
              V_EARLY_OUT,
              V_LATE_START_TIME,
              V_EARLY_END_TIME,
              V_TOTAL_WORKING_MIN
            FROM
              (SELECT S.LATE_IN,
                S.EARLY_OUT,
                (
                CASE
                  WHEN V_HALFDAY_PERIOD ='F'
                  THEN S.HALF_DAY_IN_TIME
                  ELSE S.START_TIME
                END ) +((1/1440)*NVL(S.LATE_IN,0)) AS LATE_START_TIME,
                (
                CASE
                  WHEN V_HALFDAY_PERIOD ='F'
                  THEN S.END_TIME
                  ELSE S.HALF_DAY_OUT_TIME
                END ) -((1/1440)*NVL(S.EARLY_OUT,0)) AS EARLY_END_TIME,
                S.TOTAL_WORKING_HR
              FROM HRIS_SHIFTS S
              WHERE S.SHIFT_ID =V_SHIFT_ID
              );
          ELSIF V_GRACE_PERIOD IS NOT NULL THEN
            SELECT LATE_IN,
              EARLY_OUT,
              TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
              ||' '
              ||TO_CHAR(LATE_START_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
              TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
              ||' '
              ||TO_CHAR(EARLY_END_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
              TOTAL_WORKING_HR
            INTO V_LATE_IN,
              V_EARLY_OUT,
              V_LATE_START_TIME,
              V_EARLY_END_TIME,
              V_TOTAL_WORKING_MIN
            FROM
              (SELECT S.LATE_IN,
                S.EARLY_OUT,
                (
                CASE
                  WHEN V_GRACE_PERIOD ='E'
                  THEN S.GRACE_START_TIME
                  ELSE S.START_TIME
                END) +((1/1440)*NVL(S.LATE_IN,0)) AS LATE_START_TIME,
                (
                CASE
                  WHEN V_GRACE_PERIOD ='E'
                  THEN S.END_TIME
                  ELSE S.GRACE_END_TIME
                END) -((1/1440)*NVL(S.EARLY_OUT,0)) AS EARLY_END_TIME,
                S.TOTAL_WORKING_HR
              FROM HRIS_SHIFTS S
              WHERE S.SHIFT_ID=V_SHIFT_ID
              );
          ELSE
            SELECT LATE_IN,
              EARLY_OUT,
              TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
              ||' '
              ||TO_CHAR(LATE_START_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
              TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
              ||' '
              ||TO_CHAR(EARLY_END_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
              TOTAL_WORKING_HR
            INTO V_LATE_IN,
              V_EARLY_OUT,
              V_LATE_START_TIME,
              V_EARLY_END_TIME,
              V_TOTAL_WORKING_MIN
            FROM
              (SELECT S.LATE_IN,
                S.EARLY_OUT,
                S.START_TIME+((1/1440)*NVL(S.LATE_IN,0))   AS LATE_START_TIME,
                S.END_TIME  -((1/1440)*NVL(S.EARLY_OUT,0)) AS EARLY_END_TIME,
                S.TOTAL_WORKING_HR
              FROM HRIS_SHIFTS S
              WHERE S.SHIFT_ID=V_SHIFT_ID
              );
          END IF;
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR(-20344, 'SHIFT WITH SHIFT_ID => '|| V_SHIFT_ID ||' NOT FOUND.');
        END;
        --   CHECK FOR ADJUSTED SHIFT
        BEGIN
          SELECT TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
            ||' '
            ||TO_CHAR(LATE_START_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM'),
            TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
            ||' '
            ||TO_CHAR(EARLY_END_TIME,'HH:MI AM'),'DD-MON-YYYY HH:MI AM')
          INTO V_LATE_START_TIME,
            V_EARLY_END_TIME
          FROM
            (SELECT SA.START_TIME + ((1/1440)*NVL(V_LATE_IN,0))  AS LATE_START_TIME,
              SA.END_TIME         -((1/1440)*NVL(V_EARLY_OUT,0)) AS EARLY_END_TIME
            FROM HRIS_SHIFT_ADJUSTMENT SA
            JOIN HRIS_EMPLOYEE_SHIFT_ADJUSTMENT ESA
            ON (SA.ADJUSTMENT_ID=ESA.ADJUSTMENT_ID)
            WHERE (TRUNC(employee.ATTENDANCE_DT) BETWEEN TRUNC(SA.ADJUSTMENT_START_DATE) AND TRUNC(SA.ADJUSTMENT_END_DATE) )
            AND ESA.EMPLOYEE_ID =employee.EMPLOYEE_ID
            );
        EXCEPTION
        WHEN NO_DATA_FOUND THEN
          DBMS_OUTPUT.PUT_LINE('NO ADJUSTMENT FOUND FOR EMPLOYEE =>'|| employee.EMPLOYEE_ID || 'ON THE DATE'||employee.ATTENDANCE_DT);
        END;
        --      END FOR CHECK FOR ADJUSTED_SHIFT
        IF(V_OVERALL_STATUS     ='DO') THEN
          V_OVERALL_STATUS     :='WD';
        ELSIF (V_OVERALL_STATUS ='HD') THEN
          V_OVERALL_STATUS     :='WH';
        ELSIF (V_OVERALL_STATUS ='LV') THEN
          NULL;
        ELSIF (V_OVERALL_STATUS ='TV') THEN
          NULL;
        ELSIF (V_OVERALL_STATUS ='TN') THEN
          NULL;
        ELSIF (V_OVERALL_STATUS = 'AB') THEN
          IF V_HALFDAY_FLAG     ='N' AND (V_HALFDAY_PERIOD IS NOT NULL OR V_GRACE_PERIOD IS NOT NULL) THEN
            V_OVERALL_STATUS   :='LP';
          ELSE
            V_OVERALL_STATUS :='PR';
          END IF;
        END IF;
        --
        IF V_OVERALL_STATUS ='PR' AND (V_LATE_START_TIME<V_IN_TIME) THEN
          V_LATE_STATUS    :='L';
        END IF;
        --
        IF V_OVERALL_STATUS ='PR' AND (V_EARLY_END_TIME>V_OUT_TIME) THEN
          IF (V_LATE_STATUS = 'L') THEN
            V_LATE_STATUS  :='B';
          ELSE
            V_LATE_STATUS :='E';
          END IF;
        END IF;
        --
        IF TRUNC(employee.ATTENDANCE_DT) != TRUNC(SYSDATE) THEN
          IF V_IN_TIME                   IS NOT NULL AND V_OUT_TIME IS NULL THEN
            IF V_LATE_STATUS              ='L' THEN
              V_LATE_STATUS              := 'Y';
            ELSE
              V_LATE_STATUS := 'X';
            END IF;
          END IF;
          --
          SELECT COUNT(*)
          INTO V_LATE_COUNT
          FROM HRIS_ATTENDANCE_DETAIL
          WHERE EMPLOYEE_ID = employee.EMPLOYEE_ID
          AND (ATTENDANCE_DT BETWEEN V_FROM_DATE AND employee.ATTENDANCE_DT )
          AND OVERALL_STATUS           IN ('PR','LA')
          AND LATE_STATUS              IN ('E','L','Y') ;
          IF V_LATE_STATUS             IN ('E','L','Y') THEN
            V_LATE_COUNT       := V_LATE_COUNT+1;
            IF V_LATE_COUNT    != 0 AND MOD(V_LATE_COUNT,4)=0 THEN
              V_OVERALL_STATUS := 'LA';
            END IF;
          END IF;
          --
          IF V_LATE_STATUS   ='B' AND V_OVERALL_STATUS='PR' THEN
            V_OVERALL_STATUS:='BA';
          END IF;
        END IF;
        --
        UPDATE HRIS_ATTENDANCE_DETAIL
        SET IN_TIME         = V_IN_TIME,
          OUT_TIME          =V_OUT_TIME,
          OVERALL_STATUS    = V_OVERALL_STATUS,
          LATE_STATUS       = V_LATE_STATUS,
          TOTAL_HOUR        = V_DIFF_IN_MIN,
          OT_MINUTES        = (V_DIFF_IN_MIN - V_TOTAL_WORKING_MIN),
          IN_REMARKS  = (select IN_REMARKS from HRIS_ATTENDANCE_REQUEST
                                    where IN_REMARKS is not null
                                            and STATUS='AP'
                            and employee_id=employee.EMPLOYEE_ID
                            and ATTENDANCE_DT=TO_DATE (employee.ATTENDANCE_DT, 'DD-MON-YY')
                        AND ROWNUM=1),
          OUT_REMARKS = (select OUT_REMARKS from HRIS_ATTENDANCE_REQUEST
                            where OUT_REMARKS is not null
                            and STATUS='AP'
                            and employee_id=employee.EMPLOYEE_ID
                            and ATTENDANCE_DT=TO_DATE (employee.ATTENDANCE_DT, 'DD-MON-YY')
                             AND ROWNUM=1)
        WHERE ATTENDANCE_DT = TO_DATE (employee.ATTENDANCE_DT, 'DD-MON-YY')
        AND EMPLOYEE_ID     = employee.EMPLOYEE_ID;
        --
      END IF ;
      --
      DECLARE
        V_ID HRIS_EMPLOYEE_WORK_DAYOFF.ID%TYPE;
      BEGIN
        SELECT ID
        INTO V_ID
        FROM HRIS_EMPLOYEE_WORK_DAYOFF
        WHERE EMPLOYEE_ID = employee.EMPLOYEE_ID
        AND TO_DATE       = TRUNC(employee.ATTENDANCE_DT)
        AND STATUS        ='AP'
        AND ROWNUM        =1;
        --
        HRIS_WOD_REWARD(V_ID);
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT('NO WORK ON DAYOFF FOUND');
      END;
      -- check if woh is present for every employee
      DECLARE
        V_ID HRIS_EMPLOYEE_WORK_HOLIDAY.ID%TYPE;
      BEGIN
        SELECT ID
        INTO V_ID
        FROM HRIS_EMPLOYEE_WORK_HOLIDAY
        WHERE EMPLOYEE_ID =employee.EMPLOYEE_ID
        AND TO_DATE       = TRUNC(employee.ATTENDANCE_DT)
        AND STATUS        = 'AP'
        AND ROWNUM        =1;
        --
        HRIS_WOH_REWARD(V_ID);
      EXCEPTION
      WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT('NO WORK ON DAYOFF FOUND');
      END;

 -- added from trainign assign start V_dayOffTravelAutoAddLeave
    SELECT VALUE INTO V_dayOffTrainingAutoAddLeave FROM HRIS_SETTINGS WHERE NAME = 'reatt.dayOffTrainingAutoSubstituteLeaveAddition';

    IF (V_dayOffTrainingAutoAddLeave = '1')
    then
        BEGIN
            v_training_id:=NULL;
                    SELECT
                        ta.training_id
                    INTO
                        v_training_id
                    FROM
                        hris_employee_training_assign ta
                        INNER JOIN hris_training_master_setup t ON ta.training_id = t.training_id
                    WHERE
                            ta.employee_id = employee.employee_id
                        AND
                            ta.status = 'E'
                        AND
                            t.status = 'E'    
                        AND
                            p_from_attendance_dt + i BETWEEN t.start_date AND t.end_date and ROWNUM=1;
                             EXCEPTION
                        WHEN no_data_found THEN
                            dbms_output.put('NO training for the day ON DAYOFF FOUND');
        
        
        
                             IF v_training_id IS NOT NULL
                             THEN 
                             HRIS_TRAINING_LEAVE_REWARD(v_employee_id,v_training_id);
                             END IF;
            END;      
        END IF;
    -- added from trainign assign 
    
    -- added from travel assign start
    -- added from trainign assign start 
    SELECT VALUE INTO V_dayOffTravelAutoAddLeave FROM HRIS_SETTINGS WHERE NAME = 'reatt.dayOffTravelAutoSubstituteLeaveAddition';

    IF (V_dayOffTravelAutoAddLeave = '1')
    then
        BEGIN
        v_travel_id:=NULL;
        begin
                SELECT
                    tr.travel_id
                INTO
                    v_travel_id
                FROM
                    HRIS_EMPLOYEE_TRAVEL_REQUEST tr
                WHERE
                        tr.employee_id = employee.employee_id
                    AND
                        tr.status = 'AP'
                    AND
                        tr.requested_type = 'ad'
                    AND
                        p_from_attendance_dt + i BETWEEN tr.from_date AND tr.TO_DATE AND ROWNUM=1;
                         EXCEPTION
                    WHEN no_data_found THEN
                        dbms_output.put('NO travel for the day found');
                        WHEN too_many_rows THEN
        dbms_output.put('too many travel id');
        end;
    
                         IF v_travel_id IS NOT NULL
                         THEN
                         HRIS_TRAVEL_LEAVE_REWARD(v_travel_id);
                         END IF;
    
            END;
        END IF;
    -- added from travel assign
    

       --special attendance start
    BEGIN
    SELECT SP_ID, DISPLAY_IN_OUT INTO V_SP_ID, V_DISPLAY_IN_OUT FROM HRIS_SPECIAL_ATTENDANCE_ASSIGN WHERE 
    EMPLOYEE_ID = EMPLOYEE.EMPLOYEE_ID AND ATTENDANCE_DATE = EMPLOYEE.ATTENDANCE_DT AND ROWNUM = 1;
    UPDATE HRIS_ATTENDANCE_DETAIL SET OVERALL_STATUS = 'PR', SP_ID = V_SP_ID WHERE EMPLOYEE_ID = EMPLOYEE.EMPLOYEE_ID AND 
    ATTENDANCE_DT = EMPLOYEE.ATTENDANCE_DT;
    IF V_DISPLAY_IN_OUT = 'Y' THEN
    SELECT START_TIME, END_TIME INTO V_SHIFT_START_TIME, V_SHIFT_END_TIME FROM HRIS_SHIFTS WHERE SHIFT_ID = V_SHIFT_ID;
    UPDATE HRIS_ATTENDANCE_DETAIL SET IN_TIME = TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
    || ' ' || TO_CHAR(V_SHIFT_START_TIME, 'HH:MI AM'), 'DD-MON-YYYY HH:MI AM'), 
    OUT_TIME = TO_DATE(TO_CHAR(employee.ATTENDANCE_DT,'DD-MON-YYYY')
    || ' ' || TO_CHAR(V_SHIFT_END_TIME, 'HH:MI AM'), 'DD-MON-YYYY HH:MI AM') WHERE 
    EMPLOYEE_ID = EMPLOYEE.EMPLOYEE_ID AND ATTENDANCE_DT = EMPLOYEE.ATTENDANCE_DT;
    END IF;
    EXCEPTION WHEN NO_DATA_FOUND THEN
    NULL;
    END;
    --special attendance end


    END LOOP;
  END LOOP;
END;