---
title: My archives
tags: posts
description: All posts published since the start of of the blog back in 2020.
eleventyNavigation:
  key: Archive
  order: 3
hasAsides: true
disclaimer:
  text: There is a lot of cringe in this old stuff. I wrote most of it in my 20s.
---

Give or take quite a lot of unfortunate data loss over the years, I've been dragging some of these posts around for 25 years through WYSIWYG editors, text editors, self-taught (with a lotta help from my friends) PHP, [Movable
Type](https://web.archive.org/web/20021127162851/http://jokerbone.com/), [Wordpress](https://web.archive.org/web/20041129200618/http://www.jokerbone.com:80/
), [Textpattern](https://textpattern.com/) (the best of the bunch in my opinion), and [octopress](https://web.archive.org/web/20180322055328/http://archives.grantstavely.com/), which is where I left things when I bailed for Twitter and [Tumblr](https://web.archive.org/web/20180330002228/https://grantstavely.com/), which I've also since deleted, and now, [{{ eleventy.generator }}](https://www.11ty.dev/).

{aside}<img
    src="https://v1.sparkline.11ty.dev/120x30/8,10,27,32,86,175,85,99,34,10,7,4/%23123456/"
    width="130"
    height="30"
    alt="Sparkline representing frequency of posts written per year from 1999 to 2011"
    loading="lazy"
    decoding="async"
/><br />
Posts per year, 1999–2011: {{ postsByYear }}{/aside}

The oldest posts kind of predate blogging, but I was dating my updates in ways that made sense to import. The next generation of posts were from when my friends and I used my website as a message board, to make plans, or post about parties we'd just been to, which made sense at the time, I guess? Once I moved to blogging engines, the guest posts taper off and it's just my own bad ideas. In almost all cases, I've only ported over my own posts. Once social networks took off, I mistakenly posted on them instead. Oops.

It seems like every migration, I managed to port some posts to the new thing while accidentally leaving others behind. Oh well. For this archive, I've also more intentionally cut out a bunch of stuff, which is for the best.

{% include "partials/archive.njk" %}

{% include "partials/tag-list.njk" %}