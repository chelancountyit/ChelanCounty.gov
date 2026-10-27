component extends="Model" {

	function config() {
		table("calendar_events");
		belongsTo(name="category", modelName="CalendarEventCategory", foreignKey="category_id");
	}

}
