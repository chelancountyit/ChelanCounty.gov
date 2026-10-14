<cfscript>
// Place functions here that should be available globally in your application.

public array function getNavigation(required string siteid, string menuKey = "side") {
	local.nav = [];
	local.menu = model("NavigationMenu").findOne(
		where="siteid = '#arguments.siteid#' AND menu_key = '#arguments.menuKey#' AND is_active = 1"
	);

	if (!IsObject(local.menu)) {
		return local.nav;
	}

	local.rows = model("NavigationMenuItem").findAll(
		where="navigation_menu_id = #Val(local.menu.id)# AND is_active = 1",
		order="sort_order ASC, id ASC"
	);

	if (!local.rows.recordCount) {
		return local.nav;
	}

	local.itemIds = {};
	for (local.row in local.rows) {
		local.itemIds["k_" & local.row.id] = true;
	}

	local.nodesById = {};
	local.children = {};
	for (local.row in local.rows) {
		local.pVal = (IsNumeric(local.row.parent_item_id) && Val(local.row.parent_item_id) > 0) ? Val(local.row.parent_item_id) : 0;
		if (local.pVal > 0 && !StructKeyExists(local.itemIds, "k_" & local.pVal)) {
			local.pVal = 0;
		}
		local.cKey = "k_" & local.pVal;
		if (!StructKeyExists(local.children, local.cKey)) {
			local.children[local.cKey] = [];
		}
		local.node = {
			id: local.row.id,
			title: local.row.label,
			label: local.row.label,
			url: local.row.destination,
			destination: local.row.destination,
			destinationType: local.row.destination_type == "url" ? "custom" : "page",
			parentId: local.pVal > 0 ? local.pVal : "",
			sortOrder: local.row.sort_order,
			active: local.row.is_active ? true : false,
			newWindow: local.row.open_in_new_tab ? true : false,
			icon: IsSimpleValue(local.row.icon) ? local.row.icon : "",
			children: []
		};
		local.nodesById["k_" & local.row.id] = local.node;
		ArrayAppend(local.children[local.cKey], local.node);
	}

	for (local.nodeKey in local.nodesById) {
		if (StructKeyExists(local.children, local.nodeKey)) {
			local.nodesById[local.nodeKey].children = local.children[local.nodeKey];
		}
	}

	if (StructKeyExists(local.children, "k_0")) {
		local.nav = local.children["k_0"];
	}

	return local.nav;
}
</cfscript>

