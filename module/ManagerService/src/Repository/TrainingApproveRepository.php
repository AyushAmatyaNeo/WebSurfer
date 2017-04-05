<?php
namespace ManagerService\Repository;

use Application\Model\Model;
use Application\Repository\RepositoryInterface;
use Zend\Db\Adapter\AdapterInterface;
use SelfService\Model\TrainingRequest;
use Zend\Db\TableGateway\TableGateway;
use Zend\Db\Sql\Expression;
use Zend\Db\Sql\Sql;
use Setup\Model\HrEmployees;

class TrainingApproveRepository implements RepositoryInterface{
    private $tableGateway;
    private $adapter;
    
    public function __construct(\Zend\Db\Adapter\AdapterInterface $adapter) {
        $this->adapter = $adapter;
        $this->tableGateway = new TableGateway(TrainingRequest::TABLE_NAME,$adapter);
    }

    public function add(\Application\Model\Model $model) {
        
    }

    public function delete($id) {
        
    }
    public function getAllWidStatus($id,$status){
        
    }

    public function edit(\Application\Model\Model $model, $id) {
        $temp=$model->getArrayCopyForDB();
        $this->tableGateway->update($temp,[TrainingRequest::ID=>$id]);
    }

    public function fetchAll() {
        
    }

    public function fetchById($id) {
        $sql = new Sql($this->adapter);
        $select = $sql->select();
        $select->columns([
            new Expression("TR.REQUEST_ID AS REQUEST_ID"),
            new Expression("TR.EMPLOYEE_ID AS EMPLOYEE_ID"),
            new Expression("TR.TRAINING_ID AS TRAINING_ID") ,
            new Expression("TO_CHAR(TR.REQUESTED_DATE, 'DD-MON-YYYY') AS REQUESTED_DATE"),
            new Expression("TO_CHAR(TR.START_DATE, 'DD-MON-YYYY') AS FROM_DATE"),
            new Expression("TO_CHAR(TR.END_DATE, 'DD-MON-YYYY') AS TO_DATE"),
            new Expression("TR.DURATION AS DURATION"),
            new Expression("TR.DESCRIPTION AS DESCRIPTION"),
            new Expression("TR.STATUS AS STATUS"),
            new Expression("TR.TRAINING_TYPE AS TRAINING_TYPE"),
            new Expression("TR.TITLE AS TITLE"),
            new Expression("TR.REMARKS AS REMARKS"),
            new Expression("TR.RECOMMENDED_BY AS RECOMMENDED_BY"),
            new Expression("TO_CHAR(TR.RECOMMENDED_DATE, 'DD-MON-YYYY') AS RECOMMENDED_DATE"),
            new Expression("TR.RECOMMENDED_REMARKS AS RECOMMENDED_REMARKS"),
            new Expression("TR.APPROVED_BY AS APPROVED_BY"),
            new Expression("TO_CHAR(TR.APPROVED_DATE, 'DD-MON-YYYY') AS APPROVED_DATE"),
            new Expression("TR.APPROVED_REMARKS AS APPROVED_REMARKS"),
            new Expression("TO_CHAR(TR.MODIFIED_DATE, 'DD-MON-YYYY') AS MODIFIED_DATE"),
                ], true);

        $select->from(['TR' => TrainingRequest::TABLE_NAME])
            ->join(['E'=>"HRIS_EMPLOYEES"],"E.EMPLOYEE_ID=TR.EMPLOYEE_ID",['FIRST_NAME','MIDDLE_NAME','LAST_NAME'],"left")
            ->join(['E1'=>"HRIS_EMPLOYEES"],"E1.EMPLOYEE_ID=TR.RECOMMENDED_BY",['FN1'=>'FIRST_NAME','MN1'=>'MIDDLE_NAME','LN1'=>'LAST_NAME'],"left")
            ->join(['E2'=>"HRIS_EMPLOYEES"],"E2.EMPLOYEE_ID=TR.APPROVED_BY",['FN2'=>'FIRST_NAME','MN2'=>'MIDDLE_NAME','LN2'=>'LAST_NAME'],"left")
            ->join(['RA'=>"HRIS_RECOMMENDER_APPROVER"],"RA.EMPLOYEE_ID=TR.EMPLOYEE_ID",['RECOMMENDER'=>'RECOMMEND_BY','APPROVER'=>'APPROVED_BY'],"left")
            ->join(['RECM'=>"HRIS_EMPLOYEES"],"RECM.EMPLOYEE_ID=RA.RECOMMEND_BY",['RECM_FN'=>'FIRST_NAME','RECM_MN'=>'MIDDLE_NAME','RECM_LN'=>'LAST_NAME'],"left")
            ->join(['APRV'=>"HRIS_EMPLOYEES"],"APRV.EMPLOYEE_ID=RA.APPROVED_BY",['APRV_FN'=>'FIRST_NAME','APRV_MN'=>'MIDDLE_NAME','APRV_LN'=>'LAST_NAME'],"left");

        $select->where([
            "TR.REQUEST_ID=".$id
        ]);

        $statement = $sql->prepareStatementForSqlObject($select);
        $result = $statement->execute();
        return $result->current();
    }
     public function getAllRequest($id = null,$status=null)
    {
        $sql = "SELECT 
                    TR.REQUEST_ID,
                    TR.EMPLOYEE_ID,
                    TO_CHAR(TR.REQUESTED_DATE, 'DD-MON-YYYY') AS REQUESTED_DATE,
                    TR.APPROVED_BY,
                    TR.RECOMMENDED_BY,
                    TR.REMARKS,
                    TR.DURATION,
                    TR.DESCRIPTION,
                    TR.TITLE,
                    TR.STATUS,
                    TR.TRAINING_ID,
                    TR.RECOMMENDED_REMARKS,
                    TR.APPROVED_REMARKS,
                    TO_CHAR(TR.START_DATE, 'DD-MON-YYYY') AS FROM_DATE,
                    TO_CHAR(TR.END_DATE, 'DD-MON-YYYY') AS TO_DATE,
                    TO_CHAR(TR.RECOMMENDED_DATE, 'DD-MON-YYYY') AS RECOMMENDED_DATE,
                    TO_CHAR(TR.APPROVED_DATE, 'DD-MON-YYYY') AS APPROVED_DATE,
                    TO_CHAR(TR.MODIFIED_DATE, 'DD-MON-YYYY') AS MODIFIED_DATE,
                    E.FIRST_NAME,
                    E.MIDDLE_NAME,
                    E.LAST_NAME,
                    T.TRAINING_NAME,
                    T.TRAINING_CODE,
                    RA.RECOMMEND_BY as RECOMMENDER,
                    RA.APPROVED_BY AS APPROVER
                    FROM HRIS_EMPLOYEE_TRAINING_REQUEST TR
                    LEFT JOIN HRIS_TRAINING_MASTER_SETUP T ON 
                    T.TRAINING_ID=TR.TRAINING_ID
                    LEFT JOIN HRIS_EMPLOYEES E ON 
                    E.EMPLOYEE_ID=TR.EMPLOYEE_ID
                    LEFT JOIN HRIS_RECOMMENDER_APPROVER RA
                    ON E.EMPLOYEE_ID=RA.EMPLOYEE_ID
                    WHERE E.STATUS='E'
                    AND E.RETIRED_FLAG='N'";
        if($status==null){
            $sql .=" AND ((RA.RECOMMEND_BY=".$id." AND TR.STATUS='RQ') OR (RA.APPROVED_BY=".$id." AND TR.STATUS='RC') )";
        }else if($status=='RC'){
            $sql .= " AND TR.STATUS='RC' AND
                RA.RECOMMEND_BY=".$id;
        }else if($status=='AP'){
            $sql .= " AND TR.STATUS='AP' AND
                RA.APPROVED_BY=".$id;
        }else if($status=='R'){
            $sql .=" AND TR.STATUS='".$status."' AND
                ((RA.RECOMMEND_BY=".$id." AND TR.APPROVED_DATE IS NULL) OR (RA.APPROVED_BY=".$id." AND TR.APPROVED_DATE IS NOT NULL) )";
        }
        $sql .= " ORDER BY TR.REQUESTED_DATE DESC";
        $statement = $this->adapter->query($sql);
        $result = $statement->execute();
        return $result;
    }
}