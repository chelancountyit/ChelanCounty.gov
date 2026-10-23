<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/auditor/page.cfm - Chelan County Auditor Department Subpage --->
<cfparam name="site" default="#getWorkspace('auditor')#">
<cfparam name="content" default="">
<cfparam name="nav" default="#[]#">
<cfparam name="sidebars" default="#queryNew('ID,ContentID,SiteID,Title,Body,Position')#">
<cfparam name="ctaCards" default="#getAttachedCtaCards(content)#">
<cfparam name="folderExplorers" default="#getAttachedFolderExplorers(content)#">
<cfparam name="hasSidebar" default="false">
<cfparam name="layoutType" default="full">
<cfset local.showSidebar = (isBoolean(hasSidebar) and hasSidebar) or (isQuery(sidebars) and sidebars.recordCount GT 0) or (isArray(sidebars) and ArrayLen(sidebars) GT 0)>
<cfset local.pageTitle = (isObject(content) and StructKeyExists(content, "Title") and Len(Trim(content.Title))) ? Trim(content.Title) : "Chelan County Auditor">
<cfoutput>

<!-- Department Hero Banner & Wave Divider -->
#includePartial(partial="/shared/_dept-hero.cfm", isSubpage=true)#

<!-- ==========================================================================
     Department Content Grid
     Left Sidebar (col-lg-3): Dynamic Navigation (`nav`) & Office Info
     Main Content (col-lg-6 with sidebar, or col-lg-9 full layout): Page Content (`content`)
     Right Sidebar (col-lg-3 when attached sidebars exist): Attached `sidebars`
     ========================================================================== -->
<div class="container py-4">

  <!-- Active Notifications / Emergency Alerts -->
  #includePartial(partial="/shared/_dept-notifications.cfm")#

  <div class="row g-4 g-lg-5">

    <!-- ======================================================================
         Sidebar Column (col-lg-3 col-md-4) — Left Navigation & Office Info
         ====================================================================== -->
    <aside class="col-lg-3 col-md-4" aria-label="Department information and navigation">
      #includePartial(partial="/shared/_dept-nav.cfm", isSubpage=true)#
      #includePartial(partial="/shared/_dept-contact.cfm")#
    </aside>

    <!-- ======================================================================
         Main Column (col-lg-6 with right sidebar, or default col-lg-9 full layout)
         ====================================================================== -->
    <div class="<cfif local.showSidebar>col-lg-6 col-md-8<cfelse>col-lg-9 col-md-8</cfif>">
      <cfif isObject(content)>
        <h1 class="section-title mb-3">#EncodeForHTML(local.pageTitle)#</h1>
        <hr>
      </cfif>

      <!-- Quick Services / CTA Cards (when enabled on subpage) -->
      #includePartial(partial="/shared/_dept-cta-cards.cfm", isSubpage=true)#

      <!-- Dynamic Page Content -->
      #includePartial(partial="/shared/_dept-overview.cfm", isSubpage=true)#

      <!-- Folder Explorer (when configured in CMSAdmin2.0) -->
      #includePartial(partial="/shared/_dept-folder-explorer.cfm", isSubpage=true)#

      <!-- Page Timestamp & Meta -->
      #includePartial(partial="/shared/_dept-meta.cfm", isSubpage=true)#
    </div>

    <!-- Right Sidebar Column (when attached sidebars exist) -->
    #includePartial(partial="/shared/_dept-right-sidebar.cfm")#

  </div>

</div>

</cfoutput>
