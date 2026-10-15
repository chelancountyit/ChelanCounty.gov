<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/assessor/page.cfm - Chelan County Assessor Department Subpage --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="content" default="">
<cfparam name="nav" default="#[]#">
<cfparam name="sidebars" default="#queryNew('ID,ContentID,SiteID,Title,Body,Position')#">
<cfparam name="ctaCards" default="#getAttachedCtaCards(content)#">
<cfparam name="hasSidebar" default="false">
<cfparam name="layoutType" default="full">
<cfset local.showSidebar = (isBoolean(hasSidebar) and hasSidebar) or (isQuery(sidebars) and sidebars.recordCount GT 0) or (isArray(sidebars) and ArrayLen(sidebars) GT 0)>
<cfset local.pageTitle = (isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title))) ? Trim(content.Title) : "Chelan County Assessor">
<cfoutput>

<!-- ==========================================================================
     Department Hero Banner
     Gradient banner with accessible breadcrumb and department identity
     ========================================================================== -->
<section class="dept-hero text-white position-relative" aria-label="Department Header"<cfif isStruct(site) and StructKeyExists(site, "color") and Len(Trim(site.color))> style="--dept-hero-start: #site.color#; --dept-hero-end: #site.colorDark#; background: #site.heroGradient#;"</cfif>>
  <div class="container">
    <nav aria-label="Breadcrumb" class="mb-3">
      <ol class="breadcrumb breadcrumb-gov mb-0">
        <li class="breadcrumb-item"><a href="/"><i class="fa-solid fa-house me-1" aria-hidden="true"></i>Home</a></li>
        <li class="breadcrumb-item"><a href="##primaryNav">Your Government</a></li>
        <li class="breadcrumb-item"><a href="/assessor">Assessor</a></li>
        <li class="breadcrumb-item active" aria-current="page">#EncodeForHTML(local.pageTitle)#</li>
      </ol>
    </nav>
    <div class="row align-items-center">
      <div class="col-lg-9">
        <p class="dept-title display-5 fw-bold mb-2">
          <cfif isDefined("site.name") and len(trim(site.name))>#EncodeForHTML(site.name)#<cfelse>Chelan County Assessor</cfif>
        </p>
        <p class="dept-tagline lead mb-0">
          Determining fair, equitable, and uniform property valuations for Chelan County taxpayers according to Washington State law.
        </p>
      </div>
      <div class="col-lg-3 text-lg-end mt-3 mt-lg-0 d-none d-lg-block">
        <a href="tel:5096676365" class="btn btn-outline-light btn-sm rounded-pill px-3 py-2 fw-semibold">
          <i class="fa-solid fa-phone me-1" aria-hidden="true"></i> (509) 667-6365
        </a>
      </div>
    </div>
  </div>
</section>

<!-- Wave Transition Divider -->
<div class="dept-wave-divider" aria-hidden="true"></div>

<!-- ==========================================================================
     Department Content Grid
     Left Sidebar (col-lg-3): Elected Official, Dynamic Navigation (`nav`), & Office Info
     Main Content (col-lg-6 with sidebar, or col-lg-9 full layout): Page Content (`content`)
     Right Sidebar (col-lg-3 when attached sidebars exist): Attached `sidebars`
     ========================================================================== -->
<div class="container py-4">

  <!--- Active Notifications / Emergency Alerts if defined --->
  <cfif isDefined("notifications") and isQuery(notifications) and notifications.recordCount GT 0>
    <div class="alert alert-warning d-flex align-items-start gap-3 shadow-sm mb-4" role="alert">
      <i class="fa-solid fa-triangle-exclamation fs-4 mt-1 text-warning" aria-hidden="true"></i>
      <div>
        <h2 class="h5 alert-heading mb-1">Important Notice</h2>
        <cfloop query="notifications">
          <p class="mb-0">#EncodeForHTML(notifications.title)#: #EncodeForHTML(notifications.message)#</p>
        </cfloop>
      </div>
    </div>
  </cfif>

  <div class="row g-4 g-lg-5">

    <!-- ======================================================================
         Sidebar Column (col-lg-3 col-md-4) — Left Navigation & Official Info
         ====================================================================== -->
    <aside class="col-lg-3 col-md-4" aria-label="Department information and navigation">

     

      <!-- Department Navigation (Driven by `nav` table) -->
      <nav class="dept-nav-card" aria-label="Assessor Department Navigation">
        <p class="dept-nav-header">
          <i class="fa-solid fa-folder-tree me-1" aria-hidden="true"></i> Assessor Menu
        </p>
        <ul class="dept-nav-list">
          <cfif isArray(nav) and ArrayLen(nav) GT 0>
            <cfloop array="#nav#" index="local.item">
              <cfset local.itemUrl = StructKeyExists(local.item, "url") and Len(Trim(local.item.url)) ? Trim(local.item.url) : "##">
              <cfset local.itemLabel = StructKeyExists(local.item, "label") and Len(Trim(local.item.label)) ? Trim(local.item.label) : (StructKeyExists(local.item, "title") ? Trim(local.item.title) : "")>
              <cfset local.itemIcon = StructKeyExists(local.item, "icon") and isSimpleValue(local.item.icon) ? Trim(local.item.icon) : "">
              <cfset local.hasChildren = StructKeyExists(local.item, "children") and isArray(local.item.children) and ArrayLen(local.item.children) GT 0>
              <cfset local.isCurrent = false>
              <cfif StructKeyExists(params, "slug") and Len(Trim(params.slug)) and Right(local.itemUrl, Len(Trim(params.slug))) EQ Trim(params.slug)>
                <cfset local.isCurrent = true>
              </cfif>

              <cfif local.hasChildren>
                <cfset local.subnavId = "subnav-" & local.item.id>
                <cfset local.childActive = false>
                <cfloop array="#local.item.children#" index="local.childCheck">
                  <cfif StructKeyExists(params, "slug") and Len(Trim(params.slug)) and StructKeyExists(local.childCheck, "url") and Right(local.childCheck.url, Len(Trim(params.slug))) EQ Trim(params.slug)>
                    <cfset local.childActive = true>
                  </cfif>
                </cfloop>
                <li class="dept-nav-item">
                  <button class="dept-nav-link dept-nav-toggle<cfif local.isCurrent or local.childActive> active</cfif>"
                          type="button"
                          data-bs-toggle="collapse"
                          data-bs-target="###local.subnavId#"
                          aria-expanded="#local.childActive ? 'true' : 'false'#"
                          aria-controls="#local.subnavId#">
                    <span class="d-inline-flex align-items-center">
                      <cfif Len(local.itemIcon)>
                        <span class="me-2 text-brand d-inline-flex align-items-center" aria-hidden="true">#svgIcon(name=local.itemIcon, size=16)#</span>
                      </cfif>
                      #EncodeForHTML(local.itemLabel)#
                    </span>
                    <i class="fa-solid fa-chevron-down chevron-icon" aria-hidden="true"></i>
                  </button>
                  <div class="collapse<cfif local.childActive> show</cfif>" id="#local.subnavId#">
                    <ul class="dept-subnav">
                      <cfloop array="#local.item.children#" index="local.child">
                        <cfset local.childUrl = StructKeyExists(local.child, "url") and Len(Trim(local.child.url)) ? Trim(local.child.url) : "##">
                        <cfset local.childLabel = StructKeyExists(local.child, "label") and Len(Trim(local.child.label)) ? Trim(local.child.label) : (StructKeyExists(local.child, "title") ? Trim(local.child.title) : "")>
                        <cfset local.childNewWin = StructKeyExists(local.child, "newWindow") and isBoolean(local.child.newWindow) and local.child.newWindow>
                        <li>
                          <a href="#EncodeForHTMLAttribute(local.childUrl)#"
                             class="dept-subnav-link"
                             <cfif local.childNewWin>target="_blank" rel="noopener noreferrer"</cfif>>
                            <i class="fa-solid #local.childNewWin ? 'fa-arrow-up-right-from-square' : 'fa-angle-right'# text-brand small" aria-hidden="true"></i>
                            <span>#EncodeForHTML(local.childLabel)#</span>
                            <cfif local.childNewWin><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                          </a>
                        </li>
                      </cfloop>
                    </ul>
                  </div>
                </li>
              <cfelse>
                <cfset local.newWin = StructKeyExists(local.item, "newWindow") and isBoolean(local.item.newWindow) and local.item.newWindow>
                <li class="dept-nav-item">
                  <a href="#EncodeForHTMLAttribute(local.itemUrl)#"
                     class="dept-nav-link<cfif local.isCurrent> active</cfif>"
                     <cfif local.isCurrent>aria-current="page"</cfif>
                     <cfif local.newWin>target="_blank" rel="noopener noreferrer"</cfif>>
                    <span class="d-inline-flex align-items-center">
                      <cfif Len(local.itemIcon)>
                        <span class="me-2 text-brand d-inline-flex align-items-center" aria-hidden="true">#svgIcon(name=local.itemIcon, size=16)#</span>
                      </cfif>
                      <span>#EncodeForHTML(local.itemLabel)#</span>
                      <cfif local.newWin><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                    </span>
                    <i class="fa-solid #local.newWin ? 'fa-arrow-up-right-from-square' : 'fa-chevron-right'# text-muted small" aria-hidden="true"></i>
                  </a>
                </li>
              </cfif>
            </cfloop>
          <cfelse>
            <li class="dept-nav-item">
              <a href="/assessor" class="dept-nav-link">
                <span><i class="fa-solid fa-house me-2 text-brand" aria-hidden="true"></i>Home</span>
                <i class="fa-solid fa-chevron-right text-muted small" aria-hidden="true"></i>
              </a>
            </li>
          </cfif>
        </ul>
      </nav>

      <!-- Office Contact & Hours Card -->
      <div class="dept-contact-card">
        <p>
          <i class="fa-solid fa-building me-2 text-brand" aria-hidden="true"></i> <strong class="fs-5">Office Information</strong>
        </p>
        <p>
          <i class="fa-solid fa-location-dot text-brand me-2" aria-hidden="true"></i>
          <strong>Address:</strong><br>
          350 Orondo Ave, Suite 6<br>
          Wenatchee, WA 98801
        </p>
        <p>
          <i class="fa-solid fa-phone text-brand me-2" aria-hidden="true"></i>
          <strong>Phone:</strong><br>
          <a href="tel:5096676365" class="text-decoration-none fw-semibold">(509) 667-6365</a>
        </p>
        <p>
          <i class="fa-solid fa-fax text-brand me-2" aria-hidden="true"></i>
          <strong>Fax:</strong><br>
          (509) 667-6664
        </p>
        <p>
          <i class="fa-regular fa-clock text-brand me-2" aria-hidden="true"></i>
          <strong>Hours:</strong><br>
          Monday &ndash; Friday<br>
          8:00 AM &ndash; 5:00 PM PST
        </p>
      </div>

    </aside>

    <!-- ======================================================================
         Main Column (col-lg-6 with right sidebar, or default col-lg-9 full layout)
         ====================================================================== -->
    <div class="<cfif local.showSidebar>col-lg-6 col-md-8<cfelse>col-lg-9 col-md-8</cfif>">
      <h1 class="section-title mb-3">#EncodeForHTML(local.pageTitle)#</h1>
      <hr>

      <cfif isObject(content) and StructKeyExists(content, "hasCtaCards") and isBoolean(content.hasCtaCards) and content.hasCtaCards and isQuery(ctaCards) and ctaCards.recordCount GT 0>
        <cfset local.ctaHeading = (StructKeyExists(content, "ctaSectionTitle") and Len(Trim(content.ctaSectionTitle))) ? Trim(content.ctaSectionTitle) : "Quick Services & Online Tools">
        <section class="mb-5" aria-labelledby="ctaSectionHeading">
          <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
            <h2 id="ctaSectionHeading" class="section-title m-0">#EncodeForHTML(local.ctaHeading)#</h2>
          </div>
          <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" role="list">
            <cfloop query="ctaCards">
              <cfset local.cardNewTab = isBoolean(ctaCards.OpenInNewTab) and ctaCards.OpenInNewTab>
              <cfset local.cardBtnText = Len(Trim(ctaCards.ButtonText ?: "")) ? Trim(ctaCards.ButtonText) : "Learn More">
              <cfset local.cardBtnIcon = Len(Trim(ctaCards.ButtonIcon ?: "")) ? Trim(ctaCards.ButtonIcon) : (local.cardNewTab ? "fa-solid fa-arrow-up-right-from-square" : "fa-solid fa-arrow-right")>
              <cfif NOT REFindNoCase("\bfa-(solid|regular|brands|light|thin|duotone)\b", local.cardBtnIcon)>
                <cfset local.cardBtnIcon = "fa-solid " & local.cardBtnIcon>
              </cfif>
              <div class="col" role="listitem">
                <a href="#EncodeForHTMLAttribute(Trim(ctaCards.DestinationUrl))#"<cfif local.cardNewTab> target="_blank" rel="noopener noreferrer"</cfif> class="action-card">
                  <cfif Len(Trim(ctaCards.ImagePath ?: ""))>
                    <div class="action-card-img-wrapper">
                      <img src="#EncodeForHTMLAttribute(Trim(ctaCards.ImagePath))#" alt="#EncodeForHTMLAttribute(Trim(ctaCards.ImageAlt ?: ''))#" class="action-card-img">
                    </div>
                  </cfif>
                  <div class="action-card-body">
                    <h3 class="action-card-title">#EncodeForHTML(Trim(ctaCards.Title))#</h3>
                    <cfif Len(Trim(ctaCards.ShortDescription ?: ""))>
                      <p class="action-card-text">
                        #EncodeForHTML(Trim(ctaCards.ShortDescription))#
                      </p>
                    </cfif>
                    <span class="action-card-btn">
                      <span>#EncodeForHTML(local.cardBtnText)#</span>
                      <cfif local.cardNewTab><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                      <i class="#EncodeForHTMLAttribute(local.cardBtnIcon)#" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
            </cfloop>
          </div>
        </section>
      </cfif>

      <!-- Dynamic Page Content from `content` model (dbo.pages) -->
      <section class="overview-card" aria-label="#EncodeForHTMLAttribute(local.pageTitle)#">
        <cfif isObject(content)>
          <cfif StructKeyExists(content, "Summary") and Len(Trim(content.Summary))>
            <p class="lead fw-semibold mb-3">#EncodeForHTML(content.Summary)#</p>
          </cfif>

          <cfif StructKeyExists(content, "imageAttachment") and Len(Trim(content.imageAttachment))>
            <div class="row g-4">
              <div class="col-md-8">
                #content.Body#
              </div>
              <div class="col-md-4">
                <img src="#EncodeForHTMLAttribute(content.imageAttachment)#"
                     alt="#EncodeForHTMLAttribute(Len(Trim(content.imageAlt)) ? content.imageAlt : content.Title)#"
                     class="img-fluid rounded shadow-sm mb-2">
                <cfif StructKeyExists(content, "imageAttribution") and Len(Trim(content.imageAttribution))>
                  <p class="text-muted small mb-0">#EncodeForHTML(content.imageAttribution)#</p>
                </cfif>
              </div>
            </div>
          <cfelseif StructKeyExists(content, "Body") and Len(Trim(content.Body))>
            <div class="cms-page-body">
              #content.Body#
            </div>
          <cfelse>
            <p class="text-muted mb-0">No content has been published for this page yet.</p>
          </cfif>
        <cfelse>
          <p class="text-muted mb-0">The requested page could not be found.</p>
        </cfif>
      </section>

      <!-- Page Timestamp & Meta -->
      <div class="d-flex justify-content-between align-items-center flex-wrap pt-3 border-top text-muted small">
        <span>
          <i class="fa-solid fa-clock-rotate-left me-1" aria-hidden="true"></i>
          <cfif isObject(content) and StructKeyExists(content, "Modified") and isDate(content.Modified)>
            Last Updated: #DateFormat(content.Modified, "mmmm d, yyyy")# #TimeFormat(content.Modified, "h:mm tt")# &bull; Chelan County Assessor's Office
          <cfelseif isObject(content) and StructKeyExists(content, "Created") and isDate(content.Created)>
            Posted: #DateFormat(content.Created, "mmmm d, yyyy")# &bull; Chelan County Assessor's Office
          <cfelse>
            Chelan County Assessor's Office
          </cfif>
        </span>
        <a href="##top" class="text-muted text-decoration-none"><i class="fa-solid fa-arrow-up me-1" aria-hidden="true"></i> Back to top</a>
      </div>

    </div>

    <cfif local.showSidebar>
      <!-- ====================================================================
           Right Sidebar Column (col-lg-3 col-md-12) — Attached Page Sidebars
           ==================================================================== -->
      <aside class="col-lg-3 col-md-12" aria-label="Additional page information">
        <cfif isQuery(sidebars)>
          <cfloop query="sidebars">
            <section class="dept-contact-card" <cfif Len(Trim(sidebars.Title))>aria-label="#EncodeForHTMLAttribute(sidebars.Title)#"</cfif>>
              <cfif Len(Trim(sidebars.Title))>
                <h2 class="h5 fw-bold border-bottom pb-2 mb-3">#EncodeForHTML(sidebars.Title)#</h2>
              </cfif>
              <div class="dept-sidebar-body">
                #sidebars.Body#
              </div>
            </section>
          </cfloop>
        <cfelseif isArray(sidebars)>
          <cfloop array="#sidebars#" index="local.sb">
            <cfset local.sbTitle = StructKeyExists(local.sb, "Title") ? local.sb.Title : (StructKeyExists(local.sb, "title") ? local.sb.title : "")>
            <cfset local.sbBody = StructKeyExists(local.sb, "Body") ? local.sb.Body : (StructKeyExists(local.sb, "body") ? local.sb.body : "")>
            <section class="dept-contact-card" <cfif Len(Trim(local.sbTitle))>aria-label="#EncodeForHTMLAttribute(local.sbTitle)#"</cfif>>
              <cfif Len(Trim(local.sbTitle))>
                <h2 class="h5 fw-bold border-bottom pb-2 mb-3">#EncodeForHTML(local.sbTitle)#</h2>
              </cfif>
              <div class="dept-sidebar-body">
                #local.sbBody#
              </div>
            </section>
          </cfloop>
        </cfif>
      </aside>
    </cfif>

  </div>

</div>

</cfoutput>