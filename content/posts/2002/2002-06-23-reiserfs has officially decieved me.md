---
title: reiserfs has officially decieved me
date: 2002-06-23 14:24:00.00 -8
categories: general
---
Welp, reiserfs has officially decieved me.

```shell
Kernel Panic: Unable to mount root filesystem on 03:07
> reiserfsck --rebuild-tree /dev/hda7

[UNCORRECTABLE ERROR] SECTOR 110!

[UNCORRECTABLE ERROR] SECTOR 111!

[UNCORRECTABLE ERROR] SECTOR 112!

[UNCORRECTABLE ERROR] SECTOR 113!

[UNCORRECTABLE ERROR] SECTOR 114!
```

It then makes it to about 133 before aborting and dying. Good times indeed.

For those not in the know, that means, I just lost my / linux partition with all of my data on it. Suck suck suck.

Edit: No seriously - this fucking sucks. hard. =/

