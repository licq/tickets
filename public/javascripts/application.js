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

    $("#today_spot_reservations_search input").keyup(function() {
        $.get($("#today_spot_reservations_search").attr("action"), $("#today_spot_reservations_search").serialize(), null, "script");
        return false;
    });

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
    $('#team_reservation_adult_ticket_number').blur(function() {
        calculate_team_price();
    });
    $('#team_reservation_child_ticket_number').blur(function() {
        calculate_team_price();
    });

    $('#individual_reservation_adult_true_ticket_number').keyup(function() {
        calculate_individual_true_price();
    });
    $('#individual_reservation_child_true_ticket_number').keyup(function() {
        calculate_individual_true_price();
    });
    $('#team_reservation_adult_true_ticket_number').keyup(function() {
        calculate_team_true_price();
    });
    $('#team_reservation_child_true_ticket_number').keyup(function() {
        calculate_team_true_price();
    });

    calculate_individual_price();
    calculate_team_price();
});

function set_datepicker() {
    $(".start_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true,
        changeMonth: true,
        onClose: function(dateText, inst) {
            $(this).siblings(".end_datepicker").datepicker("option", "minDate", dateText);
            $(this).siblings(".end_datepicker").datepicker("show");
        }
    });


    $(".end_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true,
        changeMonth: true
    });
    var day = new Date();
    day.setDate(day.getDate() + 1);

    $(".book_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true ,
        changeMonth: true
    }
            );
    $(".reservation_datepicker").datepicker({
        changeYear: true ,
        changeMonth: true
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
    if ($("#individual_reservation_adult_ticket_number").length != 0) {
        calculate_price("individual_reservation_adult_ticket_number", "individual_reservation_adult_sale_price", "individual_reservation_child_ticket_number",
                "individual_reservation_child_sale_price", "total_price_text");
    }
}


function calculate_team_price() {
    if ($("#team_reservation_adult_ticket_number").length != 0) {
        calculate_price("team_reservation_adult_ticket_number", "team_reservation_adult_price", "team_reservation_child_ticket_number",
                "team_reservation_child_price", "total_price_text");
    }
}


function calculate_individual_true_price() {
    if ($("#individual_reservation_adult_true_ticket_number").length != 0) {
        calculate_price("individual_reservation_adult_true_ticket_number", "individual_reservation_adult_sale_price", "individual_reservation_child_true_ticket_number",
                "individual_reservation_child_sale_price", "total_price_text");
    }
}


function calculate_team_true_price() {
    if ($("#team_reservation_adult_true_ticket_number").length != 0) {
        calculate_price("team_reservation_adult_true_ticket_number", "team_reservation_adult_price", "team_reservation_child_true_ticket_number",
                "team_reservation_child_price", "total_price_text");
    }
}

function calculate_price(adult_number_id, adult_price_id, child_number_id, child_price_id, total_price_id) {
    var adult_ticket_number = $("#" + adult_number_id).val();
    var child_ticket_number = $("#" + child_number_id).val();
    var adult_price = $("#" + adult_price_id).val();
    var child_price = $("#" + child_price_id).val();
    var total_price = nan2zero(parseInt(adult_ticket_number)) * nan2zero(parseInt(adult_price));
    total_price += nan2zero(parseInt(child_ticket_number)) * nan2zero(parseInt(child_price));
    $("#" + total_price_id)[0].innerHTML = total_price;
}

function nan2zero(number) {
    if (isNaN(number)) {
        return 0;
    } else {
        return number;
    }
}



