<?php

namespace System\Model;

use Application\Model\Model;

class AttendanceDevice extends Model {

    const TABLE_NAME = "HRIS_ATTD_DEVICE_MASTER";
    const DEVICE_ID = "DEVICE_ID";
    const DEVICE_NAME = "DEVICE_NAME";
    const DEVICE_IP = "DEVICE_IP";
    const DEVICE_LOCATION = "DEVICE_LOCATION";
    const ISACTIVE = "ISACTIVE";
    const COMPANY_ID = "COMPANY_ID";
    const BRANCH_ID = "BRANCH_ID";
    const STATUS = "STATUS";
    const DEVICE_COMPANY = "DEVICE_COMPANY";

    public $deviceId;
    public $deviceName;
    public $deviceIp;
    public $deviceLocation;
    public $isActive;
    public $companyId;
    public $branchId;
    public $status;
    public $deviceCompany;
    public $mappings = [
        'deviceId' => self::DEVICE_ID,
        'deviceName' => self::DEVICE_NAME,
        'deviceIp' => self::DEVICE_IP,
        'deviceLocation' => self::DEVICE_LOCATION,
        'isActive' => self::ISACTIVE,
        'companyId' => self::COMPANY_ID,
        'branchId' => self::BRANCH_ID,
        'status' => self::STATUS,
        'deviceCompany' => self::DEVICE_COMPANY,
    ];

}