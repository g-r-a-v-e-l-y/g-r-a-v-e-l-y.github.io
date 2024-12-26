---
title: Eternal bash history
tags: posts
date: 2007-10-18 11:24:00.00 -8
---
[Debian Administration](http://www.debian-administration.org/articles/543) has great advice for requesting that bash keep a history of all commands recorded. Add this to your .bashrc!

> `export HISTTIMEFORMAT="%s " PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER \ "$(history 1)" >> ~/.bash_eternal_history'`