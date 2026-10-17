<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-right-sidebar.cfm — Reusable Attached Right Sidebars Column --->
<cfparam name="sidebars" default="#queryNew('ID,ContentID,SiteID,Title,Body,Position')#">
<cfparam name="hasSidebar" default="false">

<cfset local.showSidebar = (isBoolean(hasSidebar) and hasSidebar) or (isQuery(sidebars) and sidebars.recordCount GT 0) or (isArray(sidebars) and ArrayLen(sidebars) GT 0)>

<cfoutput>
<cfif local.showSidebar>
  <!-- ====================================================================
       Right Sidebar Column (col-lg-3 col-md-12) — Attached Page Sidebars
       ==================================================================== -->
  <aside class="col-lg-3 col-md-12" aria-label="Additional page information">
    <cfif isQuery(sidebars)>
      <cfloop query="sidebars">
        <section  <cfif Len(Trim(sidebars.Title))>aria-label="#EncodeForHTMLAttribute(sidebars.Title)#"</cfif>>
          <!--- <cfif Len(Trim(sidebars.Title))>
            <h2 class="h5 fw-bold border-bottom pb-2 mb-3">#EncodeForHTML(sidebars.Title)#</h2>
          </cfif> --->
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
</cfoutput>

