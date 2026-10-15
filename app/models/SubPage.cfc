component extends="Model" {

	function config() {
		table("page_SubPage");
		setPrimaryKey("ID");

		belongsTo(name="page", modelName="Page", foreignKey="ContentID");
	}

}

