---
title: Putty as a Cygwin Shell
date: 2006-09-22 14:34:00.00 -8
categories: geeky microsoft
---
If you already have a working bash shell and are just looking to extend bash's tab completion capabilities, do not pass go, proceed directly to [Ian MacDonald's programable bash completion project](http://www.caliban.org/bash/index.shtml#completion). Then read the rest of his advice, it is excellent.

To skip bash completely and try an entirely new shell, give [fish](http://fishshell.org/screenshots.html) or less crazy, [zsh](http://zsh.sourceforge.net/FAQ/zshfaq01.html#l4) a shot.

If you are looking for bash in Windows and Cygwin help, continue reading.

`cmd.exe` is really terrible.

There are hackish Unix workarounds but none that really come through. Cygwin's default install leaves us with the Cygwin Bash Shell, which is just bash running in (drumroll please) cmd.exe. It also comes with rxvt.exe which is fast and actually a terminal and instead of just a process running within cmd.exe, but it isn't easily configurable and has a nasty looking scrollbar.

Mark Edgar's [PuTTYcyg](http://code.google.com/p/puttycyg/) to the rescue!

It's easy.

Install [Cygwin](http://www.cygwin.com/). This should give you a working unix environment, home directory, shell, and Cygwin bash shell. Launch the included Cygwin Bash Shell shortcut to remind yourself how lame it is. It uses cmd.exe! Gross! It should dump you in your home directory.

Download the [latest release of Mark Edgar's patched PuTTY executables](http://code.google.com/p/puttycyg/). I like to keep all that stuff in ~/bin, which is in c:\home\bin on my laptop. You probably want to add c:\home\bin to your PATH environment variables in windows. Yours might be different. If you aren't sure, type "set | grep -i home" in the default Cygwin shell to find out.

Launch the putty.exe you just extracted. It looks like the normal Putty GUI but there is a new connection type radio button labeled Cygterm. Select that. Label it whatever you like, I call mine 'local' and hit save. Then click the Open button and you are off!

![Cygterm](/images/cygterm.jpg)

You should probably go back and tweak your shell settings now that you have a working shell in windows. From the top-left corner context menu, select "Change Settings…"

I like to enable logging, use a lighter gray background, turn on the visual-bell and blinking cursor, and modify all of the colors assignments. Once you are happy, go back to the top "Session" menu and save your session over your 'local' bookmark.

![My shell](/images/cygterm-local.jpg)

NB: [Not all dos commands work well within PuTTYcyg](http://code.google.com/p/puttycyg/wiki/FAQ). Some of the sysinternal tools (pstools for example) that request passwords misbehave and are useless. Keep in mind that the shell is interpreted like a unix shell, so you'll need to escape backslashes and so on.

Now go back to the cygwin setup and grab bash and [bash completion](http://www.caliban.org/bash/index.shtml#completion). You will need to add the bash completion files to your startup by sourcing it in a bash dotfile like .bash_profile or .bashrc

```shell
if [ "$PS1" ] && [ $bmajor -eq 2 ] && [ $bminor '>' 04 ] \
  && [ -f /etc/bash_completion ];
  then
  # interactive shell
  # Source completion code
  . /etc/bash_completion fi
```

To jump right to your shell and have a shortcut in your quicklaunch or on your desktop, use Putty's [-launch](http://www.chiark.greenend.org.uk/~sgtatham/putty/faq.html#faq-startsess) flag.

![](/images/cygterm-shortcut.jpg)

I'm always looking for something better, let me know if it's out there!