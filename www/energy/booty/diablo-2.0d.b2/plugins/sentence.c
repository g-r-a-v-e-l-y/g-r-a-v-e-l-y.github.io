#include <stdio.h>
#include <stdlib.h>
#include <sys/timeb.h>

#define	num_subject_pronouns	(sizeof(subject_pronouns)/4)

char *object_pronouns[] = { "me", "you", "them", "us", "him", "her", "it" };
#define	num_object_pronouns	(sizeof(object_pronouns)/4)

char sentbuf[512];

char pronoun_plural[] = { 1, 1, 1, 1, 0, 0, 0 };
char *pronoun_verbs[] = { "am", "are", "are", "are", "is", "is", "is" };
char *pronoun_possessive[] = { "my", "your", "their", "our", "his", "her", "its" };
char *subject_pronouns[] = { "I", "You", "They", "We", "He", "She", "It" };

char *nouns[] = {
		"man", "woman", "child", "surgeon", "doctor", "dentist",
		"scientist", "programmer", "writer", "artist", "reporter",
		"rock climber", "governor", "mayor", "volunteer", "actor",
		"actress", "consultant", "advisor", "sorceror", "elf",
		"son", "daughter", "boy", "girl", "teacher", "boss", "potato",
		"employer", "dictator", "prime minister", "salesman",
		"saleswoman", "chiropractor", "electroencephalogram", "brick",
		"car", "xylophone", "saxophone", "telephone booth", "rock",
		"garage", "parking lot", "school", "refrigerator",
		"office building", "space shuttle", "mountain",
		"airplane", "barbecue", "trash can", "jar", "box", "bed",
		"bookshelf", "lamp", "piggy bank", "tree", "bush", "lawn",
		"house", "carpet", "rug", "computer", "android", "book",
		"toy", "clock", "power cable", "rocket", "keyboard",
		"window", "door", "wall", "snack", "sun", "immortal",
		"sand box", "jelly bean", "donut", "shop", "restaurant", "apple",
		"pear", "banana", "grape", "strawberry", "blueberry", "orange",
		"highway", "road", "boat", "pencil", "paper", "factory",
		"hallway", "street", "cradle", "crib", "soda can", "driveway",
		"shoe", "shirt", "pair of pants", "pair of shorts",
		"door knob", "bear", "cat", "dog", "elk", "emu", "dear",
		"pork chop", "steak", "stake", "star", "wire", "candle",
		"jukebox", "spoon", "fork", "sega", "nintendo", "sausage",
		"hamburger", "hotdog", "pancake", "waffle", "salad", "carrot",
		"head of lettuce", "piece of cheese", "platter of beans", 
		"bowl of rice", "bacterium", "jar of tomato sauce", "protozoan",
		"country", "county", "city", "Ford Taurus", "birthday", "crap",
		"blob of jelly", "undertaker", "slug", "germ", "tooth", "bone",
		"eye socket", "sodium chloride molecule", "chunk of granite",
		"liver", "foliose lichen", "Spanish moss", "kudzu", "trout",
		"horseshoe", "adenosine triphosphate molecule", "DNA strand",
		"superhero", "Mr. Rogers", "government", "Donald Duck imposter", 
		"Oscar Mayer weiner", "paint store", "bag of goodies",
		"revenge story", "dermatologist", "phosphoric acid molecule",
		"figher jet", "Budweiser frog", "burp", "sentence",
		"illusion", "hallucination", "violation", "invitation",
		"breast implant", "brain tumor", "bubble", "Egyptian",
		"mummy", "ghost", "MCI five-cent Sunday calling plan",
		"turtle", "strand of cotton", "asbestos", "hippopotamus",
		"Linux", "lollipop", "pointer", "sign", "term", "word",
		"cartoon", "test tube", "piece of tape", "plan", "escape plan",
		"gerund phrase", "newspaper", "froot loop", "fruit snack",
		"office building", "turnip", "atomic bomb", "bomb", "movie",
		"film", "website", "Richard Scarry book", "alphabet",
		"letter M", "idea", "concept", "number", "ambition", "dream",
		"imagination", "loin cloth", "bed time", "sleep", "noon",
		"afternoon", "evening", "flame", "school subject", "idea",
		"tan", "color", "string", "pole", "pumpkin", "IP address",
		"circuit", "beam of sunlight", "nickname", "hologram",
		"emotion", "vomit", "riot", "excavator", "gravesight",
		"headstone", "cow", "mass", "vegetable garden",
		"bundle of straw", "pot", "teenager", "beach", "dollar bill",
		"duck bill", "rain", "silence", "noise", "log", "vampire",
		"bark", "count", "king", "prince", "apple cider jug", "monk",
		"zoo", "poultry", "thighmaster", "tamborine", "drum",
		"bottle of vodka", "kangaroo", "dust buster", "supermodel",
		"apprentice", "prostitute", "substitute", "alternator", "valve",
		"Volkswagon", "Honda Civic", "magazine", "childrens' video",
		"renovator", "inferno", "bark", "speech", "isosceles triangle",
		"copyright owner", "technical support specialist",
		"owner", "meeting", "assembly", "aggravation", "hatred",
		"shooting", "soccer game", "baseball game", "baseball player",
		"rule", "bed sheet", "desk", "alarm", "alarm clock", "rate",
		"rate", "shower", "crayon", "lego set", "phone jack", "monitor",
		"bottle cap", "stick of deodorant", "diskette", "puzzle",
		"rag doll", "icosahedron", "bubble bath", "window", "curtains",
		"thermometer", "monitor cable", "chemistry set", "slime",
		"compact disc", "frisbee", "basket", "toothbrush",
		"bottle of school glue", "robot", "airport", "glove",
		"bottle of champagne", "closet", "suit", "piece of wood",
		"popsicle", "popsicle stick", "dollar bill", "aluminum foil",
		"baseball cap", "mirror", "stick of gum", "floss", "pillow",
		"feather", "trumpet", "machine gun", "machine",
		"toilet bowl cleaner", "box of cereal", "soccer ball",
		"field goal", "goalie", "swimmer", "bathing suit", "liar",
		"marker", "plaque", "plaque buildup", "glare", "aisle",
		"candy bar", "copyright", "copyright date", "piece of glass",
		"glacier", "gator", "column", "bear", "grease", "berry",
		"tooth"
		};
#define	num_nouns	(sizeof(nouns)/4)

char *adjectives[] = { "hungry", "frantic", "greedy", "lame", "angry", "dirty",
		"clean", "soft", "hard", "drumming", "dead", "live", "thriving",
		"polluted", "mistreated", "neglected", "old", "new", "heavy",
		"foggy", "evil", "good", "happy", "sad", "funny", "idiotic",
		"freaky", "cold", "hot", "warm", "cool", "peaceful", "large",
		"giant", "small", "puny", "beige", "sandy", "rough", "tough",
		"thorough", "red", "orange", "yellow", "green", "blue",
		"violet", "brown", "black", "white", "light", "dark",
		"purple", "furry", "smooth", "relaxing", "devastating", "young",
		"fantastic", "terrific", "devastating", "disasterous",
		"frightening", "fearful", "surrounding", "sinister", "tight",
		"lukewarm", "freezing", "tricky", "turbulent", "rocky",
		"delicious", "jumbly", "random", "real", "easy", "humorous",
		"fresh", "enormous", "appealing", "dazzling", "shimmering",
		"shocking", "merry", "plump", "nauseous", "portable",
		"portable", "neverending", "dental", "missing", "nonexistent",
		"deranged", "analytical", "powerful", "unscrupulous",
		"unstoppable", "babbling", "dissatisfied", "penny-pinching",
		"handicapped", "graduating", "sleek", "oxidized", "neutered",
		"neutralized", "instrumental", "psychological", "unnecessary",
		"null", "fake",  "tubular", "dioescious", "hermaphroditic",
		"unsightly", "friendly", "sucky", "diabolical", "groggy",
		"naked", "censored", "X-rated", "preschool", "stumped",
		"nutty", "violent", "awesome", "exhausted", "low", "high",
		"intermediate", "incomplete", "unfinished", "dynamic",
		"productive", "fast", "stirring", "unnecessary", "challenged",
		"diurnal", "horror-stricken", "bitten", "stung", "nautical",
		"grateful", "enhanced", "malicious", "sulking", "evergreen",
		"fruitful", "energetic", "love-making", "flying", "swimming",
		"forged", "troublesome", "barking", "alarming",
		"whimsical", "musical", "challenged", "bleeding", "running",
		"humming", "falling", "blue-belted", "screaming",
		"glow-in-the-dark", "smelly", "active", "inactive",
		"sedimentary", "gooey", "semisolid", "gelatinous",
		"iron-clad", "copper-coated", "gold-plated", "steel-reinforced",
		"hanging", "lying", "fiddling", "crying", "shining",
		"changing", "inventing", "inventive", "filamentous", "dumb",
		"stringy", "stretchy", "chewy", "sticky", "rubbery", "bouncy",
		"bouncing", "reflecting", "reflective", "charged",
		"electronic", "turbo-charged", "cleansing", "scrubbing",
		"polished", "burned", "charred", "scented", "uneventful",
		"glaring", "absent", "absent-minded", "unobjectable", 
		"untrusted", "conky", "evil twin of the", "grim mountain of",
		"ravishing", "instant"
		};
#define	num_adjectives	(sizeof(adjectives)/4)		

char *adverbs[] = { "angrily", "thoughtfully", "frantically", "greedily",
		"helplessly", "needlessly", "forcefully", "crazily",
		"slowly", "quickly", "hardly", "quietly", "loudly", "fully",
		"dreadfully", "fearlessly", "fearfully", "frightfully",
		"thoroughly", "incompletely", "completely", "reluctantly",
		"helpfully", "basically", "unsanitarily", "insanely", "mostly",
		"dashingly", "truly", "lovingly", "daringly", "stupidly",
		"refreshingly", "shockingly", "merrily", "strangely", "oddly",
		"sickly", "lately", "recently", "unceasingly", "powerfully",
		"abnormally", "adversely", "nonsensically", "disgustingly",
		"willfully", "astonishingly", "erotically", "freakishly",
		"sheepishly", "feverishly", "needlessly", "unnecessarily",
		"unproductively", "productively", "cleverly", "shyly",
		"astonishingly", "intermediately", "solemnly", "robotically",
		"parentally", "maternally", "eternally", "mystically",
		"romantically", "inhumanely",
		"hopefully", "hopelessly", "subtly", "indescribably",
		"uneventfully", "absent-mindedly", "unobjectably",
		"informatively", "randomly", "gingerly", "instantly"
		};
#define	num_adverbs	(sizeof(adverbs)/4)

char *verbs_now[] = { "runs", "walks", "drives", "plays", "taxes",
		"celebrates", "hikes", "rolls", "cancels",
		"steals", "destroys", "demolishes", "programs", "drains",
		"generates", "helps", "hurts", "scares", "underestimates",
		"attends", "protests", "calls", "asks", "steers", "fears",
		"handles", "flies", "drinks", "eats", "builds", "encourages",
		"loves", "takes revenge on", "leans on", "falls on",
		"strains", "drops", "mixes", "seduces", "pulls a Monica on",
		"likes to quote", "oxidizes", "reduces", "unleashes",
		"restrains", "chokes", "gets in a fight with", "burns",
		"devours", "abuses", "neglects", "nurtures", "cleans",
		"pounds on", "flattens", "Pasteurizes", "radiates", "expels",
		"excretes", "authorizes", "punches", "does the dishes with",
		"wastes", "evades", "avoids", "scowls at", "dances with",
		"has a crush on", "wants", "likes cake topped with",
		"has never eaten", "never wants to hurt", "gets it on with",
		"becomes as disgusting as", "cheats on", "interrupts",
		"locates", "differentiates", "identifies", "lynches",
		"smashes", "kisses", "flatters", "impresses", "tricks",
		"loosens", "is", "stalks", "silences", "beheads", "annoys",
		"catalyzes", "imagines", "admires", "adores", "believes",
		"forgets", "stores", "sneezes at", "digests", "steps on",
		"writes", "screams at", "polishes", "glares at", "knocks",
		"knocks", "knocks", "drives through", "interrogates",
		"escapes", "reprimands", "marries", "pulled"
		};
#define	num_verbs_now	(sizeof(verbs_now)/4)

char *verbs_plural[] = { "run", "walk", "drive", "play", "tax", "celebrate",
		"hike", "roll", "cancel", "steal", "destroy",
		"demolish", "program", "drain", "generate", "help", "hurt",
		"scare", "underestimate", "attend", "protest", "call", "ask",
		"steer", "fear", "handle", "fly", "drink", "eat", "build",
		"encourage", "love", "write", "scream at", "knock", "knock",
		"escape", "reprimand", "marry", "pull"
		};
#define	num_verbs_plural	(sizeof(verbs_plural)/4)

char *verbs_past[] = { "ran", "walked", "drove", "played", "taxed", "celebrated",
		"hiked", "rolled", "stole", "cancelled", "dropped", "destroyed",
		"demolished", "programmed", "drained", "generated", "helped",
		"hurt", "scared", "underestimated", "attended", "protested",
		"called", "asked", "steered", "feared", "handled", "flew",
		"drank", "ate", "built", "tented", "loved", "encouraged",
		"talked to", "murdered", "disguised", "Pasteurized", "radiated",
		"expelled", "pounded on", "flattened", "abused", "neglected",
		"performed surgery on", "invaded", "hit", "shot", "knocked",
		"disgusted", "repelled", "annoyed", "sprang out of",
		"hatched from", "cheated on", "pulled a Monica on",
		"hacked", "ICMP flooded", "neutered", "spayed", "inscribed",
		"described", "arrested", "smoked", "revived", "buried",
		"sneaked", "burned", "sent a carnation to",
		"shoved a bundle of roses up the bottom of", "sneered at",
		"laughed at", "yelled at", "frowned at", "made faces at",
		"sued", "invented", "forgot", "remembered", "imagined",
		"dreamed about", "had breakfast with", "ate lunch with",
		"cannibalized", "located", "differentiated", "identified",
		"lynched", "smashed", "kissed", "flattered", "impressed",
		"tricked", "loosened", "stalked", "silenced", "beheaded",
		"annoyed", "catalyzed", "imagined", "admired", "adored",
		"believed", "forgot", "stored", "sneezded at", "digested",
		"stepped on", "wrote", "screamed at", "polished", "glared at",
		"knocked", "knocked", "knocked", "drove through",
		"interrogated", "escaped", "reprimanded", "married", "pulled"
		};

#define	num_verbs_past	(sizeof(verbs_past)/4)

#define	lc(x)	(x|0x20)

#define isvowel(x) (x != '-' && (lc(x) == 'a' || lc(x) == 'e' || lc(x) == 'i' \
			|| lc(x) == 'o' || lc(x) == 'u' || x == '+'))

void bprintf(pattern, p1, p2, p3, p4, p5, p6, p7, p8)
char *pattern, *p1, *p2, *p3, *p4, *p5, *p6, *p7, *p8;
{
	char mybuf[255];
	sprintf(mybuf, pattern, p1, p2, p3, p4, p5, p6, p7, p8);
	strcat(sentbuf, mybuf);
}

void find_possibilities()
{
	unsigned long subj_objects, verb_phrases, verbs;
	
	subj_objects =
	  3 +						/* sing. pronouns */
	    (2 *					/* A and The */
	      (						 
	        (num_nouns) +				/* plain nouns */
	        (num_nouns*num_adjectives) +		/* adj-noun */
		(num_nouns*num_adjectives*num_adverbs)	/* all 3 */
	      )
	    );
	verbs = num_verbs_now + num_verbs_past;
	verb_phrases =
		verbs+					  /* plain verbs */
		(num_adverbs*verbs);			  /* adv-verb */
	printf("%d possible subjects + objects, %d possible verb/adverb-verb phrases.\n",
		subj_objects, verb_phrases);
	printf("Total possibilities: (%d * %d * %d) + %d\n", subj_objects,
		subj_objects, verb_phrases, 4*num_verbs_plural);

}

void main(int argc, char *argv[])
{
	int x,y,z,a,plural,numoftimes, cnt;
	struct timeb tb;

	(void)ftime(&tb);	
	srand(time(NULL)+(tb.millitm*3600));
	x = (rand() % 5) + 2;
	for (y = 0; y < x; y++)
		z = rand();
	if (argc > 1 && argv[1])
	{
		if (*argv[1] == 'c')
		{
			find_possibilities();
			return;
		}
		numoftimes = atoi(argv[1]);
	}
	else
		numoftimes = 1;
	for (cnt = 0; cnt < numoftimes; cnt++)
	{
		x = rand() % 4;
		if (x == 0)
		{
			a = rand()%num_subject_pronouns;
			plural = pronoun_plural[a];
			bprintf("%s ", subject_pronouns[a]);
		}
		else
		{
			plural = 0;
			z = rand() % 2;
			bprintf("%s", z == 0 ? "The" : "A");
			x = rand() % 5;
			y = rand() % num_nouns;
			if (x)
			{
				x = rand()%5;
				if (x)
				{
					x = rand()%num_adverbs;
					bprintf("%s %s",
						z && isvowel(*adverbs[x]) ?"n" : "",
						adverbs[x]);
					z = 0;
				}
				x = rand()%num_adjectives;
				bprintf("%s %s",
					(z && isvowel(*adjectives[x]) ? "n" : ""),
					adjectives[x]);
			}
			else if (z && isvowel(*nouns[y]))
				bprintf("n");
			bprintf(" %s ", nouns[y]);
		}
		if ((rand() % 3) != 0)
			bprintf("%s ", adverbs[rand()%num_adverbs]);
		if ((rand() % 7) < 4)
			bprintf("%s ", verbs_past[rand()%num_verbs_past]);
		else
			bprintf("%s ", plural ? verbs_plural[rand()%num_verbs_plural]
				: verbs_now[rand()%num_verbs_now]);
		if ((rand() % 4) == 0)
			bprintf("%s.", object_pronouns[rand()%num_object_pronouns]);
		else
		{
			z = rand() % 2;
			bprintf("%s", z == 0 ? "the" : "a");
			x = rand() % 5;
			y = rand() % num_nouns;
			if (x)
			{
				x = rand()%5;
				if (x)
				{
					x = rand()%num_adverbs;
					bprintf("%s %s",
						z && isvowel(*adverbs[x]) ?"n" : "",
						adverbs[x]);
					z = 0;
				}			
				x = rand()%num_adjectives;
				bprintf("%s %s",
					(z && isvowel(*adjectives[x])) ? "n" : "",
					adjectives[x]);
			}
			else if (z && isvowel(*nouns[y]))
				bprintf("n");
			bprintf(" %s.", nouns[y]);
		}
		printf("%s\n", sentbuf);
		bzero(sentbuf, sizeof(sentbuf));
	}
}