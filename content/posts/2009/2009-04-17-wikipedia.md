---
title: Wikipedia
tags: posts
date: 2009-04-17 10:53:00.00 -8
permalink: "/wikipedia.html"
---
[Simplepedia](http://userscripts.org/scripts/show/42312) is a
[greasemonkey](http://en.wikipedia.org/wiki/Greasemonkey) userscript that
gives mediawiki sites a modern and clean design.

Wikipedia's design and style is tiring and cluttered. There's just too much
going on!

![Wikipedia front page](/images/wikipedia.off.png)

![Wikipedia main page](/images/en.wikipedia.off.png)


Without the entire left bar, banner ads, footers, and tiny sans serif type,
[wikipedia](http://www.wikipedia.org/) is much more inviting.

![Wikipedia front page](/images/wikipedia.png)

![Wikipedia main page](/images/en.wikipedia.png)


Visit your [about:config](about:config) to chose the heading and body fonts
you'd like Simplepedia to use. You can change the link colors too.

![Wikipedia as an editor](/images/prefs.png)

Try it in Helvetica. ![Wikipedia in Helvetica](/images/helvetica.png)

Or Wikipedia's logotype, Hoefler Text. ![Wikipedia in Hoefler Text](/images/hoefler.png)


And you can optionally display a drop down selection box to jump to the same
article in other languages, hide edit and logon text, and more.

The script generically applies to any site built with the standard MediaWiki
engine using the default theme, but works best on WikipediA.

This was inspired by [Jon Hick's](http://hicksdesign.co.uk/) excellent
[Helvetireader](http://helvetireader.com/) user script for Google Reader.

## Change Log

  * Version .991 July 17, 2009
    * Added a W favicon for wikipedia only
    * Cleaned preference handling a bit, please reset and reload to use
    * Fixed display of international language selection to use a localized title
    * Darkened the darks a bit
    * Misc. css tweaking
    * Updated wikipedia discovery to regex better
  * Version .99 July 15, 2009
    * Fixed the alternate language select drop-down and made it an option
  * Version .983 July 10, 2009
    * Miscelaneous small css fixes adapting to changes made at Wikipedia
    * Simplified front page further
    * Made en.wikipedia closer resemble artile pages
    * Embracing helvetica, possibly renaming to helvetipedia soon
  * Version .982 June 22, 2009
    * Tweaked thumbnail picture padding to correct a hover issue (thanks sdfghrr)
    * Tweaked Encyclopedia Dramatica again
  * Version .98 June 2, 2009
    * Added a new about:config / cookie option to make customizing link colors more discoverable
  * Version .97 June 2, 2009
    * Resolved issues with preference handling in webkit
    * Added disabled preference to dynamically create jump-list of all alternate language versions of a given document on wikipedia (still under construction)
  * Version .96 May 21, 2009
    * Improved generic wiki support (including wikia.com wikis)
  * Version .95 May 18, 2009
    * Improved font selection changes and examples
    * Updated namespace
    * Fixed Auto-updating menu selection controls
  * Version .94 May 16, 2009
    * Reset font selection to allow greater user control
    * Tweaked javascript style, thanks iandalton
    * Updated css for multiple fixes
  * Version .93 May 14, 2009
    * Added checks to leave user configured items alone, thanks iandalton
    * Updated css for multiple fixes
  * Version .92 May 10, 2009 (Complete rewrite)
    * Simplepedia is now self-contained, and will not reach out to the author's server for css
    * Document titles are no longer altered
    * Added generic mediaWiki detection, and removed specific site support, so that Simplepedia will just work on any MediaWiki you throw at it
    * Added proper search form submission detection using each pages built in search form
    * Reverted to auto-updating via Another Auto Update Script by sizzlemctwizzle ([http://userscripts.org/scripts/show/38017](http://userscripts.org/scripts/show/38017 ))
    * GreaseKit users: You will need <http://userscripts.org/topics/21030>
    * Opera users: You will need <http://www.howtocreate.co.uk/operaStuff/userjs/aagmfunctions.js>
  * Version .9.1 April 30, 2009
    * Fixed front page WikipediA logo (wikipedia moved it)
    * Dumped firefox specific auto-updater in favor of pure js version by Jarett ([http://userscripts.org/scripts/show/20145](http://userscripts.org/scripts/show/20145 ))
    * Fixed http/https mixup when browsing secure sites, simplepedia will now also use https to grab external css
    * Updated front page bookshelves to link to random pages because it makes more sense to me
  * Version .9 April 29, 2009
    * Added auto-updating via Another Auto Update Script by sizzlemctwizzle ([http://userscripts.org/scripts/show/38017](http://userscripts.org/scripts/show/38017 ))
    * Restored TOC toggle for [auscompgeek](http://userscripts.org/users/87567)
  * Version .8.1.51 April 13, 2009
    * Added support for http://*.intelink.gov/wiki/*, just in case
  * Version .8.2 April 11, 2009
    * Added a simple wikipedia graphic anchor for the main page next to the search bar
    * Swapped the same out on wikipedia.org/
    * Added support for http://wiki.greasespot.net/*
    * Improved user/editor display option
  * Version .8 April 5, 2009
    * Added preliminary support for many more wikis http://en.wikipedia.org/wiki/List_of_wikis
    * with main page bugs calling them all WikipediA
  * Version .7.5 March 30, 2009
    * Reintroduced edit links, page and user login tabs, ++
  * Version .7.2.1 March 25, 2009
    * Added helper functions, basic error checking
  * Version .7.2 March 18, 2009
    * Added basic support for wikileaks.org
    * Added support for secure wikimedia sites
  * Version .7.1 March 17, 2009
    * Fixed front page form elements in Firefox
    * Added default language links to the front page
  * Version .7 March 17, 2009
    * Added 'I'm feeling lucky' and 'Search' buttons to the front portal
    * Reintroduced .noprint content for the main pages
    * Fixed center td border display

