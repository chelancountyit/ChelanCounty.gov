component extends="Controller" {

	function index() {
		ensureCtaCardsSchema();
		ensureFolderExplorerSchema();
		site = getWorkspace("public-works");
		content = model("Page").findOne(
			where="SiteID IN ('public-works', 'pw', 'site-public-works', 'site-pw') AND Permalink = 'home' AND StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published'"
		);
		nav = getNavigation("public-works");
		sidebars = getAttachedSidebars(content);
		ctaCards = getAttachedCtaCards(content);
		folderExplorers = getAttachedFolderExplorers(content);
		hasSidebar = isQuery(sidebars) && sidebars.recordCount > 0;
		layoutType = hasSidebar ? "right-sidebar" : "full";
	}

	function page() {
		ensureCtaCardsSchema();
		ensureFolderExplorerSchema();
		local.slug = StructKeyExists(params, "slug") ? Trim(params.slug) : (StructKeyExists(params, "key") ? Trim(params.key) : "home");
		local.safeSlug = ReReplace(local.slug, "[^a-zA-Z0-9_-]", "", "all");
		site = getWorkspace("public-works");
		content = model("Page").findOne(
			where="SiteID IN ('public-works', 'pw', 'site-public-works', 'site-pw') AND Permalink = '#local.safeSlug#' AND StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published'"
		);
		if (!isObject(content)) {
			cfheader(statusCode=404);
		}
		nav = getNavigation("public-works");
		sidebars = getAttachedSidebars(content);
		ctaCards = getAttachedCtaCards(content);
		folderExplorers = getAttachedFolderExplorers(content);
		hasSidebar = isQuery(sidebars) && sidebars.recordCount > 0;
		layoutType = hasSidebar ? "right-sidebar" : "full";
	}

	function contacts() {
		site = getWorkspace("public-works");
		nav = getNavigation("public-works");
		try {
			employees = queryExecute("
				SELECT EMPLOYEEID, FIRSTNAME, LASTNAME, TITLE, POSITION, LOCATIONNAME, ADDRESS, CITY, STATE, ZIP, PHONE, FAX, EMAIL
				FROM cccmsdbv2.dbo.cEmployees WITH (NOLOCK)
				WHERE SiteID = 1022 AND StatusCode = 1
				ORDER BY listPosition ASC, EMPLOYEEID ASC
			", {}, { datasource: "ChelanCountyWebsite" });
		} catch (any e) {
			employees = queryNew("EMPLOYEEID,FIRSTNAME,LASTNAME,TITLE,POSITION,LOCATIONNAME,ADDRESS,CITY,STATE,ZIP,PHONE,FAX,EMAIL");
		}
	}

	function howdoi() {
		site = getWorkspace("public-works");
		nav = getNavigation("public-works");
		try {
			howDoIItems = queryExecute("
				SELECT f.FAQID, f.CATEGORYID, ISNULL(c.CATEGORY, 'General') AS CATEGORY, f.QUESTION, f.ANSWER,
				       f.EXTERNALFORWARDURL, f.INTERNALFORWARDURL, f.INTERNALCUSTOMURL
				FROM cccmsdbv2.dbo.cFAQ f WITH (NOLOCK)
				LEFT JOIN cccmsdbv2.dbo.cFAQCategories c WITH (NOLOCK) ON c.CATEGORYID = f.CATEGORYID
				WHERE f.SITEID = 1022 AND f.STATUSCODE = 1 AND (f.QNAID IS NULL OR f.QNAID = 0) AND f.CATEGORYID > 0
				ORDER BY f.CATEGORYID ASC, f.FAQID ASC
			", {}, { datasource: "ChelanCountyWebsite" });
		} catch (any e) {
			howDoIItems = queryNew("FAQID,CATEGORYID,CATEGORY,QUESTION,ANSWER,EXTERNALFORWARDURL,INTERNALFORWARDURL,INTERNALCUSTOMURL");
		}
	}

	function blog() {
		site = getWorkspace("public-works");
		nav = getNavigation("public-works");
		local.slug = StructKeyExists(params, "slug") ? Trim(params.slug) : (StructKeyExists(params, "key") ? Trim(params.key) : "");
		local.safeSlug = ReReplace(local.slug, "[^a-zA-Z0-9_-]", "", "all");
		try {
			if (Len(local.safeSlug)) {
				selectedBlog = queryExecute("
					SELECT TOP 1 BLOGID, TITLE, PERMALINK, BODY, POSTDATE, IMAGEATTACHMENT, IMAGEATTRIBUTION
					FROM cccmsdbv2.dbo.cBlog WITH (NOLOCK)
					WHERE SiteID = 1022 AND isPublished = 1 AND Permalink = :slug
					ORDER BY BLOGID DESC
				", { slug: { value: local.safeSlug, cfsqltype: "cf_sql_nvarchar" } }, { datasource: "ChelanCountyWebsite" });
			} else {
				selectedBlog = queryExecute("
					SELECT TOP 1 BLOGID, TITLE, PERMALINK, BODY, POSTDATE, IMAGEATTACHMENT, IMAGEATTRIBUTION
					FROM cccmsdbv2.dbo.cBlog WITH (NOLOCK)
					WHERE SiteID = 1022 AND isPublished = 1
					ORDER BY BLOGID DESC
				", {}, { datasource: "ChelanCountyWebsite" });
			}
			local.excludeId = selectedBlog.recordCount ? Val(selectedBlog.BLOGID) : 0;
			blogPosts = queryExecute("
				SELECT TOP 20 BLOGID, TITLE, PERMALINK, BODY, POSTDATE, IMAGEATTACHMENT, IMAGEATTRIBUTION
				FROM cccmsdbv2.dbo.cBlog WITH (NOLOCK)
				WHERE SiteID = 1022 AND isPublished = 1 AND BLOGID <> :excludeId
				ORDER BY BLOGID DESC
			", { excludeId: { value: local.excludeId, cfsqltype: "cf_sql_integer" } }, { datasource: "ChelanCountyWebsite" });
		} catch (any e) {
			selectedBlog = queryNew("BLOGID,TITLE,PERMALINK,BODY,POSTDATE,IMAGEATTACHMENT,IMAGEATTRIBUTION");
			blogPosts = queryNew("BLOGID,TITLE,PERMALINK,BODY,POSTDATE,IMAGEATTACHMENT,IMAGEATTRIBUTION");
		}
	}

	function forms() {
		site = getWorkspace("public-works");
		nav = getNavigation("public-works");
		formKey = StructKeyExists(params, "slug") ? LCase(Trim(params.slug)) : (StructKeyExists(params, "key") ? LCase(Trim(params.key)) : "report-a-problem");
	}

	function file() {
		local.feId = StructKeyExists(params, "fe") ? Val(params.fe) : 0;
		local.relFile = StructKeyExists(params, "file") ? Trim(params.file) : "";
		if (local.feId <= 0 || !Len(local.relFile) || Find("..", local.relFile)) {
			renderText(text="File not found.", status=404, layout=false);
			return;
		}

		local.qFe = queryExecute("
			SELECT TOP 1 f.ID, f.SiteID, f.RelativePath, f.AbsolutePath
			FROM dbo.page_FolderExplorer f
			INNER JOIN dbo.pages p ON p.ContentID = f.ContentID
			WHERE f.ID = :id
			  AND p.DeletedAt IS NULL
			  AND p.StatusCode = 'Active'
			  AND p.isPublished = 1
			  AND p.Visibility = 'Published'
			  AND p.hasArchive = 1
		", {
			id: { value: local.feId, cfsqltype: "cf_sql_integer" }
		}, { datasource: "ChelanCountyWebsite" });

		if (!local.qFe.recordCount) {
			renderText(text="Folder explorer configuration not found.", status=404, layout=false);
			return;
		}

		local.resolved = resolveFolderExplorerRoot(
			absolutePath = local.qFe.AbsolutePath ?: "",
			relativePath = local.qFe.RelativePath ?: "",
			siteId = local.qFe.SiteID ?: "public-works"
		);

		if (!Len(local.resolved.diskPath) || !DirectoryExists(local.resolved.diskPath)) {
			renderText(text="Directory not found.", status=404, layout=false);
			return;
		}

		local.cleanRelFile = ReReplace(Replace(local.relFile, "/", "\", "all"), "^\\+", "", "one");
		local.targetPath = local.resolved.diskPath & "\" & local.cleanRelFile;

		try {
			local.rootJavaFile = CreateObject("java", "java.io.File").init(local.resolved.diskPath);
			local.targetJavaFile = CreateObject("java", "java.io.File").init(local.targetPath);
			local.rootCanon = local.rootJavaFile.getCanonicalPath();
			local.targetCanon = local.targetJavaFile.getCanonicalPath();

			if (
				Left(local.targetCanon, Len(local.rootCanon)) != local.rootCanon
				|| !FileExists(local.targetCanon)
			) {
				renderText(text="Requested file was not found.", status=404, layout=false);
				return;
			}

			local.fileName = GetFileFromPath(local.targetCanon);
			local.ext = ListLen(local.fileName, ".") > 1 ? LCase(ListLast(local.fileName, ".")) : "";
			local.mime = "application/octet-stream";
			switch (local.ext) {
				case "pdf": local.mime = "application/pdf"; break;
				case "xlsx": local.mime = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"; break;
				case "xls": local.mime = "application/vnd.ms-excel"; break;
				case "docx": local.mime = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"; break;
				case "doc": local.mime = "application/msword"; break;
				case "pptx": local.mime = "application/vnd.openxmlformats-officedocument.presentationml.presentation"; break;
				case "ppt": local.mime = "application/vnd.ms-powerpoint"; break;
				case "csv": local.mime = "text/csv"; break;
				case "txt": local.mime = "text/plain"; break;
				case "jpg": case "jpeg": local.mime = "image/jpeg"; break;
				case "png": local.mime = "image/png"; break;
				case "gif": local.mime = "image/gif"; break;
				case "webp": local.mime = "image/webp"; break;
				case "svg": local.mime = "image/svg+xml"; break;
				case "zip": local.mime = "application/zip"; break;
			}

			local.isDownload = StructKeyExists(params, "download") && (Val(params.download) == 1 || params.download == true);
			local.disposition = local.isDownload ? "attachment" : "inline";
			local.safeHeaderName = Replace(local.fileName, '"', '', 'all');

			cfheader(name="Content-Disposition", value='#local.disposition#; filename="#local.safeHeaderName#"');
			cfcontent(file=local.targetCanon, type=local.mime, reset=true);
			abort;
		} catch (any e) {
			if (FindNoCase("abort", e.type ?: "") || FindNoCase("abort", e.message ?: "")) {
				abort;
			}
			renderText(text="Unable to serve file.", status=404, layout=false);
			return;
		}
	}

}

