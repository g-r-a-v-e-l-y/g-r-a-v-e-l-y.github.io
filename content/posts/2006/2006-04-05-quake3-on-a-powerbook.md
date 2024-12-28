---
title: Quake3 on a Powerbook
date: 2006-04-05 08:50:00.00 -8
categories: geeky macintosh
---
If you want to Quake on a powerbook, the first of many problems you'll face after getting over macs-can't-play-games is that the resolution is funky. Quake 3 has a single widescreen resolution in the GUI but it's not quite up to snuff for my needs, and it never remembers my settings for resolution, color depth, sound quality, and so on…

Fix:

In ~~/Applications/Quake 3/baseq3~~ `~/Library/Application Support/Quake3/baseq3`, create a file named `autoexec.cfg` with the following text in it:


```
seta r_fullscreen "1"
seta r_mode "-1"
seta r_customwidth "1680"
seta r_customheight "1050"
seta r_customaspect "1"
```

That resolution matches my 17" powerbook - adjust accordingly.

Here are a few of the other things I keep in my autoexec.cfg that you may or may not care for, lowering the graphics complexity and disabling/enabling some things for the slightly more experienced quaker:


```
seta com_hunkMegs "1024" // use more than the default amount of ram!
seta com_blood "0"
seta sensitivity "5.5"
seta cl_mouseAccel "0"
seta r_inGameVideo "0"
seta model "tankjr"
seta headmodel "tankjr"
seta team_model "tankjr"
seta team_headmodel "tankjr"
seta g_redTeam "Rudy's"
seta g_blueTeam "Theo's"
seta r_picmip "4"
seta r_detailtextures "0"
seta r_texturebits "32"
seta r_colorbits "32"
seta r_depthbits "32"
seta r_vertexLight "1"
seta r_fastsky "1"
seta r_flares "0"
seta r_dynamiclight "0"
seta s_volume "1"
seta s_musicvolume "0"
seta s_doppler "0"
seta s_khz "11"
seta cg_brassTime "0"
seta cg_drawCrosshair "5"
seta cg_drawCrosshairNames "1"
```

Any of these actually giving me a higher frame-rate is debate-able, most of the tweaks date back to when I was trying to squeeze a playable game out of a voodoo3 card on a PC. Give it a try! If you know of any other tweaks which improve playability, I'm definitely interested!