<cfscript>
// Place functions here that should be available globally in your application.

/**
 * Resolves all candidate SiteID values for a workspace identifier using cms_workspaces
 * (code, alias, virtual_directory) plus singular/plural and 'site-' prefix variations.
 */
public array function resolveCandidateSiteIds(required string siteid) {
	local.candidates = [];
	local.raw = LCase(Trim(arguments.siteid));
	if (!Len(local.raw)) {
		return local.candidates;
	}
	ArrayAppend(local.candidates, local.raw);

	if (Right(local.raw, 1) == "s" && Len(local.raw) > 1) {
		local.singular = Left(local.raw, Len(local.raw) - 1);
		if (!ArrayFindNoCase(local.candidates, local.singular)) ArrayAppend(local.candidates, local.singular);
	} else {
		local.plural = local.raw & "s";
		if (!ArrayFindNoCase(local.candidates, local.plural)) ArrayAppend(local.candidates, local.plural);
	}

	try {
		local.wsRows = queryExecute("
			SELECT LOWER(LTRIM(RTRIM(code))) AS code,
			       LOWER(LTRIM(RTRIM(ISNULL(alias, '')))) AS alias,
			       LOWER(LTRIM(RTRIM(ISNULL(virtual_directory, '')))) AS vdir
			FROM cms_workspaces
			WHERE deletedat IS NULL AND is_active = 1
		", {}, { datasource: "ChelanCountyWebsite" });

		for (local.w in local.wsRows) {
			if (
				ArrayFindNoCase(local.candidates, local.w.code)
				|| (Len(local.w.alias) && ArrayFindNoCase(local.candidates, local.w.alias))
				|| (Len(local.w.vdir) && ArrayFindNoCase(local.candidates, local.w.vdir))
			) {
				if (Len(local.w.code) && !ArrayFindNoCase(local.candidates, local.w.code)) ArrayAppend(local.candidates, local.w.code);
				if (Len(local.w.alias) && !ArrayFindNoCase(local.candidates, local.w.alias)) ArrayAppend(local.candidates, local.w.alias);
				if (Len(local.w.vdir) && !ArrayFindNoCase(local.candidates, local.w.vdir)) ArrayAppend(local.candidates, local.w.vdir);
			}
		}
	} catch (any e) {}

	for (local.c in Duplicate(local.candidates)) {
		if (Left(local.c, 5) == "site-") {
			local.noSite = Mid(local.c, 6, Len(local.c));
			if (Len(local.noSite) && !ArrayFindNoCase(local.candidates, local.noSite)) ArrayAppend(local.candidates, local.noSite);
		} else {
			local.withSite = "site-" & local.c;
			if (!ArrayFindNoCase(local.candidates, local.withSite)) ArrayAppend(local.candidates, local.withSite);
		}
	}

	return local.candidates;
}

public array function getNavigation(required string siteid, string menuKey = "side") {
	local.nav = [];
	local.candidates = resolveCandidateSiteIds(arguments.siteid);
	if (!ArrayLen(local.candidates)) {
		return local.nav;
	}

	local.params = {
		menuKey: { value: Trim(arguments.menuKey), cfsqltype: "cf_sql_nvarchar", maxlength: 100 }
	};
	local.placeholders = [];
	for (local.i = 1; local.i <= ArrayLen(local.candidates); local.i++) {
		local.pName = "site" & local.i;
		ArrayAppend(local.placeholders, ":" & local.pName);
		local.params[local.pName] = { value: local.candidates[local.i], cfsqltype: "cf_sql_nvarchar", maxlength: 100 };
	}

	local.menus = queryExecute("
		SELECT TOP 1 id, siteid, name
		FROM navigation_menus
		WHERE siteid IN (" & ArrayToList(local.placeholders, ", ") & ")
		  AND menu_key = :menuKey
		  AND deletedat IS NULL
		  AND (is_active = 1 OR is_active IS NULL)
		ORDER BY id ASC
	", local.params, { datasource: "ChelanCountyWebsite" });

	if (!local.menus.recordCount) {
		return local.nav;
	}

	local.rows = queryExecute("
		SELECT id, parent_item_id, label, destination_type, destination,
		       sort_order, is_active, open_in_new_tab, icon
		FROM navigation_menu_items
		WHERE navigation_menu_id = :menuId
		  AND deletedat IS NULL
		  AND is_active = 1
		ORDER BY sort_order ASC, id ASC
	", {
		menuId: { value: Val(local.menus.id), cfsqltype: "cf_sql_integer" }
	}, { datasource: "ChelanCountyWebsite" });

	if (!local.rows.recordCount) {
		return local.nav;
	}

	local.itemIds = {};
	for (local.row in local.rows) {
		local.itemIds["k_" & local.row.id] = true;
	}

	local.wsSlug = ReReplaceNoCase(LCase(Trim(arguments.siteid)), "^site-", "");
	if (local.wsSlug == "assessors") {
		local.wsSlug = "assessor";
	}
	local.wsBasePath = "/" & local.wsSlug;

	// Track known and published+active page slugs in this workspace so Draft/Inactive pages are excluded from navigation
	local.knownPageSlugs = {};
	local.publishedActiveSlugs = {};
	try {
		local.pagePlaceholders = [];
		local.pageParams = {};
		for (local.i = 1; local.i <= ArrayLen(local.candidates); local.i++) {
			local.ppName = "navPageSite" & local.i;
			ArrayAppend(local.pagePlaceholders, ":" & local.ppName);
			local.pageParams[local.ppName] = { value: local.candidates[local.i], cfsqltype: "cf_sql_nvarchar", maxlength: 100 };
		}
		local.qWorkspacePages = queryExecute("
			SELECT LOWER(LTRIM(RTRIM(Permalink))) AS slug,
			       StatusCode,
			       isPublished,
			       Visibility,
			       DeletedAt
			FROM dbo.pages
			WHERE SiteID IN (" & ArrayToList(local.pagePlaceholders, ", ") & ")
		", local.pageParams, { datasource: "ChelanCountyWebsite" });

		for (local.pRow in local.qWorkspacePages) {
			if (Len(local.pRow.slug)) {
				local.knownPageSlugs[local.pRow.slug] = true;
				if (
					!Len(Trim(ToString(local.pRow.DeletedAt ?: "")))
					&& CompareNoCase(Trim(local.pRow.StatusCode ?: ""), "Active") == 0
					&& (local.pRow.isPublished == 1 || local.pRow.isPublished == true)
					&& CompareNoCase(Trim(local.pRow.Visibility ?: ""), "Published") == 0
				) {
					local.publishedActiveSlugs[local.pRow.slug] = true;
				}
			}
		}
	} catch (any eNavPages) {}

	local.nodesById = {};
	local.children = {};
	for (local.row in local.rows) {
		local.destUrl = Trim(local.row.destination ?: "");
		if (Len(local.destUrl) && !REFindNoCase("^https?://", local.destUrl)) {
			if (Left(local.destUrl, 1) != "/" && Left(local.destUrl, 1) != "##") {
				local.destUrl = "/" & local.destUrl;
			}
			local.destUrl = REReplaceNoCase(local.destUrl, "\.cfm$", "", "one");
			if (Len(local.wsSlug) && local.row.destination_type != "url") {
				if (
					CompareNoCase(local.destUrl, local.wsBasePath) == 0
					|| CompareNoCase(local.destUrl, local.wsBasePath & "/home") == 0
					|| CompareNoCase(local.destUrl, local.wsBasePath & "/index") == 0
					|| CompareNoCase(local.destUrl, local.wsBasePath & "/page/home") == 0
					|| CompareNoCase(local.destUrl, local.wsBasePath & "/page/index") == 0
					|| CompareNoCase(local.destUrl, "/home") == 0
					|| CompareNoCase(local.destUrl, "/index") == 0
					|| CompareNoCase(local.destUrl, "/") == 0
				) {
					local.destUrl = local.wsBasePath;
				} else if (REFindNoCase("^" & local.wsBasePath & "/(?!page/)[^/]+/?$", local.destUrl)) {
					local.slugPart = ReReplaceNoCase(local.destUrl, "^" & local.wsBasePath & "/+", "", "one");
					local.slugPart = ReReplace(local.slugPart, "/+$", "", "one");
					local.destUrl = local.wsBasePath & "/page/" & local.slugPart;
				} else if (REFindNoCase("^" & local.wsBasePath & "/page/[^/]+/?$", local.destUrl)) {
					// already in /ws/page/slug format
				} else if (!FindNoCase(local.wsBasePath, local.destUrl)) {
					local.slugPart = ReReplace(local.destUrl, "^/+", "", "one");
					local.slugPart = ReReplace(local.slugPart, "/+$", "", "one");
					if (Len(local.slugPart)) {
						local.destUrl = local.wsBasePath & "/page/" & local.slugPart;
					}
				}
				if (local.destUrl != Trim(local.row.destination ?: "")) {
					try {
						queryExecute("
							UPDATE navigation_menu_items
							SET destination = :dest, updatedat = SYSUTCDATETIME()
							WHERE id = :id
						", {
							dest: { value: local.destUrl, cfsqltype: "cf_sql_nvarchar", maxlength: 1000 },
							id: { value: Val(local.row.id), cfsqltype: "cf_sql_integer" }
						}, { datasource: "ChelanCountyWebsite" });
					} catch (any errHeal) {}
				}
			}
		}

		// Skip internal workspace pages that exist in dbo.pages but are not both Active and Published
		if (Len(local.destUrl) && local.row.destination_type != "url" && REFindNoCase("^" & local.wsBasePath & "/page/([^/?##]+)", local.destUrl)) {
			local.targetPageSlug = LCase(ReReplaceNoCase(local.destUrl, "^" & local.wsBasePath & "/page/([^/?##]+).*$", "\1", "one"));
			if (
				StructKeyExists(local.knownPageSlugs, local.targetPageSlug)
				&& !StructKeyExists(local.publishedActiveSlugs, local.targetPageSlug)
			) {
				StructDelete(local.itemIds, "k_" & local.row.id);
				continue;
			}
		}

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
			url: local.destUrl,
			destination: local.destUrl,
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

public boolean function isPagePublishedAndActive(any page = "") {
	if (!isObject(arguments.page)) {
		return false;
	}
	if (StructKeyExists(arguments.page, "DeletedAt") && Len(Trim(ToString(arguments.page.DeletedAt)))) {
		return false;
	}
	if (StructKeyExists(arguments.page, "StatusCode") && CompareNoCase(Trim(arguments.page.StatusCode), "Active") != 0) {
		return false;
	}
	if (StructKeyExists(arguments.page, "isPublished") && !(arguments.page.isPublished == 1 || arguments.page.isPublished == true)) {
		return false;
	}
	if (StructKeyExists(arguments.page, "Visibility") && CompareNoCase(Trim(arguments.page.Visibility), "Published") != 0) {
		return false;
	}
	return true;
}

public query function getAttachedSidebars(any page = "") {
	local.empty = queryNew("ID,ContentID,SiteID,Title,Body,Position");
	if (!isPagePublishedAndActive(arguments.page)) {
		return local.empty;
	}
	if (StructKeyExists(arguments.page, "LayoutType") && Len(Trim(arguments.page.LayoutType)) && !ListFindNoCase("Right Sidebar,Sidebar,right-sidebar", Trim(arguments.page.LayoutType))) {
		return local.empty;
	}
	if (StructKeyExists(arguments.page, "SidebarIDs") && Trim(arguments.page.SidebarIDs) == "[]") {
		return local.empty;
	}

	// Respect page LayoutType: if set to Full (anything other than Right Sidebar), do not attach sidebars
	local.rawLayout = StructKeyExists(arguments.page, "LayoutType") ? Trim(ToString(arguments.page.LayoutType ?: "")) : "";
	if (CompareNoCase(local.rawLayout, "Right Sidebar") != 0 && CompareNoCase(local.rawLayout, "right-sidebar") != 0) {
		return local.empty;
	}

	local.sidebarIds = [];
	local.hasExplicitSidebarConfig = false;
	if (StructKeyExists(arguments.page, "SidebarIDs") && Len(Trim(arguments.page.SidebarIDs))) {
		local.hasExplicitSidebarConfig = true;
		local.rawList = [];
		try {
			if (IsJSON(Trim(arguments.page.SidebarIDs))) {
				local.parsed = DeserializeJSON(Trim(arguments.page.SidebarIDs));
				if (IsArray(local.parsed)) {
					local.rawList = local.parsed;
				}
			} else {
				local.rawList = ListToArray(Trim(arguments.page.SidebarIDs));
			}
		} catch (any e) {
			local.rawList = [];
		}

		for (local.item in local.rawList) {
			local.cleanId = ReReplaceNoCase(Trim(ToString(local.item)), "^subpage-", "");
			if (IsNumeric(local.cleanId) && Int(Val(local.cleanId)) > 0 && !ArrayFind(local.sidebarIds, Int(Val(local.cleanId)))) {
				ArrayAppend(local.sidebarIds, Int(Val(local.cleanId)));
			}
		}
	}

	if (ArrayLen(local.sidebarIds)) {
		return model("SubPage").findAll(
			where="ID IN (#ArrayToList(local.sidebarIds)#)",
			order="Position ASC, ID ASC"
		);
	}

	// Only fall back to ContentID lookup if SidebarIDs was never configured (null/empty string), not when explicitly "[]"
	if (!local.hasExplicitSidebarConfig && StructKeyExists(arguments.page, "ContentID") && IsNumeric(arguments.page.ContentID) && Val(arguments.page.ContentID) > 0) {
		return model("SubPage").findAll(
			where="ContentID = #Val(arguments.page.ContentID)#",
			order="Position ASC, ID ASC"
		);
	}

	return local.empty;
}

public void function ensureCtaCardsSchema() {
	if (StructKeyExists(application, "ctaCardsSchemaReady") && application.ctaCardsSchemaReady == true) {
		return;
	}
	try {
		queryExecute("
			IF COL_LENGTH(N'dbo.pages', N'hasCtaCards') IS NULL
			BEGIN
				ALTER TABLE dbo.pages ADD hasCtaCards BIT NOT NULL CONSTRAINT DF_pages_hasCtaCards DEFAULT (0);
			END;
			IF COL_LENGTH(N'dbo.pages', N'ctaSectionTitle') IS NULL
			BEGIN
				ALTER TABLE dbo.pages ADD ctaSectionTitle NVARCHAR(255) NULL CONSTRAINT DF_pages_ctaSectionTitle DEFAULT (N'Quick Services & Online Tools');
			END;
			IF OBJECT_ID(N'dbo.page_CtaCard', N'U') IS NULL
			BEGIN
				CREATE TABLE dbo.page_CtaCard (
					ID               INT IDENTITY(1,1) NOT NULL,
					ContentID        INT            NOT NULL,
					SiteID           NVARCHAR(100)  NOT NULL CONSTRAINT DF_page_CtaCard_SiteID DEFAULT (N'global'),
					Title            NVARCHAR(255)  NOT NULL,
					ShortDescription NVARCHAR(500)  NULL,
					DestinationUrl   NVARCHAR(500)  NOT NULL,
					ImagePath        NVARCHAR(500)  NULL,
					ImageAlt         NVARCHAR(255)  NULL,
					ButtonText       NVARCHAR(100)  NULL CONSTRAINT DF_page_CtaCard_ButtonText DEFAULT (N'Learn More'),
					ButtonIcon       NVARCHAR(100)  NULL CONSTRAINT DF_page_CtaCard_ButtonIcon DEFAULT (N'fa-arrow-right'),
					OpenInNewTab     BIT            NOT NULL CONSTRAINT DF_page_CtaCard_OpenInNewTab DEFAULT (0),
					SortOrder        INT            NOT NULL CONSTRAINT DF_page_CtaCard_SortOrder DEFAULT (0),
					IsActive         BIT            NOT NULL CONSTRAINT DF_page_CtaCard_IsActive DEFAULT (1),
					CreatedAt        DATETIME2(0)   NOT NULL CONSTRAINT DF_page_CtaCard_CreatedAt DEFAULT (SYSDATETIME()),
					CreatedBy        NVARCHAR(255)  NULL,
					ModifiedAt       DATETIME2(0)   NULL,
					ModifiedBy       NVARCHAR(255)  NULL,
					CONSTRAINT PK_page_CtaCard PRIMARY KEY CLUSTERED (ID)
				);
				CREATE NONCLUSTERED INDEX IX_page_CtaCard_ContentID
					ON dbo.page_CtaCard (SiteID, ContentID, SortOrder);
			END;
			IF COL_LENGTH(N'dbo.page_CtaCard', N'CreatedAt') IS NULL
			BEGIN
				ALTER TABLE dbo.page_CtaCard ADD CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_page_CtaCard_CreatedAt DEFAULT (SYSDATETIME());
			END;
			IF COL_LENGTH(N'dbo.page_CtaCard', N'CreatedBy') IS NULL
			BEGIN
				ALTER TABLE dbo.page_CtaCard ADD CreatedBy NVARCHAR(255) NULL;
			END;
			IF COL_LENGTH(N'dbo.page_CtaCard', N'ModifiedAt') IS NULL
			BEGIN
				ALTER TABLE dbo.page_CtaCard ADD ModifiedAt DATETIME2(0) NULL;
			END;
			IF COL_LENGTH(N'dbo.page_CtaCard', N'ModifiedBy') IS NULL
			BEGIN
				ALTER TABLE dbo.page_CtaCard ADD ModifiedBy NVARCHAR(255) NULL;
			END;
		", {}, { datasource: "ChelanCountyWebsite" });

		queryExecute("
			DECLARE @AssessorHomeContentID INT;
			DECLARE @AssessorSiteID NVARCHAR(100);
			SELECT TOP 1
				@AssessorHomeContentID = ContentID,
				@AssessorSiteID = SiteID
			FROM dbo.pages
			WHERE LOWER(LTRIM(RTRIM(SiteID))) IN (N'assessor', N'assessors', N'site-assessor', N'site-assessors')
			  AND LOWER(LTRIM(RTRIM(Permalink))) = N'home'
			  AND DeletedAt IS NULL
			ORDER BY ContentID ASC;

			IF @AssessorHomeContentID IS NOT NULL
			BEGIN
				IF NOT EXISTS (SELECT 1 FROM dbo.page_CtaCard WHERE ContentID = @AssessorHomeContentID)
				BEGIN
					UPDATE dbo.pages
					SET hasCtaCards = 1,
					    ctaSectionTitle = ISNULL(NULLIF(LTRIM(RTRIM(ctaSectionTitle)), N''), N'Quick Services & Online Tools')
					WHERE ContentID = @AssessorHomeContentID;

					INSERT INTO dbo.page_CtaCard (
						ContentID, SiteID, Title, ShortDescription, DestinationUrl, ImagePath, ImageAlt, ButtonText, ButtonIcon, OpenInNewTab, SortOrder, IsActive, CreatedBy
					)
					VALUES
					(@AssessorHomeContentID, @AssessorSiteID, N'Parcel & Sale Search', N'Look up property details, assessed valuations, tax history, and verified market sales.', N'/assessor/page/parcel-and-sale-search', N'/images/picjumbo/parcel16x9.jpg', N'', N'Search Parcels', N'fa-arrow-right', 0, 1, 1, N'System'),
					(@AssessorHomeContentID, @AssessorSiteID, N'Interactive GIS Map', N'Explore county parcel boundaries, aerial photography, tax code areas, and zoning layers.', N'https://maps.chelancounty.gov/GIS/', N'/images/picjumbo/mapping.jpg', N'', N'Open Map', N'fa-arrow-up-right-from-square', 1, 2, 1, N'System'),
					(@AssessorHomeContentID, @AssessorSiteID, N'Property Owner''s Guide', N'Comprehensive reference covering assessments, market valuation cycles, and rights.', N'/files/assessor/documents/propertyownerguide.pdf', N'/images/picjumbo/propownguideimage.jpg', N'', N'Download PDF', N'fa-file-pdf text-danger', 1, 3, 1, N'System'),
					(@AssessorHomeContentID, @AssessorSiteID, N'Destroyed Property', N'File for property valuation adjustment and tax relief due to disaster, calamity, or fire damage.', N'/assessor/page/destroyed-property-exemptions', N'/images/picjumbo/fire-house.jpg', N'', N'View Relief Forms', N'fa-arrow-right', 0, 4, 1, N'System'),
					(@AssessorHomeContentID, @AssessorSiteID, N'Assessment Appeals', N'Learn how to file a petition with the Chelan County Board of Equalization if you dispute your valuation.', N'/assessor/page/appeals', N'/images/picjumbo/property-claim.jpg', N'', N'Appeal Instructions', N'fa-arrow-right', 0, 5, 1, N'System'),
					(@AssessorHomeContentID, @AssessorSiteID, N'Document Search', N'Access official recorded deeds, land surveys, plats, and legal public records via AcclaimWeb.', N'https://acclaim.co.chelan.wa.us/acclaimweb', N'/images/picjumbo/liberty16x9.jpg', N'', N'Search Records', N'fa-arrow-up-right-from-square', 1, 6, 1, N'System');
				END
			END;
		", {}, { datasource: "ChelanCountyWebsite" });

		application.ctaCardsSchemaReady = true;
	} catch (any e) {
		application.ctaCardsLastError = e.message & " | " & (e.detail ?: "");
	}
}

public query function getAttachedCtaCards(any page = "") {
	ensureCtaCardsSchema();
	local.empty = queryNew("ID,ContentID,SiteID,Title,ShortDescription,DestinationUrl,ImagePath,ImageAlt,ButtonText,ButtonIcon,OpenInNewTab,SortOrder,IsActive");
	if (!isPagePublishedAndActive(arguments.page)) {
		return local.empty;
	}
	if (StructKeyExists(arguments.page, "hasCtaCards") && (arguments.page.hasCtaCards == false || Val(arguments.page.hasCtaCards) == 0)) {
		return local.empty;
	}
	if (StructKeyExists(arguments.page, "ContentID") && IsNumeric(arguments.page.ContentID) && Val(arguments.page.ContentID) > 0) {
		try {
			local.qCards = queryExecute("
				SELECT c.ID, c.ContentID, c.SiteID, c.Title, c.ShortDescription, c.DestinationUrl,
				       c.ImagePath, c.ImageAlt, c.ButtonText, c.ButtonIcon, c.OpenInNewTab, c.SortOrder, c.IsActive
				FROM dbo.page_CtaCard c
				INNER JOIN dbo.pages p ON p.ContentID = c.ContentID
				WHERE c.ContentID = :contentId
				  AND p.DeletedAt IS NULL
				  AND p.StatusCode = 'Active'
				  AND p.isPublished = 1
				  AND p.Visibility = 'Published'
				  AND p.hasCtaCards = 1
				  AND (c.IsActive = 1 OR c.IsActive IS NULL)
				ORDER BY c.SortOrder ASC, c.ID ASC
			", {
				contentId: { value: Val(arguments.page.ContentID), cfsqltype: "cf_sql_integer" }
			}, { datasource: "ChelanCountyWebsite" });

			if (local.qCards.recordCount > 0) {
				return local.qCards;
			}

			if (
				StructKeyExists(arguments.page, "Permalink") && LCase(Trim(arguments.page.Permalink)) == "home"
				&& StructKeyExists(arguments.page, "SiteID") && Len(Trim(arguments.page.SiteID))
			) {
				local.qStudio = queryExecute("
					SELECT cta.id AS ID,
					       :contentId AS ContentID,
					       cta.siteid AS SiteID,
					       cta.title AS Title,
					       cta.description AS ShortDescription,
					       cta.link_url AS DestinationUrl,
					       cta.image_url AS ImagePath,
					       cta.image_alt AS ImageAlt,
					       cta.link_text AS ButtonText,
					       cta.link_icon AS ButtonIcon,
					       cta.target_blank AS OpenInNewTab,
					       cta.sort_order AS SortOrder,
					       cta.is_published AS IsActive
					FROM dbo.page_call_to_actions cta
					WHERE LOWER(LTRIM(RTRIM(cta.siteid))) = LOWER(:siteId)
					  AND cta.is_published = 1
					  AND cta.deletedat IS NULL
					ORDER BY cta.sort_order ASC, cta.id ASC
				", {
					contentId: { value: Val(arguments.page.ContentID), cfsqltype: "cf_sql_integer" },
					siteId: { value: Trim(arguments.page.SiteID), cfsqltype: "cf_sql_nvarchar" }
				}, { datasource: "ChelanCountyWebsite" });
				if (local.qStudio.recordCount > 0) {
					return local.qStudio;
				}
			}
			return local.qCards;
		} catch (any e) {
			return local.empty;
		}
	}
	return local.empty;
}

public void function ensureFolderExplorerSchema() {
	if (StructKeyExists(application, "folderExplorerSchemaReady") && application.folderExplorerSchemaReady == true) {
		return;
	}
	try {
		queryExecute("
			IF COL_LENGTH(N'dbo.pages', N'hasArchive') IS NULL
			BEGIN
				ALTER TABLE dbo.pages ADD hasArchive BIT NOT NULL CONSTRAINT DF_pages_hasArchive DEFAULT (0);
			END;
			IF OBJECT_ID(N'dbo.page_FolderExplorer', N'U') IS NULL
			BEGIN
				CREATE TABLE dbo.page_FolderExplorer (
					ID           INT IDENTITY(1,1) NOT NULL,
					ContentID    INT           NULL,
					SiteID       NVARCHAR(100) NOT NULL CONSTRAINT DF_page_FolderExplorer_SiteID DEFAULT (N'global'),
					Title        NVARCHAR(255) NOT NULL,
					RelativePath NVARCHAR(500) NULL,
					AbsolutePath NVARCHAR(500) NULL,
					Absolute     BIT           NOT NULL CONSTRAINT DF_page_FolderExplorer_Absolute  DEFAULT (0),
					Weight       INT           NOT NULL CONSTRAINT DF_page_FolderExplorer_Weight    DEFAULT (0),
					Layout       NVARCHAR(50)  NOT NULL CONSTRAINT DF_page_FolderExplorer_Layout    DEFAULT (N'Full'),
					Placement    NVARCHAR(20)  NOT NULL CONSTRAINT DF_page_FolderExplorer_Placement DEFAULT (N'After'),
					CONSTRAINT PK_page_FolderExplorer PRIMARY KEY CLUSTERED (ID)
				);
				CREATE NONCLUSTERED INDEX IX_page_FolderExplorer_ContentID
					ON dbo.page_FolderExplorer (SiteID, ContentID);
			END;
		", {}, { datasource: "ChelanCountyWebsite" });
		application.folderExplorerSchemaReady = true;
	} catch (any e) {
		application.folderExplorerLastError = e.message & " | " & (e.detail ?: "");
	}
}

public query function getAttachedFolderExplorers(any page = "") {
	ensureFolderExplorerSchema();
	local.empty = queryNew("ID,ContentID,SiteID,Title,RelativePath,AbsolutePath,Absolute,Weight,Layout,Placement");
	if (!isPagePublishedAndActive(arguments.page)) {
		return local.empty;
	}
	if (StructKeyExists(arguments.page, "hasArchive") && (arguments.page.hasArchive == false || Val(arguments.page.hasArchive) == 0)) {
		return local.empty;
	}
	if (StructKeyExists(arguments.page, "ContentID") && IsNumeric(arguments.page.ContentID) && Val(arguments.page.ContentID) > 0) {
		try {
			return queryExecute("
				SELECT f.ID, f.ContentID, f.SiteID, f.Title, f.RelativePath, f.AbsolutePath,
				       f.Absolute, f.Weight, f.Layout, f.Placement
				FROM dbo.page_FolderExplorer f
				INNER JOIN dbo.pages p ON p.ContentID = f.ContentID
				WHERE f.ContentID = :contentId
				  AND p.DeletedAt IS NULL
				  AND p.StatusCode = 'Active'
				  AND p.isPublished = 1
				  AND p.Visibility = 'Published'
				  AND p.hasArchive = 1
				ORDER BY f.Weight ASC, f.ID ASC
			", {
				contentId: { value: Val(arguments.page.ContentID), cfsqltype: "cf_sql_integer" }
			}, { datasource: "ChelanCountyWebsite" });
		} catch (any e) {
			return local.empty;
		}
	}
	return local.empty;
}

public struct function resolveFolderExplorerRoot(
	string absolutePath = "",
	string relativePath = "",
	string siteId = "assessor"
) {
	local.rawAbs = Trim(arguments.absolutePath);
	local.rawRel = Trim(arguments.relativePath);
	local.cleanRel = ReReplace(Replace(local.rawRel, "\", "/", "all"), "^/+|/+$", "", "all");
	if (!Len(local.cleanRel)) {
		local.cleanRel = "files/assessors";
	}

	local.candidates = [];
	if (Len(local.rawAbs)) {
		ArrayAppend(local.candidates, local.rawAbs);
	}
	if (Len(local.cleanRel)) {
		local.winRel = Replace(local.cleanRel, "/", "\", "all");
		try {
			ArrayAppend(local.candidates, ExpandPath("/" & local.cleanRel));
		} catch (any e) {}
		ArrayAppend(local.candidates, "C:\inetpub\CMSAdmin2.0\" & local.winRel);
		ArrayAppend(local.candidates, "C:\inetpub\wwwroot\" & local.winRel);
		ArrayAppend(local.candidates, "C:\inetpub\ChelanCounty.gov\" & local.winRel);
	}

	local.resolvedDisk = "";
	for (local.cand in local.candidates) {
		local.normCand = ReReplace(Trim(local.cand), "[\\/]+$", "", "one");
		if (Len(local.normCand) && DirectoryExists(local.normCand)) {
			local.resolvedDisk = local.normCand;
			break;
		}
	}

	// Fallback to workspace files directory in CMSAdmin2.0 if a custom slug was used for RelativePath
	if (!Len(local.resolvedDisk)) {
		local.wsClean = LCase(ReReplaceNoCase(Trim(arguments.siteId), "^site-", ""));
		local.wsFallbacks = [
			"C:\inetpub\CMSAdmin2.0\files\" & local.wsClean,
			"C:\inetpub\CMSAdmin2.0\files\assessors",
			"C:\inetpub\CMSAdmin2.0\files\assessor",
			"C:\inetpub\wwwroot\files\assessor"
		];
		for (local.fb in local.wsFallbacks) {
			if (DirectoryExists(local.fb)) {
				local.resolvedDisk = local.fb;
				break;
			}
		}
	}

	return {
		diskPath: local.resolvedDisk,
		relativePath: local.cleanRel,
		webDisplayUrl: "chelancounty.gov/" & local.cleanRel
	};
}

public string function formatExplorerFileSize(required numeric bytes) {
	if (arguments.bytes < 1024) {
		return arguments.bytes & " B";
	} else if (arguments.bytes < 1048576) {
		return NumberFormat(arguments.bytes / 1024, "0.0") & " KB";
	} else if (arguments.bytes < 1073741824) {
		return NumberFormat(arguments.bytes / 1048576, "0.0") & " MB";
	}
	return NumberFormat(arguments.bytes / 1073741824, "0.00") & " GB";
}

public struct function getExplorerFileBadge(required string ext) {
	local.e = LCase(Trim(arguments.ext));
	switch (local.e) {
		case "pdf":
			return { label: "PDF", badgeClass: "fe-badge-pdf", icon: "fa-solid fa-file-pdf", openInNewTab: true };
		case "xls": case "xlsx": case "csv":
			return { label: "XLS", badgeClass: "fe-badge-xls", icon: "fa-solid fa-file-excel", openInNewTab: false };
		case "doc": case "docx": case "rtf":
			return { label: "DOC", badgeClass: "fe-badge-doc", icon: "fa-solid fa-file-word", openInNewTab: false };
		case "ppt": case "pptx":
			return { label: "PPT", badgeClass: "fe-badge-ppt", icon: "fa-solid fa-file-powerpoint", openInNewTab: false };
		case "jpg": case "jpeg": case "png": case "gif": case "webp": case "svg":
			return { label: UCase(local.e), badgeClass: "fe-badge-img", icon: "fa-solid fa-file-image", openInNewTab: true };
		case "zip": case "7z": case "tar": case "gz":
			return { label: "ZIP", badgeClass: "fe-badge-zip", icon: "fa-solid fa-file-zipper", openInNewTab: false };
		default:
			return { label: Len(local.e) ? Left(UCase(local.e), 4) : "FILE", badgeClass: "fe-badge-file", icon: "fa-solid fa-file-lines", openInNewTab: true };
	}
}

public numeric function scanFolderExplorerDir(
	required struct treeResult,
	required numeric explorerId,
	required string currentDiskPath,
	required string relSubPath,
	required string folderKey,
	required string folderLabel,
	required numeric depth
) {
	if (arguments.depth > 3 || !DirectoryExists(arguments.currentDiskPath)) {
		return 0;
	}
	local.skipFiles = "README.txt,.gitkeep,thumbs.db,.DS_Store,desktop.ini";
	local.skipDirs = "_thumbs,.git,.svn,__MACOSX";
	local.qList = DirectoryList(arguments.currentDiskPath, false, "query", "", "name ASC");
	local.subDirs = [];
	local.directFiles = 0;

	for (local.row in local.qList) {
		if (FindNoCase("H", local.row.attributes ?: "")) {
			continue;
		}
		if (CompareNoCase(local.row.type, "Dir") == 0) {
			if (!ListFindNoCase(local.skipDirs, local.row.name) && Left(local.row.name, 1) != ".") {
				ArrayAppend(local.subDirs, local.row);
			}
		} else if (CompareNoCase(local.row.type, "File") == 0) {
			if (ListFindNoCase(local.skipFiles, local.row.name) || Left(local.row.name, 1) == ".") {
				continue;
			}
			local.ext = ListLen(local.row.name, ".") > 1 ? LCase(ListLast(local.row.name, ".")) : "";
			local.badgeInfo = getExplorerFileBadge(local.ext);
			local.relFile = Len(arguments.relSubPath) ? (arguments.relSubPath & "/" & local.row.name) : local.row.name;
			local.viewUrl = "/assessor/file?fe=" & Val(arguments.explorerId) & "&file=" & UrlEncodedFormat(local.relFile);
			local.downloadUrl = local.viewUrl & "&download=1";

			local.cleanName = local.row.name;
			ArrayAppend(arguments.treeResult.files, {
				name: local.row.name,
				displayName: local.cleanName,
				extension: local.ext,
				badgeLabel: local.badgeInfo.label,
				badgeClass: local.badgeInfo.badgeClass,
				iconClass: local.badgeInfo.icon,
				openInNewTab: local.badgeInfo.openInNewTab,
				sizeBytes: Val(local.row.size),
				sizeFormatted: formatExplorerFileSize(Val(local.row.size)),
				dateModified: local.row.dateLastModified,
				dateFormatted: IsDate(local.row.dateLastModified) ? DateFormat(local.row.dateLastModified, "mmm d, yyyy") : "",
				folderKey: arguments.folderKey,
				folderLabel: arguments.folderLabel,
				relativeSubPath: arguments.relSubPath,
				relativeFilePath: local.relFile,
				viewUrl: local.viewUrl,
				downloadUrl: local.downloadUrl
			});
			local.directFiles++;
			if (arguments.folderKey == "root") {
				arguments.treeResult.rootFileCount++;
			}
			arguments.treeResult.totalFileCount++;
		}
	}

	local.totalInBranch = local.directFiles;
	for (local.dRow in local.subDirs) {
		local.childRel = Len(arguments.relSubPath) ? (arguments.relSubPath & "/" & local.dRow.name) : local.dRow.name;
		local.childKey = ReReplace(LCase(local.childRel), "[^a-z0-9/_-]", "-", "all");
		local.childDisplayLabel = Replace(local.dRow.name, "_", " ", "all");
		local.childFullLabel = (arguments.folderKey == "root") ? local.childDisplayLabel : (arguments.folderLabel & " / " & local.childDisplayLabel);
		local.folderIdx = ArrayLen(arguments.treeResult.folders) + 1;
		ArrayAppend(arguments.treeResult.folders, {
			key: local.childKey,
			name: local.dRow.name,
			label: local.childDisplayLabel,
			fullLabel: local.childFullLabel,
			relativePath: local.childRel,
			parentKey: arguments.folderKey,
			depth: arguments.depth,
			fileCount: 0,
			totalFileCount: 0
		});
		local.childTotal = scanFolderExplorerDir(
			treeResult = arguments.treeResult,
			explorerId = arguments.explorerId,
			currentDiskPath = arguments.currentDiskPath & "\" & local.dRow.name,
			relSubPath = local.childRel,
			folderKey = local.childKey,
			folderLabel = local.childFullLabel,
			depth = arguments.depth + 1
		);
		local.childDirect = 0;
		for (local.fItem in arguments.treeResult.files) {
			if (local.fItem.folderKey == local.childKey) {
				local.childDirect++;
			}
		}
		arguments.treeResult.folders[local.folderIdx].fileCount = local.childDirect;
		arguments.treeResult.folders[local.folderIdx].totalFileCount = local.childTotal;
		local.totalInBranch += local.childTotal;
	}
	return local.totalInBranch;
}

public struct function loadFolderExplorerTree(
	required numeric explorerId,
	string absolutePath = "",
	string relativePath = "",
	string siteId = "assessor"
) {
	local.resolved = resolveFolderExplorerRoot(
		absolutePath = arguments.absolutePath,
		relativePath = arguments.relativePath,
		siteId = arguments.siteId
	);
	local.result = {
		diskPath: local.resolved.diskPath,
		relativePath: local.resolved.relativePath,
		webDisplayUrl: local.resolved.webDisplayUrl,
		exists: Len(local.resolved.diskPath) > 0 && DirectoryExists(local.resolved.diskPath),
		folders: [],
		files: [],
		rootFileCount: 0,
		totalFileCount: 0
	};

	if (!local.result.exists) {
		return local.result;
	}

	scanFolderExplorerDir(
		treeResult = local.result,
		explorerId = Val(arguments.explorerId),
		currentDiskPath = local.resolved.diskPath,
		relSubPath = "",
		folderKey = "root",
		folderLabel = "Root Directory",
		depth = 1
	);

	return local.result;
}

/**
 * Darkens a hex color (#RRGGBB or #RGB) by a multiplier (default 0.38)
 * to produce the deep companion stop for the department hero gradient banner.
 */
public string function darkenHexColor(required string hexColor, numeric factor = 0.38) {
	local.clean = ReReplaceNoCase(Trim(arguments.hexColor), "^##", "");
	if (Len(local.clean) == 3 && REFindNoCase("^[0-9a-f]{3}$", local.clean)) {
		local.clean = Mid(local.clean, 1, 1) & Mid(local.clean, 1, 1)
			& Mid(local.clean, 2, 1) & Mid(local.clean, 2, 1)
			& Mid(local.clean, 3, 1) & Mid(local.clean, 3, 1);
	}
	if (Len(local.clean) != 6 || !REFindNoCase("^[0-9a-f]{6}$", local.clean)) {
		return "##0f2c46";
	}
	local.r = Max(0, Min(255, Round(InputBaseN(Mid(local.clean, 1, 2), 16) * arguments.factor)));
	local.g = Max(0, Min(255, Round(InputBaseN(Mid(local.clean, 3, 2), 16) * arguments.factor)));
	local.b = Max(0, Min(255, Round(InputBaseN(Mid(local.clean, 5, 2), 16) * arguments.factor)));

	return "##" & LCase(
		Right("0" & FormatBaseN(local.r, 16), 2)
		& Right("0" & FormatBaseN(local.g, 16), 2)
		& Right("0" & FormatBaseN(local.b, 16), 2)
	);
}

/**
 * Retrieves workspace configuration and theme/brand color from cms_workspaces
 * for a given siteid/workspace code.
 */
public struct function getWorkspace(required string siteid) {
	local.defaultColor = "##004879";
	local.defaultDark = darkenHexColor(local.defaultColor);
	local.ws = {
		code: LCase(Trim(arguments.siteid)),
		name: "",
		type: "dept",
		color: local.defaultColor,
		colorDark: local.defaultDark,
		heroGradient: "linear-gradient(135deg, " & local.defaultColor & " 0%, " & local.defaultDark & " 100%)",
		description: "",
		department: "",
		department_category: ""
	};

	local.candidates = resolveCandidateSiteIds(arguments.siteid);
	if (!ArrayLen(local.candidates)) {
		return local.ws;
	}

	local.params = {};
	local.placeholders = [];
	for (local.i = 1; local.i <= ArrayLen(local.candidates); local.i++) {
		local.pName = "wsSite" & local.i;
		ArrayAppend(local.placeholders, ":" & local.pName);
		local.params[local.pName] = { value: LCase(local.candidates[local.i]), cfsqltype: "cf_sql_nvarchar", maxlength: 100 };
	}
	local.inList = ArrayToList(local.placeholders, ", ");

	try {
		local.qWs = queryExecute("
			SELECT TOP 1 id, code, name, alias, type, badge, badge_class, icon, description,
			       folder_path, virtual_directory, redirect_url, department, department_category,
			       contact_first_name, contact_last_name, contact_email, contact_phone, contact_fax,
			       address, address2, city, state, zip, office_hours, color,
			       leadership_type, job_title, contact_photo, assets_domain
			FROM cms_workspaces
			WHERE deletedat IS NULL
			  AND is_active = 1
			  AND (
			      LOWER(LTRIM(RTRIM(code))) IN (" & local.inList & ")
			      OR LOWER(LTRIM(RTRIM(ISNULL(alias, '')))) IN (" & local.inList & ")
			      OR LOWER(LTRIM(RTRIM(ISNULL(virtual_directory, '')))) IN (" & local.inList & ")
			  )
			ORDER BY sort_order ASC, id ASC
		", local.params, { datasource: "ChelanCountyWebsite" });

		if (local.qWs.recordCount > 0) {
			local.rawColor = StructKeyExists(local.qWs, "color") && Len(Trim(local.qWs.color))
				? Trim(local.qWs.color)
				: (local.qWs.type == "site" ? "##10b981" : "##7e22ce");
			if (Left(local.rawColor, 1) != "##") {
				local.rawColor = "##" & local.rawColor;
			}
			if (!REFindNoCase("^##[0-9a-fA-F]{3,6}$", local.rawColor)) {
				local.rawColor = local.defaultColor;
			}
			local.darkColor = darkenHexColor(local.rawColor);

			local.ws.id = local.qWs.id;
			local.ws.code = Trim(local.qWs.code);
			local.ws.name = Trim(local.qWs.name);
			local.ws.type = Trim(local.qWs.type);
			local.ws.color = LCase(local.rawColor);
			local.ws.colorDark = local.darkColor;
			local.ws.heroGradient = "linear-gradient(135deg, " & local.ws.color & " 0%, " & local.ws.colorDark & " 100%)";
			local.ws.description = Trim(local.qWs.description ?: "");
			local.ws.department = Trim(local.qWs.department ?: "");
			local.ws.department_category = Trim(local.qWs.department_category ?: "");
			local.ws.phone = Trim(local.qWs.contact_phone ?: "");
			local.ws.fax = Trim(local.qWs.contact_fax ?: "");
			local.ws.email = Trim(local.qWs.contact_email ?: "");
			local.ws.address = Trim(local.qWs.address ?: "");
			local.ws.address2 = Trim(local.qWs.address2 ?: "");
			local.ws.city = Trim(local.qWs.city ?: "");
			local.ws.state = Trim(local.qWs.state ?: "");
			local.ws.zip = Trim(local.qWs.zip ?: "");
			local.ws.office_hours = Trim(local.qWs.office_hours ?: "");
			local.ws.leadership_type = Trim(local.qWs.leadership_type ?: "");
			local.ws.job_title = Trim(local.qWs.job_title ?: "");
			local.ws.contacttitle = Len(Trim(local.qWs.job_title ?: "")) ? Trim(local.qWs.job_title) : Trim(local.qWs.name ?: "");
			local.ws.contact_photo = Trim(local.qWs.contact_photo ?: "");
			local.ws.officialPhoto = Len(Trim(local.qWs.contact_photo ?: "")) ? Trim(local.qWs.contact_photo) : "";
			local.ws.assets_domain = StructKeyExists(local.qWs, "assets_domain") && !IsNull(local.qWs.assets_domain) ? ReReplace(Trim(local.qWs.assets_domain), "/+$", "", "all") : "";

			if (Len(Trim(local.qWs.contact_first_name ?: "")) && Len(Trim(local.qWs.contact_last_name ?: ""))) {
				local.ws.contactfirstname = Trim(local.qWs.contact_first_name);
				local.ws.contactlastname = Trim(local.qWs.contact_last_name);
			}
		}
	} catch (any e) {}

	return local.ws;
}

/**
 * Ensures CMSAdmin 2.0 calendar tables (dbo.calendar_event_categories and dbo.calendar_events)
 * exist and have standard categories and initial county events if empty.
 */
public void function ensureCalendarEventsSchema() {
	if (StructKeyExists(application, "calendarEventsSeedV2Ready") && application.calendarEventsSeedV2Ready == true) {
		return;
	}
	try {
		queryExecute("
			IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calendar_event_categories]') AND type in (N'U'))
			BEGIN
				CREATE TABLE [dbo].[calendar_event_categories] (
					[id]          INT IDENTITY(1,1) NOT NULL,
					[name]        NVARCHAR(120) NOT NULL,
					[slug]        NVARCHAR(120) NOT NULL,
					[color]       NVARCHAR(30)  NOT NULL CONSTRAINT [DF_cal_event_cat_color] DEFAULT (N'##0284c7'),
					[badge_class] NVARCHAR(50)  NOT NULL CONSTRAINT [DF_cal_event_cat_badge] DEFAULT (N'badge-info'),
					[icon]        NVARCHAR(50)  NOT NULL CONSTRAINT [DF_cal_event_cat_icon]  DEFAULT (N'calendar'),
					[description] NVARCHAR(255) NULL,
					[sort_order]  INT NOT NULL CONSTRAINT [DF_cal_event_cat_sort]   DEFAULT (0),
					[is_active]   BIT NOT NULL CONSTRAINT [DF_cal_event_cat_active] DEFAULT (1),
					[is_system]   BIT NOT NULL CONSTRAINT [DF_cal_event_cat_system] DEFAULT (0),
					[createdat]   DATETIME2(7) NOT NULL CONSTRAINT [DF_cal_event_cat_createdat] DEFAULT (SYSUTCDATETIME()),
					[updatedat]   DATETIME2(7) NOT NULL CONSTRAINT [DF_cal_event_cat_updatedat] DEFAULT (SYSUTCDATETIME()),
					[deletedat]   DATETIME2(7) NULL,
					CONSTRAINT [PK_calendar_event_categories] PRIMARY KEY CLUSTERED ([id] ASC)
				);
			END;

			IF NOT EXISTS (SELECT 1 FROM dbo.calendar_event_categories WHERE deletedat IS NULL)
			BEGIN
				INSERT INTO dbo.calendar_event_categories (name, slug, color, badge_class, icon, description, sort_order, is_active, is_system)
				VALUES
				(N'Commissioners Meeting',       N'commissioners-meeting', N'##0284c7', N'badge-info',    N'building',     N'Board of County Commissioners regular sessions, workshops, and legislative briefings.', 10, 1, 1),
				(N'Public Hearing',              N'public-hearing',        N'##b45309', N'badge-warning', N'megaphone',    N'Official public hearings, land use dockets, budget hearings, and ordinance reviews.', 20, 1, 1),
				(N'Advisory Board & Committee',  N'advisory-board',        N'##7e22ce', N'badge-purple',  N'users',        N'Planning Commission, Noxious Weed Board, Lodging Tax, and citizen advisory committees.', 30, 1, 1),
				(N'Community Event & Outreach',  N'community-event',       N'##15803d', N'badge-success', N'calendar',     N'County Expo Center events, town halls, parks activities, and public workshops.', 40, 1, 1),
				(N'Holiday & Office Closure',    N'holiday-closure',       N'##b91c1c', N'badge-danger',  N'clock',        N'Official county holidays, courthouse closures, and modified department hours.', 50, 1, 1),
				(N'Elections & Civic Deadlines', N'elections-deadlines',   N'##0f172a', N'badge-neutral', N'check-square', N'Voter registration deadlines, ballot drop dates, tax due dates, and public trainings.', 60, 1, 1);
			END;

			IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[calendar_events]') AND type in (N'U'))
			BEGIN
				CREATE TABLE [dbo].[calendar_events] (
					[id]                  INT IDENTITY(1,1) NOT NULL,
					[siteid]              NVARCHAR(100) NOT NULL CONSTRAINT [DF_calendar_events_siteid] DEFAULT (N'global'),
					[category_id]         INT NOT NULL,
					[title]               NVARCHAR(255) NOT NULL,
					[slug]                NVARCHAR(255) NOT NULL,
					[summary]             NVARCHAR(500) NULL,
					[description]         NVARCHAR(MAX) NULL,
					[start_date]          DATE NOT NULL,
					[end_date]            DATE NOT NULL,
					[start_time]          NVARCHAR(20) NULL,
					[end_time]            NVARCHAR(20) NULL,
					[is_all_day]          BIT NOT NULL CONSTRAINT [DF_calendar_events_allday] DEFAULT (0),
					[location_name]       NVARCHAR(255) NULL,
					[location_address]    NVARCHAR(255) NULL,
					[room_number]         NVARCHAR(120) NULL,
					[virtual_meeting_url] NVARCHAR(1000) NULL,
					[virtual_meeting_id]  NVARCHAR(120) NULL,
					[agenda_url]          NVARCHAR(1000) NULL,
					[minutes_url]         NVARCHAR(1000) NULL,
					[contact_name]        NVARCHAR(150) NULL,
					[contact_email]       NVARCHAR(150) NULL,
					[contact_phone]       NVARCHAR(60) NULL,
					[is_featured]         BIT NOT NULL CONSTRAINT [DF_calendar_events_featured] DEFAULT (0),
					[is_public_notice]    BIT NOT NULL CONSTRAINT [DF_calendar_events_notice] DEFAULT (0),
					[status]              NVARCHAR(30) NOT NULL CONSTRAINT [DF_calendar_events_status] DEFAULT (N'Published'),
					[publish_at]          DATETIME2 NULL,
					[unpublish_at]        DATETIME2 NULL,
					[created_by]          NVARCHAR(255) NULL,
					[modified_by]         NVARCHAR(255) NULL,
					[createdat]           DATETIME2(7) NOT NULL CONSTRAINT [DF_calendar_events_createdat] DEFAULT (SYSUTCDATETIME()),
					[updatedat]           DATETIME2(7) NOT NULL CONSTRAINT [DF_calendar_events_updatedat] DEFAULT (SYSUTCDATETIME()),
					[deletedat]           DATETIME2(7) NULL,
					CONSTRAINT [PK_calendar_events] PRIMARY KEY CLUSTERED ([id] ASC),
					CONSTRAINT [FK_calendar_events_categories] FOREIGN KEY ([category_id]) REFERENCES [dbo].[calendar_event_categories] ([id])
				);
			END;

			IF COL_LENGTH(N'dbo.calendar_events', N'publish_at') IS NULL
			BEGIN
				ALTER TABLE [dbo].[calendar_events] ADD [publish_at] DATETIME2 NULL;
			END;
			IF COL_LENGTH(N'dbo.calendar_events', N'unpublish_at') IS NULL
			BEGIN
				ALTER TABLE [dbo].[calendar_events] ADD [unpublish_at] DATETIME2 NULL;
			END;
		", {}, { datasource: "ChelanCountyWebsite" });

		// Seed standard county calendar events for testing if not already present (idempotent by slug)
		queryExecute("
			DECLARE @catComm INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'community-event' AND deletedat IS NULL);
			DECLARE @catElec INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'elections-deadlines' AND deletedat IS NULL);
			DECLARE @catAdv  INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'advisory-board' AND deletedat IS NULL);
			DECLARE @catBocc INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'commissioners-meeting' AND deletedat IS NULL);
			DECLARE @catHear INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'public-hearing' AND deletedat IS NULL);
			DECLARE @catHol  INT = (SELECT TOP 1 id FROM dbo.calendar_event_categories WHERE slug = N'holiday-closure' AND deletedat IS NULL);
			IF @catComm IS NULL SET @catComm = (SELECT TOP 1 id FROM dbo.calendar_event_categories ORDER BY id ASC);
			IF @catElec IS NULL SET @catElec = @catComm;
			IF @catAdv  IS NULL SET @catAdv  = @catComm;
			IF @catBocc IS NULL SET @catBocc = @catComm;
			IF @catHear IS NULL SET @catHear = @catComm;
			IF @catHol  IS NULL SET @catHol  = @catComm;

			MERGE INTO dbo.calendar_events AS Target
			USING (VALUES
				(N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-oct-5', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners, including public comment, consent agenda, and administrative updates.', '2026-10-05', '2026-10-05', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
				(N'board-of-commissioners', @catComm, N'District 1 Fall Community Meeting', N'district-1-fall-community-meeting', N'Community town hall and county update for District 1 residents.', N'Join Chelan County leadership for the District 1 Fall Community Meeting in Wenatchee to discuss road projects, county services, and upcoming priorities.', '2026-10-07', '2026-10-07', N'18:00', N'19:30', 0, N'Wenatchee Community Center', N'400 Douglas St, Wenatchee, WA 98801', N'Main Hall', N'', N'', N'Published', 1, 0),
				(N'elections', @catElec, N'Local Voters'' Pamphlet Mailed', N'local-voters-pamphlet-mailed', N'Official Chelan County Local Voters'' Pamphlets mailed to all residential households.', N'The Chelan County Elections Office mails the Official Local Voters'' Pamphlet for the November General Election to registered households county-wide.', '2026-10-09', '2026-10-09', N'', N'', 1, N'Elections Office', N'350 Orondo Ave, Wenatchee, WA 98801', N'Level 3', N'', N'/elections', N'Published', 0, 0),
				(N'board-of-commissioners', @catHear, N'Public Hearing: 2027 Preliminary County Budget', N'public-hearing-2027-preliminary-budget', N'Official public hearing on departmental budget requests and revenue forecasts for 2027.', N'The Board of County Commissioners holds a public hearing to review the 2027 preliminary county budget and take public testimony.', '2026-10-13', '2026-10-13', N'10:30', N'12:00', 0, N'BOCC Chambers', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 1),
				(N'elections', @catAdv, N'Logic & Accuracy Test (Public Meeting)', N'logic-and-accuracy-test-public-meeting', N'Official pre-election Logic & Accuracy test of ballot tabulation equipment.', N'Public test of the Chelan County ballot tabulation system prior to the General Election. Open to public observation in accordance with Washington State election law.', '2026-10-15', '2026-10-15', N'10:00', N'11:30', 0, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
				(N'elections', @catElec, N'Ballots Mailed — General Election', N'ballots-mailed-general-election', N'General Election ballots mailed to all active registered voters in Chelan County.', N'Ballots for the November General Election are mailed today. Official ballot drop boxes open across Chelan County.', '2026-10-16', '2026-10-16', N'', N'', 1, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'', N'', N'/elections', N'Published', 1, 0),
				(N'global', @catComm, N'Wenatchee Kennel Club Dog Show', N'wenatchee-kennel-club-dog-show', N'Annual Wenatchee Kennel Club all-breed dog show and agility trials.', N'Hosted at the Chelan County Expo Center in Cashmere. Open to spectators and exhibitors throughout the weekend.', '2026-10-16', '2026-10-18', N'08:00', N'17:00', 0, N'Chelan County Expo Center', N'5700 Wescott Dr, Cashmere, WA 98815', N'Pavilion', N'', N'', N'Published', 0, 0),
				(N'community-development', @catAdv, N'Chelan County Planning Commission Meeting', N'planning-commission-meeting-oct-21', N'Monthly public meeting of the Chelan County Planning Commission.', N'Review of comprehensive plan amendments, land use dockets, and community development updates.', '2026-10-21', '2026-10-21', N'17:30', N'19:30', 0, N'Community Development', N'316 Washington St, Wenatchee, WA 98801', N'Suite 301', N'https://zoom.us/j/chelancounty', N'', N'Published', 0, 1),
				(N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-oct-26', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners, including public comment, consent agenda, and administrative updates.', '2026-10-26', '2026-10-26', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
				(N'elections', @catElec, N'Online & Mail Voter Registration Deadline', N'voter-registration-deadline-oct-26', N'Last day for online and mail-in voter registrations and address updates for the General Election.', N'Voters may still register or update their registration in person at the Chelan County Elections Office through Election Day.', '2026-10-26', '2026-10-26', N'08:00', N'17:00', 0, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
				(N'natural-resources', @catAdv, N'Noxious Weed Control Board Quarterly Meeting', N'noxious-weed-board-oct-28', N'Quarterly board meeting covering seasonal weed management and landowner outreach.', N'Public meeting of the Chelan County Noxious Weed Control Board.', '2026-10-28', '2026-10-28', N'13:30', N'15:00', 0, N'Natural Resources Department', N'411 Washington St, Wenatchee, WA 98801', N'Suite 201', N'', N'', N'Published', 0, 0),
				(N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-nov-2', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners.', '2026-11-02', '2026-11-02', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
				(N'elections', @catElec, N'General Election Day — Ballots Due by 8:00 PM', N'general-election-day-nov-3', N'Ballots must be deposited in an official drop box by 8:00 PM or postmarked by Election Day.', N'Chelan County Elections Office and official ballot drop boxes remain open until 8:00 PM sharp on Election Day.', '2026-11-03', '2026-11-03', N'08:00', N'20:00', 0, N'County-Wide Drop Boxes & Elections Office', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
				(N'public-works', @catComm, N'Monthly Drop-Off Saturday — Moderate Risk Waste', N'monthly-drop-off-saturday-nov-7', N'Drop-Off Saturday at the Chelan County Moderate Risk Waste Facility.', N'Hosted by Chelan County Solid Waste Management for household hazardous waste disposal.', '2026-11-07', '2026-11-07', N'09:00', N'15:00', 0, N'Moderate Risk Waste Facility', N'Wenatchee, WA', N'', N'', N'', N'Published', 0, 0),
				(N'community-development', @catHear, N'Planning Commission Public Hearing', N'planning-commission-hearing-nov-18', N'Public hearing on zoning code updates and short-term rental regulations.', N'Public hearing before the Chelan County Planning Commission.', '2026-11-18', '2026-11-18', N'17:30', N'19:30', 0, N'Community Development', N'316 Washington St, Wenatchee, WA 98801', N'Suite 301', N'https://zoom.us/j/chelancounty', N'', N'Published', 1, 1),
				(N'elections', @catElec, N'County Canvassing Board — Election Certification', N'canvassing-board-certification-nov-24', N'Official certification of the November General Election returns.', N'The Chelan County Canvassing Board convenes in public session to certify the official results of the General Election.', '2026-11-24', '2026-11-24', N'10:00', N'11:00', 0, N'Chelan County Elections', N'350 Orondo Ave, Wenatchee, WA 98801', N'Suite 306', N'', N'/elections', N'Published', 1, 1),
				(N'board-of-commissioners', @catHear, N'Public Hearing: Final 2027 County Budget Adoption', N'public-hearing-2027-final-budget-dec-1', N'Final public hearing and adoption of the 2027 Chelan County Operating and Capital Budget.', N'The Board of County Commissioners conducts the final public hearing on the 2027 budget.', '2026-12-01', '2026-12-01', N'10:00', N'12:00', 0, N'BOCC Chambers', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 1),
				(N'board-of-commissioners', @catBocc, N'Board of County Commissioners Regular Session', N'bocc-regular-session-dec-7', N'Weekly legislative session and department briefings with the Board of County Commissioners.', N'Regular public session of the Chelan County Board of Commissioners.', '2026-12-07', '2026-12-07', N'09:00', N'12:00', 0, N'County Administration Building', N'400 Douglas St, Wenatchee, WA 98801', N'Suite 201', N'https://zoom.us/j/chelancounty', N'/board-of-commissioners', N'Published', 1, 0),
				(N'global', @catHol, N'Christmas Day — County Offices Closed', N'christmas-day-closure-2026', N'Chelan County Courthouse and administrative offices closed in observance of Christmas Day.', N'All non-emergency county offices are closed in observance of Christmas Day.', '2026-12-25', '2026-12-25', N'', N'', 1, N'Chelan County Courthouse', N'400 Douglas St, Wenatchee, WA 98801', N'', N'', N'', N'Published', 0, 0)
			) AS Source (siteid, category_id, title, slug, summary, description, start_date, end_date, start_time, end_time, is_all_day, location_name, location_address, room_number, virtual_meeting_url, agenda_url, status, is_featured, is_public_notice)
			ON Target.slug = Source.slug AND Target.deletedat IS NULL
			WHEN NOT MATCHED BY TARGET THEN
				INSERT (siteid, category_id, title, slug, summary, description, start_date, end_date, start_time, end_time, is_all_day, location_name, location_address, room_number, virtual_meeting_url, agenda_url, status, is_featured, is_public_notice, created_by)
				VALUES (Source.siteid, Source.category_id, Source.title, Source.slug, Source.summary, Source.description, Source.start_date, Source.end_date, Source.start_time, Source.end_time, Source.is_all_day, Source.location_name, Source.location_address, Source.room_number, Source.virtual_meeting_url, Source.agenda_url, Source.status, Source.is_featured, Source.is_public_notice, N'System');
		", {}, { datasource: "ChelanCountyWebsite" });

		application.calendarEventsSeedV2Ready = true;
	} catch (any e) {
		application.calendarEventsLastError = e.message & " | " & (e.detail ?: "");
	}
}

/**
 * Formats a 24-hour time string ("18:00" or "09:30") into "6:00 PM" / "9:30 AM"
 */
public string function formatCalendarTime(string rawTime = "") {
	local.t = Trim(arguments.rawTime);
	if (!Len(local.t)) {
		return "";
	}
	if (REFindNoCase("(am|pm)$", local.t)) {
		return UCase(local.t);
	}
	try {
		local.parsed = ParseDateTime("2000-01-01 " & local.t);
		return TimeFormat(local.parsed, "h:nn tt");
	} catch (any e) {
		return local.t;
	}
}

/**
 * Maps CMSAdmin 2.0 category icon names to Font Awesome 6 classes
 */
public string function mapCalendarCategoryIcon(string iconName = "", string categorySlug = "") {
	local.ic = LCase(Trim(arguments.iconName));
	local.slug = LCase(Trim(arguments.categorySlug));
	if (FindNoCase("fa-", local.ic)) {
		return FindNoCase("fa-solid", local.ic) || FindNoCase("fa-regular", local.ic) ? local.ic : ("fa-solid " & local.ic);
	}
	switch (local.ic) {
		case "building":     return "fa-solid fa-building-columns";
		case "megaphone":    return "fa-solid fa-bullhorn";
		case "users":        return "fa-solid fa-users";
		case "clock":        return "fa-regular fa-clock";
		case "check-square": return "fa-solid fa-check-to-slot";
		case "calendar":     return "fa-solid fa-calendar-day";
	}
	if (FindNoCase("election", local.slug)) return "fa-solid fa-check-to-slot";
	if (FindNoCase("hearing", local.slug))  return "fa-solid fa-bullhorn";
	if (FindNoCase("board", local.slug))    return "fa-solid fa-users";
	if (FindNoCase("commissioner", local.slug)) return "fa-solid fa-building-columns";
	if (FindNoCase("holiday", local.slug))  return "fa-regular fa-clock";
	return "fa-solid fa-calendar-day";
}

/**
 * Loads active Calendar Event Categories from CMSAdmin 2.0 (dbo.calendar_event_categories)
 */
public array function getCalendarCategories() {
	ensureCalendarEventsSchema();
	local.cats = [];
	try {
		local.q = queryExecute("
			SELECT c.id, c.name, c.slug, c.color, c.badge_class, c.icon, c.description, c.sort_order
			FROM dbo.calendar_event_categories c
			WHERE c.deletedat IS NULL AND c.is_active = 1
			ORDER BY c.sort_order ASC, c.name ASC
		", {}, { datasource: "ChelanCountyWebsite" });

		for (local.r in local.q) {
			ArrayAppend(local.cats, {
				id:          Val(local.r.id),
				name:        Trim(local.r.name ?: ""),
				slug:        Trim(local.r.slug ?: ""),
				color:       Len(Trim(local.r.color ?: "")) ? Trim(local.r.color) : "##0284c7",
				badgeClass:  Len(Trim(local.r.badge_class ?: "")) ? Trim(local.r.badge_class) : "badge-info",
				icon:        Trim(local.r.icon ?: "calendar"),
				faIcon:      mapCalendarCategoryIcon(local.r.icon ?: "", local.r.slug ?: ""),
				description: Trim(local.r.description ?: "")
			});
		}
	} catch (any e) {}
	return local.cats;
}

/**
 * Loads published Calendar Events from CMSAdmin 2.0 (dbo.calendar_events)
 */
public array function getCalendarEvents(string siteid = "", boolean includeAllWorkspaces = true) {
	ensureCalendarEventsSchema();
	local.events = [];
	try {
		local.wsNames = { "global": "County-Wide" };
		try {
			local.qWs = queryExecute("
				SELECT LOWER(LTRIM(RTRIM(code))) AS code,
				       LOWER(LTRIM(RTRIM(ISNULL(alias, '')))) AS alias,
				       LOWER(LTRIM(RTRIM(ISNULL(virtual_directory, '')))) AS vdir,
				       name
				FROM dbo.cms_workspaces
				WHERE deletedat IS NULL AND is_active = 1
			", {}, { datasource: "ChelanCountyWebsite" });
			for (local.w in local.qWs) {
				if (Len(local.w.code))  local.wsNames[local.w.code]  = Trim(local.w.name);
				if (Len(local.w.alias)) local.wsNames[local.w.alias] = Trim(local.w.name);
				if (Len(local.w.vdir))  local.wsNames[local.w.vdir]  = Trim(local.w.name);
			}
		} catch (any eWs) {}

		local.params = {};
		local.whereClause = "
			WHERE e.deletedat IS NULL
			  AND c.deletedat IS NULL
			  AND (c.is_active = 1 OR c.is_active IS NULL)
			  AND e.status IN (N'Published', N'Scheduled')
			  AND (e.publish_at IS NULL OR e.publish_at <= SYSUTCDATETIME())
			  AND (e.unpublish_at IS NULL OR e.unpublish_at > SYSUTCDATETIME())
		";

		if (!arguments.includeAllWorkspaces && Len(Trim(arguments.siteid)) && !ListFindNoCase("all,global", Trim(arguments.siteid))) {
			local.cands = resolveCandidateSiteIds(arguments.siteid);
			if (!ArrayFindNoCase(local.cands, "global")) {
				ArrayAppend(local.cands, "global");
			}
			local.inPlaceholders = [];
			for (local.i = 1; local.i <= ArrayLen(local.cands); local.i++) {
				local.pKey = "calSite" & local.i;
				ArrayAppend(local.inPlaceholders, ":" & local.pKey);
				local.params[local.pKey] = { value: LCase(local.cands[local.i]), cfsqltype: "cf_sql_nvarchar", maxlength: 100 };
			}
			if (ArrayLen(local.inPlaceholders)) {
				local.whereClause &= " AND LOWER(LTRIM(RTRIM(e.siteid))) IN (" & ArrayToList(local.inPlaceholders, ", ") & ")";
			}
		}

		local.q = queryExecute("
			SELECT e.id, e.siteid, e.category_id, e.title, e.slug, e.summary, e.description,
			       e.start_date, e.end_date, e.start_time, e.end_time, e.is_all_day,
			       e.location_name, e.location_address, e.room_number,
			       e.virtual_meeting_url, e.virtual_meeting_id, e.agenda_url, e.minutes_url,
			       e.contact_name, e.contact_email, e.contact_phone,
			       e.is_featured, e.is_public_notice, e.status,
			       c.name AS category_name, c.slug AS category_slug, c.color AS category_color,
			       c.badge_class AS category_badge, c.icon AS category_icon
			FROM dbo.calendar_events e
			INNER JOIN dbo.calendar_event_categories c ON c.id = e.category_id
			" & local.whereClause & "
			ORDER BY e.start_date ASC,
			         CASE WHEN e.is_all_day = 1 THEN '00:00' ELSE ISNULL(NULLIF(LTRIM(RTRIM(e.start_time)), ''), '09:00') END ASC,
			         e.title ASC
		", local.params, { datasource: "ChelanCountyWebsite" });

		for (local.r in local.q) {
			local.sDate = IsDate(local.r.start_date) ? ParseDateTime(local.r.start_date) : Now();
			local.eDate = IsDate(local.r.end_date) ? ParseDateTime(local.r.end_date) : local.sDate;
			if (DateCompare(local.eDate, local.sDate, "d") < 0) {
				local.eDate = local.sDate;
			}
			local.sDateIso = DateFormat(local.sDate, "yyyy-mm-dd");
			local.eDateIso = DateFormat(local.eDate, "yyyy-mm-dd");
			local.isAllDay = (local.r.is_all_day == 1 || local.r.is_all_day == true);
			local.startTimeFormatted = local.isAllDay ? "" : formatCalendarTime(local.r.start_time ?: "");
			local.endTimeFormatted = local.isAllDay ? "" : formatCalendarTime(local.r.end_time ?: "");
			local.timeLabel = "";
			if (local.isAllDay) {
				local.timeLabel = "All Day";
			} else if (Len(local.startTimeFormatted) && Len(local.endTimeFormatted)) {
				local.timeLabel = local.startTimeFormatted & " – " & local.endTimeFormatted;
			} else if (Len(local.startTimeFormatted)) {
				local.timeLabel = local.startTimeFormatted;
			}

			local.sKey = LCase(ReReplaceNoCase(Trim(local.r.siteid ?: "global"), "^site-", ""));
			local.deptName = (local.sKey == "global" || local.sKey == "all")
				? "County-Wide"
				: (StructKeyExists(local.wsNames, local.sKey) ? local.wsNames[local.sKey] : REReplace(local.sKey, "(^|-)([a-z])", " \U\2", "all"));
			if (CompareNoCase(Trim(local.deptName), "All Workspaces") == 0) {
				local.deptName = "County-Wide";
			}

			local.faIcon = mapCalendarCategoryIcon(local.r.category_icon ?: "", local.r.category_slug ?: "");

			ArrayAppend(local.events, {
				id:                Val(local.r.id),
				siteId:            Trim(local.r.siteid ?: "global"),
				departmentName:    Trim(local.deptName),
				categoryId:        Val(local.r.category_id),
				categoryName:      Trim(local.r.category_name ?: "County Event"),
				categorySlug:      Trim(local.r.category_slug ?: "event"),
				categoryColor:     Len(Trim(local.r.category_color ?: "")) ? Trim(local.r.category_color) : "##0284c7",
				categoryIcon:      local.faIcon,
				title:             Trim(local.r.title ?: ""),
				slug:              Trim(local.r.slug ?: ""),
				summary:           Trim(local.r.summary ?: ""),
				description:       Trim(local.r.description ?: ""),
				startDate:         local.sDateIso,
				endDate:           local.eDateIso,
				startYear:         Year(local.sDate),
				startMonth:        Month(local.sDate),
				startDay:          Day(local.sDate),
				monthAbbr:         DateFormat(local.sDate, "mmm"),
				dateDisplay:       (local.sDateIso == local.eDateIso)
					? DateFormat(local.sDate, "mmmm d, yyyy")
					: (DateFormat(local.sDate, "mmm d") & " – " & DateFormat(local.eDate, "mmm d, yyyy")),
				startTime:         Trim(local.r.start_time ?: ""),
				endTime:           Trim(local.r.end_time ?: ""),
				startTimeDisplay:  local.startTimeFormatted,
				endTimeDisplay:    local.endTimeFormatted,
				timeDisplay:       local.timeLabel,
				isAllDay:          local.isAllDay,
				locationName:      Trim(local.r.location_name ?: ""),
				locationAddress:   Trim(local.r.location_address ?: ""),
				roomNumber:        Trim(local.r.room_number ?: ""),
				virtualMeetingUrl: Trim(local.r.virtual_meeting_url ?: ""),
				virtualMeetingId:  Trim(local.r.virtual_meeting_id ?: ""),
				agendaUrl:         Trim(local.r.agenda_url ?: ""),
				minutesUrl:        Trim(local.r.minutes_url ?: ""),
				contactName:       Trim(local.r.contact_name ?: ""),
				contactEmail:      Trim(local.r.contact_email ?: ""),
				contactPhone:      Trim(local.r.contact_phone ?: ""),
				isFeatured:        (local.r.is_featured == 1 || local.r.is_featured == true),
				isPublicNotice:    (local.r.is_public_notice == 1 || local.r.is_public_notice == true),
				icsUrl:            "/calendar/ics?id=" & Val(local.r.id),
				url:               "/calendar?event=" & Val(local.r.id)
			});
		}
	} catch (any e) {
		writeLog(type="error", file="calendar", text="getCalendarEvents error: #e.message# #e.detail ?: ''#");
	}
	return local.events;
}
</cfscript>
