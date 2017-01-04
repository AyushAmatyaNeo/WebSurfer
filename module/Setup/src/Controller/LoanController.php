<?php
namespace Setup\Controller;

use Application\Helper\Helper;
use Setup\Form\LoanForm;
use Setup\Model\Loan;
use Setup\Repository\LoanRepository;
use Zend\Authentication\AuthenticationService;
use Zend\Db\Adapter\AdapterInterface;
use Zend\Form\Annotation\AnnotationBuilder;
use Zend\Mvc\Controller\AbstractActionController;
use Zend\Form\Element\Select;
use Application\Helper\EntityHelper as EntityHelper2;
use Setup\Model\Designation;
use Setup\Model\Position;
use Setup\Model\ServiceType;
use Setup\Model\LoanRestriction;
use Setup\Repository\LoanRestrictionRepository;

class LoanController extends AbstractActionController{
    private $form;
    private $adapter;
    private $repository;
    private $employeeId;
    private $loanRestrictionRepo;
        
    public function __construct(AdapterInterface $adapter){
        $this->adapter = $adapter;
        $this->repository = new LoanRepository($adapter);
        $this->loanRestrictionRepo = new LoanRestrictionRepository($adapter);
        $auth = new AuthenticationService();
        $this->employeeId = $auth->getStorage()->read()['employee_id'];
    }
    public function initializeForm(){
        $builder = new AnnotationBuilder();
        $form = new LoanForm();
        $this->form = $builder->createForm($form);
    }
    
    public function indexAction(){
        $list = $this->repository->fetchActiveRecord();
        return Helper::addFlashMessagesToArray($this, ['list'=>$list]);       
    } 
    
    public function addAction(){
        $this->initializeForm();
        $request = $this->getRequest();   
       
        $designationFormElement = new Select();
        $designationFormElement->setName("designation");
        $designations = EntityHelper2::getTableKVListWithSortOption($this->adapter, Designation::TABLE_NAME, Designation::DESIGNATION_ID, [Designation::DESIGNATION_TITLE], [Designation::STATUS => 'E'], "DESIGNATION_TITLE", "ASC");
        $designationFormElement->setValueOptions($designations);
        $designationFormElement->setAttributes(["id" => "designationId", "class" => "form-control","multiple"=>"multiple"]);
        $designationFormElement->setLabel("Designation");

        $positionFormElement = new Select();
        $positionFormElement->setName("position");
        $positions = EntityHelper2::getTableKVListWithSortOption($this->adapter, Position::TABLE_NAME, Position::POSITION_ID, [Position::POSITION_NAME], [Position::STATUS => 'E'], "POSITION_NAME", "ASC");
        $positionFormElement->setValueOptions($positions);
        $positionFormElement->setAttributes(["id" => "positionId", "class" => "form-control","multiple"=>"multiple"]);
        $positionFormElement->setLabel("Position");

        $serviceTypeFormElement = new Select();
        $serviceTypeFormElement->setName("serviceType");
        $serviceTypes = EntityHelper2::getTableKVListWithSortOption($this->adapter, ServiceType::TABLE_NAME, ServiceType::SERVICE_TYPE_ID, [ServiceType::SERVICE_TYPE_NAME], [ServiceType::STATUS => 'E'], "SERVICE_TYPE_NAME", "ASC");
        $serviceTypeFormElement->setValueOptions($serviceTypes);
        $serviceTypeFormElement->setAttributes(["id" => "serviceTypeId", "class" => "form-control","multiple"=>"multiple"]);
        $serviceTypeFormElement->setLabel("Service Type");
        
        if($request->isPost()){
            $postRecord = $request->getPost();
            $this->form->setData($postRecord);
            $loanRestrictionList = array();
            
            $serviceType = $postRecord['serviceType'];
            if($serviceType!="" || $serviceType!=null){
                $serviceTypeList = implode(",",$serviceType);
                $loanRestrictionList["serviceType"]=$serviceTypeList;
            }else{
                $loanRestrictionList["serviceType"]="";
            }
            $designation = $postRecord['designation'];            
            if($designation!="" || $designation!=null){
                $designationList = implode(",",$designation);
                $loanRestrictionList["designation"]=$designationList;
            }else{
                $loanRestrictionList["designation"]="";
            }
            $position = $postRecord['position'];
            if($position!="" || $position!=null){
                $positionList = implode(",",$position);
                $loanRestrictionList["position"]=$positionList;
            }else{
                $loanRestrictionList["position"]="";
            }
            $salaryRangeFrom = $postRecord['salaryRangeFrom'];
            $salaryRangeTo = $postRecord['salaryRangeTo'];
            if($salaryRangeFrom!="" || $salaryRangeTo!==""){
               $salaryRange = $salaryRangeFrom.",".$salaryRangeTo; 
               $loanRestrictionList["salaryRange"]=$salaryRange;
            }else{
               $loanRestrictionList["salaryRange"]="";
            }
            $workingPeriodFrom = $postRecord['workingPeriodFrom'];
            $workingPeriodTo = $postRecord['workingPeriodTo'];
            if($workingPeriodFrom!="" || $workingPeriodTo!==""){
               $workingPeriod = $workingPeriodFrom.",".$workingPeriodTo; 
               $loanRestrictionList["workingPeriod"]=$workingPeriod;
            }else{
               $loanRestrictionList["workingPeriod"]=""; 
            }   
            
            if($this->form->isValid()){
               $loanModel = new Loan();   
               $loanRestrictionModel = new LoanRestriction();
               $loanModel->exchangeArrayFromForm($this->form->getData());
               $loanModel->loanId = ((int) Helper::getMaxId($this->adapter, Loan::TABLE_NAME, Loan::LOAN_ID))+1;
               $loanModel->createdDate = Helper::getcurrentExpressionDate();
               $loanModel->status = 'E';
               $loanModel->createdBy = $this->employeeId;
               $this->repository->add($loanModel);
               
               foreach($loanRestrictionList as $loanRestrictionType => $loanRestrictionValue){
                   $loanRestrictionModel->loanId = $loanModel->loanId;
                   $loanRestrictionModel->restrictionId = ((int) Helper::getMaxId($this->adapter, LoanRestriction::TABLE_NAME, LoanRestriction::RESTRICTION_ID))+1;
                   $loanRestrictionModel->restrictionType = $loanRestrictionType;
                   $loanRestrictionModel->value = $loanRestrictionValue;
                   $loanRestrictionModel->createdDate = Helper::getcurrentExpressionDate();
                   $loanRestrictionModel->status = 'E';
                   $loanRestrictionModel->createdBy = $this->employeeId;                    
                   $this->loanRestrictionRepo->add($loanRestrictionModel);
               }
              
               $this->flashmessenger()->addMessage("Loan Successfully added!!!");
               return $this->redirect()->toRoute('loan');
            }       
        }
        return Helper::addFlashMessagesToArray($this, [
            'form'=>$this->form,
            'designation'=>$designationFormElement,
            'position'=>$positionFormElement,
            'serviceType'=>$serviceTypeFormElement
                ]);              
    }
    
    public function editAction() {
        $id = (int) $this->params()->fromRoute("id");
        if ($id === 0) {
            return $this->redirect()->toRoute('loan');
        }

        $this->initializeForm();
        $request = $this->getRequest();
        
        $designationFormElement = new Select();
        $designationFormElement->setName("designation");
        $designations = EntityHelper2::getTableKVListWithSortOption($this->adapter, Designation::TABLE_NAME, Designation::DESIGNATION_ID, [Designation::DESIGNATION_TITLE], [Designation::STATUS => 'E'], "DESIGNATION_TITLE", "ASC");
        $designationFormElement->setValueOptions($designations);
        $designationFormElement->setAttributes(["id" => "designationId", "class" => "form-control","multiple"=>"multiple"]);
        $designationFormElement->setLabel("Designation");

        $positionFormElement = new Select();
        $positionFormElement->setName("position");
        $positions = EntityHelper2::getTableKVListWithSortOption($this->adapter, Position::TABLE_NAME, Position::POSITION_ID, [Position::POSITION_NAME], [Position::STATUS => 'E'], "POSITION_NAME", "ASC");
        $positionFormElement->setValueOptions($positions);
        $positionFormElement->setAttributes(["id" => "positionId", "class" => "form-control","multiple"=>"multiple"]);
        $positionFormElement->setLabel("Position");

        $serviceTypeFormElement = new Select();
        $serviceTypeFormElement->setName("serviceType");
        $serviceTypes = EntityHelper2::getTableKVListWithSortOption($this->adapter, ServiceType::TABLE_NAME, ServiceType::SERVICE_TYPE_ID, [ServiceType::SERVICE_TYPE_NAME], [ServiceType::STATUS => 'E'], "SERVICE_TYPE_NAME", "ASC");
        $serviceTypeFormElement->setValueOptions($serviceTypes);
        $serviceTypeFormElement->setAttributes(["id" => "serviceTypeId", "class" => "form-control","multiple"=>"multiple"]);
        $serviceTypeFormElement->setLabel("Service Type");
        
        $loanModel = new Loan();
        $loanRestrictionModel = new LoanRestriction();
        if (!$request->isPost()) {
            $loanModel->exchangeArrayFromDB($this->repository->fetchById($id)->getArrayCopy());
            $this->form->bind($loanModel);
            
            $loanRestrictionDetail = $this->loanRestrictionRepo->getByLoanId($id);
            $serviceTypeRestriction = explode(",",$loanRestrictionDetail['serviceType']);
            $designationRestriction = explode(",",$loanRestrictionDetail['designation']);
            $positionRestriction = explode(",",$loanRestrictionDetail['position']);
            $salaryRange = explode(",",$loanRestrictionDetail['salaryRange']);
            $workingPeriod = explode(",",$loanRestrictionDetail['workingPeriod']);
            
        } else {       
            $postRecord = $request->getPost();
            $this->form->setData($postRecord);
            
            $serviceType = $postRecord['serviceType'];
            if($serviceType!="" || $serviceType!=null){
                $serviceTypeList = implode(",",$serviceType);
                $loanRestrictionList["serviceType"]=$serviceTypeList;
            }else{
                $loanRestrictionList["serviceType"]="";
            }
            $designation = $postRecord['designation'];            
            if($designation!="" || $designation!=null){
                $designationList = implode(",",$designation);
                $loanRestrictionList["designation"]=$designationList;
            }else{
                $loanRestrictionList["designation"]="";
            }
            $position = $postRecord['position'];
            if($position!="" || $position!=null){
                $positionList = implode(",",$position);
                $loanRestrictionList["position"]=$positionList;
            }else{
                $loanRestrictionList["position"]="";
            } 
            $salaryRangeFrom = $postRecord['salaryRangeFrom'];
            $salaryRangeTo = $postRecord['salaryRangeTo'];
            if($salaryRangeFrom!="" || $salaryRangeTo!==""){
               $salaryRange = $salaryRangeFrom.",".$salaryRangeTo; 
               $loanRestrictionList["salaryRange"]=$salaryRange;
            }else{
               $loanRestrictionList["salaryRange"]="";
            }
            
            $workingPeriodFrom = $postRecord['workingPeriodFrom'];
            $workingPeriodTo = $postRecord['workingPeriodTo'];
            if($workingPeriodFrom!="" || $workingPeriodTo!==""){
               $workingPeriod = $workingPeriodFrom.",".$workingPeriodTo; 
               $loanRestrictionList["workingPeriod"]=$workingPeriod;
            }else{
               $loanRestrictionList["workingPeriod"]=""; 
            }
            
            if ($this->form->isValid()) {
                $loanModel->exchangeArrayFromForm($this->form->getData());
                $loanModel->modifiedDate = Helper::getcurrentExpressionDate();
                $loanModel->modifiedBy = $this->employeeId;
                $this->repository->edit($loanModel, $id);
                
                foreach($loanRestrictionList as $loanRestrictionType => $loanRestrictionValue){
                   $loanRestrictionModel->restrictionType = $loanRestrictionType;
                   $loanRestrictionModel->value = $loanRestrictionValue;
                   $loanRestrictionModel->modifiedDate = Helper::getcurrentExpressionDate();
                   $loanRestrictionModel->modifiedBy = $this->employeeId;                    
                   $this->loanRestrictionRepo->edit($loanRestrictionModel,$id);
               }
                
                $this->flashmessenger()->addMessage("Loan Successfully Updated!!!");
                return $this->redirect()->toRoute("loan");
            }
        }
        return Helper::addFlashMessagesToArray(
                        $this, [
                            'form' => $this->form, 
                            'id' => $id,
                            'designation'=>$designationFormElement,
                            'position'=>$positionFormElement,
                            'serviceType'=>$serviceTypeFormElement,
                            'salaryRange'=>$salaryRange,
                            'workingPeriod'=>$workingPeriod,
                            'serviceTypeRestriction'=>$serviceTypeRestriction,
                            'designationRestriction'=>$designationRestriction,
                            'positionRestriction'=>$positionRestriction
                ]
        );
    }

    public function deleteAction() {
        $id = (int) $this->params()->fromRoute("id");
        if (!$id) {
            return $this->redirect()->toRoute('loan');
        }
        $this->repository->delete($id);
        $this->flashmessenger()->addMessage("Loan Successfully Deleted!!!");
        return $this->redirect()->toRoute('loan');
    }

}