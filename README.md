# ChelanCounty.gov
Public Frontend Website for Chelan County (`C:\inetpub\ChelanCounty.gov`).

Built on [Wheels](https://wheels.dev) (v4.x) and CFML, backed by the shared `ChelanCountyWebsite` SQL Server database managed by **CMSAdmin 2.0** (`C:\inetpub\CMSAdmin2.0`).

## Architecture & Relationship with CMSAdmin 2.0

- **`CMSAdmin2.0` (`C:\inetpub\CMSAdmin2.0`)** is the administrative **Content Management System** where county staff manage department workspaces, pages, navigation menus, forms, media, and jobs.
- **`ChelanCounty.gov` (`C:\inetpub\ChelanCounty.gov`)** is one of the public-facing frontend applications that consumes the `ChelanCountyWebsite` database managed by `CMSAdmin2.0`.

### How Frontend Controllers Consume CMSAdmin 2.0 Data
1. **Workspace Theme & Primary Color Variables (`getWorkspace(siteid)` in `app/global/functions.cfm` & `app/views/layout.cfm`)**
   - Queries `dbo.cms_workspaces` (`is_active = 1 AND deletedat IS NULL`) for brand color (`color`), dynamic hero gradient (`darkenHexColor()`), office contact info, address, and office hours.
   - Maps the active workspace color onto `--bs-primary`, `--bs-primary-rgb`, `--brand-900`, `--brand-800`, `--link-700`, `--dept-color`, `--dept-theme-color`, and `--dept-theme-dark` so headers, side navigation (`.dept-nav`), buttons, links, and status cards automatically inherit the department's primary color.
2. **Navigation Menus (`getNavigation(siteid, menuKey)` in `app/global/functions.cfm`)**
   - Queries `dbo.navigation_menus` and `dbo.navigation_menu_items` for the requested workspace (`siteid`, e.g. `"assessor"`, `"global"`) and menu slot (`"side"`, `"top"`, `"footer"`).
   - Automatically resolves workspace aliases, codes, virtual directories (`dbo.cms_workspaces`), and singular/plural variants via `resolveCandidateSiteIds()`.
   - Filters out internal workspace page links whose target page in `dbo.pages` is not both Active and Published (`StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published' AND DeletedAt IS NULL`).
   - Returns a nested array of active menu items (`id`, `title`, `url`, `target`, `icon`, `children`).
3. **Department Pages & Shortcode Resolution (`dbo.pages` & `renderCmsContent()` in `app/views/helpers.cfm`)**
   - Department controllers (such as `app/controllers/Assessor.cfc`) load only published and active page content (`StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published' AND DeletedAt IS NULL`) by matching `SiteID` and `Permalink`.
   - `renderCmsContent()` resolves embedded shortcodes in `content.Body`:
     - `[cta_grid slugs="..." cols="2|3|4"]` and `[cta_grid category="..."]` &rarr; responsive `.jbd-cta-grid` sections populated from `dbo.page_call_to_actions`.
     - `[call_to_action slug="..."]` / `[cta id="..."]` &rarr; individual `.jbd-cta-card` cards with inline SVG `.jbd-cta-link` icons (`normalizeCtaLinkIcons()`).
     - `[chelan_form slug="..."]` / `[chelan_form id="..."]` &rarr; auto-resizing embedded forms.
   - Subpage requests for unpublished, inactive, or non-existent slugs return HTTP `404 Not Found` with a workspace-themed empty-state card (`app/views/assessor/page.cfm`).
4. **Reusable Department Partials (`app/views/shared/`)**
   - `_dept-hero.cfm`: Department hero banner with dynamic workspace gradient and breadcrumbs.
   - `_dept-notice-bar.cfm` & `_dept-notifications.cfm`: Important deadlines and emergency/department notifications.
   - `_dept-nav.cfm` & `_dept-contact.cfm`: Left-hand multi-level navigation menu and office contact card following the selected workspace color.
   - `_dept-cta-cards.cfm`: Dynamic Call to Action (CTA) cards driven by `dbo.page_CtaCard` (`getAttachedCtaCards()`).
   - `_dept-overview.cfm`: Dynamic page body, image attachments, and rich-text template blocks (`stylesheets/jbd-templates.css` & `stylesheets/styles.css`).
   - `_dept-folder-explorer.cfm`: Document repository and folder explorer driven by `dbo.page_FolderExplorer` (`getAttachedFolderExplorers()` & `loadFolderExplorerTree()`), supporting both **3/9 Grid** (folder tree + file table) and **Full Width** layouts, with secure file streaming/downloading via `/assessor/file`.
   - `_dept-right-sidebar.cfm`: Right-hand contextual subpage cards driven by `dbo.page_subpages` (`getAttachedSidebars()`).
   - `_dept-official.cfm`, `_dept-highlights.cfm`, `_dept-meta.cfm`: Elected official profile, statutory highlights, and page revision timestamp metadata.
5. **Website Search (`dbo.usp_SearchPages`)**
   - Full-text search across published pages is powered by SQL Server Full-Text Search (`ft_cms` catalog on `dbo.pages`) using `EXEC dbo.usp_SearchPages @Query, @SiteID, @MaxResults`.

## Reloading Application Scope
Because `app/global/functions.cfm` and `app/views/helpers.cfm` are cached in the Wheels `application` scope, reload the application after modifying global functions or configuration:
```
http://chelancounty.gov/?reload=true&password=chelancms
```
