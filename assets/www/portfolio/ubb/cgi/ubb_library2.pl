## UBB COMMON ROUTINE LIBRARY

sub CheckModStatus {
my($forumnumber, $UserName) = @_;
$GetModerator = ("$forumnumber" . "Moderator");
$GetModerator = $$GetModerator;
if ($GetModerator eq "$UserName") {
	$ModMatch = "yes";
	}  else {
	$ModMatch = "no";
	}
return ($ModMatch);
}

sub CheckPermissions {
		if ($Permission =~ m/Admin/) {
			$AdminPermission = "true";
		} else {
			$AdminPermission = "false";
		}
		
		if ($Permission =~ m/Write/) {
			$PermissionToWrite = "true";
			$AdminWrite = "true";
		} else {
			$PermissionToWrite = "false";
			$AdminWrite = "false";
		}
		
		if ($Permission =~ m/Moderator/) {
			$AdminMod = "true";
		} else {
			$AdminMod = "false";
		}
		
} #end CheckPermissions

sub CheckTheStatus {

		if ($Status =~ m/Administrator/) {
			$AdminStatus = "true";
			} else {
			$AdminStatus = "false";
		}
		

		if ($Status =~ m/Moderator/) {
			$ModStatus = "true";
		} else {
			$ModStatus = "false";
		}
		if ($Permission =~ m/Write/) {
			$AdminWrite = "true";
		} else {
			$AdminWrite = "false";
		}

} #end CheckTheStatus

sub ConvertForums2HTML {
my($ForumNumber) = shift;
my($ForumTotal) = shift;
my($StartWith) = shift;

$number = "$ForumNumber";

@thisforum = &GetForumRecord($number);
$Forum = $thisforum[1];
$ForumCoded = &HTMLIFY($Forum);
$ForumCoded =~ tr/ /+/;

#retrieve all topics 
opendir (GETTHREADS, "$ForumsPath/Forum$number");
	@threads = readdir (GETTHREADS);
closedir (GETTHREADS);
@threads = grep(/\.ubb/, @threads);
@threads = sort(@threads);

($lonumber, @junky) = split(/\./, $threads[0]);
$LowNumber = $lonumber + 0;

#limit processing to 300 threads at a time
$Start = $StartWith + 0;
if ($LowNumber > $StartWith) {
	$Start = $LowNumber;
}
$End = $Start + 300;


#determine highest thread number!
@highest = reverse(@threads);
($hinumber, @junk) = split(/\./, $highest[0]);
$High = $hinumber + 0;
$GoToNextForum = "";

if ($High <= $End) {
	$End = $High;
	$GoToNextForum = "true";
}
$Stop = "";
my $New = "";
my $Last = "";

CHECKEACH: for $eachthread(@threads) {

	$ThreadNum = substr($eachthread, 0, 6);
	$ThreadNumber = $ThreadNum + 0;
		$Last = $New;
		if (($ThreadNumber >= $Start) && ($ThreadNumber <= $End)) {		
				chomp($eachthread);
			$New = "true";
			&CreateThreadHTML("Forum$number", "$eachthread");
		}  else {
			$New = "false";
		} 
		if (($New eq "false") && ($Last eq "true")) {
		last CHECKEACH;
		}
} #end for threads loop

if ($GoToNextForum eq "true") {
$number++;
$previous = ($number - 1);
$StartWith = 0;
} else {
$previous = $number;
$StartWith = $End + 1;
}
$UserName =~ tr/ /+/;
$Password =~ tr/ /+/;


if ($number <= $TotalForums) {
print<<NEXT;
<HTML><HEAD>
<meta http-equiv="Refresh" content="2; URL=$CGIURL/cpanel2.cgi?action=ContinueUpdate&number=$number&TotalForums=$TotalForums&UserName=$UserName&Password=$Password&StartWith=$StartWith">
</head>
<BODY bgcolor=$BGColor>
<center>
<FONT FACE="$FontFace" SIZE="2"><B>
<FONT FACE="Times New Roman" SIZE="4" COLOR="Maroon"><B>Processing....</B></FONT>
<P>
We are updating each of your existing threads to reflect all current settings in the control panel.<P>
Forum <FONT FACE="Verdana" SIZE="2" COLOR="Navy">$previous</FONT> is currently being updated.  Please wait while we continue updating! </B>
<P>
We just finished updating threads <FONT FACE="Verdana" SIZE="2" COLOR="Navy">$Start</font> through <FONT FACE="Verdana" SIZE="2" COLOR="Navy">$End</font> in Forum <FONT FACE="Verdana" SIZE="2" COLOR="Navy">$previous</font>
</FONT>
</center>
</BODY>
</HTML>
NEXT
}  else {

print<<CONFIRM;
<HTML><BODY BGCOLOR="$BGColor">
<BR><BR>
<CENTER><B><FONT SIZE="5" FACE="Courier New">All threads have been updated to reflect your current control panel settings.
<P>
Thank you!</FONT></B></CENTER>
</BODY></HTML>
CONFIRM

}
}  # end ConvertForums2HTML sr

sub CreateThreadHTML {
my($ForumIs) = shift;
my($ThreadFile) = shift;

$ThreadNumber = substr($ThreadFile, 0, 6);

my @threadinfo = &OpenThread("$ThreadFile");
@statarray = split(/\|\|/, $threadinfo[0]);

$UNCoded = $statarray[3];
$UNCoded =~ tr/ /+/;
$TopicSubject = $statarray[4];
chomp($TopicSubject);
	$SubjectCoded = &HTMLIFY($TopicSubject);
			$SubjectCoded =~ tr/ /+/;


	#PRINT THREAD TOP---
	
unless (-d "$ForumsPath/$ForumIs/HTML") {
mkdir("$ForumsPath/$ForumIs/HTML", 0777);
chmod (0777, "$ForumsPath/$ForumIs/HTML");
}

($trash, $number) = split("Forum", $ForumIs);
#@thisforum = &GetForumRecord($number);

$ThisThread = qq(<HTML><HEAD><TITLE>$TopicSubject - $BBName</title><META HTTP-EQUIV="Pragma" CONTENT="no-cache"></head> <BODY bgcolor="$BGColor"   text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<FONT SIZE="2" FACE="$FontFace">
<b>
<table border=0 width=95%><TR>
<td valign=top align=left><A HREF="$CGIURL/Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle" BORDER=0></A>
<BR><center><FONT SIZE="1" FACE="$FontFace" COLOR="$LinkColor"></FONT></center>
</FONT>
</td>
<td valign=top NOWRAP>
<FONT SIZE="1" FACE="$FontFace">
<IMG SRC="$NonCGIURL/open.gif" WIDTH=15 HEIGHT=11 BORDER=0>&nbsp;&nbsp;<A HREF="$CGIURL/Ultimate.cgi?action=intro">$BBName</A>
<br>
<IMG SRC="$NonCGIURL/tline.gif\" WIDTH=12 HEIGHT=12 BORDER=0><IMG SRC="$NonCGIURL/open.gif" WIDTH=15 HEIGHT=11 BORDER=0>&nbsp;&nbsp;<A HREF="$CGIURL/forumdisplay.cgi?action=topics&forum=$ForumCoded&number=$number">$Forum</A>
<br>
<IMG SRC="$NonCGIURL/tline3.gif" WIDTH=24 HEIGHT=12 BORDER=0><IMG SRC="$NonCGIURL/open.gif" WIDTH=15 HEIGHT=11 BORDER=0>&nbsp;&nbsp;$TopicSubject
<center>
<P><FONT SIZE=\"2\" FACE=\"$FontFace\">
<A HREF="$CGIURL/postings.cgi?action=newtopic&number=$number&forum=$ForumCoded"><IMG SRC="$NonCGIURL/$BBTopic"  BORDER=0 ALT="Post New Topic"></A>&nbsp;&nbsp;<A HREF="$CGIURL/postings.cgi?action=reply&forum=$ForumCoded&number=$number&topic=$ThreadFile&TopicSubject=$SubjectCoded"><IMG SRC="$NonCGIURL/$BBReply" border=0></A></FONT>
<BR>
<A HREF=\"$CGIURL/ubbmisc.cgi?action=editbio&Browser=$Browser&DaysPrune=$DaysPrune"><ACRONYM TITLE=\"Click here to edit your profile.\">profile</ACRONYM></A> | <A HREF="$CGIURL/Ultimate.cgi?action=agree"><ACRONYM TITLE=\"Registration is free!">register</ACRONYM></A>  | <A HREF="$NonCGIURL/faq.html" target=_blank><ACRONYM TITLE=\"Frequently Asked Questions">faq</ACRONYM></A>
</center>
</td></tr></table>);

@fatherarray = split(/\|\|/, $threadinfo[1]);

$theDate = "$fatherarray[3]";
#format date
@datearray = split(/-/, $theDate);
chomp($datearray[2]);
$YearCheck = $datearray[2];
$YearCheck = $YearCheck + 0;
$CheckThisYear = length($YearCheck);
if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$TheYear = ("19" . "$YearCheck");
		}  else {
		$TheYear = $YearCheck - 100;
		$TheYear = sprintf ("%2d", $TheYear);
		$TheYear =~tr/ /0/;
		$TheYear = ("20" . "$TheYear");
		}
}  else {
$TheYear = $YearCheck;

}


if ($DateFormat eq "Euro") {
$ThisDate = "$datearray[1]-$datearray[0]-$TheYear";
}  else {
$ThisDate = "$datearray[0]-$datearray[1]-$TheYear";
}

chomp($fatherarray[6]);

$theTime = "$fatherarray[4]";
#format time option 1
	if ($TimeFormat eq "24HR")  {
		($SplitTime, $TheAMPM) = split(/ /, $theTime);
		chomp($TheAMPM);
		($gethr, $getmin) = split(/:/, $SplitTime);
			&ConvertTo24Hour;
				$FormatTime = "$gethr:$getmin";
	} else {
		$FormatTime = "$theTime";
	}

## PRINT THREAD GUTS

#get topic writer's email view status
@thisprofile = &OpenProfile("$statarray[3].cgi");
$EmailView = $thisprofile[11];

if (($EmailBlock eq "ON") || ($EmailView eq "no")) {
$EmailString = "&nbsp;";
}  else {
$EmailString = qq(&nbsp;&nbsp;<A HREF="$CGIURL/Ultimate.cgi?action=email&ToWhom=$UNCoded" target=_new><IMG SRC="$NonCGIURL/$mailgif" BORDER=0 WIDTH=24 HEIGHT=11 ALT="Click Here to Email $statarray[3]"></A>&nbsp;&nbsp;);
} 	

$ThisThread .= qq(<center><table width=95% border=0 cellpadding=5><TR bgcolor="$TableColorStrip">
<TD valign=middle width=18%>
<FONT SIZE="1" face="$FontFace" color="$TableStripTextColor"><B>Author</B></FONT>
</TD>
<TD valign=middle>
<FONT SIZE="1" face="$FontFace" color="$TableStripTextColor"><B>Topic:&nbsp;&nbsp; $TopicSubject</B></FONT>
</TD>
</TR>
<tr bgcolor="$AltColumnColor1">
<td NOWRAP width=18% valign=top>
<FONT SIZE="2" face="$FontFace"><B>$statarray[3]</B></FONT></td>
</TD>
<td valign=top>
<IMG SRC="$NonCGIURL/posticon.gif" BORDER=0>
<FONT SIZE="2" FACE="$FontFace">
<FONT SIZE="1" color="$LinkColor" face="$FontFace">posted $ThisDate $FormatTime $TimeZone&nbsp;&nbsp;&nbsp;<A HREF="$CGIURL/ubbmisc.cgi?action=getbio&UserName=$UNCoded" target=_new><IMG SRC="$NonCGIURL/$profilegif" WIDTH=22 HEIGHT=11 BORDER=0 ALT="Click Here to See the Profile for $statarray[3]"></A> $EmailString 
</FONT><HR>$fatherarray[6]</FONT>
</td></tr>);

#get Replies to this topic

my $TotalReplies = $statarray[2];

if ($TotalReplies > 0) {
$AlternateColor = "$AltColumnColor2";

foreach $line(@threadinfo) {
	@thisline = split(/\|\|/, $line);
	$ReplyNo = $thisline[1] + 0;
	if (($thisline[0] eq "Z")  && ($ReplyNo > 0)) {
		$UserNameCoded = $thisline[2];
		$UserNameCoded =~ tr/ /+/;

		$theDate = "$thisline[3]";
		#format date
				@datearray = split(/-/, $theDate);
				chomp($datearray[2]);
		$YearCheck = $datearray[2];
$YearCheck = $YearCheck + 0;
$CheckThisYear = length($YearCheck);
if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$TheYear = ("19" . "$YearCheck");
		}  else {
		$TheYear = $YearCheck - 100;
		$TheYear = sprintf ("%2d", $TheYear);
		$TheYear =~tr/ /0/;
		$TheYear = ("20" . "$TheYear");
		}
}
			if ($DateFormat eq "Euro") {
		
				$ThisDate = "$datearray[1]-$datearray[0]-$TheYear";
			}  else {
				$ThisDate = "$datearray[0]-$datearray[1]-$TheYear";
			}
		
		#format time
		if ($TimeFormat eq "24HR")  {
			@timearray = split(/ /, $thisline[4]);
			chomp($timearray[1]);
			($gethour, $getmin) = split(/:/, $timearray[0]);
				if ($timearray[1] eq "PM") {		
					if ($gethour < 12) {
						$gethour = ($gethour  + 12);
					}
				}
		if ($AMpm eq "AM") {		
			if ($gethour == 12) {
				$gethour = "0";
			}
		}
		$gethour = sprintf ("%2d", $gethour);
		$gethour =~tr/ /0/;
		$getmin = sprintf ("%2d", $getmin);
		$getmin =~tr/ /0/;
		$FormatTime = "$gethour:$getmin";
		} else {
		$FormatTime = "$thisline[4]";
		}
		$theTime = "thisline[4]";
	
		$ReplyText = $thisline[6];
		chomp($ReplyText);
		
		#get reply writer's email view status
@thisprofile = &OpenProfile("$thisline[2].cgi");
$EmailView = $thisprofile[11];

if (($EmailBlock eq "ON") || ($EmailView eq "no")) {
$EmailString = "&nbsp;";
}  else {

$EmailString = qq(&nbsp;&nbsp;<A HREF="$CGIURL/Ultimate.cgi?action=email&ToWhom=$UserNameCoded" target=_new><IMG SRC="$NonCGIURL/$mailgif" BORDER=0 WIDTH=24 HEIGHT=11 ALT="Click Here to Email $thisline[2]"></A>&nbsp;&nbsp;);
} 	

$ThisThread .= qq(<tr bgcolor="$AlternateColor">
	<TD width=18% valign=top>
	<FONT SIZE="2" face="$FontFace"><B>$thisline[2]</B></FONT>
</td>
<TD>
<IMG SRC="$NonCGIURL/posticon.gif" BORDER=0>
<FONT SIZE="2" FACE="$FontFace">
<FONT SIZE="1" color="$000080" face="$FontFace">posted $ThisDate $FormatTime $TimeZone &nbsp;&nbsp;&nbsp;
<A HREF="$CGIURL/ubbmisc.cgi?action=getbio&UserName=$UserNameCoded" target=_new><IMG SRC="$NonCGIURL/$profilegif" WIDTH=22 HEIGHT=11 BORDER=0 ALT="Click Here to See the Profile for $thisline[2]"></A>$EmailString &nbsp;&nbsp;
</FONT><HR>$ReplyText</FONT></td></tr>);

#rotate thru alt colors
if ($AlternateColor eq "$AltColumnColor1") {
	$AlternateColor = "$AltColumnColor2";
	}  else {
	$AlternateColor = "$AltColumnColor1";
	}
		}  # end if not stat line and not father line
}  # end reply loop
} # end Count > 0 loop

$ThisThread .= qq(</table></center><p><table border=0 width=95%><tr><td><CENTER><A HREF="$CGIURL/postings.cgi?action=newtopic&number=$number&forum=$ForumCoded"><IMG SRC="$NonCGIURL/$BBTopic" WIDTH=91 HEIGHT=21 BORDER=0 ALT="Post New Topic"></A>&nbsp;&nbsp;<A HREF="$CGIURL/postings.cgi?action=reply&forum=$ForumCoded&number=$number&topic=$ThreadFile&TopicSubject=$SubjectCoded"><IMG SRC="$NonCGIURL/$BBReply" WIDTH=91 HEIGHT=21 BORDER=0 ALT="Post Reply"></A></CENTER></TD>
<td align=right NOWRAP>
<FONT SIZE="2" FACE="$FontFace">
<FORM ACTION="$CGIURL/forumdisplay.cgi" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="topics">
<B>Hop to: </B><SELECT NAME="number">);

open (FORUMFILE, "$VariablesPath/forums.cgi");
	@theseforums = <FORUMFILE>;
close (FORUMFILE);

for $each2(@theseforums) {
	@ForumLine = split(/\|/, $each2);
	chomp($ForumLine[8]);
		if (($ForumLine[3] eq "On") && ($number == $ForumLine[8])) {
$ThisThread .= qq(<OPTION value="$ForumLine[8]" SELECTED>$ForumLine[1]);

		}
	if (($ForumLine[3] eq "On") && ($number != $ForumLine[8])) {
$ThisThread.= qq(<OPTION value="$ForumLine[8]">$ForumLine[1]);

		} #end if/else
}  #end for loop

$ThisThread .= qq(</SELECT><INPUT TYPE="SUBMIT" NAME="SUBMIT" VALUE="Go"></FORM></FONT></TD></tr></TABLE>
<CENTER><br><B><FONT SIZE="2" FACE="$FontFace">
<A HREF="mailto:$BBEmail">Email Grant</A> | <A HREF="$HomePageURL">$MyHomePage</A>
</B></FONT>
<P>

<p><FONT COLOR="$TextColor" size="1" FACE="$FontFace">
<P>
Powered by: <A HREF="http://www.ultimatebb.com">Ultimate Bulletin Board</A>, Freeware Version 2000a<BR>Purchase our Licensed Version- which adds many more features! <BR>&copy; Infopop Corporation (formerly <A HREF="http://www.madronapark.com">Madrona Park, Inc.</A>), 1998 - 2000.<br><br>
</FONT></CENTER></body></html>);

if (-e "$ForumsPath/$ForumIs/HTML/$ThreadNumber.html") {
chmod (0777, "$ForumsPath/$ForumIs/HTML/$ThreadNumber.html");
}

&Lock("lock.file");
open (THREADHTML, ">$ForumsPath/$ForumIs/HTML/$ThreadNumber.html");
print THREADHTML ("$ThisThread");
close (THREADHTML);
&Unlock("lock.file");

chmod (0777, "$ForumsPath/$ForumIs/HTML/$ThreadNumber.html");
}  #end CreateThreadHTML

sub GetTotalForums {
open (FORUMFILE, "$VariablesPath/forums.cgi");
	@forums = <FORUMFILE>;
close (FORUMFILE);

$ForumTotal = @forums;
return($ForumTotal);
}

sub GotError {
$ErrorLine = shift;
print<<THAT;
<HTML><BODY>
<BR>
<blockquote>
$ErrorLine
</blockquote>
</BODY></HTML>
THAT
}

sub ConfirmHTML2 {

$UserNameCoded = "$UserName";
$UserNameCoded =~ tr/ /+/;
$PasswordCoded = "$Password";
$PasswordCoded =~ tr/ /+/;

print<<Confirm2;
<HTML>
<HEAD>

</HEAD>
<BODY BGCOLOR="$BGColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<br><br><FONT Size="2" FACE="$FontFace"><B>
Thank you.  $ConfirmLine
</B></FONT>
</BODY></HTML>
Confirm2
}

sub ConfirmHTML {

$UserNameCoded = "$UserNameCheck";
$UserNameCoded =~ tr/ /+/;
$PasswordCoded = "$PasswordCheck";
$PasswordCoded =~ tr/ /+/;

print<<Confirm;
<HTML>
<HEAD>
</HEAD>
<BODY BGCOLOR="$BGColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<br><br><FONT Size="2" FACE="$FontFace"><B>
Thank you.  $ConfirmLine
<P>
</B></FONT>
</BODY></HTML>
Confirm
}


sub SetLastTimes {

open (FORUMFILE, "$VariablesPath/forums.cgi");
	@sortforums = <FORUMFILE>;
close (FORUMFILE);

&CurrentDate;

for $each(@sortforums) {
@thisforuminfo = split(/\|/, $each);
chomp($thisforuminfo[8]);
$x = "$thisforuminfo[8]";

#update or create forum summary files
if ($x > 0) {
&ForumSummary($x);

# @finalarray = threads file

$numberthreads = @finalarray;
if ($numberthreads > 0) {

@currthreads = sort(@finalarray);
$latest = $currthreads[0];
@latest = split(/\|\^\|/, $latest);
$lastdatetime = $latest[2];

$LastYear = substr($lastdatetime, 0, 4);
$LastMon = substr($lastdatetime, 4, 2);
$LastDay = substr($lastdatetime, 6, 2);
$hour = substr($lastdatetime, 8, 2);
$min = substr($lastdatetime, 10, 2);
&NormalTime;
$LatestTime = ("$hour" . ":" . "$min" . " $AMPM");
$HyphenDate = "$LastMon-$LastDay-$LastYear";

#update last time file
&Lock("lock.file");
open (LASTTIME, ">$ForumsPath/Forum$x/lasttime.file") or die(&StandardHTML("Unable to write a Forum$x LastTime.file $!"));
print LASTTIME ("$HyphenDate\n");
print LASTTIME ("$LatestTime\n");
close (LASTTIME);
&Unlock("lock.file");

chmod (0666, "$ForumsPath/Forum$x/lasttime.file");
}
} #end if > 0
} #end foreach forum
} #end setlasttimes




1;
