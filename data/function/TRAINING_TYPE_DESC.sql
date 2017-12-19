create or replace FUNCTION TRAINING_TYPE_DESC(
    P_TRAINING_TYPE HRIS_EMPLOYEE_TRAINING_REQUEST.TRAINING_TYPE%TYPE)
  RETURN VARCHAR2
IS
  V_TRAINING_TYPE_DESC VARCHAR2(50 BYTE);
BEGIN
  V_TRAINING_TYPE_DESC:=
  (
    CASE P_TRAINING_TYPE
    WHEN 'CC' THEN
      'Company Contribution'
    WHEN 'RC'THEN
      'Personal'
    END);
  RETURN V_TRAINING_TYPE_DESC;
END;