#define	I_SPEAK "I speak Spanish."
#define	L001(a,b) S("PRIVMSG %s :No has elegido una contraseña, para poner una \
contraseña: \2/msg %s PASS <oldpass> <newpass>\2 (Como es tu primera \
vez en poner una contraseña, debes usar '0' en la opcion de oldpass)\n",a,b)
#define	L002(a,b,c) S("NOTICE %s :Permban ha sido borrado #%d, %s.\n",a,b,c)
#define	L003(a,b) S("NOTICE %s :Error en abrir %s :(\n",a,b)
#define L004(a,b,c) S("PRIVMSG %s :%s, Se encuentan %d VISTOS dentro de mi base de datos.\n",a,b,c)
#define	L005(a,b) S("PRIVMSG %s :Tu debes saber mas sobre eso que yo, %s.\n",a,b)
#define	L006(a,b,c,d) S("PRIVMSG %s :%s, Yo no he visto  %s %s\n",a,b,c,d)
#define	L007(a,b) S("NOTICE %s :Autotopic activado %s estaba APAGADO\n",a,b)
#define	L008(a,b) S("NOTICE %s :Autotopic activado %s ahora esta APAGADO\n",a,b);
#define	L009(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s ACTIVADO: %s\n",a,b,c)
#define	L010(a,b,c) S("NOTICE %s :AUTOTOPIC @ %s UPDATED: %s\n",a,b,c)
#define	L011(a,b,c) S("PRIVMSG %s :%s, completo. Ahora se encuentan %d randomstuffs [cosas al lazar].\n",a,b,c)
#define	L012(a,b) S("NOTICE %s :Contraseña de %s ahora esta updated.\n",a,b)
#define	L013(a) S("NOTICE %s :Contraseña incorecta!\n",a)
#define	L014(a) S("NOTICE %s :Nada encontrado!\n",a)
#define	L015(a,b,c,d) S("NOTICE %s :Usuario borrado: %s [%d:%d]\n",a,b,c,d)
#define	L016(a,b) S("PRIVMSG %s :%s: Error de division entre cero!\n",a,b)
#define	L017(a,b) S("PRIVMSG %s :%s: Operacion Ilegal!\n",a,b)
#define	L018(a,b,c,d,e) S("KICK %s %s :%s (Adicion de ignore #%d: %s)\n",a,b,c,d,e)
#define	L019(a,b,c) S("PRIVMSG %s :Adicion de ignore #%d: %s!\n",a,b,c);
#define L020(a,b,c,d) S("NOTICE %s :Updated #%d: \37[\37%s\37]\37 info\2:\2 %s\n",a,b,c,d)
#define	L021(a,b,c,d) S("PRIVMSG %s :%s \37%s\37.. %d entradas revisadas.\n",a,b,c,d)
#define	L022(a,b,c) S("PRIVMSG %s :He encontrado mas de  \37%d\37 entradas, por favor reducir tu \
busqueda\2:\2 %s\n",a,b,c);
#define	L023(a,b,c) S("PRIVMSG %s :He encontrado  \37one\37 combinaciones, %s\2:\2 %s\n",a,b,c)
#define	L024(a,b,c,d) S("PRIVMSG %s :He encontrado \37%d\37 combinaciones, %s\2:\2 %s\n",a,b,c,d)
#define	L025(a,b) S("PRIVMSG %s :Encontre %ld topic duplicados. Han sido eliminados.\n",a,b)
#define	L026(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Ejecutando %s. Yo tengo %ld \
topics en mis base de datos, Uptime: %d dias%s, %02d:%02d, \
Han habido %ld preguntas hechas, %ld adiciones de topic, y %ld topic \
borrados. Tiempo de Proceso: %1.4lf seg%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L027(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Ejecutando %s. He encontrado \
%ld topics en mis base de datos, Uptime: %d horas%s, %d min%s, \
Han habido %ld preguntas hechas, %ld topics nuevos, y %ld topics \
borrados. Tiempo de Proceso: %1.4lf seg%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L028(a,b,c,d,e,f,g,h,i,j,k,l) S("PRIVMSG %s :Ejecutando %s. Yo tengo %ld topics en mis \
base de datos, Uptime: %d min%s, %d seg%s, Han habido %ld preguntas hechas, %ld topics nuevos, y %ld topics \
borrados. Tiempo de Proceso: %1.4lf seg%s\n",a,b,c,d,e,f,g,h,i,j,k,l)
#define	L029(a,b,c,d) S("PRIVMSG %s :%s: He eliminado el topic #%ld, \2%s\2.\n",a,b,c,d)
#define	L030(a,b,c) S("PRIVMSG %s :%s\2:\2 No he podido encontrar el topic \37%s\37. Error en \
eliminacion.\n",a,b,c)
#define	L031(a,b) S("NOTICE %s :Syntax: \2/msg %s PASS <Vieja-contraseña> <nueva-contraseña>\2\n",a,b)
#define	L032(a)	Snow("QUIT :K\2\2illed (%s (cause I say so!))\n",a)
#define	L033(a)	S("NOTICE %s :Syntax: UP <#canal> <contaseña>\n",a)
#define	L034(a)	S("NOTICE %s :Syntax: OP <#canal> [nicks] <contraseña>\n",a)
#define	L035(a)	S("NOTICE %s :Syntax: DEOP <#canal> [nicks] <contraseña>\n",a)
#define	L036(a)	S("NOTICE %s :Favor especificar un nick!\n",a)
#define	L037(a,b) S("NOTICE %s :Tratando de  /nick %s\n",a,b)
#define	L038(a,b) S("NOTICE %s :Favor tratar /nick %s-dork.\n",a,b)
#define	L039(a,b) S("PRIVMSG %s :Saliendo %s\n",a,b)
#define	L040(a,b) S("PRIVMSG %s :Entrando %s\n",a,b)
#define	L041(a)	S("PRIVMSG %s :Favor especificar un nick/canal!\n",a)
#define	L042(a)	S("NOTICE %s :Entrar al u@h para hacer la eliminacion!\n",a)
#define	L043(a) S("NOTICE %s :No se encuenta el ban.\n",a)
#define	L044(a)	S("NOTICE %s :Entrar al u@h para borrar!\n",a)
#define	L045(a) S("NOTICE %s :Que tal no hago eso?\n",a)
#define	L046(a)	S("PRIVMSG %s :Backup de base de dato completo.\n",a)
#define	L047(a,b) S("NOTICE %s :SYNTAX: %cAUTOTOPIC <topic>  (Poner en \"0\" para apagar)\n",a,b)
#define	L048(a)	S("NOTICE %s :Syntax: SETCHAN <nuevos canales>\n",a)
#define	L049(a,b) S("NOTICE %s :Canal por defecto: %s\n",a,b)
#define	L050(a)	S("NOTICE %s :Syntax: SETCHAR <nuevo caracter de comando>\n",a)
#define	L051(a,b) S("NOTICE %s :Nuevo commando ya: %c\n",a,b)
#define	L052(a)	S("NOTICE %s :Syntax: SETUSER <nuevo userid> (Se requiere un restart)\n",a)
#define	L053(a,b) S("NOTICE %s :Userid por defecto: %s\n",a,b)
#define	L054(a)	S("NOTICE %s :Syntax: SETNICK <nuevonick>\n",a)
#define	L055(a)	S("NOTICE %s :Syntax: ADDUSER <#canal> <*user@*.host> <nival> <contraseña>. ie; ADDUSER \
#darkbot *jason@*.superlink.net 3 Su contraseña ... usar #* Si deseas darle acceso en todo los canales.\n",a)
#define	L056(a)	sprintf(temp, "No he usado \2%cSETINFO\2 todavia!",a)
#define	L057(a,b,c)	S("NOTICE %s :Usurario Agregado: %s - Nivel %d\n",a,b,c)
#define	L058(a,b,c)	S("NOTICE %s :Syntax: %c%s <u@h> [razon]\n",a,b,c)
#define	L059(a,b,c,d) S("NOTICE %s :Agregado en permban #%d, %s; razon: %s\n",a,b,c,d)
#define	L060(a)	S("NOTICE %s :Syntax: REPEAT <numero> <delay> <raw-data>\n",a)
#define	L061(a)	S("NOTICE %s :Listo.\n",a)
#define	L062(a) S("QUIT :Re-iniciando %s ...\n",a);
#define	L064(a,b) S("PRIVMSG %s :%s, que deseas agregar?\n",a,b)
#define	L065(a,b) S("PRIVMSG %s :Agregar que, %s?\n",a,b);
#define	L066(a,b,c)	S("PRIVMSG %s :%s: Que informacion deseas agregada para %s?\n",a,b,c)
#define	L067(a,b) S("PRIVMSG %s :OK, %s :)\n",a,b)
#define	L068(a,b) S("PRIVMSG %s :Cambiar que, %s?\n",a,b)
#define	L069(a,b,c) S("PRIVMSG %s :%s: Que informacion debe cambiar %s?\n",a,b,c)
#define	L070(a,b,c) S("PRIVMSG %s :%s, %s ha sido updated.\n",a,b,c)
#define	L071(a,b,c,d) S("PRIVMSG %s :Se encuentan %s %d permban%s cargados en memoria.\n",a,b,c,d)
#define	L073(a,b,c) S("PRIVMSG %s :%s, %d segundos restante antes de randstuff\n",a,b,c)
#define	L074(a,b,c)	S("PRIVMSG %s :%s: era de %d caracteres de largo.\n",a,b,c)
#define	L075(a,b,c,d) S("PRIVMSG %s :%s, Se encuentran ahora mismo %d itemes%s en el Que.\n",a,b,c,d)
#define	L076(a,b) S("PRIVMSG %s :Yo he visto %d joins hasta el momento.\n",a,b)
#define	L077(a,b,c,d,e)	S("PRIVMSG %s :Hay %s %d servidores%s en mi lista de servidores. Me encuentro en el \
servidor #%d.\n",a,b,c,d,e)
#define	L078(a,b,c)	S("PRIVMSG %s :%s, mi caracter de comando es: %c\n",a,b,c)
#define	L079(a,b,c)	S("PRIVMSG %s :What should i be %sing for, %s?\n",a,b,c)
#define	L080(a,b) S("PRIVMSG %s :%s, Necesitas poner una direcion!\n",a,b)
#define	L081(a,b) S("PRIVMSG %s :No logre encontrar %s.\n",a,b)
#define	L083(a,b,c)	S("PRIVMSG %s :%s: Que deseas que yo diga %s?\n",a,b,c)
#define	L084(a,b,c)	S("PRIVMSG %s :%s, Decir %s sobre que?\n",a,b,c)
#define	L085(a,b) S("PRIVMSG %s :Decirle a quien, %s?\n",a,b)
#define	L086(a,b) S("PRIVMSG %s :%s\2:\2 estabas preguntando?\n",a,b)
#define	L087(a,b,c,d,e) S("PRIVMSG %s :%s %s %s? Puedes reformular eso? (Escribir %cHELP para ayuda en \
syntax)\n",a,b,c,d,e)
#define	L088(a) S("QUIT :%s estoy drogado!\n",a)
#define	L089(a)	S("PRIVMSG %s :\1ACTION se despierta...\1\n",a)
#define	L090(a,b) S("PRIVMSG %s :Estoy siendo flooded. Vaciando output Que (data que esta esperando \
para ser mandado). %d itemes.\n",a,b)
