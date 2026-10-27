<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/assessor/index.cfm - Chelan County Assessor Department Landing Page --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="content" default="">
<cfparam name="nav" default="#[]#">
<cfparam name="ctaCards" default="#getAttachedCtaCards(content)#">
<cfoutput>

<!-- Department Hero Banner & Wave Divider -->
#includePartial(partial="/shared/_dept-hero.cfm")#

<!-- ==========================================================================
     Department Content Grid
     Left Sidebar: Elected Official, Dynamic Navigation Table (`nav`), & Office Info
     Right Main: Page Content (`content`) & Quick Service Cards
     ========================================================================== -->
<div class="container py-4">

  <!-- Active Notifications / Emergency Alerts -->
  #includePartial(partial="/shared/_dept-notifications.cfm")#

  <div class="row g-4 g-lg-5">

    <!-- ======================================================================
         Sidebar Column (col-lg-3 col-md-4) — Left Navigation & Official Info
         ====================================================================== -->
    <aside class="col-lg-3 col-md-4" aria-label="Department information and navigation">
      #includePartial(partial="/shared/_dept-official.cfm")#
      #includePartial(partial="/shared/_dept-nav.cfm")#
      #includePartial(partial="/shared/_dept-contact.cfm")#
    </aside>

    <!-- ======================================================================
         Main Column (col-lg-9 col-md-8) — Right Content Area
         ====================================================================== -->
    <div class="col-lg-9 col-md-8">
      <h1 class="section-title mb-3">
        <cfif isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title)) and CompareNoCase(Trim(content.Title), "Home") NEQ 0>
          #EncodeForHTML(content.Title)#
        <cfelseif isStruct(site) and StructKeyExists(site, "name") and Len(Trim(site.name))>
          Chelan County #EncodeForHTML(ReReplaceNoCase(Trim(site.name), "^Chelan\s+County\s+", ""))#'s Office
        <cfelse>
          Chelan County Assessor's Office
        </cfif>
      </h1>
      <hr>

      <!-- Quick Services / CTA Cards -->
      #includePartial(partial="/shared/_dept-cta-cards.cfm")#

      <!-- Dynamic Page Content / Department Overview -->
      #includePartial(partial="/shared/_dept-overview.cfm")#

      <!-- Key Responsibilities & Taxpayer Highlights -->
      <!--- #includePartial(partial="/shared/_dept-highlights.cfm")# --->

      <!-- Important Assessment Dates Callout -->
      <!--- #includePartial(partial="/shared/_dept-notice-bar.cfm")# --->

      <!-- Page Timestamp & Meta -->
      #includePartial(partial="/shared/_dept-meta.cfm")#
    </div>

  </div>

</div>

</cfoutput>