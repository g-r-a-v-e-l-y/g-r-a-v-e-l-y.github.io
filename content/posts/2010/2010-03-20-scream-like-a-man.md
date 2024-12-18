---
title: Scream Like a Man
tags: posts
date: 2010-03-20 11:28:00.00 -8
permalink: "/scream-like-a-man.html"
---
### Text Adventures

You see an article or a twitter toot or whatever.
> read the thing
 
You see a link that looks interesting.
> click the link

You just made be <a href="http://blog.last.fm/2009/02/23/techcrunch-are-full-of-shit">Mike Arrington</a> some cash.
> <a href="http://www.marco.org/244246945">undo</a>

I'm sorry, I don't understand "undo"
> damnit

Swearing won't help. 

### Enough of that

No thanks, right? I mean it's all well and good to just close the tab, of
course, when you go to a site you don't want to work for, but the ads have
already loaded. That's [revenue](http://arstechnica.com/business/news/2010/03/why-ad-blocking-is-devastating-to-the-sites-you-love.ars). Gross.

The web isn't a passive medium. These links can be fixed go to better sites.
The web isn't a passive medium.

So I made [this greasemonkey script](/files/scream.user.js) to zap all links
to all the sites I don't want to work for. Zap them dead. If it's too late—say
a shortened url tricked me—I'd rather see a [goat scream like
man](http://www.youtube.com/watch?v=L0-lkl9TzsU) than see what a mistake I
just made, so it does that too. You can edit it to do something less drastic
of course, but where's the fun in that?

Also dude—javascript-massaging the HTML DOM is so relatively simple and easy
that an idiot like me can do it. So should you. Look at this. You can do this.

The web isn't a passive medium.

```js
var url = location.href;
// add all the domains here
var natch = /(DOMAINS YOU WANT TO AVOID GO HERE)\.\w+\//; 

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
```
Run that against the entire web and it turns nasty links into neuters, and
adds ✌ to them so that it's obvious.

Well, _I_ think it's fun.

### [Install the greasemonkey script](/files/scream.user.js)

[(You need greasemonkey for it to work)](http://en.wikipedia.org/wiki/Greasemonkey)

