<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-notifications.cfm — Reusable Department Active Notifications Alert --->
<cfparam name="notifications" default="">
<cfoutput>
<cfif isDefined("notifications") and isQuery(notifications) and notifications.recordCount GT 0>
  <div class="alert alert-warning d-flex align-items-start gap-3 shadow-sm mb-4" role="alert">
    <i class="fa-solid fa-triangle-exclamation fs-4 mt-1 text-warning" aria-hidden="true"></i>
    <div>
      <h2 class="h5 alert-heading mb-1">Important Notice</h2>
      <cfloop query="notifications">
        <p class="mb-0">#EncodeForHTML(notifications.title)#: #EncodeForHTML(notifications.message)#</p>
      </cfloop>
    </div>
  </div>
</cfif>
</cfoutput>

