# ChelanCounty.gov — Engineering Roadmap & Frontend TODO

**Project:** Chelan County Public Frontend Website  
**Production URL:** `https://www.co.chelan.wa.us/` / `http://chelancounty.gov/`  
**Platform:** CFWheels 4.2.0 + Lucee CFML / IIS 10.0 + Microsoft SQL Server (`ChelanCountyWebsite`)  
**Shared CMS:** Managed by CMSAdmin 2.0 (`C:\inetpub\CMSAdmin2.0`)  
**Compliance Standard:** ADA Title II, Section 508, WCAG 2.1 & 2.2 Level AA  
**Last Updated:** 2026-10-17  

---

## 🏛️ Phase 1: Foundation & Core Framework Architecture (Completed)

Foundational setup, database models, reusable component architecture, and the Assessor pilot.

- [x] **1.1 CFWheels 4.2.0 Platform Upgrade & Setup**
  - [x] Upgraded base application to Wheels 4.2.0 with proper `Application.cfc` lifecycle methods and reload credentials (`?reload=true&password=chelancms`).
  - [x] Configured MCP agent protocols (`.mcp.json`, `.opencode.json`, `AGENTS.md`, `CLAUDE.md`).
  - [x] Configured master accessible HTML shell in [`app/views/layout.cfm`](file:///c:/inetpub/ChelanCounty.gov/app/views/layout.cfm) with skip link, Google Fonts, Bootstrap 5.3.3, and `#wheels-debugbar` ARIA role handling.
- [x] **1.2 Database Models & Entity Relations (`app/models/`)**
  - [x] [`Page.cfc`](file:///c:/inetpub/ChelanCounty.gov/app/models/Page.cfc): Maps to `dbo.pages` (Primary key `ContentID`, associations to `SubPage` and `FolderExplorer`).
  - [x] [`SubPage.cfc`](file:///c:/inetpub/ChelanCounty.gov/app/models/SubPage.cfc): Maps to `dbo.page_SubPage` (`belongsTo("page")`).
  - [x] [`FolderExplorer.cfc`](file:///c:/inetpub/ChelanCounty.gov/app/models/FolderExplorer.cfc): Maps to `dbo.page_FolderExplorer` (`belongsTo("page")`).
  - [x] [`CtaCard.cfc`](file:///c:/inetpub/ChelanCounty.gov/app/models/CtaCard.cfc): Maps to `dbo.page_CtaCard` (`belongsTo("page")`).
  - [x] [`NavigationMenu.cfc`](file:///c:/inetpub/ChelanCounty.gov/app/models/NavigationMenu.cfc): Maps to `dbo.navigation_menus` (`hasMany("navigationMenuItems")`).
  - [x] [`NavigationMenuItem.cfc`](file:///c:/inetpub/ChelanCounty.gov/app/models/NavigationMenuItem.cfc): Maps to `dbo.navigation_menu_items` (`belongsTo("navigationMenu")`, `belongsTo("parentItem")`, `hasMany("childItems")`).
- [x] **1.3 Global Functions & Workspace Helpers (`app/global/functions.cfm`)**
  - [x] `resolveCandidateSiteIds()`: Auto-resolves workspace codes, aliases, virtual directories, and singular/plural variants from `dbo.cms_workspaces`.
  - [x] `getNavigation()`: Builds hierarchical multi-level menu tree with orphan fallback and publication status filtering (`isPagePublishedAndActive()`).
  - [x] `getWorkspace()`: Extracts workspace brand color (`color`), dark tone (`colorDark`), dynamic hero gradient (`heroGradient`), office hours, and contact info.
  - [x] `getAttachedSidebars()` & `getAttachedCtaCards()`: Queries attached sidebar cards and Call to Action cards for a given page.
  - [x] `loadFolderExplorerTree()` & `resolveFolderExplorerRoot()`: Deep directory scanner supporting both 3/9 Grid and Full layouts, document metadata badges, and secure file streaming.
  - [x] `isPagePublishedAndActive()`: Enforces `StatusCode = 'Active' AND isPublished = 1 AND Visibility = 'Published' AND DeletedAt IS NULL`.
- [x] **1.4 CMS Shortcode & Content Rendering Engine (`app/views/helpers.cfm`)**
  - [x] `renderCmsContent()`: Resolves embedded shortcodes inside page HTML (`[cta_grid]`, `[call_to_action]`, `[cta]`, `[chelan_form]`).
  - [x] `renderCallToActionShortcodes()`: Generates responsive `.jbd-cta-grid` and `.jbd-cta-card` containers with image lazy loading and action buttons.
  - [x] `normalizeCtaLinkIcons()`: Automatically converts trailing Unicode entities into clean, accessible inline SVG arrows and external link icons.
  - [x] `svgIcon()`: Sitewide inline SVG icon helper with accessibility labels.
- [x] **1.5 Modular Department Views & Component Partials (`app/views/shared/`)**
  - [x] `_dept-hero.cfm`: Department hero banner with dynamic workspace gradient and breadcrumbs.
  - [x] `_dept-nav.cfm`: Left-hand collapsible navigation tree with workspace color theme injection and `aria-current="page"`.
  - [x] `_dept-contact.cfm`: Office location, contact names, telephone, fax, email, and office hours card.
  - [x] `_dept-official.cfm`: Elected official / department head photo card with badge and direct contact button.
  - [x] `_dept-overview.cfm`: Rendered page body, featured image attachment, and shortcode parser.
  - [x] `_dept-cta-cards.cfm`: Dynamic service cards (`dbo.page_CtaCard`) with fallback support.
  - [x] `_dept-folder-explorer.cfm`: Accessible document directory browser with search filter, folder counts, and file streaming.
  - [x] `_dept-right-sidebar.cfm`: Contextual subpage cards (`dbo.page_SubPage`) for Right Sidebar layouts.
  - [x] `_dept-highlights.cfm`, `_dept-notice-bar.cfm`, `_dept-notifications.cfm`, `_dept-meta.cfm`: Taxpayer highlights, statutory notice callouts, active alerts, and timestamp metadata.
- [x] **1.6 Pilot Department: Assessor (`app/controllers/Assessor.cfc`)**
  - [x] `/assessor` &rarr; `assessor#index`: Landing page with dynamic workspace theme injection.
  - [x] `/assessor/page/[slug]` &rarr; `assessor#page`: Subpage resolver with styled 404 empty-state card for inactive/unpublished slugs.
  - [x] `/assessor/file` &rarr; `assessor#file`: Secure, canonical path-validated document streaming endpoint.

---

## 🚀 Phase 2: Multi-Tenant Department Engine & Routing (Top Priority)

Expanding beyond the Assessor pilot to dynamically power all 24+ Chelan County departments without code duplication.

- [ ] **2.1 Unified Department Controller (`Workspaces.cfc`)**
  - [ ] Create a consolidated `Workspaces.cfc` (or dynamic route dispatcher) that resolves any active workspace from `dbo.cms_workspaces` via URL segment:
    - `/:workspace` &rarr; `workspaces#index` (e.g. `/auditor`, `/sheriff`, `/treasurer`, `/clerk`, `/public-works`, etc.)
    - `/:workspace/page/[slug]` &rarr; `workspaces#page`
    - `/:workspace/file` &rarr; `workspaces#file` (Unified document streaming across all departments)
  - [ ] Automatically bind department identity, office contact card, official photo, primary theme color, and navigation tree based on the matched workspace.
  - [ ] Retain backwards compatibility for `/assessor` while enabling all 24 departments from the primary mega-menu:
    - *Elected Offices:* Assessor, Auditor, Clerk, Coroner, Prosecuting Attorney, Sheriff, Treasurer, Board of County Commissioners (BOCC).
    - *Courts & Justice:* District Court, District Court Probation, Superior Court, Juvenile Justice Center, Law Library, Regional Justice Center (CCRJ).
    - *County Operations:* Community Development, Public Works, Natural Resources, Human Resources, Elections, Emergency Management, Fire Marshal, Solid Waste Management, Public Records.
    - *Community Outreach:* Boundary Review Board, Chelan County Expo Center, Farm Worker Housing, Homeless Housing Network, Horticultural Pest Board, Noxious Weed Control, Veterans Program, Wenatchee River County Park, WSU Extension.
- [ ] **2.2 Subdomain Multi-Tenancy Architecture (Future-Proofing)**
  - [ ] Enable host header inspection in `Controller.cfc` to bind workspace from subdomains (e.g. `assessor.chelancounty.gov`, `parks.chelancounty.gov`) when deployed in multi-domain IIS bindings.

---

## 🔍 Phase 3: Public Civic Services & Search (Immediate Next Value)

High-visibility citizen features connecting public users to county data.

- [ ] **3.1 Full-Text Page Search (`Search.cfc` & `/search`)**
  - [ ] Connect the search input in [`app/views/includes/header.cfm`](file:///c:/inetpub/ChelanCounty.gov/app/views/includes/header.cfm) to a dedicated `Search.cfc` controller.
  - [ ] Execute `dbo.usp_SearchPages @Query, @SiteID, @MaxResults` against the SQL Server full-text catalog (`ft_cms`).
  - [ ] Render accessible search results page with highlighted search terms, department badges, result counts, and pagination.
- [ ] **3.2 Live Emergency Alerts Banner (`_alert.cfm`)**
  - [ ] Wire `_alert.cfm` into [`layout.cfm`](file:///c:/inetpub/ChelanCounty.gov/app/views/layout.cfm) to pull active emergency alerts from `dbo.emergency_alerts` (`is_active = 1 AND (starts_at IS NULL OR starts_at <= GETDATE()) AND (expires_at IS NULL OR expires_at >= GETDATE())`).
  - [ ] Render severity-styled banners: Critical / Wildfire (Red), Warning (Orange), Notice / Facility Closure (Blue).
  - [ ] Provide client-side dismissible functionality stored in `sessionStorage`.
- [ ] **3.3 Public Solicitations & Bid Board (`Bids.cfc` & `/bids`)**
  - [ ] Connect the public frontend to `dbo.rfp_solicitations` created in CMSAdmin 2.0 Feature 3.5.
  - [ ] Public Bid Board view (`/bids`) listing Open, Under Review, and Awarded RFPs, RFQs, and ITBs.
  - [ ] Solicitation detail view (`/bids/view/[slug]`) with downloadable addenda, deadline countdown timer, and Planholder self-registration form.
- [ ] **3.4 "How Do I" Citizen Directory (`/how-do-i`)**
  - [ ] Create dedicated `/how-do-i` portal page organizing common citizen requests:
    - *Apply For:* Jobs, Building Permits, CPL, Address, Road Adoption.
    - *Pay For:* Property Taxes, Infractions, Recording Fees, Utility Assessments.
    - *Report:* Road Hazards, Code Violations, Lost Property, Noxious Weeds.
    - *Find:* Parcel Data, Jail Roster, Recorded Documents, Court Dockets, Maps.
  - [ ] Add live search filter for quick instant filtering of citizen tasks.

---

## 📝 Phase 4: Citizen Interactivity, Forms & Public Records

- [ ] **4.1 Dynamic Public Form Rendering (`[chelan_form]`)**
  - [ ] Expand shortcode parser `renderCmsContent()` to dynamically query `dbo.forms` and `dbo.form_fields` by slug or ID.
  - [ ] Render accessible form controls with explicit `<label for="...">`, required field indicators, and helper text.
  - [ ] Implement spam prevention: Hidden honeypot input, 3-second speed-trap timestamp, and CSRF token verification.
  - [ ] Process submissions via `Forms.cfc:submit()` with email notifications and database persistence (`dbo.form_submissions`).
- [ ] **4.2 Public Records Request (PRR) Portal (`/public-records`)**
  - [ ] Build dedicated Public Records intake portal under Washington State Public Records Act (RCW 42.56).
  - [ ] Department-routed request intake with statutory tracking and automated receipt confirmation.
- [ ] **4.3 County Calendar & Upcoming Meetings (`_calendar.cfm`)**
  - [ ] Connect `_calendar.cfm` to `dbo.calendar_events` for Commissioners meetings, public hearings, and community events.
  - [ ] Provide filtering by department (`siteid`) and exportable iCal / Google Calendar links.
- [ ] **4.4 News & Public Information Officer (PIO) Portal (`_news-main.cfm`)**
  - [ ] Wire `_news-main.cfm` to `dbo.articles` for county-wide press releases, wildfire updates, and department announcements.
  - [ ] Detail view for articles with image galleries, media contacts, and social share links.

---

## 🛡️ Phase 5: Accessibility Verification, Performance & SEO

- [ ] **5.1 Automated WCAG 2.2 Level AA Testing Suite**
  - [ ] Set up automated `axe-core` accessibility audit spec (`tests/specs/accessibility/`):
    - Homepage (`/`)
    - Department Landing Page (`/assessor`, `/auditor`, etc.)
    - Department CMS Subpage (Full Layout & Right Sidebar Layout)
    - Folder Explorer & Search Results
  - [ ] Verify zero violations for contrast, landmark regions, target sizes ($\ge 24\times 24$px), and focus appearances.
- [ ] **5.2 XML Sitemap & SEO Optimization**
  - [ ] Dynamic `/sitemap.xml` generating live URLs for all active, published department pages.
  - [ ] Dynamic `/robots.txt` honoring CMSAdmin 2.0 SEO settings.
  - [ ] Auto-inject OpenGraph and Twitter card metadata from `pages.MetaTitle`, `pages.MetaDesc`, and `pages.imageAttachment`.
- [ ] **5.3 Caching & Performance Optimization**
  - [ ] In-memory caching for navigation menus and workspace configurations (`application.menuCache`, `application.wsCache`).
  - [ ] Cache purging hook integrated with CMSAdmin 2.0 save actions.
  - [ ] Static asset minification and HTTP caching headers via `web.config`.

