---
title: xfree tip -- vim will thank you
date: 2003-09-14 10:04:00.00 -8
permalink: "/xfree-tip-vim-will-thank-you.html"
categories: linux
---
	<p>> cat .xinitrc | grep xmodmap
	<ol>
		<li>xmodmap to turn caps lock into another shift key</li>
	</ol><br />
xmodmap -e &#8220;remove Lock = Caps_Lock&#8221;<br />
xmodmap -e &#8220;remove Shift = Shift_L&#8221;<br />
xmodmap -e &#8220;keysym Shift_L = Caps_Lock&#8221;<br />
xmodmap -e &#8220;keysym Caps_Lock = Shift_L&#8221;<br />
xmodmap -e &#8220;add Lock = Caps_Lock&#8221;<br />
xmodmap -e &#8220;add Shift = Shift_L&#8221;</p>

	<p>Why? Because this is damned annoying:</p>

	<p>E492: Not an editor command: WQ</p>

	<p>Unless of course, you&#8217;ve modded your computer to use an <a href="http://www.ahleman.com/ElectriClerk.html">Underwood</a> typewriter as a keyboard.</p>

	<p>Similar to this snippet from my .bashrc ;)</p>

	<p>	<ol>
		<li>Silly aliases that actually help</li>
	</ol><br />
alias :q!=&#8220;exit&#8221;<br />
alias :wq=&#8220;exit&#8221;<br />
alias :q=&#8220;exit&#8221; </p>
