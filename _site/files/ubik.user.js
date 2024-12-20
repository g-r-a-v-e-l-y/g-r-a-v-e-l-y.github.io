// ==UserScript==
// @name           Ubik
// @description    Turn all text advertisements into advertisements for Ubik
// @description    Safe when used as directed
// @description	   Project page: http://grantstavely.com/ubik
// @include        http://*.facebook.com/*
// @author         Grant Stavely (http://grantstavely.com/) and others 
// ==/UserScript==

// add style
var cssNode = document.createElement('link');
cssNode.type = 'text/css';
cssNode.rel = 'stylesheet';
cssNode.href = 'http://www.grantstavely.com/files/simplepedia.css';
cssNode.media = 'screen';
cssNode.title = 'dynamicLoadedSheet';
document.getElementsByTagName("head")[0].appendChild(cssNode);

// shorten the title
var wst_res = /^(.+)\s[-\u2012\u2013\u2014\u2015]\s[^-\u2012\u2013\u2014\u2015]+$/.exec(document.title);
if (wst_res != null && wst_res.length == 2) document.title = wst_res[1];


// Begin mattrdo's userscript
/*
Copyright (c) 2008 mattrdo

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//revision2/20080608: uses the pre-existing logo (to better effect)




// Create a floating search-bar

var searchbar = document.createElement("div");

searchbar.innerHTML='\
			<form action="/wiki/Special:Search" ><div id="search_bar">\
				<input id="searchInput" name="search" type="text" title="Search Wikipedia [f]" accesskey="f" value="" />\
			</div></form>\
'; // end of searchbar source

searchbar.style.position="absolute";
searchbar.style.top=0;
searchbar.style.right="10px";

document.getElementById("column-one").appendChild(searchbar);


// one for the front page
//

var frontsearch = document.createElement("div");
frontsearch.setAttribute("id", "frontsearch");
frontsearch.innerHTML="";

var inlinestylesucks = document.getElementsByTagName("div").item(3);

inlinestylesucks.appendChild(frontsearch);




// Change margins to fit the new top of the page, and move the logo

// Lower the content stuff to give the new search bar more room
document.getElementById("content").style.marginTop="1.5em"; // 2.8em
document.getElementById("content").style.marginLeft="0em"; // 12.2em
document.getElementById("p-cactions").style.top="1.5em"; // 1.3em

// Move the logo
//document.getElementById("p-logo").style.top="-100px";
////document.getElementById("p-logo").style.left="0px";





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
