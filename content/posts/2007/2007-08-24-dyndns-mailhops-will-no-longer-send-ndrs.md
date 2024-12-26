---
title: DynDNS Mailhops will no longer send NDR's
date: 2007-08-24 16:33:00.00 -8
---
Emphasis mine.


> Dynamic Network Services, Incorporated has come to a difficult decision regarding the handling of locally-generated non-delivery reports (NDR), also known as "undeliverable mail" or "bounce" messages. DynDNS will no longer deliver **locally-generated NDRs** from any MailHop systems.

> It is through our operational experience that we believe that the exploitation of this behavior has begun to far exceed its original informational purposes. Specifically, spammers and other Internet-abusers are using this behavior to distribute spam, malware, and to otherwise cause troubles for e-mail systems It has become common for spammers to forge originating e-mail addresses and to then send large spam runs against different servers. When this happens, DynDNS sometimes receives these messages, which cannot be delivered or worse, get bounced back to the original forged sender, who now gets the spam in his or her inbox (a.k.a. spam blow back).
>
> We simply feel that this is not the right thing to do.

I've been doing this for a few years for clients that used the spam filters I set up in front of their exchange servers. All sites should do this. RFC's are not holy territory; they were designed by teams and committee's operating under assumptions that do not at all match the internet infrastructure or user-base.
