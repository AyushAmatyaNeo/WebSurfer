<?php

namespace AttendanceManagement\Controller;

use Application\Controller\HrisController;
use Application\Helper\EntityHelper;
use Application\Helper\Helper;
use Application\Model\FiscalYear;
use Application\Model\Months;
use AttendanceManagement\Repository\PenaltyRepo;
use Exception;
use Zend\Authentication\Storage\StorageInterface;
use Zend\Db\Adapter\AdapterInterface;
use Zend\View\Model\JsonModel;

class Penalty extends HrisController {

    public function __construct(AdapterInterface $adapter, StorageInterface $storage) {
        parent::__construct($adapter, $storage);
        $this->initializeRepository(PenaltyRepo::class);
    }

    public function indexAction() {
        $request = $this->getRequest();
        if ($request->isPost()) {
            try {
                $data = $request->getPost();
                $reportData = $this->repository->monthWiseReport($data);
                return new JsonModel(['success' => true, 'data' => $reportData, 'error' => '']);
            } catch (Exception $e) {
                return new JsonModel(['success' => false, 'data' => [], 'error' => $e->getMessage()]);
            }
        }

        return $this->stickFlashMessagesTo([
                    'searchValues' => EntityHelper::getSearchData($this->adapter),
                    'fiscalYears' => EntityHelper::getTableList($this->adapter, FiscalYear::TABLE_NAME, [FiscalYear::FISCAL_YEAR_ID, FiscalYear::FISCAL_YEAR_NAME]),
                    'months' => EntityHelper::getTableList($this->adapter, Months::TABLE_NAME, [Months::MONTH_ID, Months::MONTH_EDESC, Months::FISCAL_YEAR_ID]),
                    'acl' => $this->acl,
                    'employeeDetail' => $this->storageData['employee_detail'],
        ]);
    }

    public function penaltyDetailWSAction() {
        try {
            $request = $this->getRequest();
            if (!$request->isPost()) {
                throw new Exception("must be a post request.");
            }
            $data = $request->getPost();
            $reportData = $this->repository->penaltyDetail($data['employeeId'], Helper::getExpressionDate($data['attendanceDt']), $data['type']);
            return new JsonModel(['success' => true, 'data' => $reportData, 'error' => '']);
        } catch (Exception $e) {
            return new JsonModel(['success' => false, 'data' => [], 'error' => $e->getMessage()]);
        }
    }

}
