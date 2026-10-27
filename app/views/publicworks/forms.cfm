<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/publicworks/forms.cfm - Chelan County Public Works Online Forms --->
<cfparam name="site" default="#getWorkspace('public-works')#">
<cfparam name="nav" default="#[]#">
<cfparam name="formKey" default="report-a-problem">
<cfset local.formTitle = (CompareNoCase(formKey, "join-newsletter") EQ 0) ? "Join Our Newsletter" : "Report A Problem / Service Request">
<cfset content = { Title: local.formTitle }>
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
      <h1 class="section-title mb-3">#EncodeForHTML(local.formTitle)#</h1>
      <hr>

      <cfif CompareNoCase(formKey, "join-newsletter") EQ 0>
        <p class="lead">Chelan County Public Works is committed to keeping the public informed and up-to-date on road work, projects, and events.</p>
        <div class="card border-0 shadow-sm rounded-4">
          <div class="card-body p-4">
            <form action="/public-works/forms/join-newsletter" method="get">
              <div class="row g-3">
                <div class="col-md-6">
                  <label for="firstname" class="form-label fw-semibold">First Name <span class="text-danger">*</span></label>
                  <input type="text" id="firstname" name="firstname" class="form-control" required>
                </div>
                <div class="col-md-6">
                  <label for="lastname" class="form-label fw-semibold">Last Name <span class="text-danger">*</span></label>
                  <input type="text" id="lastname" name="lastname" class="form-control" required>
                </div>
                <div class="col-12">
                  <label for="email" class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                  <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="col-12">
                  <button type="submit" class="btn btn-primary rounded-pill px-4">Subscribe to Updates</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      <cfelse>
        <p>Public Works believes that we are all stakeholders and owners of the public infrastructure in Chelan County. If you have spotted a problem that Chelan County Public Works needs to know about, let us know by completing the form below. <strong>Emergencies should be referred to 911.</strong></p>
        <div class="card border-0 shadow-sm rounded-4">
          <div class="card-body p-4">
            <form action="/public-works/forms/report-a-problem" method="get">
              <div class="row g-3">
                <div class="col-md-6">
                  <label for="firstname" class="form-label fw-semibold">First Name <span class="text-danger">*</span></label>
                  <input type="text" id="firstname" name="firstname" class="form-control" required>
                </div>
                <div class="col-md-6">
                  <label for="lastname" class="form-label fw-semibold">Last Name <span class="text-danger">*</span></label>
                  <input type="text" id="lastname" name="lastname" class="form-control" required>
                </div>
                <div class="col-md-6">
                  <label for="email" class="form-label fw-semibold">Email Address <span class="text-danger">*</span></label>
                  <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="col-md-6">
                  <label for="phone" class="form-label fw-semibold">Phone Number <span class="text-danger">*</span></label>
                  <input type="tel" id="phone" name="phone" class="form-control" required>
                </div>
                <div class="col-12">
                  <label for="location" class="form-label fw-semibold">Location Address / Road Name <span class="text-danger">*</span></label>
                  <input type="text" id="location" name="location" class="form-control" required>
                </div>
                <div class="col-12">
                  <label for="description" class="form-label fw-semibold">Describe the Problem <span class="text-danger">*</span></label>
                  <textarea id="description" name="description" rows="5" class="form-control" required></textarea>
                </div>
                <div class="col-12">
                  <button type="submit" class="btn btn-primary rounded-pill px-4">Submit Request</button>
                </div>
              </div>
            </form>
          </div>
        </div>
      </cfif>
    </div>
  </div>
</div>

</cfoutput>

