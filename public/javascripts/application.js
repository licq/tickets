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

    $("#city_id").autocomplete({
        source: function(request, response) {
            $.ajax({
                url: "/cities.json",
                data: "q=" + request.term,
                success: function(data) {
                    response($.map(data, function(item) {
                        return {
                            value: item.name
                        }
                    }))
                }
            });
        },
        minLength: 1
    });

    $("#today_spot_reservations_search input").keyup(function() {
        $.get($("#today_spot_reservations_search").attr("action"), $("#today_spot_reservations_search").serialize(), null, "script");
        return false;
    });

    $("#purchase_reservations_form").submit(function() {
        if ($("#purchase_reservations_form tr td input:checked").length == 0) {
            alert("至少选择一张订单");
            return false;
        } else {
            return window.confirm("确认要将选择的订单设置为已结算吗？");
        }
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

    $.myglobals = {
        used_contacts: "unset"
    };

    $("#reservation_contact").autocomplete({
        source: function(request, response) {
            $.get("/reservations/used_contacts.json", {search: request.term},
                function(data) {
                    $.myglobals.used_contacts = data;
                    response($.map(data, function(item) {
                        return {
                            value: item.contact
                        }
                    }))
                }
            );
        },
        minLength: 1,
        select: function(event, ui) {
            $.each($.myglobals.used_contacts, function() {
                if (this.contact == ui.item.value) {
                    $("#reservation_phone").val(this.phone);
                }
            });
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

    $('#individual_reservation_date').change(function() {
        window.location = window.location.pathname + "?date=" + $(this).val();
    });

    $('#team_reservation_date').change(function() {
        window.location = window.location.pathname + "?date=" + $(this).val();
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
        });
        return false;
    });
    $("#report_paginate span a").live("click", function() {
        report_paginate($(this));
        return false;
    });


    function report_paginate(obj) {
        var page_url_arr = obj.attr("href").split("?");
        var page_uri = page_url_arr[0];
        var page_params = page_url_arr[1].split("&");
        var params = {};
        for (i = 0; i < page_params.length; i++) {
            var param = page_params[i];
            var param_temp = param.split("=");
            params[param_temp[0]] = param_temp[1];
        }
        $.post(page_uri, params, function(data) {
            $("#report").html(data);
        });


    }

    $("#purchase_reservations_form :checkbox").click(calculate_total_price_for_purchase);

    $("#generate_purchase_report_button").click(generate_purchase_report);


    init_output_report_condition();

    menuFix();

});

function set_datepicker() {
    $(".start_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true,
        changeMonth: true,
        numberOfMonths: 2,
        onClose: function(dateText, inst) {
            var end_date_picker = $(this).parent().next().children(".end_datepicker");
            end_date_picker.datepicker("option", "minDate", dateText);
            end_date_picker.datepicker("show");
        }
    });


    $(".end_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true,
        changeMonth: true,
        numberOfMonths: 2
    });
    var day = new Date();
    day.setDate(day.getDate() + 1);

    $(".book_datepicker").datepicker({
        minDate: new Date(),
        changeYear: true ,
        changeMonth: true,
        numberOfMonths: 2
    });
    $(".maxdate_datepicker").datepicker({
        maxDate: new Date(),
        changeYear: true ,
        changeMonth: true ,
        numberOfMonths: 2
    });
    $(".reservation_start_datepicker").datepicker({
        changeYear: true ,
        changeMonth: true,
        numberOfMonths: 2
    });

    $(".reservation_end_datepicker").datepicker({
        changeYear: true ,
        changeMonth: true,
        numberOfMonths: 2,
        beforeShow: function(input, inst) {
            var start_picker = $(this).closest("td").prev().find(".reservation_start_datepicker");
            $(this).datepicker('option', 'minDate', $(start_picker).datepicker('getDate'));
        }
    });

    $(".report_start_datepicker").datepicker({
        changeYear: true ,
        changeMonth: true,
        numberOfMonths: 2
    });

    $(".report_end_datepicker").datepicker({
        changeYear: true ,
        changeMonth: true,
        numberOfMonths: 2,
        beforeShow: function(input, inst) {
            var start_picker = $(this).closest("div").find(".report_start_datepicker");
            $(this).datepicker('option', 'minDate', $(start_picker).datepicker('getDate'));
        }
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

    var today_date = today.year() + "-" + today.month() + "-" + today.day();
    $("#start_report_time").val(today_date);
    $("#end_report_time").val(today_date);

}

function change_output_report_condition_fields(val) {
    switch (val) {
        case "day":
            show_year();
            show_month();
            show_day();
            hide_week();
            hide_date_range();
            break;
        case "month":
            show_year();
            show_month();
            hide_day();
            hide_week();
            hide_date_range();
            break;
        case "week":
            show_year();
            show_week();
            hide_month();
            hide_day();
            hide_date_range();
            break;
        case "date_range":
            show_date_range();
            hide_year();
            hide_week();
            hide_month();
            hide_day();
            break;
    }
}

function show_year() {
    $("#year").parent().show();
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

function show_date_range() {
    $("#date_range").show();
}

function hide_year() {
    $("#year").parent().hide();
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

function hide_date_range() {
    $("#date_range").hide();
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
        if ($(this).find("td input:checked").length > 0) {
            total_price += parseInt($(this).children("td:nth-child(10)").html());
        }
    });

    $("#total_price").text(total_price);
}


function generate_purchase_report() {
    var checked_ids = "";
    $.each($("#purchase_reservations_form tr td input:checked"), function() {
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

function menuFix() {
    var sfEls = document.getElementById("nav").getElementsByTagName("li");
    for (var i = 0; i < sfEls.length; i++) {
        sfEls[i].onmouseover = function() {
            this.className += (this.className.length > 0 ? " " : "") + "sfhover";
        };
        sfEls[i].onMouseDown = function() {
            this.className += (this.className.length > 0 ? " " : "") + "sfhover";
        };
        sfEls[i].onMouseUp = function() {
            this.className += (this.className.length > 0 ? " " : "") + "sfhover";
        };
        sfEls[i].onmouseout = function() {
            this.className = this.className.replace(new RegExp("( ?|^)sfhover\\b"), "");
        }
    }
}


