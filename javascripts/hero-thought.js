// Fills in the homepage hero's intro sentence (partials/hero.html,
// <p id="hero-thought">) with one randomly-picked historical fact's
// "text" from data/chelan-thoughts.json, once main.js has injected that
// partial. Each entry also carries a source/url, but per request that
// citation isn't rendered on the page -- only the fact text is used.
// The sentence already in the HTML is left as the fallback if the fetch
// fails, so the hero never ends up with empty/missing text.
const loadHeroThought = () => {
  const textEl = document.getElementById("hero-thought");
  if (!textEl) return;

  fetch("data/chelan-thoughts.json")
    .then(res => res.ok ? res.json() : Promise.reject(new Error(`${res.status} ${res.statusText}`)))
    .then(data => {
      const thoughts = Array.isArray(data.thoughts) ? data.thoughts : [];
      if (!thoughts.length) return; // keep the fallback sentence
      const pick = thoughts[Math.floor(Math.random() * thoughts.length)];
      // Entries are {text, source, url} objects; tolerate the older
      // plain-string format too, so this degrades gracefully instead of
      // erroring if it ever runs against an older data file.
      textEl.textContent = typeof pick === "string" ? pick : pick.text;
    })
    .catch(() => {
      // Fetch/parse failed -- leave the fallback sentence already in the
      // markup rather than clearing it or showing an error in its place.
    });
};

document.addEventListener("components:loaded", loadHeroThought);
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", loadHeroThought);
} else {
  loadHeroThought();
}
