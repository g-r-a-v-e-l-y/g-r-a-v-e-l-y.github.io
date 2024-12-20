---
title: DNS is tricky
tags: posts
date: 2008-07-22 09:44:00.00 -8
permalink: "/dns-is-tricky.html"
---
A possible explanation of the DNS vulnerability got posted on [Matasano Chargen](http://www.matasano.com/log/), an excellent infosec blog. This is neat because Matasano’s principle, Tom, [has already gotten the entire story from Dan](http://www.matasano.com/log/1093/patch-your-non-djbdns-server-now-dan-was-right-i-was-wrong/)—he knows all the details we don’t. It was written well enough, and Tom’s credibility is high enough, to assume it was a draft he had ready to fire off as soon as the exploit was public on the sixth.

It was [pulled very quickly](http://www.matasano.com/log/1105/regarding-the-post-on-chargen-earlier-today/). I have a copy in my Google Reader cache.

I thought it was a bad guess, but the retraction and the [dailydave](http://lists.immunitysec.com/pipermail/dailydave/2008-July/thread.htm) thread that it sourced getting closed (not uncommon there) have me curious. Why publish a thought experiment without captures proving it? Also, I think the post was from an intern’s account on the blog. Oops.

Then Dan Kaminsky [twittered](http://twitter.com/dakami/statuses/864746468):

> “DNS bug is public. You need to patch, or switch to opendns, RIGHT NOW. Could”

[And blogged…](http://www.doxpara.com/?p=1176)

> Patch. Today. Now. Yes, stay late. Yes, forward to OpenDNS if you have to. (They’re ready for your traffic.) Thank you to the many of you who already have.

Which has me (and [many](http://isc.sans.org/diary.html?storyid=4765&rss) [others](http://spiresecurity.typepad.com/spire_security_viewpoint/2008/07/heres-a-thought-if-you-really-want-to-keep-a-secret.html)) convinced that this is legit and we might start hearing about attempts. Did Dan’s hype backfire?

*   [Richard](http://taosecurity.blogspot.com/) is right, the [NAT question](http://blogs.iss.net/archive/dnsnat.html ) is also interesting (and why I have been asking for architecture diagrams lately)
*   This will be trivial to detect on the wire with traditional IDS/IPS
*   I’d like proof of the ‘in-bailiwick’ premise of the last paragraph
*   Dan probably has something better than this but who knows?
*   This has already won a [pwnie](http://pwnie-awards.org/2008/awards.html#overhypedbug), excellent.

*   [US-CERT Vulnerability Notes](http://www.kb.cert.org/vuls/id/800113).
*   An [excellent executive summary](http://www.ioactive.com/DNSExecutiveOverview.pdf) of the vague version of the vulnerability.

ƒ