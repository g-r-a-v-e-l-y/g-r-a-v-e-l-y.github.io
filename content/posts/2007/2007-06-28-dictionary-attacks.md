---
title: Dictionary Attacks
date: 2007-06-28 11:27:00.00 -8
---
We've all been asked to use passwords that are more than just a word that could be found in the dictionary…

Waiting for a conference call to start I took a look at a dictionary attack in a live packet capture I had running. In this case, the attacker is trying to log into an FTP server.

```shell
[root@sensor-## active]# strings grant.20070628-104057.ftpscan.i.p.add.ress.lpc | grep -a PASS | grep -ao '[^ ]*$'

antagonism
antagonisms
antagonist
antagonistic
antagonistically
antagonists
antagonize
antagonized
antagonizes
antagonizing
antarctic
Antarctica
Antares
ante
anteater
anteaters
antecedent
antecedents
antedate
antelope
antelopes
antenna
antennae
antennas
anterior
anthem
anthems
anther
anthologies
anthology
Anthony
anthracite
anthropological
anthropologically
anthropologist
anthropologist
anthropologists
anthropology
anthropomorphic
anthropomorphically
anti
antibacterial
antibiotic
antibiotics
```

And so on…

The blank lines contained passwords that I've removed, some because I recognized them as real passwords for FTP users, some because they did not fit the pattern of starting with the letter 'a', suggesting that they were legitimate passwords of which I was not aware.

I like that proper names are capitalized and that the signal/noise ratio causes outliers to jump off the screen. I dislike that the server is [running IIS6](http://secunia.com/product/1438/?task=advisories), which has a good vulnerability history but completely lacks any configurability to react to this sort of attack.