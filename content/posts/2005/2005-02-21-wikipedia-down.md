---
title: Wikipedia down
date: 2005-02-21 20:39:00.00 -8
categories: geeky
---
Note to self: Never complain about restoring from backup again.

[![](/images/spy.02212005204632.thumb.png)](/images/spy.02212005204632.thumb.png)

I'm curious if [Ben](http://www.electricfork.com/) and [Aaron](http://www.outerbody.com/) can account for their whereabouts this evening and if a witness could corroborate. (no you'll never live that down)

**Update**: Go figure, the wikipedia so-sorry notice updated itself with more details a few times since I posted ;)


>
What happened?
>
> At about 14:15 PST some circuit breakers were tripped in the colocation facility where our servers are housed. Although the facility has a well-stocked generator, this took out power to places inside the facility, including the switch that connects us to the network and all our servers.
>
> What's wrong?
>
> After some minutes, the switch and most of our machines had rebooted. Some of our servers required additional work to get up, and a few may still be sitting there dead but can be worked around.
>
> The sticky point is the database servers, where all the important stuff is. Although we use MySQL's transactional InnoDB tables, they can still sometimes be left in an unrecoverable state. Attempting to bring up the master database and one of the slaves immediately after the downtime showed corruption in parts of the database. We're currently running full backups of the raw data on two other database slave servers prior to attempting recovery on them (recovery alters the data).
>
> Update 19:20 PST: We have at least one database server with intact data. When we have a second up and running, we'll be able to put the site back online in read-only mode as we continue.
