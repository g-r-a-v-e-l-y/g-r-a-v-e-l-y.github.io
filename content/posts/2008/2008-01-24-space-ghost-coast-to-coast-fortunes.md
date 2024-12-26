---
title: Space Ghost Coast to Coast fortunes
tags: posts
date: 2008-01-24 22:39:00.00 -8
---
The [Bill Brasky](/bill-brasky-fortune-cookies) fortunes never get old. But just in case, I threw together some Space Ghost Coast to Coast fortunes!

[sgc2c.tar.gz](/files/sgc2c.tar.gz).

```shell
[grant@bender var]$ fortune sgc2c
"Did you ever meet Haystack Calhoun? He was a MOUNTAIN of a man."   -Leonard Ghostal
[grant@bender var]$ fortune sgc2c
Space Ghost: So, Zorak, how was your weekend?
Zorak: I, uh, I did some volunteer work over at the orphanage.
[grant@bender var]$ fortune sgc2c
Space Ghost: [looking for Zorak] Green... wears a vest... tall guy...   bald...
Zorak: ...no pants..
[grant@bender var]$ fortune sgc2c
Moltar: This is how I am. I'm destroying the planet!
Denis Leary: Is that so?
Moltar: Yeah. And I'm having a sale too.`
```

Put the contents of that tarball in /usr/share/games/fortune or somewhere similar and enjoy!

I keep this in my ~/.login

```shell
> `[ -x /usr/games/fortune ] && /usr/games/fortune brasky sgc2c   `
```