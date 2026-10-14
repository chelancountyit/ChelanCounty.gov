<!--- views/shared/_hero.cfm — Seasonal YouTube background hero --->

<!--- Youtube BG section --->
<section id="home" class="home-section" style="background-image: url(/images/video-landing.jpg); width: 100%; position: relative;">

	<cfoutput>
	<cfswitch expression="#month(now())#">
		<cfcase value="12,1,2">
			<!--- Winter --->
			<div id="video-player" data-property="{videoURL:'https://www.youtube.com/watch?v=WOa3dXlJSfU', mobileFallbackImage:'/images/video-landing.jpg', containment:'.home-section', mute:true, autoPlay:true, ratio:'16/9', loop:true, opacity:1, showControls:false, startAt:5, stopMovieOnBlur:false, showYTLogo:false}"></div>
		</cfcase>
		<cfcase value="3,4,5">
			<!--- Spring --->
			<div id="video-player" data-property="{videoURL:'https://www.youtube.com/watch?v=WOa3dXlJSfU', mobileFallbackImage:'/images/video-landing.jpg', containment:'.home-section', mute:true, autoPlay:true, ratio:'16/9', loop:true, opacity:1, showControls:false, startAt:5, stopMovieOnBlur:false, showYTLogo:false}"></div>
		</cfcase>
		<cfcase value="6,7,8">
			<!--- Summer --->
			<div id="video-player" data-property="{videoURL:'https://www.youtube.com/watch?v=6-oNCd8S6I8', mobileFallbackImage:'/images/video-landing.jpg', containment:'.home-section', mute:true, autoPlay:true, ratio:'16/9', loop:true, opacity:1, showControls:false, startAt:5, stopMovieOnBlur:false, showYTLogo:false}"></div>
		</cfcase>
		<cfdefaultcase>
			<!--- Fall (Sept, Oct, Nov) --->
			<div id="video-player" data-property="{videoURL:'https://www.youtube.com/watch?v=MIBf6NwDFgo', mobileFallbackImage:'/images/video-landing.jpg', containment:'.home-section', mute:true, autoPlay:true, ratio:'16/9', loop:true, opacity:1, showControls:false, startAt:5, stopMovieOnBlur:false, showYTLogo:false}"></div>
		</cfdefaultcase>
	</cfswitch>
	</cfoutput>

	<!--- Hero content overlay (sits above the video via z-index) --->
	<div class="hero-brand" style="position: relative; z-index: 2;">
		<div class="container">
			<div class="row align-items-center g-4">
				<div class="col-12">
					<h1 class="display-6 mb-2">Chelan County Government</h1>
					<div class="hero-video-audio-note">
						<span><i class="fa-solid fa-volume-xmark icon" aria-hidden="true"></i> Background has no audio</span>
						<label class="hero-motion-option" for="hero-reduced-motion"><input type="checkbox" id="hero-reduced-motion"> <span>Prefer reduced motion</span></label>
					</div>
					<p class="hero-fact-label mb-1"><i class="fa-solid fa-lightbulb icon" aria-hidden="true"></i> Did you know?</p>
					<p class="fs-5 mb-0" id="hero-thought">Serving the residents of Chelan County, Washington — property records, public safety, courts, roads, and the services that keep our communities running.</p>
				</div>
				<div class="col-12">
					<p class="hero-search-label mb-2" id="hero-search-label">What are you looking for?</p>
					<form class="d-flex bg-white rounded-pill shadow p-0 hero-search w-100" role="search" aria-labelledby="hero-search-label">
						<label class="visually-hidden" for="hero-search-input">Search ChelanCounty.gov</label>
						<input class="form-control form-control-lg border-0" type="search" id="hero-search-input" placeholder="Search services, departments, records&hellip;">
						<button class="btn btn-brand btn-lg" type="submit">
							<i class="fa-solid fa-magnifying-glass icon" aria-hidden="true"></i>
							<span class="visually-hidden">Search</span>
						</button>
					</form>

					<ul class="list-unstyled d-flex flex-wrap gap-2 mt-3 mb-0" aria-label="Quick links">
						<li><a class="hero-chip" href="#">Pay property taxes</a></li>
						<li><a class="hero-chip" href="#">Look up a parcel</a></li>
						<li><a class="hero-chip" href="#">Apply for a job</a></li>
						<li><a class="hero-chip" href="#">Request public records</a></li>
						<li><a class="hero-chip" href="#">Renew a vehicle or boat tab</a></li>
						<li><a class="hero-chip" href="#">Jail roster</a></li>
						<li><a class="hero-chip" href="#">View election results</a></li>
						<li><a class="hero-chip" href="#">Report a problem</a></li>
					</ul>
				</div>
			</div>
		</div>
	</div>

<script>
(() => {
	const toggle = document.getElementById("hero-reduced-motion");
	const hero = document.querySelector(".hero-brand");
	if (!toggle || !hero) return;
	const apply = () => {
		hero.classList.toggle("hero-reduced-motion", toggle.checked);
		const wrapper = document.querySelector(".mbYTP_wrapper");
		const player = window.jQuery && window.jQuery("#video-player");
		if (wrapper) {
			wrapper.classList.toggle("hero-fallback-active", toggle.checked);
			wrapper.style.backgroundImage = toggle.checked ? "url('/images/video-landing.jpg')" : "";
		}
		if (player && player.length && typeof player.YTPPause === "function") {
			player[toggle.checked ? "YTPPause" : "YTPPlay"]();
		}
	};
	const savedPreference = document.cookie.match(/(?:^|; )chelanReducedMotion=([^;]*)/);
	toggle.checked = savedPreference ? savedPreference[1] === "true" : false;
	const player = window.jQuery && window.jQuery("#video-player");
	if (player && player.length) player.on("YTPReady.heroMotion", apply);
	toggle.addEventListener("change", () => {
		document.cookie = `chelanReducedMotion=${toggle.checked}; max-age=31536000; path=/; SameSite=Lax`;
		apply();
	});
	apply();
})();
</script>

</section>

<!-- Wave divider -->
<div class="hero-wave-divider" aria-hidden="true"></div>

<!--- Initialize YTPlayer after section is in the DOM --->
<script>
$(function(){
	$("#video-player").YTPlayer();
});
</script>
