<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/publicworks/contacts.cfm - Chelan County Public Works Office Directory & Contact Info --->
<cfparam name="site" default="#getWorkspace('public-works')#">
<cfparam name="nav" default="#[]#">
<cfparam name="employees" default="#queryNew('EMPLOYEEID,FIRSTNAME,LASTNAME,TITLE,POSITION,LOCATIONNAME,ADDRESS,CITY,STATE,ZIP,PHONE,FAX,EMAIL')#">
<cfset content = { Title: "Contact Our Office" }>
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
      <h1 class="section-title mb-3">Contact Our Office</h1>
      <hr>

      <div class="card border-0 shadow-sm rounded-4 mb-4">
        <div class="card-body p-4">
          <div class="row g-4">
            <div class="col-md-6">
              <h2 class="h5 fw-bold mb-3">Office Details</h2>
              <p class="mb-2">
                <i class="fa-solid fa-location-dot text-primary me-2" aria-hidden="true"></i>
                #EncodeForHTML(site.address)#, #EncodeForHTML(site.city)#, #EncodeForHTML(site.state)# #EncodeForHTML(site.zip)#
              </p>
              <cfif Len(Trim(site.email ?: ""))>
                <p class="mb-2">
                  <i class="fa-solid fa-envelope text-primary me-2" aria-hidden="true"></i>
                  <a href="mailto:#EncodeForHTMLAttribute(site.email)#">#EncodeForHTML(site.email)#</a>
                </p>
              </cfif>
              <cfif Len(Trim(site.phone ?: ""))>
                <p class="mb-2">
                  <i class="fa-solid fa-phone text-primary me-2" aria-hidden="true"></i>
                  <a href="tel:#EncodeForHTMLAttribute(ReReplace(site.phone, '[^0-9+]', '', 'all'))#">#EncodeForHTML(site.phone)#</a>
                </p>
              </cfif>
              <cfif Len(Trim(site.fax ?: ""))>
                <p class="mb-0">
                  <i class="fa-solid fa-fax text-primary me-2" aria-hidden="true"></i>
                  #EncodeForHTML(site.fax)#
                </p>
              </cfif>
            </div>
            <div class="col-md-6">
              <h2 class="h5 fw-bold mb-3">Office Hours</h2>
              <p class="mb-3">#EncodeForHTML(site.office_hours ?: 'Monday - Friday 8:00 AM - 5:00 PM PST')#</p>
              <a href="/public-works/forms/report-a-problem" class="btn btn-primary rounded-pill px-4">
                <i class="fa-solid fa-triangle-exclamation me-2" aria-hidden="true"></i>Report A Problem
              </a>
            </div>
          </div>
        </div>
      </div>

      <cfif isQuery(employees) and employees.recordCount GT 0>
        <h2 class="h4 fw-bold mb-3">Office Directory</h2>
        <div class="table-responsive">
          <table class="table table-bordered table-hover align-middle bg-white shadow-sm rounded-3 overflow-hidden">
            <thead class="table-light">
              <tr>
                <th scope="col" style="width: 60%;">Staff Member &amp; Role</th>
                <th scope="col">Contact Information</th>
              </tr>
            </thead>
            <tbody>
              <cfloop query="employees">
                <tr>
                  <td>
                    <div class="fw-bold">#EncodeForHTML(Trim(employees.FIRSTNAME & " " & employees.LASTNAME))##Len(Trim(employees.TITLE ?: '')) ? ', ' & EncodeForHTML(Trim(employees.TITLE)) : ''#</div>
                    <cfif Len(Trim(employees.POSITION ?: ""))>
                      <div class="text-muted small">#EncodeForHTML(Trim(employees.POSITION))#</div>
                    </cfif>
                  </td>
                  <td>
                    <cfif Len(Trim(employees.PHONE ?: ""))>
                      <div><i class="fa-solid fa-phone text-muted me-2" aria-hidden="true"></i><a href="tel:#EncodeForHTMLAttribute(ReReplace(employees.PHONE, '[^0-9+]', '', 'all'))#">#EncodeForHTML(Trim(employees.PHONE))#</a></div>
                    </cfif>
                    <cfif Len(Trim(employees.EMAIL ?: ""))>
                      <div><i class="fa-solid fa-envelope text-muted me-2" aria-hidden="true"></i><a href="mailto:#EncodeForHTMLAttribute(Trim(employees.EMAIL))#">#EncodeForHTML(Trim(employees.EMAIL))#</a></div>
                    </cfif>
                  </td>
                </tr>
              </cfloop>
            </tbody>
          </table>
        </div>
      </cfif>
    </div>
  </div>
</div>

</cfoutput>

