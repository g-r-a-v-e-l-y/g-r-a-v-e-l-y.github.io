// ==UserScript==
// @name           SemVee style
// @include        http://*.semvee.com/*
// @author         Grant Stavely (http://grantstavely.com/) 
// ==/UserScript==

// add style
var cssNode = document.createElement('link');
cssNode.type = 'text/css';
cssNode.rel = 'stylesheet';
cssNode.href = 'http://www.grantstavely.com/files/semvee.css';
cssNode.media = 'screen';
cssNode.title = 'dynamicLoadedSheet';
document.getElementsByTagName("head")[0].appendChild(cssNode);
document.getElementById("column-one").appendChild(searchbar);

