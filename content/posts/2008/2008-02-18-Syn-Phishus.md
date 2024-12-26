---
title: Syn Phishus
tags: posts
date: 2008-02-18 11:07:00.00 -8
---
I have [nice things to say](/shmoocon-2008) about the rest of the con.

> **Baked not Fired: Performing an Unauthorized Phishing Awareness Exercise**
> _Syn Phishus_
>
> This talk will illustrate how, without getting fired, to perform an unauthorized internal phishing exercise within a large corporation to raise security awareness and demonstrate why processes need to change. The phishing attack was orchestrated to allow incidence response to quickly determine the author and support the forensic investigation that followed. _Phishing is easy_; this is how to stand up and rock the boat hard while remaining on board.

Phishing is easy to do. ~~An insider~~ Anyone can perfect the timing, presentation, and content enough to fool the people in the cubes on either side of you. But that doesn’t prove anything. It is a basic violation of the simple trust we all place in e-mail and the only things keeping you smart folks from falling for it is how poorly it is usually done, and your tinfoil hats.

[Public research suggests that](http://www.scientis.com/Security/Phishing.html) it is hard to pin down the percentage of recipients that will download and execute malware delivered to look like corporate communications but it is somewhere between 5% and 30%. If I was in corporate communications I would be disheartened – that is the same cohort that actually skims corporate communications.

That this threat has been around long enough to earn it’s own cutesy-hacker-name when it is just standard fraud is a great bullet point in the why-column for the usual controls (antivirus, nac, filtering, etc…), [comprehensive network security monitoring](http://taosecurity.blogspot.com/2007/12/does-failure-sell.html), and [logging absolutely everything](http://www.loganalysis.org/).

Presenting these findings to management might require some writing and maybe the patience to dump the data into a power point slide. A rogue drill of the incident response team isn’t a bad idea either. A planned drill of other business units with management buy-in and CSIRT awareness might even be nice validation of corporate communication plans asking users to report attacks (note: not to determine the threat / risk).

A rogue drill of other business units is a terrible idea. A poorly executed rogue drill of other business units (Syn accidentally cc’d a large distribution list) due to poor planning is inexcusable.

[Syn Phishus](http://www.linkedin.com/pub/5/038/14A) got a formal reprimand for it.

He then recommended that corporate communications in the future be [digitally signed](http://www.pgp.com/). He didn’t go on to explain how the infrastructure and training required to implement a signed communications initiative actually aligns with the poorly demonstrated unquantified risk. And, he didn’t review other existing controls that help mitigate it. And he didn’t discuss what would happen if his fix actually worked and the threat morphed to social websites, IM, continuing to use e-mail phishing but spoofing vendors instead of the company, and so on. Syn acknowledged that the company had a corporate communications initiative to spread awareness of the threat, but didn’t attempt to quantify its effectiveness. So back to pgp’ing everything.

What percentage of recipients of an incorrectly-digitally signed message would still download and execute malware? HTTPS is such a great success that no one would ever ignore a poorly signed certificate, so he had no reason to discuss it. Right?

I have too much respect for Shmoocon to heckle a presenter but had I gotten a microphone, I would have asked:

[“Where are your brains? In your ass!”](http://www.moviewavs.com/Movies/Hackers.html")