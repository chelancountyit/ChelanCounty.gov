<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-contact.cfm — Modern Office Contact & Hours Card --->
<cfif not isDefined("site") or not isStruct(site) or not StructKeyExists(site, "id") or not Val(site.id)>
  <cfset local.targetCode = isDefined("params.controller") and Len(Trim(params.controller)) ? LCase(Trim(params.controller)) : "assessor">
  <cfset site = getWorkspace(local.targetCode)>
</cfif>

<cfset local.rawAddr = isStruct(site) and StructKeyExists(site, "address") ? Trim(site.address) : "">
<cfset local.rawAddr2 = isStruct(site) and StructKeyExists(site, "address2") ? Trim(site.address2) : "">
<cfif Len(local.rawAddr) and Len(local.rawAddr2)>
  <cfset local.addrLine1 = local.rawAddr & ", " & local.rawAddr2>
<cfelseif Len(local.rawAddr)>
  <cfset local.addrLine1 = local.rawAddr>
<cfelse>
  <cfset local.addrLine1 = "350 Orondo Ave, Suite 206">
</cfif>

<cfset local.city = isStruct(site) and StructKeyExists(site, "city") and Len(Trim(site.city)) ? Trim(site.city) : "Wenatchee">
<cfset local.state = isStruct(site) and StructKeyExists(site, "state") and Len(Trim(site.state)) ? Trim(site.state) : "WA">
<cfset local.zip = isStruct(site) and StructKeyExists(site, "zip") and Len(Trim(site.zip)) ? Trim(site.zip) : "98801">
<cfset local.cityStateZip = local.city & ", " & local.state & " " & local.zip>

<cfset local.phoneDisplay = "">
<cfif isStruct(site)>
  <cfif StructKeyExists(site, "phone") and Len(Trim(site.phone))>
    <cfset local.phoneDisplay = Trim(site.phone)>
  <cfelseif StructKeyExists(site, "contact_phone") and Len(Trim(site.contact_phone))>
    <cfset local.phoneDisplay = Trim(site.contact_phone)>
  </cfif>
</cfif>
<cfif not Len(local.phoneDisplay)>
  <cfset local.phoneDisplay = "509-667-6365">
</cfif>
<cfset local.rawPhone = ReReplace(local.phoneDisplay, "[^0-9]", "", "all")>
<cfif Len(local.rawPhone) EQ 10>
  <cfset local.phoneFormatted = Mid(local.rawPhone, 1, 3) & "-" & Mid(local.rawPhone, 4, 3) & "-" & Mid(local.rawPhone, 7, 4)>
<cfelse>
  <cfset local.phoneFormatted = local.phoneDisplay>
</cfif>
<cfset local.phoneHref = ReReplace(local.phoneDisplay, "[^0-9+]", "", "all")>

<cfset local.faxDisplay = "">
<cfif isStruct(site)>
  <cfif StructKeyExists(site, "fax") and Len(Trim(site.fax))>
    <cfset local.faxDisplay = Trim(site.fax)>
  <cfelseif StructKeyExists(site, "contact_fax") and Len(Trim(site.contact_fax))>
    <cfset local.faxDisplay = Trim(site.contact_fax)>
  </cfif>
</cfif>
<cfset local.rawFax = ReReplace(local.faxDisplay, "[^0-9]", "", "all")>
<cfif Len(local.rawFax) EQ 10>
  <cfset local.faxFormatted = Mid(local.rawFax, 1, 3) & "-" & Mid(local.rawFax, 4, 3) & "-" & Mid(local.rawFax, 7, 4)>
<cfelse>
  <cfset local.faxFormatted = local.faxDisplay>
</cfif>

<cfset local.officeHours = (isStruct(site) and StructKeyExists(site, "office_hours") and Len(Trim(site.office_hours))) ? Trim(site.office_hours) : "">
<cfset local.hoursDays = "MONDAY &ndash; FRIDAY">
<cfset local.hoursTime = "9:00 AM &ndash; 5:00 PM">

<cfif Len(local.officeHours)>
  <cfset local.timeMatch = ReFindNoCase("[0-9]{1,2}:[0-9]{2}\s*(AM|PM)", local.officeHours, 1, true)>
  <cfif StructKeyExists(local.timeMatch, "pos") and ArrayLen(local.timeMatch.pos) and local.timeMatch.pos[1] GT 1>
    <cfset local.splitPos = local.timeMatch.pos[1]>
    <cfset local.rawDays = Trim(Left(local.officeHours, local.splitPos - 1))>
    <cfset local.rawDays = ReReplace(local.rawDays, "[:\-–—\s]+$", "")>
    <cfset local.rawTime = Trim(Mid(local.officeHours, local.splitPos, Len(local.officeHours)))>
    <cfif Len(local.rawDays)>
      <cfset local.hoursDays = UCase(local.rawDays)>
    </cfif>
    <cfif Len(local.rawTime)>
      <cfset local.hoursTime = UCase(local.rawTime)>
    </cfif>
  <cfelse>
    <cfset local.hoursDays = UCase(Trim(local.officeHours))>
    <cfset local.hoursTime = "">
  </cfif>

  <cfset local.hoursDays = Replace(local.hoursDays, "-", "&ndash;", "all")>
  <cfset local.hoursTime = Replace(local.hoursTime, "-", "&ndash;", "all")>
</cfif>

<cfoutput>
<!-- Modern Office Contact & Hours Card -->
<div class="dept-contact-card" role="region" aria-label="Office Information and Hours">
  <div class="dept-contact-eyebrow">VISIT US</div>
  <p class="h3 dept-contact-title">OFFICE<br>INFORMATION</p>

  <!-- Address: icon aligned with title -->
  <div class="dept-contact-section">
    <div class="dept-contact-title-row">
      <span class="dept-contact-icon me-2">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="##b47820" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/>
          <circle cx="12" cy="10" r="3"/>
        </svg>
      </span>
      <span class="dept-contact-label">ADDRESS</span>
    </div>
    <div class="dept-contact-val">
      #EncodeForHTML(local.addrLine1)#<br>
      #EncodeForHTML(local.cityStateZip)#
    </div>
  </div>

  <hr class="dept-contact-divider">

  <!-- Phone: icon aligned with title -->
  <cfif Len(local.phoneDisplay)>
    <div class="dept-contact-section mt-2">
      <div class="dept-contact-title-row">
        <span class="dept-contact-icon me-2">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="##b47820" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
          </svg>
        </span>
        <span class="dept-contact-label">PHONE</span>
      </div>
      <div class="dept-contact-val phone">
        <a href="tel:#EncodeForHTMLAttribute(local.phoneHref)#">#EncodeForHTML(local.phoneFormatted)#</a>
      </div>
    </div>
  </cfif>

  <!-- Fax: icon aligned with title -->
  <cfif Len(local.faxFormatted)>
    <div class="dept-contact-section">
      <div class="dept-contact-title-row">
        <span class="dept-contact-icon me-2">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="##b47820" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
            <path d="M6 9V2h12v7"/>
            <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/>
            <rect width="12" height="8" x="6" y="14"/>
          </svg>
        </span>
        <span class="dept-contact-label">FAX</span>
      </div>
      <div class="dept-contact-val fax">
        #EncodeForHTML(local.faxFormatted)#
      </div>
    </div>
  </cfif>

  <!-- Hours: icon aligned with title -->
  <div class="dept-contact-section mb-0">
    <div class="dept-contact-title-row">
      <span class="dept-contact-icon me-2">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="##102a43" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
          <circle cx="12" cy="12" r="10"/>
          <polyline points="12 6 12 12 16 14"/>
        </svg>
      </span>
      <span class="dept-contact-label">HOURS</span>
    </div>
    <div class="dept-contact-val hours">
      #local.hoursDays#<cfif Len(local.hoursTime)><br>#local.hoursTime#</cfif>
    </div>
  </div>
</div>
</cfoutput>
