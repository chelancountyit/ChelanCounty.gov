<cfscript>

	// Use this file to add routes to your application and point the root route to a controller action.
	// Don't forget to issue a reload request (e.g. reload=true) after making changes.
	// See https://guides.wheels.dev/v4-2-0/basics/routing/ for more info.

	mapper()
		// CLI-Appends-Here
		.get(name="calendar", pattern="/calendar", to="calendar##index")
		.get(name="calendarIcs", pattern="/calendar/ics", to="calendar##ics")
		.get(name="assessor", pattern="/assessor", to="assessor##index")
		.get(name="assessorPage", pattern="/assessor/page/[slug]", to="assessor##page")
		.get(name="assessorFile", pattern="/assessor/file", to="assessor##file")
		.get(name="auditor", pattern="/auditor", to="auditor##index")
		.get(name="auditorPage", pattern="/auditor/page/[slug]", to="auditor##page")
		.get(name="auditorFile", pattern="/auditor/file", to="auditor##file")
		.get(name="elections", pattern="/elections", to="elections##index")
		.get(name="electionsPage", pattern="/elections/page/[slug]", to="elections##page")
		.get(name="electionsFile", pattern="/elections/file", to="elections##file")
		.get(name="boardOfCommissioners", pattern="/board-of-commissioners", to="boardOfCommissioners##index")
		.get(name="boardOfCommissionersPage", pattern="/board-of-commissioners/page/[slug]", to="boardOfCommissioners##page")
		.get(name="boardOfCommissionersPagesLegacy", pattern="/board-of-commissioners/pages/[slug]", to="boardOfCommissioners##page")
		.get(name="boardOfCommissionersFile", pattern="/board-of-commissioners/file", to="boardOfCommissioners##file")
		.get(name="publicWorks", pattern="/public-works", to="publicWorks##index")
		.get(name="publicWorksPage", pattern="/public-works/page/[slug]", to="publicWorks##page")
		.get(name="publicWorksPagesLegacy", pattern="/public-works/pages/[slug]", to="publicWorks##page")
		.get(name="publicWorksFile", pattern="/public-works/file", to="publicWorks##file")
		.get(name="publicWorksContacts", pattern="/public-works/contacts", to="publicWorks##contacts")
		.get(name="publicWorksHowDoI", pattern="/public-works/howdoi", to="publicWorks##howdoi")
		.get(name="publicWorksBlog", pattern="/public-works/blog", to="publicWorks##blog")
		.get(name="publicWorksBlogPost", pattern="/public-works/blog/[slug]", to="publicWorks##blog")
		.get(name="publicWorksForm", pattern="/public-works/forms/[slug]", to="publicWorks##forms")

		// Liveness / warm-up endpoint. `wheels deploy`'s proxy healthcheck probes
		// `/up` before traffic cutover; a 200 here also compiles the request path
		// so the first real visitor gets warm latency. See app/controllers/Up.cfc.
		.get(name="up", to="up##index")

		// The root route below is the one that will be called on your application's home page.
		.root(to="main##index", method="get")

		// The "wildcard" call below enables automatic mapping of "controller/action" type routes.
		// This way you don't need to explicitly add a route every time you create a new action in a controller.
		// Routes match first to last, so keep it last: add your own routes above it.
		.wildcard()
	.end();
</cfscript>
