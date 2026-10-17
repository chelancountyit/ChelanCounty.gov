<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-official.cfm — Reusable Elected Official / Department Head Card --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="arguments.photoUrl" default="">
<cfparam name="arguments.contactUrl" default="">

<cfset local.wsCode = (isStruct(site) and StructKeyExists(site, "code") and Len(Trim(site.code))) ? LCase(Trim(site.code)) : "assessor">
<cfset local.wsSlug = ReReplaceNoCase(local.wsCode, "^site-", "")>
<cfif local.wsSlug EQ "assessors">
  <cfset local.wsSlug = "assessor">
</cfif>

<cfset local.rawName = (isStruct(site) and StructKeyExists(site, "name") and Len(Trim(site.name))) ? Trim(site.name) : "Assessor">
<cfset local.shortName = ReReplaceNoCase(local.rawName, "^Chelan\s+County\s+", "")>
<cfset local.fullTitle = FindNoCase("Chelan County", local.rawName) ? local.rawName : "Chelan County " & local.rawName>

<cfset local.officialName = (isStruct(site) and StructKeyExists(site, "contactfirstname") and StructKeyExists(site, "contactlastname") and Len(Trim(site.contactfirstname & site.contactlastname)))
  ? Trim(site.contactfirstname & " " & site.contactlastname)
  : "Wes Cornelius">

<cfset local.officialTitle = (isStruct(site) and StructKeyExists(site, "contacttitle") and Len(Trim(site.contacttitle)))
  ? Trim(site.contacttitle)
  : local.fullTitle>

<cfset local.photoSrc = Len(Trim(arguments.photoUrl))
  ? Trim(arguments.photoUrl)
  : ((isStruct(site) and StructKeyExists(site, "officialPhoto") and Len(Trim(site.officialPhoto)))
      ? Trim(site.officialPhoto)
      : "/images/picjumbo/assessor-office-elected.jpg")>

<cfset local.contactHref = Len(Trim(arguments.contactUrl))
  ? Trim(arguments.contactUrl)
  : "/" & local.wsSlug & "/contacts">

<cfoutput>
<!-- Elected Official Card -->
<div class="official-card">
  <img src="#EncodeForHTMLAttribute(local.photoSrc)#"
       alt="#EncodeForHTMLAttribute(local.officialName & ', ' & local.officialTitle)#"
       class="official-photo rounded-circle mx-auto d-block"
       width="240" height="240">
  <span class="official-name d-block">
    #EncodeForHTML(local.officialName)#
  </span>
  <span class="official-badge">
    #EncodeForHTML(local.officialTitle)#
  </span>
  <a href="#EncodeForHTMLAttribute(local.contactHref)#" class="btn btn-brand w-100 rounded-pill mt-2">
    <i class="fa-solid fa-envelope me-1" aria-hidden="true"></i> Contact #EncodeForHTML(local.shortName)#
  </a>
</div>
</cfoutput>

