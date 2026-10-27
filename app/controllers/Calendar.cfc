component extends="Controller" {

	function index() {
		categories = getCalendarCategories();
		events = getCalendarEvents(includeAllWorkspaces = true);
		selectedEventId = StructKeyExists(params, "event") ? Val(params.event) : 0;
		selectedCategory = StructKeyExists(params, "category") ? Trim(params.category) : "";
	}

	function ics() {
		local.eventId = StructKeyExists(params, "id") ? Val(params.id) : 0;
		local.allEvents = getCalendarEvents(includeAllWorkspaces = true);
		local.exportList = [];

		for (local.ev in local.allEvents) {
			if (local.eventId > 0) {
				if (local.ev.id == local.eventId) {
					ArrayAppend(local.exportList, local.ev);
					break;
				}
			} else {
				ArrayAppend(local.exportList, local.ev);
			}
		}

		local.crlf = Chr(13) & Chr(10);
		local.lines = [
			"BEGIN:VCALENDAR",
			"VERSION:2.0",
			"PRODID:-//Chelan County WA//CMSAdmin 2.0 County Calendar//EN",
			"CALSCALE:GREGORIAN",
			"METHOD:PUBLISH",
			"X-WR-CALNAME:Chelan County Calendar of Events",
			"X-WR-TIMEZONE:America/Los_Angeles"
		];

		local.dtStamp = DateFormat(Now(), "yyyymmdd") & "T" & TimeFormat(Now(), "HHmmss") & "Z";

		for (local.ev in local.exportList) {
			local.sDateClean = Replace(local.ev.startDate, "-", "", "all");
			local.eDateClean = Replace(local.ev.endDate, "-", "", "all");
			ArrayAppend(local.lines, "BEGIN:VEVENT");
			ArrayAppend(local.lines, "UID:chelan-county-event-" & local.ev.id & "@chelancounty.gov");
			ArrayAppend(local.lines, "DTSTAMP:" & local.dtStamp);
			if (local.ev.isAllDay || !Len(local.ev.startTime)) {
				ArrayAppend(local.lines, "DTSTART;VALUE=DATE:" & local.sDateClean);
				local.nextDay = DateAdd("d", 1, ParseDateTime(local.ev.endDate));
				ArrayAppend(local.lines, "DTEND;VALUE=DATE:" & DateFormat(local.nextDay, "yyyymmdd"));
			} else {
				local.stParts = Replace(local.ev.startTime, ":", "", "all");
				local.etParts = Len(local.ev.endTime) ? Replace(local.ev.endTime, ":", "", "all") : local.stParts;
				ArrayAppend(local.lines, "DTSTART:" & local.sDateClean & "T" & Left(local.stParts & "000000", 6));
				ArrayAppend(local.lines, "DTEND:" & local.eDateClean & "T" & Left(local.etParts & "000000", 6));
			}
			ArrayAppend(local.lines, "SUMMARY:" & escapeIcsText(local.ev.title));
			local.locStr = local.ev.locationName;
			if (Len(local.ev.roomNumber)) local.locStr &= " (" & local.ev.roomNumber & ")";
			if (Len(local.ev.locationAddress) && local.ev.locationAddress != local.ev.locationName) {
				local.locStr &= (Len(local.locStr) ? ", " : "") & local.ev.locationAddress;
			}
			if (Len(local.locStr)) {
				ArrayAppend(local.lines, "LOCATION:" & escapeIcsText(local.locStr));
			}
			local.descParts = [];
			if (Len(local.ev.summary)) {
				ArrayAppend(local.descParts, escapeIcsText(local.ev.summary));
			}
			if (Len(local.ev.description)) {
				ArrayAppend(local.descParts, escapeIcsText(REReplace(local.ev.description, "<[^>]+>", "", "all")));
			}
			if (Len(local.ev.virtualMeetingUrl)) {
				ArrayAppend(local.descParts, "Virtual Meeting: " & escapeIcsText(local.ev.virtualMeetingUrl));
			}
			if (Len(local.ev.agendaUrl)) {
				ArrayAppend(local.descParts, "Agenda / Packet: " & escapeIcsText(local.ev.agendaUrl));
			}
			if (ArrayLen(local.descParts)) {
				ArrayAppend(local.lines, "DESCRIPTION:" & ArrayToList(local.descParts, "\n\n"));
			}
			ArrayAppend(local.lines, "CATEGORIES:" & escapeIcsText(local.ev.categoryName));
			ArrayAppend(local.lines, "END:VEVENT");
		}

		ArrayAppend(local.lines, "END:VCALENDAR");
		local.fileName = (local.eventId > 0 && ArrayLen(local.exportList) == 1 && Len(local.exportList[1].slug))
			? (local.exportList[1].slug & ".ics")
			: "chelan-county-calendar.ics";

		cfheader(name="Content-Type", value="text/calendar; charset=utf-8");
		cfheader(name="Content-Disposition", value='attachment; filename="#local.fileName#"');
		renderText(text=ArrayToList(local.lines, local.crlf), layout=false);
	}

	private string function escapeIcsText(required string val) {
		local.s = Replace(arguments.val, "\", "\\", "all");
		local.s = Replace(local.s, ";", "\;", "all");
		local.s = Replace(local.s, ",", "\,", "all");
		local.s = REReplace(local.s, "\r?\n", "\n", "all");
		return local.s;
	}

}
