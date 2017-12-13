<?php

namespace Payroll\Repository;

use Application\Helper\EntityHelper;
use Payroll\Model\PositionMonthlyValue;
use Zend\Db\Adapter\AdapterInterface;
use Zend\Db\TableGateway\TableGateway;

class PositionMonthlyValueRepo {

    private $adapter;
    private $gateway;

    public function __construct(AdapterInterface $adapter) {
        $this->adapter = $adapter;
        $this->gateway = new TableGateway(PositionMonthlyValue::TABLE_NAME, $adapter);
    }

    public function getPositionMonthlyValue($monthId) {
        $sql = "
            SELECT *
            FROM
              ( SELECT MTH_ID,POSITION_ID,ASSIGNED_VALUE FROM HRIS_POSITION_MONTHLY_VALUE WHERE MONTH_ID ={$monthId}
              ) PIVOT ( MAX(ASSIGNED_VALUE) FOR MTH_ID IN ({$this->fetchMonthlyValueAsDbArray()}) )";
        return EntityHelper::rawQueryResult($this->adapter, $sql);
    }

    private function fetchMonthlyValueAsDbArray() {
        $rawList = EntityHelper::rawQueryResult($this->adapter, "SELECT MTH_ID FROM HRIS_MONTHLY_VALUE_SETUP WHERE STATUS ='E'");
        $dbArray = "";
        foreach ($rawList as $key => $row) {
            if ($key == sizeof($rawList)) {
                $dbArray .= "{$row['MTH_ID']}";
            } else {
                $dbArray .= "{$row['MTH_ID']},";
            }
        }
        return $dbArray;
    }

    public function setPositionMonthlyValue($monthId, $positionId, $mthId, $assignedValue) {
        $sql = "
                DECLARE
                  V_MONTH_ID HRIS_POSITION_MONTHLY_VALUE.MONTH_ID%TYPE             := {$monthId};
                  V_MTH_ID HRIS_POSITION_MONTHLY_VALUE.MTH_ID%TYPE                 := {$mthId};
                  V_POSITION_ID HRIS_POSITION_MONTHLY_VALUE.POSITION_ID%TYPE       := {$positionId};
                  V_ASSIGNED_VALUE HRIS_POSITION_MONTHLY_VALUE.ASSIGNED_VALUE%TYPE := {$assignedValue};
                  V_OLD_ASSIGNED_VALUE HRIS_POSITION_MONTHLY_VALUE.ASSIGNED_VALUE%TYPE;
                BEGIN
                  SELECT ASSIGNED_VALUE
                  INTO V_OLD_ASSIGNED_VALUE
                  FROM HRIS_POSITION_MONTHLY_VALUE
                  WHERE MTH_ID    = V_MTH_ID
                  AND POSITION_ID = V_POSITION_ID
                  AND MONTH_ID    = V_MONTH_ID;
                  UPDATE HRIS_POSITION_MONTHLY_VALUE
                  SET ASSIGNED_VALUE = V_ASSIGNED_VALUE
                  WHERE MTH_ID       = V_MTH_ID
                  AND POSITION_ID    = V_POSITION_ID
                  AND MONTH_ID       = V_MONTH_ID;
                EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  INSERT
                  INTO HRIS_POSITION_MONTHLY_VALUE
                    (
                      MTH_ID,
                      POSITION_ID,
                      MONTH_ID,
                      ASSIGNED_VALUE
                    )
                    VALUES
                    (
                      V_MTH_ID,
                      V_POSITION_ID,
                      V_MONTH_ID,
                      V_ASSIGNED_VALUE
                    );
                END;";
        $statement = $this->adapter->query($sql);
        return $statement->execute();
    }

}
