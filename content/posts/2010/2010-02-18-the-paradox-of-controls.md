---
title: The Paradox of Controls
tags: posts
date: 2010-02-18 08:55:00.00 -8
permalink: "/the-paradox-of-controls.html"
---
Given an effectively infinite set of behaviors, and a limited set of actors, the simplest and most common control strategy to restrict the behavior of actors seems to be:

1.  Deny any known forbidden actions.
2.  Permit all other actions.

But consider the numbers involved.

1.  Deny finite known forbidden actions.
2.  Permit infinite unknown actions.

Okay, so for a behavior control equaition that’s something like:

> For _y_ equal to _∞ – n_ finite knowns: ∞ – y = ∞

I’m not good with math. But that’s definitely an infinity over there. OK, so arguably it’s an infinity on both sides and we are playing with imaginary numbers, literally, but I hope the point is still clear.

This actually works quite well in practice. Consider: An escape artist tied to a chair seems to be restricted by a strong control to prevent the undesired action of escape from a room. But the rope leaves the escape artist free to do anything, so long as that thing isn’t one of the many, yet finite, activities that the rope restricts, like, say, escaping, or doing jumping jacks, or square dancing.

Two components of that are interesting.

1.  The control is restricting actions that _aren’t_ forbidden.
2.  The control is allowing infinite unknown behaviors to continue without restriction.

Doing jumping jacks in the room is not escape from the room. Neither is square dancing, however goofy it may be. In fact, forced jumping jacks or square dancing might be better controls than the rope — they are distracting, require dextrous locomotion, and in the case of square dancing, a guard could keep hold of the escape artist’s arm the entire time.

You see, this is when many practitioners argue for defense-in-depth. OK, they say, we’ll lock the room, and we’ll use a strong chair, and we’ll put chains on top of the ropes, and fill the room with water to 8 inches below the ceiling, and so on until you get sick just hearing from them. Escape artists design their tricks to be _loaded_ with defense-in-depth security theater, it makes the escape look less like a foregone conclusion.1

But no matter what, that pesky infinity is still sitting there on the right side of the escape artist’s behavior controls equation. Don’t forget that, because it’s very important. Actually, mind your mediations, it’s a [Lemniscate of Bernoulli](http://en.wikipedia.org/wiki/Lemniscate) sitting there, standing _in for_ infinity. Anyway.

OK, let’s back up and try another thought experiment, with those two points in mind. Instead of wrapping an escape artist, or a prisoner, in controls; consider implementing controls to protect a cohort of data analyst workers at Acme Incorporated™ from risks, with the intent — and this is important too — with the intent that they best be able to spend their time data analysting, whatever that is. Pause for a moment and reflect that Acme’s data analysts are not prisoners becase too many people get tripped up on that. The intent is risk reduction in order to promote data analysting, not just pink and naked risk avoidance.

Sure, sure, we’ll use all the standard controls from our handy principle of least privilege guide-book, restricting risky actions we have enumerated that Acme’s data analysts aren’t even interested in. We’ll use a roof and four walls to keep the analysts and their computers from getting wet every time it storms. We’ll put a guard at the door so that they don’t blow all their cash on cheap art prints from cube-to-cube rogue sales folks. We’ll block ports used by their desktop computer’s file sharing protocols with a firewall between their network and the Internet, because no one with good intentions wants to share files with them over the Internet. OK, you can even use your defense-in-depth principles and put more firewalls in different places, and put a roof over the roof, and put a guard on the guard, but please don’t go too crazy — controls add overhead, both in capital and operationally, because they aren’t free, and after all, what’s the point of a control if it isn’t monitored?

But what about controls that start to affect the analyst’s data analysting work? If we determine that an inline proxy-based web filter is a control we want to implement, how should we configure it? Do we want to restrict the analysts from watching jumping jacks videos or learning more about square dancing? Sure, the naive security practitioner says. Square dancing isn’t data analysting! Neither are any damned jumping jacks!

I promise I’m getting to the point here, we’re almost there. Skip ahead: our Acme data analyst is using the system we’ve designed.

On the web, there are effectively infinite destinations, but most usage patterns start at a search engine and end at a popular media streaming site, popular news site, popular information site, etc.

Consider the bizarre notion that our data analyst, might have some free time, between data sets, and want to learn about the _Allemande Left_, a square dancing call I had to look on Wikipedia to learn about.

‘Denied!’ say the prison wardens.

‘Denied!’ say the defense-in-depth practitioners.

‘Denied!’ say the principles of least-privilege.

‘Denied!’ say the curmudgeonly supervisors unable to suspend disbelief in ‘free time’.

But remember that whole infinity part. The prison wardens and defense in depth folks can only block what they know about, and in this case, things they think are related to things they know about. They think they know that video sites are [bad](http://solipsism.tumblr.com/post/392719309/no-one-knows-what-the-f-theyre-doing-or-the-3).

Let’s exaggerate and pretend that last night’s _The Bachelor_ had a long square dancing element to it, highlighting the Allemande Left. Attackers know this — they are depraved enough to watch _The Bachelor_ too. They’ve spent all night hacking small blogs and turning them into sites about nothing but how great the Allemande Left goes with trojan botnet installers. Search engines have spent all night indexing these Allemande Left & Trojan Botnet Installer sites.

Enter, stage left: An analyst.

“_With free time_“ the choruses remind us.

The analyst searches the Internet: “_Alemand left bachlor_“

The search engine replies: _“That’s silly, here, here are ‘_Allemande Left bachelor_‘ findings”_.

The analyst sees that the first search result is a video of last night’s _The Bachelor_ on a tv streaming site.

**click**

_DENIED! You are violating security policy!_

The analyst returns to the search results and sees the second search result links to a clip of square dancers doing something on another popular user-uploaded-content video streaming site.

**click**

_DENIED! You are violating security policy!_

The analyst returns to the search results and sees lots of garbage sites that look kinda strange, but whatever. The search engine preview says something like: _Allemande Left Alamand Left Square Dancing The Bachelor Allemendy Left The Bachlor The backlet Skware Dansing Allemen…_

We know this is the proverbial wolf in sheep’s clothing.

An aside: ‘Clothing’ is a weird word choice for skin, or fur, or whatever, in that idiom, isn’t it? More importantly, our data analysts aren’t sheep, we are just really paranoid. The data analysts are human. Draw no further conclusions from the silly proverb other than the masquerade idea. Sheep are stupid, our analysts are just ignorant, busy, and have been yelled at twice now for no good reason.

The analyst clicks on the third link, praying for no more _DENIED!_ wastes of time.

_**Pop**_ goes the analysts browser. _**Pop**_ goes the analysts acrobat reader. Silently the computer we are protecting joins a global criminal network and begins attacking websites to fill them with more Allemand Left stories and trojans.

Another aside: The analyst returns happily to data analysting the next data set. Our mission is not impacted. There is a very interesting discussion to be had down this rabbit hole, and I think it ends in a tragedy of the commons mess that will cause us to reconsider if our mission actually _is_ impacted, but that is neither here nor there.see 1 again

Let’s cut our thought experiment off right there because we’ve come to the point: Controls become paradoxical when their restrictions drive actors to alternative behaviors which are equally risky, or in the case of square dancing video trojan botnet installers, much more risky, than the behavior they were implemented to control.

Be ever mindful! Not only are square dancing videos, for the most part, harmless, but they are very much _not_ the multitude of worse things the analyst could be doing with their free time.

Returning to our behavior control equation:

>
> For _y_ equal to _∞ – n_ finite knowns: ∞ – y = ∞


For every harmless element of the set _y_ removed from ∞, the ∞ of available behaviors ratio tips 1 unit more towards undesirable.

As a [design pattern](http://www.43folders.com/2009/01/27/creativity-patterns), try to avoid doing that.

- - -


1 Tomes could be written on this mess, it’s debatable, join any security mailing list and wait for the thread to revive.