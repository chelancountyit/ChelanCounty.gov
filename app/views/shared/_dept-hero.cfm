<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-hero.cfm — Reusable Department Hero Banner & Wave Divider --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="content" default="">
<cfparam name="arguments.isSubpage" default="false">
<cfparam name="arguments.tagline" default="">

<cfset local.isSubpage = isBoolean(arguments.isSubpage) and arguments.isSubpage>
<cfset local.wsCode = (isStruct(site) and StructKeyExists(site, "code") and Len(Trim(site.code))) ? LCase(Trim(site.code)) : "assessor">
<cfset local.wsSlug = ReReplaceNoCase(local.wsCode, "^site-", "")>
<cfif local.wsSlug EQ "assessors">
  <cfset local.wsSlug = "assessor">
</cfif>

<cfset local.rawName = (isStruct(site) and StructKeyExists(site, "name") and Len(Trim(site.name))) ? Trim(site.name) : "Assessor">
<cfset local.shortName = ReReplaceNoCase(local.rawName, "^Chelan\s+County\s+", "")>
<cfset local.fullTitle = FindNoCase("Chelan County", local.rawName) ? local.rawName : "Chelan County " & local.rawName>

<cfset local.heroTagline = Len(Trim(arguments.tagline))
  ? Trim(arguments.tagline)
  : ((isStruct(site) and StructKeyExists(site, "description") and Len(Trim(site.description)))
      ? Trim(site.description)
      : "Determining fair, equitable, and uniform property valuations for Chelan County taxpayers according to Washington State law.")>

<cfset local.phoneDisplay = (isStruct(site) and StructKeyExists(site, "phone") and Len(Trim(site.phone))) ? Trim(site.phone) : "(509) 667-6365">
<cfset local.phoneHref = ReReplace(local.phoneDisplay, "[^0-9+]", "", "all")>
<cfset local.pageTitle = (isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title))) ? Trim(content.Title) : local.fullTitle>

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
        <cfif local.isSubpage>
          <li class="breadcrumb-item"><a href="/#EncodeForHTMLAttribute(local.wsSlug)#">#EncodeForHTML(local.shortName)#</a></li>
          <li class="breadcrumb-item active" aria-current="page">#EncodeForHTML(local.pageTitle)#</li>
        <cfelse>
          <li class="breadcrumb-item active" aria-current="page">#EncodeForHTML(local.shortName)#</li>
        </cfif>
      </ol>
    </nav>
    <div class="row align-items-center">
      <div class="col-lg-9">
        <p class="dept-title display-5 fw-bold mb-2">
          #EncodeForHTML(local.fullTitle)#
        </p>
        <p class="dept-tagline lead mb-0">
          #EncodeForHTML(local.heroTagline)#
        </p>
      </div>
      <cfif Len(local.phoneDisplay)>
        <div class="col-lg-3 text-lg-end mt-3 mt-lg-0 d-none d-lg-block">
          <a href="tel:#EncodeForHTMLAttribute(local.phoneHref)#" class="btn btn-outline-light btn-sm rounded-pill px-3 py-2 fw-semibold">
            <i class="fa-solid fa-phone me-1" aria-hidden="true"></i> #EncodeForHTML(local.phoneDisplay)#
          </a>
        </div>
      </cfif>
    </div>
  </div>
</section>

<!-- Wave Transition Divider -->
<div class="dept-wave-divider" aria-hidden="true"></div>
</cfoutput>

