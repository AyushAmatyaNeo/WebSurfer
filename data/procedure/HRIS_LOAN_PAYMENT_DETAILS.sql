create or replace PROCEDURE HRIS_LOAN_PAYMENT_DETAILS(
  P_LOAN_REQUEST_ID     HRIS_LOAN_PAYMENT_DETAIL.LOAN_REQUEST_ID%TYPE:=null,
  P_PAYMENT_ID     HRIS_LOAN_PAYMENT_DETAIL.PAYMENT_ID%TYPE:=null
) AS
    V_REPAYMENT_MONTHS                NUMBER;
    V_AMOUNT                           NUMBER;
    V_CHECK_AMOUNT                      NUMBER;
    V_INTEREST_RATE                       NUMBER;
    V_REQUESTED_DATE                 DATE;             
    V_REQUESTED_YEAR                  NUMBER(7);     
    V_INTEREST_AMOUNT           FLOAT(126);    
    V_PRINCIPLE_AMOUNT          FLOAT(126);    
    V_DAYS                      NUMBER(4);     
    V_REQUESTED_MONTH                VARCHAR2(100); 
    V_REQUESTED_AMOUNT                  FLOAT(126);     
    V_NO_OF_DAYS                 NUMBER(4);
    V_FROM_DATE                     DATE;
    V_TO_DATE                     DATE;
    V_MONTH_ID                    NUMBER(4);
    V_ROW_COUNT                    NUMBER(4);
    V_SNO1                          NUMBER(4);
    V_SNO2                          NUMBER(4);
    V_PAID_FLAG                     CHAR(1);
    --V_CALENDAR_TYPE                 CHAR(1);

    BEGIN

    --SELECT VALUE INTO V_CALENDAR_TYPE FROM HRIS_PREFERENCES WHERE KEY = 'CALENDAR_VIEW';

    SELECT 
    REPAYMENT_MONTHS, REQUESTED_AMOUNT, REQUESTED_AMOUNT/REPAYMENT_MONTHS,
    REQUESTED_DATE, INTEREST_RATE
    INTO 
    V_REPAYMENT_MONTHS, V_REQUESTED_AMOUNT, V_AMOUNT, 
    V_REQUESTED_DATE, V_INTEREST_RATE 
    FROM HRIS_EMPLOYEE_LOAN_REQUEST HELR
    JOIN HRIS_LOAN_MASTER_SETUP HLMS ON HLMS.LOAN_ID = HELR.LOAN_ID
    WHERE 
    LOAN_REQUEST_ID = P_LOAN_REQUEST_ID;

    SELECT V_REQUESTED_DATE, 
    LAST_DAY(ADD_MONTHS(V_REQUESTED_DATE,0))
    INTO V_FROM_DATE, V_TO_DATE FROM DUAL;

    SELECT (V_TO_DATE - V_FROM_DATE) INTO V_NO_OF_DAYS FROM DUAL;

    --SELECT MONTH_ID, TO_DATE, (TO_DATE - TO_DATE(V_REQUESTED_DATE)) 
    --INTO 
    --V_MONTH_ID, V_TO_DATE, V_NO_OF_DAYS
    --FROM HRIS_MONTH_CODE WHERE V_REQUESTED_DATE BETWEEN FROM_DATE AND TO_DATE;

    IF P_PAYMENT_ID IS null
    THEN
    SELECT COUNT(*) INTO V_ROW_COUNT FROM HRIS_LOAN_PAYMENT_DETAIL WHERE 
    LOAN_REQUEST_ID = P_LOAN_REQUEST_ID AND PAYMENT_ID = 1;
    IF V_ROW_COUNT = 0
    THEN

    INSERT INTO HRIS_LOAN_PAYMENT_DETAIL (
    PAYMENT_ID, 
    LOAN_REQUEST_ID, 
    SNO, 
    FROM_DATE, 
    TO_DATE, 
    AMOUNT,  
    MONTH_NO,
    INTEREST_AMOUNT,
    PRINCIPLE_AMOUNT,
    DAYS,
    VOUCHER_NO,
    SHEET_NO,
    REMARKS,
    CREATED_DT,
    CREATED_BY,
    STATUS
    )
    VALUES(
    (SELECT NVL(MAX(PAYMENT_ID)+1, 1) FROM HRIS_LOAN_PAYMENT_DETAIL),
    P_LOAN_REQUEST_ID,
    1,
    V_REQUESTED_DATE,
    V_TO_DATE,
    TRUNC(V_AMOUNT, 2),
    --V_MONTH_ID,
    null,
    TRUNC((V_REQUESTED_AMOUNT*V_INTEREST_RATE/100)/365, 2)*V_NO_OF_DAYS,
    TRUNC(V_REQUESTED_AMOUNT, 2),
    V_NO_OF_DAYS,
    null,
    null,
    null,
    TRUNC(SYSDATE),
    null,
    'E'
    );

    FOR COUNTER IN 2 .. V_REPAYMENT_MONTHS  LOOP 

    --V_MONTH_ID := V_MONTH_ID + 1;

    BEGIN

    SELECT 
    LAST_DAY(ADD_MONTHS(V_REQUESTED_DATE,+(COUNTER-1)))
    INTO V_TO_DATE FROM DUAL;

    SELECT trunc(V_TO_DATE,'month')
    INTO V_FROM_DATE FROM DUAL;

    SELECT (V_TO_DATE - V_FROM_DATE) INTO V_NO_OF_DAYS FROM DUAL;

    --SELECT FROM_DATE, TO_DATE, (TO_DATE - FROM_DATE) 
    --INTO 
    --V_FROM_DATE, V_TO_DATE, V_NO_OF_DAYS
    --FROM HRIS_MONTH_CODE WHERE MONTH_ID = V_MONTH_ID;
    EXCEPTION
            WHEN no_data_found THEN
            V_FROM_DATE:=null;  
             V_TO_DATE:=null;  
             V_NO_OF_DAYS:=null;
    END;


    INSERT INTO HRIS_LOAN_PAYMENT_DETAIL (
    PAYMENT_ID, 
    LOAN_REQUEST_ID, 
    SNO, 
    FROM_DATE, 
    TO_DATE, 
    AMOUNT,  
    MONTH_NO,
    INTEREST_AMOUNT,
    PRINCIPLE_AMOUNT,
    DAYS,
    VOUCHER_NO,
    SHEET_NO,
    REMARKS,
    CREATED_DT,
    CREATED_BY,
    STATUS
    )
    VALUES(
    (SELECT NVL(MAX(PAYMENT_ID)+1, 1) FROM HRIS_LOAN_PAYMENT_DETAIL),
    P_LOAN_REQUEST_ID,
    COUNTER,
    V_FROM_DATE,
    V_TO_DATE,
    TRUNC(V_AMOUNT, 2),
    --V_MONTH_ID,
    null,
    TRUNC((V_REQUESTED_AMOUNT*V_INTEREST_RATE/100)/365, 2)*V_NO_OF_DAYS,
    TRUNC((SELECT PRINCIPLE_AMOUNT - AMOUNT FROM HRIS_LOAN_PAYMENT_DETAIL WHERE PAYMENT_ID IN 
    (SELECT MAX(PAYMENT_ID) FROM HRIS_LOAN_PAYMENT_DETAIL)), 2),
    V_NO_OF_DAYS,
    null,
    null,
    null,
    TRUNC(SYSDATE),
    null,
    'E'
    );

    END LOOP;
    END IF;

    ELSE
    SELECT AMOUNT INTO V_CHECK_AMOUNT FROM HRIS_LOAN_PAYMENT_DETAIL
    WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND PAYMENT_ID = P_PAYMENT_ID;
    SELECT PAID_FLAG INTO V_PAID_FLAG FROM HRIS_LOAN_PAYMENT_DETAIL WHERE 
    PAYMENT_ID = P_PAYMENT_ID;
    IF V_PAID_FLAG = 'N'
    THEN
    IF V_CHECK_AMOUNT <> 0
    THEN
    BEGIN
    SELECT FROM_DATE, TO_DATE, (TO_DATE - FROM_DATE) 
    INTO 
    V_FROM_DATE, V_TO_DATE, V_NO_OF_DAYS
    FROM HRIS_MONTH_CODE WHERE MONTH_ID = V_MONTH_ID;
    EXCEPTION
            WHEN no_data_found THEN
            V_FROM_DATE:=null;  
             V_TO_DATE:=null;  
             V_NO_OF_DAYS:=null;
    END;

    UPDATE HRIS_LOAN_PAYMENT_DETAIL SET AMOUNT = 0 WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND PAYMENT_ID = P_PAYMENT_ID;

    SELECT SNO+1 INTO V_SNO1 FROM HRIS_LOAN_PAYMENT_DETAIL WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND PAYMENT_ID = P_PAYMENT_ID;

    SELECT MAX(SNO) INTO V_SNO2 FROM HRIS_LOAN_PAYMENT_DETAIL WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID;

    FOR COUNTER IN V_SNO1 .. V_SNO2 LOOP

    UPDATE HRIS_LOAN_PAYMENT_DETAIL SET PRINCIPLE_AMOUNT = 
    TRUNC((SELECT PRINCIPLE_AMOUNT - AMOUNT FROM 
    HRIS_LOAN_PAYMENT_DETAIL WHERE SNO = COUNTER-1
    AND LOAN_REQUEST_ID = P_LOAN_REQUEST_ID), 2) 
    WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND SNO = COUNTER;

    END LOOP;

    SELECT FROM_DATE, TO_DATE
    INTO V_FROM_DATE, V_TO_DATE FROM HRIS_LOAN_PAYMENT_DETAIL
    WHERE 
    SNO = (SELECT MAX(SNO) FROM HRIS_LOAN_PAYMENT_DETAIL
    WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID);

    SELECT 
    LAST_DAY(ADD_MONTHS(V_FROM_DATE,+1))
    INTO V_TO_DATE FROM DUAL;

    SELECT trunc(V_TO_DATE,'month')
    INTO V_FROM_DATE FROM DUAL;

    SELECT (V_TO_DATE - V_FROM_DATE) INTO V_NO_OF_DAYS FROM DUAL;

    INSERT INTO HRIS_LOAN_PAYMENT_DETAIL (
    PAYMENT_ID, 
    LOAN_REQUEST_ID, 
    SNO, 
    FROM_DATE, 
    TO_DATE, 
    AMOUNT,  
    MONTH_NO,
    INTEREST_AMOUNT,
    PRINCIPLE_AMOUNT,
    DAYS,
    VOUCHER_NO,
    SHEET_NO,
    REMARKS,
    CREATED_DT,
    CREATED_BY,
    STATUS
    )
    VALUES(
    (SELECT NVL(MAX(PAYMENT_ID)+1, 1) FROM HRIS_LOAN_PAYMENT_DETAIL),
    P_LOAN_REQUEST_ID,
    (SELECT MAX(SNO)+1 FROM HRIS_LOAN_PAYMENT_DETAIL WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID),
    V_FROM_DATE,
    V_TO_DATE,
    TRUNC(V_AMOUNT, 2),
    null,
    --(SELECT MONTH_NO+1 FROM HRIS_LOAN_PAYMENT_DETAIL WHERE SNO = V_SNO2 AND 
    --LOAN_REQUEST_ID = P_LOAN_REQUEST_ID),
    TRUNC((V_REQUESTED_AMOUNT*V_INTEREST_RATE/100)/365, 2)*V_NO_OF_DAYS,
    TRUNC((SELECT PRINCIPLE_AMOUNT - AMOUNT FROM HRIS_LOAN_PAYMENT_DETAIL WHERE PAYMENT_ID IN 
    (SELECT MAX(PAYMENT_ID) FROM HRIS_LOAN_PAYMENT_DETAIL)), 2),
    V_NO_OF_DAYS,
    null,
    null,
    null,
    TRUNC(SYSDATE),
    null,
    'E'
    );

    ELSE
    UPDATE HRIS_LOAN_PAYMENT_DETAIL SET AMOUNT = TRUNC(V_AMOUNT, 2)
    WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND PAYMENT_ID = P_PAYMENT_ID;

    SELECT SNO+1 INTO V_SNO1 FROM HRIS_LOAN_PAYMENT_DETAIL WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND PAYMENT_ID = P_PAYMENT_ID;

    SELECT MAX(SNO)-1 INTO V_SNO2 FROM HRIS_LOAN_PAYMENT_DETAIL WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID;

    DELETE FROM HRIS_LOAN_PAYMENT_DETAIL WHERE SNO = V_SNO2+1 AND LOAN_REQUEST_ID = P_LOAN_REQUEST_ID;

    FOR COUNTER IN V_SNO1 .. V_SNO2 LOOP

    UPDATE HRIS_LOAN_PAYMENT_DETAIL SET PRINCIPLE_AMOUNT = 
    TRUNC((SELECT PRINCIPLE_AMOUNT - AMOUNT FROM 
    HRIS_LOAN_PAYMENT_DETAIL WHERE SNO = COUNTER-1
    AND LOAN_REQUEST_ID = P_LOAN_REQUEST_ID), 2) 
    WHERE LOAN_REQUEST_ID = P_LOAN_REQUEST_ID
    AND SNO = COUNTER; 

    END LOOP;

    END IF;
    END IF;
    END IF;
    END;