component extends="Controller" {

	function index() {
		ensureCtaCardsSchema();
		ensureFolderExplorerSchema();
		site = getWorkspace("auditor");
		content = model("Page").findOne(
			where="SiteID IN ('auditor', 'site-auditor') AND Permalink = 'home' AND StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published'"
		);
		nav = getNavigation("auditor");
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
		site = getWorkspace("auditor");
		content = model("Page").findOne(
			where="SiteID IN ('auditor', 'site-auditor') AND Permalink = '#local.safeSlug#' AND StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published'"
		);
		if (!isObject(content)) {
			cfheader(statusCode=404);
		}
		nav = getNavigation("auditor");
		sidebars = getAttachedSidebars(content);
		ctaCards = getAttachedCtaCards(content);
		folderExplorers = getAttachedFolderExplorers(content);
		hasSidebar = isQuery(sidebars) && sidebars.recordCount > 0;
		layoutType = hasSidebar ? "right-sidebar" : "full";
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
			siteId = local.qFe.SiteID ?: "auditor"
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
