<!-- ============ Translate / language picker ============
     Matches the pattern several WA county sites use: instead of the nav
     link jumping straight into Google Translate's own UI, it lands here
     first on a same-site page that (a) discloses that translation is an
     automated third-party service, and (b) lets the visitor pick their
     language from a full list. Each language link below hands off to
     Google Translate with that language pre-selected (tl=<code>) rather
     than making the visitor find it inside Google's own picker. -->
<div class="container py-5">

  <!-- Disclaimer banner: same wording pattern as the reference screenshot,
       adapted for Chelan County. role="note" + the visible heading give
       assistive-tech users a clear landmark for "this is a disclosure,
       not page content." -->
  <div class="translate-banner mb-4" role="note" aria-labelledby="translate-banner-heading">
    <p class="translate-powered-by mb-3" id="translate-banner-heading">
      Powered by
      <img src="https://www.gstatic.com/images/branding/googlelogo/svg/googlelogo_clr_74x24px.svg" alt="Google" class="translate-google-logo" width="52" height="17">
      Translate
    </p>
    <p class="mb-3">We currently offer language translations on our site primarily through Google Translate. This helps visitors find and use information in the languages they speak, but the tool is not perfect. Automated translation may be inaccurate or errors may display on translated pages.</p>
    <p class="mb-0">Google Translate is an external website. Chelan County does not control the quality or accuracy of translated content.</p>
  </div>

  <h1 class="h3 mb-1">Language and region</h1>
  <p class="text-muted mb-4">Please choose a language</p>

  <!-- Each link opens Google Translate, in a new tab, with the county
       homepage pre-loaded and this language pre-selected. Sorted A-Z by
       English name, with English leading the label (native name in
       parentheses) rather than the reverse — a native-first label like
       "Shqiptar (Albanian)" is alphabetized under "S" while a visitor
       scanning for "Albanian" looks under "A", so putting the sorted-on
       name first is what actually makes the A-Z order scannable. -->
  <nav aria-label="Choose a language">
    <ul class="list-unstyled d-flex flex-wrap gap-2 translate-lang-grid mb-0">
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ab&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Abkhaz</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ace&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Acehnese</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ach&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Acholi</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=aa&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Afar</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=af&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Afrikaans</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sq&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Albanian (Shqiptar)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=alz&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Alur</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=am&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Amharic (አማርኛ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ar&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Arabic (العربية)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=hy&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Armenian (Հայերեն)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=as&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Assamese (অসমীয়া)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=av&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Avar</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=awa&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Awadhi</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ay&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Aymara (Aymar aru)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=az&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Azerbaijani (Azərbaycan)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ban&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Balinese</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bal&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Baluchi</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bm&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bambara (Bamanankan)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bci&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Baoulé</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ba&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bashkir</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=eu&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Basque (Euskal)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=btx&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Batak Karo</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bts&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Batak Simalungun</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bbc&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Batak Toba</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=be&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Belarusian (Беларус)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bem&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bemba</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bn&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bengali (বাংলা)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bew&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Betawi</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bho&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bhojpuri</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bik&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bikol</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bs&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bosnian (Bosanski)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=br&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Breton</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bg&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Bulgarian (Български)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=bua&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Buryat</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=yue&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Cantonese</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ca&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Catalan (Català)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ceb&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Cebuano</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ch&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chamorro</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ce&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chechen</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ny&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chichewa</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=zh-CN&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chinese, Simplified (中文)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=zh-TW&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chinese, Traditional (中文)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=chk&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chuukese</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=cv&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Chuvash</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=co&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Corsican (Corsu)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=crh&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Crimean Tatar (Latin)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=hr&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Croatian (Hrvatski)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=cs&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Czech (Čeština)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=da&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Danish (Dansk)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=dv&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Dhivehi (ދިވެހި)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=nl&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Dutch (Nederlands)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=dz&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Dzongkha</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=en&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">English</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=eo&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Esperanto</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=et&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Estonian (Eesti)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ee&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Ewe (Eʋegbe)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=fj&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Fijian (Na Vosa Vakaviti)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=fil&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Filipino</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=fi&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Finnish (Suomi)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=fr&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">French (Français)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=fy&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Frisian (Frysk)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=gaa&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Ga</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=gl&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Galician (Galego)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ka&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Georgian (ქართული)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=de&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">German (Deutsch)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=el&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Greek (Ελληνικά)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=gn&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Guarani</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=gu&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Gujarati (ગુજરાતી)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ht&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Haitian Creole (Kreyòl Ayisyen)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ha&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Hausa</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=haw&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Hawaiian (ʻŌlelo Hawaiʻi)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=iw&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Hebrew (עברית)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=hi&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Hindi (हिन्दी)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=hmn&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Hmong</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=hu&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Hungarian (Magyar)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=is&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Icelandic (Íslenska)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ig&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Igbo</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=id&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Indonesian (Indonesia)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ga&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Irish (Gaeilge)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=it&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Italian (Italiano)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ja&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Japanese (日本語)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=jw&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Javanese (Basa Jawa)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=kn&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Kannada (ಕನ್ನಡ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=kk&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Kazakh (Қазақ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=km&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Khmer (ខ្មែរ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=rw&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Kinyarwanda</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ko&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Korean (한국어)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ku&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Kurdish (Kurdî)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ky&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Kyrgyz (Кыргызча)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=lo&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Lao (ລາວ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=la&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Latin</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=lv&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Latvian (Latviešu)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=lt&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Lithuanian (Lietuvių)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=mk&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Macedonian (Македонски)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=mg&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Malagasy</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ms&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Malay (Bahasa Melayu)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ml&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Malayalam (മലയാളം)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=mt&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Maltese (Malti)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=mr&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Marathi (मराठी)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=mn&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Mongolian (Монгол)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=my&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Myanmar/Burmese (မြန်မာ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=mi&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Māori</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ne&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Nepali (नेपाली)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=no&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Norwegian (Norsk)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=or&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Odia (ଓଡ଼ିଆ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ps&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Pashto (پښتو)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=fa&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Persian (فارسی)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=pl&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Polish (Polski)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=pt&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Portuguese (Português)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=pa&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Punjabi (ਪੰਜਾਬੀ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ro&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Romanian (Română)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ru&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Russian (Русский)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sm&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Samoan (Gagana Sāmoa)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=gd&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Scots Gaelic (Gàidhlig)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sr&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Serbian (Српски)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sn&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Shona</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sd&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Sindhi (سنڌي)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=si&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Sinhala (සිංහල)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sk&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Slovak (Slovenčina)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sl&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Slovenian (Slovenščina)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=so&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Somali (Soomaali)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=es&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Spanish (Español)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=su&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Sundanese (Basa Sunda)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sw&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Swahili (Kiswahili)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=sv&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Swedish (Svenska)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=tl&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Tagalog</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=tg&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Tajik (Тоҷикӣ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ta&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Tamil (தமிழ்)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=tt&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Tatar (Татар)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=te&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Telugu (తెలుగు)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=th&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Thai (ไทย)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ti&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Tigrinya (ትግርኛ)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=to&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Tongan (Lea Fakatonga)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=tr&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Turkish (Türkçe)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=tk&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Turkmen (Türkmen)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=uk&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Ukrainian (Українська)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ur&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Urdu (اردو)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=ug&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Uyghur (ئۇيغۇرچە)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=uz&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Uzbek (Oʻzbek)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=vi&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Vietnamese (Tiếng Việt)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=cy&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Welsh (Cymraeg)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=xh&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Xhosa (isiXhosa)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=yi&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Yiddish (ייִדיש)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=yo&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Yoruba (Yorùbá)</a></li>
      <li><a class="translate-chip" href="https://translate.google.com/translate?sl=auto&amp;tl=zu&amp;u=https://ChelanCounty.gov/" target="_blank" rel="noopener noreferrer">Zulu (isiZulu)</a></li>
    </ul>
  </nav>

</div>
