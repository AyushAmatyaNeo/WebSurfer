ALTER TABLE HRIS_EMPLOYEES
ADD IS_CEO CHAR (1 BYTE) CHECK (IS_CEO IN ('Y','N'));

ALTER TABLE HRIS_EMPLOYEES
ADD IS_HR CHAR (1 BYTE) CHECK (IS_HR IN ('Y','N'));


ALTER TABLE HRIS_LEAVE_MASTER_SETUP ADD ASSIGN_ON_EMPLOYEE_SETUP CHAR(1 BYTE) DEFAULT 'Y'NOT NULL CHECK (ASSIGN_ON_EMPLOYEE_SETUP IN ('Y','N'));
ALTER TABLE HRIS_LEAVE_MASTER_SETUP ADD IS_PRODATA_BASIS CHAR(1 BYTE) DEFAULT 'Y'NOT NULL CHECK (IS_PRODATA_BASIS IN ('Y','N'));


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
    'EMP',
    325,
    'Edit My Profile',
    53,
    NULL,
    'employee',
    'E',
    to_date('13-JUL-17','DD-MON-RR'),
    NULL,
    'fa fa-wrench',
    'edit',
    44,
    NULL,
    NULL,
    'N'
  );
  

  
  
INSERT INTO HRIS_ROLE_PERMISSIONS
  (MENU_ID,ROLE_ID,STATUS
  )
SELECT (325),ROLE_ID, ('E') FROM HRIS_ROLES;

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
    328,
    'Attendance Report',
    5,
    NULL,
    'managerReport',
    'E',
    TRUNC(SYSDATE),
    NULL,
    'fa fa-pencil',
    'index',
    19,
    NULL,
    NULL,
    'Y'
  );

ALTER TABLE HRIS_HOLIDAY_MASTER_SETUP 
ADD ASSIGN_ON_EMPLOYEE_SETUP CHAR(1 BYTE) DEFAULT 'Y'NOT NULL CHECK (ASSIGN_ON_EMPLOYEE_SETUP IN ('Y','N'));


ALTER TABLE HRIS_TRAINING_MASTER_SETUP ADD IS_WITHIN_COMPANY CHAR( 1 BYTE) DEFAULT 'Y' NOT NULL CHECK (IS_WITHIN_COMPANY IN ('Y','N'));

ALTER TABLE HRIS_EMPLOYEES ADD ADDR_PERM_DISTRICT_ID NUMBER(7,0) ;
ALTER TABLE HRIS_EMPLOYEES ADD CONSTRAINT FK_EMP_DISTRICT_ID_1 FOREIGN KEY(ADDR_PERM_DISTRICT_ID) REFERENCES HRIS_DISTRICTS(DISTRICT_ID);
ALTER TABLE HRIS_EMPLOYEES ADD ADDR_PERM_ZONE_ID NUMBER(7,0);
ALTER TABLE HRIS_EMPLOYEES ADD CONSTRAINT FK_EMP_ZONE_ID FOREIGN KEY(ADDR_PERM_ZONE_ID) REFERENCES HRIS_ZONES(ZONE_ID);
ALTER TABLE HRIS_EMPLOYEES ADD ADDR_TEMP_DISTRICT_ID NUMBER(7,0);
ALTER TABLE HRIS_EMPLOYEES ADD CONSTRAINT FK_EMP_DISTRICT_ID_2 FOREIGN KEY (ADDR_TEMP_DISTRICT_ID) REFERENCES HRIS_DISTRICTS(DISTRICT_ID);
ALTER TABLE HRIS_EMPLOYEES ADD ADDR_TEMP_ZONE_ID NUMBER(7,0);
ALTER TABLE HRIS_EMPLOYEES ADD CONSTRAINT FK_EMP_ZONE_ID_2 FOREIGN KEY (ADDR_TEMP_ZONE_ID) REFERENCES HRIS_ZONES(ZONE_ID);
