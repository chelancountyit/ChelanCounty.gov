component extends="Controller" {

	function index() {
		content = model("Page").findOne(where="SiteID = 'assessors' AND Permalink = 'home'");
		nav = getNavigation("assessors");
	}

	function page() {
		local.slug = StructKeyExists(params, "slug") ? params.slug : (StructKeyExists(params, "key") ? params.key : "home");
		content = model("Page").findOne(where="SiteID = 'assessors' AND Permalink = '#local.slug#'");
		nav = getNavigation("assessors");
	}

}
