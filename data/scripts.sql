
-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_ADVANCE_MASTER_SETUP 
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_ADVANCE_MASTER_SETUP
ADD CONSTRAINT FK_ADV_MAS_SET_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);
--

-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_DESIGNATIONS 
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_DESIGNATIONS
ADD CONSTRAINT FK_DEGIGNATION_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_EMAIL_TEMPLATE
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_EMAIL_TEMPLATE
ADD CONSTRAINT FK_EMAIL_TEMP_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_LEAVE_MASTER_SETUP
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_LEAVE_MASTER_SETUP
ADD CONSTRAINT LEAVE_MASTER_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_LOAN_MASTER_SETUP
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_LOAN_MASTER_SETUP
ADD CONSTRAINT FK_LOAN_MASTER_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

-- 


-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_POSITIONS
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_POSITIONS
ADD CONSTRAINT FK_POSITIONS_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
-- 

ALTER TABLE HRIS_SHIFTS
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_SHIFTS
ADD CONSTRAINT FK_SHIFTS_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
--
ALTER TABLE HRIS_TRAINING_MASTER_SETUP
ADD COMPANY_ID NUMBER(7,0);

ALTER TABLE HRIS_TRAINING_MASTER_SETUP
ADD CONSTRAINT FK_TRA_MAS_SET_EMP_EMP_ID
FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);

--  

-- HRIS_NEO | 26-MAR-2017 | UKESH
--
ALTER TABLE HRIS_SHIFTS
DROP COLUMN LATE_IN;

ALTER TABLE HRIS_SHIFTS
ADD LATE_IN TIMESTAMP;

ALTER TABLE HRIS_SHIFTS
DROP COLUMN EARLY_OUT;

ALTER TABLE HRIS_SHIFTS
ADD EARLY_OUT TIMESTAMP;
-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
--
ALTER TABLE HRIS_SHIFTS
DROP COLUMN TOTAL_WORKING_HR;

ALTER TABLE HRIS_SHIFTS
ADD TOTAL_WORKING_HR TIMESTAMP DEFAULT TO_TIMESTAMP('00:00','HH24:MI') NOT NULL ;

ALTER TABLE HRIS_SHIFTS 
DROP COLUMN ACTUAL_WORKING_HR;

ALTER TABLE HRIS_SHIFTS
ADD ACTUAL_WORKING_HR TIMESTAMP DEFAULT TO_TIMESTAMP('00:00','HH24:MI') NOT NULL;

--
 
-- HRIS_NEO | 26-MAR-2017 | UKESH
--
CREATE TABLE "HRIS_ATTENDANCE_DEVICE" 
   ("DEVICE_ID" NUMBER(7,0) PRIMARY KEY, 
	"DEVICE_NAME" VARCHAR2(255 BYTE) NOT NULL, 
	"DEVICE_IP" VARCHAR2(255 BYTE) NOT NULL, 
	"DEVICE_LOCATION" VARCHAR2(255 BYTE) NOT NULL, 
	"ISACTIVE" CHAR(1 BYTE) DEFAULT 'Y' NOT NULL CHECK (ISACTIVE IN ('Y','N')), 
	"COMPANY_ID" NUMBER(7,0), 
         DEVICE_COMPANY VARCHAR2(255 BYTE),
	"BRANCH_ID" NUMBER(7,0)
   ) ;

  ALTER TABLE HRIS_ATTENDANCE_DEVICE ADD CONSTRAINT FK_ATT_DEV_BRA_BRA_ID FOREIGN KEY (BRANCH_ID)
	  REFERENCES HRIS_BRANCHES (BRANCH_ID) ;
 
  ALTER TABLE HRIS_ATTENDANCE_DEVICE ADD CONSTRAINT FK_ATT_DEV_COMP_COMP_ID FOREIGN KEY (COMPANY_ID)
	  REFERENCES HRIS_COMPANY(COMPANY_ID);



ALTER TABLE HRIS_ATTENDANCE_DEVICE 
ADD STATUS CHAR(1 BYTE) DEFAULT 'E' NOT NULL  CHECK (STATUS IN ('E','D'));
-- 

-- HRIS_NEO | 26-MAR-2017 | UKESH
--
CREATE TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
(
	ID			                    NUMBER(7,0) NOT NULL,	
	TRAVEL_ID			              NUMBER(7,0) NOT NULL,
	DEPARTURE_DATE              DATE NOT NULL,
  DEPARTURE_TIME              TIMESTAMP(6) NOT NULL,
  DEPARTURE_PLACE             VARCHAR2(255 BYTE) NOT NULL,
  DESTINATION_DATE            DATE NOT NULL,
  DESTINATION_TIME            TIMESTAMP(6) NOT NULL,
  DESTINATION_PLACE           VARCHAR2(255 BYTE) NOT NULL,
  TRANSPORT_TYPE              CHAR(2 BYTE) NOT NULL,
  FARE                        FLOAT NOT NULL,
  ALLOWANCE                   FLOAT NOT NULL,
  LOCAL_CONVEYENCE            FLOAT NOT NULL,
  MISC_EXPENSES               FLOAT NOT NULL,
  TOTAL_AMOUNT                FLOAT NOT NULL,
  REAMRKS                     VARCHAR2(255 BYTE),
	COMPANY_ID          	      NUMBER(7,0),	
	BRANCH_ID           	      NUMBER(7,0),
	CREATED_BY                  NUMBER(7,0),
	CREATED_DATE                DATE DEFAULT SYSDATE,
	MODIFIED_BY		              NUMBER(7,0),
	MODIFIED_DATE		            DATE,
	CHECKED					            VARCHAR2(1 BYTE) DEFAULT 'N',
	APPROVED_BY				          NUMBER(7,0),
	APPROVED_DATE			          DATE DEFAULT SYSDATE,
	APPROVED				            VARCHAR2(1 BYTE) DEFAULT 'N',
	STATUS        			        CHAR(1 BYTE),
	CONSTRAINT FK_TRL_EXP_DTL_COM_COM_ID FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID),
	CONSTRAINT FK_TRL_EXP_DTL_BRN_BNC_ID FOREIGN KEY(BRANCH_ID) REFERENCES HRIS_BRANCHES(BRANCH_ID),
	CONSTRAINT PK_TRL_EXP_DTL PRIMARY KEY (ID),
	CONSTRAINT FK_TRL_EXP_DTL FOREIGN KEY(TRAVEL_ID) REFERENCES HRIS_EMPLOYEE_TRAVEL_REQUEST(TRAVEL_ID),
	CONSTRAINT FK_TRL_EXP_DTL_EMP_EMP_ID FOREIGN KEY(CREATED_BY) REFERENCES 	HRIS_EMPLOYEES(EMPLOYEE_ID),
	CONSTRAINT FK_TRL_EXP_DTL_EMP_EMP_ID2 FOREIGN KEY(MODIFIED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID),
	CONSTRAINT FK_TRL_EXP_DTL_EMP_EMP_ID3 FOREIGN KEY(APPROVED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID)
);


ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL 
ADD
CONSTRAINT CHEK_TRANS CHECK (TRANSPORT_TYPE IN ('AP','OV','TI','BS'));

ALTER TABLE HRIS_EMPLOYEE_TRAVEL_REQUEST
ADD ( TRANSPORT_TYPE      CHAR(2 BYTE),
      DEPARTURE_DATE      DATE,
      RETURED_DATE        DATE
);


ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
RENAME COLUMN REAMRKS TO REMARKS;
-- 
-- HRIS_NEO | 27-MAR-2017 | UKESH
--
CREATE TABLE HRIS_USER_LOG
  (
    USER_ID    NUMBER(7,0) NOT NULL,
    LOGIN_IP   VARCHAR2(255 BYTE) NOT NULL,
    LOGIN_DATE TIMESTAMP DEFAULT SYSDATE NOT NULL
  );
CREATE TABLE HRIS_NEWS
  (
    NEWS_ID   NUMBER(12,0) PRIMARY KEY,
    NEWS_DATE DATE NOT NULL,
    NEWS_TYPE VARCHAR2(100 BYTE) NOT NULL CHECK(NEWS_TYPE IN ('NEWS','NOTICE','CIRCULAR','RULE','OTHERS')),
    NEWS_TITLE     VARCHAR2(255 BYTE) NOT NULL,
    NEWS_EDESC     VARCHAR2(3000 BYTE) NOT NULL,
    NEWS_LDESC     VARCHAR2(3000 BYTE) NOT NULL,
    REMARKS        VARCHAR2(400 BYTE) DEFAULT NULL,
    COMPANY_ID     NUMBER(7,0) NOT NULL,
    BRANCH_ID      NUMBER(7,0) DEFAULT NULL,
    DESIGNATION_ID NUMBER(7,0) DEFAULT NULL,
    DEPARTMENT_ID  NUMBER(7,0) DEFAULT NULL,
    CREATED_BY     NUMBER(7,0) NOT NULL,
    CREATED_DT     DATE DEFAULT SYSDATE NOT NULL,
    MODIFIED_BY    NUMBER(7,0),
    MODIFIED_DT    DATE,
    APPROVED_BY    NUMBER(7,0),
    APPROVED_DT    DATE ,
    STATUS         CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
  );
ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_COM_COMPANY_ID FOREIGN KEY(COMPANY_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);
ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_BRA_BRANCH_ID FOREIGN KEY(BRANCH_ID) REFERENCES HRIS_BRANCHES(BRANCH_ID);
ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_DESIG_DESIGNATION_ID FOREIGN KEY(DESIGNATION_ID) REFERENCES HRIS_DESIGNATIONS(DESIGNATION_ID);
ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_DEPT_DEPT_ID FOREIGN KEY(DEPARTMENT_ID) REFERENCES HRIS_DEPARTMENTS(DEPARTMENT_ID);


ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_EMP_EMPLOYEE_ID1 FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_EMP_EMPLOYEE_ID2 FOREIGN KEY(MODIFIED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_NEWS ADD CONSTRAINT FK_NEWS_EMP_EMPLOYEE_ID3 FOREIGN KEY(APPROVED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
-- 

-- HRIS_NEO | 27-MAR-2017 | UKESH
-- 
TRUNCATE TABLE HRIS_ATTENDANCE;
ALTER TABLE HRIS_ATTENDANCE ADD CONSTRAINT UNQ_ATTENDANCE UNIQUE (EMPLOYEE_ID, ATTENDANCE_DT,ATTENDANCE_TIME);
-- 
  
-- HRIS_NEO | 27-MAR-2017 | SOMKALA
-- 
ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
MODIFY ALLOWANCE FLOAT NULL;

ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
MODIFY LOCAL_CONVEYENCE FLOAT NULL;

ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
MODIFY MISC_EXPENSES FLOAT NULL;
--

-- HRIS_NEO | 27-MAR-2017 | SOMKALA
ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
MODIFY ALLOWANCE FLOAT NULL;

ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
MODIFY LOCAL_CONVEYENCE FLOAT NULL;

ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
MODIFY MISC_EXPENSES FLOAT NULL;

ALTER TABLE HRIS_EMP_TRAVEL_EXPENSE_DTL
DROP(COMPANY_ID,BRANCH_ID,CHECKED,APPROVED,APPROVED_BY,APPROVED_DATE);

ALTER TABLE HRIS_EMPLOYEE_TRAVEL_REQUEST
RENAME COLUMN RETURED_DATE TO RETURNED_DATE
--

-- HRIS_NEO | 27-MAR-2017 | UKESH
-- HRIS_MODERN | 27-MAR-2017 | UKESH
-- 
ALTER TABLE HRIS_ATTENDANCE_DETAIL
ADD SHIFT_ID NUMBER(7,0) NOT NULL;

ALTER TABLE HRIS_ATTENDANCE_DETAIL
ADD CONSTRAINT FK_ATT_DET_SFT_SHIFT_ID
FOREIGN KEY(SHIFT_ID) REFERENCES HRIS_SHIFTS(SHIFT_ID);

ALTER TABLE HRIS_ATTENDANCE_DETAIL
ADD DAYOFF_FLAG CHAR(1 BYTE) DEFAULT 'N' NOT NULL CHECK(DAYOFF_FLAG IN ('Y','N'));
-- 

-- HRIS_NEO | 30-MAR-2017 | UKESH
-- 
CREATE TABLE HRIS_TASK
  (
    TASK_ID        NUMBER(12,0) PRIMARY KEY ,
    TASK_EDESC     VARCHAR2(500 BYTE) NOT NULL,
    TASK_NDESC     VARCHAR2(500 BYTE),
    START_DATE     DATE DEFAULT NULL,
    END_DATE       DATE DEFAULT NULL,
    ESTIMATED_TIME NUMBER(10,2) DEFAULT NULL,
    EMPLOYEE_ID    NUMBER(7,0) NOT NULL,
    STATUS         CHAR(1 BYTE) DEFAULT 'O' NOT NULL CHECK(STATUS        IN ('O','C')),
    TASK_PRIORITY  CHAR(1 BYTE) DEFAULT 'L' NOT NULL CHECK(TASK_PRIORITY IN ('L','M','H')),
    REMARKS        VARCHAR2(400 BYTE) DEFAULT NULL,
    COMPANY_ID     NUMBER(7,0),
    BRANCH_ID      NUMBER(7,0),
    CREATED_BY     NUMBER(7,0)  NOT NULL,
    CREATED_DT     DATE DEFAULT SYSDATE NOT NULL,
    MODIFIED_BY    NUMBER(7,0),
    MODIFIED_DT    DATE,
    APPROVED_FLAG  CHAR(1 BYTE) DEFAULT 'Y',
    APPROVED_BY    NUMBER(7,0),
    APPROVED_DATE  DATE,
    DELETED_FLAG   CHAR(1 BYTE) DEFAULT 'N' NOT NULL CHECK(DELETED_FLAG IN ('Y','N'))
  );

ALTER TABLE HRIS_TASK ADD CONSTRAINT FK_TASK_EMP_EMP_ID_1 FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_TASK ADD CONSTRAINT FK_TASK_COMP_COMP_ID FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_COMPANY(COMPANY_ID);
ALTER TABLE HRIS_TASK ADD CONSTRAINT FK_TASK_BRA_BRA_ID FOREIGN KEY(BRANCH_ID) REFERENCES HRIS_BRANCHES(BRANCH_ID);
ALTER TABLE HRIS_TASK ADD CONSTRAINT FK_TASK_EMP_EMP_ID_2 FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_TASK ADD CONSTRAINT FK_TASK_EMP_EMP_ID_3 FOREIGN KEY(MODIFIED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_TASK ADD CONSTRAINT FK_TASK_EMP_EMP_ID_4 FOREIGN KEY(APPROVED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);


-- 

-- HRIS_NEO || 2017-03-30
-- 
CREATE TABLE HRIS_LEAVE_SUBSTITUTE
  (
    LEAVE_REQUEST_ID NUMBER(7,0) NOT NULL,
    EMPLOYEE_ID      NUMBER(7,0) NOT NULL,
    REMARKS          VARCHAR2(400 BYTE) DEFAULT NULL,
    CREATED_BY       NUMBER(7,0) NOT NULL,
    CREATED_DT       DATE DEFAULT SYSDATE NOT NULL,
    APPROVED_FLAG    CHAR(1 BYTE) DEFAULT NULL CHECK(APPROVED_FLAG IN ('Y','N')),
    APPROVED_DATE    DATE,
    STATUS           CHAR(1 BYTE) DEFAULT 'N' CHECK (STATUS IN ('E','D'))
  );
  
ALTER TABLE HRIS_LEAVE_SUBSTITUTE ADD CONSTRAINT FK_LEAVESUB_EMP_EMP_ID_1 FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_LEAVE_SUBSTITUTE ADD CONSTRAINT FK_LEAVESUB_LREQUEST_ID FOREIGN KEY(LEAVE_REQUEST_ID) REFERENCES HRIS_EMPLOYEE_LEAVE_REQUEST(ID);
ALTER TABLE HRIS_LEAVE_SUBSTITUTE ADD CONSTRAINT FK_LEAVESUB_EMP_EMP_ID_2 FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);


ALTER TABLE HRIS_EMPLOYEE_LEAVE_REQUEST ADD CONSTRAINT PK_LEAVE_REQUEST_ID PRIMARY KEY(ID);

  
  
CREATE TABLE HRIS_TRAVEL_SUBSTITUTE
  (
    TRAVEL_ID          NUMBER(12) NOT NULL,
    EMPLOYEE_ID      NUMBER(7,0) NOT NULL,
    REMARKS          VARCHAR2(400 BYTE) DEFAULT NULL,
    CREATED_BY       NUMBER(7,0) NOT NULL,
    CREATED_DT       DATE DEFAULT SYSDATE NOT NULL,
    APPROVED_FLAG    CHAR(1 BYTE) DEFAULT NULL CHECK(APPROVED_FLAG IN ('Y','N')),
    APPROVED_DATE    DATE,
    STATUS  CHAR(1 BYTE) DEFAULT 'N' CHECK (STATUS IN ('E','D'))
  );
  

ALTER TABLE HRIS_TRAVEL_SUBSTITUTE ADD CONSTRAINT FK_TRAVELSUB_EMP_EMP_ID_1 FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_TRAVEL_SUBSTITUTE ADD CONSTRAINT FK_TRAVELSUB_TREQUEST_ID FOREIGN KEY(TRAVEL_ID) REFERENCES HRIS_EMPLOYEE_TRAVEL_REQUEST(TRAVEL_ID);
ALTER TABLE HRIS_TRAVEL_SUBSTITUTE ADD CONSTRAINT FK_TRAVELSUB_EMP_EMP_ID_2 FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
-- 

-- NEO-HRIS | SOMKALA PACHHAI | MARCH 31 2017
ALTER TABLE HRIS_LEAVE_SUBSTITUTE
RENAME COLUMN CREATED_DT TO CREATED_DATE;

ALTER TABLE HRIS_TRAVEL_SUBSTITUTE
RENAME COLUMN CREATED_DT TO CREATED_DATE;
--


-- HRIS_NEO | 26-MAR-2017 | PRABIN
-- 

ALTER TABLE HRIS_TASK
ADD TASK_TITLE  VARCHAR2(100 BYTE) NOT NULL;


--ITNEPAL_HRIS_APR2 |2nd april 2017| PRABIN

ALTER TABLE HRIS_EMPLOYEES
MODIFY  ID_CARD_NO VARCHAR2(100 BYTE);


-- HRIS_NEO | 4-APRIL-2017 | PRABIN

DROP TABLE HRIS_ATTENDANCE_DEVICE;

CREATE TABLE "HRIS_ATTD_DEVICE_MASTER" 
   ("DEVICE_ID" NUMBER(7,0) PRIMARY KEY, 
	"DEVICE_NAME" VARCHAR2(255 BYTE) NOT NULL, 
	"DEVICE_IP" VARCHAR2(255 BYTE) NOT NULL, 
	"DEVICE_LOCATION" VARCHAR2(255 BYTE) NOT NULL, 
	"ISACTIVE" CHAR(1 BYTE) DEFAULT 'Y' NOT NULL CHECK (ISACTIVE IN ('Y','N')), 
	"COMPANY_ID" NUMBER(7,0), 
         DEVICE_COMPANY VARCHAR2(255 BYTE),
	"BRANCH_ID" NUMBER(7,0)
   ) ;

  ALTER TABLE HRIS_ATTD_DEVICE_MASTER ADD CONSTRAINT FK_ATT_DEV_BRA_BRA_ID FOREIGN KEY (BRANCH_ID)
	  REFERENCES HRIS_BRANCHES (BRANCH_ID) ;
 
  ALTER TABLE HRIS_ATTD_DEVICE_MASTER ADD CONSTRAINT FK_ATT_DEV_COMP_COMP_ID FOREIGN KEY (COMPANY_ID)
	  REFERENCES HRIS_COMPANY(COMPANY_ID);


ALTER TABLE HRIS_ATTENDANCE_DEVICE 

ALTER TABLE HRIS_ATTD_DEVICE_MASTER 
ADD STATUS CHAR(1 BYTE) DEFAULT 'E' NOT NULL  CHECK (STATUS IN ('E','D'));
--

-- NEO_HRIS | SOMKALA PACHHAI | APRIL 4 2017
  ALTER TABLE HRIS_TRAINING_MASTER_SETUP MODIFY
  TRAINING_TYPE CHAR(2 BYTE) CHECK (TRAINING_TYPE IN ('CC','CP'))
    
    
  ALTER TABLE HRIS_TRAINING_MASTER_SETUP MODIFY
  TRAINING_TYPE CHECK (TRAINING_TYPE IN ('CC','CP'))


CREATE TABLE HRIS_EMPLOYEE_TRAINING_REQUEST
  (
    REQUEST_ID          NUMBER(7,0) NOT NULL,
    REQUESTED_DATE      DATE DEFAULT SYSDATE NOT NULL ,
    EMPLOYEE_ID         NUMBER(7,0) NOT NULL,
    TRAINING_ID         NUMBER(7,0) NULL,
    TITLE               VARCHAR2(255 BYTE),
    DESCRIPTION         VARCHAR2(255 BYTE),
    TRAINING_TYPE       CHAR(2 BYTE) CHECK (TRAINING_TYPE IN ('CC','CP')),
    START_DATE          DATE,
    END_DATE            DATE,
    STATUS              CHAR(2 BYTE) NOT NULL,
    RECOMMENDED_BY      NUMBER(6,0),
    RECOMMENDED_DATE    DATE,
    RECOMMENDED_REMARKS VARCHAR2(255 BYTE),
    APPROVED_BY         NUMBER(6,0),
    APPROVED_DATE       DATE,
    APPROVED_REMARKS    VARCHAR2(255 BYTE),
    MODIFIED_DATE       DATE 
  ); 
  
ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT PK_TRAIN_REQ_REQUEST_ID PRIMARY KEY(REQUEST_ID);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT FK_TRAIN_REQ_EMP_EMP_ID FOREIGN KEY(EMPLOYEE_ID)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT FK_TRAIN_REQ_EMP_EMP_ID1 FOREIGN KEY(APPROVED_BY)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT FK_TRAIN_REQ_EMP_EMP_ID2 FOREIGN KEY(RECOMMENDED_BY)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD DURATION NUMBER(6,0);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD REMARKS VARCHAR2(255 BYTE);
--



-- JWL_HRIS_APR4 | Prabin  | APRIL 4 2017
INSERT
INTO HRIS_LEAVE_MASTER_SETUP
  (
    LEAVE_ID,
    LEAVE_CODE,
    LEAVE_ENAME,
    LEAVE_LNAME,
    ALLOW_HALFDAY,
    FISCAL_YEAR,
    CARRY_FORWARD,
    CASHABLE,
    CREATED_DT,
    MODIFIED_DT,
    STATUS,
    REMARKS,
    CREATED_BY,
    MODIFIED_BY,
    IS_SUBSTITUTE,
    PAID,
    COMPANY_ID,
    MAX_ACCUMULATE_DAYS,
    DEFAULT_DAYS
  )
  VALUES
  (
    3,
    '003',
    'Subsitute',
    NULL,
    'N',
    '1',
    'N',
    'N',
    to_date('06-APR-17','DD-MON-RR'),
    NULL,
    'E',
    NULL,
    NULL,
    NULL,
    'Y',
    'N',
    NULL,
    NULL,
    1
  );
--

REMAINING IN NEW DATABASE

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT FK_TRAIN_REQ_EMP_EMP_ID FOREIGN KEY(EMPLOYEE_ID)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT FK_TRAIN_REQ_EMP_EMP_ID1 FOREIGN KEY(APPROVED_BY)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST ADD CONSTRAINT FK_TRAIN_REQ_EMP_EMP_ID2 FOREIGN KEY(RECOMMENDED_BY)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

REMAINING IN NEW DATABASE


--NEO_HRIS | SOMKALA PACHHAI | APRIL 10 2017
ALTER TABLE HRIS_EMPLOYEE_TRAINING_REQUEST
MODIFY STATUS VARCHAR2(2 BYTE)
--

--NEO_HRIS | SOMKALA PACHHAI | APRIL 19 2017
ALTER TABLE HRIS_LEAVE_MASTER_SETUP
ADD MAX_ACCUMULATE_DAYS NUMBER(7,0);
---


--NEO_HRIS | SOMKALA PACHHAI | APRIL 26 2017
CREATE TABLE HRIS_FORGOT_PWD_DTL(
  EMPLOYEE_ID   NUMBER(7,0) NOT NULL,
  CODE          NUMBER(6,0) NOT NULL,
  EXPIRY_DATE   TIMESTAMP NOT NULL
);
ALTER TABLE HRIS_FORGOT_PWD_DTL ADD CONSTRAINT FK_FORGOT_PWD_DTL_EMP_EMP_ID FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

---


--NEO_HRIS | SOMKALA PACHHAI | MAY 1 2017
CREATE TABLE HRIS_OVERTIME
  (
    OVERTIME_ID         NUMBER(7,0) NOT NULL,
    EMPLOYEE_ID         NUMBER(7,0) NOT NULL,
    OVERTIME_DATE       DATE NOT NULL,
    REQUESTED_DATE      DATE NOT NULL,
    DESCRIPTION         VARCHAR2(255 BYTE) NOT NULL,
    REMARKS             VARCHAR2(255 BYTE),
    STATUS              VARCHAR2(2 BYTE) CHECK(STATUS IN ('RQ','RC','AP','C','R')),
    RECOMMENDED_BY      NUMBER(7,0),
    RECOMMENDED_DATE    DATE,
    RECOMMENDED_REMARKS VARCHAR2(255 BYTE),
    APPROVED_BY         NUMBER(7,0),
    APPROVED_DATE       DATE,
    APPROVED_REMARKS    VARCHAR2(255 BYTE),
    MODIFIED_DATE       DATE
  );
  
  
ALTER TABLE HRIS_OVERTIME ADD CONSTRAINT PK_OVERTIME_OVERTIME_ID PRIMARY KEY(OVERTIME_ID);

ALTER TABLE HRIS_OVERTIME ADD CONSTRAINT FK_OVERTIME_EMP_EMP_ID FOREIGN KEY(EMPLOYEE_ID)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_OVERTIME ADD CONSTRAINT FK_OVERTIME_EMP_EMP_ID1 FOREIGN KEY(APPROVED_BY)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

ALTER TABLE HRIS_OVERTIME ADD CONSTRAINT FK_OVERTIME_EMP_EMP_ID2 FOREIGN KEY(RECOMMENDED_BY)
REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

---

ALTER TABLE HRIS_EMPLOYEE_ADVANCE_REQUEST ADD VOUCHER_NO VARCHAR2(20 BYTE) ;

ALTER TABLE HRIS_LEAVE_MASTER_SETUP DROP COLUMN DEFAULT_DAYS;
ALTER TABLE HRIS_LEAVE_MASTER_SETUP ADD DEFAULT_DAYS NUMBER(3) DEFAULT 1 NOT NULL ;


CREATE TABLE HRIS_OVERTIME_DETAIL(
    DETAIL_ID           NUMBER(7,0) NOT NULL,
    OVERTIME_ID         NUMBER(7,0) NOT NULL,
    START_TIME          TIMESTAMP NOT NULL,
    END_TIME            TIMESTAMP NOT NULL,
    STATUS              CHAR(1 BYTE) CHECK(STATUS IN ('E','D')),
    CREATED_BY          NUMBER(7,0),
    CREATED_DATE        DATE,
    MODIFIED_BY         NUMBER(7,0),
    MODIFIED_DATE       DATE
);
ALTER TABLE HRIS_OVERTIME_DETAIL ADD CONSTRAINT PK_OVRTIME_DTL_DETAIL_ID PRIMARY KEY(DETAIL_ID);
ALTER TABLE HRIS_OVERTIME_DETAIL ADD CONSTRAINT FK_OVRTIME_DTL_OVRTIME_OVR_ID FOREIGN KEY(OVERTIME_ID) REFERENCES HRIS_OVERTIME(OVERTIME_ID);
ALTER TABLE HRIS_OVERTIME_DETAIL ADD CONSTRAINT FK_OVRTIME_DTL_EMP_EMP_ID FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_OVERTIME_DETAIL ADD CONSTRAINT FK_OVRTIME_DTL_EMP_EMP_ID2 FOREIGN KEY(MODIFIED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
ALTER TABLE HRIS_OVERTIME_DETAIL
ADD TOTAL_HOUR FLOAT
---


--NEO_HRIS | SOMKALA PACHHAI | 3rd May 2017
CREATE TABLE HRIS_SERVICE_QA
  (
    QA_ID              NUMBER(7,0) NOT NULL,
    PARENT_QA_ID       NUMBER(7,0),
    SERVICE_EVENT_TYPE_ID   NUMBER(7,0),
    QUESTION_EDESC     VARCHAR2(300 BYTE) NOT NULL,
    QUESTION_NDESC     VARCHAR2(800 BYTE) DEFAULT NULL,
    REMARKS            VARCHAR2(255 BYTE) DEFAULT NULL,
    STATUS             CHAR(1 BYTE) CHECK( STATUS IN ('D','E')),
    COMPANY_ID         NUMBER(7,0),
    BRANCH_ID          NUMBER(7,0),
    CREATED_BY         NUMBER(7,0),
    CREATED_DATE       DATE DEFAULT SYSDATE,
    MODIFIED_BY        NUMBER(7,0),
    MODIFIED_DATE      DATE,
    CHECKED            VARCHAR2(1 BYTE) DEFAULT 'N',
    APPROVED_BY        NUMBER(7,0),
    APPROVED_DATE      DATE,
    APPROVED           VARCHAR2(1 BYTE) DEFAULT 'N'
  );
  
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT PK_SERVICE_QA PRIMARY KEY(QA_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT UNQ_SERVICE_QA UNIQUE (QUESTION_EDESC,SERVICE_EVENT_TYPE_ID,COMPANY_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT FK_SRV_QA_SRV_EVT_SRV_EVT_ID FOREIGN KEY(SERVICE_EVENT_TYPE_ID)
  REFERENCES HRIS_SERVICE_EVENT_TYPES(SERVICE_EVENT_TYPE_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT FK_SRV_QA_COM_COM_ID FOREIGN KEY(COMPANY_ID)
  REFERENCES HRIS_COMPANY(COMPANY_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT FK_SRV_QA_BRN_BRN_ID FOREIGN KEY(BRANCH_ID) REFERENCES HRIS_BRANCHES(BRANCH_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT FK_SRV_QA_EMP_EMP_ID FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT FK_SRV_QA_EMP_EMP_ID2 FOREIGN KEY(MODIFIED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
  ALTER TABLE HRIS_SERVICE_QA ADD CONSTRAINT FK_SRV_QA_EMP_EMP_ID3 FOREIGN KEY(APPROVED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);


  
CREATE TABLE HRIS_EMPLOYEE_SERVICE_QA
  (
    EMP_QA_ID          NUMBER(7,0) NOT NULL,
    EMPLOYEE_ID        NUMBER(7,0) NOT NULL,
    QA_ID              NUMBER(7,0) NOT NULL,
    QA_DATE            DATE NOT NULL,
    ANSWER             VARCHAR2(800 BYTE) NOT NULL,
    REMARKS            VARCHAR2(255 BYTE) DEFAULT NULL,
    STATUS             CHAR(1 BYTE) CHECK( STATUS IN ('D','E')),
    COMPANY_ID         NUMBER(7,0),
    BRANCH_ID          NUMBER(7,0),
    CREATED_BY         NUMBER(7,0),
    CREATED_DATE       DATE,
    MODIFIED_BY        NUMBER(7,0),
    MODIFIED_DATE      DATE,
    CHECKED            VARCHAR2(1 BYTE) DEFAULT 'N',
    APPROVED_BY        NUMBER(7,0),
    APPROVED_DATE      DATE,
    APPROVED           VARCHAR2(1 BYTE) DEFAULT 'N',
    DELETED_FLAG       CHAR(1 BYTE)    
  );

  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT PK_EMP_SERVICE_QA PRIMARY KEY(EMP_QA_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_SRV_QA_QA_ID FOREIGN KEY(QA_ID)
  REFERENCES HRIS_SERVICE_QA(QA_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_COM_COM_ID FOREIGN KEY(COMPANY_ID)
  REFERENCES HRIS_COMPANY(COMPANY_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_BRN_BRN_ID FOREIGN KEY(BRANCH_ID) REFERENCES HRIS_BRANCHES(BRANCH_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_EMP_EMP_ID FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_EMP_EMP_ID2 FOREIGN KEY(CREATED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_EMP_EMP_ID3 FOREIGN KEY(MODIFIED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);
  ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_EMP_EMP_ID4 FOREIGN KEY(APPROVED_BY) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID);

---  

CREATE TABLE HRIS_EMPLOYEE_HOLIDAY
  (
    EMPLOYEE_ID NUMBER(7,0) NOT NULL,
    HOLIDAY_ID  NUMBER(7,0) NOT NULL    
  ); 
  
  ALTER TABLE HRIS_EMPLOYEE_HOLIDAY
  ADD CONSTRAINT FK_EMP_HOLIDAY_EMP_EMP_ID FOREIGN KEY (EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID) ON
  DELETE CASCADE;
  
  ALTER TABLE HRIS_EMPLOYEE_HOLIDAY
  ADD CONSTRAINT FK_EMP_HOLI_HOLI_HOLI_ID FOREIGN KEY(HOLIDAY_ID) REFERENCES HRIS_HOLIDAY_MASTER_SETUP(HOLIDAY_ID) ON
  DELETE CASCADE;
--PRABIN --NEO-HRRIS
ALTER TABLE HRIS_ASSET_SETUP
ADD QUANTITY_BALANCE number(6,0) NULL


--4th May | Somkala Pachhai | NEO_HRIS
ALTER TABLE HRIS_SERVICE_QA ADD QA_INDEX NUMBER(7,0);
--

--5th May | Somkala Pachhai | NEO_HRIS
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA DROP COLUMN QA_ID;
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA DROP COLUMN ANSWER;
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD REMARKS VARCHAR2(255 BYTE);
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA
DROP COLUMN DELETED_FLAG

CREATE TABLE HRIS_EMPLOYEE_SERVICE_QA_DTL
  (
    EMP_QA_ID          NUMBER(7,0) NOT NULL,
    QA_ID              NUMBER(7,0) NOT NULL,
    ANSWER             VARCHAR2(800 BYTE),
    STATUS             CHAR(1 BYTE) CHECK( STATUS IN ('D','E'))
  );
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA_DTL ADD CONSTRAINT FK_EMP_SRV_QA_DTL_SRV_QA_QA_ID FOREIGN KEY(QA_ID) REFERENCES HRIS_SERVICE_QA(QA_ID);
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA_DTL ADD CONSTRAINT FK_E_SV_QA_DTL_E_SV_QA_E_QA_ID FOREIGN KEY(EMP_QA_ID) REFERENCES HRIS_EMPLOYEE_SERVICE_QA(EMP_QA_ID);

ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD SERVICE_EVENT_TYPE_ID NUMBER(7,0) NOT NULL;
ALTER TABLE HRIS_EMPLOYEE_SERVICE_QA ADD CONSTRAINT FK_EMP_SRV_QA_SRV_EVT_T_ID FOREIGN KEY(SERVICE_EVENT_TYPE_ID)
REFERENCES HRIS_SERVICE_EVENT_TYPES(SERVICE_EVENT_TYPE_ID)
--


--7th May | Somkala Pachhai |NEO-HRIS
ALTER TABLE HRIS_LEAVE_MASTER_SETUP
DROP CONSTRAINT SYS_C00745074;

ALTER TABLE HRIS_LEAVE_MASTER_SETUP
DROP CONSTRAINT SYS_C00236461;

ALTER TABLE HRIS_LEAVE_MASTER_SETUP
DROP CONSTRAINT SYS_C00236466;

ALTER TABLE HRIS_LEAVE_MASTER_SETUP
DROP CONSTRAINT SYS_C00744970;

ALTER TABLE HRIS_LEAVE_MASTER_SETUP
DROP CONSTRAINT SYS_C00745022;
---


---8 May | Prabin | NEO-HRIS
ALTER TABLE HRIS_EMPLOYEES 
ADD EMPLOYEE_TYPE CHAR(1 BYTE) DEFAULT 'R' NOT NULL CHECK (EMPLOYEE_TYPE IN ('R','C'))


--8 mAY | UKESH | ITNEPAL_HRIS_APR2
DROP TABLE HRIS_HOLIDAY_BRANCH;
DROP TABLE HRIS_HOLIDAY_DESIGNATION;

ALTER TABLE HRIS_HOLIDAY_MASTER_SETUP
DROP COLUMN GENDER_ID;

-- All database updated on 8 May | APR5, APR4, MODERN, HRIS
