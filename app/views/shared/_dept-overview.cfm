<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-overview.cfm — Reusable Dynamic Page Content & Department Overview Section --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="content" default="">
<cfparam name="arguments.isSubpage" default="false">

<cfset local.isSubpage = isBoolean(arguments.isSubpage) and arguments.isSubpage>
<cfset local.rawName = (isStruct(site) and StructKeyExists(site, "name") and Len(Trim(site.name))) ? Trim(site.name) : "Assessor">
<cfset local.fullTitle = FindNoCase("Chelan County", local.rawName) ? local.rawName : "Chelan County " & local.rawName>
<cfset local.pageTitle = (isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title))) ? Trim(content.Title) : local.fullTitle>
<cfset local.ariaLabel = local.isSubpage ? local.pageTitle : "Department Overview">

<cfoutput>
<!-- Dynamic Page Content from `content` model (dbo.pages) -->
<section  aria-label="#EncodeForHTMLAttribute(local.ariaLabel)#">
  <cfif local.isSubpage>
    <cfif isObject(content)>
     <!---  <cfif StructKeyExists(content, "Summary") and Len(Trim(content.Summary))>
        <p class="lead fw-semibold mb-3">#EncodeForHTML(content.Summary)#</p>
      </cfif> --->

      <cfif StructKeyExists(content, "imageAttachment") and Len(Trim(content.imageAttachment))>
        <div class="row g-4">
          <div class="col-md-8">
            #renderCmsContent(content.Body)#
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
          #renderCmsContent(content.Body)#
        </div>
      <cfelseif not ((isDefined("folderExplorers") and isQuery(folderExplorers) and folderExplorers.recordCount GT 0) or (isDefined("ctaCards") and isQuery(ctaCards) and ctaCards.recordCount GT 0))>
        <cfset local.wsCode = (isStruct(site) and StructKeyExists(site, "code") and Len(Trim(site.code))) ? LCase(Trim(site.code)) : "assessor">
        <cfset local.wsSlug = ReReplaceNoCase(local.wsCode, "^site-", "")>
        <cfif local.wsSlug EQ "assessors"><cfset local.wsSlug = "assessor"></cfif>
        <cfset local.shortName = ReReplaceNoCase(local.rawName, "^Chelan\s+County\s+", "")>
        <cfset local.wsColor = (isStruct(site) and StructKeyExists(site, "color") and Len(Trim(site.color))) ? Trim(site.color) : "##173F63">
        <cfset local.wsColorDark = (isStruct(site) and StructKeyExists(site, "colorDark") and Len(Trim(site.colorDark))) ? Trim(site.colorDark) : local.wsColor>
        <cfset local.wsGradient = (isStruct(site) and StructKeyExists(site, "heroGradient") and Len(Trim(site.heroGradient))) ? Trim(site.heroGradient) : ("linear-gradient(135deg, " & local.wsColor & " 0%, " & local.wsColorDark & " 100%)")>
        <div class="card border-0 shadow-sm rounded-4 overflow-hidden my-2" style="background: linear-gradient(180deg, ##ffffff 0%, ##f8fafc 100%); border: 1px solid ##e2e8f0 !important;">
          <div style="height: 4px; background: #EncodeForHTMLAttribute(local.wsGradient)#;"></div>
          <div class="card-body p-4 p-md-5 text-center">
            <div class="d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 64px; height: 64px; background: color-mix(in srgb, #EncodeForHTMLAttribute(local.wsColor)# 12%, ##ffffff); color: #EncodeForHTMLAttribute(local.wsColor)#;">
              <i class="fa-regular fa-file-lines fa-2x" aria-hidden="true"></i>
            </div>
            <h2 class="h4 fw-bold mb-2" style="color: #EncodeForHTMLAttribute(local.wsColorDark)#;">Content Coming Soon</h2>
            <p class="text-muted mx-auto mb-4" style="max-width: 480px;">
              No content has been published for this page yet. Please check back soon or return to the #EncodeForHTML(local.shortName)# homepage.
            </p>
            <a href="/#EncodeForHTMLAttribute(local.wsSlug)#" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold text-decoration-none" style="background: #EncodeForHTMLAttribute(local.wsGradient)#; background-color: #EncodeForHTMLAttribute(local.wsColor)#; border-color: #EncodeForHTMLAttribute(local.wsColor)#; color: ##ffffff !important;">
              <i class="fa-solid fa-arrow-left me-2" aria-hidden="true"></i>Back to #EncodeForHTML(local.shortName)#
            </a>
          </div>
        </div>
      </cfif>
    <cfelse>
      <cfset local.wsCode = (isStruct(site) and StructKeyExists(site, "code") and Len(Trim(site.code))) ? LCase(Trim(site.code)) : "assessor">
      <cfset local.wsSlug = ReReplaceNoCase(local.wsCode, "^site-", "")>
      <cfif local.wsSlug EQ "assessors"><cfset local.wsSlug = "assessor"></cfif>
      <cfset local.shortName = ReReplaceNoCase(local.rawName, "^Chelan\s+County\s+", "")>
      <cfset local.wsColor = (isStruct(site) and StructKeyExists(site, "color") and Len(Trim(site.color))) ? Trim(site.color) : "##173F63">
      <cfset local.wsColorDark = (isStruct(site) and StructKeyExists(site, "colorDark") and Len(Trim(site.colorDark))) ? Trim(site.colorDark) : local.wsColor>
      <cfset local.wsGradient = (isStruct(site) and StructKeyExists(site, "heroGradient") and Len(Trim(site.heroGradient))) ? Trim(site.heroGradient) : ("linear-gradient(135deg, " & local.wsColor & " 0%, " & local.wsColorDark & " 100%)")>
      <div class="card border-0 shadow-sm rounded-4 overflow-hidden my-2" style="background: linear-gradient(180deg, ##ffffff 0%, ##f8fafc 100%); border: 1px solid ##e2e8f0 !important;" role="status" aria-live="polite">
        <div style="height: 5px; background: #EncodeForHTMLAttribute(local.wsGradient)#;"></div>
        <div class="card-body p-4 p-md-5 text-center">
          <div class="position-relative d-inline-flex align-items-center justify-content-center rounded-circle mb-3" style="width: 76px; height: 76px; background: color-mix(in srgb, #EncodeForHTMLAttribute(local.wsColor)# 12%, ##ffffff); color: #EncodeForHTMLAttribute(local.wsColor)#; border: 1px solid color-mix(in srgb, #EncodeForHTMLAttribute(local.wsColor)# 30%, ##ffffff);">
            <i class="fa-solid fa-file-circle-question fa-2x" aria-hidden="true"></i>
          </div>
          <div class="mb-2">
            <span class="badge rounded-pill text-uppercase px-3 py-1" style="background: color-mix(in srgb, #EncodeForHTMLAttribute(local.wsColor)# 12%, ##ffffff); color: #EncodeForHTMLAttribute(local.wsColorDark)#; font-size: 0.72rem; letter-spacing: 0.06em; font-weight: 700;">
              404 &bull; Page Not Found
            </span>
          </div>
          <h1 class="h3 fw-bold mb-2" style="color: #EncodeForHTMLAttribute(local.wsColorDark)#;">
            The requested page could not be found.
          </h1>
          <p class="text-muted mx-auto mb-4" style="max-width: 520px; font-size: 0.98rem; line-height: 1.6;">
            The page you are looking for may have been moved, renamed, or is not yet published in the <strong>#EncodeForHTML(local.fullTitle)#</strong> portal. Use the department menu on the left or choose an option below.
          </p>
          <div class="d-flex flex-wrap justify-content-center gap-2 pt-1">
            <a href="/#EncodeForHTMLAttribute(local.wsSlug)#" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold text-decoration-none shadow-sm" style="background: #EncodeForHTMLAttribute(local.wsGradient)#; background-color: #EncodeForHTMLAttribute(local.wsColor)#; border-color: #EncodeForHTMLAttribute(local.wsColor)#; color: ##ffffff !important;">
              <i class="fa-solid fa-arrow-left me-2" aria-hidden="true"></i>#EncodeForHTML(local.shortName)# Home
            </a>
            <a href="/" class="btn btn-outline-secondary rounded-pill px-4 py-2 fw-semibold text-decoration-none" style="background-color: ##ffffff; border-color: ##cbd5e1; color: #EncodeForHTMLAttribute(local.wsColorDark)# !important;">
              <i class="fa-solid fa-house me-2" aria-hidden="true"></i>County Homepage
            </a>
          </div>
        </div>
      </div>
    </cfif>
  <cfelse>
   <!---  <cfif isObject(content) and StructKeyExists(content, "Summary") and Len(Trim(content.Summary))>
      <p class="lead fw-semibold mb-3">#EncodeForHTML(content.Summary)#</p>
    </cfif> --->

    <cfif isObject(content) and StructKeyExists(content, "imageAttachment") and Len(Trim(content.imageAttachment))>
      <div class="row g-4">
        <div class="col-md-8">
          #renderCmsContent(content.Body)#
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
      #renderCmsContent(content.Body)#
    <cfelse>
      <cfif isObject(content) and StructKeyExists(content, "Body") and Len(Trim(content.Body))>
        <div class="cms-page-body mb-3">
          #renderCmsContent(content.Body)#
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
  </cfif>
</section>
</cfoutput>

