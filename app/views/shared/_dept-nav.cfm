<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/shared/_dept-nav.cfm — Reusable Department Sidebar Navigation Menu --->
<cfparam name="site" default="#getWorkspace('assessor')#">
<cfparam name="nav" default="#[]#">
<cfparam name="arguments.isSubpage" default="false">

<cfset local.isSubpage = isBoolean(arguments.isSubpage) and arguments.isSubpage>
<cfset local.wsCode = (isStruct(site) and StructKeyExists(site, "code") and Len(Trim(site.code))) ? LCase(Trim(site.code)) : "assessor">
<cfset local.wsSlug = ReReplaceNoCase(local.wsCode, "^site-", "")>
<cfif local.wsSlug EQ "assessors">
  <cfset local.wsSlug = "assessor">
</cfif>
<cfset local.wsBasePath = "/" & local.wsSlug>

<cfset local.rawName = (isStruct(site) and StructKeyExists(site, "name") and Len(Trim(site.name))) ? Trim(site.name) : "Assessor">
<cfset local.shortName = ReReplaceNoCase(local.rawName, "^Chelan\s+County\s+", "")>

<cfoutput>
<!-- Department Navigation (Driven by `nav` table) -->
<nav class="dept-nav-card" aria-label="#EncodeForHTMLAttribute(local.shortName)# Department Navigation">
  <p class="dept-nav-header">
    <i class="fa-solid fa-folder me-1" aria-hidden="true"></i> #EncodeForHTML(local.shortName)# Menu
  </p>
  <ul class="dept-nav-list">
    <cfif isArray(nav) and ArrayLen(nav) GT 0>
      <cfloop array="#nav#" index="local.item">
        <cfset local.itemUrl = StructKeyExists(local.item, "url") and Len(Trim(local.item.url)) ? Trim(local.item.url) : "##">
        <cfset local.itemLabel = StructKeyExists(local.item, "label") and Len(Trim(local.item.label)) ? Trim(local.item.label) : (StructKeyExists(local.item, "title") ? Trim(local.item.title) : "")>
        <cfset local.itemIcon = StructKeyExists(local.item, "icon") and isSimpleValue(local.item.icon) ? Trim(local.item.icon) : "">
        <cfset local.hasChildren = StructKeyExists(local.item, "children") and isArray(local.item.children) and ArrayLen(local.item.children) GT 0>
        <cfif local.isSubpage>
          <cfset local.isCurrent = false>
        <cfelse>
          <cfset local.isCurrent = (CompareNoCase(local.itemUrl, local.wsBasePath) EQ 0) or (CompareNoCase(local.itemLabel, "Home") EQ 0 and (not StructKeyExists(params, "slug") or CompareNoCase(params.slug, "home") EQ 0))>
        </cfif>
        <cfif StructKeyExists(params, "slug") and Len(Trim(params.slug)) and Right(local.itemUrl, Len(Trim(params.slug))) EQ Trim(params.slug)>
          <cfset local.isCurrent = true>
        </cfif>

        <cfif local.hasChildren>
          <cfset local.subnavId = "subnav-" & local.item.id>
          <cfset local.childActive = false>
          <cfloop array="#local.item.children#" index="local.childCheck">
            <cfif StructKeyExists(params, "slug") and Len(Trim(params.slug)) and StructKeyExists(local.childCheck, "url") and Right(local.childCheck.url, Len(Trim(params.slug))) EQ Trim(params.slug)>
              <cfset local.childActive = true>
            </cfif>
          </cfloop>
          <li class="dept-nav-item">
            <button class="dept-nav-link dept-nav-toggle<cfif local.isCurrent or local.childActive> active</cfif>"
                    type="button"
                    data-bs-toggle="collapse"
                    data-bs-target="###local.subnavId#"
                    aria-expanded="#local.childActive ? 'true' : 'false'#"
                    aria-controls="#local.subnavId#">
              <span class="d-inline-flex align-items-center">
                <cfif Len(local.itemIcon)>
                  <span class="me-2 text-brand d-inline-flex align-items-center" aria-hidden="true">#svgIcon(name=local.itemIcon, size=16)#</span>
                </cfif>
                #EncodeForHTML(local.itemLabel)#
              </span>
              <i class="fa-solid fa-chevron-down chevron-icon" aria-hidden="true"></i>
            </button>
            <div class="collapse<cfif local.childActive> show</cfif>" id="#local.subnavId#">
              <ul class="dept-subnav">
                <cfloop array="#local.item.children#" index="local.child">
                  <cfset local.childUrl = StructKeyExists(local.child, "url") and Len(Trim(local.child.url)) ? Trim(local.child.url) : "##">
                  <cfset local.childLabel = StructKeyExists(local.child, "label") and Len(Trim(local.child.label)) ? Trim(local.child.label) : (StructKeyExists(local.child, "title") ? Trim(local.child.title) : "")>
                  <cfset local.childNewWin = StructKeyExists(local.child, "newWindow") and isBoolean(local.child.newWindow) and local.child.newWindow>
                  <li>
                    <a href="#EncodeForHTMLAttribute(local.childUrl)#"
                       class="dept-subnav-link"
                       <cfif local.childNewWin>target="_blank" rel="noopener noreferrer"</cfif>>
                      <i class="fa-solid #local.childNewWin ? 'fa-arrow-up-right-from-square' : 'fa-angle-right'# text-brand small" aria-hidden="true"></i>
                      <span>#EncodeForHTML(local.childLabel)#</span>
                      <cfif local.childNewWin><span class="visually-hidden"> (opens in a new tab)</span></cfif>
                    </a>
                  </li>
                </cfloop>
              </ul>
            </div>
          </li>
        <cfelse>
          <cfset local.newWin = StructKeyExists(local.item, "newWindow") and isBoolean(local.item.newWindow) and local.item.newWindow>
          <li class="dept-nav-item">
            <a href="#EncodeForHTMLAttribute(local.itemUrl)#"
               class="dept-nav-link<cfif local.isCurrent> active</cfif>"
               <cfif local.isCurrent>aria-current="page"</cfif>
               <cfif local.newWin>target="_blank" rel="noopener noreferrer"</cfif>>
              <span class="d-inline-flex align-items-center">
                <cfif Len(local.itemIcon)>
                  <span class="me-2 text-brand d-inline-flex align-items-center" aria-hidden="true">#svgIcon(name=local.itemIcon, size=16)#</span>
                </cfif>
                <span>#EncodeForHTML(local.itemLabel)#</span>
                <cfif local.newWin><span class="visually-hidden"> (opens in a new tab)</span></cfif>
              </span>
            </a>
          </li>
        </cfif>
      </cfloop>
    <cfelse>
      <li class="dept-nav-item">
        <a href="#EncodeForHTMLAttribute(local.wsBasePath)#" class="dept-nav-link<cfif not local.isSubpage> active</cfif>"<cfif not local.isSubpage> aria-current="page"</cfif>>
          <span><i class="fa-solid fa-house me-2 text-brand" aria-hidden="true"></i>Home</span>
        </a>
      </li>
    </cfif>
  </ul>
</nav>
</cfoutput>

