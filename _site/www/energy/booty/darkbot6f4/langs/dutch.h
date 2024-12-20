#define	I_SPEAK "I speak Dutch."
#define	L001(a,b) S("PRIVMSG %s :U heeft geen wachtwoord gezet, om een wachtwoord te zetten: \
\2/msg %s PASS <oudwachtwoord> <nieuwwachtwoord>\2 (Omdat dit de eerste keer is \
dat U een wachtwoord zet, gebruik dan '0' als uw oude wachtwoord)\n",a,b)
#define	L002(a,b,c) S("NOTICE %s :Permban #%d verwijderd, %s.\n",a,b,c)
#define	L003(a,b) S("NOTICE %s :Niet mogelijk %s te openen:(\n",a,b)
#define L004(a,b,c) S("PRIVMSG %s :%s, Er zijn %d SEEN's in mijn database.\n",a,b,c)
#define	L005(a,b) S("PRIVMSG %s :Dat zou jij toch beter moeten weten, %s.\n",a,b)
#define	L006(a,b,c,d) S("PRIVMSG %s :%s, Ik heb %s niet gezien%s\n",a,b,c,d)
#define	L007(a,b) S("NOTICE %s :Autotopic op %s was UIT\n",a,b)
#define	L008(a,b) S("NOTICE %s :Autotopic op %s is nu UIT\n",a,b);
#define	L009(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s AAN: %s\n",a,b,c)
#define	L010(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s AANGEPAST: %s\n",a,b,c)
#define	L011(a,b,c) S("PRIVMSG %s :%s, gedaan. Er zijn nu %d randomstuffs.\n",a,b,c)
#define	L012(a,b) S("NOTICE %s :Wachtwoord voor %s is veranderd.\n",a,b)
#define	L013(a) S("NOTICE %s :Foutief wachtwoord!\n",a)
#define	L014(a) S("NOTICE %s :Geen gelijkenis!\n",a)
#define	L015(a,b,c,d) S("NOTICE %s :Gebruiker verwijderd: %s [%d:%d]\n",a,b,c,d)
#define	L016(a,b) S("PRIVMSG %s :%s: Deling door nul fout!\n",a,b)
#define	L017(a,b) S("PRIVMSG %s :%s: Illegale bewerking!\n",a,b)
#define	L018(a,b,c,d,e) S("KICK %s %s :%s (U wordt genegeerd #%d: %s)\n",a,b,c,d,e)
#define	L019(a,b,c) S("PRIVMSG %s :Negeren toegevoegd voor #%d: %s!\n",a,b,c);
#define L020(a,b,c,d) S("NOTICE %s :#%d aangepast: \37[\37%s\37]\37 info\2:\2 %s\n",a,b,c,d)
#define	L021(a,b,c,d) S("PRIVMSG %s :%s \37%s\37.. %d records doorzocht.\n",a,b,c,d)
#define	L022(a,b,c) S("PRIVMSG %s :Meer dan \37%d\37 onderwerpen gevonden, verklein uw \
zoekgebied a.u.b.\2:\2 %s\n",a,b,c);
#define	L023(a,b,c) S("PRIVMSG %s :Ik heb \37een\37 onderwep gevonden, %s\2:\2 %s\n",a,b,c)
#define	L024(a,b,c,d) S("PRIVMSG %s :Ik heb \37%d\37 onderwerp gevonden, %s\2:\2 %s\n",a,b,c,d)
#define	L025(a,b) S("PRIVMSG %s :%ld onderwerp duplicaten gevonden. Ze zijn verwijderd.\n",a,b)
#define	L026(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Actief %s. Ik heb %ld onderwerpen in mijn \
database, Uptime: %d dagen%s, %02d:%02d, Er zijn %ld vragen gesteld, %ld onderwerpen \
toegevoegd, en %ld onderwerpen verwijderd. Verwerkingstijd: %1.4lf sec%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L027(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Actief %s. Ik heb %ld onderwerpen in mijn \
database, Uptime: %d uur%s, %d min%s, Er zijn %ld vragen gesteld, %ld onderwerpen \
toegevoegd, en %ld onderwerpen verwijderd. Verwerkingstijd: %1.4lf sec%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L028(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Actief %s. Ik heb %ld onderwerpen in mijn \
database, Uptime: %d min%s, %d sec%s, Er zijn %ld vragen gesteld, %ld onderwerpen \
toegevoegd, en %ld onderwerpen verwijderd. Verwerkingstijd: %1.4lf sec%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L029(a,b,c,d) S("PRIVMSG %s :%s: Ik heb onderwerp #%ld verwijderd, \2%s\2.\n",a,b,c,d)
#define	L030(a,b,c) S("PRIVMSG %s :%s\2:\2 Ik was niet in staat om onderwerp \37%s\37 te \
vinden. Verwijdering gefaald.\n",a,b,c)
#define	L031(a,b) S("NOTICE %s :Syntax: \2/msg %s PASS <oudwachtwoord> <nieuwwachtwoord>\2\n",a,b)
#define	L032(a)	Snow("QUIT :K\2\2illed (%s (omdat ik get zeg!))\n",a)
#define	L033(a)	S("NOTICE %s :Syntax: UP <#chan> <wachtwoord>\n",a)
#define	L034(a)	S("NOTICE %s :Syntax: OP <#chan> [nicks] <wachtwoord>\n",a)
#define	L035(a)	S("NOTICE %s :Syntax: DEOP <#chan> [nicks] <wachtwoord>\n",a)
#define	L036(a)	S("NOTICE %s :Specificeer een nick!\n",a)
#define	L037(a,b) S("NOTICE %s :Probeer /nick %s\n",a,b)
#define	L038(a,b) S("NOTICE %s :Probeer /nick %s-eikel.\n",a,b)
#define	L039(a,b) S("PRIVMSG %s :Ik verlaat %s\n",a,b)
#define	L040(a,b) S("PRIVMSG %s :Ik kom binnen in %s\n",a,b)
#define	L041(a)	S("PRIVMSG %s :Specificeer een nick/kanaal!\n",a)
#define	L042(a)	S("NOTICE %s :Vul de u@h om te verwijderen!\n",a)
#define	L043(a) S("NOTICE %s :Geen ban van bekend.\n",a)
#define	L044(a)	S("NOTICE %s :Vul de u@h in om te verwijderen!\n",a)
#define	L045(a) S("NOTICE %s :Wat vind je ervan als ik dat nou eens niet doe?\n",a)
#define	L046(a)	S("PRIVMSG %s :Database gebackupt.\n",a)
#define	L047(a,b) S("NOTICE %s :SYNTAX: %cAUTOTOPIC <onderwerp>  (zet hem op \"0\" om hem uit \
te zetten)\n",a,b)
#define	L048(a)	S("NOTICE %s :Syntax: SETCHAN <nieuwe kanalen>\n",a)
#define	L049(a,b) S("NOTICE %s :Standaard kanaal: %s\n",a,b)
#define	L050(a)	S("NOTICE %s :Syntax: SETCHAR <nieuwe commando karakter>\n",a)
#define	L051(a,b) S("NOTICE %s :Het nieuwe commando karakter is nu: %c\n",a,b)
#define	L052(a)	S("NOTICE %s :Syntax: SETUSER <nieuwe gebruikersid> (vereist een herstart)\n",a)
#define	L053(a,b) S("NOTICE %s :Standaard gebruikersid is nu: %s\n",a,b)
#define	L054(a)	S("NOTICE %s :Syntax: SETNICK <nieuwenick>\n",a)
#define	L055(a)	S("NOTICE %s :Syntax: ADDUSER <#chan> <*user@*.host> <niveau> \
<wachtwoord>. ie; ADDUSER #darkbot *jason@*.superlink.net 3 zijnwachtwoord ... gebruik #* \
als je rechten in alle kanalen wilt geven.\n",a)
#define	L056(a)	sprintf(temp, "Ik heb \2%cSETINFO\2 nog niet gebruikt!",a)
#define	L057(a,b,c)	S("NOTICE %s :Gebruiker toegevoegd: %s - niveau %d\n",a,b,c)
#define	L058(a,b,c)	S("NOTICE %s :Syntax: %c%s <u@h> [reden]\n",a,b,c)
#define	L059(a,b,c,d) S("NOTICE %s :Toegevoegd aan permban #%d, %s; reden: %s\n",a,b,c,d)
#define	L060(a)	S("NOTICE %s :Syntax: REPEAT <nummer> <vertaling> <ruwe-data>\n",a)
#define	L061(a)	S("NOTICE %s :Klaar.\n",a)
#define	L062(a) S("QUIT :Aan het herstarten %s ...\n",a)
#define	L064(a,b) S("PRIVMSG %s :%s, wat wil je toevoegen?\n",a,b)
#define	L065(a,b) S("PRIVMSG %s :Voeg wat informatie toe, %s?\n",a,b);
#define	L066(a,b,c)	S("PRIVMSG %s :%s: Welke informatie moet worden%s?\n",a,b,c)
#define	L067(a,b) S("PRIVMSG %s :OK, %s :)\n",a,b)
#define	L068(a,b) S("PRIVMSG %s :Vervang wat, %s?\n",a,b)
#define	L069(a,b,c) S("PRIVMSG %s :%s: Welke informatie moet vervangen worden%s?\n",a,b,c)
#define	L070(a,b,c) S("PRIVMSG %s :%s, %s is aangepast.\n",a,b,c)
#define	L071(a,b,c,d) S("PRIVMSG %s :Er %s %d permban%s in RAM geladen.\n",a,b,c,d)
#define	L072(a,b) S("PRIVMSG %s :Ik heb momenteel %d banserv's geladen.\n",a,b)
#define	L073(a,b,c) S("PRIVMSG %s :%s, %d seconden tot de volgende randstuff\n",a,b,c)
#define	L074(a,b,c)	S("PRIVMSG %s :%s: het was %d karakters lang.\n",a,b,c)
#define	L075(a,b,c,d) S("PRIVMSG %s :%s, Er zijn momenteel %d item%s in Que.\n",a,b,c,d)
#define	L076(a,b) S("PRIVMSG %s :Ik heb %d binnenkomsten gezien tot nu toe.\n",a,b)
#define	L077(a,b,c,d,e)	S("PRIVMSG %s :Er zijn %s %d server%s in mijn server lijst. Ik zit \
momenteel op server #%d.\n",a,b,c,d,e)
#define	L078(a,b,c)	S("PRIVMSG %s :%s, mijn commando karakter is: %c\n",a,b,c)
#define	L079(a,b,c)	S("PRIVMSG %s :Waarom zou ik moeten %sing, %s?\n",a,b,c)
#define	L080(a,b) S("PRIVMSG %s :%s, je moet een adres specificeren!\n",a,b)
#define	L081(a,b) S("PRIVMSG %s :Was niet in staat om %s op te zoeken.\n",a,b)
#define	L083(a,b,c)	S("PRIVMSG %s :%s: Wat wil je dat ik vertel %s?\n",a,b,c)
#define	L084(a,b,c)	S("PRIVMSG %s :%s, Vertel %s wat?\n",a,b,c)
#define	L085(a,b) S("PRIVMSG %s :Vertel wie, %s?\n",a,b)
#define	L086(a,b) S("PRIVMSG %s :%s\2:\2 je zei?\n",a,b)
#define	L087(a,b,c,d,e) S("PRIVMSG %s :%s %s %s? Vind je het erg om dat te herformuleren? \
(Type %cHELP voor syntax hints)\n",a,b,c,d,e)
#define	L088(a) S("QUIT :%s is stoned!\n",a)
#define	L089(a)	S("PRIVMSG %s :\1ACTION wordt wakker...\1\n",a)
#define	L090(a,b) S("PRIVMSG %s :Ik wordt geflood. Output-rij gedumpt (data dat klaarstond om \
verzonden te worden). %d opdrachten.\n",a,b)
