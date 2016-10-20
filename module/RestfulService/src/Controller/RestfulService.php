<?php
namespace RestfulService\Controller;

use Application\Helper\Helper;
use AttendanceManagement\Controller\ShiftSetup;
use AttendanceManagement\Model\ShiftAssign;
use AttendanceManagement\Repository\ShiftAssignRepository;
use Payroll\Model\FlatValueDetail;
use Payroll\Model\MonthlyValueDetail;
use Payroll\Model\Rules;
use Payroll\Model\RulesDetail;
use Payroll\Repository\FlatValueDetailRepo;
use Payroll\Repository\MonthlyValueDetailRepo;
use Payroll\Repository\RulesDetailRepo;
use Payroll\Repository\RulesRepository;
use Zend\Authentication\AuthenticationService;
use Zend\Db\Adapter\AdapterInterface;
use Zend\Db\Adapter\Driver\ResultInterface;
use Zend\Form\Annotation\AnnotationBuilder;
use Zend\Mvc\Controller\AbstractRestfulController;
use Zend\View\Model\JsonModel;
use System\Repository\MenuSetupRepository;

class RestfulService extends AbstractRestfulController
{

    private $adapter;

    public function __construct(AdapterInterface $adapter)
    {
        $this->adapter = $adapter;
    }

    public function convertResultInterfaceIntoArray(ResultInterface $result)
    {
        $tempArray = [];
        foreach ($result as $unit) {
            array_push($tempArray, $unit);
        }
        return $tempArray;
    }

    public function indexAction()
    {
        $request = $this->getRequest();
        $responseData = [];
        if ($request->isPost()) {
            $postedData = $request->getPost();
            switch ($postedData->action) {
                case "pullEmployeeForShiftAssign":
                    $responseData = $this->pullEmployeeForShiftAssign($postedData->id);
                    break;

                case "assignEmployeeShift":
                    $responseData = assignEmployeeShift($postedData->data);
                    break;

                case "pullEmployeeMonthlyValue":
                    $responseData = $this->pullEmployeeMonthlyValue($postedData->id);
                    break;
                case "pushEmployeeMonthlyValue":
                    $responseData = $this->pushEmployeeMonthlyValue($postedData->id);
                    break;

                case "pullEmployeeFlatValue":
                    $responseData = $this->pullEmployeeFlatValue($postedData->id);
                    break;
                case "pushEmployeeFlatValue":
                    $responseData = $this->pushEmployeeFlatValue($postedData->id);
                    break;
                case "pushRule":
                    $responseData = $this->pushRule($postedData->data);
                    break;
                case "pullRule":
                    $responseData = $this->pullRule($postedData->data);
                    break;
<<<<<<< HEAD
                case "pushRuleDetail":
                    $responseData = $this->pushRuleDetail($postedData->data);
                    break;
                case "pullRuleDetailByPayId":
                    $responseData = $this->pullRuleDetailByPayId($postedData->data);
=======
                case "menu":
                    $responseData= $this->menu();
>>>>>>> 666f98817ea9e268a6b0c618a297b7a885b0e935
                    break;

                default:
                    $responseData = [
                        "success" => false
                    ];
                    break;
            }
        } else {
            $responseData = [
                "success" => false
            ];
        }
        return new JsonModel(['data' => $responseData]);
    }

    private function pullEmployeeForShiftAssign(array $ids)
    {
        $shiftAssignRepo = new ShiftAssignRepository($this->adapter);
        $result = $shiftAssignRepo->filter($ids['branchId'], $ids['departmentId'], $ids['designationId'], $ids['positionId'], $ids['serviceTypeId']);

        $tempArray = [];
        foreach ($result as $item) {
            $tmp = $shiftAssignRepo->filterByEmployeeId($item['EMPLOYEE_ID']);
            if ($tmp != null) {
                $item[ShiftAssign::SHIFT_ID] = $tmp[ShiftAssign::SHIFT_ID];
                $item[\AttendanceManagement\Model\ShiftSetup::SHIFT_ENAME] = $tmp[\AttendanceManagement\Model\ShiftSetup::SHIFT_ENAME];
            } else {
                $item[ShiftAssign::SHIFT_ID] = "";
                $item[\AttendanceManagement\Model\ShiftSetup::SHIFT_ENAME] = "";
            }
            array_push($tempArray, $item);
        }
        return [
            "success" => true,
            "data" => $tempArray
        ];
    }

    private function assignEmployeeShift($data)
    {
        $shiftAssign = new ShiftAssign();

        $shiftAssign->employeeId = $data['employeeId'];
        $shiftAssign->shiftId = $data['shiftId'];

        $shiftAssignRepo = new ShiftAssignRepository($this->adapter);
        if (!empty($data['oldShiftId'])) {
            $shiftAssignClone = clone $shiftAssign;

            unset($shiftAssignClone->employeeId);
            unset($shiftAssignClone->shiftId);
            unset($shiftAssignClone->createdDt);

            $shiftAssignClone->status = 'D';
            $shiftAssignClone->modifiedDt = Helper::getcurrentExpressionDate();
            $shiftAssignRepo->edit($shiftAssignClone, [$data['employeeId'], $data['oldShiftId']]);

            $shiftAssign->createdDt = Helper::getcurrentExpressionDate();
            $shiftAssign->status = 'E';
            $shiftAssignRepo->add($shiftAssign);
        } else {
            $shiftAssign->createdDt = Helper::getcurrentExpressionDate();
            $shiftAssign->status = 'E';
            $shiftAssignRepo->add($shiftAssign);
        }

        return [
            "success" => true,
            "data" => $data
        ];
    }

    private function pullEmployeeMonthlyValue(array $data)
    {
        $monValDetRepo = new MonthlyValueDetailRepo($this->adapter);
        $empListRaw = $monValDetRepo->fetchEmployees($data['branch'], $data['department'], $data['designation']);
        $empListP = [];
        foreach ($empListRaw as $key => $emp) {
            $empListP[$key] = $emp;
        }
        $empList = [];
        $mthIds = $data['monthlyValues'];

        $mthVal = [];
        foreach ($mthIds as $mthId) {
            $tempData = $monValDetRepo->filter($data['branch'], $data['department'], $data['designation'], $mthId);
            $tempOutput = [];
            foreach ($tempData as $key => $val) {
                $val['MTH_ID'] = $mthId;
                array_push($tempOutput, $val);
            }
            array_push($mthVal, $tempOutput);

        }
//                    foreach ($empListRaw as $key => $val) {
//
//                        foreach ($mthVal as $mthValUnit) {
//                            print "a";
//                            print_r($mthValUnit);
//                            print "b";
//                            print_r($val);
//                            if (array_key_exists($key - 1, $mthValUnit)) {
//                                $val[$mthValUnit[$key - 1]['MTH_ID']] = floatval(($mthValUnit[$key - 1]['MTH_VALUE'] == null) ? 0 : $mthValUnit[$key - 1]['MTH_VALUE']);
//                            }
//                        }
//                        $empList[$key] = $val;
//                    }
        $counter = 0;
        foreach ($mthVal as $mthValUnit) {
            foreach ($empListP as $key => $val) {
                if ($counter == 0) {
                    $empList[$key] = $val;
                }
                foreach ($mthValUnit as $key1 => $val1) {
                    if ($val['EMPLOYEE_ID'] == $val1['EMPLOYEE_ID']) {
                        $empList[$key][$val1['MTH_ID']] = floatval($val1['MTH_VALUE']);

                        break;
                    } else {
                        $empList[$key][$val1['MTH_ID']] = floatval("0");
                    }
                }
            }
            $counter++;
        }
        return [
            "success" => true,
            "data" => $empList
        ];
    }

    private function pushEmployeeMonthlyValue(array $data)
    {
        $monValDet = new MonthlyValueDetail();
        $monValDet->employeeId = $data['employeeId'];
        $monValDet->mthId = $data['mthId'];
        $monValDet->mthValue = $data['value'];
        unset($monValDet->branchId);
        unset($monValDet->companyId);

        $monValDetRepo = new MonthlyValueDetailRepo($this->adapter);
        if ($monValDetRepo->fetchById([$data['employeeId'], $data['mthId']]) == null) {
            $monValDet->createdDt = Helper::getcurrentExpressionDate();
            $monValDet->status = 'E';
            $monValDetRepo->add($monValDet);
        } else {
            unset($monValDet->status);
            unset($monValDet->createdDt);
            unset($monValDet->employeeId);
            unset($monValDet->mthId);
            $monValDet->modifiedDt = Helper::getcurrentExpressionDate();
            $monValDetRepo->edit($monValDet, [$data['employeeId'], $data['mthId']]);
        }

        return [
            "success" => true,
            "data" => $data
        ];
    }

    private function pullEmployeeFlatValue(array $data)
    {
        $flatValDetRepo = new FlatValueDetailRepo($this->adapter);
        $empListRaw = $flatValDetRepo->fetchEmployees($data['branch'], $data['department'], $data['designation']);
        $empListP = [];
        foreach ($empListRaw as $key => $emp) {
            $empListP[$key] = $emp;
        }
        $empList = [];
        $mthIds = $data['flatValues'];

        $mthVal = [];
        foreach ($mthIds as $mthId) {
            $tempData = $flatValDetRepo->filter($data['branch'], $data['department'], $data['designation'], $mthId);
            $tempOutput = [];
            foreach ($tempData as $key => $val) {
                $val['MTH_ID'] = $mthId;
                array_push($tempOutput, $val);
            }
            array_push($mthVal, $tempOutput);

        }
        $counter = 0;
        foreach ($mthVal as $mthValUnit) {
            foreach ($empListP as $key => $val) {
                if ($counter == 0) {
                    $empList[$key] = $val;
                }
                foreach ($mthValUnit as $key1 => $val1) {
                    if ($val['EMPLOYEE_ID'] == $val1['EMPLOYEE_ID']) {
                        $empList[$key][$val1['FLAT_ID']] = floatval($val1['FLAT_VALUE']);

                        break;
                    } else {
                        $empList[$key][$val1['FLAT_ID']] = floatval("0");
                    }
                }
            }
            $counter++;
        }

        return [
            "success" => true,
            "data" => $empList
        ];

    }

    private function pushEmployeeFlatValue(array $data)
    {
        $flatValDet = new FlatValueDetail();
        $flatValDet->employeeId = $data['employeeId'];
        $flatValDet->flatId = $data['flatId'];
        $flatValDet->flatValue = $data['value'];
        unset($flatValDet->branchId);
        unset($flatValDet->companyId);

        $flatValDetRepo = new FlatValueDetailRepo($this->adapter);
        if ($flatValDetRepo->fetchById([$data['employeeId'], $data['flatId']]) == null) {
            $flatValDet->createdDt = Helper::getcurrentExpressionDate();
            $flatValDet->status = 'E';
            $flatValDetRepo->add($flatValDet);
        } else {
            unset($flatValDet->status);
            unset($flatValDet->createdDt);
            unset($flatValDet->employeeId);
            unset($flatValDet->flatId);
            $flatValDet->modifiedDt = Helper::getcurrentExpressionDate();
            $flatValDetRepo->edit($flatValDet, [$data['employeeId'], $data['flatId']]);
        }

        return [
            "success" => true,
            "data" => $data
        ];
    }

    private function pushRule(array $data = null)
    {
        $repository = new RulesRepository($this->adapter);
        $auth = new AuthenticationService();

        $rulesValue = new Rules();
        $rulesValue->exchangeArrayFromForm($data);
        if ($rulesValue->payId != NULL) {
            $payId = $rulesValue->payId;
            unset($rulesValue->payId);
            unset($rulesValue->createdDt);
            unset($rulesValue->createdBy);
            unset($rulesValue->status);
            unset($rulesValue->refRuleFlag);

            $rulesValue->modifiedDt = Helper::getcurrentExpressionDate();
            $rulesValue->modifiedBy = $auth->getStorage()->read()['user_id'];
            $repository->edit($rulesValue, $payId);
            return ["success" => true, "message" => "Rule successfully edited"];

        } else {
            $rulesValue->payId = ((int)Helper::getMaxId($this->adapter, Rules::TABLE_NAME, Rules::PAY_ID)) + 1;
            $rulesValue->createdDt = Helper::getcurrentExpressionDate();
            $rulesValue->status = 'E';
            $rulesValue->refRuleFlag = 'N';

            $rulesValue->createdBy = $auth->getStorage()->read()['user_id'];
            $repository->add($rulesValue);
            return ["success" => true, "message" => "Rule successfully added", "data" => ["payId" => $rulesValue->payId]];
        }
    }

    private function pullRule(array $data = null)
    {
        $repository = new RulesRepository($this->adapter);
        return ["success" => true, "message" => "Rule successfully added", "data" => ["rule" => $repository->fetchById($data['ruleId'])]];
    }

<<<<<<< HEAD
    private function pushRuleDetail(array $data = null)
    {
        $repository = new RulesDetailRepo($this->adapter);
        $ruleDetail = new RulesDetail();

        $ruleDetail->payId = $data['payId'];
        $ruleDetail->mnenonicName = $data['mnenonicName'];
        if ($data['srNo'] == null) {
            $ruleDetail->srNo = 1;
            $repository->add($ruleDetail);
            return ["success" => true, "data" => $data];

        } else {
            $payId=$ruleDetail->payId;
            unset($ruleDetail->payId);
            $repository->edit($ruleDetail,[RulesDetail::PAY_ID=>$payId]);
            $ruleDetail->srNo = $data['srNo'];
        }


    }

    private function pullRuleDetailByPayId(array $data = null)
    {
        $repository = new RulesDetailRepo($this->adapter);
        $payDetail = $repository->fetchById($data["payId"]);
        return ["success" => true, "data" => $payDetail];

=======
    private function menu($parent_menu=null)
    {
        $menuSetupRepository = new MenuSetupRepository($this->adapter);
        $result = $menuSetupRepository->getHierarchicalMenu($parent_menu);
        $num = count($result);
        if ($num > 0) {
            $temArray = array();
            foreach ($result as $row) {
                $children =  $this->menu($row['MENU_ID']);
                if($children){
                    $temArray[] = array(
                        "text" => $row['MENU_NAME'],
                        "id"=>$row['MENU_ID'],
                        "icon" => "fa fa-folder icon-state-success",
                        "children" =>$children
                    );
                }else{
                    $temArray[] = array(
                        "text" => $row['MENU_NAME'],
                        "id"=>$row['MENU_ID'],
                        "icon" => "fa fa-folder icon-state-success"
                    );
                }
            }
            return  $temArray;
        } else {
            return false;
        }
>>>>>>> 666f98817ea9e268a6b0c618a297b7a885b0e935
    }
}