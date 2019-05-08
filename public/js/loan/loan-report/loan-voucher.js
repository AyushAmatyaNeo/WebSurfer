(function ($, app) {
    'use strict';
    $(document).ready(function () {
        $("select").select2();
        $('select').select2();
        // app.datePickerWithNepali("fromDate","nepaliFromDate");
        // $('#form-paidDate').datepicker("setStartDate", new Date());
        app.startEndDatePickerWithNepali('nepaliFromDate', 'fromDate', 'nepaliToDate', 'toDate', null, true);
        var $tableContainer = $("#loanRequestStatusTable");
        var $search = $('#search');

        var columns = [
            {field: "DT", title: "Date", width: 100},
            {field: "PARTICULARS", title: "Particulars", width: 150},
            {field: "DEBIT_AMOUNT", title: "Debit Rs", width: 120},
            {field: "CREDIT_AMOUNT", title: "Credit Rs", width: 120},
            {field: "BALANCE", title: "Balance", width: 120}
        ];
 
        var map = {
            'DT': 'Date',
            'PARTICULARS': 'Particulars',
            'DEBIT_AMOUNT': 'Debit Rs',
            'CREDIT_AMOUNT': 'Credit Rs',
            'BALANCE': 'Balance'
        }
        app.initializeKendoGrid($tableContainer, columns);
        app.searchTable($tableContainer, ['FULL_NAME']);

        $search.on('click', function () {
            var employee = $("#employeeId").val();
            var fromDate = $("#fromDate").val();
            var toDate = $("#toDate").val();
            if(employee == -1 || fromDate == "" || toDate == ""){
                alert("Employee, From date and To Date are required");
                return false;
            }
            //employee = employee == -1 ? null : employee ;
            //employee = employee == -1 ? null : employee ;
            var data = { 
                'emp_id' : employee,
                'fromDate' :  fromDate,
                'toDate' :  toDate,
            };
            App.blockUI({target: "#hris-page-content"});
            window.app.pullDataById(document.pullLoanVoucherDetailsLink, data).then(function (success) {
                App.unblockUI("#hris-page-content");
                var data = success.data;
                data[0].BALANCE = data[0].DEBIT_AMOUNT;
                for(var i = 1; i < data.length; i++){
                    data[i].BALANCE = parseFloat(data[i-1].BALANCE) + parseFloat(data[i].DEBIT_AMOUNT) - parseFloat(data[i].CREDIT_AMOUNT);
                }
                app.renderKendoGrid($tableContainer, data);
            }, function (failure) {
                App.unblockUI("#hris-page-content");
            });
        });
        $('#excelExport').on('click', function () {
            app.excelExport($tableContainer, map, "Loan Request List.xlsx");
        });
        $('#pdfExport').on('click', function () {
            app.exportToPDF($tableContainer, map, "Loan Request List.pdf");
        });



    });
})(window.jQuery, window.app);
