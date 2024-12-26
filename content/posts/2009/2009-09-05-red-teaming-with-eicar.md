---
title: Red teaming with EICAR
tags: posts
date: 2009-09-05 10:35:00.00 -8
hasAsides: true
disclaimer:
  text: This post has ben edited to be less.
---

{aside}The **EICAR test file** (official name: **EICAR Standard Anti-Virus Test File**) is a file, developed by the [European Institute for Computer Antivirus Research](http://wikipedia.org/wiki/EICAR), to test the response of computer [antivirus](http://wikipedia.org/wiki/Antivirus) (AV) programs. The rationale behind it is to allow people, companies, and AV programmers to test their software without having to use a real [computer virus](http://wikipedia.org/wiki/Computer_virus) that could cause actual damage should the AV not respond correctly. EICAR likens the use of a live virus to test AV software to setting a fire in a trashcan to test a fire alarm, and promotes the EICAR test file as a safe alternative.{/aside}

Testing antivirus software with EICAR[^eicar] deletions one virus at a time is effective but one dimensional. Successful deletion of a single EICAR string validates antivirus software for a given system, in a given directory, at the rate of one virus per unit of time. But single EICAR string deletions do nothing to stress secondary system alerting capabilities, validate rate limiting rules, enumerate directory level exclusions, validate reactive policy changes, and so on.

That later group all seem like fun, useful-to-have validation capabilities, so with them in mind, I wrote eicar based malware for a red team drill, leveraging EICAR to enumerate directory level antivirus exclusions.

The attack I wrote for the drill skipped system compromise.

The components of this attack were designed to replicate real world attacker techniques, while avoiding real world obfuscation techniques that would turn this drill into a _receive alert & down the host_ drill.

### A few simple subroutines

1. DNS command and control – Every few minutes, interrogate a public internet DNS server for an A record. This hostname was under my control, and returned a resource record pointing to 127.0.0.1. If this changes to anything else, proceed to...
2. EICAR antivirus directory level exclusion enumeration – start at the root of `C:\` and interrogate every listing found. If it is a directory, drop an EICAR file in it. Immediately interrogate the EICAR file. If it still exists, push the directory name into the `findings` array.
3. After enumerating all of the directory level exclusions, choose one at random and download more reconnaissance tools from internet servers.


### Why drill like this?

Each subroutine increases the time-to-response requirements. The DNS subroutine could run for days, the EICAR test will interrogate a full system in minutes, tools can be downloaded in seconds.

Each subroutine highlights disparate detection technologies, placement, logging, and so on. EICAR throws incident responder assumptions because it is very much an infrastructure testing tool and not malware.

### spray-eicar

I've ripped out all the command and control and tool downloads. Sorry, it was rubbish anyway and you can do better.

But you can have the perl that can be compiled with perl2exe sort of tools, I've posted it on github as [spray-eicar](/files/spray-eicar.pl).

### Weaponizing EICAR?

OK, maybe it isn't actually weaponizing EICAR. What else could be done with this trick?

* Enumerate file level antivirus exclusions: Find .exe file -> determine if it is an active process -> move it to $filename.bak -> drop EICAR -> undo.
* DDOS secondary alerting systems: Execute spray-eicar enterprise wide on all desktops. Ouch. Can your antivirus product whitelist EICAR even if you want it to?
* Stop at the first finding. Pull and run tools. Obviously.
* Stop at the first subroutine and then propagate to enumerate policy homogeneity.

And so on.