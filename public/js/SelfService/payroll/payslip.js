(function ($, app) {
    'use strict';
    $(document).ready(function () {
        $('select').select2();
        var months = null;
        var $year = $('#fiscalYearId');
        var $month = $('#monthId');
        var $employeeId = $('#employeeId');
        var $viewBtn = $('#viewBtn');
        var $printBtn = $('#printBtn');
        var $paySlipBody = $('#paySlipBody');
        var $excelExport = $('#excelExport');
        var $pdfExport = $('#pdfExport');

        var employeeList = null;
        app.setFiscalMonth($year, $month, function (yearList, monthList, currentMonth) {
            months = monthList;
        });
        var showPaySlip = function ($data) {
            $paySlipBody.html('');
            var additionData = {};
            var additionCounter = 0;
            var additionSum = 0
            var deductionData = {};
            var deductionCounter = 0;
            var deductionSum = 0;
            var netSum = 0;
            var net=0;
            var add=0;
            var sub=0;
            $.each($data, function (index, item) {
                switch (item['PAY_TYPE_FLAG']) {
                    case 'A':
                        additionData[additionCounter] = item;
                        additionSum = additionSum + parseFloat(item['VAL']);
                        additionCounter++;
                        break;
                    case 'D':
                        deductionData[deductionCounter] = item;
                        deductionSum = deductionSum + parseFloat(item['VAL']);
                        deductionCounter++;
                        break;
                       
                }
                        netSum = additionSum - deductionSum;
            });
                add = parseFloat(additionSum).toFixed(2);
                sub = parseFloat(deductionSum).toFixed(2);
                net= parseFloat(netSum).toFixed(2);

            var maxRows = (additionCounter > deductionCounter) ? additionCounter : deductionCounter;
            for (var i = 0; i < maxRows; i++) {
                var $row = $(`<tr>
                                <td>${(typeof additionData[i] !== 'undefined') ? additionData[i]['PAY_EDESC'] : ''}</td>
                                <td>${(typeof additionData[i] !== 'undefined') ? additionData[i]['VAL'] : ''}</td>
                                <td>${(typeof deductionData[i] !== 'undefined') ? deductionData[i]['PAY_EDESC'] : ''}</td>
                                <td>${(typeof deductionData[i] !== 'undefined') ? deductionData[i]['VAL'] : ''}</td>
                                </tr>`);
                $paySlipBody.append($row);
            }
            $paySlipBody.append($(`<tr>
                                <td>Total Addition:</td>
                                <td>${add}</td>
                                <td>Total Deduction:</td>
                                <td>${sub}</td>
                                </tr> <td>Net Salary:</td>
                                 <td>${net}</td>`));

        };
        var showEmpDetail = function ($data) {
            for (var i in $data) {
                $(`td[key='${i}'] `).html($data[i]);
            }
        }
        $viewBtn.on('click', function () {
            
            var selectedYearText=$("#fiscalYearId option:selected" ).text();
            var selectedMonthText=$("#monthId option:selected" ).text();
         
            var monthId = $month.val();
            var employeeId = $employeeId.val();
            app.serverRequest('', {
                monthId: monthId,
                employeeId: employeeId,
            }).then(function (response) {
                // var displayYearMonthtext='Payslip of '+selectNameText+' for '+selectedMonthText+' '+selectedYearText+'('+response.data['currentMonthDate']['FROM_DATE']+'/'+response.data['currentMonthDate']['TO_DATE']+')';
                // $('#yearMonthDetails').html(displayYearMonthtext);
                var displayYearMonthtext='Payslip for '+selectedMonthText+' '+selectedYearText+'('+response.data['currentMonthDate']['FROM_DATE']+'/'+response.data['currentMonthDate']['TO_DATE']+')';
                $('#yearMonthDetails').html(displayYearMonthtext);
        
                showPaySlip(response.data['pay-detail']);
                showEmpDetail(response.data['emp-detail']);
            }, function (error) {

            });
        });

        $printBtn.on('click', function () {
            app.exportDomToPdf2($('#paySlipView'));
        });

        $pdfExport.on('click', function () {
            app.exportDomToPdf2($('#paySlipView'));
        });

    });
})(window.jQuery, window.app);