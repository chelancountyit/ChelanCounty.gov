<cfscript>
// Place helper functions here that should be available for use in all view pages of your application.

/**
 * Returns inline SVG markup for crisp, lightweight icons shared with CMSAdmin 2.0.
 * @name Name of the icon (home, government, office, map, signpost, dollar-sign, etc.)
 * @class Optional CSS classes
 * @size Width and height in pixels (default: 18)
 */
public string function svgIcon(required string name, string class = "", numeric size = 18) {
	var s = arguments.size;
	var cls = Len(arguments.class) ? " class=""#arguments.class#""" : "";
	var baseAttrs = "width=""#s#"" height=""#s#"" viewBox=""0 0 24 24"" fill=""none"" stroke=""currentColor"" stroke-width=""2"" stroke-linecap=""round"" stroke-linejoin=""round""#cls#";

	switch (LCase(arguments.name)) {
		case "dashboard":
			return '<svg #baseAttrs#><rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/></svg>';
		case "article":
		case "file-text":
			return '<svg #baseAttrs#><path d="M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z"/><path d="M14 2v4a2 2 0 0 0 2 2h4"/><path d="M10 9H8"/><path d="M16 13H8"/><path d="M16 17H8"/></svg>';
		case "book":
		case "docs":
		case "documentation":
			return '<svg #baseAttrs#><path d="M4 19.5v-15A2.5 2.5 0 0 1 6.5 2H20v20H6.5a2.5 2.5 0 0 1 0-5H20"/><path d="M6 6h10"/><path d="M6 10h10"/></svg>';
		case "pages":
		case "copy":
			return '<svg #baseAttrs#><rect width="14" height="14" x="8" y="8" rx="2" ry="2"/><path d="M4 16c-1.1 0-2-.9-2-2V4c0-1.1.9-2 2-2h10c1.1 0 2 .9 2 2"/></svg>';
		case "media":
		case "image":
			return '<svg #baseAttrs#><rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/></svg>';
		case "folder":
		case "categories":
			return '<svg #baseAttrs#><path d="M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z"/></svg>';
		case "tag":
		case "tags":
			return '<svg #baseAttrs#><path d="M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z"/><circle cx="7.5" cy="7.5" r=".5" fill="currentColor"/></svg>';
		case "users":
		case "user":
			return '<svg #baseAttrs#><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>';
		case "settings":
			return '<svg #baseAttrs#><path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle cx="12" cy="12" r="3"/></svg>';
		case "bell":
			return '<svg #baseAttrs#><path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/></svg>';
		case "briefcase":
		case "hrm":
			return '<svg #baseAttrs#><rect width="20" height="14" x="2" y="7" rx="2" ry="2"/><path d="M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"/></svg>';
		case "megaphone":
		case "bullhorn":
		case "pio":
			return '<svg #baseAttrs#><path d="m3 11 18-5v12L3 14v-3z"/><path d="M11.6 16.8a3 3 0 1 1-5.8-1.6"/></svg>';
		case "search":
			return '<svg #baseAttrs#><circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/></svg>';
		case "menu":
			return '<svg #baseAttrs#><line x1="4" x2="20" y1="12" y2="12"/><line x1="4" x2="20" y1="6" y2="6"/><line x1="4" x2="20" y1="18" y2="18"/></svg>';
		case "chevron-down":
			return '<svg #baseAttrs#><path d="m6 9 6 6 6-6"/></svg>';
		case "chevron-right":
			return '<svg #baseAttrs#><path d="m9 18 6-6-6-6"/></svg>';
		case "chevron-left":
			return '<svg #baseAttrs#><path d="m15 18-6-6 6-6"/></svg>';
		case "arrow-left":
			return '<svg #baseAttrs#><line x1="19" x2="5" y1="12" y2="12"/><polyline points="12 19 5 12 12 5"/></svg>';
		case "arrow-right":
			return '<svg #baseAttrs#><line x1="5" x2="19" y1="12" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>';
		case "chevron-up":
			return '<svg #baseAttrs#><path d="m18 15-6-6-6 6"/></svg>';
		case "plus":
			return '<svg #baseAttrs#><path d="M5 12h14"/><path d="M12 5v14"/></svg>';
		case "maximize":
			return '<svg #baseAttrs#><path d="M8 3H5a2 2 0 0 0-2 2v3"/><path d="M21 8V5a2 2 0 0 0-2-2h-3"/><path d="M3 16v3a2 2 0 0 0 2 2h3"/><path d="M16 21h3a2 2 0 0 0 2-2v-3"/></svg>';
		case "check-circle":
			return '<svg #baseAttrs#><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/><polyline points="22 4 12 14.01 9 11.01"/></svg>';
		case "clock":
			return '<svg #baseAttrs#><circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/></svg>';
		case "eye":
			return '<svg #baseAttrs#><path d="M2 12s3-7 10-7 10 7 10 7-3 7-10 7-10-7-10-7Z"/><circle cx="12" cy="12" r="3"/></svg>';
		case "edit":
			return '<svg #baseAttrs#><path d="M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z"/><path d="m15 5 4 4"/></svg>';
		case "trash":
			return '<svg #baseAttrs#><path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/><line x1="10" x2="10" y1="11" y2="17"/><line x1="14" x2="14" y1="11" y2="17"/></svg>';
		case "log-out":
			return '<svg #baseAttrs#><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/></svg>';
		case "external-link":
			return '<svg #baseAttrs#><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>';
		case "trending-up":
			return '<svg #baseAttrs#><polyline points="22 7 13.5 15.5 8.5 10.5 2 17"/><polyline points="16 7 22 7 22 13"/></svg>';
		case "activity":
			return '<svg #baseAttrs#><path d="M22 12h-4l-3 9L9 3l-3 9H2"/></svg>';
		case "filter":
			return '<svg #baseAttrs#><polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/></svg>';
		case "hard-drive":
			return '<svg #baseAttrs#><line x1="22" x2="2" y1="12" y2="12"/><path d="M5.45 5.11 2 12v6a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-6l-3.45-6.89A2 2 0 0 0 16.76 4H7.24a2 2 0 0 0-1.79 1.11z"/><line x1="6" x2="6.01" y1="16" y2="16"/><line x1="10" x2="10.01" y1="16" y2="16"/></svg>';
		case "form":
		case "form-builder":
		case "clipboard-list":
			return '<svg #baseAttrs#><rect width="8" height="4" x="8" y="2" rx="1" ry="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><path d="M12 11h4"/><path d="M12 16h4"/><path d="M8 11h.01"/><path d="M8 16h.01"/></svg>';
		case "mail":
		case "email":
			return '<svg #baseAttrs#><rect width="20" height="16" x="2" y="4" rx="2"/><path d="m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7"/></svg>';
		case "phone":
			return '<svg #baseAttrs#><path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/></svg>';
		case "calendar":
		case "date":
			return '<svg #baseAttrs#><rect width="18" height="18" x="3" y="4" rx="2" ry="2"/><line x1="16" x2="16" y1="2" y2="6"/><line x1="8" x2="8" y1="2" y2="6"/><line x1="3" x2="21" y1="10" y2="10"/></svg>';
		case "upload-cloud":
		case "upload":
		case "file-upload":
			return '<svg #baseAttrs#><path d="M4 14.899A7 7 0 1 1 15.71 8h1.79a4.5 4.5 0 0 1 2.5 8.242"/><path d="M12 12v9"/><path d="m16 16-4-4-4 4"/></svg>';
		case "star":
		case "rating":
			return '<svg #baseAttrs#><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"/></svg>';
		case "map-pin":
		case "address":
			return '<svg #baseAttrs#><path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/></svg>';
		case "code":
		case "embed":
			return '<svg #baseAttrs#><polyline points="16 18 22 12 16 6"/><polyline points="8 6 2 12 8 18"/></svg>';
		case "monitor":
		case "desktop":
			return '<svg #baseAttrs#><rect width="20" height="14" x="2" y="3" rx="2"/><line x1="8" x2="16" y1="21" y2="21"/><line x1="12" x2="12" y1="17" y2="21"/></svg>';
		case "download":
		case "export":
			return '<svg #baseAttrs#><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/></svg>';
		case "check":
			return '<svg #baseAttrs#><polyline points="20 6 9 17 4 12"/></svg>';
		case "help-circle":
			return '<svg #baseAttrs#><circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" x2="12.01" y1="17" y2="17"/></svg>';
		case "layers":
			return '<svg #baseAttrs#><polygon points="12 2 2 7 12 12 22 7 12 2"/><polyline points="2 17 12 22 22 17"/><polyline points="2 12 12 17 22 12"/></svg>';
		case "link":
			return '<svg #baseAttrs#><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>';
		case "shield":
		case "security":
			return '<svg #baseAttrs#><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>';
		case "lock":
			return '<svg #baseAttrs#><rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>';
		case "building":
		case "department":
			return '<svg #baseAttrs#><rect width="16" height="20" x="4" y="2" rx="2" ry="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M12 6h.01"/><path d="M12 10h.01"/><path d="M12 14h.01"/><path d="M16 10h.01"/><path d="M16 14h.01"/><path d="M8 10h.01"/><path d="M8 14h.01"/></svg>';
		case "globe":
		case "site":
			return '<svg #baseAttrs#><circle cx="12" cy="12" r="10"/><path d="M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20"/><path d="M2 12h20"/></svg>';
		case "grid":
		case "workspace":
			return '<svg #baseAttrs#><rect width="7" height="7" x="3" y="3" rx="1"/><rect width="7" height="7" x="14" y="3" rx="1"/><rect width="7" height="7" x="14" y="14" rx="1"/><rect width="7" height="7" x="3" y="14" rx="1"/></svg>';
		case "info":
			return '<svg #baseAttrs#><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></svg>';
		case "home":
		case "house":
			return '<svg #baseAttrs#><path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/></svg>';
		case "compass":
			return '<svg #baseAttrs#><circle cx="12" cy="12" r="10"/><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"/></svg>';
		case "navigation":
			return '<svg #baseAttrs#><polygon points="3 11 22 2 13 21 11 13 3 11"/></svg>';
		case "map":
			return '<svg #baseAttrs#><polygon points="3 6 9 3 15 6 21 3 21 18 15 21 9 18 3 21"/><line x1="9" x2="9" y1="3" y2="18"/><line x1="15" x2="15" y1="6" y2="21"/></svg>';
		case "signpost":
			return '<svg #baseAttrs#><path d="M12 3v3"/><path d="M18.5 13h-13L2 9.5 5.5 6h13a1 1 0 0 1 1 1v5a1 1 0 0 1-1 1Z"/><path d="M12 13v8"/><path d="M9 21h6"/></svg>';
		case "route":
			return '<svg #baseAttrs#><circle cx="6" cy="19" r="3"/><path d="M9 19h8.5a3.5 3.5 0 0 0 0-7h-11a3.5 3.5 0 0 1 0-7H15"/><circle cx="18" cy="5" r="3"/></svg>';
		case "government":
		case "landmark":
		case "capitol":
		case "courthouse":
			return '<svg #baseAttrs#><line x1="3" x2="21" y1="22" y2="22"/><line x1="6" x2="6" y1="18" y2="11"/><line x1="10" x2="10" y1="18" y2="11"/><line x1="14" x2="14" y1="18" y2="11"/><line x1="18" x2="18" y1="18" y2="11"/><polygon points="12 2 20 7 4 7"/><line x1="2" x2="22" y1="18" y2="18"/></svg>';
		case "office":
		case "building-2":
			return '<svg #baseAttrs#><path d="M6 22V4a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v18Z"/><path d="M6 12H4a2 2 0 0 0-2 2v6a2 2 0 0 0 2 2h2"/><path d="M18 9h2a2 2 0 0 1 2 2v9a2 2 0 0 1-2 2h-2"/><path d="M10 6h4"/><path d="M10 10h4"/><path d="M10 14h4"/><path d="M10 18h4"/></svg>';
		case "gavel":
			return '<svg #baseAttrs#><path d="m14 13-7.5 7.5c-.83.83-2.17.83-3 0 0 0 0 0 0 0a2.12 2.12 0 0 1 0-3L11 10"/><path d="m16 16 6-6"/><path d="m8 8 6-6"/><path d="m9 7 8 8"/><path d="m21 11-8-8"/></svg>';
		case "scale":
		case "justice":
			return '<svg #baseAttrs#><path d="m16 16 3-8 3 8c-.87.65-1.92 1-3 1s-2.13-.35-3-1Z"/><path d="m2 16 3-8 3 8c-.87.65-1.92 1-3 1s-2.13-.35-3-1Z"/><path d="M7 21h10"/><path d="M12 3v18"/><path d="M3 7h2c2 0 5-1 7-2 2 1 5 2 7 2h2"/></svg>';
		case "flag":
			return '<svg #baseAttrs#><path d="M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z"/><line x1="4" x2="4" y1="22" y2="15"/></svg>';
		case "award":
		case "badge":
			return '<svg #baseAttrs#><circle cx="12" cy="8" r="6"/><path d="M15.477 12.89 17 22l-5-3-5 3 1.523-9.11"/></svg>';
		case "vote":
		case "ballot":
			return '<svg #baseAttrs#><path d="m9 12 2 2 4-4"/><path d="M5 7c0-1.1.9-2 2-2h10a2 2 0 0 1 2 2v12H5V7Z"/><path d="M22 19H2"/></svg>';
		case "siren":
		case "emergency":
			return '<svg #baseAttrs#><path d="M7 18v-6a5 5 0 1 1 10 0v6"/><path d="M5 21a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-1a2 2 0 0 0-2-2H7a2 2 0 0 0-2 2z"/><path d="M21 12h1"/><path d="M18.5 4.5 18 5"/><path d="M2 12h1"/><path d="M12 2v1"/><path d="m4.929 4.929.707.707"/><path d="M12 12v6"/></svg>';
		case "id-card":
		case "contact-card":
			return '<svg #baseAttrs#><rect width="20" height="14" x="2" y="5" rx="2"/><circle cx="8" cy="11" r="2"/><path d="M5 16a3 3 0 0 1 6 0"/><line x1="14" x2="18" y1="10" y2="10"/><line x1="14" x2="18" y1="14" y2="14"/></svg>';
		case "credit-card":
		case "payment":
			return '<svg #baseAttrs#><rect width="20" height="14" x="2" y="5" rx="2"/><line x1="2" x2="22" y1="10" y2="10"/></svg>';
		case "dollar-sign":
		case "finance":
			return '<svg #baseAttrs#><line x1="12" x2="12" y1="2" y2="22"/><path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"/></svg>';
		case "calculator":
			return '<svg #baseAttrs#><rect width="16" height="20" x="4" y="2" rx="2"/><line x1="8" x2="16" y1="6" y2="6"/><line x1="16" x2="16" y1="14" y2="18"/><path d="M16 10h.01"/><path d="M12 10h.01"/><path d="M8 10h.01"/><path d="M12 14h.01"/><path d="M8 14h.01"/><path d="M12 18h.01"/><path d="M8 18h.01"/></svg>';
		case "printer":
			return '<svg #baseAttrs#><polyline points="6 9 6 2 18 2 18 9"/><path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"/><rect width="12" height="8" x="6" y="14"/></svg>';
		case "archive":
			return '<svg #baseAttrs#><rect width="20" height="5" x="2" y="3" rx="1"/><path d="M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8"/><path d="M10 12h4"/></svg>';
		case "newspaper":
		case "news":
			return '<svg #baseAttrs#><path d="M4 22h16a2 2 0 0 0 2-2V4a2 2 0 0 0-2-2H8a2 2 0 0 0-2 2v16a2 2 0 0 1-2 2Zm0 0a2 2 0 0 1-2-2v-9c0-1.1.9-2 2-2h2"/><path d="M18 14h-8"/><path d="M15 18h-5"/><path d="M10 6h8v4h-8V6Z"/></svg>';
		case "trees":
		case "parks":
			return '<svg #baseAttrs#><path d="M10 10v.2A3 3 0 0 1 8.9 16v0H5v0h0a3 3 0 0 1-1-5.8V10a3 3 0 0 1 6 0Z"/><path d="M7 16v6"/><path d="M13 19v3"/><path d="M12 19h8.3a1 1 0 0 0 .7-1.7L18 14h.3a1 1 0 0 0 .7-1.7L16 9h.2a1 1 0 0 0 .8-1.7L13 3l-1.4 1.5"/></svg>';
		case "truck":
		case "public-works":
			return '<svg #baseAttrs#><path d="M14 18V6a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2v11a1 1 0 0 0 1 1h2"/><path d="M15 18H9"/><path d="M19 18h2a1 1 0 0 0 1-1v-3.65a1 1 0 0 0-.22-.624l-3.48-4.35A1 1 0 0 0 17.52 8H14"/><circle cx="17" cy="18" r="2"/><circle cx="7" cy="18" r="2"/></svg>';
		case "wrench":
			return '<svg #baseAttrs#><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>';
		case "heart-pulse":
		case "health":
			return '<svg #baseAttrs#><path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/><path d="M3.22 12H9.5l.5-1 2 4.5 2-7 1.5 3.5h5.27"/></svg>';
		case "graduation-cap":
		case "education":
			return '<svg #baseAttrs#><path d="M21.42 10.922a1 1 0 0 0-.019-1.838L12.83 5.18a2 2 0 0 0-1.66 0L2.6 9.08a1 1 0 0 0 0 1.832l8.57 3.908a2 2 0 0 0 1.66 0z"/><path d="M22 10v6"/><path d="M6 12.5V16a6 3 0 0 0 12 0v-3.5"/></svg>';
		default:
			return '<svg #baseAttrs#><circle cx="12" cy="12" r="10"/><line x1="12" x2="12" y1="8" y2="12"/><line x1="12" x2="12.01" y1="16" y2="16"/></svg>';
	}
}

/**
 * Renders HTML markup for a single Call to Action card matching the reference design.
 */
public string function renderCallToActionCardHtml(required struct item) {
	var title = Len(item.title ?: "") ? Trim(item.title) : "Call to Action";
	var desc = Len(item.description ?: "") ? Trim(item.description) : "";
	var imgUrl = Len(item.imageUrl ?: (item.image_url ?: "")) ? Trim(item.imageUrl ?: item.image_url) : "";
	var imgAlt = Len(item.imageAlt ?: (item.image_alt ?: "")) ? Trim(item.imageAlt ?: item.image_alt) : title;
	var linkText = Len(item.linkText ?: (item.link_text ?: "")) ? Trim(item.linkText ?: item.link_text) : "Learn More";
	var linkUrl = Len(item.linkUrl ?: (item.link_url ?: "")) ? Trim(item.linkUrl ?: item.link_url) : "##";
	var linkIcon = Len(item.linkIcon ?: (item.link_icon ?: "")) ? LCase(Trim(item.linkIcon ?: item.link_icon)) : "arrow";
	var linkStyle = Len(item.linkStyle ?: (item.link_style ?: "")) ? LCase(Trim(item.linkStyle ?: item.link_style)) : "link";
	var isBlank = (StructKeyExists(item, "targetBlank") && (item.targetBlank == 1 || item.targetBlank == "1" || item.targetBlank == true))
		|| (StructKeyExists(item, "target_blank") && (item.target_blank == 1 || item.target_blank == "1" || item.target_blank == true));
	var badgeText = Len(item.badgeText ?: (item.badge_text ?: "")) ? Trim(item.badgeText ?: item.badge_text) : "";
	var badgeColor = Len(item.badgeColor ?: (item.badge_color ?: "")) ? LCase(Trim(item.badgeColor ?: item.badge_color)) : "blue";
	var hasImage = Len(imgUrl) > 0;

	var sb = CreateObject("java", "java.lang.StringBuilder").init();
	sb.append('<aside class="jbd-template jbd-cta-card');
	if (hasImage) sb.append(' has-image');
	sb.append('" aria-label="Action: ' & Replace(title, '"', '&quot;', 'all') & '">');

	if (hasImage) {
		sb.append('<div class="jbd-cta-card-img-wrap">');
		sb.append('<img src="' & Replace(imgUrl, '"', '&quot;', 'all') & '" alt="' & Replace(imgAlt, '"', '&quot;', 'all') & '" loading="lazy">');
		sb.append('</div>');
		sb.append('<div class="jbd-cta-card-content">');
	}

	if (Len(badgeText)) {
		var badgeClass = "jbd-cta-badge";
		if (badgeColor == "teal") badgeClass &= " jbd-cta-badge-teal";
		else if (badgeColor == "blue") badgeClass &= " jbd-cta-badge-blue";
		else if (badgeColor == "amber" || badgeColor == "red") badgeClass &= " jbd-cta-badge-amber";
		sb.append('<div class="jbd-cta-card-header"><span class="' & badgeClass & '" aria-hidden="true">' & Replace(badgeText, "<", "&lt;", "all") & '</span></div>');
	}

	sb.append('<p class="jbd-cta-title h4">' & Replace(title, "<", "&lt;", "all") & '</p>');
	if (Len(desc)) {
		sb.append('<p class="jbd-cta-desc">' & Replace(desc, "<", "&lt;", "all") & '</p>');
	}

	sb.append('<div class="jbd-cta-card-footer">');
	var targetAttr = isBlank ? ' target="_blank" rel="noopener noreferrer"' : '';
	var extClass = (isBlank || linkIcon == "external") ? ' has-external-icon' : '';

	if (linkStyle == "button") {
		sb.append('<a href="' & Replace(linkUrl, '"', '&quot;', 'all') & '" class="jbd-btn jbd-btn-primary jbd-cta-btn"' & targetAttr & ' aria-label="' & Replace(linkText & ' for ' & title, '"', '&quot;', 'all') & '">');
		sb.append('<span>' & Replace(linkText, "<", "&lt;", "all") & '</span>');
		if (linkIcon == "external") {
			sb.append(' <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>');
		} else if (linkIcon == "pdf") {
			sb.append(' <span class="jbd-cta-pdf-badge" aria-hidden="true">PDF</span>');
		} else if (linkIcon != "none") {
			sb.append(' <svg viewBox="0 0 24 24" width="16" height="16" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>');
		}
		sb.append('</a>');
	} else {
		sb.append('<a href="' & Replace(linkUrl, '"', '&quot;', 'all') & '" class="jbd-cta-link' & extClass & '"' & targetAttr & ' aria-label="' & Replace(linkText & ' for ' & title, '"', '&quot;', 'all') & '">');
		sb.append('<span>' & Replace(linkText, "<", "&lt;", "all") & '</span>');
		if (linkIcon == "external") {
			sb.append(' <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>');
		} else if (linkIcon == "pdf") {
			sb.append(' <span class="jbd-cta-pdf-badge" aria-hidden="true">PDF</span>');
		} else if (linkIcon != "none") {
			sb.append(' <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>');
		}
		sb.append('</a>');
	}

	sb.append('</div>');
	if (hasImage) {
		sb.append('</div>');
	}
	sb.append('</aside>');
	return sb.toString();
}

/**
 * Repairs any .jbd-cta-link anchors whose arrow/external icon was saved as '?', '&rarr;', or '&nearr;' instead of inline SVG.
 */
public string function normalizeCtaLinkIcons(required string content) {
	if (!Len(arguments.content) || FindNoCase("jbd-cta-link", arguments.content) == 0) {
		return arguments.content;
	}
	var result = arguments.content;
	var arrowSvg = ' <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/></svg>';
	var extSvg = ' <svg viewBox="0 0 24 24" width="15" height="15" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M15 3h6v6"/><path d="M10 14 21 3"/><path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"/></svg>';
	var matches = REMatchNoCase('<a\b[^>]*class="[^"]*\bjbd-cta-link\b[^"]*"[^>]*>[\s\S]*?</a>', result);
	for (var aTag in matches) {
		if (FindNoCase("<svg", aTag) == 0 && FindNoCase("jbd-cta-pdf-badge", aTag) == 0) {
			var isExt = (FindNoCase('target="_blank"', aTag) > 0 || FindNoCase("has-external-icon", aTag) > 0 || FindNoCase("&nearr;", aTag) > 0 || Find(Chr(8599), aTag) > 0);
			var cleaned = REReplaceNoCase(aTag, '\s*(\?|&rarr;|&nearr;|##8594;|##8599;|' & Chr(8594) & '|' & Chr(8599) & ')?\s*</a>$', (isExt ? extSvg : arrowSvg) & '</a>');
			if (isExt && FindNoCase("has-external-icon", cleaned) == 0) {
				cleaned = REReplaceNoCase(cleaned, 'class="([^"]*\bjbd-cta-link\b)', 'class="\1 has-external-icon');
			}
			result = Replace(result, aTag, cleaned, "all");
		}
	}
	return result;
}

/**
 * Parses and replaces [call_to_action ...], [cta ...], and [cta_grid ...] shortcodes in content.
 */
public string function renderCallToActionShortcodes(required string content) {
	if (!Len(arguments.content) || (FindNoCase("[call_to_action", arguments.content) == 0 && FindNoCase("[cta", arguments.content) == 0)) {
		return arguments.content;
	}

	var parsed = arguments.content;

	// 1. Process Grid Shortcodes: [cta_grid slugs="s1,s2,s3" cols="3"] or [cta_grid category="..." layout="2x2"]
	var gridMatches = REMatchNoCase("\[cta_grid\s+[^\]]+\]", parsed);
	for (var gTag in gridMatches) {
		var slugsMatch = REFindNoCase('slugs?="([^"]+)"', gTag, 1, true);
		var catMatch = REFindNoCase('categor(y|ies)="([^"]+)"', gTag, 1, true);
		var colsMatch = REFindNoCase('(?:cols?|columns?|layout)="([^"]+)"', gTag, 1, true);
		var itemsHtml = "";
		var itemCount = 0;

		try {
			if (ArrayLen(slugsMatch.len) >= 2 && slugsMatch.len[2] > 0) {
				var slugList = Mid(gTag, slugsMatch.pos[2], slugsMatch.len[2]);
				var slugArr = ListToArray(slugList);
				for (var s in slugArr) {
					var qS = queryExecute("
						SET ANSI_NULLS ON; SET QUOTED_IDENTIFIER ON;
						SELECT TOP 1 * FROM page_call_to_actions
						WHERE slug = :slug AND is_published = 1 AND deletedat IS NULL
					", { slug: { value: Trim(s), cfsqltype: "cf_sql_nvarchar" } }, { datasource: "ChelanCountyWebsite" });
					if (qS.recordCount) {
						itemsHtml &= renderCallToActionCardHtml(qS.getRow(1));
						itemCount++;
					}
				}
			} else if (ArrayLen(catMatch.len) >= 3 && catMatch.len[3] > 0) {
				var catName = Mid(gTag, catMatch.pos[3], catMatch.len[3]);
				var qC = queryExecute("
					SET ANSI_NULLS ON; SET QUOTED_IDENTIFIER ON;
					SELECT * FROM page_call_to_actions
					WHERE category = :cat AND is_published = 1 AND deletedat IS NULL
					ORDER BY sort_order ASC, id ASC
				", { cat: { value: Trim(catName), cfsqltype: "cf_sql_nvarchar" } }, { datasource: "ChelanCountyWebsite" });
				itemCount = qC.recordCount;
				for (var row in qC) {
					itemsHtml &= renderCallToActionCardHtml(row);
				}
			}
		} catch (any e) {}

		if (Len(itemsHtml)) {
			var gridCls = "jbd-template jbd-cta-grid";
			var specifiedLayout = "";
			if (ArrayLen(colsMatch.len) >= 2 && colsMatch.len[2] > 0) {
				specifiedLayout = LCase(Trim(Mid(gTag, colsMatch.pos[2], colsMatch.len[2])));
			}

			if (specifiedLayout == "4" || specifiedLayout == "4col" || specifiedLayout == "4-col" || specifiedLayout == "4cols") {
				gridCls &= " cta-grid-4";
			} else if (specifiedLayout == "2" || specifiedLayout == "2col" || specifiedLayout == "2-col" || specifiedLayout == "2x2" || specifiedLayout == "50/50" || specifiedLayout == "50-50" || specifiedLayout == "5050") {
				gridCls &= " cta-grid-2 cta-grid-50-50";
			} else if (specifiedLayout == "3" || specifiedLayout == "3col" || specifiedLayout == "3-col" || specifiedLayout == "3x1" || specifiedLayout == "3-1") {
				gridCls &= " cta-grid-3";
			} else {
				if (itemCount == 2) {
					gridCls &= " cta-grid-2 cta-grid-50-50";
				} else if (itemCount == 4) {
					gridCls &= " cta-grid-4";
				} else {
					gridCls &= " cta-grid-3";
				}
			}

			var gridReplacement = '<section class="' & gridCls & '" aria-label="Featured Actions">' & itemsHtml & '</section>';
			parsed = Replace(parsed, gTag, gridReplacement, "one");
		}
	}

	// 2. Process Individual Shortcodes: [call_to_action slug="..."] or [cta slug="..."]
	var singleMatches = REMatchNoCase("\[(?:call_to_action|cta)\s+[^\]]+\]", parsed);
	for (var sTag in singleMatches) {
		var slugM = REFindNoCase('slug="([^"]+)"', sTag, 1, true);
		var idM = REFindNoCase('id="?([0-9]+)"?', sTag, 1, true);
		var cardHtml = "";

		try {
			if (ArrayLen(slugM.len) >= 2 && slugM.len[2] > 0) {
				var targetSlug = Mid(sTag, slugM.pos[2], slugM.len[2]);
				var qOne = queryExecute("
					SET ANSI_NULLS ON; SET QUOTED_IDENTIFIER ON;
					SELECT TOP 1 * FROM page_call_to_actions
					WHERE slug = :slug AND is_published = 1 AND deletedat IS NULL
				", { slug: { value: Trim(targetSlug), cfsqltype: "cf_sql_nvarchar" } }, { datasource: "ChelanCountyWebsite" });
				if (qOne.recordCount) {
					cardHtml = renderCallToActionCardHtml(qOne.getRow(1));
				}
			} else if (ArrayLen(idM.len) >= 2 && idM.len[2] > 0) {
				var targetId = Val(Mid(sTag, idM.pos[2], idM.len[2]));
				var qId = queryExecute("
					SET ANSI_NULLS ON; SET QUOTED_IDENTIFIER ON;
					SELECT TOP 1 * FROM page_call_to_actions
					WHERE id = :id AND is_published = 1 AND deletedat IS NULL
				", { id: { value: targetId, cfsqltype: "cf_sql_integer" } }, { datasource: "ChelanCountyWebsite" });
				if (qId.recordCount) {
					cardHtml = renderCallToActionCardHtml(qId.getRow(1));
				}
			}
		} catch (any e) {}

		if (Len(cardHtml)) {
			parsed = Replace(parsed, sTag, cardHtml, "one");
		}
	}

	return parsed;
}

/**
 * Renders CMS content with automatic shortcode resolution for [chelan_form ...], [cta_grid ...], and [call_to_action ...]
 */
public string function renderCmsContent(required string html) {
	if (!Len(Trim(arguments.html))) return "";
	var out = renderCallToActionShortcodes(arguments.html);
	out = normalizeCtaLinkIcons(out);

	// Replace [chelan_form slug="xyz"]
	out = REReplaceNoCase(
		out,
		'\[chelan_form\s+slug=["'']([^"'']+)["'']\s*\]',
		'<div class="cms-form-embed my-4" data-form-slug="\1"><iframe src="http://cmsadmin.chelancounty.gov/forms/preview?slug=\1" width="100%" height="920" frameborder="0" scrolling="auto" style="border:none; width:100%; min-height:650px; transition:height 0.2s ease;" title="Online Form" loading="lazy"></iframe></div>',
		"all"
	);

	// Replace [chelan_form id="123"]
	out = REReplaceNoCase(
		out,
		'\[chelan_form\s+id=["'']?([0-9]+)["'']?\s*\]',
		'<div class="cms-form-embed my-4" data-form-id="\1"><iframe src="http://cmsadmin.chelancounty.gov/forms/preview?id=\1" width="100%" height="920" frameborder="0" scrolling="auto" style="border:none; width:100%; min-height:650px; transition:height 0.2s ease;" title="Online Form" loading="lazy"></iframe></div>',
		"all"
	);

	// Automatically attach responsive height listener if an embedded form is present on the page
	if (FindNoCase("cms-form-embed", out)) {
		out &= '<script>if(!window._chelanFormResizeAttached){window._chelanFormResizeAttached=true;window.addEventListener("message",function(e){if(e.data&&e.data.type==="chelan-form-resize"&&e.data.height){var targetHeight=Math.max(400,Math.min(parseInt(e.data.height,10),3500));var iframes=document.querySelectorAll(".cms-form-embed iframe");for(var i=0;i<iframes.length;i++){if(iframes[i].contentWindow===e.source||iframes.length===1){iframes[i].style.height=targetHeight+"px";iframes[i].style.minHeight=targetHeight+"px";iframes[i].setAttribute("height",targetHeight);}}}});}</script>';
	}

	return out;
}
</cfscript>
