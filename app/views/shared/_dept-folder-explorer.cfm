<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-folder-explorer.cfm — Reusable Folder Explorer Section (Driven by CMSAdmin2.0 dbo.page_FolderExplorer) --->
<cfif NOT StructKeyExists(variables, "scanFolderExplorerDir") OR NOT StructKeyExists(variables, "isPagePublishedAndActive")>
  <cfinclude template="/app/global/functions.cfm">
</cfif>
<cfparam name="content" default="">
<cfparam name="folderExplorers" default="#getAttachedFolderExplorers(content)#">
<cfparam name="arguments.isSubpage" default="false">
<cfparam name="arguments.placement" default="">

<cfset local.hasExplorers = isQuery(folderExplorers) and folderExplorers.recordCount GT 0>
<cfset local.filterPlacement = Trim(arguments.placement)>

<cfif local.hasExplorers>
<cfoutput>
  <cfloop query="folderExplorers">
    <cfset local.rowPlacement = Len(Trim(folderExplorers.Placement ?: "")) ? Trim(folderExplorers.Placement) : "After">
    <cfif NOT Len(local.filterPlacement) OR CompareNoCase(local.filterPlacement, local.rowPlacement) EQ 0>
      <cfset local.feId = Val(folderExplorers.ID)>
      <cfset local.feTitle = Len(Trim(folderExplorers.Title ?: "")) ? Trim(folderExplorers.Title) : "Public Records & Document Archives">
      <cfset local.feLayout = (CompareNoCase(Trim(folderExplorers.Layout ?: ""), "3/9") EQ 0) ? "3/9" : "Full">
      <cfset local.feSiteId = Len(Trim(folderExplorers.SiteID ?: "")) ? Trim(folderExplorers.SiteID) : "assessor">
      <cfset local.tree = loadFolderExplorerTree(
        explorerId = local.feId,
        absolutePath = folderExplorers.AbsolutePath ?: "",
        relativePath = folderExplorers.RelativePath ?: "",
        siteId = local.feSiteId
      )>
      <cfset local.sectionDomId = "fe-section-" & local.feId>
      <cfset local.headingDomId = "fe-heading-" & local.feId>
      <cfset local.searchDomId = "fe-search-" & local.feId>
      <cfset local.statusDomId = "fe-status-" & local.feId>
      <cfset local.reqFolder = StructKeyExists(url, "folder") ? LCase(Trim(url.folder)) : "all">

      <!-- Folder Explorer Section (#EncodeForHTML(local.feTitle)# - Layout: #EncodeForHTML(local.feLayout)#) -->
      <section id="#local.sectionDomId#" class="fe-explorer-section my-4" aria-labelledby="#local.headingDomId#" data-fe-instance="#local.feId#" data-fe-layout="#EncodeForHTMLAttribute(local.feLayout)#">
        <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
          <div>
            <h2 id="#local.headingDomId#" class="section-title m-0">
              <!--- <i class="fa-solid fa-folder-tree text-brand me-2" aria-hidden="true"></i> --->#EncodeForHTML(local.feTitle)#
            </h2>
          </div>
          <span class="badge rounded-pill bg-light text-dark border fw-semibold px-3 py-2">
            <i class="fa-regular fa-file-lines text-brand me-1" aria-hidden="true"></i>
            <span data-fe-count-badge>#local.tree.totalFileCount# #local.tree.totalFileCount EQ 1 ? 'document' : 'documents'#</span>
          </span>
        </div>

        <div id="#local.statusDomId#" class="visually-hidden" role="status" aria-live="polite"></div>

        <cfif NOT local.tree.exists>
          <div class="fe-card p-4 text-muted">
            <i class="fa-solid fa-folder-open me-2 text-brand" aria-hidden="true"></i>
            No documents are currently available in this directory.
          </div>
        <cfelseif local.feLayout EQ "3/9">
          <!-- ================================================================
               3/9 Grid Layout: 3-Col Folder Tree (Left) + 9-Col Files (Right)
               ================================================================ -->
          <div class="row g-3 align-items-start">
            <!-- 3-Column Left Folder Tree -->
            <div class="col-md-4 col-lg-3">
              <div class="fe-card">
                <div class="fe-card-header">
                  <span class="fe-card-heading">
                    <i class="fa-solid fa-folder text-brand me-1" aria-hidden="true"></i> Folders
                  </span>
                </div>
                <div class="fe-tree-list" role="tree" aria-label="#EncodeForHTMLAttribute(local.feTitle)# Folders">
                  <button type="button"
                          role="treeitem"
                          aria-selected="#(local.reqFolder EQ 'all' ? 'true' : 'false')#"
                          tabindex="#(local.reqFolder EQ 'all' ? '0' : '-1')#"
                          class="fe-tree-item#(local.reqFolder EQ 'all' ? ' active' : '')#"
                          data-fe-folder-btn="all"
                          data-fe-folder-label="All Documents">
                    <span class="fe-tree-item-label">
                      <i class="fa-solid #(local.reqFolder EQ 'all' ? 'fa-folder-open' : 'fa-folder')# fe-folder-icon" aria-hidden="true"></i>
                      <span>All Documents</span>
                    </span>
                    <span class="fe-tree-count">#local.tree.totalFileCount#</span>
                  </button>

                  <cfif local.tree.rootFileCount GT 0 AND ArrayLen(local.tree.folders) GT 0>
                    <button type="button"
                            role="treeitem"
                            aria-selected="#(local.reqFolder EQ 'root' ? 'true' : 'false')#"
                            tabindex="#(local.reqFolder EQ 'root' ? '0' : '-1')#"
                            class="fe-tree-item#(local.reqFolder EQ 'root' ? ' active' : '')#"
                            data-fe-folder-btn="root"
                            data-fe-folder-label="Main Directory">
                      <span class="fe-tree-item-label">
                        <i class="fa-solid #(local.reqFolder EQ 'root' ? 'fa-folder-open' : 'fa-folder')# fe-folder-icon" aria-hidden="true"></i>
                        <span>Main Directory</span>
                      </span>
                      <span class="fe-tree-count">#local.tree.rootFileCount#</span>
                    </button>
                  </cfif>

                  <cfloop array="#local.tree.folders#" index="local.folder">
                    <cfset local.isSel = (local.reqFolder EQ LCase(local.folder.key)) OR (local.reqFolder EQ LCase(local.folder.name))>
                    <cfset local.indentPx = Max(0, (local.folder.depth - 1) * 14)>
                    <button type="button"
                            role="treeitem"
                            aria-selected="#(local.isSel ? 'true' : 'false')#"
                            tabindex="#(local.isSel ? '0' : '-1')#"
                            class="fe-tree-item#(local.isSel ? ' active' : '')#"
                            style="<cfif local.indentPx GT 0>padding-left: calc(0.85rem + #local.indentPx#px);</cfif>"
                            data-fe-folder-btn="#EncodeForHTMLAttribute(local.folder.key)#"
                            data-fe-folder-label="#EncodeForHTMLAttribute(local.folder.fullLabel)#">
                      <span class="fe-tree-item-label">
                        <i class="fa-solid #(local.isSel ? 'fa-folder-open' : 'fa-folder')# fe-folder-icon" aria-hidden="true"></i>
                        <span>#EncodeForHTML(local.folder.label)#</span>
                      </span>
                      <span class="fe-tree-count">#local.folder.fileCount#</span>
                    </button>
                  </cfloop>
                </div>
              </div>
            </div>

            <!-- 9-Column Right Files & Documents Table -->
            <div class="col-md-8 col-lg-9">
              <div class="fe-card">
                <div class="fe-card-header d-flex align-items-center justify-content-between flex-wrap gap-2">
                  <div class="d-flex align-items-center gap-2">
                    <i class="fa-regular fa-folder-open text-brand" aria-hidden="true"></i>
                    <span class="fe-card-heading" data-fe-active-folder-heading>All Documents</span>
                  </div>
                  <div class="fe-search-wrap">
                    <label for="#local.searchDomId#" class="visually-hidden">Search documents in #EncodeForHTML(local.feTitle)#</label>
                    <div class="input-group input-group-sm">
                      <span class="input-group-text bg-white border-end-0 text-muted">
                        <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                      </span>
                      <input type="search"
                             id="#local.searchDomId#"
                             class="form-control border-start-0 ps-0"
                             placeholder="Filter files..."
                             data-fe-search-input>
                    </div>
                  </div>
                </div>

                <div class="fe-card-body p-0">
                  <cfif ArrayLen(local.tree.files) GT 0>
                    <div class="table-responsive">
                      <table class="table table-hover align-middle mb-0 fe-file-table">
                        <caption class="visually-hidden">Documents in #EncodeForHTML(local.feTitle)#</caption>
                        <thead>
                          <tr>
                            <th scope="col">Document</th>
                            <th scope="col" class="d-none d-sm-table-cell text-nowrap">Modified</th>
                            <th scope="col" class="text-end text-nowrap">Size</th>
                            <th scope="col" class="text-end text-nowrap">Action</th>
                          </tr>
                        </thead>
                        <tbody>
                          <cfloop array="#local.tree.files#" index="local.fileItem">
                            <tr data-fe-file-row
                                data-fe-folder="#EncodeForHTMLAttribute(local.fileItem.folderKey)#"
                                data-fe-search-text="#EncodeForHTMLAttribute(LCase(local.fileItem.displayName & ' ' & local.fileItem.folderLabel & ' ' & local.fileItem.extension))#">
                              <td>
                                <div class="d-flex align-items-center gap-2">
                                  <span class="fe-ext-badge #EncodeForHTMLAttribute(local.fileItem.badgeClass)#" aria-hidden="true">
                                    #EncodeForHTML(local.fileItem.badgeLabel)#
                                  </span>
                                  <div class="min-w-0">
                                    <a href="#EncodeForHTMLAttribute(local.fileItem.viewUrl)#"
                                       <cfif local.fileItem.openInNewTab>target="_blank" rel="noopener noreferrer"</cfif>
                                       class="fe-file-link fw-semibold">
                                      #EncodeForHTML(local.fileItem.displayName)#
                                      <cfif local.fileItem.openInNewTab><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                                    </a>
                                    <cfif local.fileItem.folderKey NEQ "root">
                                      <div class="text-muted small fe-folder-crumb" data-fe-row-crumb>
                                        <i class="fa-regular fa-folder me-1" aria-hidden="true"></i>#EncodeForHTML(local.fileItem.folderLabel)#
                                      </div>
                                    </cfif>
                                  </div>
                                </div>
                              </td>
                              <td class="d-none d-sm-table-cell text-muted small text-nowrap">
                                #EncodeForHTML(local.fileItem.dateFormatted)#
                              </td>
                              <td class="text-end text-muted small text-nowrap">
                                #EncodeForHTML(local.fileItem.sizeFormatted)#
                              </td>
                              <td class="text-end text-nowrap">
                                <a href="#EncodeForHTMLAttribute(local.fileItem.downloadUrl)#"
                                   class="btn btn-outline-secondary btn-sm fe-download-btn"
                                   aria-label="Download #EncodeForHTMLAttribute(local.fileItem.displayName)# (#EncodeForHTMLAttribute(local.fileItem.sizeFormatted)#)">
                                  <i class="fa-solid fa-download" aria-hidden="true"></i>
                                  <span class="d-none d-lg-inline ms-1">Download</span>
                                </a>
                              </td>
                            </tr>
                          </cfloop>
                        </tbody>
                      </table>
                    </div>
                    <div class="p-4 text-center text-muted d-none" data-fe-empty-state>
                      <i class="fa-regular fa-folder-open fa-lg mb-2 d-block text-brand" aria-hidden="true"></i>
                      No documents match the selected folder or filter criteria.
                    </div>
                  <cfelse>
                    <div class="p-4 text-center text-muted">
                      <i class="fa-regular fa-folder-open fa-lg mb-2 d-block text-brand" aria-hidden="true"></i>
                      This folder is currently empty.
                    </div>
                  </cfif>
                </div>
              </div>
            </div>
          </div>

        <cfelse>
          <!-- ================================================================
               Full Width Layout: Single Full-Width Searchable Directory Table
               ================================================================ -->
          <div class="fe-card">
            <div class="fe-card-header d-flex align-items-center justify-content-between flex-wrap gap-2">
              <div class="d-flex align-items-center gap-2">
                <i class="fa-regular fa-folder-open text-brand" aria-hidden="true"></i>
                <span class="fe-card-heading">Documents &amp; Files</span>
              </div>
              <div class="fe-search-wrap">
                <label for="#local.searchDomId#" class="visually-hidden">Search documents in #EncodeForHTML(local.feTitle)#</label>
                <div class="input-group input-group-sm">
                  <span class="input-group-text bg-white border-end-0 text-muted">
                    <i class="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
                  </span>
                  <input type="search"
                         id="#local.searchDomId#"
                         class="form-control border-start-0 ps-0"
                         placeholder="Filter files..."
                         data-fe-search-input>
                </div>
              </div>
            </div>

            <div class="fe-card-body p-0">
              <cfif ArrayLen(local.tree.files) GT 0 OR ArrayLen(local.tree.folders) GT 0>
                <div class="table-responsive">
                  <table class="table table-hover align-middle mb-0 fe-file-table">
                    <caption class="visually-hidden">Documents in #EncodeForHTML(local.feTitle)#</caption>
                    <thead>
                      <tr>
                        <th scope="col">Document / Folder</th>
                        <th scope="col" class="d-none d-sm-table-cell text-nowrap">Modified</th>
                        <th scope="col" class="text-end text-nowrap">Size</th>
                        <th scope="col" class="text-end text-nowrap">Action</th>
                      </tr>
                    </thead>
                    <tbody>
                      <!--- Subfolders with expandable file rows --->
                      <cfloop array="#local.tree.folders#" index="local.folder">
                        <cfif local.folder.fileCount GT 0>
                          <cfset local.groupDomId = "fe-full-group-" & local.feId & "-" & ReReplace(local.folder.key, "[^a-z0-9_-]", "-", "all")>
                          <tr class="fe-folder-group-row" data-fe-group-header="#EncodeForHTMLAttribute(local.folder.key)#">
                            <td colspan="4" class="p-0">
                              <button type="button"
                                      class="fe-folder-toggle-btn"
                                      aria-expanded="true"
                                      aria-controls="#local.groupDomId#"
                                      data-fe-toggle-folder="#EncodeForHTMLAttribute(local.folder.key)#">
                                <span class="d-inline-flex align-items-center gap-2">
                                  <i class="fa-solid fa-folder-open text-brand fe-toggle-folder-icon" aria-hidden="true"></i>
                                  <span class="fw-bold">#EncodeForHTML(local.folder.fullLabel)#</span>
                                  <span class="badge rounded-pill bg-secondary bg-opacity-10 text-dark fw-semibold">#local.folder.fileCount#</span>
                                </span>
                                <i class="fa-solid fa-chevron-down fe-toggle-chevron" aria-hidden="true"></i>
                              </button>
                            </td>
                          </tr>
                          <cfloop array="#local.tree.files#" index="local.fileItem">
                            <cfif local.fileItem.folderKey EQ local.folder.key>
                              <tr data-fe-file-row
                                  data-fe-folder="#EncodeForHTMLAttribute(local.fileItem.folderKey)#"
                                  data-fe-search-text="#EncodeForHTMLAttribute(LCase(local.fileItem.displayName & ' ' & local.fileItem.folderLabel & ' ' & local.fileItem.extension))#">
                                <td class="ps-4">
                                  <div class="d-flex align-items-center gap-2">
                                    <span class="fe-ext-badge #EncodeForHTMLAttribute(local.fileItem.badgeClass)#" aria-hidden="true">
                                      #EncodeForHTML(local.fileItem.badgeLabel)#
                                    </span>
                                    <a href="#EncodeForHTMLAttribute(local.fileItem.viewUrl)#"
                                       <cfif local.fileItem.openInNewTab>target="_blank" rel="noopener noreferrer"</cfif>
                                       class="fe-file-link fw-semibold">
                                      #EncodeForHTML(local.fileItem.displayName)#
                                      <cfif local.fileItem.openInNewTab><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                                    </a>
                                  </div>
                                </td>
                                <td class="d-none d-sm-table-cell text-muted small text-nowrap">
                                  #EncodeForHTML(local.fileItem.dateFormatted)#
                                </td>
                                <td class="text-end text-muted small text-nowrap">
                                  #EncodeForHTML(local.fileItem.sizeFormatted)#
                                </td>
                                <td class="text-end text-nowrap">
                                  <a href="#EncodeForHTMLAttribute(local.fileItem.downloadUrl)#"
                                     class="btn btn-outline-secondary btn-sm fe-download-btn"
                                     aria-label="Download #EncodeForHTMLAttribute(local.fileItem.displayName)# (#EncodeForHTMLAttribute(local.fileItem.sizeFormatted)#)">
                                    <i class="fa-solid fa-download" aria-hidden="true"></i>
                                    <span class="d-none d-lg-inline ms-1">Download</span>
                                  </a>
                                </td>
                              </tr>
                            </cfif>
                          </cfloop>
                        </cfif>
                      </cfloop>

                      <!--- Root-level files --->
                      <cfloop array="#local.tree.files#" index="local.fileItem">
                        <cfif local.fileItem.folderKey EQ "root">
                          <tr data-fe-file-row
                              data-fe-folder="root"
                              data-fe-search-text="#EncodeForHTMLAttribute(LCase(local.fileItem.displayName & ' ' & local.fileItem.extension))#">
                            <td>
                              <div class="d-flex align-items-center gap-2">
                                <span class="fe-ext-badge #EncodeForHTMLAttribute(local.fileItem.badgeClass)#" aria-hidden="true">
                                  #EncodeForHTML(local.fileItem.badgeLabel)#
                                </span>
                                <a href="#EncodeForHTMLAttribute(local.fileItem.viewUrl)#"
                                   <cfif local.fileItem.openInNewTab>target="_blank" rel="noopener noreferrer"</cfif>
                                   class="fe-file-link fw-semibold">
                                  #EncodeForHTML(local.fileItem.displayName)#
                                  <cfif local.fileItem.openInNewTab><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                                </a>
                              </div>
                            </td>
                            <td class="d-none d-sm-table-cell text-muted small text-nowrap">
                              #EncodeForHTML(local.fileItem.dateFormatted)#
                            </td>
                            <td class="text-end text-muted small text-nowrap">
                              #EncodeForHTML(local.fileItem.sizeFormatted)#
                            </td>
                            <td class="text-end text-nowrap">
                              <a href="#EncodeForHTMLAttribute(local.fileItem.downloadUrl)#"
                                 class="btn btn-outline-secondary btn-sm fe-download-btn"
                                 aria-label="Download #EncodeForHTMLAttribute(local.fileItem.displayName)# (#EncodeForHTMLAttribute(local.fileItem.sizeFormatted)#)">
                                <i class="fa-solid fa-download" aria-hidden="true"></i>
                                <span class="d-none d-lg-inline ms-1">Download</span>
                              </a>
                            </td>
                          </tr>
                        </cfif>
                      </cfloop>
                    </tbody>
                  </table>
                </div>
                <div class="p-4 text-center text-muted d-none" data-fe-empty-state>
                  <i class="fa-regular fa-folder-open fa-lg mb-2 d-block text-brand" aria-hidden="true"></i>
                  No documents match your filter criteria.
                </div>
              <cfelse>
                <div class="p-4 text-center text-muted">
                  <i class="fa-regular fa-folder-open fa-lg mb-2 d-block text-brand" aria-hidden="true"></i>
                  This folder is currently empty.
                </div>
              </cfif>
            </div>
          </div>
        </cfif>
      </section>
    </cfif>
  </cfloop>
</cfoutput>

  <script>
  (function () {
    if (window.__ccFolderExplorerInit) return;
    window.__ccFolderExplorerInit = true;

    function initExplorerSection(section) {
      var layout = section.getAttribute("data-fe-layout") || "Full";
      var searchInput = section.querySelector("[data-fe-search-input]");
      var folderBtns = Array.prototype.slice.call(section.querySelectorAll("[data-fe-folder-btn]"));
      var fileRows = Array.prototype.slice.call(section.querySelectorAll("[data-fe-file-row]"));
      var emptyState = section.querySelector("[data-fe-empty-state]");
      var activeHeading = section.querySelector("[data-fe-active-folder-heading]");
      var countBadge = section.querySelector("[data-fe-count-badge]");
      var liveStatus = section.querySelector('[role="status"]');
      var toggleBtns = Array.prototype.slice.call(section.querySelectorAll("[data-fe-toggle-folder]"));
      var collapsedFolders = {};
      var currentFolder = "all";

      folderBtns.forEach(function (btn) {
        if (btn.getAttribute("aria-selected") === "true") {
          currentFolder = btn.getAttribute("data-fe-folder-btn") || "all";
        }
      });

      function applyFilters() {
        var q = searchInput ? searchInput.value.trim().toLowerCase() : "";
        var visibleCount = 0;

        fileRows.forEach(function (row) {
          var rowFolder = row.getAttribute("data-fe-folder") || "root";
          var haystack = row.getAttribute("data-fe-search-text") || "";
          var folderMatch = (layout !== "3/9")
            || (currentFolder === "all")
            || (rowFolder === currentFolder)
            || (rowFolder.indexOf(currentFolder + "/") === 0);
          var searchMatch = !q || haystack.indexOf(q) !== -1;
          var isCollapsed = (layout === "Full" && !q && collapsedFolders[rowFolder] === true);
          var show = folderMatch && searchMatch && !isCollapsed;

          row.classList.toggle("d-none", !show);
          if (folderMatch && searchMatch) {
            visibleCount++;
          }

          var crumb = row.querySelector("[data-fe-row-crumb]");
          if (crumb) {
            crumb.classList.toggle("d-none", currentFolder !== "all" && rowFolder === currentFolder);
          }
        });

        if (layout === "Full") {
          var groupHeaders = Array.prototype.slice.call(section.querySelectorAll("[data-fe-group-header]"));
          groupHeaders.forEach(function (hdr) {
            var gKey = hdr.getAttribute("data-fe-group-header");
            if (!q) {
              hdr.classList.remove("d-none");
              return;
            }
            var hasMatchInGroup = fileRows.some(function (r) {
              return r.getAttribute("data-fe-folder") === gKey && !r.classList.contains("d-none");
            });
            hdr.classList.toggle("d-none", !hasMatchInGroup);
          });
        }

        if (emptyState) {
          emptyState.classList.toggle("d-none", visibleCount > 0);
        }
        if (countBadge) {
          countBadge.textContent = visibleCount + (visibleCount === 1 ? " document" : " documents");
        }
        if (liveStatus) {
          liveStatus.textContent = visibleCount + (visibleCount === 1 ? " document shown." : " documents shown.");
        }
      }

      function selectFolder(btn) {
        var targetKey = btn.getAttribute("data-fe-folder-btn") || "all";
        var targetLabel = btn.getAttribute("data-fe-folder-label") || "All Documents";
        currentFolder = targetKey;

        folderBtns.forEach(function (b) {
          var isMatch = (b === btn);
          b.classList.toggle("active", isMatch);
          b.setAttribute("aria-selected", isMatch ? "true" : "false");
          b.setAttribute("tabindex", isMatch ? "0" : "-1");
          var icon = b.querySelector(".fe-folder-icon");
          if (icon) {
            icon.classList.toggle("fa-folder-open", isMatch);
            icon.classList.toggle("fa-folder", !isMatch);
          }
        });

        if (activeHeading) {
          activeHeading.textContent = targetLabel;
        }
        applyFilters();
      }

      folderBtns.forEach(function (btn, idx) {
        btn.addEventListener("click", function () {
          selectFolder(btn);
        });
        btn.addEventListener("keydown", function (e) {
          var nextIdx = -1;
          if (e.key === "ArrowDown") {
            e.preventDefault();
            nextIdx = (idx + 1) % folderBtns.length;
          } else if (e.key === "ArrowUp") {
            e.preventDefault();
            nextIdx = (idx - 1 + folderBtns.length) % folderBtns.length;
          } else if (e.key === "Home") {
            e.preventDefault();
            nextIdx = 0;
          } else if (e.key === "End") {
            e.preventDefault();
            nextIdx = folderBtns.length - 1;
          }
          if (nextIdx >= 0 && folderBtns[nextIdx]) {
            selectFolder(folderBtns[nextIdx]);
            folderBtns[nextIdx].focus();
          }
        });
      });

      toggleBtns.forEach(function (btn) {
        btn.addEventListener("click", function () {
          var fKey = btn.getAttribute("data-fe-toggle-folder");
          var isCurrentlyExpanded = btn.getAttribute("aria-expanded") === "true";
          var nextExpanded = !isCurrentlyExpanded;
          btn.setAttribute("aria-expanded", nextExpanded ? "true" : "false");
          collapsedFolders[fKey] = !nextExpanded;
          var folderIcon = btn.querySelector(".fe-toggle-folder-icon");
          if (folderIcon) {
            folderIcon.classList.toggle("fa-folder-open", nextExpanded);
            folderIcon.classList.toggle("fa-folder", !nextExpanded);
          }
          applyFilters();
        });
      });

      if (searchInput) {
        searchInput.addEventListener("input", applyFilters);
      }

      applyFilters();
    }

    function bootAll() {
      var sections = document.querySelectorAll("[data-fe-instance]");
      Array.prototype.forEach.call(sections, initExplorerSection);
    }

    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", bootAll);
    } else {
      bootAll();
    }
  })();
  </script>
</cfif>

