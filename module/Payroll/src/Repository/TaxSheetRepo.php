<?php

namespace Payroll\Repository;

use Application\Model\Model;
use Application\Repository\HrisRepository;
use Payroll\Model\TaxSheet;
use Zend\Db\Adapter\AdapterInterface;

class TaxSheetRepo extends HrisRepository {

    public function __construct(AdapterInterface $adapter, $tableName = null) {
        if ($tableName == null) {
            $tableName = TaxSheet::TABLE_NAME;
        }
        parent::__construct($adapter, $tableName);
    }

    public function add(Model $model) {
        return $this->tableGateway->insert($model->getArrayCopyForDB());
    }

    public function fetchById($id) {
        return $this->tableGateway->select($id);
    }

    private function fetchPayIdsAsArray() {
        $rawList = $this->rawQuery("SELECT PAY_ID FROM HRIS_PAY_SETUP WHERE STATUS ='E'");
        $dbArray = "";
        foreach ($rawList as $key => $row) {
            if ($key == sizeof($rawList) - 1) {
                $dbArray .= "{$row['PAY_ID']} AS P_{$row['PAY_ID']}";
            } else {
                $dbArray .= "{$row['PAY_ID']} AS P_{$row['PAY_ID']},";
            }
        }
        return $dbArray;
    }

    public function fetchEmpTaxSheetPivoted($monthId, $employeeId) {
        $in = $this->fetchPayIdsAsArray();
        $sql = "SELECT P.*,
                  E.FULL_NAME AS EMPLOYEE_NAME
                FROM
                  (SELECT *
                  FROM
                    (SELECT EMPLOYEE_ID,
                      PAY_ID,
                      VAL
                    FROM HRIS_TAX_SHEET
                    WHERE SHEET_NO =
                      (SELECT SHEET_NO FROM HRIS_SALARY_SHEET WHERE MONTH_ID ={$monthId}
                      )
                    AND EMPLOYEE_ID               ={$employeeId}
                    ) PIVOT (MAX(VAL) FOR PAY_ID IN ({$in}))
                  ) P
                JOIN HRIS_EMPLOYEES E
                ON (P.EMPLOYEE_ID=E.EMPLOYEE_ID)";
        return $this->rawQuery($sql);
    }

    public function fetchEmployeeTaxSheet($monthId, $employeeId) {
        $sql = "SELECT TS.*,
                  P.PAY_TYPE_FLAG,
                  P.PAY_EDESC
                FROM HRIS_TAX_SHEET TS
                LEFT JOIN HRIS_PAY_SETUP P
                ON (TS.PAY_ID         =P.PAY_ID)
                WHERE P.INCLUDE_IN_TAX='Y'
                AND TS.SHEET_NO       =
                  (SELECT SHEET_NO FROM HRIS_SALARY_SHEET WHERE MONTH_ID ={$monthId}
                  )
                AND EMPLOYEE_ID ={$employeeId} ORDER BY P.PRIORITY_INDEX";
        return $this->rawQuery($sql);
    }

}