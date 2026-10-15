<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/assessor/index.cfm - Chelan County Assessor Department Landing Page --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="content" default="">
<cfparam name="nav" default="#[]#">
<cfparam name="ctaCards" default="#getAttachedCtaCards(content)#">
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
        <li class="breadcrumb-item active" aria-current="page">Assessor</li>
      </ol>
    </nav>
    <div class="row align-items-center">
      <div class="col-lg-9">
        <p class="dept-title display-5 fw-bold mb-2">
          <cfif isDefined("site.name") and len(trim(site.name))>Chelan County #EncodeForHTML(site.name)#<cfelse>Chelan County Assessor</cfif>
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
     Left Sidebar: Elected Official, Dynamic Navigation Table (`nav`), & Office Info
     Right Main: Page Content (`content`) & Quick Service Cards
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

      <!-- Elected Official Card -->
      <div class="official-card">
        <img src="/images/picjumbo/assessor-office-elected.jpg"
             alt="Wes Cornelius, Chelan County Assessor"
             class="official-photo rounded-circle mx-auto d-block"
             width="240" height="240">
        <span class="official-name d-block">
          <cfif isDefined("site.contactfirstname") and isDefined("site.contactlastname")>
            #EncodeForHTML(site.contactfirstname)# #EncodeForHTML(site.contactlastname)#
          <cfelse>
            Wes Cornelius
          </cfif>
        </span>
        <span class="official-badge">
          <cfif isDefined("site.contacttitle") and len(trim(site.contacttitle))>
            #EncodeForHTML(site.contacttitle)#
          <cfelse>
            Chelan County Assessor
          </cfif>
        </span>
        <a href="/assessor/contacts" class="btn btn-brand w-100 rounded-pill mt-2">
          <i class="fa-solid fa-envelope me-1" aria-hidden="true"></i> Contact Assessor
        </a>
      </div>

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
              <cfset local.isCurrent = (CompareNoCase(local.itemUrl, "/assessor") EQ 0) or (CompareNoCase(local.itemLabel, "Home") EQ 0 and (not StructKeyExists(params, "slug") or CompareNoCase(params.slug, "home") EQ 0))>
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
              <a href="/assessor" class="dept-nav-link active" aria-current="page">
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
         Main Column (col-lg-9 col-md-8) — Right Content Area
         ====================================================================== -->
    <div class="col-lg-9 col-md-8">
      <h1 class="section-title mb-3 ">
        <cfif isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title)) and CompareNoCase(Trim(content.Title), "Home") NEQ 0>
          #EncodeForHTML(content.Title)#
        <cfelse>
          Chelan County Assessor's Office
        </cfif>
      </h1>
      <hr>

      <cfset local.ctaEnabled = !(isObject(content) and StructKeyExists(content, "hasCtaCards") and isBoolean(content.hasCtaCards) and !content.hasCtaCards)>
      <cfset local.ctaHeading = (isObject(content) and StructKeyExists(content, "ctaSectionTitle") and Len(Trim(content.ctaSectionTitle))) ? Trim(content.ctaSectionTitle) : "Quick Services & Online Tools">

      <cfif local.ctaEnabled>
        <!-- Quick Services Section (WCAG 2.2 AA Region & List Semantics) -->
        <section class="mb-5" aria-labelledby="ctaSectionHeading">
          <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
            <h2 id="ctaSectionHeading" class="section-title m-0">#EncodeForHTML(local.ctaHeading)#</h2>
          </div>

          <!-- Quick Services Cards (Dynamic Call to Action Cards from dbo.page_CtaCard) -->
          <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" role="list">
            <cfif isQuery(ctaCards) and ctaCards.recordCount GT 0>
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
            <cfelse>
              <!-- Fallback Default Cards -->
              <div class="col" role="listitem">
                <a href="/assessor/page/parcel-and-sale-search" class="action-card">
                  <div class="action-card-img-wrapper">
                    <img src="/images/picjumbo/parcel16x9.jpg" alt="" class="action-card-img">
                  </div>
                  <div class="action-card-body">
                    <h3 class="action-card-title">Parcel &amp; Sale Search</h3>
                    <p class="action-card-text">
                      Look up property details, assessed valuations, tax history, and verified market sales.
                    </p>
                    <span class="action-card-btn">
                      <span>Search Parcels</span> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
              <div class="col" role="listitem">
                <a href="https://maps.chelancounty.gov/GIS/" target="_blank" rel="noopener noreferrer" class="action-card">
                  <div class="action-card-img-wrapper">
                    <img src="/images/picjumbo/mapping.jpg" alt="" class="action-card-img">
                  </div>
                  <div class="action-card-body">
                    <h3 class="action-card-title">Interactive GIS Map</h3>
                    <p class="action-card-text">
                      Explore county parcel boundaries, aerial photography, tax code areas, and zoning layers.
                    </p>
                    <span class="action-card-btn">
                      <span>Open Map</span><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
              <div class="col" role="listitem">
                <a href="/files/assessor/documents/propertyownerguide.pdf" target="_blank" rel="noopener noreferrer" class="action-card">
                  <div class="action-card-img-wrapper">
                    <img src="/images/picjumbo/propownguideimage.jpg" alt="" class="action-card-img">
                  </div>
                  <div class="action-card-body">
                    <h3 class="action-card-title">Property Owner's Guide</h3>
                    <p class="action-card-text">
                      Comprehensive reference covering assessments, market valuation cycles, and rights.
                    </p>
                    <span class="action-card-btn">
                      <span>Download PDF</span><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-file-pdf text-danger" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
              <div class="col" role="listitem">
                <a href="/assessor/page/destroyed-property-exemptions" class="action-card">
                  <div class="action-card-img-wrapper">
                    <img src="/images/picjumbo/fire-house.jpg" alt="" class="action-card-img">
                  </div>
                  <div class="action-card-body">
                    <h3 class="action-card-title">Destroyed Property</h3>
                    <p class="action-card-text">
                      File for property valuation adjustment and tax relief due to disaster, calamity, or fire damage.
                    </p>
                    <span class="action-card-btn">
                      <span>View Relief Forms</span> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
              <div class="col" role="listitem">
                <a href="/assessor/page/appeals" class="action-card">
                  <div class="action-card-img-wrapper">
                    <img src="/images/picjumbo/property-claim.jpg" alt="" class="action-card-img">
                  </div>
                  <div class="action-card-body">
                    <h3 class="action-card-title">Assessment Appeals</h3>
                    <p class="action-card-text">
                      Learn how to file a petition with the Chelan County Board of Equalization if you dispute your valuation.
                    </p>
                    <span class="action-card-btn">
                      <span>Appeal Instructions</span> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
              <div class="col" role="listitem">
                <a href="https://acclaim.co.chelan.wa.us/acclaimweb" target="_blank" rel="noopener noreferrer" class="action-card">
                  <div class="action-card-img-wrapper">
                    <img src="/images/picjumbo/liberty16x9.jpg" alt="" class="action-card-img">
                  </div>
                  <div class="action-card-body">
                    <h3 class="action-card-title">Document Search</h3>
                    <p class="action-card-text">
                      Access official recorded deeds, land surveys, plats, and legal public records via AcclaimWeb.
                    </p>
                    <span class="action-card-btn">
                      <span>Search Records</span><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i>
                    </span>
                  </div>
                </a>
              </div>
            </cfif>
          </div>
        </section>
      </cfif>

      <!-- Dynamic Page Content from `content` model (dbo.pages) -->
      <section class="overview-card" aria-label="Department Overview">
        <cfif isObject(content) and StructKeyExists(content, "Summary") and Len(Trim(content.Summary))>
          <p class="lead fw-semibold mb-3">#EncodeForHTML(content.Summary)#</p>
        </cfif>

        <cfif isObject(content) and StructKeyExists(content, "imageAttachment") and Len(Trim(content.imageAttachment))>
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
        <cfelseif isObject(content) and StructKeyExists(content, "Body") and Len(Trim(ReReplace(content.Body, "<[^>]*>", "", "all"))) and CompareNoCase(Trim(ReReplace(content.Body, "<[^>]*>", "", "all")), "Home") NEQ 0>
          #content.Body#
        <cfelse>
          <cfif isObject(content) and StructKeyExists(content, "Body") and Len(Trim(content.Body))>
            <div class="cms-page-body mb-3">
              #content.Body#
            </div>
          </cfif>
          <h2 id="heading-what-we-do" class="section-title mb-4">What We Do</h2>
          <p>
            The Assessor's office is responsible for determining the value of all taxable real and personal property in the county on a fair and equitable basis, along with maintaining accurate and accessible property information, providing timely and accurate assessments for tax purposes, and a detailed parcel map showing all parcels within the County.
          </p>
          <p>
            Chelan County is now annually updating all properties according to market sales, and continues to do physical inspections of every property on a 4-year cycle. Washington State law requires property to be assessed at 100% of fair market value.
          </p>
          <p class="mb-0">
            Your property taxes fund state and county services, including roads, transit, schools, libraries, parks, hospitals, fire and rescue, law enforcement, environmental and social services. Information such as parcel numbers, ownership, tax code areas, and assessed valuations for all property within the county can be obtained online through the <a href="/assessor/page/parcel-and-sale-search" class="fw-bold">Parcel &amp; Sale Search</a>, or by calling the assessor's office during business hours.
          </p>
        </cfif>
      </section>

      <!-- Key Responsibilities & Taxpayer Highlights -->
      <div class="row g-4 mb-5">
        <div class="col-md-4">
          <div class="info-feature-card">
            <h3><i class="fa-solid fa-chart-line text-gold" aria-hidden="true"></i> Annual Revaluations</h3>
            <p>
              All property valuations are reviewed annually based on market sales, accompanied by physical inspections on a rotating 4-year countywide cycle.
            </p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="info-feature-card">
            <h3><i class="fa-solid fa-hand-holding-dollar text-teal" aria-hidden="true"></i> Property Tax Relief</h3>
            <p>
              Exemption programs are available for qualified senior citizens, persons with disabilities, and agricultural or open space properties.
            </p>
          </div>
        </div>
        <div class="col-md-4">
          <div class="info-feature-card">
            <h3><i class="fa-solid fa-scale-balanced text-brand" aria-hidden="true"></i> 100% Market Value</h3>
            <p>
              Washington State RCW 84.40.030 requires all assessments to reflect 100% of fair market value to ensure equitable distribution of property tax levies.
            </p>
          </div>
        </div>
      </div>

      <!-- Important Assessment Dates Callout -->
      <div class="notice-bar d-flex flex-column flex-md-row align-items-start align-items-md-center justify-content-between gap-3">
        <div>
          <h3 class="h5 fw-bold text-brand mb-1"><i class="fa-regular fa-calendar-check me-2" aria-hidden="true"></i>Important Assessment Dates &amp; Deadlines</h3>
          <p class="mb-0 small text-muted">
            Personal property filings are due April 30. Board of Equalization valuation appeals must be submitted by July 1 (or within 30 days of notice).
          </p>
        </div>
        <a href="/assessor/page/important-assessment-dates" class="btn btn-outline-dark btn-sm text-nowrap fw-semibold">
          View All Dates &rarr;
        </a>
      </div>

      <!-- Page Timestamp & Meta -->
      <div class="d-flex justify-content-between align-items-center flex-wrap pt-3 border-top text-muted small">
        <span>
          <i class="fa-solid fa-clock-rotate-left me-1" aria-hidden="true"></i>
          <cfif isObject(content) and StructKeyExists(content, "Modified") and isDate(content.Modified)>
            Last Updated: #DateFormat(content.Modified, "mmmm d, yyyy")# #TimeFormat(content.Modified, "h:mm tt")# &bull; Chelan County Assessor's Office
          <cfelseif isObject(content) and StructKeyExists(content, "Created") and isDate(content.Created)>
            Posted: #DateFormat(content.Created, "mmmm d, yyyy")# &bull; Chelan County Assessor's Office
          <cfelse>
            Last Updated: May 2026 &bull; Chelan County Assessor's Office
          </cfif>
        </span>
        <a href="##top" class="text-muted text-decoration-none"><i class="fa-solid fa-arrow-up me-1" aria-hidden="true"></i> Back to top</a>
      </div>

    </div>

  </div>

</div>

</cfoutput>