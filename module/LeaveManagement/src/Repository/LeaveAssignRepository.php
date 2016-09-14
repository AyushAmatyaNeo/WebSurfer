<?php
/**
 * Created by PhpStorm.
 * User: ukesh
 * Date: 9/9/16
 * Time: 10:53 AM
 */

namespace LeaveManagement\Repository;


use Application\Model\Model;
use Application\Repository\RepositoryInterface;
use Zend\Db\Adapter\AdapterInterface;
use Zend\Db\Sql\Sql;
use Zend\Db\TableGateway\TableGateway;

class LeaveAssignRepository implements RepositoryInterface
{
    private $tableGateway;
    private $adapter;

    public function __construct(AdapterInterface $adapter)
    {
        $this->tableGateway = new TableGateway('HR_EMPLOYEE_LEAVE_ASSIGN', $adapter);
        $this->adapter = $adapter;
    }

    public function add(Model $model)
    {
        $this->tableGateway->insert($model->getArrayCopyForDB());
    }


    public function edit(Model $model, $id)
    {
        $array = $model->getArrayCopyForDB();
        $this->tableGateway->update($array, ["EMPLOYEE_lEAVE_ASSIGN_ID" => $id]);
    }

    public function fetchAll()
    {
        return $this->tableGateway->select();
    }

    public function fetchByEmployeeId($id)
    {
//        return $this->tableGateway->select(['EMPLOYEE_ID' => $id]);

        $sql = new Sql($this->adapter);
        $select = $sql->select();
        $select->from(['A' => "HR_EMPLOYEE_LEAVE_ASSIGN"])
            ->join(['S' => 'HR_LEAVE_MASTER_SETUP'], 'A.LEAVE_ID=S.LEAVE_ID');
        $statement = $sql->prepareStatementForSqlObject($select);
        $result = $statement->execute();
        return $result;

    }

    public function fetchById($id)
    {
        $rowset = $this->tableGateway->select(['EMPLOYEE_LEAVE_ASSIGN_ID' => $id]);
        return $rowset->current();
    }

    public function delete($id)
    {
        $this->tableGateway->delete(['EMPLOYEE_LEAVE_ASSIGN_ID' => $id]);

    }
}