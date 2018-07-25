// ==UserScript==
// @name     Google Calendark
// @namespace https://github.com/elterminad0r
// @description Sets the background colour for "today" to something darker in Google calendar
// @include  https://calendar.google.com/calendar/*
// @version  1
// @grant    none
// ==/UserScript==

// install greasemonkey: https://addons.mozilla.org/en-GB/firefox/addon/greasemonkey/
// then click on the icon and click "new user script"

// change the background-color or add CSS to suit your needs

document.getElementsByTagName("head")[0].innerHTML += "<style> div.ef2wWc, div.F262Ye { background-color: #000 } </style>"
