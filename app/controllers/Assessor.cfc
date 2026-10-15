component extends="Controller" {

	function index() {
		ensureCtaCardsSchema();
		site = getWorkspace("assessor");
		content = model("Page").findOne(where="SiteID IN ('assessor', 'assessors') AND Permalink = 'home'");
		nav = getNavigation("assessor");
		sidebars = getAttachedSidebars(content);
		ctaCards = getAttachedCtaCards(content);
		hasSidebar = isQuery(sidebars) && sidebars.recordCount > 0;
		layoutType = hasSidebar ? "right-sidebar" : "full";
	}

	function page() {
		ensureCtaCardsSchema();
		local.slug = StructKeyExists(params, "slug") ? Trim(params.slug) : (StructKeyExists(params, "key") ? Trim(params.key) : "home");
		site = getWorkspace("assessor");
		content = model("Page").findOne(where="SiteID IN ('assessor', 'assessors') AND Permalink = '#local.slug#'");
		nav = getNavigation("assessor");
		sidebars = getAttachedSidebars(content);
		ctaCards = getAttachedCtaCards(content);
		hasSidebar = isQuery(sidebars) && sidebars.recordCount > 0;
		layoutType = hasSidebar ? "right-sidebar" : "full";
	}

}
