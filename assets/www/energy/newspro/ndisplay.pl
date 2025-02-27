# ndisplay.pl
# This file contains the HTML used to generate your news.
#
# For more information on NewsPro customisations, see the online FAQ.
#
# Do not change $ndisplayversion below! It tells the script which version of ndisplay.pl this is.
$ndisplayversion = 3;
#
# *********
# IMPORTANT: If you ever edit this file by hand, remove the exclamation mark
# *********  from the next line:
# <Manual!Edit>
# (do not remove the # or anything else, only the exclamation mark)
# This will tell the script that it has been edited by hand, and disable web-based
# editing. If you don't do this, your ndisplay.pl will likely become corrupted.
#
# You may use the following variables in DoNewsHTML:
# $newsname, $newssubject, $newsdate, $newstext, $newsemail.
# Also, remember that this is a Perl script you're editing. Make sure to escape necessary
# characters: i.e. $,@,%,and ~ should be written as \$,\@,\%, and \~ (of course, you 
# shouldn't escape the $ sign in a variable).


sub DoNewsHTML {
# <BeginEdit>
$newshtml = qq~
</td></tr><tr><td colspan=2></td></tr></td></tr><tr><td width=600 colspan=2><img src="images/foot.gif" width="600" height="2" alt="plan:b plan:b plan:b plan:b plan:b plan:b plan:b" border="0"><DIV class="news_subject">$newssubject:</DIV><img src="images/foot2.gif" width="600" height="1" alt="r3verend, jokerbone, Agamemnon, stereotype, bullet, raildog, tgm2000, Monty, Thrash, Lemon, tml..." border="0"><br><br></td></tr><tr><td colspan=2><P>$newstext</P><img src="images/foot2.gif" width=600 height=1 alt="this is a very thin line and it still loves pixels more than you do"></td></tr><tr><td><p>$newsdate</p></td><td align=right><p>$newsname
~;
$newshtml .= qq~<img src="http://online.mirabilis.com/scripts/online.dll?icq=$UGP_ICQ&img=5" alt="$UGP_ICQ">~ if( $UGP_ICQ );

# DO NOT REMOVE THIS LINE! <EndEdit> 
} 


#
# Archive Link Formatting. Edit the HTML below to change the style.
# This defines the links on the main archive page, the one that
# links to the individual monthly archives.
# The location of the archive is $arcfile.$ArcHtmlExt and the 
# month the archive covers is $ArcDate{$arcfile}.
# Reminder: if editing this file by hand, follow the instructions
# at the top of the file or the script may not function.
sub DoLinkHTML {
	$newshtml = qq~
<a href="$arcfile.$ArcHtmlExt">$ArcDate{$arcfile}</a><br>
~;
}
#
# Headline Formatting.
# This defines the headlines that will be produced if you enable headlines
# (in Advanced Settings).
# You have access to all the variables as in DoNewsHTML.
# TIP: To link the headline to your full news article, use a link like:
# <a href="http://my.site/mynewspage.html#newsitem$newsid">$newssubject</a>
sub DoHeadlineHTML {
	$newshtml = qq~
<b>$newssubject</b> - $newsdate <br>
~;
}
#
#
# New Files Formatting
# The format of the file links on the new files list (enabled via Advanced Settings).
# $fileurl: URL of the file
# $filetitle: Name or title of the file
# $filedate: Date the file was last modified
sub DoNewFileHTML {
	$newshtml = qq~
<a href="$fileurl">$filetitle</a><br>
~;
}
# Email Notification
# How the e-mail notifications sent will look.
# If you choose to have news items sent manually, in batches,
# you'll be able to edit this before sending. Otherwise, this will be
# the text of the message.
#
# You have access to all the new variables, as in DoNewsHTML.
sub DoEmailText {
	$newshtml = qq~
---------------------------------
$newssubject
---------------------------------
Posted $newsdate by $newsname:
$newstext
~;
}
# Archive HTML
# The news style used when archiving.
# By default, calls DoNewsHTML. If you'd like a different style, replace this with something like
# sub DoArchiveHTML {
# $newshtml = qq~
# <p><strong><font color="#ff0000">$newssubject</font> </strong><small>Posted $newsdate by <a href="mailto:$newsemail">$newsname</a></small><br>
# $newstext
# </p>
# ~;
# }

sub DoArchiveHTML {
# <BeginEdit>
$newshtml = qq~
</td></tr><tr><td colspan=2><img src="../images/foot.gif" width="600" height="2" alt="" border="0"><br><br></td></tr></td></tr><tr><td width=600 colspan=2><img src="../images/newsbar.gif" width="600" height="1" alt="" border="0"><DIV class="news_subject">$newssubject:</DIV><img src="../images/newsbar.gif" width="600" height="1" alt="" border="0"><br><br></td></tr><tr><td colspan=2><P>$newstext</P></td></tr><tr><td>$newsdate</td><td align=right>$newsname
~;
$newshtml .= qq~<img src="http://online.mirabilis.com/scripts/online.dll?icq=$UGP_ICQ&img=5" alt="$UGP_ICQ">~ if( $UGP_ICQ );

# DO NOT REMOVE THIS LINE! <EndEdit> 
} 
# Search HTML
# Much like archive HTML - by default, uses DoNewsHTML.
sub DoSearchHTML {
&DoNewsHTML;
}
1;
