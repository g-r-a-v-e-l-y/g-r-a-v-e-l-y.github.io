#if LANG == 1
#include "english.h"
#endif
#if LANG == 2
#include "french.h"
#endif
#if LANG == 3
#include "spanish.h"
#endif
#if LANG == 4
#include "dutch.h"
#endif
#if LANG == 5
#include "latin.h"
#endif
#if LANG == 6
#include "greek.h"
#endif
#if LANG == 7
#include "ebonics.h"
#endif
#if LANG == 8
#include "latin2.h"
#endif
#if LANG == 9
#include "russian.h"
#endif
#if LANG == 10
#include "russian2.h"
#endif
#if LANG == 11
#include "portuguese.h"
#endif
#if LANG == 12
#include "german.h"
#endif
#if LANG == 13
#include "italian.h"
#endif
#if LANG == 14
#include "chinese.h"
#endif
#if LANG == 15
#include "swedish.h"
#endif
#if LANG == 16
#include "norwegian.h"
#endif
#if LANG == 17
#include "romanian.h"
#endif
#ifndef L091
#define L091(a) S("NOTICE %s :Syntax: SETVHOST <new Vhost> (requires a restart)\n",a)
#endif
#ifndef L092
#define L092(a,b) S("NOTICE %s :Default Vhost now: %s\n",a,b)
#endif
