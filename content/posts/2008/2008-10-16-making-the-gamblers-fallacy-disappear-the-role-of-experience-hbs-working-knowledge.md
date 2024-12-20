---
title: ! 'Making the Gambler''s Fallacy Disappear: The Role of Experience — HBS Working
tags: posts
  Knowledge'
date: 2008-10-16 10:51:00.00 -8
permalink: "/making-the-gamblers-fallacy-disappear-the-role-of-experience-hbs-working-knowledge.html"
---
The [Harvard Business School Working Knowledge](http://hbswk.hbs.edu) blog has posted an interesting paper about the gambler’s fallacy, the notion that when presented with random binary events, we tend to identify patterns which we believe will impact future events. As an analyst, this is very interesting.

I wonder if after reviewing six false positive events, having only heard about true positives from third parties, can reaction time to future alerts be expected to slow? Where F is a false positive and T is a true positive, is TFFFFFFF to be handled differently than FFFFFF? Is it incorrect to do so? The paper relates instances where it is correct to subscribe the gambler’s fallacy, and surely identifying a systemic form of false positive with no change to alerting controls is an adequate example.

But what about non-systemic repeat false positives? An alert looking for something simple like a secret word, could first fire on an e-mail, then an instant message, then a file transfer, then an inbound connection to a web server, and all from unrelated sources. An analyst would be wrong to assume the gambler’s fallacy only if the secret word is not so secret after all. If it is indeed secret and the alerts were coincidence, what of no similar alerts for a month, followed by another string of false positives?

What if the analyst can reliably expect a true positive and knows it is only a matter of time? I expect that would prevent the gambler’s fallacy from effecting reaction times, as it is nearly equivalent to being presented with FFFFFFFTFTT after the events have transpired.

Unfortunately unlike experiment and true binary random chance, analyst’s both handle events they can reliably expect, and have control or tuning capabilities of alerts. An analyst can and should tune a control’s or alarm’s sensitivity or volume to prevent FFFFFFFF occurrences but always at the risk of squelching FFFFFTFFF detections.
