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

    $("input.numeric").keydown(function(e) {
        var key = e.charCode || e.keyCode || 0;
        return ( key == 8 || key == 9 ||
                key == 46 || (key >= 37 && key <= 40) ||
                (key >= 48 && key <= 57) || (key >= 96 && key <= 105));

    });

    $('#spot_accept_rfp_dialog').click(function() {
        $('<div></div>')
                .load($(this).action)
                .dialog({
                            title: '选择旅行社价格'
                        });
        return false;
    });

    $('#individual_reservation_adult_ticket_number').blur(function() {
        calculate_individual_price();
    });
    $('#individual_reservation_child_ticket_number').blur(function() {
        calculate_individual_price();
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
    var day = new Date();
    day.setDate(day.getDate() + 1);

    $(".book_datepicker").datepicker({
        minDate: day,
        changeYear: true
    }
            );
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

function calculate_individual_price() {
    var adult_ticket_number = $("#individual_reservation_adult_ticket_number").val();
    var child_ticket_number = $("#individual_reservation_child_ticket_number").val();
    var adult_sale_price = $("#individual_reservation_adult_sale_price").val();
    var child_sale_price = $("#individual_reservation_child_sale_price").val();
    var total_price = parseInt(adult_ticket_number) * parseInt(adult_sale_price) + parseInt(child_ticket_number) * parseInt(child_sale_price);
    $("#individual_reservation_total_price").val(total_price);
    $("#total_price_text")[0].innerHTML = total_price;
}



