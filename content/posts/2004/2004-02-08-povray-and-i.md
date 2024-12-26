---
title: povray and I
date: 2004-02-08 20:28:00.00 -8
categories: geeky
---
![](/images/povray_thumb.jpg)

When I first [got started](http://jokerbone.com/portfolio/image1.html) in 3d-rendering tech, all shapes were created by a process called "extrusion". Improvements in technology eventually brought "primitives", giving artists the ability to insert things like spheres, cones, blocks, stars and [teapots](http://sjbaker.org/teapot/). Current tech allows primitives to be sculpted like stone and rapid application of smart textures that remove the need for detailed mesh modeling.

But this was before we had that fancy shit. A block is the easiest extrusion -- start with a rectangle of length and width and give it height (generally along the z access -- the line pointing at you), leaveing the shape alone throughout the raising process. Voila. A sphere is a bit trickier. Take a circle of zero diameter, give it height and increase diameter in a non-linear but simple curve until the midpoint and then reverse the rate of change as you decrease the radius to zero again.

Of course you can imagine how difficult it is to generate truly complex shapes via extrusion. I made the linked guitar body using graph paper and an estimated curvature on a rough six different slices spread throughout the extrusion. Software took care of the interpolation making the transitions smooth. Were I to lathe the actual guitar (like printing a drafting in 3d), I'm sure the low resolution of my work would have been highlighted.

PovRAY doesn't have extrusion. PovRay, as I know it, doest not have any drawing whatsoever -- it is pure math. Geeky. Neato.

The previous post's fancy generated [fractal shape](http://astronomy.swin.edu.au/~pbourke/fractals/quatjulia/) renders quickly at low-low resolution but takes a few hours at standard size. I tweaked the colors used and that worked. I tweaked the input numbers and the shape disappeared.

I'm curious if any of you can get some interesting shapes out of the template. Povray is free software -- google for your flavor (nix/mac/win32) and give it a shot!
