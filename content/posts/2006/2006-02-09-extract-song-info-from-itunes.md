---
title: Extract song info from iTunes
date: 2006-02-09 07:47:00.00 -8
categories: geeky
---
You may or may not have noticed that the song listing on the left is pretty dynamic and recently has included the album cover for the most recently played song.

I used to do this all manually with [an applescript with a bit of shell](http://www.jokerbone.com/misc/mac/CurrentTrack.applescript) that I'd hacked together, running every 10 seconds in a hidden [geektool](http://projects.tynsoe.org/en/geektool/) panel. My script was very very ugly. I uploaded 2008 lines of text that already existed on the other side because it was easier for my ignorant non-programmer skills to produce and broadband with compression can upload a 600K file quick enough to make it not matter. But I knew how lame that was.

I've just finished upgrading to a third party Wordpress plugin, [cg-whattunes](http://www.chait.net/index.php?p=238), which fetches amazon art, accepts the currently playing track and caches it. The nice part is that it caches the history locally for me so I only need to HTTP POST songs using curl as they change.

iTunes still lacks the ability to trigger events on track changing, so I'm still forced to use a good bit of [my old script, modified](http://www.jokerbone.com/misc/mac/cg-whattunes.scpt) to work specifically with cg-whattunes every 10 seconds in a hidden [geektool](http://projects.tynsoe.org/en/geektool/) panel.

Still a nasty ugly kludge, but hay look, album art. Note: If you use cg-whattunes out of the box it won't look like mine on the sidebar, I hacked the output a bit. ;)
