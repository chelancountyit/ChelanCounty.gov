<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-cta-cards.cfm — Reusable Quick Services / CTA Cards Section --->
<cfparam name="content" default="">
<cfparam name="ctaCards" default="#getAttachedCtaCards(content)#">
<cfparam name="arguments.isSubpage" default="false">
<cfparam name="arguments.showFallbackCards" default="#!(isBoolean(arguments.isSubpage) and arguments.isSubpage)#">

<cfset local.isSubpage = isBoolean(arguments.isSubpage) and arguments.isSubpage>
<cfset local.showFallbackCards = isBoolean(arguments.showFallbackCards) and arguments.showFallbackCards>
<cfset local.hasDbCards = isQuery(ctaCards) and ctaCards.recordCount GT 0>
<cfset local.bodyHasEmbeddedCta = isObject(content) and StructKeyExists(content, "Body") and REFindNoCase("(jbd-cta-grid|jbd-cta-card|\[cta_grid|\[call_to_action|\[cta\b)", content.Body) GT 0>

<cfif local.bodyHasEmbeddedCta>
  <cfset local.ctaEnabled = false>
<cfelseif local.isSubpage>
  <cfset local.ctaEnabled = isObject(content) and StructKeyExists(content, "hasCtaCards") and isBoolean(content.hasCtaCards) and content.hasCtaCards and (local.hasDbCards or local.showFallbackCards)>
<cfelse>
  <cfset local.ctaEnabled = !(isObject(content) and StructKeyExists(content, "hasCtaCards") and isBoolean(content.hasCtaCards) and !content.hasCtaCards) and (local.hasDbCards or local.showFallbackCards)>
</cfif>

<cfset local.ctaHeading = (isObject(content) and StructKeyExists(content, "ctaSectionTitle") and Len(Trim(content.ctaSectionTitle))) ? Trim(content.ctaSectionTitle) : "Quick Services & Online Tools">

<cfoutput>
<cfif local.ctaEnabled>
  <!-- Quick Services Section (WCAG 2.2 AA Region & List Semantics) -->
  <section class="mb-5" aria-labelledby="ctaSectionHeading">
    <div class="d-flex align-items-center justify-content-between mb-4 flex-wrap gap-2">
      <h2 id="ctaSectionHeading" class="section-title m-0">#EncodeForHTML(local.ctaHeading)#</h2>
    </div>

    <!-- Quick Services Cards (Dynamic Call to Action Cards from dbo.page_CtaCard) -->
    <div class="row row-cols-1 row-cols-sm-2 row-cols-lg-3 g-4" role="list">
      <cfif local.hasDbCards>
        <cfloop query="ctaCards">
          <cfset local.cardNewTab = isBoolean(ctaCards.OpenInNewTab) and ctaCards.OpenInNewTab>
          <cfset local.cardBtnText = Len(Trim(ctaCards.ButtonText ?: "")) ? Trim(ctaCards.ButtonText) : "Learn More">
          <cfset local.rawIcon = LCase(Trim(ctaCards.ButtonIcon ?: ""))>
          <cfif local.rawIcon EQ "external">
            <cfset local.cardBtnIcon = "fa-solid fa-arrow-up-right-from-square">
          <cfelseif local.rawIcon EQ "pdf">
            <cfset local.cardBtnIcon = "fa-solid fa-file-pdf text-danger">
          <cfelseif local.rawIcon EQ "none">
            <cfset local.cardBtnIcon = "">
          <cfelseif local.rawIcon EQ "arrow" OR NOT Len(local.rawIcon)>
            <cfset local.cardBtnIcon = local.cardNewTab ? "fa-solid fa-arrow-up-right-from-square" : "fa-solid fa-arrow-right">
          <cfelse>
            <cfset local.cardBtnIcon = Trim(ctaCards.ButtonIcon)>
            <cfif NOT REFindNoCase("\bfa-(solid|regular|brands|light|thin|duotone)\b", local.cardBtnIcon)>
              <cfset local.cardBtnIcon = "fa-solid " & local.cardBtnIcon>
            </cfif>
          </cfif>
          <div class="col" role="listitem">
            <a href="#EncodeForHTMLAttribute(Trim(ctaCards.DestinationUrl))#"<cfif local.cardNewTab> target="_blank" rel="noopener noreferrer"</cfif> class="action-card">
              <cfif Len(Trim(ctaCards.ImagePath ?: ""))>
                <div class="action-card-img-wrapper">
                  <img src="#EncodeForHTMLAttribute(Trim(ctaCards.ImagePath))#" alt="#EncodeForHTMLAttribute(Trim(ctaCards.ImageAlt ?: ''))#" class="action-card-img">
                </div>
              </cfif>
              <div class="action-card-body">
                <h3 class="action-card-title">#EncodeForHTML(Trim(ctaCards.Title))#</h3>
                <cfif Len(Trim(ctaCards.ShortDescription ?: ""))>
                  <p class="action-card-text">
                    #EncodeForHTML(Trim(ctaCards.ShortDescription))#
                  </p>
                </cfif>
                <span class="action-card-btn">
                  <span>#EncodeForHTML(local.cardBtnText)#</span>
                  <cfif local.cardNewTab><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                  <cfif Len(local.cardBtnIcon)><i class="#EncodeForHTMLAttribute(local.cardBtnIcon)#" aria-hidden="true"></i></cfif>
                </span>
              </div>
            </a>
          </div>
        </cfloop>
      <cfelseif local.showFallbackCards>
        <!-- Fallback Default Cards -->
        <div class="col" role="listitem">
          <a href="/assessor/page/parcel-and-sale-search" class="action-card">
            <div class="action-card-img-wrapper">
              <img src="/images/picjumbo/parcel16x9.jpg" alt="" class="action-card-img">
            </div>
            <div class="action-card-body">
              <h3 class="action-card-title">Parcel &amp; Sale Search</h3>
              <p class="action-card-text">
                Look up property details, assessed valuations, tax history, and verified market sales.
              </p>
              <span class="action-card-btn">
                <span>Search Parcels</span> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
              </span>
            </div>
          </a>
        </div>
        <div class="col" role="listitem">
          <a href="https://maps.chelancounty.gov/GIS/" target="_blank" rel="noopener noreferrer" class="action-card">
            <div class="action-card-img-wrapper">
              <img src="/images/picjumbo/mapping.jpg" alt="" class="action-card-img">
            </div>
            <div class="action-card-body">
              <h3 class="action-card-title">Interactive GIS Map</h3>
              <p class="action-card-text">
                Explore county parcel boundaries, aerial photography, tax code areas, and zoning layers.
              </p>
              <span class="action-card-btn">
                <span>Open Map</span><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i>
              </span>
            </div>
          </a>
        </div>
        <div class="col" role="listitem">
          <a href="/files/assessor/documents/propertyownerguide.pdf" target="_blank" rel="noopener noreferrer" class="action-card">
            <div class="action-card-img-wrapper">
              <img src="/images/picjumbo/propownguideimage.jpg" alt="" class="action-card-img">
            </div>
            <div class="action-card-body">
              <h3 class="action-card-title">Property Owner's Guide</h3>
              <p class="action-card-text">
                Comprehensive reference covering assessments, market valuation cycles, and rights.
              </p>
              <span class="action-card-btn">
                <span>Download PDF</span><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-file-pdf text-danger" aria-hidden="true"></i>
              </span>
            </div>
          </a>
        </div>
        <div class="col" role="listitem">
          <a href="/assessor/page/destroyed-property-exemptions" class="action-card">
            <div class="action-card-img-wrapper">
              <img src="/images/picjumbo/fire-house.jpg" alt="" class="action-card-img">
            </div>
            <div class="action-card-body">
              <h3 class="action-card-title">Destroyed Property</h3>
              <p class="action-card-text">
                File for property valuation adjustment and tax relief due to disaster, calamity, or fire damage.
              </p>
              <span class="action-card-btn">
                <span>View Relief Forms</span> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
              </span>
            </div>
          </a>
        </div>
        <div class="col" role="listitem">
          <a href="/assessor/page/appeals" class="action-card">
            <div class="action-card-img-wrapper">
              <img src="/images/picjumbo/property-claim.jpg" alt="" class="action-card-img">
            </div>
            <div class="action-card-body">
              <h3 class="action-card-title">Assessment Appeals</h3>
              <p class="action-card-text">
                Learn how to file a petition with the Chelan County Board of Equalization if you dispute your valuation.
              </p>
              <span class="action-card-btn">
                <span>Appeal Instructions</span> <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
              </span>
            </div>
          </a>
        </div>
        <div class="col" role="listitem">
          <a href="https://acclaim.co.chelan.wa.us/acclaimweb" target="_blank" rel="noopener noreferrer" class="action-card">
            <div class="action-card-img-wrapper">
              <img src="/images/picjumbo/liberty16x9.jpg" alt="" class="action-card-img">
            </div>
            <div class="action-card-body">
              <h3 class="action-card-title">Document Search</h3>
              <p class="action-card-text">
                Access official recorded deeds, land surveys, plats, and legal public records via AcclaimWeb.
              </p>
              <span class="action-card-btn">
                <span>Search Records</span><span class="visually-hidden"> (opens in a new tab)</span> <i class="fa-solid fa-arrow-up-right-from-square" aria-hidden="true"></i>
              </span>
            </div>
          </a>
        </div>
      </cfif>
    </div>
  </section>
</cfif>
</cfoutput>

