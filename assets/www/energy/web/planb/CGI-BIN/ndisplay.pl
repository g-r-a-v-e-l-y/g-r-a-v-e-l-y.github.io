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
<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0>	<TR>		<TD COLSPAN=5>			<IMG SRC="images/newscard_01.gif" WIDTH=516 HEIGHT=5></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=5></TD>	</TR>	<TR>		<TD ROWSPAN=4>			<IMG SRC="images/newscard_02.gif" WIDTH=9 HEIGHT=64></TD>		<TD align=top background="images/newscard_03.gif" WIDTH=232 HEIGHT=32 ROWSPAN=2><center></center>			</TD>		<TD COLSPAN=3>			<IMG SRC="images/newscard_04.gif" WIDTH=275 HEIGHT=13></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=13></TD>	</TR>	<TR>		<TD ROWSPAN=3>			<IMG SRC="images/newscard_05.gif" WIDTH=13 HEIGHT=51></TD>		<TD background="images/newscard_06.gif" WIDTH=241 HEIGHT=31 ROWSPAN=2><center><font face="arial, verdana, sans-serif" color="#ffffff" size=1>$newsdate</font></center> 			</TD>		<TD ROWSPAN=3>			<IMG SRC="images/newscard_07.gif" WIDTH=21 HEIGHT=51></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=19></TD>	</TR>	<TR>		<TD ROWSPAN=2>			<IMG SRC="images/newscard_08.gif" WIDTH=232 HEIGHT=32></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=12></TD>	</TR>	<TR>		<TD>			<IMG SRC="images/newscard_09.gif" WIDTH=241 HEIGHT=20></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=20></TD>	</TR>	<TR>		<TD background="images/newscard_10.gif" WIDTH=516 HEIGHT=2 COLSPAN=5><center>			<table width="470"><tr>       <td><font face="arial, verdana, san-serif" color="#ffffff"><b>$newssubject:</b>&nbsp; $newstext	   <br></font>	   <br>	   <p align="right">	   <font face="arial" color="#ffffff" size=2>posted by: <a href="$newsemail">$newsname</a></font></p></td></tr></table></center></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=2></TD>	</TR>		<TR>		<TD COLSPAN=5>			<IMG SRC="images/newscard_12.gif" WIDTH=516 HEIGHT=26></TD>		<TD>			<IMG SRC="images/spacer.gif" WIDTH=1 HEIGHT=26></TD>	</TR></TABLE>
~;
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
&DoNewsHTML;
}
# Search HTML
# Much like archive HTML - by default, uses DoNewsHTML.
sub DoSearchHTML {
&DoNewsHTML;
}
1;
