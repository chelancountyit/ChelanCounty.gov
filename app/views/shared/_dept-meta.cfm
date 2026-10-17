<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-meta.cfm — Reusable Page Timestamp & Meta Footer --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="content" default="">
<cfparam name="arguments.isSubpage" default="false">

<cfset local.isSubpage = isBoolean(arguments.isSubpage) and arguments.isSubpage>
<cfset local.rawName = (isStruct(site) and StructKeyExists(site, "name") and Len(Trim(site.name))) ? Trim(site.name) : "Assessor">
<cfset local.officeLabel = FindNoCase("Office", local.rawName)
  ? (FindNoCase("Chelan County", local.rawName) ? local.rawName : "Chelan County " & local.rawName)
  : (FindNoCase("Chelan County", local.rawName) ? local.rawName & "'s Office" : "Chelan County " & local.rawName & "'s Office")>

<cfoutput>
<!-- Page Timestamp & Meta -->
<div class="d-flex justify-content-between align-items-center flex-wrap pt-3 border-top text-muted small">
  <span>
    <i class="fa-solid fa-clock-rotate-left me-1" aria-hidden="true"></i>
    <cfif isObject(content) and StructKeyExists(content, "Modified") and isDate(content.Modified)>
      Last Updated: #DateFormat(content.Modified, "mmmm d, yyyy")# #TimeFormat(content.Modified, "h:mm tt")# &bull; #EncodeForHTML(local.officeLabel)#
    <cfelseif isObject(content) and StructKeyExists(content, "Created") and isDate(content.Created)>
      Posted: #DateFormat(content.Created, "mmmm d, yyyy")# &bull; #EncodeForHTML(local.officeLabel)#
    <cfelseif local.isSubpage>
      #EncodeForHTML(local.officeLabel)#
    <cfelse>
      Last Updated: May 2026 &bull; #EncodeForHTML(local.officeLabel)#
    </cfif>
  </span>
  <a href="##top" class="text-muted text-decoration-none"><i class="fa-solid fa-arrow-up me-1" aria-hidden="true"></i> Back to top</a>
</div>
</cfoutput>

