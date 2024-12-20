#!/usr/bin/perl

#
###                  FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998 -2000.
#
#       ------------ forumdisplay.cgi -------------
#
#  This file contains functionality for the Freeware UBB.
#
#  Infopop Corporation offers no
#  warranties on this script.  The owner/licensee of the script is
#  solely responsible for any problems caused by installation of
#  the script or use of the script, including messages that may be
#  posted on the BB.
#
#  All copyright notices regarding the Ultimate Bulletin Board
#  must remain intact on the scripts and in the HTML
#  for the scripts.  These "powered by" and copyright notices MUST
#  remain visible when the pages are viewed on the Internet.
#
#  You may not SELL this script.  You may offer it freely to others.
#  It is freeware.  You may not alter the code and then call it another
#  name.  You may not alter the code and then resell it under another
#  name, either.
#
# For more info on the Ultimate BB, including licensing info,
# see http://www.UltimateBB.com
#
###############################################################
#
#If you are running UBB on IIS,
#you may need to add the following line
#if so, just remove the "#" sign before the print line below
#print "HTTP/1.0 200 OK\n";
eval {
  ($0 =~ m,(.*)/[^/]+,)   && unshift (@INC, "$1"); # Get the script location: UNIX / or Windows /
  ($0 =~ m,(.*)\\[^\\]+,) && unshift (@INC, "$1"); # Get the script location: Windows \
 
#substitute all require files here for the file

require "UltBB.setup";
require "Date.pl";
require "mods.file";
require "ubb_library.pl";

};

print ("Content-type: text/html\n\n");

if ($@) {
    print "Error including required files: $@\n";
    print "Make sure these files exist, permissions are set properly, and paths are set correctly.";
 exit;
}

&ReadParse;

foreach $row(@in) {
	($Name, $Value) = split ("=", $row);
	$Name = &decodeURL($Name);
	$Value = &decodeURL($Value);
		if ($Name eq "forum") {
			$Forum = $Value;
			$Forum =~ s/\/\\//g;
			$ForumCoded = &HTMLIFY($Forum);
			$ForumCoded =~ tr/ /+/;
			$Forum = &UNHTMLIFY($Forum);
	}
		if ($Name eq "TopicSubject") {
			$TopicSubject = $Value;
			$TopicSubject =~ s/<.+?>//g;
			$TopicSubject = &UNHTMLIFY($TopicSubject);
	}
		if ($Name eq "UserName") {
		$UserName = $Value;
		$UserNameFile = $UserName;
		$UserNameFile =~ s/ /_/g; #remove spaces
	}

		if ($Name eq "PasswordConfirm") {
			$PasswordConfirm = $Value;
		}

		if ($Name eq "number") {
			$number = $Value;
			$number =~ s/\D//g;
	}
		if ($Name eq "DaysPrune") {
			$DaysPrune = $Value;
	}
	if ($Name eq "topic") {
			$topic = $Value;
	}

}  # end FOREACH $row

if ($VariablesPath eq "") {
	$VariablesPath = $CGIPath;
}

		$SubjectCoded = &HTMLIFY($TopicSubject);
		$SubjectCoded =~ tr/ /+/;
		


if (@in == 0) {
&Topics;
}
 
if ($in{'action'} eq "topics") {
 &Topics;
 }  


sub Topics {


if ($DaysPrune eq "") {
$DaysPrune = "20";
}

@thisforum = &GetForumRecord($number);

$Moderator = ("Forum" . "$number" . "Moderator");
$Moderator = $$Moderator;
$Forum = $thisforum[1];
$CustomTitle = $thisforum[9];
chomp($CustomTitle);


$ForumCoded = &HTMLIFY($Forum);
$ForumCoded =~ tr/ /+/;

@theprofile = &OpenProfile("$Moderator.cgi");
	
$ModeratorEmail = "$theprofile[2]";


&TopicTopHTML;

&CurrentDate;

##### create new day summary file, if necessary
unless (-e "$ForumsPath/Forum$number/$RunOnDate.threads") {
my $CreateThreadFile = "yes";
&ForumSummary($number);
## REMOVE OLDER .threads file, if necessary
# @threadfiles contains list of all thread files
foreach $threadfile(@threadfiles) {
	if ($threadfile ne "$RunOnDate.threads") {
		unlink ("$ForumsPath/Forum$number/$threadfile");
	}
}
}  # end UNLESS THREADS SUMMARY EXISTS
##########

if ($CreateThreadFile ne "yes") {
#open thread file online
open (THREADS, "$ForumsPath/Forum$number/$RunOnDate.threads") or die(&StandardHTML("Unable to read Forum$number thread summary file $!"));
@finalarray = <THREADS>;
close (THREADS);
}
@finalarray = sort(@finalarray);

## @finalarray hold thread summary used to display page

$x = $number;
#set Days Prune variable to 3 digits for matching--

if ($DaysPrune == 1) {
	$Days1 = "SELECTED";
	 @finalarray = grep (/^000|001/, @finalarray);
}

if ($DaysPrune == 2) {
	$Days2 = "SELECTED";
	@finalarray = grep (/^(000|001|002)/, @finalarray);
}

if ($DaysPrune == 5) {
	$Days5 = "SELECTED";
		@finalarray = grep (/^(000|001|002|003|004|005)/, @finalarray);
}

if ($DaysPrune == 10) {
	$Days10 = "SELECTED";
		@finalarray = grep (/^(000|001|002|003|004|005|006|007|008|009|010)/, @finalarray);
}

if ($DaysPrune == 20) {
	$Days20 = "SELECTED";
}

if ($DaysPrune == 30) {
	$Days30 = "SELECTED";
}

if ($DaysPrune == 45) {
	$Days45 = "SELECTED";
}

if ($DaysPrune == 60) {
	$Days60 = "SELECTED";
}

if ($DaysPrune == 75) {
	$Days75 = "SELECTED";
}

if ($DaysPrune == 100) {
	$Days100 = "SELECTED";
}

if ($DaysPrune == 365) {
	$Days365 = "SELECTED";
}

&TopicMidHTML;

CHECKEACH: for $eachone(@finalarray) {

	@threadinfo = split(/\|\^\|/, $eachone);
	
	if ($threadinfo[0] <= $DaysPrune) {
	#format date
	my $ThisMonth = substr($threadinfo[2], 4, 2);
	my $ThisYear = substr($threadinfo[2], 0, 4);
	my $ThisDay = substr($threadinfo[2], 6, 2);
	my $JYear = substr($threadinfo[2], 0, 4);
	$hour = substr($threadinfo[2], 8, 2);
	$min = substr($threadinfo[2], 10, 2);
	
	if ($DateFormat eq "Euro") {
	$TheDate = "$ThisDay-$ThisMonth-$ThisYear";
	$DateWording = "All dates are in Day-Month-Year format.";
	}  else {
	$TheDate = "$ThisMonth-$ThisDay-$ThisYear";
	$DateWording = "All dates are in Month-Day-Year format.";
	}
	


#format time option 1
	if ($TimeFormat eq "24HR")  {
		$FormatTime = "$hour:$min";
	}
	&NormalTime;

#format time option 2
	if ($TimeFormat eq "AMPM")  {
		$FormatTime = "$hour:$min $AMPM";
	}

&TopicGutsHTML;
}  else {   #if within prune range
last CHECKEACH;
}
}

&TopicBottomHTML;
&GetForumSelectList;
&TopicBottom2NonJShtml;


}  ## END TOPICS SR ####


sub TopicTopHTML {
print <<TOP;
<HTML>
<HEAD><TITLE>$BBName</title>
<link REL="SHORTCUT ICON" href="$NonCGIURL/ubbfavicon.ico">
</head>
 <BODY bgcolor="#FFFFFF" text="#000000" link="#000080" vlink="#800080" topmargin=0>
<FONT SIZE="2" FACE="Verdana, Arial">
<b>
TOP
}  ## END TOPIC TOP HTML sr

sub TopicMidHTML {
print <<OtherMiddle;
<center>
<table border=0 width=95%>
<tr>
<td align=left valign=top>
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/bbtitle5.jpg" BORDER=0></A>
<BR>
<FONT SIZE="2" FACE="Verdana, Arial" color="#000080"><B>$Forum</B>
<br><FONT size= "1" COLOR="#800080">(moderated by <A HREF="mailto:$ModeratorEmail">$Moderator</A>)
<P>
</FONT></font>
</td>
<td valign=top nowrap><FONT SIZE="1" FACE="Verdana, Arial">
<IMG SRC="$NonCGIURL/open.gif" WIDTH=15 HEIGHT=11 BORDER=0>&nbsp;&nbsp;<A HREF="$CGIURL/Ultimate.cgi?action=intro"><ACRONYM TITLE="Return to summary page of all forums.">$BBName</ACRONYM></A>
<br>
<IMG SRC="$NonCGIURL/tline.gif" WIDTH=12 HEIGHT=12 BORDER=0><IMG SRC="$NonCGIURL/open.gif" WIDTH=15 HEIGHT=11 BORDER=0>&nbsp;&nbsp;$Forum
<P>
<CENTER>
<FONT SIZE="2" FACE="Verdana, Arial">
<A HREF="$CGIURL/postings.cgi?action=newtopic&number=$number&forum=$ForumCoded&DaysPrune=$DaysPrune"><IMG SRC="$NonCGIURL/topic5.jpg"  BORDER=0 ALT="Post New Topic"></A></FONT>
<BR>
<A HREF="$CGIURL/ubbmisc.cgi?action=editbio&Browser=$Browser&DaysPrune=$DaysPrune"><ACRONYM TITLE="Click here to edit your profile.">profile</ACRONYM></A> | <A HREF="$CGIURL/Ultimate.cgi?action=agree"><ACRONYM TITLE="Registration is free!">register</ACRONYM></A> | <A HREF="$NonCGIURL/faq.html" target=_blank><ACRONYM TITLE="Frequently Asked Questions">faq</ACRONYM></A>
<p>
<FORM ACTION="forumdisplay.cgi" METHOD="GET">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="topics">
<INPUT TYPE="HIDDEN" NAME="forum" VALUE="$Forum">
<INPUT TYPE="HIDDEN" NAME="number" VALUE="$number">
<SELECT NAME="DaysPrune">
	<OPTION value="1" $Days1>Show topics from last day
	<OPTION value="2" $Days2>Show topics from last 2 days
	<OPTION value="5" $Days5>Show topics from last 5 days
	<OPTION value="10" $Days10>Show topics from last 10 days
	<OPTION value="20" $Days20>Show topics from last 20 days
	<OPTION value="30" $Days30>Show topics from last 30 days
	<OPTION value="45" $Days45>Show topics from last 45 days
	<OPTION value="60" $Days60>Show topics from last 60 days
	<OPTION value="75" $Days75>Show topics from last 75 days
	<OPTION value="100" $Days100>Show topics from last 100 days
	<OPTION value="365" $Days365>Show topics from the last year
</SELECT>
<INPUT TYPE="SUBMIT" NAME="SUBMIT" VALUE="Go">
</FORM>
</center>
</FONT>
</td></tr></table>

<table border=0 width=95%>
<tr bgcolor="#D5E6E1">
<td>
<FONT SIZE="1" FACE="Verdana, Arial" color="#000080">Topic</FONT>
</td>
<td>
<FONT SIZE="1" FACE="Verdana, Arial" color="#000080">Originator</FONT>
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial" color="#000080">Replies</FONT>
</td>
<td NOWRAP><FONT SIZE="1" FACE="Verdana, Arial" color="#000080">Last Post</FONT>
</td></tr>
OtherMiddle
}  ## END Middle HTML for Topic Page 

sub TopicGutsHTML {
print <<GUTS;
<TR>
<TD bgcolor="#F7F7F7"><IMG SRC="$NonCGIURL/closed.gif" WIDTH=14 HEIGHT=11 BORDER=0><FONT SIZE="2" FACE="Verdana, Arial">&nbsp;
<A HREF="$NonCGIURL/Forum$number/HTML/$threadinfo[3]">$threadinfo[4]</A>
</FONT>
</td>
<td bgcolor="#dedfdf">
<FONT SIZE="2" FACE="Verdana, Arial">$threadinfo[6]</FONT>
</td>
<td align=center bgcolor="#F7F7F7">
<FONT SIZE="2" FACE="Verdana, Arial">$threadinfo[5]</FONT>
</td>
<td NOWRAP bgcolor="#dedfdf">
<FONT SIZE="2" FACE="Verdana, Arial">$TheDate <FONT SIZE="1" FACE="Verdana, Arial" COLOR="#000080">$FormatTime</FONT></FONT>
</td></tr>
GUTS
}  ## END Guts HTML for Topic Page


sub TopicBottomHTML {
print<<BOTTOM
</table>
<br>
<table border=0 width=95%>
<tr><td align=left valign=top>
<FONT SIZE="1" FACE="Verdana, Arial" COLOR="#800080">All times are $TimeZone. $DateWording</FONT></td>
<td align=right NOWRAP>
<FONT SIZE="2" FACE="Verdana, Arial">
<FORM ACTION="forumdisplay.cgi" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="topics">
<B>Hop to: </B><SELECT NAME="number">
BOTTOM
} ## End TopicBottomNonIEhtml

sub TopicBottom2NonJShtml {
print<<TrueTopicBottom;
</SELECT><INPUT TYPE="SUBMIT" NAME="SUBMIT" VALUE="Go"></FORM></FONT></TD></tr></TABLE>
</center>

<p>
<CENTER><A HREF="$CGIURL/postings.cgi?action=newtopic&number=$number&forum=$ForumCoded">Post New Topic</A><P>
TrueTopicBottom

&PageBottomHTML;
}

