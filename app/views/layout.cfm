<!--- ColdFusion Application Layout (app/views/layout.cfm) --->
<!DOCTYPE html>
<cfoutput>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><cfif isDefined("site.name") and len(trim(site.name))>#site.name# &mdash; Chelan County, Washington<cfelse>Chelan County, Washington &mdash; Accessible Portal (Bootstrap, Site-Matched Colors)</cfif></title>
<link rel="icon" href="/images/favicon.ico" type="image/x-icon">

<!-- Facebook / Open Graph -->
<meta property="og:type" content="website">
<meta property="og:site_name" content="Chelan County, Washington">
<meta property="og:locale" content="en_US">
<meta property="og:title" content="<cfif isDefined('site.name') and len(trim(site.name))>#site.name# &mdash; Chelan County, Washington<cfelse>Chelan County, Washington</cfif>">
<meta property="og:description" content="<cfif isDefined('site.name') and len(trim(site.name))>Official #site.name# &mdash; property assessments, parcel lookups, tax relief, and taxpayer services.<cfelse>Official Chelan County, Washington government website &mdash; news, services, elected officials, and county departments.</cfif>">
<meta property="og:url" content="https://ChelanCounty.gov/<cfif isDefined('site.virtualdirectory')>#site.virtualdirectory#</cfif>">
<meta property="og:image" content="https://www.co.chelan.wa.us/images/picjumbo/chelan-county-courthouse.jpg">

<!-- Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Alegreya:wght@700;800&family=Barlow:ital,wght@0,500;0,600;0,700;1,500&family=Public+Sans:ital,wght@0,400;0,500;0,600;0,700;1,400&display=swap" rel="stylesheet">

<!-- Bootstrap 5.3.3 & Font Awesome 6.5.2 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/css/bootstrap.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">

<link href="/stylesheets/jbd-templates.css?v=1.0" media="all" rel="stylesheet" type="text/css">

<!-- YTPlayer CSS -->
<link href="/assets/vendor/jquery.mb.YTPlayer-3.2.10/dist/css/jquery.mb.YTPlayer.min.css" media="all" rel="stylesheet" type="text/css">

<!-- CFWheels Stylesheets -->
#styleSheetLinkTag(source="styles.css", head="true")#
#styleSheetLinkTag(source="custom.css", head="true")#

<!-- jQuery (required before YTPlayer and Bootstrap JS) -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- YTPlayer JS -->
<script type="text/javascript" src="/assets/vendor/jquery.mb.YTPlayer-3.2.10/dist/jquery.mb.YTPlayer.min.js"></script>
</head>
<body<cfif isDefined("site") and isStruct(site) and structKeyExists(site, "color") and len(trim(site.color))><cfset local.bodyPrimary = trim(site.color)><cfset local.bodyDark = structKeyExists(site, "colorDark") and len(trim(site.colorDark)) ? trim(site.colorDark) : local.bodyPrimary><cfset local.bodyGrad = structKeyExists(site, "heroGradient") and len(trim(site.heroGradient)) ? trim(site.heroGradient) : local.bodyPrimary> style="--dept-color: #EncodeForHTMLAttribute(local.bodyPrimary)#; --dept-color-dark: #EncodeForHTMLAttribute(local.bodyDark)#; --dept-gradient: #EncodeForHTMLAttribute(local.bodyGrad)#; --dept-theme-color: #EncodeForHTMLAttribute(local.bodyPrimary)#; --dept-theme-dark: #EncodeForHTMLAttribute(local.bodyDark)#; --dept-theme-gradient: #EncodeForHTMLAttribute(local.bodyGrad)#; --bs-primary: #EncodeForHTMLAttribute(local.bodyPrimary)#; --bs-secondary: #EncodeForHTMLAttribute(local.bodyDark)#; --bs-link-color: #EncodeForHTMLAttribute(local.bodyPrimary)#; --bs-link-hover-color: #EncodeForHTMLAttribute(local.bodyDark)#; --brand-800: #EncodeForHTMLAttribute(local.bodyPrimary)#; --brand-900: #EncodeForHTMLAttribute(local.bodyDark)#; --brand-700: #EncodeForHTMLAttribute(local.bodyPrimary)#; --link-700: #EncodeForHTMLAttribute(local.bodyPrimary)#; --link-600: #EncodeForHTMLAttribute(local.bodyPrimary)#;"</cfif>>

<!-- WCAG 2.4.1 Skip Link -->
<a class="visually-hidden-focusable position-absolute top-0 start-0 p-3" href="##main-content">Skip to main content</a>
</cfoutput>

<!-- Header & Nav ColdFusion Includes -->
<cfinclude template="includes/header.cfm">
<cfinclude template="includes/nav.cfm">

<cfoutput>


<!-- Main Content Landmark -->
<main id="main-content">
  <!-- Separated Hero Section Partial (Inside main-content) -->
  <cfif not isDefined("params.controller") or params.controller eq "Main" or params.controller eq "">
    #includePartial(partial="/shared/_hero.cfm")#
  </cfif>

  <!-- Sitewide Alert Partial -->
 <!---  #includePartial(partial="/shared/_alert.cfm")# --->

  <!-- Application Action Content -->
  #includeContent()#

  <cfif not isDefined("params.controller") or params.controller eq "Main" or params.controller eq "">
    <div class="container my-5">
      <div class="row justify-content-center">
        <div class="col-lg-10">
          #includePartial(partial="/shared/_calendar.cfm")#
        </div>
      </div>
    </div>
  </cfif>
</main>

<!-- Footer ColdFusion Include -->
<cfinclude template="includes/footer.cfm">


<!-- Bootstrap 5.3.3 Bundle JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.3/js/bootstrap.bundle.min.js"></script>
#javaScriptIncludeTag(source="translate.js")#
#javaScriptIncludeTag(source="hero-thought.js")#
<script>
document.addEventListener("DOMContentLoaded", () => {
  const db = document.getElementById("wheels-debugbar");
  if (db) {
    db.setAttribute("role", "region");
    db.setAttribute("aria-label", "Developer debug bar");
  }
});
</script>
</body>
</html>
</cfoutput>
