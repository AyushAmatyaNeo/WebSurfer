(function ($) {
    'use strict';
    $(document).ready(function () {    
       
        $("#leaveApproveTable").kendoGrid({
            dataSource: {
                data: document.leaveApprove,
                pageSize: 20
            },
            height: 450,
            scrollable: true,
            sortable: true,
            filterable: true,
            pageable: {
                input: true,
                numeric: false
            },
            dataBound:gridDataBound,
            rowTemplate: kendo.template($("#rowTemplate").html()),
            columns: [
                {field: "FIRST_NAME", title: "Employee Name"},
                {field: "LEAVE_ENAME", title: "Leave Name"},
                {field: "APPLIED_DATE", title: "Requested Date"},
                {field: "START_DATE", title: "From Date"},
                {field: "END_DATE", title: "To Date"},
                {field: "NO_OF_DAYS", title: "Duration"},
                {field: "YOUR_ROLE", title: "Your Role"},
                {title: "Action"}
            ]
        });    
        function gridDataBound(e) {
            var grid = e.sender;
            if (grid.dataSource.total() == 0) {
                var colCount = grid.columns.length;
                $(e.sender.wrapper)
                    .find('tbody')
                    .append('<tr class="kendo-data-row"><td colspan="' + colCount + '" class="no-data">There is no data to show in the grid.</td></tr>');
            }
        };
    });   
})(window.jQuery, window.app);