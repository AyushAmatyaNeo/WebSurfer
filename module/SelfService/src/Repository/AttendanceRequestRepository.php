<?php
/**
 * Created by PhpStorm.
 * User: punam
 * Date: 10/6/16
 * Time: 3:20 PM
 */
namespace SelfService\Repository;

use Application\Model\Model;
use Application\Repository\RepositoryInterface;
use Zend\Db\Adapter\AdapterInterface;
use SelfService\Model\AttendanceRequestModel;
use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Sql\Sql;
use Zend\Db\Sql\Expression;

class AttendanceRequestRepository implements RepositoryInterface {

    private $adapter;
    private $tableGateway;
    public function __construct(AdapterInterface $adapter)
    {
        $this->tableGateway = new TableGateway(AttendanceRequestModel::TABLE_NAME,$adapter);
        $this->adapter = $adapter;
    }

    public function add(Model $model)
    {
        $this->tableGateway->insert($model->getArrayCopyForDB());
    }

    public function edit(Model $model, $id)
    {
        $array = $model->getArrayCopyForDB();
        $this->tableGateway->update($array, [AttendanceRequestModel::ID => $id]);
    }

    public function fetchAll()
    {
        $sql = new Sql($this->adapter);
        $select = $sql->select();
        $select->columns([new Expression("TO_CHAR(A.ATTENDANCE_DT, 'DD-MON-YYYY') AS ATTENDANCE_DT"),new Expression("TO_CHAR(A.IN_TIME, 'HH:MI AM') AS IN_TIME"),new Expression("TO_CHAR(A.OUT_TIME, 'HH:MI AM') AS OUT_TIME"), new Expression("E.EMPLOYEE_ID AS EMPLOYEE_ID"), new Expression("A.ID AS ID"),new Expression("A.IN_REMARKS AS IN_REMARKS"),new Expression("A.OUT_REMARKS AS OUT_REMARKS")], true);
        $select->from(['A'=>AttendanceRequestModel::TABLE_NAME])
            ->join(['E' => 'HR_EMPLOYEES'], 'A.EMPLOYEE_ID=E.EMPLOYEE_ID', ["FIRST_NAME" => 'FIRST_NAME',"MIDDLE_NAME" => 'MIDDLE_NAME',"LAST_NAME" => 'LAST_NAME']);
        $statement = $sql->prepareStatementForSqlObject($select);
        $result = $statement->execute();
        return $result;
    }

    public function fetchById($id)
    {
        $sql = new Sql($this->adapter);
        $select = $sql->select();
        $select->columns([
            new Expression("TO_CHAR(A.ATTENDANCE_DT, 'DD-MON-YYYY') AS ATTENDANCE_DT"),
            new Expression("TO_CHAR(A.IN_TIME, 'HH:MI AM') AS IN_TIME"),
            new Expression("TO_CHAR(A.OUT_TIME, 'HH:MI AM') AS OUT_TIME"),
            new Expression("E.EMPLOYEE_ID AS EMPLOYEE_ID"),
            new Expression("A.ID AS ID"),
            new Expression("A.IN_REMARKS AS IN_REMARKS"),
            new Expression("A.STATUS AS STATUS"),
            new Expression("A.OUT_REMARKS AS OUT_REMARKS"),
            new Expression("TO_CHAR(A.REQUESTED_DT, 'DD-MON-YYYY') AS REQUESTED_DT"),
            new Expression("A.APPROVED_REMARKS AS APPROVED_REMARKS"),
            new Expression("A.TOTAL_HOUR AS TOTAL_HOUR")], true);
        $select->from(['A'=>AttendanceRequestModel::TABLE_NAME])
            ->join(['E' => 'HR_EMPLOYEES'], 'A.EMPLOYEE_ID=E.EMPLOYEE_ID', ["FIRST_NAME" => 'FIRST_NAME',"MIDDLE_NAME" => 'MIDDLE_NAME',"LAST_NAME" => 'LAST_NAME'])
            ->join(['E1'=>"HR_EMPLOYEES"],"E1.EMPLOYEE_ID=A.APPROVED_BY",['FIRST_NAME1'=>"FIRST_NAME",'MIDDLE_NAME1'=>"MIDDLE_NAME",'LAST_NAME1'=>"LAST_NAME"]);

        $select->where([AttendanceRequestModel::ID=>$id]);
        $statement = $sql->prepareStatementForSqlObject($select);
        $result = $statement->execute();
        return $result->current();
    }

    public function fetchByEmpId($id)
    {
        $sql = new Sql($this->adapter);
        $select = $sql->select();
        $select->columns([new Expression("TO_CHAR(A.ATTENDANCE_DT, 'DD-MON-YYYY') AS ATTENDANCE_DT"), new Expression("TO_CHAR(A.IN_TIME, 'HH:MI AM') AS IN_TIME"), new Expression("TO_CHAR(A.OUT_TIME, 'HH:MI AM') AS OUT_TIME"), new Expression("E.EMPLOYEE_ID AS EMPLOYEE_ID"), new Expression("A.ID AS ID"), new Expression("A.IN_REMARKS AS IN_REMARKS"), new Expression("A.OUT_REMARKS AS OUT_REMARKS"), new Expression("A.TOTAL_HOUR AS TOTAL_HOUR"),new Expression("A.STATUS AS STATUS")], true);
        $select->from(['A' => AttendanceRequestModel::TABLE_NAME])
            ->join(['E' => 'HR_EMPLOYEES'], 'A.EMPLOYEE_ID=E.EMPLOYEE_ID', ["FIRST_NAME" => 'FIRST_NAME']);
        $select->where(['A.EMPLOYEE_ID'=> $id]);
        $statement = $sql->prepareStatementForSqlObject($select);
        $result = $statement->execute();
        return $result;
    }

    public function delete($id)
    {
        $this->tableGateway->update([AttendanceRequestModel::STATUS=>'C'],[AttendanceRequestModel::ID=>$id]);
    }
    public function getFilterRecords($data){
        $employeeId = $data['employeeId'];
        $attendanceRequestStatusId = $data['attendanceRequestStatusId'];
        $fromDate = $data['fromDate'];
        $toDate = $data['toDate'];
        
        $sql = new Sql($this->adapter);
        $select = $sql->select();
        $select->columns([new Expression("TO_CHAR(A.ATTENDANCE_DT, 'DD-MON-YYYY') AS ATTENDANCE_DT"), new Expression("TO_CHAR(A.IN_TIME, 'HH:MI AM') AS IN_TIME"), new Expression("TO_CHAR(A.OUT_TIME, 'HH:MI AM') AS OUT_TIME"), new Expression("E.EMPLOYEE_ID AS EMPLOYEE_ID"), new Expression("A.ID AS ID"), new Expression("A.IN_REMARKS AS IN_REMARKS"), new Expression("A.OUT_REMARKS AS OUT_REMARKS"), new Expression("A.TOTAL_HOUR AS TOTAL_HOUR"),new Expression("A.STATUS AS STATUS")], true);
        $select->from(['A' => AttendanceRequestModel::TABLE_NAME])
            ->join(['E' => 'HR_EMPLOYEES'], 'A.EMPLOYEE_ID=E.EMPLOYEE_ID', ["FIRST_NAME" => 'FIRST_NAME']);
        $select->where(['A.EMPLOYEE_ID'=> $employeeId]);
        
         if($attendanceRequestStatusId!=-1){
            $select->where([
                "A.STATUS='" . $attendanceRequestStatusId."'"
            ]);
        }
        
        if($fromDate!=null){
            $select->where([
                "A.ATTENDANCE_DT>=TO_DATE('".$fromDate."','DD-MM-YYYY')"
            ]);
        }
        if($toDate!=null){
            $select->where([
                "A.ATTENDANCE_DT<=TO_DATE('".$toDate."','DD-MM-YYYY')"
            ]);
        }
        
        $statement = $sql->prepareStatementForSqlObject($select);
        $result = $statement->execute();
        return $result;        
    }
}