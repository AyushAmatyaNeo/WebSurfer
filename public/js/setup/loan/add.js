(function ($,app) {
    'use strict';
    $(document).ready(function () {
        $('select').select2();
        
        var inputFieldId = "form-loanName";
        var formId = "loan-form";
        var tableName =  "HR_LOAN_MASTER_SETUP";
        var columnName = "LOAN_NAME";
        var checkColumnName = "LOAN_ID";
        var selfId = $("#loanID").val();
        if (typeof(selfId) == "undefined"){
            selfId=0;
        }
        window.app.checkUniqueConstraints(inputFieldId,formId,tableName,columnName,checkColumnName,selfId);
        window.app.checkUniqueConstraints("form-loanCode",formId,tableName,"LOAN_CODE",checkColumnName,selfId);
    });
})(window.jQuery,window.app);


angular.module('hris',[])
        .controller('loanRestrictionController',function($scope,$http){
            $scope.view = function(){
                $scope.salaryRangeFrom = 8000;
            }
        });

