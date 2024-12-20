#define	I_SPEAK "I speak Greek."
#define	L001(a,b) S("PRIVMSG %s :Den exis vali kodiko, gian na valis grapse: \2/msg %s PASS \
<palioskodikos> <kainourioskodikos>\2 (epidi auti ine i prota sou fora pou vazi kodiko, \
xrisimopia '0' san ton palio sou kodiko)\n",a,b)
#define	L002(a,b,c) S("NOTICE %s :To monimo ban exi svisti #%d, %s.\n",a,b,c)
#define	L003(a,b) S("NOTICE %s :Den mporesa na anixo to %s :(\n",a,b)
#define L004(a,b,c) S("PRIVMSG %s :%s, Eparxoun %d SEEN's stin lista mou.\n",a,b,c)
#define	L005(a,b) S("PRIVMSG %s :Den tha xeris perissotera aposa xero ego, %s.\n",a,b)
#define	L006(a,b,c,d) S("PRIVMSG %s :%s, Den ida to nick %s %s\n",a,b,c,d)
#define	L007(a,b) S("NOTICE %s :Autotopic gia to %s itan apenergepiimeno\n",a,b)
#define	L008(a,b) S("NOTICE %s :Autotopic gia to %s einai to apenergepiimeno\n",a,b);
#define	L009(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s Energopieimeno: %s\n",a,b,c)
#define	L010(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s UPDATED: %s\n",a,b,c)
#define	L011(a,b,c) S("PRIVMSG %s :%s, Egine. Iparxoun tora %d randomstuffs.\n",a,b,c)
#define	L012(a,b) S("NOTICE %s :O kodikos gia to nick %s exi exixronisti.\n",a,b)
#define	L013(a) S("NOTICE %s :Lathos Kodikos!\n",a)
#define	L014(a) S("NOTICE %s :Den Vrethike!\n",a)
#define	L015(a,b,c,d) S("NOTICE %s :Svismeni xristes: %s [%d:%d]\n",a,b,c,d)
#define	L016(a,b) S("PRIVMSG %s :%s: Upodieresi apo to miden eine lanthasmeni!\n",a,b)
#define	L017(a,b) S("PRIVMSG %s :%s: Paranomi epixirisi!\n",a,b)
#define	L018(a,b,c,d,e) S("KICK %s %s :%s (Prostheto to ignore #%d: %s)\n",a,b,c,d,e)
#define	L019(a,b,c) S("PRIVMSG %s :Prostheto to ignore #%d: %s!\n",a,b,c);
#define L020(a,b,c,d) S("NOTICE %s :Exixronismos gia #%d: \37[\37%s\37]\37 plirofories\2:\2 %s\n",a,b,c,d)
#define	L021(a,b,c,d) S("PRIVMSG %s :%s \37%s\37.. %d dedomena anazytithikan.\n",a,b,c,d)
#define	L022(a,b,c) S("PRIVMSG %s :Vrika perissotore apo \37%d\37 dedomena, parakalo perioriste \
thn anazitisi sas\2:\2 %s\n",a,b,c);
#define	L023(a,b,c) S("PRIVMSG %s :Vrika \37one\37 dedomena, %s\2:\2 %s\n",a,b,c)
#define	L024(a,b,c,d) S("PRIVMSG %s :Vrika \37%d\37 dedomena, %s\2:\2 %s\n",a,b,c,d)
#define	L025(a,b) S("PRIVMSG %s :Vrika %ld themata. Exoun svisti.\n",a,b)
#define	L026(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Letourgiko %s. +Ellinika Exo %ld themata stin lista my, Eime energepioimenos gia: \
%d day%s, %02d:%02d, Exoun rotithi %ld erotisis,Exoun prosthethi %ld \
themata, kai exoun aferethi %ld themata. Process time: %1.4lf sec%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L027(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Letourgiko %s.
+ Ellinika Exo % ld themata stin lista my, Eime energepioimenos gia:\
%d day % s, %02 d:%02 d, Exoun rotithi % ld erotisis, Exoun prosthethi % ld themata, \
kai exoun aferethi % ld themata.Process time: %1.4lf sec % s \ n ",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L028(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Letourgiko %s. \
+Ellinika Exo %ld themata stin lista my, Eime energepioimenos gia: %d day%s, %02d:%02d, \
Exoun rotithi %ld erotisis,Exoun prosthethi %ld themata, kai exoun \
aferethi %ld themata. Process time: %1.4lf sec%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L029(a,b,c,d) S("PRIVMSG %s :%s: Exo svisi to thema #%ld, \2%s\2.\n",a,b,c,d)
#define	L030(a,b,c) S("PRIVMSG %s :%s\2:\2 Den moris na vro to thema \37%s\37. Delete failed.\n",a,b,c)
#define	L031(a,b) S("NOTICE %s :Syntaxi: \2/msg %s PASS <palioskodikos> <kainourios>\2\n",a,b)
#define	L032(a)	Snow("QUIT :K\2\2illed (%s (epidi etsi leo!))\n",a)
#define	L033(a)	S("NOTICE %s :Syntaxi: UP <#Kanali> <kodikos>\n",a)
#define	L034(a)	S("NOTICE %s :Syntaxi: OP <#Kanali> [nicks] <kodikos>\n",a)
#define	L035(a)	S("NOTICE %s :Syntaxi: DEOP <#Kanali> [nicks] <kodikos>\n",a)
#define	L036(a)	S("NOTICE %s :Kathorise ena nick!\n",a)
#define	L037(a,b) S("NOTICE %s :Dokimazo na kano /nick %s\n",a,b)
#define	L038(a,b) S("NOTICE %s :Dokimase /nick %s-gios-ths-poutanas.\n",a,b)
#define	L039(a,b) S("PRIVMSG %s :Fevgo apo to %s\n",a,b)
#define	L040(a,b) S("PRIVMSG %s :Mpeno sto %s\n",a,b)
#define	L041(a)	S("PRIVMSG %s :Kathorise ena paratsoukli/Kanali!\n",a)
#define	L042(a)	S("NOTICE %s :Vale to u@h pou tha dioxo\n",a)
#define	L043(a) S("NOTICE %s :Den vrika etsi ban.\n",a)
#define	L044(a)	S("NOTICE %s :Vale to u@h pou thes na svisti!\n",a)
#define	L045(a) S("NOTICE %s :Pos sou fenete i idea na min to kano?\n",a)
#define	L046(a)	S("PRIVMSG %s :Exo filaxi thn lista mou.\n",a)
#define	L047(a,b) S("NOTICE %s :Syntaxi: %cAUTOTOPIC <epikefalida>  (vale \"0\" gia \
na to apenergopiisis)\n",a,b)
#define	L048(a)	S("NOTICE %s :Syntaxi: SETCHAN <Nea kanalia>\n",a)
#define	L049(a,b) S("NOTICE %s :Proepilegmeno kanali: %s\n",a,b)
#define	L050(a)	S("NOTICE %s :Syntaxi: SETCHAR <Nea anagnorisi gia ths entoles>\n",a)
#define	L051(a,b) S("NOTICE %s :I nea anagnorisi einai: %c\n",a,b)
#define	L052(a)	S("NOTICE %s :Syntaxi: SETUSER <Neon userid> (Prepi na xanaxekinisi to bot)\n",a)
#define	L053(a,b) S("NOTICE %s :Proepilegmeno userid: %s\n",a,b)
#define	L054(a)	S("NOTICE %s :Syntaxi: SETNICK <neoparatsoukli>\n",a)
#define	L055(a)	S("NOTICE %s :Syntaxi: ADDUSER <#kanali> <*user@*.host> <dinami> <kodikos>. \
diladi; ADDUSER #darkbot *jason@*.superlink.net 3 tonkodikotou ... xrisimopia #* gia na dosi \
kapion dinami se ola ta kanalia.\n",a)
#define	L056(a)	sprintf(temp, "Den exo xrisimopioisi to \2%cSETINFO\2 akoma!",a)
#define	L057(a,b,c)	S("NOTICE %s :Prosthesa ton: %s - me dinami %d\n",a,b,c)
#define	L058(a,b,c)	S("NOTICE %s :Syntaxi: %c%s <u@h> [dikeologia]\n",a,b,c)
#define	L059(a,b,c,d) S("NOTICE %s :Proshethike sti lista ton monimon ban #%d, %s; logos: %s\n",a,b,c,d)
#define	L060(a)	S("NOTICE %s :Syntax: REPEAT <arithmos> <kathisterisi> <entoli-gia-ton-server>\n",a)
#define	L061(a)	S("NOTICE %s :Egine.\n",a)
#define	L062(a) S("QUIT :Epanarxisi %s ...\n",a);
#define	L064(a,b) S("PRIVMSG %s :%s, ti thelis na prosthesis?\n",a,b)
#define	L065(a,b) S("PRIVMSG %s :Ti na prostheso, %s?\n",a,b);
#define	L066(a,b,c)	S("PRIVMSG %s :%s: Ti proforia na protheso gia to %s?\n",a,b,c)
#define	L067(a,b) S("PRIVMSG %s :Egine, %s :)\n",a,b)
#define	L068(a,b) S("PRIVMSG %s :Ti na alaxo, %s?\n",a,b)
#define	L069(a,b,c) S("PRIVMSG %s :%s: Ti pliroforia na alaxo %s?\n",a,b,c)
#define	L070(a,b,c) S("PRIVMSG %s :%s, %s exis anavathimisti.\n",a,b,c)
#define	L071(a,b,c,d) S("PRIVMSG %s :Iparxoun %s %d permban%s stin mnimi mou.\n",a,b,c,d)
#define	L073(a,b,c) S("PRIVMSG %s :%s, %d defteropta exoun mini gia na xekiniso to randstuff\n",a,b,c)
#define	L074(a,b,c)	S("PRIVMSG %s :%s: eixen %d xaraktires.\n",a,b,c)
#define	L075(a,b,c,d) S("PRIVMSG %s :%s, Epourxou %d pragmata%s sto Que.\n",a,b,c,d)
#define	L076(a,b) S("PRIVMSG %s :Exo thi di %d na erxontai mexri tora.\n",a,b)
#define	L077(a,b,c,d,e)	S("PRIVMSG %s :Iparxoun %s %d server%s stin lista ton server. Eime ston \
server #%d.\n",a,b,c,d,e)
#define	L078(a,b,c)	S("PRIVMSG %s :%s, oi ento les arxizou apo: %c\n",a,b,c)
#define	L079(a,b,c)	S("PRIVMSG %s :What should i be %sing for, %s?\n",a,b,c)
#define	L080(a,b) S("PRIVMSG %s :%s, prepi na pis mian diefthisi!\n",a,b)
#define	L081(a,b) S("PRIVMSG %s :Den mporesa na to vro %s.\n",a,b)
#define	L083(a,b,c)	S("PRIVMSG %s :%s: Ti thelis na po %s?\n",a,b,c)
#define	L084(a,b,c)	S("PRIVMSG %s :%s, Na po ston %s giati pragma?\n",a,b,c)
#define	L085(a,b) S("PRIVMSG %s :Se pion na po, %s?\n",a,b)
#define	L086(a,b) S("PRIVMSG %s :%s\2:\2 ti rotises?\n",a,b)
#define	L087(a,b,c,d,e) S("PRIVMSG %s :%s %s %s? Se piraza na to xanapis? (Grapse %cHELP \
gia thn syntaxi tou)\n",a,b,c,d,e)
#define	L088(a) S("QUIT :%s eine stoned!\n",a)
#define	L089(a)	S("PRIVMSG %s :\1ACTION xipna...\1\n",a)
#define	L090(a,b) S("PRIVMSG %s :Exo gini flood. %d items.\n",a,b)
