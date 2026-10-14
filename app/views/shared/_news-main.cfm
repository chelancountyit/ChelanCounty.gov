<cfoutput >

<!-- ============ Main column: Latest News & Current Events ============ -->
<!-- col-12, not col-lg-8: home-sidebar.html (the third column) is
     removed for now, so this takes the full row width instead of
     leaving empty space beside it. -->
<div class="col-12 news-heading-column" >
  <section aria-labelledby="news-heading">
    <h2 id="news-heading" class="section-title mb-4">Latest News &amp; Current Events</h2>

    <!-- Cards gained col-lg-4 (3-across) here to make use of the width
         freed up by the sidebar removal above — 2-across (col-sm-6 alone)
         would leave each card oddly wide at full container width. -->
    <div class="row g-4 mb-3">
       
      <cfloop query="#news#" >
        <cfif news.imageAttachment NEQ "">
					<cfset image = "https://www.co.chelan.wa.us#news.imageAttachment#">
				<cfelse>
					<cfset image = "/images/default-images/news.jpg">
				</cfif>
        <div class="col-sm-6 col-lg-4">
          <article class="news-card h-100">
            <img class="news-card-img" src="#image#" alt="#news.title#" loading="lazy" onerror="this.remove()">
            <p><a href="/news/article/#news.permalink#"><strong> #news.title# </strong></a></p>
            <p class="mb-0">#news.summary#</p>
          </article>
        </div>
      </cfloop>
      
      

     <div class="col-sm-6 col-lg-4">
        <article class="news-card h-100">
          <!-- Linked video, not decorative — its own YouTube thumbnail
               (id svfam0n0dAM), so this gets real, title-matching alt text
               and a play-button affordance rather than alt="". -->
          <a class="news-card-video" href="https://youtu.be/svfam0n0dAM">
            <img class="news-card-img" src="https://img.youtube.com/vi/svfam0n0dAM/maxresdefault.jpg" alt="Chelan County Connection: watch the latest episode" loading="lazy" onerror="this.remove()">
            
          </a>
          <a href="https://youtu.be/svfam0n0dAM"><strong>Chelan County Connection: watch the latest episode </strong></a>
          <p class="mb-0">Our monthly video update covers county projects, upcoming meetings, and services residents should know about.</p>
        </article>
      </div>


   <!---  <a class="fw-bold" href="/news">See all news &amp; announcements &rarr;</a> --->
   
  </section>

  <hr class="my-5">

  <!--- <section aria-labelledby="sheriff-heading">
    <h2 id="sheriff-heading" class="section-title mb-4">Sheriff&rsquo;s Office Press Releases</h2>
    <div class="table-responsive">
      <table class="table">
        <caption class="visually-hidden">Recent press releases from the Chelan County Sheriff&rsquo;s Office</caption>
        <thead>
          <tr>
            <th scope="col">Date</th>
            <th scope="col">Release</th>
          </tr>
        </thead>
        <tbody>
           <cfloop  query="sheriffnews" >
                   <tr>
                      <td>#Dateformat(sheriffnews.newsstart, 'Mmmm dd, yyyy')#</td>
                      <td><a href="/news/article/#sheriffnews.permalink#">#sheriffnews.title#</a></td>
                    </tr>
           </cfloop>
          
        </tbody>
      </table>
    </div>
  </section> --->
</div>
</cfoutput>