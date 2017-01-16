
-- FIRST LEVEL AUDIT TRIAL
ALTER TABLE HR_BRANCHES ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_BRANCHES ADD CONSTRAINT BRA_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_BRANCHES ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_BRANCHES ADD CONSTRAINT BRA_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 



ALTER TABLE HR_COMPANY ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_COMPANY ADD CONSTRAINT COM_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_COMPANY ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_COMPANY ADD CONSTRAINT COM_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_DEPARTMENTS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_DEPARTMENTS ADD CONSTRAINT DEP_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_DEPARTMENTS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_DEPARTMENTS ADD CONSTRAINT DEP_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 



ALTER TABLE HR_DESIGNATIONS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_DESIGNATIONS ADD CONSTRAINT DES_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_DESIGNATIONS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_DESIGNATIONS ADD CONSTRAINT DES_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_POSITIONS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_POSITIONS ADD CONSTRAINT POS_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_POSITIONS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_POSITIONS ADD CONSTRAINT POS_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_SERVICE_TYPES ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_SERVICE_TYPES ADD CONSTRAINT SER_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_SERVICE_TYPES ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_SERVICE_TYPES ADD CONSTRAINT SER_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_RECOMMENDER_APPROVER ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_RECOMMENDER_APPROVER ADD CONSTRAINT RECOMMAPPR_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_RECOMMENDER_APPROVER ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_RECOMMENDER_APPROVER ADD CONSTRAINT RECOMMAPPR_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_ACADEMIC_UNIVESITY ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_UNIVESITY ADD CONSTRAINT AUNI_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_ACADEMIC_UNIVESITY ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_UNIVESITY ADD CONSTRAINT AUNI_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_ACADEMIC_PROGRAMS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_PROGRAMS ADD CONSTRAINT APRO_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_ACADEMIC_PROGRAMS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_PROGRAMS ADD CONSTRAINT APRO_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_ACADEMIC_COURSES ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_COURSES ADD CONSTRAINT ACOUR_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_ACADEMIC_COURSES ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_COURSES ADD CONSTRAINT ACOUR_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_ACADEMIC_DEGREES ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_DEGREES ADD CONSTRAINT ADEGRE_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_ACADEMIC_DEGREES ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_ACADEMIC_DEGREES ADD CONSTRAINT ADEGRE_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_LEAVE_MASTER_SETUP ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_LEAVE_MASTER_SETUP ADD CONSTRAINT LEAVE_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_LEAVE_MASTER_SETUP ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_LEAVE_MASTER_SETUP ADD CONSTRAINT ALEAVE_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_EMPLOYEE_LEAVE_ASSIGN ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_EMPLOYEE_LEAVE_ASSIGN ADD CONSTRAINT EMPLEAVE_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_EMPLOYEE_LEAVE_ASSIGN ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_EMPLOYEE_LEAVE_ASSIGN ADD CONSTRAINT EMPLEAVE_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_HOLIDAY_MASTER_SETUP ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_HOLIDAY_MASTER_SETUP ADD CONSTRAINT HOLI_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_HOLIDAY_MASTER_SETUP ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_HOLIDAY_MASTER_SETUP ADD CONSTRAINT HOLI_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_SHIFTS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_SHIFTS ADD CONSTRAINT SHIFTS_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_SHIFTS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_SHIFTS ADD CONSTRAINT SHIFTS_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_EMPLOYEE_SHIFT_ASSIGN ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_EMPLOYEE_SHIFT_ASSIGN ADD CONSTRAINT EMPSHIFT_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_EMPLOYEE_SHIFT_ASSIGN ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_EMPLOYEE_SHIFT_ASSIGN ADD CONSTRAINT EMPSHIFT_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_JOB_HISTORY ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_JOB_HISTORY ADD CONSTRAINT JOBHIS_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_JOB_HISTORY ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_JOB_HISTORY ADD CONSTRAINT JOBHIS_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_JOB_HISTORY ADD CREATED_DT DATE

ALTER TABLE HR_JOB_HISTORY ADD MODIFIED_DT DATE


ALTER TABLE HR_ROLES ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_ROLES ADD CONSTRAINT ROLES_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_ROLES ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_ROLES ADD CONSTRAINT ROLES_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_USERS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_USERS ADD CONSTRAINT USERS_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_USERS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_USERS ADD CONSTRAINT USERS_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


ALTER TABLE HR_MENUS ADD CREATED_BY NUMBER(6,0)

ALTER TABLE HR_MENUS ADD CONSTRAINT MENUS_EMP_ID_FK FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 

ALTER TABLE HR_MENUS ADD MODIFIED_BY NUMBER(6,0)

ALTER TABLE HR_MENUS ADD CONSTRAINT MENUS_EMP_ID_FK2 FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID) 


-- END OF FIRST LEVEL AUDIT TRIAL

-- PROFILE PICTURE FK SET

ALTER TABLE HR_EMPLOYEES 
ADD CONSTRAINT FK_EMP_FILE_EMP_PRO_PIC_ID
FOREIGN KEY(PROFILE_PICTURE_ID) REFERENCES HR_EMPLOYEE_FILE(FILE_CODE);

UPDATE HR_EMPLOYEES SET PROFILE_PICTURE_ID=3;

-- END OF PICTURE FK SET

-- 
SELECT E.* FROM HR_EMPLOYEES E
        JOIN HR_EMPLOYEE_SHIFT_ASSIGN ESA ON (E.EMPLOYEE_ID=ESA.EMPLOYEE_ID) JOIN HR_SHIFTS S ON (ESA.SHIFT_ID=S.SHIFT_ID) 
        WHERE  
        (CASE
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'SUN' THEN ( CASE WHEN (S.WEEKDAY1 = 'DAY_OFF') THEN 0 ELSE 1 END )
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'MON' THEN ( CASE WHEN (S.WEEKDAY2 = 'DAY_OFF') THEN 0 ELSE 1 END )
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'TUE' THEN ( CASE WHEN (S.WEEKDAY3 = 'DAY_OFF') THEN 0 ELSE 1 END )
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'WED' THEN ( CASE WHEN (S.WEEKDAY4 = 'DAY_OFF') THEN 0 ELSE 1 END )
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'THU' THEN ( CASE WHEN (S.WEEKDAY5 = 'DAY_OFF') THEN 0 ELSE 1 END )
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'FRI' THEN ( CASE WHEN (S.WEEKDAY6 = 'DAY_OFF') THEN 0 ELSE 1 END )
        WHEN  trim(TO_CHAR(SYSDATE, 'DY')) = 'SAT' THEN ( CASE WHEN (S.WEEKDAY7 = 'DAY_OFF') THEN 0 ELSE 1 END )
        END)=1 AND E.STATUS='E' AND E.RETIRED_FLAG='N' AND E.JOIN_DATE <= SYSDATE; 
-- 
--  SALARY DETAIL TABLE ADDED
CREATE TABLE HR_SALARY_DETAIL
(
  EMPLOYEE_ID NUMBER(6,0) NOT NULL,  
  OLD_AMOUNT NUMBER(9,0) NOT NULL,
  NEW_AMOUNT NUMBER(9,0) NOT NULL,
  EFFECTIVE_DATE DATE,
  JOB_HISTORY_ID NUMBER(6,0),
  CREATED_BY NUMBER(6,0) NOT NULL,
  CREATED_DT DATE NOT NULL,
  MODIFIED_BY NUMBER(6,0),
  MODIFIED_DT DATE,
  STATUS CHAR(1 BYTE) NOT NULL CHECK(STATUS IN ('E','D'))
)


ALTER TABLE HR_SALARY_DETAIL 
ADD CONSTRAINT FK_SAL_DETL_EMP_EMPLOYEE_ID 
FOREIGN KEY(EMPLOYEE_ID) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);


ALTER TABLE HR_SALARY_DETAIL
ADD CONSTRAINT FK_SAL_DET_EMP_CREATED_BY
FOREIGN KEY(CREATED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_SALARY_DETAIL
ADD CONSTRAINT FK_SAL_DET_EMP_MODIFIED_BY
FOREIGN KEY(MODIFIED_BY) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_SALARY_DETAIL
ADD CONSTRAINT FK_SAL_DET_JOB_HIS_J_H_ID
FOREIGN KEY (JOB_HISTORY_ID) REFERENCES HR_JOB_HISTORY(JOB_HISTORY_ID);
-- 
-- LOAN MASTER SETUP QUERY START
CREATE TABLE HR_LOAN_MASTER_SETUP(
  LOAN_ID           NUMBER(6,0) NOT NULL,
  LOAN_CODE         VARCHAR2(15 BYTE) NOT NULL,
  LOAN_NAME         VARCHAR2(255 BYTE) NOT NULL,
  MIN_AMOUNT        FLOAT(126) NOT NULL,
  MAX_AMOUNT        FLOAT(126) NOT NULL,
  INTEREST_RATE     FLOAT(126),
  REPAYMENT_AMOUNT  FLOAT(126),
  REPAYMENT_PERIOD  NUMBER(6,0),
  DEDUCT_ON_SALARY  CHAR(1 BYTE) NOT NULL,
  REMARKS           VARCHAR2(255 BYTE),
  STATUS            CHAR(1 BYTE) DEFAULT 'E' NOT NULL,
  CREATED_DATE      DATE DEFAULT SYSDATE NOT NULL,
  CREATED_BY        NUMBER(6,0) NOT NULL,
  MODIFIED_DATE     DATE,
  MODIFIED_BY       NUMBER(6,0),
  CHECK ( STATUS IN ('D', 'E'))
);

ALTER TABLE HR_LOAN_MASTER_SETUP ADD CONSTRAINT LOAN_ID_PK PRIMARY KEY (LOAN_ID);
-- END OF LOAN MASTER SETUP QUERY

-- QUERY FOR LOAN PERMISSIONS SETUP START
CREATE TABLE HR_LOAN_PERMISSIONS(
  LOAN_ID           NUMBER(6,0) NOT NULL,
  PERMISSION_TYPE   VARCHAR2(255 BYTE) NOT NULL,
  VALUE             VARCHAR2(255 BYTE) NOT NULL,
  STATUS            CHAR(1 BYTE) DEFAULT 'E' NOT NULL,
  CREATED_DATE      DATE DEFAULT SYSDATE NOT NULL,
  CREATED_BY        NUMBER(6,0) NOT NULL,
  MODIFIED_DATE     DATE,
  MODIFIED_BY       NUMBER(6,0),
  CHECK ( STATUS IN ('D', 'E'))
);

ALTER TABLE HR_LOAN_PERMISSIONS ADD CONSTRAINT PER_LOAN_ID_FK FOREIGN KEY (LOAN_ID)
REFERENCES HR_LOAN_MASTER_SETUP(LOAN_ID);

ALTER TABLE HR_LOAN_PERMISSIONS ADD PERMISSIONS_ID NUMBER(6,0) NOT NULL;

ALTER TABLE HR_LOAN_PERMISSIONS ADD CONSTRAINT PER_PERMISSION_ID_PK PRIMARY KEY (PERMISSIONS_ID);

-- END LOAN PERMISSION QUERY

-- START LOAN DETAIL HISTORY QUERY
CREATE TABLE HR_LOAN_DETAIL_HISTORY(
  HISTORY_ID        NUMBER(6,0) NOT NULL,
  EMPLOYEE_ID       NUMBER(6,0) NOT NULL,
  LOAN_ID           NUMBER(6,0) NOT NULL,
  RECEIVED_DATE     DATE NOT NULL,
  RECEIVED_AMOUNT   FLOAT(126) NOT NULL,
  FINAL_BALANCE     FLOAT(126) NOT NULL,
  TERMS             NUMBER(6,0) NOT NULL,
  RECEIVED_BY       NUMBER(6,0) NOT NULL,
  REMARKS           VARCHAR2(255 BYTE)
);
ALTER TABLE HR_LOAN_DETAIL_HISTORY ADD CONSTRAINT LOAN_HISTORY_ID_PK PRIMARY KEY(HISTORY_ID);

ALTER TABLE HR_LOAN_DETAIL_HISTORY ADD CONSTRAINT HISTORY_LOAN_ID_FK FOREIGN KEY (LOAN_ID)
REFERENCES HR_LOAN_MASTER_SETUP(LOAN_ID);

ALTER TABLE HR_LOAN_DETAIL_HISTORY ADD CONSTRAINT HISTORY_EMP_ID_FK FOREIGN KEY (EMPLOYEE_ID)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);
-- END LOAN DETAIL HISTORY QUERY

-- START LOAN REQUEST QUERY
CREATE TABLE HR_EMPLOYEE_LOAN_REQUEST (
  LOAN_REQUEST_ID     NUMBER(6,0) NOT NULL,
  EMPLOYEE_ID         NUMBER(6,0) NOT NULL,
  LOAN_ID             NUMBER(6,0) NOT NULL,
  REQUESTED_AMOUNT    FLOAT(126) NOT NULL,
  REQUESTED_DATE      DATE DEFAULT SYSDATE NOT NULL,
  LOAN_DATE           DATE NOT NULL,
  REASON              VARCHAR2(255 BYTE),
  STATUS              CHAR(2 BYTE) NOT NULL,
  APPROVED_AMOUNT     FLOAT(126),
  RECOMMENDED_BY      NUMBER(6,0),
  RECOMMENDED_DATE    DATE,
  RECOMMENDED_REMARKS VARCHAR2(255 BYTE),
  APPROVED_BY         NUMBER(6,0),
  APPROVED_DATE       DATE,
  APPROVED_REMARKS    VARCHAR2(255 BYTE)
);

ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST ADD CONSTRAINT RQ_LN_ID_PK PRIMARY KEY (LOAN_REQUEST_ID);

ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST ADD CONSTRAINT RQ_LN_EMP_FK FOREIGN KEY (EMPLOYEE_ID)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST ADD CONSTRAINT RQ_LN_LOAN_FK FOREIGN KEY (LOAN_ID)
REFERENCES HR_LOAN_MASTER_SETUP(LOAN_ID);

ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST ADD CONSTRAINT RQ_LN_APRV_BY_FK FOREIGN KEY(APPROVED_BY)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST ADD CONSTRAINT RQ_LN_RECMD_BY_FK FOREIGN KEY(RECOMMENDED_BY)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

-- END LOAN REQUEST QUERY


--START ADVCANCE MASTER SETUP
CREATE TABLE HR_ADVANCE_MASTER_SETUP (
  ADVANCE_ID            NUMBER(6,0) NOT NULL,
  ADVANCE_CODE          VARCHAR2(15 BYTE) NOT NULL,
  ADVANCE_NAME          VARCHAR2(255 BYTE) NOT NULL,
  MIN_SALARY_AMT        FLOAT(126) NOT NULL,
  MAX_SALARY_AMT        FLOAT(126) NOT NULL,
  AMOUNT_TO_ALLOW_PER   FLOAT(126) NOT NULL,
  MONTH_TO_ALLOW        NUMBER(6,0) NOT NULL,
  REMARKS               VARCHAR2(255),
  STATUS                CHAR(1 BYTE) NOT NULL,
  CREATED_BY            NUMBER(6,0) NOT NULL,
  CREATED_DATE          DATE DEFAULT SYSDATE NOT NULL,
  MODIFIED_BY           NUMBER(6,0),
  MODIFIED_DATE         DATE, 
  CHECK ( STATUS IN ('D', 'E'))
);
ALTER TABLE HR_ADVANCE_MASTER_SETUP ADD CONSTRAINT ADV_ID_PK PRIMARY KEY (ADVANCE_ID);

-- END ADVANCE MASTER SETUP


-- START ADVANCE REQUEST QUERY
CREATE TABLE HR_EMPLOYEE_ADVANCE_REQUEST (
  ADVANCE_REQUEST_ID     NUMBER(6,0) NOT NULL,
  EMPLOYEE_ID            NUMBER(6,0) NOT NULL,
  ADVANCE_ID             NUMBER(6,0) NOT NULL,
  REQUEST_AMOUNT         FLOAT(126) NOT NULL,
  TERMS                  NUMBER(6,0) NOT NULL,
  REQUESTED_DATE         DATE DEFAULT SYSDATE NOT NULL,
  ADVANCE_DATE           DATE,
  REASON                 VARCHAR2(255 BYTE),
  STATUS                 CHAR(2 BYTE) NOT NULL,
  APPROVED_AMOUNT        FLOAT(126),
  RECOMMENDED_BY         NUMBER(6,0),
  RECOMMENDED_DATE       DATE,
  RECOMMENDED_REMARKS    VARCHAR2(255),
  APPROVED_BY            NUMBER(6,0),
  APPROVED_DATE          DATE,
  APPROVED_REMARKS       VARCHAR2(255)
);

ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST ADD CONSTRAINT ADV_RQ_ID_PK PRIMARY KEY(ADVANCE_REQUEST_ID);

ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST ADD CONSTRAINT ADV_RQ_ADV_ID_FK FOREIGN KEY(ADVANCE_ID)
REFERENCES HR_ADVANCE_MASTER_SETUP(ADVANCE_ID);

ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST ADD CONSTRAINT ADV_RQ_EMP_ID_FK FOREIGN KEY(EMPLOYEE_ID)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST ADD CONSTRAINT RQ_ADV_APRV_BY_FK FOREIGN KEY(APPROVED_BY)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST ADD CONSTRAINT RQ_ADV_RECMD_BY_FK FOREIGN KEY(RECOMMENDED_BY)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

--END ADVANCE REQUEST QUERY

-- START INSTITUTE MASTER SETUP
CREATE TABLE HR_INSTITUTE_MASTER_SETUP(
  INSTITUTE_ID      NUMBER(6,0) NOT NULL,
  INSTITUTE_CODE    VARCHAR2(15 BYTE) NOT NULL,
  INSTITUTE_NAME    VARCHAR2(255 BYTE) NOT NULL,
  LOCATION          VARCHAR2(255 BYTE) NOT NULL,
  REMARKS           VARCHAR2(255 BYTE) NOT NULL,
  STATUS            CHAR(1 BYTE) NOT NULL,
  CREATED_DATE      DATE DEFAULT SYSDATE NOT NULL,
  CREATED_BY        NUMBER(6,0) NOT NULL,
  MODIFIED_DATE     DATE,
  MODIFIED_BY       NUMBER(6,0),
  CHECK ( STATUS IN ('D', 'E'))
  );
ALTER TABLE HR_INSTITUTE_MASTER_SETUP ADD CONSTRAINT INST_ID_PK PRIMARY KEY(INSTITUTE_ID);

-- END INSTITUTE MASTER SETUP

-- START TRAINING MASTER SETUP 
CREATE TABLE HR_TRAINING_MASTER_SETUP (
  TRAINING_ID       NUMBER(6,0) NOT NULL,
  INSTITUTE_ID       NUMBER(6,0) NOT NULL,
  TRAINING_CODE     VARCHAR2(15 BYTE) NOT NULL,
  TRAINING_NAME     VARCHAR2(255 BYTE) NOT NULL,
  TRRAINING_TYPE    VARCHAR2(15 BYTE) NOT NULL,
  START_DATE        DATE NOT NULL,
  END_DATE          DATE NOT NULL,
  DURATION          NUMBER(6,0),
  INSTRUCTOR_NAME   VARCHAR2(255 BYTE) NOT NULL,
  REMARKS           VARCHAR2(255 BYTE),
  STATUS            CHAR(1 BYTE) NOT NULL,
  CREATED_DATE      DATE DEFAULT SYSDATE NOT NULL,
  CREATED_BY        NUMBER(6,0) NOT NULL,
  MODIFIED_DATE     DATE,
  MODIFIED_BY       NUMBER(6,0),
  CHECK ( STATUS IN ('D', 'E'))
);
ALTER TABLE HR_TRAINING_MASTER_SETUP ADD CONSTRAINT TRAIN_ID_PK PRIMARY KEY(TRAINING_ID);

ALTER TABLE HR_TRAINING_MASTER_SETUP ADD CONSTRAINT TRAIN_INST_ID_FK FOREIGN KEY(INSTITUTE_ID) 
REFERENCES HR_INSTITUTE_MASTER_SETUP(INSTITUTE_ID);

-- END TRAINING MASTER SETUP

-- START EMPLOYEE TRAINING ASSIGN 
CREATE TABLE HR_EMPLOYEE_TRAINING_ASSIGN (
  TRAINING_ID         NUMBER(6,0) NOT NULL,
  EMPLOYEE_ID         NUMBER(6,0) NOT NULL,
  REMARKS             VARCHAR2(255 BYTE),
  STATUS              CHAR(1 BYTE) NOT NULL,
  CREATED_DATE        DATE DEFAULT SYSDATE NOT NULL,
  CREATED_BY          NUMBER(6,0) NOT NULL,
  MODIFIED_DATE       DATE,
  MODIFIED_BY         NUMBER(6,0)
);

ALTER TABLE HR_EMPLOYEE_TRAINING_ASSIGN ADD CONSTRAINT TRAIN_EMP_ID_FK FOREIGN KEY(EMPLOYEE_ID) REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_TRAINING_ASSIGN ADD CONSTRAINT TRAIN_TRAINING_ID_FK 
FOREIGN KEY (TRAINING_ID) REFERENCES HR_TRAINING_MASTER_SETUP(TRAINING_ID);
-- END EMPLOYEE TRAINING ASSIGN


-- START EMPLOYEE TRAVEL REQUEST
CREATE TABLE HR_EMPLOYEE_TRAVEL_REQUEST(
  TRAVEL_ID           NUMBER(6,0) NOT NULL,
  EMPLOYEE_ID         NUMBER(6,0) NOT NULL,
  REQUESTED_DATE      DATE DEFAULT SYSDATE NOT NULL,
  FROM_DATE           DATE NOT NULL,
  TO_DATE             DATE NOT NULL,
  DESTINATION         VARCHAR2(255 BYTE) NOT NULL,
  PURPOSE             VARCHAR2(255 BYTE),
  REQUESTED_TYPE      VARCHAR2(15 BYTE) NOT NULL,
  REQUESTED_AMOUNT    FLOAT(126) NOT NULL,
  REMARKS             VARCHAR2(255),
  STATUS              CHAR(2 BYTE) NOT NULL,
  APPROVED_AMOUNT     FLOAT(125),
  RECOMMENDED_BY      NUMBER(6,0),
  RECOMMENDED_DATE    DATE,
  RECOMMENDED_REMARKS VARCHAR2(255 BYTE),
  APPROVED_BY         NUMBER(6,0),
  APPROVED_DATE       DATE,
  APPROVED_REMARKS    VARCHAR2(255 BYTE)
);

ALTER TABLE HR_EMPLOYEE_TRAVEL_REQUEST ADD CONSTRAINT EMP_TRAVEL_ID_PK PRIMARY KEY(TRAVEL_ID);

ALTER TABLE HR_EMPLOYEE_TRAVEL_REQUEST ADD CONSTRAINT EMP_TRAVEL_EMP_ID_FK FOREIGN KEY(EMPLOYEE_ID)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_TRAVEL_REQUEST ADD CONSTRAINT RQ_TRVL_APRV_BY_FK FOREIGN KEY(APPROVED_BY)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HR_EMPLOYEE_TRAVEL_REQUEST ADD CONSTRAINT RQ_TRVL_RECMD_BY_FK FOREIGN KEY(RECOMMENDED_BY)
REFERENCES HR_EMPLOYEES(EMPLOYEE_ID);
-- END EMPLOYEE TRAVEL REQUEST

-- DROP COLUMN OF LOAN MASTER SETUP [2 Jan 2017]
ALTER TABLE HR_LOAN_MASTER_SETUP 
DROP COLUMN DEDUCT_ON_SALARY;
-- END DROP QUERY

-- ADD COLUMN ON LOAN REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST 
ADD DEDUCT_ON_SALARY CHAR(1 BYTE);
-- END 

-- RENAME COLUMN OF ADVANCE MASTER SETUP 
ALTER TABLE HR_ADVANCE_MASTER_SETUP
RENAME COLUMN AMOUNT_TO_ALLOW_PER TO AMOUNT_TO_ALLOW
-- END

-- ADD TWO COLUMN ON INSTITUTE MASTER SETUP
ALTER TABLE HR_INSTITUTE_MASTER_SETUP
ADD (TELEPHONE VARCHAR2(255 BYTE),EMAIL VARCHAR2(255 BYTE));
--END

-- RENAME COLUMN OF TRAINING TABLE
ALTER TABLE HR_TRAINING_MASTER_SETUP
RENAME COLUMN TRRAINING_TYPE TO TRAINING_TYPE;
-- END


-- RENAME TABLE NAME 
RENAME HR_LOAN_PERMISSIONS TO HR_LOAN_RESTRICTIONS
-- END

-- RENAME COLUMN OF LOAN RESTRICTIONS TABLE
ALTER TABLE HR_LOAN_RESTRICTIONS
RENAME COLUMN PERMISSION_TYPE TO RESTRICTION_TYPE

ALTER TABLE HR_LOAN_RESTRICTIONS
RENAME COLUMN PERMISSIONS_ID TO RESTRICTION_ID

ALTER TABLE HR_LOAN_RESTRICTIONS
MODIFY VALUE VARCHAR2(255 BYTE) NULL
-- END

-- MODIFY DATA TYPE OF STATUS ON LOAN REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST
MODIFY STATUS VARCHAR2(2 BYTE)
-- END

-- DROP COLUMN APPROVED AMOUNT OF LOAN REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_LOAN_REQUEST 
DROP COLUMN APPROVED_AMOUNT;
--END

-- DROP COLUMN APPROVED AMOUNT OF ADVANCE REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST 
DROP COLUMN APPROVED_AMOUNT;
-- END

-- RENAME COLUMN OF ADVANCE REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST
RENAME COLUMN REQUEST_AMOUNT TO REQUESTED_AMOUNT
-- END

-- MODIFY DATA TYPE OF STATUS ON ADVANCE REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST
MODIFY STATUS VARCHAR2(2 BYTE)
-- END

-- DROP COLUMN APPROVED AMOUNT OF TRAVEL REQUEST TABLE
ALTER TABLE HR_EMPLOYEE_ADVANCE_REQUEST 
DROP COLUMN APPROVED_AMOUNT;
-- END