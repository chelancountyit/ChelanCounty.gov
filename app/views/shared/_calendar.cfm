<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_calendar.cfm — Subtle 6x6 Calendar (Left) & Events (Right) Card connected to CMSAdmin 2.0 --->
<cfparam name="arguments.theme" default="light">
<cfparam name="arguments.siteid" default="">
<cfparam name="arguments.includeAllWorkspaces" default="true">
<cfscript>
	local.isDark = CompareNoCase(Trim(arguments.theme), "dark") == 0;
	local.themeClass = local.isDark ? " subtle-events-card--dark" : "";
	local.calEvents = getCalendarEvents(
		siteid = arguments.siteid,
		includeAllWorkspaces = arguments.includeAllWorkspaces
	);

	local.nowDate = Now();
	local.todayIso = DateFormat(local.nowDate, "yyyy-mm-dd");
	local.initYear = Year(local.nowDate);
	local.initMonth = Month(local.nowDate);

	// Check if current month has any events; if not, jump to the month of the next upcoming event (or most recent event)
	local.curMonthPrefix = NumberFormat(local.initYear, "0000") & "-" & NumberFormat(local.initMonth, "00");
	local.hasCurMonthEvents = false;
	for (local.ev in local.calEvents) {
		if (Left(local.ev.startDate, 7) <= local.curMonthPrefix && Left(local.ev.endDate, 7) >= local.curMonthPrefix) {
			local.hasCurMonthEvents = true;
			break;
		}
	}
	if (!local.hasCurMonthEvents && ArrayLen(local.calEvents) > 0) {
		local.pickedEv = local.calEvents[1];
		for (local.ev in local.calEvents) {
			if (local.ev.endDate >= local.todayIso) {
				local.pickedEv = local.ev;
				break;
			}
		}
		local.initYear = local.pickedEv.startYear;
		local.initMonth = local.pickedEv.startMonth;
	}

	local.firstOfMonth = CreateDate(local.initYear, local.initMonth, 1);
	local.monthLabel = DateFormat(local.firstOfMonth, "mmmm yyyy");
	local.daysInMonth = DaysInMonth(local.firstOfMonth);
	local.startDow = DayOfWeek(local.firstOfMonth); // 1=Sunday .. 7=Saturday
	local.prevMonthDate = DateAdd("m", -1, local.firstOfMonth);
	local.daysInPrevMonth = DaysInMonth(local.prevMonthDate);

	local.monthStartIso = DateFormat(local.firstOfMonth, "yyyy-mm-dd");
	local.monthEndIso = DateFormat(CreateDate(local.initYear, local.initMonth, local.daysInMonth), "yyyy-mm-dd");

	// Collect events occurring in the initial month and map day->events
	local.monthEvents = [];
	local.dayEventsMap = {};
	local.firstEventDay = 0;

	for (local.ev in local.calEvents) {
		if (local.ev.startDate <= local.monthEndIso && local.ev.endDate >= local.monthStartIso) {
			ArrayAppend(local.monthEvents, local.ev);
			for (local.d = 1; local.d <= local.daysInMonth; local.d++) {
				local.dIso = NumberFormat(local.initYear, "0000") & "-" & NumberFormat(local.initMonth, "00") & "-" & NumberFormat(local.d, "00");
				if (local.dIso >= local.ev.startDate && local.dIso <= local.ev.endDate) {
					local.dKey = "d_" & local.d;
					if (!StructKeyExists(local.dayEventsMap, local.dKey)) {
						local.dayEventsMap[local.dKey] = [];
					}
					ArrayAppend(local.dayEventsMap[local.dKey], local.ev);
					if (local.firstEventDay == 0) {
						local.firstEventDay = local.d;
					}
				}
			}
		}
	}

	local.widgetUid = "cal_" & LCase(Left(CreateUUID(), 8));
</cfscript>
<cfoutput>
<aside class="subtle-events-card#local.themeClass#" id="#local.widgetUid#" role="region" aria-label="Upcoming Events and County Calendar" data-init-year="#local.initYear#" data-init-month="#local.initMonth#">
  
  <!-- Eyebrow & Title matching _dept-contact style -->
  <div class="events-eyebrow">CHELAN COUNTY</div>
  <h3 class="h4 events-card-title">CALENDAR &amp; EVENTS</h3>

  <!-- 6x6 Grid: Calendar on Left (col-md-6), Events on Right (col-md-6) -->
  <div class="row g-4 align-items-stretch">
    
    <!-- LEFT 6 COLS: Calendar Month View -->
    <div class="col-12 col-md-6 d-flex flex-column">
      <div class="mini-cal h-100 js-mini-cal" aria-label="#EncodeForHTMLAttribute(local.monthLabel)# Calendar">
        <div class="mini-cal-header">
          <span class="mini-cal-month js-mini-cal-month" aria-live="polite">
            <i class="fa-regular fa-calendar-days <cfif local.isDark>text-warning<cfelse>text-primary</cfif> me-2" aria-hidden="true"></i><span class="js-mini-cal-month-text">#EncodeForHTML(local.monthLabel)#</span>
          </span>
          <div class="mini-cal-nav">
            <button type="button" class="mini-cal-btn js-cal-prev" aria-label="Previous month" title="Previous month"><i class="fa-solid fa-chevron-left" aria-hidden="true"></i></button>
            <button type="button" class="mini-cal-btn js-cal-today" aria-label="Current month" title="Jump to current month"><i class="fa-solid fa-calendar-check" aria-hidden="true"></i></button>
            <button type="button" class="mini-cal-btn js-cal-next" aria-label="Next month" title="Next month"><i class="fa-solid fa-chevron-right" aria-hidden="true"></i></button>
          </div>
        </div>
        <div class="mini-cal-grid js-mini-cal-grid" role="grid" aria-label="Calendar dates">
          <div class="mini-cal-dow" aria-label="Sunday">Su</div>
          <div class="mini-cal-dow" aria-label="Monday">Mo</div>
          <div class="mini-cal-dow" aria-label="Tuesday">Tu</div>
          <div class="mini-cal-dow" aria-label="Wednesday">We</div>
          <div class="mini-cal-dow" aria-label="Thursday">Th</div>
          <div class="mini-cal-dow" aria-label="Friday">Fr</div>
          <div class="mini-cal-dow" aria-label="Saturday">Sa</div>

          <div class="js-mini-cal-days" style="display:contents;">
            <!--- Leading muted days from previous month --->
            <cfif local.startDow GT 1>
              <cfloop from="#local.daysInPrevMonth - local.startDow + 2#" to="#local.daysInPrevMonth#" index="local.prevDay">
                <div class="mini-cal-day muted" aria-disabled="true">#local.prevDay#</div>
              </cfloop>
            </cfif>

            <!--- Days of active month --->
            <cfloop from="1" to="#local.daysInMonth#" index="local.dayNum">
              <cfset local.dKey = "d_" & local.dayNum>
              <cfset local.hasEv = StructKeyExists(local.dayEventsMap, local.dKey)>
              <cfset local.dateIso = NumberFormat(local.initYear, "0000") & "-" & NumberFormat(local.initMonth, "00") & "-" & NumberFormat(local.dayNum, "00")>
              <cfset local.isSelected = (local.dayNum EQ local.firstEventDay)>
              <cfset local.dayTitles = []>
              <cfif local.hasEv>
                <cfloop array="#local.dayEventsMap[local.dKey]#" index="local.dEv">
                  <cfset ArrayAppend(local.dayTitles, local.dEv.title)>
                </cfloop>
              </cfif>
              <cfset local.titleStr = ArrayToList(local.dayTitles, " • ")>
              <cfset local.ariaStr = DateFormat(CreateDate(local.initYear, local.initMonth, local.dayNum), "mmmm d, yyyy") & (Len(local.titleStr) ? ": " & local.titleStr : "")>
              <div class="mini-cal-day<cfif local.hasEv> has-event</cfif><cfif local.isSelected> selected</cfif>"
                   tabindex="0"
                   role="gridcell"
                   aria-selected="#local.isSelected ? 'true' : 'false'#"
                   data-day="#local.dayNum#"
                   data-date="#local.dateIso#"
                   <cfif Len(local.titleStr)>title="#EncodeForHTMLAttribute(local.titleStr)#"</cfif>
                   aria-label="#EncodeForHTMLAttribute(local.ariaStr)#">#local.dayNum#</div>
            </cfloop>

            <!--- Trailing muted days to complete final week --->
            <cfset local.totalCells = (local.startDow - 1) + local.daysInMonth>
            <cfset local.remCells = (7 - (local.totalCells MOD 7)) MOD 7>
            <cfif local.remCells GT 0>
              <cfloop from="1" to="#local.remCells#" index="local.nextDay">
                <div class="mini-cal-day muted" aria-disabled="true">#local.nextDay#</div>
              </cfloop>
            </cfif>
          </div>
        </div>
      </div>
    </div>

    <!-- RIGHT 6 COLS: Events List Feed -->
    <div class="col-12 col-md-6 d-flex flex-column">
      <ul class="event-list js-event-list" aria-label="Upcoming Events List" aria-live="polite">
        <cfif ArrayLen(local.monthEvents) GT 0>
          <cfloop array="#local.monthEvents#" index="local.ev">
            <li class="event-item" data-day="#local.ev.startDay#" data-start="#local.ev.startDate#" data-end="#local.ev.endDate#" data-event-id="#local.ev.id#">
              <div class="event-badge">
                <span class="badge-month">#EncodeForHTML(local.ev.monthAbbr)#</span>
                <span class="badge-day">#local.ev.startDay#</span>
              </div>
              <div class="event-details">
                <div class="event-title">
                  <a href="#EncodeForHTMLAttribute(local.ev.url)#" class="js-event-open" data-event-id="#local.ev.id#">#EncodeForHTML(local.ev.title)#</a>
                </div>
                <div class="event-meta">
                  <cfif !local.ev.isAllDay and Len(local.ev.startTimeDisplay)>
                    <span><i class="fa-regular fa-clock" aria-hidden="true"></i> #EncodeForHTML(local.ev.startTimeDisplay)#</span>
                  </cfif>
                  <cfif Len(local.ev.locationName)>
                    <span><i class="fa-solid fa-location-dot" aria-hidden="true"></i> #EncodeForHTML(local.ev.locationName)#</span>
                  <cfelse>
                    <span><i class="#EncodeForHTMLAttribute(local.ev.categoryIcon)#" aria-hidden="true"></i> #EncodeForHTML(local.ev.categoryName)#</span>
                  </cfif>
                </div>
              </div>
            </li>
          </cfloop>
        <cfelse>
          <li class="event-item border-0 py-4 text-center">
            <div class="event-details">
              <p class="mb-1 fw-semibold">No events scheduled for #EncodeForHTML(local.monthLabel)#.</p>
              <span class="small text-muted">Use the arrows to browse other months or view the full county calendar.</span>
            </div>
          </li>
        </cfif>
      </ul>
    </div>

  </div><!-- /.row -->

  <!-- View Full Calendar Link spanning bottom -->
  <a href="/calendar" class="events-view-all">
    <span>View the full county calendar</span>
    <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
  </a>

  <!-- Embedded CMSAdmin 2.0 Events Payload -->
  <script type="application/json" class="js-calendar-events-data">#Replace(SerializeJSON(local.calEvents), "</", "<\/", "all")#</script>
</aside>

<!-- Accessible Event Details Modal (Shared on Page) -->
<div class="modal fade" id="countyCalendarEventModal" tabindex="-1" aria-labelledby="countyCalendarEventModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content border-0 shadow-lg" style="border-radius:14px; overflow:hidden;">
      <div class="modal-header border-bottom" style="background:linear-gradient(165deg, ##ffffff 0%, ##f4f7fb 100%);">
        <div>
          <div class="d-flex flex-wrap align-items-center gap-2 mb-1">
            <span class="badge rounded-pill js-ev-modal-cat" style="background:##0284c7; color:##fff; font-size:.72rem;">Event</span>
            <span class="badge bg-light text-secondary border js-ev-modal-dept" style="font-size:.72rem;">County-Wide</span>
          </div>
          <h4 class="modal-title h5 fw-bold mb-0" id="countyCalendarEventModalTitle" style="color:##102a43; font-family:'Alegreya', Georgia, serif;">Event Details</h4>
        </div>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close event details"></button>
      </div>
      <div class="modal-body p-4">
        <div class="d-flex flex-column gap-2 mb-3 p-3 rounded-3" style="background:##f8fafc; border:1px solid ##e2e8f0; font-size:.9rem;">
          <div class="d-flex align-items-center gap-2">
            <i class="fa-regular fa-calendar-days text-primary" aria-hidden="true" style="width:18px; text-align:center;"></i>
            <span class="fw-semibold js-ev-modal-date" style="color:##102a43;"></span>
          </div>
          <div class="d-flex align-items-center gap-2 js-ev-modal-time-row">
            <i class="fa-regular fa-clock text-warning" aria-hidden="true" style="width:18px; text-align:center;"></i>
            <span class="js-ev-modal-time" style="color:##334e68;"></span>
          </div>
          <div class="d-flex align-items-start gap-2 js-ev-modal-loc-row">
            <i class="fa-solid fa-location-dot text-danger mt-1" aria-hidden="true" style="width:18px; text-align:center;"></i>
            <span class="js-ev-modal-loc" style="color:##334e68;"></span>
          </div>
        </div>
        <div class="js-ev-modal-desc mb-3" style="color:##2b2e31; font-size:.95rem; line-height:1.6;"></div>
        <div class="js-ev-modal-links d-flex flex-wrap gap-2 mb-2"></div>
        <div class="js-ev-modal-contact small text-muted border-top pt-2 mt-3" style="display:none;"></div>
      </div>
      <div class="modal-footer bg-light border-top d-flex justify-content-between">
        <a href="/calendar/ics" class="btn btn-sm btn-outline-secondary js-ev-modal-ics">
          <i class="fa-regular fa-calendar-plus me-1" aria-hidden="true"></i> Add to Calendar (.ics)
        </a>
        <div class="d-flex gap-2">
          <a href="/calendar" class="btn btn-sm btn-primary js-ev-modal-full">Full Calendar</a>
          <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
  var MONTH_NAMES = ["January","February","March","April","May","June","July","August","September","October","November","December"];
  var MONTH_ABBR  = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

  function pad2(n) { return n < 10 ? "0" + n : "" + n; }
  function escapeHtml(s) {
    return String(s || "")
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&##39;");
  }

  function normEvent(raw) {
    var get = function(k) {
      if (raw[k] !== undefined) return raw[k];
      var u = k.toUpperCase();
      if (raw[u] !== undefined) return raw[u];
      var l = k.toLowerCase();
      return raw[l] !== undefined ? raw[l] : "";
    };
    return {
      id: Number(get("id") || 0),
      title: String(get("title") || ""),
      summary: String(get("summary") || ""),
      description: String(get("description") || ""),
      startDate: String(get("startDate") || ""),
      endDate: String(get("endDate") || get("startDate") || ""),
      startYear: Number(get("startYear") || 0),
      startMonth: Number(get("startMonth") || 0),
      startDay: Number(get("startDay") || 1),
      monthAbbr: String(get("monthAbbr") || ""),
      dateDisplay: String(get("dateDisplay") || ""),
      startTimeDisplay: String(get("startTimeDisplay") || ""),
      timeDisplay: String(get("timeDisplay") || ""),
      isAllDay: Boolean(get("isAllDay") === true || get("isAllDay") === 1 || get("isAllDay") === "true"),
      locationName: String(get("locationName") || ""),
      locationAddress: String(get("locationAddress") || ""),
      roomNumber: String(get("roomNumber") || ""),
      categoryName: String(get("categoryName") || "County Event"),
      categoryColor: String(get("categoryColor") || "##0284c7"),
      categoryIcon: String(get("categoryIcon") || "fa-solid fa-calendar-day"),
      departmentName: String(get("departmentName") || "County-Wide"),
      virtualMeetingUrl: String(get("virtualMeetingUrl") || ""),
      agendaUrl: String(get("agendaUrl") || ""),
      minutesUrl: String(get("minutesUrl") || ""),
      contactName: String(get("contactName") || ""),
      contactEmail: String(get("contactEmail") || ""),
      contactPhone: String(get("contactPhone") || ""),
      icsUrl: String(get("icsUrl") || "/calendar/ics"),
      url: String(get("url") || "/calendar")
    };
  }

  function openEventModal(ev) {
    var modalEl = document.getElementById("countyCalendarEventModal");
    if (!modalEl || typeof bootstrap === "undefined" || !bootstrap.Modal) {
      window.location.href = ev.url || "/calendar";
      return;
    }
    modalEl.querySelector("##countyCalendarEventModalTitle").textContent = ev.title;
    var catEl = modalEl.querySelector(".js-ev-modal-cat");
    catEl.textContent = ev.categoryName;
    catEl.style.backgroundColor = ev.categoryColor || "##0284c7";
    modalEl.querySelector(".js-ev-modal-dept").textContent = ev.departmentName || "County-Wide";
    modalEl.querySelector(".js-ev-modal-date").textContent = ev.dateDisplay || ev.startDate;

    var timeRow = modalEl.querySelector(".js-ev-modal-time-row");
    var timeEl  = modalEl.querySelector(".js-ev-modal-time");
    if (ev.timeDisplay) {
      timeEl.textContent = ev.timeDisplay;
      timeRow.style.display = "flex";
    } else {
      timeRow.style.display = "none";
    }

    var locRow = modalEl.querySelector(".js-ev-modal-loc-row");
    var locEl  = modalEl.querySelector(".js-ev-modal-loc");
    var locParts = [];
    if (ev.locationName) locParts.push(ev.locationName);
    if (ev.roomNumber) locParts.push(ev.roomNumber);
    if (ev.locationAddress && ev.locationAddress !== ev.locationName) locParts.push(ev.locationAddress);
    if (locParts.length) {
      locEl.textContent = locParts.join(" • ");
      locRow.style.display = "flex";
    } else {
      locRow.style.display = "none";
    }

    var descEl = modalEl.querySelector(".js-ev-modal-desc");
    var bodyText = ev.description || ev.summary || "No additional details provided.";
    descEl.innerHTML = escapeHtml(bodyText).replace(/\r?\n/g, "<br>");

    var linksEl = modalEl.querySelector(".js-ev-modal-links");
    var linksHtml = "";
    if (ev.virtualMeetingUrl) {
      linksHtml += '<a href="' + escapeHtml(ev.virtualMeetingUrl) + '" target="_blank" rel="noopener" class="btn btn-sm btn-outline-primary"><i class="fa-solid fa-video me-1"></i>Join Virtual Meeting</a>';
    }
    if (ev.agendaUrl) {
      linksHtml += '<a href="' + escapeHtml(ev.agendaUrl) + '" target="_blank" rel="noopener" class="btn btn-sm btn-outline-dark"><i class="fa-regular fa-file-lines me-1"></i>Agenda / Packet</a>';
    }
    if (ev.minutesUrl) {
      linksHtml += '<a href="' + escapeHtml(ev.minutesUrl) + '" target="_blank" rel="noopener" class="btn btn-sm btn-outline-secondary"><i class="fa-regular fa-clipboard me-1"></i>Minutes</a>';
    }
    linksEl.innerHTML = linksHtml;

    var contactEl = modalEl.querySelector(".js-ev-modal-contact");
    var cParts = [];
    if (ev.contactName) cParts.push("Contact: " + escapeHtml(ev.contactName));
    if (ev.contactPhone) cParts.push(escapeHtml(ev.contactPhone));
    if (ev.contactEmail) cParts.push('<a href="mailto:' + escapeHtml(ev.contactEmail) + '">' + escapeHtml(ev.contactEmail) + '</a>');
    if (cParts.length) {
      contactEl.innerHTML = cParts.join(" &bull; ");
      contactEl.style.display = "block";
    } else {
      contactEl.style.display = "none";
    }

    var icsBtn = modalEl.querySelector(".js-ev-modal-ics");
    if (icsBtn) icsBtn.setAttribute("href", ev.icsUrl || ("/calendar/ics?id=" + ev.id));
    var fullBtn = modalEl.querySelector(".js-ev-modal-full");
    if (fullBtn) fullBtn.setAttribute("href", ev.url || "/calendar");

    bootstrap.Modal.getOrCreateInstance(modalEl).show();
  }

  function initCalendarCard(cardEl) {
    if (cardEl.dataset.calBound === "1") return;
    cardEl.dataset.calBound = "1";

    var dataScript = cardEl.querySelector(".js-calendar-events-data");
    var rawEvents = [];
    if (dataScript) {
      try { rawEvents = JSON.parse(dataScript.textContent || "[]"); } catch (e) { rawEvents = []; }
    }
    var allEvents = rawEvents.map(normEvent);
    var eventsById = {};
    allEvents.forEach(function(ev) { eventsById[ev.id] = ev; });

    window.openCountyCalendarEvent = function(eventId) {
      var ev = eventsById[Number(eventId)];
      if (!ev) return false;
      if (ev.startYear && ev.startMonth) {
        renderMonth(ev.startYear, ev.startMonth, ev.startDate);
      }
      openEventModal(ev);
      return true;
    };

    var curYear = parseInt(cardEl.getAttribute("data-init-year"), 10) || new Date().getFullYear();
    var curMonth = parseInt(cardEl.getAttribute("data-init-month"), 10) || (new Date().getMonth() + 1);
    var selectedDateIso = "";

    var miniCalEl = cardEl.querySelector(".js-mini-cal");
    var monthTextEl = cardEl.querySelector(".js-mini-cal-month-text");
    var daysContainer = cardEl.querySelector(".js-mini-cal-days");
    var eventListEl = cardEl.querySelector(".js-event-list");
    var prevBtn = cardEl.querySelector(".js-cal-prev");
    var nextBtn = cardEl.querySelector(".js-cal-next");
    var todayBtn = cardEl.querySelector(".js-cal-today");

    function renderMonth(year, month, keepSelectedIso) {
      curYear = year;
      curMonth = month;
      var monthName = MONTH_NAMES[month - 1] + " " + year;
      if (monthTextEl) monthTextEl.textContent = monthName;
      if (miniCalEl) miniCalEl.setAttribute("aria-label", monthName + " Calendar");

      var daysInMonth = new Date(year, month, 0).getDate();
      var startDow = new Date(year, month - 1, 1).getDay(); // 0=Sun..6=Sat
      var daysInPrev = new Date(year, month - 1, 0).getDate();

      var monthStartIso = year + "-" + pad2(month) + "-01";
      var monthEndIso   = year + "-" + pad2(month) + "-" + pad2(daysInMonth);

      var monthEvents = [];
      var dayEventsMap = {};
      var firstEventDateIso = "";

      allEvents.forEach(function(ev) {
        if (ev.startDate <= monthEndIso && ev.endDate >= monthStartIso) {
          monthEvents.push(ev);
          for (var d = 1; d <= daysInMonth; d++) {
            var dIso = year + "-" + pad2(month) + "-" + pad2(d);
            if (dIso >= ev.startDate && dIso <= ev.endDate) {
              if (!dayEventsMap[d]) dayEventsMap[d] = [];
              dayEventsMap[d].push(ev);
              if (!firstEventDateIso) firstEventDateIso = dIso;
            }
          }
        }
      });

      selectedDateIso = keepSelectedIso !== undefined ? keepSelectedIso : firstEventDateIso;

      // Build day cells HTML
      var cellsHtml = "";
      for (var p = daysInPrev - startDow + 1; p <= daysInPrev; p++) {
        cellsHtml += '<div class="mini-cal-day muted" aria-disabled="true">' + p + '</div>';
      }
      for (var dayNum = 1; dayNum <= daysInMonth; dayNum++) {
        var dateIso = year + "-" + pad2(month) + "-" + pad2(dayNum);
        var dEvs = dayEventsMap[dayNum] || [];
        var hasEv = dEvs.length > 0;
        var isSel = (selectedDateIso && selectedDateIso === dateIso);
        var cls = "mini-cal-day" + (hasEv ? " has-event" : "") + (isSel ? " selected" : "");
        var titles = dEvs.map(function(e) { return e.title; }).join(" • ");
        var ariaLabel = MONTH_NAMES[month - 1] + " " + dayNum + ", " + year + (titles ? ": " + titles : "");
        cellsHtml += '<div class="' + cls + '" tabindex="0" role="gridcell" aria-selected="' + (isSel ? "true" : "false") + '" data-day="' + dayNum + '" data-date="' + dateIso + '"' + (titles ? ' title="' + escapeHtml(titles) + '"' : '') + ' aria-label="' + escapeHtml(ariaLabel) + '">' + dayNum + '</div>';
      }
      var totalCells = startDow + daysInMonth;
      var remCells = (7 - (totalCells % 7)) % 7;
      for (var n = 1; n <= remCells; n++) {
        cellsHtml += '<div class="mini-cal-day muted" aria-disabled="true">' + n + '</div>';
      }
      if (daysContainer) daysContainer.innerHTML = cellsHtml;

      // Build events list HTML
      if (eventListEl) {
        if (monthEvents.length === 0) {
          eventListEl.innerHTML =
            '<li class="event-item border-0 py-4 text-center">' +
              '<div class="event-details">' +
                '<p class="mb-1 fw-semibold">No events scheduled for ' + escapeHtml(monthName) + '.</p>' +
                '<span class="small opacity-75">Use the arrows to browse other months or view the full county calendar.</span>' +
              '</div>' +
            '</li>';
        } else {
          var listHtml = "";
          monthEvents.forEach(function(ev) {
            var isHighlighted = selectedDateIso && selectedDateIso >= ev.startDate && selectedDateIso <= ev.endDate;
            var dispDay = ev.startDay;
            var dispMon = ev.monthAbbr;
            if (ev.startDate < monthStartIso) {
              dispDay = 1;
              dispMon = MONTH_ABBR[month - 1];
            }
            var metaHtml = "";
            if (!ev.isAllDay && ev.startTimeDisplay) {
              metaHtml += '<span><i class="fa-regular fa-clock" aria-hidden="true"></i> ' + escapeHtml(ev.startTimeDisplay) + '</span>';
            }
            if (ev.locationName) {
              metaHtml += '<span><i class="fa-solid fa-location-dot" aria-hidden="true"></i> ' + escapeHtml(ev.locationName) + '</span>';
            } else {
              metaHtml += '<span><i class="' + escapeHtml(ev.categoryIcon) + '" aria-hidden="true"></i> ' + escapeHtml(ev.categoryName) + '</span>';
            }
            listHtml +=
              '<li class="event-item' + (isHighlighted ? ' highlighted' : '') + '" data-day="' + dispDay + '" data-start="' + escapeHtml(ev.startDate) + '" data-end="' + escapeHtml(ev.endDate) + '" data-event-id="' + ev.id + '">' +
                '<div class="event-badge">' +
                  '<span class="badge-month">' + escapeHtml(dispMon) + '</span>' +
                  '<span class="badge-day">' + dispDay + '</span>' +
                '</div>' +
                '<div class="event-details">' +
                  '<div class="event-title">' +
                    '<a href="' + escapeHtml(ev.url) + '" class="js-event-open" data-event-id="' + ev.id + '">' + escapeHtml(ev.title) + '</a>' +
                  '</div>' +
                  '<div class="event-meta">' + metaHtml + '</div>' +
                '</div>' +
              '</li>';
          });
          eventListEl.innerHTML = listHtml;
        }
      }

      bindDayInteractions();
    }

    function selectDateCell(cellEl) {
      var dateIso = cellEl.getAttribute("data-date");
      if (!dateIso) return;
      var allDayCells = cardEl.querySelectorAll(".mini-cal-day[data-date]");
      var items = cardEl.querySelectorAll(".event-item[data-start]");

      if (selectedDateIso === dateIso && cellEl.classList.contains("selected")) {
        selectedDateIso = "";
        allDayCells.forEach(function(el) {
          el.classList.remove("selected");
          el.setAttribute("aria-selected", "false");
        });
        items.forEach(function(item) { item.classList.remove("highlighted"); });
        return;
      }

      selectedDateIso = dateIso;
      allDayCells.forEach(function(el) {
        var active = el === cellEl;
        el.classList.toggle("selected", active);
        el.setAttribute("aria-selected", active ? "true" : "false");
      });

      var matched = false;
      items.forEach(function(item) {
        var s = item.getAttribute("data-start") || "";
        var e = item.getAttribute("data-end") || s;
        if (dateIso >= s && dateIso <= e) {
          item.classList.add("highlighted");
          if (!matched) {
            item.scrollIntoView({ behavior: "smooth", block: "nearest" });
            matched = true;
          }
        } else {
          item.classList.remove("highlighted");
        }
      });
    }

    function bindDayInteractions() {
      var allDayCells = Array.prototype.slice.call(cardEl.querySelectorAll(".mini-cal-day[data-date]"));
      allDayCells.forEach(function(cell, idx) {
        cell.addEventListener("click", function() {
          selectDateCell(this);
        });
        cell.addEventListener("keydown", function(e) {
          if (e.key === "Enter" || e.key === " ") {
            e.preventDefault();
            selectDateCell(this);
          } else if (e.key === "ArrowRight" && idx + 1 < allDayCells.length) {
            e.preventDefault();
            allDayCells[idx + 1].focus();
          } else if (e.key === "ArrowLeft" && idx - 1 >= 0) {
            e.preventDefault();
            allDayCells[idx - 1].focus();
          } else if (e.key === "ArrowDown" && idx + 7 < allDayCells.length) {
            e.preventDefault();
            allDayCells[idx + 7].focus();
          } else if (e.key === "ArrowUp" && idx - 7 >= 0) {
            e.preventDefault();
            allDayCells[idx - 7].focus();
          }
        });
      });

      cardEl.querySelectorAll(".js-event-open").forEach(function(link) {
        link.addEventListener("click", function(e) {
          var id = Number(this.getAttribute("data-event-id") || 0);
          if (id && eventsById[id]) {
            e.preventDefault();
            openEventModal(eventsById[id]);
          }
        });
      });
    }

    if (prevBtn) {
      prevBtn.addEventListener("click", function() {
        var m = curMonth - 1;
        var y = curYear;
        if (m < 1) { m = 12; y--; }
        renderMonth(y, m);
      });
    }
    if (nextBtn) {
      nextBtn.addEventListener("click", function() {
        var m = curMonth + 1;
        var y = curYear;
        if (m > 12) { m = 1; y++; }
        renderMonth(y, m);
      });
    }
    if (todayBtn) {
      todayBtn.addEventListener("click", function() {
        var now = new Date();
        var todayIso = now.getFullYear() + "-" + pad2(now.getMonth() + 1) + "-" + pad2(now.getDate());
        renderMonth(now.getFullYear(), now.getMonth() + 1, todayIso);
      });
    }

    bindDayInteractions();
  }

  document.querySelectorAll(".subtle-events-card").forEach(initCalendarCard);
});
</script>
</cfoutput>
