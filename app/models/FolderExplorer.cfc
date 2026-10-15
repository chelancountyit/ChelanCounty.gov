component extends="Model" {

	function config() {
		table("page_FolderExplorer");
		setPrimaryKey("ID");

		belongsTo(name="page", modelName="Page", foreignKey="ContentID");
	}

}

