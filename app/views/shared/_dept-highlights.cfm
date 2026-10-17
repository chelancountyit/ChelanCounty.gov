<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-highlights.cfm — Reusable Key Responsibilities & Feature Highlights Grid --->
<cfparam name="arguments.highlights" default="#[]#">
<cfoutput>
<!-- Key Responsibilities & Taxpayer Highlights -->
<div class="row g-4 mb-5">
  <cfif isArray(arguments.highlights) and ArrayLen(arguments.highlights) GT 0>
    <cfloop array="#arguments.highlights#" index="local.feat">
      <cfset local.featIcon = StructKeyExists(local.feat, "icon") and Len(Trim(local.feat.icon)) ? Trim(local.feat.icon) : "fa-solid fa-circle-info text-brand">
      <cfset local.featTitle = StructKeyExists(local.feat, "title") ? Trim(local.feat.title) : "">
      <cfset local.featText = StructKeyExists(local.feat, "text") ? Trim(local.feat.text) : "">
      <div class="col-md-4">
        <div class="info-feature-card">
          <h3><i class="#EncodeForHTMLAttribute(local.featIcon)#" aria-hidden="true"></i> #EncodeForHTML(local.featTitle)#</h3>
          <p>#EncodeForHTML(local.featText)#</p>
        </div>
      </div>
    </cfloop>
  <cfelse>
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
  </cfif>
</div>
</cfoutput>

