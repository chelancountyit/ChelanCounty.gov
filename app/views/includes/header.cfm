<!-- ============ Header / search ============ -->
<!-- Utility bar: Careers / Facebook / YouTube on the left, Translate on
     the right (via the same ms-auto flex trick used in nav.html). Careers
     and the social links are placeholders (href="#"), matching every
     other not-yet-wired nav link in this mockup. All-caps styling comes
     from CSS (.utility-bar), not typed-caps text, so screen readers still
     get "Careers at the County" rather than letter-by-letter "C A R E..."
     Translate is an inline dropdown listbox (same dropdown-toggle /
     dropdown-menu pattern as the mega-menus in nav.html), labeled
     "English" for the current language. Its items are populated at
    runtime by javascripts/translate.js from data/languages.json — English,
     Spanish and French pinned at the top as the site's most-requested
     languages, then a divider, then the full A-Z list of the rest —
     rather than 140+ <li>s hand-written here. Each item opens Google
     Translate directly in a new tab. The earlier modal/page versions of
     this (partials/translate-modal.html, translate-main.html,
     translate.html) are left on disk unused (same "keep for easy
     restoration" pattern as home-sidebar.html) rather than deleted. -->
<nav class="utility-bar py-1" aria-label="Utility navigation">
  <div class="container d-flex align-items-center justify-content-between">
    <ul class="list-unstyled d-flex gap-4 mb-0">
      <li><a href="human-resources/jobs"><i class="fa-solid fa-briefcase icon" aria-hidden="true"></i> Careers at the County</a></li>
      <li><a href="https://www.facebook.com/ChelanCounty" target="_blank" rel="noopener noreferrer" aria-label="Facebook (opens in a new tab)"><i class="fa-brands fa-facebook icon" aria-hidden="true"></i> Facebook</a></li>
      <li><a href="https://www.youtube.com/channel/UCuTXhLpKsH4IXCbHM8rgzSA" target="_blank" rel="noopener noreferrer" aria-label="YouTube (opens in a new tab)"><i class="fa-brands fa-youtube icon" aria-hidden="true"></i> YouTube</a></li>
    </ul>
    <ul class="list-unstyled mb-0">
      <li class="dropdown">
        <button type="button" class="utility-bar-btn dropdown-toggle" data-bs-toggle="dropdown" aria-expanded="false" aria-controls="translate-listbox" aria-label="English (current language — choose a different one)">
          <img src="https://flagcdn.com/us.svg" alt="" aria-hidden="true" class="flag-icon" width="20" height="15"> English
          <span class="visually-hidden">(current language &mdash; choose a different one)</span>

        </button>
        <ul class="dropdown-menu dropdown-menu-end translate-listbox" id="translate-listbox" aria-label="Choose a language">
          <!-- Populated by js/translate.js from data/languages.json once
               this partial has been injected (listens for main.js's
               "components:loaded" event) -- the language list is data,
               not markup, so it is not hand-maintained here anymore. -->
        </ul>
      </li>
    </ul>
  </div>
</nav>
<!-- Real county logo, hotlinked from the live site (same pattern used for
     the news thumbnails elsewhere in this build). It's a white/light
     lockup meant for a dark background, so this bar uses the same navy
     as the nav below it rather than the earlier white bar + CSS mark —
     matching how ChelanCounty.gov itself runs utility bar, logo and nav
     as one continuous navy band. -->
<header class="site-header" role="banner">
  <div class="container d-flex flex-wrap align-items-center justify-content-between gap-3 py-3">
    <!-- aria-current="page" here (WCAG 2.4.8 Location): this logo link
         points to the homepage, and this partial is only included on the
         homepage build, so it always IS the current page — unlike the
         Assessor/Commissioners builds, where this same link points home
         but isn't the current page there, so it correctly carries no
         aria-current (see README's "aria-current removed" note, which
         is about nav.html's section links, not this homepage-only
         header.html). -->
    <a class="navbar-brand mb-0" href="#top" aria-current="page">
      <img class="brand-logo" src="https://www.co.chelan.wa.us/images/cc_Logo_white.png" alt="Chelan County, Washington — home">
    </a>

    <!-- aria-label distinguishes this "search" landmark from the hero's
         own <form role="search"> further down the page — two landmarks
         of the same type need distinct accessible names (WCAG 1.3.1 /
         4.1.2), otherwise assistive-tech users navigating by landmark
         see two unlabeled "search" regions with no way to tell them apart. -->
    <form class="d-flex bg-white rounded-pill shadow p-0 site-search" role="search" aria-label="Sitewide search" style="max-width:340px; width:100%;">
      <label class="visually-hidden" for="site-search-input">Search the county website</label>
      <input class="form-control border-0" type="search" id="site-search-input" placeholder="Search ChelanCounty.gov">
      <button class="btn btn-brand" type="submit">
        <i class="fa-solid fa-magnifying-glass icon" aria-hidden="true"></i>
        <span class="visually-hidden">Search</span>
      </button>
    </form>
  </div>
</header>
