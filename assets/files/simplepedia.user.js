// ==UserScript==
// @name           Simplepedia
// @description    A wikipedia simplification script, combining a few other scripts
// @description    Removing the sidebar, shortening the document title, and applying some 
// @description    new document styles 
// @description	   Project page: http://grantstavely.com/helvetipedia

// @include        http://*.wikipedia.org/*
// @include        http://*.wikibooks.org/*
// @include	   http://wikipedia.org/
// @include	   http://*.wiktionary.org/*
// @include	   http://*.wikiquote.org/*
// @include	   http://*.wikimedia.org/*
// @include	   http://*.wikibooks.org/*
// @include	   http://*.wikiversity.org/*
// @include 	   http://*.wikinews.org/*
// @include	   http://commons.oreilly.com/*
// @author         Grant Stavely (http://grantstavely.com/) and others 
// @author	   Much of the removal is from http://userscripts.org/scripts/show/28575
// @author	   mattrdo (http://userscripts.org/users/56046)
// @author 	   @ (http://userscripts.org/users/36713)
// ==/UserScript==

// Until I add a config screen
var helvetica = true; // set to true for helvetica, false for Hoefler Text+

// add style
var primaryCSS = document.createElement('link');
primaryCSS.type = 'text/css';
primaryCSS.rel = 'stylesheet';
primaryCSS.href = 'http://www.grantstavely.com/files/simplepedia/simplepedia.css';
primaryCSS.media = 'screen';
primaryCSS.title = 'dynamicLoadedSheet';
document.getElementsByTagName("head")[0].appendChild(primaryCSS);

// add font option styles
var fontCSS = document.createElement('link');
fontCSS.type = 'text/css';
fontCSS.rel = 'stylesheet';
if (helvetica == true) {
	fontCSS.href = 'http://www.grantstavely.com/files/simplepedia/helvetica.css';
}
else {
	fontCSS.href = 'http://www.grantstavely.com/files/simplepedia/hoefler.css';
}
fontCSS.media = 'screen';
fontCSS.title = 'dynamicLoadedSheet';
document.getElementsByTagName("head")[0].appendChild(fontCSS);

// fix front page
var url = location.href;
if (url == "http://wikipedia.org/"|| url == "http://www.wikipedia.org/") {
	var newFrontPage = document.createElement("div");
	newFrontPage.innerHTML='\
	<div id="logotype">\
		<img src="http://upload.wikimedia.org/wikipedia/en/6/62/174px-Wikipedia-word1_7.png"  width="174" height="50" alt="WIKIPEDIA" />\
	</div>\
	<div id="globeLogo">\
		<img src="http://upload.wikimedia.org/wikipedia/meta/2/2a/Nohat-logo-nowords-bgwhite-200px.jpg" width="200" height="200" alt="" />\
	</div>\
	<form id="front-search" action="/w/index.php" method="get">\
		<div id="front_search_bar">\
			<input name="title" type="hidden" value="Special:Search" />\
			<input name="ns0" type="hidden" value="1" />\
			<input id="frontsearchInput" name="search" type="text" title="Search Wikipedia [f]" accesskey="f" value="" />\
		</div>\
	</form>\
	';
	newFrontPage.setAttribute('id', 'NewFront');
	var oldheader = document.getElementById("column-content");
        oldheader.parentNode.replaceChild(newFrontPage, oldheader);
}

// fix wiktionary front page
else if (url == "http://wiktionary.org/"|| url == "http://www.wiktionary.org/") {
	var newWiktionary = document.createElement("div");
	newWiktionary.innerHTML='\
<div id="logotype">\
		<h1 ="logotype"> Wiktionary </h1>\
        </div>\
        <div id="Wiktionary Logo">\
                <img src="http://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Wiktionary-logo-en.png/170px-Wiktionary-logo-en.png" width="200" height="200" alt="" />\
        </div>\
        <form id="front-search" action="/w/index.php" method="get">\
                <div id="front_search_bar">\
                        <input name="title" type="hidden" value="Special:Search" />\
                        <input name="ns0" type="hidden" value="1" />\
                        <input id="frontsearchInput" name="search" type="text" title="Search Wiktionary" accesskey="f" value="" />\
                </div>\
        </form>\
        ';
        newWiktionary.setAttribute('id', 'NewFront');
        var oldheader = document.getElementById("column-content");
        oldheader.parentNode.replaceChild(newWiktionary, oldheader);
}

// shorten the title
var wst_res = /^(.+)\s[-\u2012\u2013\u2014\u2015]\s[^-\u2012\u2013\u2014\u2015]+$/.exec(document.title);
if (wst_res != null && wst_res.length == 2) document.title = wst_res[1];

// Create a floating search-bar that uses advanced search instead of generic search

var searchbar = document.createElement("div");

searchbar.innerHTML='\
	<form id="search" action="/w/index.php" method="get">\
		<div id="search_bar">\
			<input name="title" type="hidden" value="Special:Search" />\
			<input name="ns0" type="hidden" value="1" />\
			<input id="searchInput" name="search" type="text" title="Search Wikipedia [f]" accesskey="f" value="" />\
		</div>\
	</form>\
'; // end of searchbar source

searchbar.id="floatingsearch";
searchbar.style.position="absolute";
searchbar.style.right="20px";
searchbar.style.top="45px";
document.getElementById("column-one").appendChild(searchbar);


// func: kill(array of IDs, number of times to retry killing IDs):
// desc: Kills every node whose id is in "idList", the first parameter, and if it didn't work for any then
//        try again "retries" more times (b/c strangely p-personal wasn't always loading soon enough).

window.euh38f_kill = function(idList, retries) {
	var iWantDebugMessages = false;
	iWantDebugMessages ? console.log(">> kill() is running with "+retries+" retries.") : false;

	var missingIds = [];
	var len = idList.length;
	var id;

	for (var i=0; i<len; i++) {
		id = document.getElementById(idList[i]);
		if (id) {
			id.parentNode.removeChild(id);
			iWantDebugMessages ? console.log(">> Killed id: "+idList[i]) : false;
		} else {
			missingIds.push(idList[i]);
			iWantDebugMessages ? console.log(">> Couldn't kill id: "+idList[i]) : false;
		}
	}
	if (missingIds.length>0 && retries>0) {
		window.setTimeout(euh38f_kill,400, missingIds, retries-1);
	}
}

// These portlet ids are in <div id="column-one">; we're implicitly keeping "p-actions", "p-logo"
var killList = ["p-navigation","p-interaction","p-search","p-tb",
		"p-personal","donate","p-lang","anontip","anon-banner"];
euh38f_kill(killList,4);

// Replace the main page header
var newHeaderContent = document.createElement("div");
newHeaderContent.innerHTML='\
        <h1 class="mp-header">Welcome to Wikipedia</h1>\
        ';
newHeaderContent.setAttribute('id', 'mp-newhead')
var oldheader = document.getElementById("mp-topbanner");
        oldheader.parentNode.replaceChild(newHeaderContent, oldheader);


