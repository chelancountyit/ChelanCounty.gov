<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/publicworks/index.cfm - Chelan County Public Works Department Landing Page --->
<cfparam name="site" default="#getWorkspace('public-works')#">
<cfparam name="content" default="">
<cfparam name="nav" default="#[]#">
<cfparam name="sidebars" default="#queryNew('ID,ContentID,SiteID,Title,Body,Position')#">
<cfparam name="ctaCards" default="#getAttachedCtaCards(content)#">
<cfparam name="folderExplorers" default="#getAttachedFolderExplorers(content)#">
<cfparam name="hasSidebar" default="false">
<cfparam name="layoutType" default="full">
<cfset local.showSidebar = (isBoolean(hasSidebar) and hasSidebar) or (isQuery(sidebars) and sidebars.recordCount GT 0) or (isArray(sidebars) and ArrayLen(sidebars) GT 0)>
<cfoutput>

<!-- Department Hero Banner & Wave Divider -->
#includePartial(partial="/shared/_dept-hero.cfm")#

<!-- ==========================================================================
     Department Content Grid
     Left Sidebar: Department Head, Dynamic Navigation Table (`nav`), & Office Info
     Main Content (col-lg-6 with right sidebar, or col-lg-9 full layout): Page Content & Quick Service Cards
     Right Sidebar (col-lg-3 when attached sidebars exist): Attached `sidebars`
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
         Main Column (col-lg-6 with right sidebar, or default col-lg-9 full layout)
         ====================================================================== -->
    <div class="<cfif local.showSidebar>col-lg-6 col-md-8<cfelse>col-lg-9 col-md-8</cfif>">
      <h1 class="section-title mb-3">
        <cfif isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title)) and CompareNoCase(Trim(content.Title), "Home") NEQ 0>
          #EncodeForHTML(content.Title)#
        <cfelse>
          Chelan County Public Works
        </cfif>
      </h1>
      <hr>

      <!-- Quick Services / CTA Cards -->
      <!--- #includePartial(partial="/shared/_dept-cta-cards.cfm", showFallbackCards=false)# --->

      <!-- Dynamic Page Content / Department Overview -->
      #includePartial(partial="/shared/_dept-overview.cfm")#

      <!-- Folder Explorer (when configured in CMSAdmin2.0) -->
      #includePartial(partial="/shared/_dept-folder-explorer.cfm")#

      <!-- Page Timestamp & Meta -->
      #includePartial(partial="/shared/_dept-meta.cfm")#
    </div>

    <!-- Right Sidebar Column (when attached sidebars exist) -->
    #includePartial(partial="/shared/_dept-right-sidebar.cfm")#

  </div>

</div>

</cfoutput>

