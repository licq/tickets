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
    if($(link).parent(".fields").siblings(".fields:visible").length == 0){
        alert('出错:至少需要一个时间段');
        return false;
    }
	$(link).prev("input[type=hidden]").val("1");
	$(link).parent(".fields").hide();
}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
	$(content.replace(regexp,new_id)).insertBefore($(link).parent());
    set_datepicker();
}
