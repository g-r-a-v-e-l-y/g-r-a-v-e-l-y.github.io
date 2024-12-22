---
title: Logging incident handler activity on the console
tags: posts
date: 2008-04-28 13:33:00.00 -8
permalink: "/logging-incident-handler-activity-on-the-console.html"
---
During incident handling, time is precious. I try to make myself take notes and communicate about the incident over logged channels like e-mail and IM - to the point that I think some team members have rules specifically for e-mail from me.

The detailed timelines that can be reconstructed from these notes are crucial when preparing post-mortem documents!

> I have a simple philosophy: Fill what's empty. Empty what's full. Scratch where it itches Script the process wherever possible.
>
> — Alice Roosevelt Longworth (and Grant Stavely)



Initially, I thought [bash history](http://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#index-histchars-186) could help.

```shell
# Bash settings
export HISTTIMEFORMAT="%s "
export HISTCONTROL=ignoredups
export HISTFILESIZE="9999999"
```

But what about the command output? There is a better way:

Firstly, and this is something that took getting used to, set up [a fancy shell prompt](http://www.linuxselfhelp.com/howtos/Bash-Prompt/Bash-Prompt-HOWTO-6.html) to provide the log with context and time stamping:

```shell
--(grant@sensor)-(1/pts/1)-(17:32:33-UTC/28-Apr-08)--
--($:/nsm/)-
```

Gross! A two-line shell prompt! Trust me, it's useful.

Then just add to your shell start-up:

```shell
# start script to log everything now!
exec /usr/bin/script -f /nsm/var/handlerlog/$USER.shell_log.` date +'%Y-%m-%d:%H:%M:%S' `.$$
```

Script will then log everything that prints to the console with the prompt providing context.