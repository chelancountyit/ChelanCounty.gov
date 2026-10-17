<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-notice-bar.cfm — Reusable Important Dates / Callout Notice Bar --->
<cfparam name="arguments.noticeIcon" default="fa-regular fa-calendar-check">
<cfparam name="arguments.noticeTitle" default="Important Assessment Dates & Deadlines">
<cfparam name="arguments.noticeText" default="Personal property filings are due April 30. Board of Equalization valuation appeals must be submitted by July 1 (or within 30 days of notice).">
<cfparam name="arguments.noticeUrl" default="/assessor/page/assessments##important-assessment-dates">
<cfparam name="arguments.noticeButtonText" default="View All Dates">
<cfoutput>
<!-- Important Assessment Dates Callout -->
<div class="notice-bar d-flex flex-column flex-md-row align-items-start align-items-md-center justify-content-between gap-3">
  <div>
    <h3 class="h5 fw-bold text-brand mb-1"><i class="#EncodeForHTMLAttribute(arguments.noticeIcon)# me-2" aria-hidden="true"></i>#EncodeForHTML(arguments.noticeTitle)#</h3>
    <p class="mb-0 small text-muted">
      #EncodeForHTML(arguments.noticeText)#
    </p>
  </div>
  <cfif Len(Trim(arguments.noticeUrl))>
    <a href="#EncodeForHTMLAttribute(arguments.noticeUrl)#" class="btn btn-outline-dark btn-sm text-nowrap fw-semibold">
      #EncodeForHTML(arguments.noticeButtonText)# &rarr;
    </a>
  </cfif>
</div>
</cfoutput>

