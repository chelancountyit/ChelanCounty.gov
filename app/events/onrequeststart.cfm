<cfsilent>
<cfscript>
	// Place code here that should be executed on the "onRequestStart" event.
	if (!StructKeyExists(application, "folderExplorerV4Ready")) {
		try {
			if (StructKeyExists(application, "wo")) {
				application.wo.$include(template = "/app/global/functions.cfm");
			}
			if (StructKeyExists(application, "wheels")) {
				if (StructKeyExists(application.wheels, "controllers")) StructClear(application.wheels.controllers);
				if (StructKeyExists(application.wheels, "integrationPlans")) StructClear(application.wheels.integrationPlans);
			}
			if (StructKeyExists(application, "$wheels")) {
				if (StructKeyExists(application.$wheels, "controllers")) StructClear(application.$wheels.controllers);
				if (StructKeyExists(application.$wheels, "integrationPlans")) StructClear(application.$wheels.integrationPlans);
			}
			application.folderExplorerV4Ready = true;
		} catch (any e) {}
	}
</cfscript>
</cfsilent>