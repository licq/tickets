$(function() {
    $("#spot_city_tokens").tokenInput("/cities.json", {
        crossDomain: false,
        prePopulate: $("#spot_city_tokens").data("pre"),
        theme: "facebook",
        hintText: "输入城市名或拼音",
        preventDuplicates: true,
        searchingText: "查询中",
        noResultsText: "无结果"
    });
    set_datepicker();

    $("input.numeric").keydown(function(event) {
        var key = e.charCode || e.keyCode || 0;
        return ( key == 8 || key == 9 ||
                key == 46 || (key >= 37 && key <= 40) ||
                (key >= 48 && key <= 57) || (key >= 96 && key <= 105));

    });

});

function set_datepicker() {
    $(".start_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true,
        onClose: function(dateText, inst) {
            $(this).siblings(".end_datepicker").datepicker("option", "minDate", dateText);
            $(this).siblings(".end_datepicker").datepicker("show");
        }
    });


    $(".end_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true
    });
}

function remove_field(link) {
    if ($(link).parent(".fields").siblings(".fields:visible").length == 0) {
        alert('出错:至少需要一个时间段');
        return false;
    }
    $(link).prev("input[type=hidden]").val("1");
    $(link).parent(".fields").hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(content.replace(regexp, new_id)).insertBefore($(link).parent());
    set_datepicker();
}
