# ChelanCounty.gov
Public Frontend Website for Chelan County (`C:\inetpub\ChelanCounty.gov`).

Built on [Wheels](https://wheels.dev) (v4.x) and CFML, backed by the shared `ChelanCountyWebsite` SQL Server database managed by **CMSAdmin 2.0** (`C:\inetpub\CMSAdmin2.0`).

## Architecture & Relationship with CMSAdmin 2.0

- **`CMSAdmin2.0` (`C:\inetpub\CMSAdmin2.0`)** is the administrative **Content Management System** where county staff manage department workspaces, pages, navigation menus, forms, media, and jobs.
- **`ChelanCounty.gov` (`C:\inetpub\ChelanCounty.gov`)** is one of the public-facing frontend applications that consumes the `ChelanCountyWebsite` database managed by `CMSAdmin2.0`.

### How Frontend Controllers Consume CMSAdmin 2.0 Data
1. **Navigation Menus (`getNavigation(siteid, menuKey)` in `app/global/functions.cfm`)**
   - Queries `dbo.navigation_menus` and `dbo.navigation_menu_items` for the requested workspace (`siteid`, e.g. `"assessor"`, `"global"`) and menu slot (`"side"`, `"top"`, `"footer"`).
   - Automatically resolves workspace aliases, codes, virtual directories (`dbo.cms_workspaces`), and singular/plural variants via `resolveCandidateSiteIds()`.
   - Returns a nested array of active menu items (`id`, `title`, `url`, `target`, `icon`, `children`).
   - Icons selected in CMSAdmin 2.0's Navigation Manager can be rendered in views using `#svgIcon(name=item.icon)#` (`app/views/helpers.cfm`).
2. **Department Pages (`dbo.pages`)**
   - Department controllers (such as `app/controllers/Assessor.cfc`) load published page content (`Status = 'published'`) by matching `SiteID` and `slug` / `id`.
3. **Website Search (`dbo.usp_SearchPages`)**
   - Full-text search across published pages is powered by SQL Server Full-Text Search (`ft_cms` catalog on `dbo.pages`) using `EXEC dbo.usp_SearchPages @Query, @SiteID, @MaxResults`.

## Reloading Application Scope
Because `app/global/functions.cfm` and `app/views/helpers.cfm` are cached in the Wheels `application` scope, reload the application after modifying global functions or configuration:
```
http://chelancounty.gov/?reload=true&password=chelancms
```
