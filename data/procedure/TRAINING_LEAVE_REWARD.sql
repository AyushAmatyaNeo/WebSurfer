create or replace PROCEDURE HRIS_TRAINING_LEAVE_REWARD(p_training_request_id NUMBER ) AS

    v_employee_id           NUMBER;
    v_shift_id              NUMBER;
    v_training_start_date   DATE;
    v_training_end_date     DATE;
    v_duration              NUMBER;
    v_training_type         hris_training_master_setup.training_type%TYPE;
    v_daily_training_hour   hris_training_master_setup.daily_training_hour%TYPE;
    v_is_present            NUMBER;
    v_weekday1              hris_shifts.weekday1%TYPE;
    v_weekday2              hris_shifts.weekday2%TYPE;
    v_weekday3              hris_shifts.weekday3%TYPE;
    v_weekday4              hris_shifts.weekday4%TYPE;
    v_weekday5              hris_shifts.weekday5%TYPE;
    v_weekday6              hris_shifts.weekday6%TYPE;
    v_weekday7              hris_shifts.weekday7%TYPE;
    v_dayoff                VARCHAR2(1 BYTE);
    v_holiday_count         NUMBER;
    v_holiday               CHAR(1 BYTE);
    v_sub_days              NUMBER := 0;
    v_sub_leave_id          NUMBER;
    v_increament            NUMBER;
    v_status                char(2 byte);
    v_assigned_balance      NUMBER;
BEGIN
    dbms_output.put_line('LEAVE ADDITION');

-- TO SELECT TRAINING DEATILS
    SELECT
        employee_id,
        status,
        start_date,
        end_date,
        duration,
        training_type,
        CASE
            WHEN daily_training_hour < 2  THEN 0
            WHEN
                daily_training_hour >= 2
            AND
                daily_training_hour < 4
            THEN 0.5
            WHEN daily_training_hour >= 4 THEN 1
        END
    INTO
        v_employee_id,v_status,v_training_start_date,v_training_end_date,v_duration,v_training_type,v_increament
     FROM
        HRIS_EMPLOYEE_TRAINING_REQUEST
    WHERE
        REQUEST_ID = p_training_request_id;

    IF
        ( v_training_type = 'CC' )
    THEN
        FOR i IN 0..v_duration - 1 LOOP
            dbms_output.put_line(v_training_start_date + i);


                BEGIN
                    SELECT
                        hs.shift_id,
                        weekday1,
                        weekday2,
                        weekday3,
                        weekday4,
                        weekday5,
                        weekday6,
                        weekday7
                    INTO
                        v_shift_id,v_weekday1,v_weekday2,v_weekday3,v_weekday4,v_weekday5,v_weekday6,v_weekday7
                    FROM
                        hris_employee_shift_roaster es,
                        hris_shifts hs
                    WHERE
                            1 = 1
                        AND
                            es.employee_id = v_employee_id
                        AND
                            trunc(es.for_date) = v_training_start_date + i
                        AND
                            hs.status = 'E'
                        AND
                            es.shift_id = hs.shift_id;

                EXCEPTION
                    WHEN no_data_found THEN
                        BEGIN
                            SELECT
                                hs.shift_id,
                                weekday1,
                                weekday2,
                                weekday3,
                                weekday4,
                                weekday5,
                                weekday6,
                                weekday7
                            INTO
                                v_shift_id,v_weekday1,v_weekday2,v_weekday3,v_weekday4,v_weekday5,v_weekday6,v_weekday7
                            FROM
                                (
                                    SELECT
                                        *
                                    FROM
                                        (
                                            SELECT
                                                *
                                            FROM
                                                hris_employee_shift_assign
                                            WHERE
                                                    employee_id = v_employee_id
                                                AND (
                                                        trunc(v_training_start_date + i) >= start_date
                                                    AND
                                                        trunc(v_training_start_date + i) <=
                                                            CASE
                                                                WHEN end_date IS NOT NULL THEN end_date
                                                                ELSE trunc(v_training_start_date + i)
                                                            END
                                                )
                                            ORDER BY start_date DESC,end_date ASC
                                        )
                                    WHERE
                                        ROWNUM = 1
                                ) es,
                                hris_shifts hs
                            WHERE
                                es.shift_id = hs.shift_id;

                        EXCEPTION
                            WHEN no_data_found THEN
                                BEGIN
                                    SELECT
                                        shift_id,
                                        weekday1,
                                        weekday2,
                                        weekday3,
                                        weekday4,
                                        weekday5,
                                        weekday6,
                                        weekday7
                                    INTO
                                        v_shift_id,v_weekday1,v_weekday2,v_weekday3,v_weekday4,v_weekday5,v_weekday6,v_weekday7
                                    FROM
                                        hris_shifts
                                    WHERE
                                            v_training_start_date + i BETWEEN start_date AND end_date
                                        AND
                                            default_shift = 'Y'
                                        AND
                                            status = 'E'
                                        AND
                                            ROWNUM = 1;

                                EXCEPTION
                                    WHEN no_data_found THEN
                                        raise_application_error(-20344,'No default and normal shift defined for this time period');
                                END;
                        END;
                END;

                dbms_output.put_line(v_shift_id);
                v_dayoff := 'N';
                BEGIN
                    IF
                        ( TO_CHAR(v_training_start_date + i,'D') = '1' )
                    THEN
                        IF
                            v_weekday1 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    ELSIF ( TO_CHAR(v_training_start_date + i,'D') = '2' ) THEN
                        IF
                            v_weekday2 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    ELSIF ( TO_CHAR(v_training_start_date + i,'D') = '3' ) THEN
                        IF
                            v_weekday3 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    ELSIF ( TO_CHAR(v_training_start_date + i,'D') = '4' ) THEN
                        IF
                            v_weekday4 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    ELSIF ( TO_CHAR(v_training_start_date + i,'D') = '5' ) THEN
                        IF
                            v_weekday5 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    ELSIF ( TO_CHAR(v_training_start_date + i,'D') = '6' ) THEN
                        IF
                            v_weekday6 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    ELSIF ( TO_CHAR(v_training_start_date + i,'D') = '7' ) THEN
                        IF
                            v_weekday7 = 'DAY_OFF'
                        THEN
                            v_dayoff := 'Y';
                        END IF;
                    END IF;
                END;

                dbms_output.put_line('DAYOFF ' || v_dayoff);
                IF
                    ( v_dayoff = 'Y' )
                THEN
                    v_sub_days := v_sub_days + v_increament;
                ELSE
                    BEGIN
                        SELECT
                            COUNT(*)
                        INTO
                            v_holiday_count
                        FROM
                            hris_holiday_master_setup hs
                            LEFT JOIN hris_employee_holiday eha ON (
                                hs.holiday_id = eha.holiday_id
                            )
                        WHERE
                                eha.employee_id = 700280
                            AND
                                trunc(SYSDATE) BETWEEN start_date AND end_date;

                        IF
                            ( v_holiday_count > 0 )
                        THEN
                            dbms_output.put_line('HOLIDAY');
                            v_sub_days := v_sub_days + v_increament;
                        END IF;

                    END;
                END IF;



            dbms_output.put_line('-----------');
        END LOOP;

        dbms_output.put_line('SUBdAYS ' || v_sub_days);
        BEGIN
            SELECT
                leave_id
            INTO
                v_sub_leave_id
            FROM
                hris_leave_master_setup
            WHERE
                is_substitute = 'Y';

            DELETE FROM hris_employee_leave_addition WHERE
                    employee_id = v_employee_id
                AND
                    leave_id = v_sub_leave_id
                AND
                    training_id = p_training_request_id;


                    BEGIN
            SELECT BALANCE
            INTO v_assigned_balance
            FROM HRIS_EMPLOYEE_LEAVE_ASSIGN
            WHERE EMPLOYEE_ID=v_employee_id
            AND LEAVE_ID     = v_sub_leave_id;
          EXCEPTION
          WHEN no_data_found THEN
            INSERT
            INTO HRIS_EMPLOYEE_LEAVE_ASSIGN
              (
                EMPLOYEE_ID,
                LEAVE_ID,
                PREVIOUS_YEAR_BAL,
                TOTAL_DAYS,
                BALANCE,
                CREATED_DT,
                CREATED_BY
              )
              VALUES
              (
                v_employee_id,
                v_sub_leave_id,
                0,
                0,
                0,
                TRUNC(SYSDATE),
                v_employee_id
              );
        END;


            IF
                ( v_sub_days > 0 and v_status='AP' )
            THEN
                INSERT INTO hris_employee_leave_addition VALUES (
                    v_employee_id,
                    v_sub_leave_id,
                    v_sub_days,
                    'WOT REWARD',
                    trunc(SYSDATE),
                    NULL,
                    NULL,
                    p_training_request_id
                );

            END IF;

        END;

    END IF;

END;