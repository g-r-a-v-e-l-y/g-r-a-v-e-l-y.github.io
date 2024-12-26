---
title: Ubik, the fortune file
tags: posts
date: 2008-12-23 10:34:00.00 -8
---

The text ads on facebook and google make me think of [ubik](http://en.wikipedia.org/wiki/Ubik), and with the power of greasemonkey, it's possible to actually make them all _for_ ubiq - so many use proper nouns that it should be a simple regex.

> Tired of the same old message of the day? What's a unix user to do? Simply install our patented [ubik](/files/ubik.tar.gz) fortune database wherever you keep fortune files! Safe when used as directed. Do not use internally. Do not execute the ubik fortune database. Do not run as root. Do not add to your login.

Start with a basic ad.

> Pay your bill on time. Chase +1 rewards you when you pay your bill on time. Apply now for Chase +1.

Munge it with something like…

```perl
$ad =~ s/[[A-Z]+[a-z]]+/Ubik/g; `
```

And get:

> Pay your bill on time. Ubik +1 rewards you when you pay your bill on time. Apply now for Ubik +1.

But it's not very easy to take:

> With the Intel® Core™2 Duo Processor, the HP TouchSmart PC gives you all the power you can handle. Get the magic now.

And programatically get:

> With the Ubik, the HP PC gives you all the power you can handle. Get the magic now.

I'll play with it.

In the meantime, I wanted to grab some Ubik ads to make sure it was going to make sense. Once I [had them](/files/ubiq.txt), I compiled a [fortune file](/files/ubig.tar.gz). Enjoy!

```shell
> fortune ubik
Friends, this is clean-up time and we're discounting all
our silent, electric Ubiks by this much money. Yes, we're throwing
away the blue-book. And remember: every Ubik on our lot has been used
only as directed.

> fortune ubik
"Tired of lazy tastebuds?" Runciter said in his familiar gravelly
voice. "Has boiled cabbage taken over your world of food? That same
old, stale, flat, Monday-morning odor no matter how many dimes you put
into your stove? Ubik changes all that; Ubik wakes up food flavor,
puts hearty taste back where it belongs, and restores fine food
smell."

> fortune ubik
I am Ubik. Before the universe was, I am. I made the
suns. I made the worlds. I created the lives and the places they
inhabit; I move them here, I put them there. They go as I say, they
do as I tell them. I am the word and my name is never spoken, the
name which no one knows. I am called Ubik, but that is not my name. I
am. I shall always be.
```

[Download](/files/ubik.tar.gz)
