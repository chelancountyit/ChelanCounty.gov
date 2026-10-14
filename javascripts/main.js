// main.js
//
// Tiny component loader: finds every element with a `data-include`
// attribute, fetches the referenced partial from /partials, and swaps
// the placeholder for the fetched markup. This is what lets header.html,
// nav.html, sidebar.html, main-content.html, footer.html, etc. live as
// separate files instead of one long index.html.
//
// IMPORTANT — this uses fetch(), which browsers block against local
// files opened directly (file://) due to CORS. To view this page you
// need to serve the folder over http://, e.g. from a terminal in this
// project folder:
//
//   Python 3:      python -m http.server 8000
//   Node (npx):    npx serve .
//   VS Code:       "Live Server" extension → "Open with Live Server"
//
// then visit http://localhost:<port>/ in the browser.
//
// Bootstrap's own JS (loaded separately via CDN, above this script tag)
// uses event delegation for its dropdowns/collapse, so it works fine
// with content injected after the initial page load — no extra wiring
// needed here for the mega-menu or mobile nav toggle.

document.addEventListener("DOMContentLoaded", () => {
  const placeholders = Array.from(document.querySelectorAll("[data-include]"));

  Promise.all(
    placeholders.map((el) => {
      const path = el.getAttribute("data-include");
      return fetch(path)
        .then((res) => {
          if (!res.ok) throw new Error(`${res.status} ${res.statusText}`);
          return res.text();
        })
        .then((html) => {
          el.outerHTML = html;
        })
        .catch((err) => {
          console.error(`Could not load component "${path}":`, err);
          el.innerHTML =
            `<p style="padding:1rem;color:#900;">` +
            `Could not load this component (${path}). ` +
            `Are you opening the file directly instead of serving it with a local server?` +
            `</p>`;
        });
    })
  ).then(() => {
    // Let the rest of the page know every component has finished loading,
    // in case a future script needs to run only after the full DOM is in place.
    document.dispatchEvent(new CustomEvent("components:loaded"));
  });
});
