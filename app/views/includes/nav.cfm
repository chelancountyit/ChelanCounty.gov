<!-- ============ Primary nav (Bootstrap navbar + mega dropdowns) ============ -->
<cfoutput>
<nav class="navbar navbar-expand-lg navbar-gov p-0" aria-label="Primary">
  <div class="container">
    <button class="navbar-toggler my-2 text-white border-white" type="button" data-bs-toggle="collapse" data-bs-target="##primaryNav" aria-controls="primaryNav" aria-expanded="false" aria-label="Toggle navigation menu">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="primaryNav">
      <ul class="navbar-nav">

        <li class="nav-item dropdown position-static">
          <a class="nav-link dropdown-toggle px-3 py-3" href="##" role="button" data-bs-toggle="dropdown" aria-expanded="false" aria-controls="your-government-menu">
            Your Government
          </a>
          <div class="dropdown-menu mega-menu" data-bs-display="static" id="your-government-menu" aria-labelledby="your-government-title">
            <div class="container">
              <p class="mega-menu-heading mega-menu-heading-lg" id="your-government-title">Your Government</p>

              <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4" role="group" aria-labelledby="your-government-title">
                <div class="col"><a class="dropdown-item" href="/assessor">Assessor</a></div>
                <div class="col"><a class="dropdown-item" href="/auditor">Auditor</a></div>
                <div class="col"><a class="dropdown-item" href="/board-of-commissioners">Board of County Commissioners</a></div>
                <div class="col"><a class="dropdown-item" href="/clerk">Clerk</a></div>
                <div class="col"><a class="dropdown-item" href="/community-development">Community Development</a></div>
                <div class="col"><a class="dropdown-item" href="/coroner">Coroner</a></div>
                <div class="col"><a class="dropdown-item" href="/district-court">District Court</a></div>
                <div class="col"><a class="dropdown-item" href="/district-court-probation">District Court Probation</a></div>
                <div class="col"><a class="dropdown-item" href="/elections">Elections</a></div>
                <div class="col"><a class="dropdown-item" href="/emergency-management">Emergency Management</a></div>
                <div class="col"><a class="dropdown-item" href="/fire-marshal">Fire Prevention and Investigation</a></div>
                <div class="col"><a class="dropdown-item" href="/flood-control-zone-district">Flood Control Zone District</a></div>
                <div class="col"><a class="dropdown-item" href="/human-resources">Human Resources</a></div>
                <div class="col"><a class="dropdown-item" href="/juvenile-justice-center">Juvenile Justice Center</a></div>
                <div class="col"><a class="dropdown-item" href="/law-library">Law Library</a></div>
                <div class="col"><a class="dropdown-item" href="/natural-resources">Natural Resources</a></div>
                <div class="col"><a class="dropdown-item" href="/prosecutor">Prosecuting Attorney</a></div>
                <div class="col"><a class="dropdown-item" href="/public-records">Public Records Request</a></div>
                <div class="col"><a class="dropdown-item" href="/public-works">Public Works</a></div>
                <div class="col"><a class="dropdown-item" href="/regional-justice-center">Regional Justice Center</a></div>
                <div class="col"><a class="dropdown-item" href="/sheriff">Sheriff's Office</a></div>
                <div class="col"><a class="dropdown-item" href="/solid-waste">Solid Waste Management</a></div>
                <div class="col"><a class="dropdown-item" href="/superior-court">Superior Court</a></div>
                <div class="col"><a class="dropdown-item" href="/treasurer">Treasurer</a></div>
              </div>

              <hr class="mega-menu-divider">

              <p class="mega-menu-heading mega-menu-heading-lg" id="mm-heading-community-outreach">Community Outreach</p>

              <div class="row row-cols-sm-2 row-cols-md-4" role="group" aria-labelledby="mm-heading-community-outreach">
                <div class="col"><a class="dropdown-item" href="/boundary-review-board">Boundary Review Board</a></div>
                <div class="col"><a class="dropdown-item" href="/expo-center">Chelan County Expo Center</a></div>
                <div class="col"><a class="dropdown-item" href="https://www.chelancountyfair.com" aria-label="Visit Chelan County Fair (Opens a new window)" target="_blank" rel="noopener noreferrer">Chelan County Fair</a></div>
                <div class="col"><a class="dropdown-item" href="https://cdhd.wa.gov" aria-label="Visit Chelan-Douglas Health District (Opens a new window)" target="_blank" rel="noopener noreferrer">Chelan-Douglas Health District</a></div>
                <div class="col"><a class="dropdown-item" href="/communications">Communications</a></div>
                <div class="col"><a class="dropdown-item" href="/farm-worker-housing">Farm Worker Housing</a></div>
                <div class="col"><a class="dropdown-item" href="/homeless-housing-network">Homeless Housing Network</a></div>
                <div class="col"><a class="dropdown-item" href="/horticultural-pest-and-disease-board">Horticultural Pest and Disease Board</a></div>
                <div class="col"><a class="dropdown-item" href="/noxious-weed">Noxious Weed Control Board</a></div>
                <div class="col"><a class="dropdown-item" href="https://www.ohmegardens.org" aria-label="Visit Ohme Gardens (Opens a new window)" target="_blank" rel="noopener noreferrer">Ohme Gardens</a></div>
                <div class="col"><a class="dropdown-item" href="/veterans-program">Veterans Program</a></div>
                <div class="col"><a class="dropdown-item" href="https://www.visitchelancounty.com" aria-label="Visit Visit Chelan County (Opens a new window)" target="_blank" rel="noopener noreferrer">Visit Chelan County</a></div>
                <div class="col"><a class="dropdown-item" href="/wenatchee-river-county-park">Wenatchee River County Park</a></div>
                <div class="col"><a class="dropdown-item" href="/wsu-extension">WSU Extension</a></div>
              </div>

            </div>
          </div>
        </li>

        <li class="nav-item dropdown position-static">
          <a class="nav-link dropdown-toggle px-3 py-3" href="##" role="button" data-bs-toggle="dropdown" aria-expanded="false" aria-controls="how-do-i-menu">
            How Do I
          </a>
          <div class="dropdown-menu mega-menu" data-bs-display="static" id="how-do-i-menu" aria-labelledby="how-do-i-title">
            <div class="container">
              <p class="mega-menu-title" id="how-do-i-title">How Do I</p>
              <div class="row g-3 row-cols-1 row-cols-sm-2 row-cols-md-5">
                <div class="col" role="group" aria-labelledby="mm-heading-apply-for">
                  <p class="mega-menu-heading pt-3" id="mm-heading-apply-for">Apply For</p>
                  <a class="dropdown-item" href="/human-resources/jobs">A job</a>
                  <a class="dropdown-item" href="/community-development">A new address</a>
                  <a class="dropdown-item" href="/public-works">Adopt a County Road</a>
                  <a class="dropdown-item" href="/community-development">A building permit</a>
                  <a class="dropdown-item" href="/sheriff">A concealed pistol license</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-contact">
                  <p class="mega-menu-heading pt-3" id="mm-heading-contact">Contact</p>
                  <a class="dropdown-item" href="/board-of-commissioners">Board of Commissioners</a>
                  <a class="dropdown-item" href="/elections">Chelan County Elections</a>
                  <a class="dropdown-item" href="/coroner">Coroner's Office</a>
                  <a class="dropdown-item" href="/clerk">Court Clerk</a>
                  <a class="dropdown-item" href="/district-court">District Court</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-find">
                  <p class="mega-menu-heading pt-3" id="mm-heading-find">Find</p>
                  <a class="dropdown-item" href="##">Bail bond agencies</a>
                  <a class="dropdown-item" href="##">Agencias de fianza de bonos</a>
                  <a class="dropdown-item" href="##">Check a subpoena status</a>
                  <a class="dropdown-item" href="##">Court-approved transcribers</a>
                  <a class="dropdown-item" href="/public-works">Public Works bidding opportunities</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-file-a">
                  <p class="mega-menu-heading pt-3" id="mm-heading-file-a">File A</p>
                  <a class="dropdown-item" href="##">Claim against Chelan County</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-pay-for">
                  <p class="mega-menu-heading pt-3" id="mm-heading-pay-for">Pay For</p>
                  <a class="dropdown-item" href="/treasurer">Property taxes</a>
                  <a class="dropdown-item" href="/clerk">Court costs and restitution</a>
                  <a class="dropdown-item" href="/regional-justice-center">Jail commissary account</a>
                  <a class="dropdown-item" href="/district-court-probation">Probation fees online</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-learn-about">
                  <p class="mega-menu-heading pt-3" id="mm-heading-learn-about">Learn About</p>
                  <a class="dropdown-item" href="##">Anti-harassment orders</a>
                  <a class="dropdown-item" href="##">Domestic violence</a>
                  <a class="dropdown-item" href="##">Domestic violence assistance</a>
                  <a class="dropdown-item" href="##">Domestic violence protection</a>
                  <a class="dropdown-item" href="##">No-contact orders</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-register-to">
                  <p class="mega-menu-heading pt-3" id="mm-heading-register-to">Register To</p>
                  <a class="dropdown-item" href="##">Serve jury duty</a>
                  <a class="dropdown-item" href="/clerk/forms/parenting-class-enrollment">Take a parenting class</a>
                  <a class="dropdown-item" href="/elections">Vote</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-report">
                  <p class="mega-menu-heading pt-3" id="mm-heading-report">Report</p>
                  <a class="dropdown-item" href="##">A code violation</a>
                  <a class="dropdown-item" href="##">Icy road conditions</a>
                  <a class="dropdown-item" href="##">A missing traffic sign</a>
                  <a class="dropdown-item" href="/horticultural-pest-and-disease-board/forms/report-a-problem">A pest infestation on fruit trees</a>
                  <a class="dropdown-item" href="/public-works/forms/report-a-problem">A general problem</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-request">
                  <p class="mega-menu-heading pt-3" id="mm-heading-request">Request</p>
                  <a class="dropdown-item" href="/public-records">Public records</a>
                  <a class="dropdown-item" href="##">A death certificate</a>
                  <a class="dropdown-item" href="/district-court">District Court case records</a>
                  <a class="dropdown-item" href="##">Administrative records (GR 31.1)</a>
                  <a class="dropdown-item" href="##">A flood elevation certificate</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-search-for">
                  <p class="mega-menu-heading pt-3" id="mm-heading-search-for">Search For</p>
                  <a class="dropdown-item" href="/board-of-commissioners">Commissioners' public documents</a>
                  <a class="dropdown-item" href="/regional-justice-center">An inmate or arrestee</a>
                </div>
                <div class="col" role="group" aria-labelledby="mm-heading-view">
                  <p class="mega-menu-heading pt-3" id="mm-heading-view">View</p>
                  <a class="dropdown-item" href="##">Court dockets and schedules</a>
                </div>
              </div>
            </div>
          </div>
        </li>

        <li class="nav-item dropdown position-static">
          <a class="nav-link dropdown-toggle px-3 py-3" href="##" role="button" data-bs-toggle="dropdown" aria-expanded="false" aria-controls="online-services-menu">
            Online Services
          </a>
          <div class="dropdown-menu mega-menu" data-bs-display="static" id="online-services-menu" aria-labelledby="online-services-title">
            <div class="container">
              <p class="mega-menu-heading mega-menu-heading-lg" id="online-services-title">Online Services</p>
              <div class="row row-cols-sm-2 row-cols-md-5">
                <div class="col"><a class="dropdown-item" href="https://maps.chelancounty.gov/GIS/" aria-label="ArcGIS Mapping (Opens a new window)">ArcGIS Mapping</a></div>
                <div class="col"><a class="dropdown-item" href="/assessor" aria-label="Property and Parcel Search (Opens a new window)">Property and Parcel Search</a></div>
                <div class="col"><a class="dropdown-item" href="/elections" aria-label="Election Results (Opens a new window)">Election Results</a></div>
                <div class="col"><a class="dropdown-item" href="/district-court" aria-label="Court Case Search (Opens a new window)">Court Case Search</a></div>
                <div class="col"><a class="dropdown-item" href="/auditor" aria-label="Recording Document Search (Opens a new window)">Recording Document Search</a></div>
                <div class="col"><a class="dropdown-item" href="/treasurer" aria-label="Pay Your Property Tax (Opens a new window)">Pay Your Property Tax</a></div>
                <div class="col"><a class="dropdown-item" href="/auditor" aria-label="Renew a Vehicle or Boat Tab (Opens a new window)">Renew a Vehicle or Boat Tab</a></div>
                <div class="col"><a class="dropdown-item" href="/district-court-probation" aria-label="Probation Fee Online Payment (Opens a new window)">Probation Fee Online Payment</a></div>
                <div class="col"><a class="dropdown-item" href="/auditor" aria-label="Apply for a Marriage License (Opens a new window)">Apply for a Marriage License</a></div>
                <div class="col"><a class="dropdown-item" href="/public-records" aria-label="Public Records Request (Opens a new window)">Public Records Request</a></div>
                <div class="col"><a class="dropdown-item" href="https://www.codepublishing.com/WA/ChelanCounty/" aria-label="Chelan County Code (Opens a new window)">Chelan County Code</a></div>
                <div class="col"><a class="dropdown-item" href="https://www.premera.com/visitor/transparency-coverage" aria-label="Transparency in Coverage (Opens a new window)">Transparency in Coverage</a></div>
                <div class="col"><a class="dropdown-item" href="http://www.sheriffalerts.com/cap_office_disclaimer.php?office=54458" aria-label="Search For Sex Offenders (Opens a new window)">Search For Sex Offenders</a></div>
              </div>

              <hr class="mega-menu-divider">

              <p class="mega-menu-heading mega-menu-heading-lg" id="mm-heading-online-forms">Online Forms</p>

              <div class="row row-cols-sm-2 row-cols-md-4" role="group" aria-labelledby="mm-heading-online-forms">
                <div class="col"><a class="dropdown-item" href="/clerk/forms/confirm-a-hearing">Continue or Strike A Hearing</a></div>
                <div class="col"><a class="dropdown-item" href="/district-court/pages/mitigation-or-contested-hearing-on-written-statements">Hearing on Written Statements</a></div>
                <div class="col"><a class="dropdown-item" href="/district-court-probation/forms/monthly-probation-reporting">Monthly Probation Reporting</a></div>
                <div class="col"><a class="dropdown-item" href="/clerk/forms/parenting-class-enrollment">Parenting Class Enrollment</a></div>
                <div class="col"><a class="dropdown-item" href="/public-works/forms/report-a-problem">Public Works Service Request</a></div>
                <div class="col"><a class="dropdown-item" href="/sheriff/forms/request-for-residence-check">Request for Residence Check</a></div>
                <div class="col"><a class="dropdown-item" href="/noxious-weed/forms/report-a-weed-infestation">Report Weed Infestation</a></div>
                <div class="col"><a class="dropdown-item" href="/horticultural-pest-and-disease-board/forms/report-a-problem">Report Pest Infestation</a></div>
                <div class="col"><a class="dropdown-item" href="/sheriff/forms/submit-a-tip">Submit A Crime Tip</a></div>
              </div>

            </div>
          </div>
        </li>

      </ul>
    </div>
  </div>
</nav>
</cfoutput>