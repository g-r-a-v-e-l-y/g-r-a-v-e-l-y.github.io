// ==UserScript==
// @name           Scream Like A Man
// @version        1.0mazing
// @namespace      http://grantstavely.com/files/lame.user.js
// @license        (CC) Attribution Non-Commercial Share Alike; http://creativecommons.org/licenses/by-nc-sa/3.0/
// @description    Improve the web, scream like a man.
// @include        *
// ==/UserScript==

// So you're reading an article or some goofball's twitter toot,
// and the link looks interesting so you click on it, not
// realizing it's going to take you to some cesspool run by
// Mike Arrington or something. 
//
// No thanks, right?
//
// Make them go to better sites! Who cares about context?

var url = location.href;
// add all the domains here
var natch = /(experts-exchange|techcrunch|crunchgear|mobilecrunch|techcrunchit|talkcrunch|techcrunch50|crunchboard|crunchbase)\.\w+\//;

// Serious options
// var ohShit = 'about:blank';
var betterLink = '#';

// Comedy options
var ohShit = 'http://grantstavely.com/evil/';
// var betterLink = ohShit;

// if it's too late
if (url.match(natch)) {
  window.location = ohShit;
}

// if it's not too late
list = document.getElementsByTagName('a');
for (i=0; i<list.length; i++) {
  if (list[i].href.match(natch)) {
    var scream = document.createElement('a');
    scream.setAttribute('href', betterLink);
    scream.innerHTML = list[i].innerHTML + "<sup>✌</sup>";
    list[i].parentNode.replaceChild(scream, list[i]);
  }
}

