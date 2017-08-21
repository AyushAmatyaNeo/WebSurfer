ALTER TABLE HRIS_APPRAISAL_QUESTION
ADD (HR_FLAG CHAR(1 BYTE) DEFAULT 'N' CHECK (HR_FLAG IN ('Y','N')),
    HR_RATING CHAR(1 BYTE) DEFAULT 'N' CHECK (HR_RATING IN ('Y','N')));
    
CREATE TABLE HRIS_PAY_EMPLOYEE_SETUP
  (
    PAY_ID      NUMBER(7,0) NOT NULL,
    EMPLOYEE_ID NUMBER(7,0) NOT NULL,
    CONSTRAINT FK_PAY_EMP_PAY_ID FOREIGN KEY(PAY_ID) REFERENCES HRIS_PAY_SETUP(PAY_ID),
    CONSTRAINT FK_PAY_EMP_EMP_ID FOREIGN KEY(EMPLOYEE_ID) REFERENCES HRIS_EMPLOYEES(EMPLOYEE_ID)
  );

  
ALTER TABLE HRIS_APPRAISAL_ASSIGN
ADD IS_EXECUTIVE CHAR(1 BYTE) NULL;

ALTER TABLE HRIS_APPRAISAL_ASSIGN
ADD CONSTRAINT CHECK_IS_EXECUTIVE CHECK (IS_EXECUTIVE IN ('Y','N'));

  DROP TABLE HRIS_PAY_POSITION_SETUP;


INSERT
INTO HRIS_MENUS
  (
    MENU_CODE,
    MENU_ID,
    MENU_NAME,
    PARENT_MENU,
    MENU_DESCRIPTION,
    ROUTE,
    STATUS,
    CREATED_DT,
    MODIFIED_DT,
    ICON_CLASS,
    ACTION,
    MENU_INDEX,
    CREATED_BY,
    MODIFIED_BY,
    IS_VISIBLE
  )
  VALUES
  (
  NULL,
    (select max(menu_id+1) from HRIS_MENUS),
    'Subordinate Review',
    6,
    NULL,
    'subordinatesReview',
    'E',
      TRUNC(SYSDATE),
    NULL,
    'fa fa-pencil',
    'index',
    20,
    NULL,
    NULL,
    'Y'
    );

ALTER TABLE HRIS_APPRAISAL_ASSIGN 
ADD SUBORDINATES VARCHAR(300) NULL;


ALTER TABLE HRIS_APPRAISAL_STATUS
ADD SUBORdINATES_REVIEW VARCHAR(300) NULL;

ALTER TABLE HRIS_EMPLOYEES ADD PERMANENT_DATE DATE;

ALTER TABLE HRIS_FLAT_VALUE_DETAIL DROP COLUMN MONTH_ID;

ALTER TABLE HRIS_JOB_HISTORY ADD FROM_SALARY NUMBER(11,2);

ALTER TABLE HRIS_JOB_HISTORY ADD TO_SALARY NUMBER(11,2);
