(function ($) {
    'use strict';
    $(document).ready(function () {    
       console.log(document.flatValues);
        $("#flatValueTable").kendoGrid({
            dataSource: {
                data: document.flatValues,
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
            rowTemplate: kendo.template($("#rowTemplate").html()),
            columns: [
                {field: "FLAT_CODE", title: "Code"},
                {field: "FLAT_EDESC", title: "EDesc"},
                {field: "FLAT_LDESC", title: "LDesc"},
                {field: "SHOW_AT_RULE", title: "Show At Rule"},
                {title: "Action"}
            ]
        });    
    });   
})(window.jQuery, window.app);
