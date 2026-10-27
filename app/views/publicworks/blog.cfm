<cfprocessingdirective pageencoding="utf-8">
<!--- app/views/publicworks/blog.cfm - Chelan County Public Works Blog --->
<cfparam name="site" default="#getWorkspace('public-works')#">
<cfparam name="nav" default="#[]#">
<cfparam name="selectedBlog" default="#queryNew('BLOGID,TITLE,PERMALINK,BODY,POSTDATE,IMAGEATTACHMENT,IMAGEATTRIBUTION')#">
<cfparam name="blogPosts" default="#queryNew('BLOGID,TITLE,PERMALINK,BODY,POSTDATE,IMAGEATTACHMENT,IMAGEATTRIBUTION')#">
<cfset content = { Title: "Public Works Blog" }>
<cfoutput>

<!-- Department Hero Banner & Wave Divider -->
#includePartial(partial="/shared/_dept-hero.cfm", isSubpage=true)#

<div class="container py-4">
  #includePartial(partial="/shared/_dept-notifications.cfm")#

  <div class="row g-4 g-lg-5">
    <aside class="col-lg-3 col-md-4" aria-label="Department information and navigation">
      #includePartial(partial="/shared/_dept-nav.cfm", isSubpage=true)#
      #includePartial(partial="/shared/_dept-contact.cfm")#
    </aside>

    <div class="col-lg-9 col-md-8">
      <h1 class="section-title mb-3">Public Works Blog</h1>
      <hr>

      <cfif isQuery(selectedBlog) and selectedBlog.recordCount GT 0>
        <article class="card border-0 shadow-sm rounded-4 mb-5 overflow-hidden">
          <cfif Len(Trim(selectedBlog.IMAGEATTACHMENT ?: ""))>
            <img src="#EncodeForHTMLAttribute(Trim(selectedBlog.IMAGEATTACHMENT))#" alt="#EncodeForHTMLAttribute(Trim(selectedBlog.TITLE))#" class="img-fluid w-100" style="max-height: 400px; object-fit: cover;">
          </cfif>
          <div class="card-body p-4 p-md-5">
            <cfif isDate(selectedBlog.POSTDATE)>
              <div class="text-muted small fw-semibold text-uppercase mb-2">
                <i class="fa-regular fa-calendar me-1" aria-hidden="true"></i>#DateFormat(selectedBlog.POSTDATE, "mmmm d, yyyy")#
              </div>
            </cfif>
            <h2 class="h3 fw-bold mb-3">#EncodeForHTML(Trim(selectedBlog.TITLE))#</h2>
            <div class="cms-page-body">
              #renderCmsContent(Replace(Replace(selectedBlog.BODY ?: "", "https://www.co.chelan.wa.us/files/", "/files/", "all"), "http://www.co.chelan.wa.us/files/", "/files/", "all"))#
            </div>
          </div>
        </article>
      </cfif>

      <cfif isQuery(blogPosts) and blogPosts.recordCount GT 0>
        <h2 class="h4 fw-bold mb-3">More Blog Posts</h2>
        <div class="list-group shadow-sm rounded-4 overflow-hidden">
          <cfloop query="blogPosts">
            <a href="/public-works/blog/#EncodeForHTMLAttribute(Trim(blogPosts.PERMALINK))#" class="list-group-item list-group-item-action p-3 d-flex justify-content-between align-items-center">
              <div>
                <div class="fw-bold">#EncodeForHTML(Trim(blogPosts.TITLE))#</div>
                <cfif isDate(blogPosts.POSTDATE)>
                  <small class="text-muted">#DateFormat(blogPosts.POSTDATE, "mmmm d, yyyy")#</small>
                </cfif>
              </div>
              <i class="fa-solid fa-chevron-right text-muted" aria-hidden="true"></i>
            </a>
          </cfloop>
        </div>
      </cfif>
    </div>
  </div>
</div>

</cfoutput>

