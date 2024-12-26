---
title: linux kernel dev cycle
date: 2004-08-17 22:12:00.00 -8
categories: geeky
---
non-geeks: Groups can only e-mail a document back and forth to work on it at certain sizes. When it's a few million lines it has to be maintained in one place and changes (patches) need to be inspected one at a time because hundres of people are throwing them in rapid-fire. Impressive account of a speech about stats about the developement of the linux kernel after moving from old-and-busted(CVS) to new-hotness(BitKeeper) versioning systems:

> Pre-Bitkeeper, this is how they did it: maintainer sends patches to Linus. Wait. Resend if patches dropped. Lather, rinse, repeat.

> January 2002 - patch penguin lkml flame fest. Worried about patchs getting dropped. Linus decided to use BitKeeper, 2.5.3 first kernel. "License weenies got their panties in bind, ah feh." (Greg is like the Vin Diesel of kernel dev: I keep expecting him to shout "I! LOVE! THIS! DEVELOPMENT CYCLE!!!".)

> BitKeeper change things a lot. Bitkeeper maintainers got a lot more work. Linus sucks in all patches, discarded crappy stuff. Non-bk maintainers just sent patches as it goes.

> Unexpected consequences: we knew what Linus was doing, so much better feedback. Bk2cvs and bk2svn trees. bkcommits-head mailing list so you could you see what was flying around.

> All patches started to go through Andrew Morton; BK stuff goes through Linus.

> **Result: 2.6.0 = Two years of dev, 27149 different patches, 1.66 patches per hour. At least 916 unique contributors. Top developers handled 6956 patches. Ten patches a day for two years. People should research this data.**

> 2.6.1 538 patches. 2.6.2 = 1472, 2.6.3 = 863 patches, 2.6.4 1385 patches…. keeps going. bY 2.6.7 2306 patches. Something is wrong. This is the stable kernel, but we're going faster --\- one million lines added, 700 thousand lines deleted: a third of the kernel. A **lot** of data, and this is **stable**. Feeling uncomfortable yet?

I need a new PC. I haven't even booted a 2.5+ kernel. I was in 2.4 land ~2.4.2 praying for usb fixes that 2.2 wasn't up to. A shuttle is in my future.
