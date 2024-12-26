---
title: New Server
date: 2007-01-24 20:13:00.00 -8
categories: plans geeky
---
[Aaron](http://www.outerbody.com/) put me in charge of setting up the new server that will replace the server on which this site and about 20 other domains w/ mail and websites, databases, and so on are hosted.

We are using [FreeBSD](http://www.freebsd.org/) again. 5.5-RELEASE this time.

We are shooting for a combination hardware-refresh and something a bit more scalable for what goes on: virtual users, robust imap and webmail, spam and malware filtering, a bit tighter security, and anything else we want to do.

Today [Exim](http://www.exim.org/) with [Spamassassin](http://spamassassin.apache.org/), [openssl tls (using self signed keys)](http://www.openssl.org/), [clamav](http://www.clamav.net/), and [Cyrus SASL](http://asg.web.cmu.edu/sasl/) have all been installed and configured and are working.

:dance:

I'm looking to use [Cyrus](http://www.exim.org/eximwiki/CyrusImap) for imap but the documentation isn't exactly a series of easy to follow steps.

I'm also looking forward to trying [Roundcube](http://www.roundcube.net/) webmail. Neato.

This is all putting off the obvious tricky part: migrating user website, SQL databases, mail, home directories, and accounts for some and virtual accounts for others.

Exciting stuff.

Currently fighting:

~~Cryus-sasl wants to link to db43, Cyrus-imapd wants to link to db3.
They need to auth to the same database. Result: imapd signal 11
crashes.~~

Authentication: Should sasl use its own Berkely DB to store passwords? PAM? And then should exim and cyrus-imap use sasl or mysql? What about the dozen or few virtual users? mysql? mysql linked to pam? :gonk: