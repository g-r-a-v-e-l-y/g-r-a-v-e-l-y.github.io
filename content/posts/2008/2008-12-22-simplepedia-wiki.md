---
title: Simplepedia
tags: posts
date: 2008-12-22 15:15:00.00 -8
permalink: "/simplepedia-wiki.html"
---

I integrated two existing greasemonkey user scripts for wikipedia, and added lots of _element { display: none; }_‘s to the style sheet, and ended up with a userscript I’m calling [Simplepedia](http://userscripts.org/scripts/show/42312):

Wikipedia’s design and style is tiring and cluttered:

[![screenshot of wikipedia on the Adrian Belew page](/images/pre-simplepedia-belew-thumb.png)](/images/pre-simplepedia-belew.png)

There is just too much going on!

Without the entire left bar, banner ads, footers, and tiny sans serif type, [wikipedia](http://www.wikipedia.org/) is much more inviting:

[![screenshot of simplepedia on the Adrian Belew page](/images/simplepedia-belew-thumb.png)](/images/simplepedia-belew.png "Click to veiew larger")

There are still issues – some hard coded elements just can’t be undone. The front page language selection doorstop is completely lacking ID elements, and I don’t want to follow their lead and hard code a DOM\-walking cleanup. Entire tables exist just to pad out other tables. There are numbered lists that are actually unordered lists with each list item hard coding their number values. Colors and fonts are called out inline all over the place in css in place of proper classes and ids.

This was inspired by [Jon Hick’s](http://hicksdesign.co.uk/) excellent [Helvetireader](http://helvetireader.com/) user script for Google Reader.

If you don’t have Greasemonkey yet, [go get it](https://addons.mozilla.org/en-US/firefox/addon/748). It isn’t just for firefox either, [greasekit](http://8-p.info/greasekit/) is a port for WebKit browsers like Safari and Omniweb.