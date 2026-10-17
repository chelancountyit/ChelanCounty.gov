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
      <cfelseif not ((isDefined("folderExplorers") and isQuery(folderExplorers) and folderExplorers.recordCount GT 0) or (isDefined("ctaCards") and isQuery(ctaCards) and ctaCards.recordCount GT 0))>
        <p class="text-muted mb-0">No content has been published for this page yet.</p>
      </cfif>
    <cfelse>
      <p class="text-muted mb-0">The requested page could not be found.</p>
    </cfif>
  <cfelse>
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
  </cfif>
</section>
</cfoutput>

