# If you need to, set the following line to the full URL to 
# sproxy.cgi (or whatever you've renamed it to). Example:
# $SpellChk_SproxyURL = 'http://www.mysite.com/cgi-bin/sproxy.pl';
# Most users should leave this unchanged (blank).
$SpellChk_SproxyURL = '';


##################################################
# SpellCheck v1.0.1     Created by Raul Gonzalez #
# Made for NewsPro      Tested on NewsPro v3.7.4 #
# Bugs? Comments? Ideas? @                       # 
#         Email ----> Wrestlinggamer@hotmail.com #
##################################################

push(@Addons_Loaded, 'SpellCheck v1.0.1');
$Addons_List{'SpellCheck v1.0.1'} = ['npa_spellchk.pl', 'Checks the spelling of news items before submission.', 'http://amphibian.gagames.com/addon.cgi?spellchk&1.0.1'];
push(@Addons_DisplaySubForm_Post, 'SpellChk_Button');
push(@Addons_NPHTMLHead_Head, 'SpellChk_Head');
push(@Addons_AdvancedSettingsLoad, 'SpellChk_Settings');
unless ($NPConfig{'SpellCheckLang'}) {
	$NPConfig{'SpellCheckLang'} = 'en';
}



sub SpellChk_Settings {
	$AdvDescr{'SpellCheckID'} = q~
	Your Customer ID from <a href="http://www.spellchecker.net/" target="_blank">SpellChecker.net</a>. If you haven't signed up yet, the process takes about 3 minutes. Once signed up, you will receive your Customer ID via e-mail.~;
	$AdvDescr{'SpellCheckLang'} = q~
	The code for the spell-checking dictionary you'd like to use. Choices: "en" - English, "fr" - French,
	"ge" - German, "it" - Italian, "sp" - Spanish, "dk" - Danish, "br" - Brazilian Portuguese, 
	"nl" - Dutch, "no" - Norwegian, "pt" - Portuguese, "se" - Swedish, "fi" - Finnish.~;
	push(@advancedsettings, 'draw_line', 'SpellCheckID', 'SpellCheckLang');
}

##################################################
# Head JAVASCRIPT link. 
#
	sub SpellChk_Head { 
		print qq~
			<script language= "javascript" src="http://www.spellchecker.net/spellcheck/lf/spch.cgi?customerid=$NPConfig{'SpellCheckID'}"> </script>
		~;	
	}
	
##################################################
# Show SpellCheck Button
#
	sub SpellChk_Button {
		unless ($SpellChk_SproxyURL) {
			$scripturl =~ /^(\S+)\//;
			$SpellChk_SproxyURL = $1 . '/sproxy.cgi';
		}
		unless ($NPConfig{'SpellCheckID'} && $NPConfig{'SpellCheckLang'}) {
			print "The SpellCheck addon is installed, but has not been configured in Advanced Settings.";
		}
		else {
			print qq~
				<input type="button" value="Check Spelling" onclick="var f=document.forms[0]; doSpell ('$NPConfig{'SpellCheckLang'}', f.newstext, '$SpellChk_SproxyURL', true);">
			~;
		}
	}

# FIN.
# Shout-Outs to: Xaken, plushpuffin (I didn't capitalize!), Elvii, and Kyro. 
1;