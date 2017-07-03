create or replace TRIGGER UPDATE_LEAVE_BALANCE_TRIGGER BEFORE
  INSERT OR
  UPDATE ON HRIS_EMPLOYEE_LEAVE_ASSIGN FOR EACH ROW BEGIN IF (:new.PREVIOUS_YEAR_BAL IS NULL) THEN :new.PREVIOUS_YEAR_BAL:= 0 ;
END IF;
IF(:new.TOTAL_DAYS IS NULL) THEN
  :new.TOTAL_DAYS  := 0 ;
END IF;
IF(:old.BALANCE =:new.BALANCE) THEN
  :new.BALANCE := :new.PREVIOUS_YEAR_BAL + :new.TOTAL_DAYS;
END IF;
END;