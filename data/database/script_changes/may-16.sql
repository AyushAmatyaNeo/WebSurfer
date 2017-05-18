ALTER TABLE HRIS_OVERTIME MODIFY TOTAL_HOUR NUMBER(7,0);

ALTER TABLE HRIS_OVERTIME_DETAIL MODIFY TOTAL_HOUR NUMBER(7,0);

--to modify on hris_shift first need to disable constraint and after inserting new record enable it
ALTER TABLE HRIS_SHIFTS MODIFY LATE_IN NUMBER(7,0);

ALTER TABLE HRIS_SHIFTS MODIFY EARLY_OUT NUMBER(7,0);

ALTER TABLE HRIS_SHIFTS MODIFY TOTAL_WORKING_HR NUMBER(7,0) DEFAULT NULL;

ALTER TABLE HRIS_SHIFTS MODIFY ACTUAL_WORKING_HR NUMBER(7,0) DEFAULT NULL;

ALTER TABLE HRIS_PREFERENCE_SETUP MODIFY CONSTRAINT_VALUE NUMBER(7,0);


ALTER TABLE HRIS_POSITIONS ADD LEVEL_NO NUMBER(7,0) ;


--

-- TO UPDATE HRIS_MENUS FOR ASSET   
UPDATE HRIS_MENUS SET
MENU_NAME='Asset' 
WHERE MENU_ID=133;


UPDATE HRIS_MENUS SET
MENU_NAME='Asset Type',PARENT_MENU=1,MENU_INDEX=22
WHERE MENU_ID=131