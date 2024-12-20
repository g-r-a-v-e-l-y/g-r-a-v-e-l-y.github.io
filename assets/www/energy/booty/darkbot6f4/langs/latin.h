#define	I_SPEAK "I speak Latin"
#define	L001(a,b) S("PRIVMSG %s :Non posuisti tesserae, ut ponere tesserae: \2/msg %s PASS \
<tessera senex> <tessera nova>\2 (quod hoc est tempus primum tuum ponendo tesseram, uti '0' \
quam tesserae tua senex)\n",a,b)
#define	L002(a,b,c) S("NOTICE %s :Delevi permban #%d, %s.\n",a,b,c)
#define	L003(a,b) S("NOTICE %s :Non possum aperire %s :(\n",a,b)
#define L004(a,b,c) S("PRIVMSG %s :%s, Habeo %d SEEN's in basis factorum mea.\n",a,b,c)
#define	L005(a,b) S("PRIVMSG %s :Scis plus illius quam scio, %s.\n",a,b)
#define	L006(a,b,c,d) S("PRIVMSG %s :%s, Non vidi %s %s\n",a,b,c,d)
#define	L007(a,b) S("NOTICE %s :Autotopic in %s erat OFF\n",a,b)
#define	L008(a,b) S("NOTICE %s :Autotopic in %s modo est OFF\n",a,b);
#define	L009(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s ON: %s\n",a,b,c)
#define	L010(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s MUTABAT: %s\n",a,b,c)
#define	L011(a,b,c) S("PRIVMSG %s :%s, peragebam. Habeo %d randomstuffs.\n",a,b,c)
#define	L012(a,b) S("NOTICE %s :Tessera pro %s mutavit.\n",a,b)
#define	L013(a) S("NOTICE %s :Tessera mendosa!\n",a)
#define	L014(a) S("NOTICE %s :Non habeo pari!\n",a)
#define	L015(a,b,c,d) S("NOTICE %s :Cliens delevit: %s [%d:%d]\n",a,b,c,d)
#define	L016(a,b) S("PRIVMSG %s :%s: Divisio pro nihil error!\n",a,b)
#define	L017(a,b) S("PRIVMSG %s :%s: Effectio illicita!\n",a,b)
#define	L018(a,b,c,d,e) S("KICK %s %s :%s (addendo praeteriendo #%d: %s)\n",a,b,c,d,e)
#define	L019(a,b,c) S("PRIVMSG %s :Addendo praeteriendo #%d: %s!\n",a,b,c);
#define L020(a,b,c,d) S("NOTICE %s :Mutabam #%d: \37[\37%s\37]\37 res\2:\2 %s\n",a,b,c,d)
#define	L021(a,b,c,d) S("PRIVMSG %s :%s \37%s\37.. %d nomina investigabant.\n",a,b,c,d)
#define	L022(a,b,c) S("PRIVMSG %s :Inveniebam plus quam \37%d\37 para, si placet coarcta \
investigatio tua\2:\2 %s\n",a,b,c);
#define	L023(a,b,c) S("PRIVMSG %s :Inveniebam \37unum\37 par, %s\2:\2 %s\n",a,b,c)
#define	L024(a,b,c,d) S("PRIVMSG %s :Inveniebam \37%d\37 para, %s\2:\2 %s\n",a,b,c,d)
#define	L025(a,b) S("PRIVMSG %s :Inveniebam %ld res duplices. Amovebantur.\n",a,b)
#define	L026(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Utiendo %s. Habeo %ld res in basis \
factorum mea, Confui: %d dies%s, %02d:%02d, Habeo %ld quaestiones rogabant, %ld res addebant, \
et %ld res delebant. Tempus de ratio: %1.4lf momenta%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L027(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Utiendo %s. Habeo %ld res in basis factorum \
mea, Confui: %d horae%s, %d temporis momenta%s, Habeo %ld quaestiones rogabant, %ld res addebant, \
et %ld res delebant. Tempus de ratio: %1.4lf momenta%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L028(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Utiendo %s. Habeo %ld res in basis factorum \
mea, Confui: %d temporis momenta%s, %d momenta%s, Habeo %ld quaestiones rogabant, %ld res addebant, \
et %ld res delebant. Tempus de ratio: %1.4lf momenta%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L029(a,b,c,d) S("PRIVMSG %s :%s: Delevi res #%ld, \2%s\2.\n",a,b,c,d)
#define	L030(a,b,c) S("PRIVMSG %s :%s\2:\2 Non possum invenire res \37%s\37. Delendo deficiebat.\n",a,b,c)
#define	L031(a,b) S("NOTICE %s :Syntaxis: \2/msg %s PASS <tessera senexa> <tessera nova>\2\n",a,b)
#define	L032(a)	Snow("QUIT :K\2\2illed (%s (Quod dico!))\n",a)
#define	L033(a)	S("NOTICE %s :Syntaxis: UP <canalis> <tessera>\n",a)
#define	L034(a)	S("NOTICE %s :Syntaxis: OP <canalis> [agnomina] <tessera>\n",a)
#define	L035(a)	S("NOTICE %s :Syntaxis: DEOP <canalis> [agnomina] <tessera>\n",a)
#define	L036(a)	S("NOTICE %s :Subtiliter enumera agnomen!\n",a)
#define	L037(a,b) S("NOTICE %s :Temptando /nick %s\n",a,b)
#define	L038(a,b) S("NOTICE %s :Tenta /nick %s-baro.\n",a,b)
#define L039(a,b) S("PRIVMSG %s :Relinquendo %s\n",a,b)
#define	L041(a)	S("PRIVMSG %s :Subtiliter enumera agnomen/canalis!\n",a)
#define	L042(a)	S("NOTICE %s :Intra cliens@hospes purgare!\n",a)
#define	L043(a) S("NOTICE %s :Non quam interdictum.\n",a)
#define L040(a,b) S("PRIVMSG %s :Jungiendo %s\n",a,b)
#define	L044(a)	S("NOTICE %s :Intra cliens@hospes delere!\n",a)
#define	L045(a) S("NOTICE %s :Quidni ago hoc?\n",a)
#define	L046(a)	S("PRIVMSG %s :Exscribebam ex base factorum.\n",a)
#define	L047(a,b) S("NOTICE %s :SYNTAX: %cAUTOTOPIC <res>  (pone ad \"0\" vertere \"off\")\n",a,b)
#define	L048(a)	S("NOTICE %s :Syntaxis: SETCHAN <canales novi>\n",a)
#define	L049(a,b) S("NOTICE %s :Canalis delictum: %s\n",a,b)
#define	L050(a)	S("NOTICE %s :Syntaxis: SETCHAR <littera jussum nova>\n",a)
#define	L051(a,b) S("NOTICE %s :Littera jussum nova jam: %c\n",a,b)
#define	L052(a)	S("NOTICE %s :Syntaxis: SETUSER <cliens novus> (poscit reinitium)\n",a)
#define	L053(a,b) S("NOTICE %s :Cliens delictum jam: %s\n",a,b)
#define	L054(a)	S("NOTICE %s :Syntaxis: SETNICK <agnomen novum>\n",a)
#define	L055(a)	S("NOTICE %s :Syntaxis: ADDUSER <canalis> <*cliens@*.hospes> <planities> <tessera>. \
ie; ADDUSER #darkbot *jason@*.superlink.net 3 tessera-sui ... uti #* si vis dare penetrare ad canales \
omnes.\n",a)
#define	L056(a)	sprintf(temp, "Non utuvi \2%cSETINFO\2 tamen!",a)
#define	L057(a,b,c)	S("NOTICE %s :Addebam cliens: %s - planities %d\n",a,b,c)
#define	L058(a,b,c)	S("NOTICE %s :Syntaxis: %c%s <cliens@hospes> [ratio]\n",a,b,c)
#define	L059(a,b,c,d) S("NOTICE %s :Addebam in permban #%d, %s; ratio: %s\n",a,b,c,d)
#define	L060(a)	S("NOTICE %s :Syntaxis: REPEAT <numerus> <mora> <facta crudi>\n",a)
#define	L061(a)	S("NOTICE %s :Termino.\n",a)
#define	L062(a) S("QUIT :Reinitium %s ...\n",a);
#define	L064(a,b) S("PRIVMSG %s :%s, quid vis addere?\n",a,b)
#define	L065(a,b) S("PRIVMSG %s :Addere quid, %s?\n",a,b);
#define	L066(a,b,c)	S("PRIVMSG %s :%s: Quid res addere pro %s?\n",a,b,c)
#define	L067(a,b) S("PRIVMSG %s :Ita, %s :)\n",a,b)
#define	L068(a,b) S("PRIVMSG %s :Quid reponit, %s?\n",a,b)
#define	L069(a,b,c) S("PRIVMSG %s :%s: Quid res debet reponere %s?\n",a,b,c)
#define	L070(a,b,c) S("PRIVMSG %s :%s, %s mutavit.\n",a,b,c)
#define	L071(a,b,c,d) S("PRIVMSG %s :Habeo %s %d permban%s onerant in RAM.\n",a,b,c,d)
#define	L073(a,b,c) S("PRIVMSG %s :%s, %d momenta usque ad randstuff\n",a,b,c)
#define	L074(a,b,c)	S("PRIVMSG %s :%s: erat %d lettrae.\n",a,b,c)
#define	L075(a,b,c,d) S("PRIVMSG %s :%s, Habeo %d res%s in Que.\n",a,b,c,d)
#define	L076(a,b) S("PRIVMSG %s :Vidui %d jungendis adhuc.\n",a,b)
#define	L077(a,b,c,d,e)	S("PRIVMSG %s :Habeo %s %d societates%s in numerus de societas mea. Sum in \
societas #%d.\n",a,b,c,d,e)
#define	L078(a,b,c)	S("PRIVMSG %s :%s, Littera jussum mea est: %c\n",a,b,c)
#define	L079(a,b,c)	S("PRIVMSG %s :Quid debeo %sing pro, %s?\n",a,b,c)
#define	L080(a,b) S("PRIVMSG %s :%s, requiris subtiliter enumerare alloquio!\n",a,b)
#define	L081(a,b) S("PRIVMSG %s :Non possum convidere %s.\n",a,b)
#define	L083(a,b,c)	S("PRIVMSG %s :%s: Quid me vis dicere %s?\n",a,b,c)
#define	L084(a,b,c)	S("PRIVMSG %s :%s, Dico %s de quid?\n",a,b,c)
#define	L085(a,b) S("PRIVMSG %s :Dico quis, %s?\n",a,b)
#define	L086(a,b) S("PRIVMSG %s :%s\2:\2 rogas?\n",a,b)
#define	L087(a,b,c,d,e) S("PRIVMSG %s :%s %s %s? Potes verbis rexprimere illud?  (Exara in machinam \
scriptoriam %cHELP pro significationes syntaxium)\n",a,b,c,d,e)
#define	L088(a) S("QUIT :%s est lapidando!\n",a)
#define	L089(a)	S("PRIVMSG %s :\1ACTION expergit...\1\n",a)
#define	L090(a,b) S("PRIVMSG %s :Inundo. demittendi fructus Que (facta illa exspectabante mandare). \
%d res.\n",a,b)
