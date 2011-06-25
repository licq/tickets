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

    $("#menu_tree").jstree({
        "json_data" : {
            "ajax" : {
                "url" : $("#menus_url").html()
            }
        },

        "plugins" : [ "themes", "json_data", "ui", "checkbox" ],
        "core" : {
            "strings": { "loading" : "加载中"}
        }
    });

    jQuery("#menu_tree").bind("loaded.jstree", function (event, data) {
        var selected_menu_ids = $("#menu_ids").val() || [];
        for (var i = 0; i < selected_menu_ids.length; i++) {
            $("#menu_tree").jstree("check_node", $("#" + selected_menu_ids[i]));
        }
    });

    $("#role_form").submit(function() {
        var checked_ids = [];
        $("#menu_tree").jstree("get_checked", null, true).each(function() {
            if (this.id != '')
                checked_ids.push(this.id);
        });

        $("#menu_ids").val(checked_ids);
        $(this).submit();

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

    $('a[data-popup]').live('click', function(e) {
        window.open($(this)[0].href);
        e.preventDefault();
    });

    $('#reservation_select_all').click(function() {
        selectAllReservations($(this).attr("checked"));
    });

    $('#output_report_type').change(function() {
        change_output_report_condition_fields($(this).val());
    });

    $('#year').change(function() {
        change_year($(this).val());
    });

    $('#month').change(function() {
        change_month($(this).val());
    });

    $("#output_report_form input[type=submit]").click(function() {
        $.post($("#output_report_form").attr("action"), $("#output_report_form").serialize(), function(data) {
            $("#report").html(data);
        }, "script");
        return false;
    });


    $("#purchase_reservations_form :checkbox").click(calculate_total_price_for_purchase);

    $("#generate_purchase_report_button").click(generate_purchase_report);


    init_output_report_condition();

})
        ;

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
    $(".maxdate_datepicker").datepicker({
        maxDate: new Date(),
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

function init_output_report_condition() {
    $("#output_report_type").val("day");
    change_output_report_condition_fields("day");
    setYearOptions();
    var today = new Time();
    $("#year").val(today.year());
    change_year(today.year());
    $("#month").val(today.month());
    change_month(today.month());
    $("#day").val(today.day());

}

function change_output_report_condition_fields(val) {
    switch (val) {
        case "day":
            show_month();
            show_day();
            hide_week();
            break;
        case "month":
            show_month();
            hide_day();
            hide_week();
            break;
        case "week":
            show_week();
            hide_month();
            hide_day();
            break;
    }
}

function show_month() {
    $("#month").parent().show();
}
function show_day() {

    $("#day").parent().show();
}
function show_week() {
    $("#week").parent().show();
}

function hide_month() {
    $("#month").parent().hide();
}
function hide_day() {
    $("#day").parent().hide();
}
function hide_week() {
    $("#week").parent().hide();
}

function change_year(year) {
    if (year == new Time().year()) {
        setMonthOptions(new Time().month());
        setWeekOptions(new Time().week());
    } else {
        setMonthOptions(12);
        setWeekOptions(new Time(year).endOfYear().week());
    }
}

function change_month(month) {

    var year_int = parseInt($("#year").val());
    var month_int = parseInt(month);
    var today = new Time();
    if (year_int == today.year() && (month_int == today.month())) {
        setDayOptions(today.day());
    } else
        setDayOptions(new Time(year_int, month_int).daysInMonth());
}

function change_day(day) {
    $("#day").selected = day;
}

function setYearOptions() {
    var this_year = new Time().year();
    $("#year" + " option").remove();
    for (var i = this_year - 5; i < this_year; i ++)
        $("#year").append('<option value="' + (i + 1) + '">' + (i + 1) + '</option>');
}

function setMonthOptions(max) {
    setIntOptions("month", max);
    change_month($("#month").val());
}
function setWeekOptions(max) {
    setIntOptions("week", max);
}
function setDayOptions(max) {
    setIntOptions("day", max);
}


function setIntOptions(element, max) {
    $("#" + element + " option").remove();
    for (var i = 0; i < max; i ++)
        $("#" + element).append('<option value="' + (i + 1) + '">' + (i + 1) + '</option>');
}

function selectAllReservations(flag) {
    $("#purchase_table input[type=checkbox]").attr('checked', flag);
}

function calculate_total_price_for_purchase() {
    var total_price = 0;
    $.each($("#purchase_reservations_form tr"), function() {
        if ($(this).find("input:checked").length > 0) {
            total_price += parseInt($(this).children("td:nth-child(10)").html());
        }
    });

    $("#total_price").text(total_price);
}


function generate_purchase_report() {
    var checked_ids = "";
    $.each($("#purchase_reservations_form tr input:checked"), function() {
        checked_ids += $(this).val() + ",";
    });

    if (checked_ids.length == 0) {
        alert("至少选择一张订单");
    } else {
        checked_ids = checked_ids.substring(0, checked_ids.length - 1);
        if ($("#flag").val() == 'spot')
            window.open("/spot_purchases/report.pdf?reservation_ids=" + checked_ids + "&date=" + $("#date").val());
        else
            window.open("/agent_purchases/report.pdf?reservation_ids=" + checked_ids + "&date=" + $("#date").val());
    }
}


