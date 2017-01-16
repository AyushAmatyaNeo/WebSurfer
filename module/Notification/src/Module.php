<?php

namespace Notification;

use Application\Helper\SessionHelper;
use Application\Helper\Helper;
use DateTime;
use Notification\Controller\HeadNotification;
use Zend\Authentication\AuthenticationService;
use Zend\Db\Adapter\AdapterInterface;
use Zend\ModuleManager\Feature\ConfigProviderInterface;
use Zend\Mvc\ModuleRouteListener;
use Zend\Mvc\MvcEvent;

class Module implements ConfigProviderInterface {

    public function getConfig() {
        return include __DIR__ . '/../config/module.config.php';
    }

    public function onBootstrap(MvcEvent $e) {
        $eventManager = $e->getApplication()->getEventManager();
        $moduleRouteListener = new ModuleRouteListener();
        $moduleRouteListener->attach($eventManager);

        $serviceManager = $e->getApplication()->getServiceManager();
        $eventManager->attach(MvcEvent::EVENT_DISPATCH, [
            $this,
            'beforeDispatch'
                ], 100);
    }

    function beforeDispatch(MvcEvent $event) {
        SessionHelper::sessionCheck($event);


        $auth = new AuthenticationService();
        $employeeId = $auth->getStorage()->read()['employee_id'];
        $app = $event->getApplication();
        $adapter = $app->getServiceManager()->get(AdapterInterface::class);
        $event->getViewModel()->setVariable('dateCompare', function($date) {
            $startDate = DateTime::createFromFormat(Helper::PHP_DATE_FORMAT . " " . Helper::PHP_TIME_FORMAT, $date);
            $currentDate = new DateTime();
            $interval = $startDate->diff($currentDate);
            return $interval->d;
        });
        if ($employeeId == null) {
            $event->getViewModel()->setVariable("notifications", []);
        } else {
            $event->getViewModel()->setVariable("notifications", HeadNotification::getNotifications($adapter, $employeeId));
        }
    }

}
