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
});

function remove_field(link) {
	$(link).prev("input[type=hidden]").val("1");
	$(link).parent(".fields").hide();
}

function add_fields(link, association, content) {
	$(content).insertBefore($(link))
}
