component extends="Model" {

	function config() {
		table("navigation_menus");

		hasMany(name="navigationMenuItems", foreignKey="navigation_menu_id");

		validatesPresenceOf(properties="siteid,menu_key,name");
		validatesUniquenessOf(property="menu_key", scope="siteid");
	}

}

