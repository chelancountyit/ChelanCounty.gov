<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/calendar/index.cfm — Full County Calendar Page connected to CMSAdmin 2.0 --->
<cfparam name="categories" default="#[]#">
<cfparam name="events" default="#[]#">
<cfparam name="selectedEventId" default="0">
<cfparam name="selectedCategory" default="">

<cfoutput>
<section class="dept-hero" style="--dept-hero-start:##0F2C46; --dept-hero-end:##173F63;">
  <div class="container">
    <nav aria-label="Breadcrumb" class="breadcrumb-gov">
      <ol class="breadcrumb mb-2">
        <li class="breadcrumb-item"><a href="/"><i class="fa-solid fa-house me-1" aria-hidden="true"></i>Home</a></li>
        <li class="breadcrumb-item active" aria-current="page">County Calendar &amp; Events</li>
      </ol>
    </nav>
    <div class="d-flex flex-wrap align-items-end justify-content-between gap-3">
      <div>
        <h1 class="display-5 dept-title mb-2">County Calendar &amp; Events</h1>
        <p class="dept-tagline mb-0">Official schedule of Board of County Commissioners sessions, public hearings, advisory boards, elections deadlines, and community events.</p>
      </div>
      <div>
        <a href="/calendar/ics" class="btn btn-light fw-bold shadow-sm">
          <i class="fa-regular fa-calendar-plus me-2 text-primary" aria-hidden="true"></i>Export Calendar (.ics)
        </a>
      </div>
    </div>
  </div>
</section>
<div class="dept-wave-divider" aria-hidden="true"></div>

<div class="container py-4">
  <!-- Interactive 6x6 Calendar & Month Feed -->
  <div class="row justify-content-center mb-5">
    <div class="col-lg-10">
      #includePartial(partial="/shared/_calendar.cfm")#
    </div>
  </div>

  <!-- Full Searchable & Filterable Directory of Events -->
  <div class="row justify-content-center">
    <div class="col-lg-10">
      <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-3 pb-2 border-bottom">
        <h2 class="h4 mb-0">All Scheduled Events</h2>
        <div class="d-flex flex-wrap align-items-center gap-2">
          <label for="calendar-search-input" class="visually-hidden">Search events</label>
          <input type="search" id="calendar-search-input" class="form-control form-control-sm" style="min-width:220px;" placeholder="Search events or locations...">
        </div>
      </div>

      <!-- Category Filter Pills -->
      <cfif ArrayLen(categories) GT 0>
        <div class="d-flex flex-wrap gap-2 mb-4" role="group" aria-label="Filter events by category">
          <button type="button" class="btn btn-sm btn-primary js-cal-cat-filter active" data-category="">All Categories</button>
          <cfloop array="#categories#" index="local.cat">
            <button type="button" class="btn btn-sm btn-outline-secondary js-cal-cat-filter" data-category="#EncodeForHTMLAttribute(local.cat.slug)#">
              <i class="#EncodeForHTMLAttribute(local.cat.faIcon)# me-1" aria-hidden="true" style="color:#EncodeForHTMLAttribute(local.cat.color)#;"></i>#EncodeForHTML(local.cat.name)#
            </button>
          </cfloop>
        </div>
      </cfif>

      <div class="d-flex flex-column gap-3 full-calendar-events-scroll" id="full-calendar-events-list" tabindex="0" role="region" aria-label="All Scheduled Events">
        <cfif ArrayLen(events) GT 0>
          <cfloop array="#events#" index="local.ev">
            <article class="card card-brand shadow-sm js-full-cal-item <cfif Val(selectedEventId) EQ local.ev.id>border-primary border-2</cfif>"
                     id="event-#local.ev.id#"
                     data-category="#EncodeForHTMLAttribute(local.ev.categorySlug)#"
                     data-search="#EncodeForHTMLAttribute(LCase(local.ev.title & ' ' & local.ev.summary & ' ' & local.ev.locationName & ' ' & local.ev.categoryName & ' ' & local.ev.departmentName))#">
              <div class="card-body d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
                <div class="d-flex align-items-start gap-3">
                  <div class="event-badge" style="min-width:60px; padding:.5rem .45rem;">
                    <span class="badge-month">#EncodeForHTML(local.ev.monthAbbr)#</span>
                    <span class="badge-day">#local.ev.startDay#</span>
                  </div>
                  <div>
                    <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
                      <span class="badge rounded-pill" style="background:#EncodeForHTMLAttribute(local.ev.categoryColor)#; color:##fff; font-size:.72rem;">
                        <i class="#EncodeForHTMLAttribute(local.ev.categoryIcon)# me-1" aria-hidden="true"></i>#EncodeForHTML(local.ev.categoryName)#
                      </span>
                      <span class="badge bg-light text-secondary border" style="font-size:.72rem;">#EncodeForHTML(local.ev.departmentName)#</span>
                      <cfif local.ev.isPublicNotice>
                        <span class="badge bg-warning text-dark" style="font-size:.72rem;">Public Notice</span>
                      </cfif>
                    </div>
                    <h3 class="h5 mb-1">
                      <a href="#EncodeForHTMLAttribute(local.ev.url)#" class="js-full-event-open text-decoration-none" data-event-id="#local.ev.id#">#EncodeForHTML(local.ev.title)#</a>
                    </h3>
                    <div class="event-meta mb-2">
                      <span><i class="fa-regular fa-calendar" aria-hidden="true"></i> #EncodeForHTML(local.ev.dateDisplay)#</span>
                      <cfif Len(local.ev.timeDisplay)>
                        <span><i class="fa-regular fa-clock" aria-hidden="true"></i> #EncodeForHTML(local.ev.timeDisplay)#</span>
                      </cfif>
                      <cfif Len(local.ev.locationName)>
                        <span><i class="fa-solid fa-location-dot" aria-hidden="true"></i> #EncodeForHTML(local.ev.locationName)#<cfif Len(local.ev.roomNumber)> (#EncodeForHTML(local.ev.roomNumber)#)</cfif></span>
                      </cfif>
                    </div>
                    <cfif Len(local.ev.summary)>
                      <p class="mb-0 text-secondary small">#EncodeForHTML(local.ev.summary)#</p>
                    </cfif>
                  </div>
                </div>
                <div class="d-flex flex-wrap flex-md-column align-items-stretch gap-2 flex-shrink-0">
                  <cfif Len(local.ev.virtualMeetingUrl)>
                    <a href="#EncodeForHTMLAttribute(local.ev.virtualMeetingUrl)#" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary">
                      <i class="fa-solid fa-video me-1" aria-hidden="true"></i>Virtual Meeting
                    </a>
                  </cfif>
                  <cfif Len(local.ev.agendaUrl)>
                    <a href="#EncodeForHTMLAttribute(local.ev.agendaUrl)#" target="_blank" rel="noopener" class="btn btn-sm btn-outline-dark">
                      <i class="fa-regular fa-file-lines me-1" aria-hidden="true"></i>Agenda
                    </a>
                  </cfif>
                  <a href="#EncodeForHTMLAttribute(local.ev.icsUrl)#" class="btn btn-sm btn-outline-secondary">
                    <i class="fa-regular fa-calendar-plus me-1" aria-hidden="true"></i>Add (.ics)
                  </a>
                </div>
              </div>
            </article>
          </cfloop>
        <cfelse>
          <div class="alert alert-light border text-center py-4">
            No upcoming events are currently scheduled.
          </div>
        </cfif>
      </div>
    </div>
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
  var searchInput = document.getElementById("calendar-search-input");
  var catBtns = document.querySelectorAll(".js-cal-cat-filter");
  var cards = document.querySelectorAll(".js-full-cal-item");
  var activeCat = "";

  function filterFullList() {
    var q = (searchInput ? searchInput.value : "").trim().toLowerCase();
    cards.forEach(function(card) {
      var c = card.getAttribute("data-category") || "";
      var s = card.getAttribute("data-search") || "";
      var matchCat = !activeCat || c === activeCat;
      var matchQ = !q || s.indexOf(q) !== -1;
      card.style.display = (matchCat && matchQ) ? "" : "none";
    });
  }

  catBtns.forEach(function(btn) {
    btn.addEventListener("click", function() {
      activeCat = this.getAttribute("data-category") || "";
      catBtns.forEach(function(b) {
        b.classList.remove("active", "btn-primary");
        b.classList.add("btn-outline-secondary");
      });
      this.classList.remove("btn-outline-secondary");
      this.classList.add("active", "btn-primary");
      filterFullList();
    });
  });

  if (searchInput) {
    searchInput.addEventListener("input", filterFullList);
  }

  // Trigger modal when clicking an event title in the full directory
  document.querySelectorAll(".js-full-event-open").forEach(function(link) {
    link.addEventListener("click", function(e) {
      var id = Number(this.getAttribute("data-event-id") || 0);
      if (id && typeof window.openCountyCalendarEvent === "function") {
        e.preventDefault();
        window.openCountyCalendarEvent(id);
      }
    });
  });

  <cfif Val(selectedEventId) GT 0>
  var targetEl = document.getElementById("event-#Val(selectedEventId)#");
  if (targetEl) {
    targetEl.scrollIntoView({ behavior: "smooth", block: "center" });
  }
  </cfif>
});
</script>
</cfoutput>
