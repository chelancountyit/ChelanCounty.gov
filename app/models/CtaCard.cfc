component extends="Model" {

	function config() {
		table("page_CtaCard");
		setPrimaryKey("ID");

		belongsTo(name="page", modelName="Page", foreignKey="ContentID");

		validatesPresenceOf(properties="ContentID,Title,DestinationUrl");
	}

}

