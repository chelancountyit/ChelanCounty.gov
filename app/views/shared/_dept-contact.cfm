<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-contact.cfm — Reusable Office Contact & Hours Card --->
<cfparam name="site" default="#getWorkspace('assessor')#">

<cfset local.addrLine1 = (isStruct(site) and StructKeyExists(site, "address") and Len(Trim(site.address)))
  ? Trim(site.address) & ((StructKeyExists(site, "address2") and Len(Trim(site.address2))) ? ", " & Trim(site.address2) : "")
  : "350 Orondo Ave, Suite 6">

<cfset local.cityStateZip = "Wenatchee, WA 98801">
<cfif isStruct(site) and StructKeyExists(site, "city") and Len(Trim(site.city))>
  <cfset local.cityStateZip = Trim(site.city)>
  <cfif StructKeyExists(site, "state") and Len(Trim(site.state))>
    <cfset local.cityStateZip &= ", " & Trim(site.state)>
  </cfif>
  <cfif StructKeyExists(site, "zip") and Len(Trim(site.zip))>
    <cfset local.cityStateZip &= " " & Trim(site.zip)>
  </cfif>
</cfif>

<cfset local.phoneDisplay = (isStruct(site) and StructKeyExists(site, "phone") and Len(Trim(site.phone))) ? Trim(site.phone) : "(509) 667-6365">
<cfset local.phoneHref = ReReplace(local.phoneDisplay, "[^0-9+]", "", "all")>
<cfset local.faxDisplay = (isStruct(site) and StructKeyExists(site, "fax") and Len(Trim(site.fax))) ? Trim(site.fax) : "(509) 667-6664">
<cfset local.officeHours = (isStruct(site) and StructKeyExists(site, "office_hours") and Len(Trim(site.office_hours))) ? Trim(site.office_hours) : "">

<cfoutput>
<!-- Office Contact & Hours Card -->
<div class="dept-contact-card">
  <p>
    <i class="fa-solid fa-building me-2 text-brand" aria-hidden="true"></i> <strong class="fs-5">Office Information</strong>
  </p>
  <p>
    <i class="fa-solid fa-location-dot text-brand me-2" aria-hidden="true"></i>
    <strong>Address:</strong><br>
    #EncodeForHTML(local.addrLine1)#<br>
    #EncodeForHTML(local.cityStateZip)#
  </p>
  <cfif Len(local.phoneDisplay)>
    <p>
      <i class="fa-solid fa-phone text-brand me-2" aria-hidden="true"></i>
      <strong>Phone:</strong><br>
      <a href="tel:#EncodeForHTMLAttribute(local.phoneHref)#" class="text-decoration-none fw-semibold">#EncodeForHTML(local.phoneDisplay)#</a>
    </p>
  </cfif>
  <cfif Len(local.faxDisplay)>
    <p>
      <i class="fa-solid fa-fax text-brand me-2" aria-hidden="true"></i>
      <strong>Fax:</strong><br>
      #EncodeForHTML(local.faxDisplay)#
    </p>
  </cfif>
  <p>
    <i class="fa-regular fa-clock text-brand me-2" aria-hidden="true"></i>
    <strong>Hours:</strong><br>
    <cfif Len(local.officeHours)>
      #EncodeForHTML(local.officeHours)#
    <cfelse>
      Monday &ndash; Friday<br>
      8:00 AM &ndash; 5:00 PM PST
    </cfif>
  </p>
</div>
</cfoutput>

