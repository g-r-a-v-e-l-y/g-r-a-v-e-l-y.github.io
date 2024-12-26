---
title: How I Decoded the Verizon 2009 DBIR Cover
tags: posts
date: 2009-04-27 15:02:00.00 -8
---
I was the first to solve the [Verizon 2009 Data Breach Investigations Report](http://www.verizonbusiness.com/products/security/risk/databreach/) cover. [Chris Eng's similar write-up](http://www.veracode.com/blog/2009/04/decoding-the-dbir-2009-cover/) is excellent and perhaps more in the spirit of defeating a challenge of the sort.

That wasn't how I solved it though.

![2009 Verizon DBIR cover](/images/2009-dbir-cover.png)

Below lie spoilers. You've been warned.

I have no idea what I'm doing when approaching a cryptographic challenge. My
background is in art.

I approached the challenge naively unaware it even _was_ a challenge. A
designer had been asked to put 1s and 0s on the cover of the report
because hey, it's about computer stuff right? That's what I thought at least.
I've been asked to do that sort of thing, and copy and pasting finger-mashed
1s and 0s is boring. I always made an effort to make my gibberish _mean
something_. At the least, I'd find Cicero's [lorem ipsum dolor sit amet](http://is.gd/35FY) et cetera ad nauseum.

I assumed something amusing would be there but didn't bother much with it. It
was 5:30AM and the report made better coffee reading than the cover. When I
reached the end though, I [found the major clue](http://twitter.com/grantstavely/status/1524420451).

So I tweeted about it.

> _Verizon Breach Report, page 48: Notice it? It's 2 searches away from
WikipediA. Common cipher lore? Neat regardless! <http://is.gd/sxkL>_

By two searches away from WikipediA, I meant, as [others have noted](http://blog.internetnews.com/agoldman/2009/04/dbir-code.html) that it was a one-hit google search at the time, for a [geocaching clue](http://www.geocaching.com/seek/cache_details.aspx?guid=004f66fe-0817-49e3-abc8-e6ee4c2cae39
).

Handy. Even handier is the 'decrypt' link on the geocaching site, yielding the
original text, _le chiffre indéchiffrable_. Seems like an obvious clue! As I
related in my tweet, that led me straight to the WikipediA article on the
[Vigenère cipher](http://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher).

So then I read up on Vigenère. I'm kind of into just [hopping through WikipediA](http://userscripts.org/scripts/show/42312). I read up on Caesar ciphers, of which rot-13 is one. I [joked about it on twitter](http://twitter.com/grantstavely/status/1524442510) and went back to [syndicated](/suggested) feeds and twitter, then drove to work.

> _What is The Verizon Breach Report cover binary text? [http://is.gd/hafb](http://is.gd/hafb ) please be Clutch lyrics, please be Clutch lyrics, please be Clutch l-_

At the office, I asked a few co-workers if they had noticed the clue on page
48, and showed them that the cover text was probably something. I had no
idea what, but hey presto, let's give it a spin.

I threw the source 1s and 0s into Vim and got rid of all the newlines.
Nothing useful. Then I tossed the single long line into TextMate to play with
wrap points.

While shifting it around in Textmate I noticed a pattern.

> _A pattern emerges... <http://is.gd/sz5k> #vzbdir_

![screen shot](/images/spy.04152009101815.thumb.png)

Neat columns, but what does it mean? I didn't know. I was getting tired of
moving the source text around though, and knew it was copy and pasted a few
times, because I was still going on the naive 'it is nothing or it is funny'
approach. I selected the first line and searched-all in TextMate. Four hits on
lines 101, 201, etc... I did the same for the second and third lines. Sure
enough, only the first 100 lines were unique. Oh well that proves nothing,
[back to work](http://twitter.com/grantstavely/status/1525541305).

> _Only the first 100 lines matter. Off to blue team, will have to resume
after lunch. Argh, obviously a Vigenère. <http://is.gd/sz5k> #vzbdir_

After my morning meetings, I decided to keep at it through lunch. After
talking to my friend [Ben](http://electricfork.com/), we agreed I should just
script out ascii one letter at a time whether that was what I was looking at
or not. All the easy to find online ascii-binary converters wouldn't accept
it. I read up on perl's pack() and threw this together.

```perl
#!/usr/bin/perl -w
# bin-to-ascii
my $binary_text = shift;
open (BINARY, $binary_text) or
    die "Can't open input file: $!";
foreach my $line () {
    my $length = length($line);
    my $hex = pack("B$length", $line);
    print "$hex ";
}
```

Simple enough, what does that yield?

```
evntxigyimwsneheiefotxbscwyhrqmwguzabvycbbfreyfbvedkevmfri
fngfnrbfgvksfpnbufzjgceeewakhpxebtzjczowgtbsqgtmiaydpydriryetkcjrpyhepwkuoa
eknvtvzhsmznttivikmmrysnuiakbrkqmstycgccrlrriirefgytjubuxheysgleyrvhiyxdeyzcj
kvtosoixjehoxevmwjbnzmtkwzefofcnbwncuwmyfiuvbkwnpwtyoeyqtirryrcmnvfvlrsbn
tpwpaoczpekhlfceerrvwvuybvjpuvpoaymikqqnswzghzkdgylaegwpkesgcyzfvjdmepq
ksslnvsvpuvvrvyerhdtutyymqgevwrmqszfnpnrjiggwajnnjlkoeqhnetrpuqydfzwczkvje xlm
ckcsiftctsutldrrmikqtninpgrpqqxptzdpaiotceuazfewdqllpzrhxlxqgslrjtblzrirvisnzi
wl mvyadvohfevnakkgorrxsygxpumvgbomrjlcrefcmrqvxtmiymjjvhxnbtszmtjefkfgkurfl
nhxpkcwlexmiylgynnrwaksewthpkgzkkxgazellutayciekwishundkekwargbyzfgkepkqg
zzsrimflgkarturainsngeeumexrveelzxtisuwvzkoyltpbhzweoqwnxnpxpkssxjhpancvfpr
yadrlroewebqewhzrgatzdguceklfyhzjnnzijrgnzrvbocauyezgkpsjxjiasmvftdwfxbidhqz
eykdrtdrioppkjrpisskmczjfztbvbjugeyanjigjtdcptzdeogutlzpekhtnihtggumvgbomrjlcr
efswfzocroheau
```

Whoa! Letters! [Chris Eng](http://www.veracode.com/blog/2009/04/decoding-the-dbir-2009-cover/) got this far immediately with a shell one-liner: sick fu!.

I had no idea how to attack the Vigenère but given the clue on page 48, that's
where I had to start. I read up on [brute forcing Vigenère](http://www-rohan.sdsu.edu/~gawron/crypto/lectures/vigenere.html). Yikes. If it's possible, I can probably find a tool to do it. [I found lots](http://www.google.com/search?&q=decrypt+vigenere+cipher), but the first hit was enough.

I asked [Munsee and Leech's java applet](http://islab.oregonstate.edu/koc/ece575/02Project/Mun+Lee/VigenereCipher.html#demo) to find 5 keys. The first one
looked like a winner.

> crangingdefaultcrrdsntialschangingdlfeultfredentials

A few typo's but that's obviously English. I fixed the typos and used the key
and Munsee and Leech's java applet again to decrypt the text.

> changingdefaultcredentialschangingdefaultcredentials

By the time lunch was over, I'd discovered the source text, [found out it was actually a contest](http://twitter.com/grantstavely/status/1525541305), and submitted my answer.

> _@[alexhutton](http://twitter.com/alexhutton) I just submitted my cipher
text solution. Never done any code breaking before, was a lot of fun!
#[vzdbir](http://search.twitter.com/search?q=%23vzdbir) (now back to work!)_

I got a call an hour later.

I was the first to submit! I'd won!

Congratulate me at [CharmSec](http://charmsec.org/) this Wednesday, and I'll
buy you a beer.

### Update

I just used this old [ascii <-> hex <->binary converter](/ascii-hex-converter)
I keep handy and noticed it would have converted the binary for me. I use it
for hex so much I forgot it handled binary. I didn't need that perl script
after all. Doh.
