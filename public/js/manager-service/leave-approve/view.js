(function ($) {
    'use strict';
    $(document).ready(function (e) {
        $("#approve").on("click", function () {
            try {
                var id = $(this);
                var parentId = id.parent(".form-group");
                var availableBalance = parseFloat($("#availableDays").val());
                var noOfDays = parseFloat($("#noOfDays").val());
                if (noOfDays > availableBalance) {
                    var errorMsgSpan = $('<span />', {
                        "class": 'errorMsgNoLeft',
                        text: "There is not enough available days...!!!"
                    });
                    parentId.append(errorMsgSpan);
                    $("#availableDaysText").css("font-weight", "bold");
                    this.disabled = true;
                } else {
                    this.disabled = false;
                }
            } catch (e) {
                console.log("onApproveBtnClick", e.message);
            }
        });
    });
})(window.jQuery, window.app);
