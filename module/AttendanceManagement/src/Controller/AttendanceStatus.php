<?php

namespace AttendanceManagement\Controller;

use Application\Helper\EntityHelper;
use Application\Helper\Helper;
use AttendanceManagement\Model\AttendanceDetail;
use AttendanceManagement\Repository\AttendanceDetailRepository;
use AttendanceManagement\Repository\AttendanceStatusRepository;
use Exception;
use SelfService\Form\AttendanceRequestForm;
use SelfService\Model\AttendanceRequestModel;
use SelfService\Repository\AttendanceRequestRepository;
use Setup\Model\Branch;
use Setup\Model\Department;
use Setup\Model\Designation;
use Setup\Model\Position;
use Setup\Model\ServiceEventType;
use Setup\Model\ServiceType;
use Setup\Repository\EmployeeRepository;
use Zend\Authentication\AuthenticationService;
use Zend\Db\Adapter\AdapterInterface;
use Zend\Form\Annotation\AnnotationBuilder;
use Zend\Form\Element\Select;
use Zend\Mvc\Controller\AbstractActionController;

/**
 * Created by PhpStorm.
 * User: root
 * Date: 10/25/16
 * Time: 11:57 AM
 */
class AttendanceStatus extends AbstractActionController {

    private $adapter;
    private $repository;
    private $form;
    private $userId;
    private $employeeId;

    public function __construct(AdapterInterface $adapter) {
        $this->adapter = $adapter;
        $this->repository = new AttendanceStatusRepository($adapter);
        $authService = new AuthenticationService();
        $recordDetail = $authService->getIdentity();
        $this->userId = $recordDetail['user_id'];
        $this->employeeId = $recordDetail['employee_id'];
    }

    public function initializeForm() {
        $attendanceRequestForm = new AttendanceRequestForm();
        $builder = new AnnotationBuilder();
        $this->form = $builder->createForm($attendanceRequestForm);
    }

    public function indexAction() {
        $attendanceStatus = [
            '-1' => 'All Status',
            'RQ' => 'Pending',
            'AP' => 'Approved',
            'R' => 'Rejected',
            'C' => 'Cancelled'
        ];
        $attendanceStatusFormElement = new Select();
        $attendanceStatusFormElement->setName("attendanceStatus");
        $attendanceStatusFormElement->setValueOptions($attendanceStatus);
        $attendanceStatusFormElement->setAttributes(["id" => "attendanceRequestStatusId", "class" => "form-control"]);
        $attendanceStatusFormElement->setLabel("Status");

        return Helper::addFlashMessagesToArray($this, [
                    'searchValues' => EntityHelper::getSearchData($this->adapter),
                    'attendanceStatus' => $attendanceStatusFormElement
        ]);
    }

    public function viewAction() {
        $this->initializeForm();
        $id = (int) $this->params()->fromRoute('id');

        if ($id === 0) {
            return $this->redirect()->toRoute("attendancestatus");
        }
        $attendanceRequestRepository = new AttendanceRequestRepository($this->adapter);
        $fullName = function($id) {
            $empRepository = new EmployeeRepository($this->adapter);
            $empDtl = $empRepository->fetchById($id);
            $empMiddleName = ($empDtl['MIDDLE_NAME'] != null) ? " " . $empDtl['MIDDLE_NAME'] . " " : " ";
            return $empDtl['FIRST_NAME'] . $empMiddleName . $empDtl['LAST_NAME'];
        };

        $request = $this->getRequest();
        $model = new AttendanceRequestModel();
        $detail = $attendanceRequestRepository->fetchById($id);
        $employeeId = $detail['EMPLOYEE_ID'];
        $employeeName = $fullName($detail['EMPLOYEE_ID']);

        $status = $detail['STATUS'];
        $approvedDT = $detail['APPROVED_DT'];
        $approved_by = $fullName($detail['APPROVED_BY']);
        $approverName = $fullName($detail['APPROVER']);
        $authApprover = ( $status == 'RQ' || $status == 'C' || ($status == 'R' && $approvedDT == null)) ? $approverName : $approved_by;

        $attendanceDetail = new AttendanceDetail();
        $attendanceRepository = new AttendanceDetailRepository($this->adapter);

        try {
            if (!$request->isPost()) {
                $model->exchangeArrayFromDB($detail);
                $this->form->bind($model);
            } else {
                $getData = $request->getPost();
                $reason = $getData->approvedRemarks;
                $action = $getData->submit;

                $model->approvedDt = Helper::getcurrentExpressionDate();

                if ($action == "Approve") {
                    $model->status = "AP";
                    $empAttDtl = $attendanceRepository->getDtlWidEmpIdDate($employeeId, $detail['ATTENDANCE_DT']);
                    if ($empAttDtl == null) {
                        $tempDate = $detail['ATTENDANCE_DT'];
                        throw new Exception("Attendance of employee with employeeId :$employeeId on $tempDate is not found.");
                    }

                    $attendanceDetail->inTime = Helper::getExpressionTime($detail['IN_TIME']);
                    $attendanceDetail->inRemarks = $detail['IN_REMARKS'];
                    $attendanceDetail->outTime = Helper::getExpressionTime($detail['OUT_TIME']);
                    $attendanceDetail->outRemarks = $detail['OUT_REMARKS'];
                    $attendanceDetail->totalHour = $detail['TOTAL_HOUR'];

//                $attendanceDetail->id = (int) Helper::getMaxId($this->adapter, AttendanceDetail::TABLE_NAME, AttendanceDetail::ID) + 1;
//                $attendanceRepository->add($attendanceDetail);

                    $attendanceRepository->editWith($attendanceDetail, [
                        AttendanceDetail::EMPLOYEE_ID => $employeeId,
                        AttendanceDetail::ATTENDANCE_DT => Helper::getExpressionDate($detail['ATTENDANCE_DT'])
                    ]);

                    $this->flashmessenger()->addMessage("Attendance Request Approved!!!");
                } else if ($action == "Reject") {
                    $model->status = "R";
                    $this->flashmessenger()->addMessage("Attendance Request Rejected!!!");
                }
                $model->approvedBy = $this->employeeId;
                $model->approvedRemarks = $reason;
                $attendanceRequestRepository->edit($model, $id);
                return $this->redirect()->toRoute("attendancestatus");
            }
            return Helper::addFlashMessagesToArray($this, [
                        'form' => $this->form,
                        'id' => $id,
                        'employeeName' => $employeeName,
                        'approver' => $authApprover,
                        'employeeId' => $employeeId,
                        'status' => $status,
                        'requestedDt' => $detail['REQUESTED_DT'],
            ]);
        } catch (\Exception $e) {
            $this->flashmessenger()->addMessage($e->getMessage());
            return Helper::addFlashMessagesToArray($this, [
                        'form' => $this->form,
                        'id' => $id,
                        'employeeName' => $employeeName,
                        'approver' => $authApprover,
                        'employeeId' => $employeeId,
                        'status' => $status,
                        'requestedDt' => $detail['REQUESTED_DT'],
            ]);
        }
    }

}
