<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/publicworks/howdoi.cfm - Chelan County Public Works How Do I Directory --->
<cfparam name="site" default="#getWorkspace('public-works')#">
<cfparam name="nav" default="#[]#">
<cfparam name="howDoIItems" default="#queryNew('FAQID,CATEGORYID,CATEGORY,QUESTION,ANSWER,EXTERNALFORWARDURL,INTERNALFORWARDURL,INTERNALCUSTOMURL')#">
<cfset content = { Title: "How Do I..." }>
<cfoutput>

<!-- Department Hero Banner & Wave Divider -->
#includePartial(partial="/shared/_dept-hero.cfm", isSubpage=true)#

<div class="container py-4">
  #includePartial(partial="/shared/_dept-notifications.cfm")#

  <div class="row g-4 g-lg-5">
    <aside class="col-lg-3 col-md-4" aria-label="Department information and navigation">
      #includePartial(partial="/shared/_dept-nav.cfm", isSubpage=true)#
      #includePartial(partial="/shared/_dept-contact.cfm")#
    </aside>

    <div class="col-lg-9 col-md-8">
      <h1 class="section-title mb-3">How Do I...</h1>
      <hr>

      <cfif isQuery(howDoIItems) and howDoIItems.recordCount GT 0>
        <cfset local.currentCat = "">
        <cfloop query="howDoIItems">
          <cfif CompareNoCase(local.currentCat, Trim(howDoIItems.CATEGORY)) NEQ 0>
            <cfif Len(local.currentCat)>
              </ul>
              </div>
              </div>
            </cfif>
            <cfset local.currentCat = Trim(howDoIItems.CATEGORY)>
            <div class="card border-0 shadow-sm rounded-4 mb-4">
              <div class="card-body p-4">
                <h2 class="h5 fw-bold mb-3">#EncodeForHTML(local.currentCat)#</h2>
                <ul class="list-unstyled mb-0">
          </cfif>
          <cfset local.targetUrl = "">
          <cfset local.isExt = false>
          <cfif Len(Trim(howDoIItems.EXTERNALFORWARDURL ?: ""))>
            <cfset local.targetUrl = Trim(howDoIItems.EXTERNALFORWARDURL)>
            <cfset local.isExt = true>
          <cfelseif Len(Trim(howDoIItems.INTERNALFORWARDURL ?: ""))>
            <cfset local.targetUrl = Trim(howDoIItems.INTERNALFORWARDURL)>
          <cfelseif Len(Trim(howDoIItems.INTERNALCUSTOMURL ?: ""))>
            <cfset local.targetUrl = Trim(howDoIItems.INTERNALCUSTOMURL)>
          </cfif>
          <cfset local.targetUrl = Replace(local.targetUrl, "https://www.co.chelan.wa.us/files/", "/files/", "all")>
          <cfset local.targetUrl = Replace(local.targetUrl, "http://www.co.chelan.wa.us/files/", "/files/", "all")>
          <cfset local.targetUrl = Replace(local.targetUrl, "/public-works/pages/", "/public-works/page/", "all")>
          <li class="py-2 border-bottom">
            <cfif Len(local.targetUrl)>
              <a href="#EncodeForHTMLAttribute(local.targetUrl)#"<cfif local.isExt> target="_blank" rel="noopener noreferrer"</cfif> class="fw-semibold text-decoration-none">
                <i class="fa-solid fa-angle-right text-primary me-2" aria-hidden="true"></i>#EncodeForHTML(Trim(howDoIItems.QUESTION))#
                <cfif local.isExt><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-arrow-up-right-from-square small text-muted ms-1" aria-hidden="true"></i></cfif>
              </a>
            <cfelse>
              <span class="fw-semibold">#EncodeForHTML(Trim(howDoIItems.QUESTION))#</span>
            </cfif>
          </li>
        </cfloop>
        <cfif Len(local.currentCat)>
          </ul>
          </div>
          </div>
        </cfif>
      <cfelse>
        <p class="text-muted">Visit our <a href="/public-works/page/frequently-asked-questions-public-works">Frequently Asked Questions</a> page for common Public Works resources.</p>
      </cfif>
    </div>
  </div>
</div>

</cfoutput>

