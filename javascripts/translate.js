// javascripts/translate.js
//
// Builds the "English" utility-bar dropdown's language list from
// data/languages.json instead of hardcoding 140+ <li> elements.
// Works seamlessly on both dynamic client partial injection ("components:loaded")
// and native server-rendered ColdFusion templates (DOMContentLoaded).

(function () {
  let isLoaded = false;

  function initTranslate() {
    const listEl = document.getElementById("translate-listbox");
    if (!listEl || isLoaded) return;

    const tryFetch = (primary, fallback) => {
      return fetch(primary)
        .then((res) => {
          if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
          return res;
        })
        .catch((err) => {
          if (fallback) {
            return fetch(fallback).then((res) => {
              if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
              return res;
            });
          }
          throw err;
        });
    };

    tryFetch("/data/languages.json", "data/languages.json")
      .then((res) => res.json())
      .then((data) => {
        isLoaded = true;
        const targetUrl = data.targetUrl || window.location.href;
        const linkFor = (code) =>
          `https://translate.google.com/translate?sl=auto&tl=${encodeURIComponent(code)}&u=${encodeURIComponent(targetUrl)}`;

        const itemHtml = ({ code, label }) => `
        <li>
          <a class="dropdown-item" href="${linkFor(code)}" target="_blank" rel="noopener noreferrer" aria-label="${label} (opens in a new tab)">${label}</a>
        </li>`;

        const pinnedHtml = (data.pinned || []).map(itemHtml).join("");
        const dividerHtml = `<li><hr class="dropdown-divider"></li>`;
        const restHtml = (data.all || []).map(itemHtml).join("");

        listEl.innerHTML = pinnedHtml + dividerHtml + restHtml;
      })
      .catch((err) => {
        console.error("Could not load languages.json:", err);
        listEl.innerHTML =
          `<li><span class="dropdown-item-text text-muted">Language list unavailable</span></li>`;
      });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initTranslate);
  } else {
    initTranslate();
  }

  document.addEventListener("components:loaded", initTranslate);
})();

