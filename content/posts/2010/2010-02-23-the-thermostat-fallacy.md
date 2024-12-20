---
title: The Thermostat Fallacy
tags: posts
date: 2010-02-23 11:21:00.00 -8
permalink: "/the-thermostat-fallacy.html"
---
I've always called this collection of phenomena _thermostat fallacies_, but my dad does HVAC for a living, so, go figure. I'm not even sure that they are proper fallacies.

### The premise

In our cars, the analog dial or lever spanning a blue triangle stacked on a red triangle presents an analog blend of temperatures. At least that's how they used to work. But in analog home thermostats, and increasingly in cars, in multiple zones even, the temperature dial offers "now" and "target" temperatures.

This can confuse the crap out of people.

Anyway, in the car, with the old fashioned thermostat, most of us start out with the dial cranked to _all hot_ or _all cold_ and then adjust to comfort. Being uncomfortable is uncomfortable, we seek its undoing with a vengeance. We don't want the inside of the car to be 85°F in February, we just want it to be 68°, or whatever, faster than if we asked the car vents to spit out 68° degree air.

But home thermostats don't work that way, and not letting that stop the mind from thinking that they do is what I call _the thermostat fallacy_. It has three faces. I'll present them here as design patterns.

### Do not try to put significant figures into an binary bucket

_For example:_ Coming home cold, and raking the analog home thermostat dial up to 85°. If the house is already 64°, setting the thermostat target to 70° or setting the thermostat target to 85° make no difference whatsoever. That's just how the things work. 85° doesn't fit into the _on/off_ bucket, it fits into _stop when_ bucket. The heating and air conditioning is not working harder, it's just running longer, and will eventually [boil the frog](http://en.wikipedia.org/wiki/Boiling_frog).

### Do not represent a binary state with _exclusively_ insignificant figures

This is the inverse of standard thermostat fallacy and better demonstrated in other technologies.

_For example:_ Nearly every instance of numbered badges of unread email, unread RSS and atom subscription articles, unread twitter posts, unread _whatever_ are representing "you have unread items" with "you have a specific-yet-useless number of unread items."

You see, if the badge says _43_ now, and five minutes later, it says _44_, it still only conveys "There is unread email". The number lacks context but it still has to be parsed. More importantly, there is no unit-comparability. _All_ of those messages could be spam, or one could be a life changing job offer, and so on.

### Do not expect insignificant figures to have unit-comparibility

_For example_: Insisting thermostats at separate houses set at the same temperature are creating the same environment in spite of perceived differences in temperatures caused by room layout, thermostat placement, humidity, elevation, and so on.

This is a big one. I consider it an instance of [ceteris paribus](http://en.wikipedia.org/wiki/Ceteris_paribus), or the [all else equal](http://www.stat.columbia.edu/~cook/movabletype/archives/2008/03/the_all_else_eq_1.html) fallacy. It's what leads [people to wonder why Oscar the Grouch](http://www.google.com/search?ie=utf8&oe=utf8&q=dave%20chappelle%20killing%20them%20softly) doesn't just go to college and get a job, damnit.

### So?

Significant figures matter, but when human perception is the target, and not scientific measuring apparatus — lossy compression isn't just okay, it's humane. The mind works better in some cases with fuzzy numbers than specifics. When numbers can't be avoided, keep the thermostat fallacies in mind when working with them.