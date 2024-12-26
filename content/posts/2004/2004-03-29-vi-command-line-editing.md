---
title: vi command line editing
date: 2004-03-29 06:52:00.00 -8
categories: geeky
---
![](/images/bash.s.gif)I've always been annoyed at my lack of ability to be [annoyed](/000481.php) with [bash](http://www.gnu.org/software/bash/bash.html)'s default to emacs-style command line editing long enough to learn simple emacs commands.

> set -o [vi](/000364.php)

Problem solved. Add it to your bashrc. Play with your history with /., esc:0 to the beginning of a line, w, b, j, k, x, dd around or jump with /. Leave that pesky ctrl key to things you don't do very often like exiting the shell.
