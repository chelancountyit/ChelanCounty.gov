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
				) {
					local.destUrl = local.wsBasePath;
				} else if (REFindNoCase("^" & local.wsBasePath & "/(?!page/)[^/]+/?$", local.destUrl)) {
					local.slugPart = ReReplaceNoCase(local.destUrl, "^" & local.wsBasePath & "/+", "", "one");
					local.slugPart = ReReplace(local.slugPart, "/+$", "", "one");
					local.destUrl = local.wsBasePath & "/page/" & local.slugPart;
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
			return queryExecute("
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
			       leadership_type, job_title, contact_photo
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

			if (Len(Trim(local.qWs.contact_first_name ?: "")) && Len(Trim(local.qWs.contact_last_name ?: ""))) {
				local.ws.contactfirstname = Trim(local.qWs.contact_first_name);
				local.ws.contactlastname = Trim(local.qWs.contact_last_name);
			}
		}
	} catch (any e) {}

	return local.ws;
}
</cfscript>
