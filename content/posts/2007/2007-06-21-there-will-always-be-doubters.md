---
title: There will always be doubters
date: 2007-06-21 08:16:00.00 -8
permalink: "/there-will-always-be-doubters.html"
---
And sometimes, [they are even right](http://bytecoder.com/2006/09/28/xerox-1974-ethernet-would-be-a-failure/)...

> Date: March 5, 1974
To: Bob Metcalf and Dave Boggs
From: R. T. Bachrach
Location: PARC - Bldg. 31
Organization: GSL - 44
>
> Subject: Comments on “Draft Ethernet Overview”
>
> I have read with dismay your presentation “Draft Ethernet Overview”. As I am sure you are aware, technically or conceptually there is nothing new in your proposal. Perhaps appropriately, you have chosen a coined jargon utilizing discredited scientific conceptual expression in which to frame your ideas. I find your analysis of the proposed interconnection lacking in technical credibility. Quantitative statistical analysis would show that your proposed system would be a failure. You have tried to adopt a scheme inappropriate to the intended _engineering_ application. A random transmisstion scheme such as you propose, along with the quasi-de-randomizing hardware you invoke to patch the obvious deficiency, would place in fact an undo [sic] hardware, software, and scheduling problem on the individual stations.
>
> You should seriously reconsider your basic premises and formulate fully and logically _all_ the parameters necessary to evaluate the system. Your transmission medium or environment is not quantum noise limited. Simple analysis shows that imposing a [P]oisson (i.e., random) statistics on message transmission drastically reduces the available effective bandwidth. Such a system is effective (reasonable) only in the limit of negligible average bit transmission rates. In fact you will want to maintain as high an effective transmission rate as possible. This requires a _synchronized_ system. The fallacy in your conception is that the stations should be transmitting randomly. One possibility for a syncrhonized system would be time division multiplexing. You should seriously study how the telephone companies handle this problem. For example the A.T.T. long lines T2 buried microwave link multiplexes close to 10[^]7 - 6 KHz channels.
>
> Most importantly, you should fully define your _engineering_ applications before proceeding further. You specify an undefined message packet length, a 1 mile or 1 mile diameter loop and 256 stations working at a 3 Mbs rate. What is the nature of the station? How many bits transmitted does an activity require and what is the expected average rate that the 256 stations will be seeking use of the bus in the comtemplated application? What is a tolerable dead time for a given station to acquire a full set of data? The worst case delay for your 1 mile loop is ~2 usec. What effect does this have on far station getting locked out, etc. . . .?
>
> RTB/Tk
>
> cc: W. K. English
R. W. Taylor
J. I. Elkind
H. H. Hall
>
> [signed: Robert Bachrach]

It is a lot easier to complain without offering solutions in a memo, or a blog comment, or a usenet or mailing list thread. For some reason, in conversation, the same behavior is obviously lame, annoying, counter-productive, etc…

They are so fun to write though.
