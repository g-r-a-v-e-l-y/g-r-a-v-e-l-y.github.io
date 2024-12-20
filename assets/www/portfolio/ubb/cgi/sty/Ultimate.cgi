#!/usr/bin/perl

#
###                  PRIMARY FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998-1999.
#
#       ------------ Ultimate.cgi -------------
#
#  This file contains intro functionality for the Freeware UBB.
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
require "Styles.file";
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
	}
		if ($Name eq "DaysPrune") {
			$DaysPrune = $Value;
	}
	if ($Name eq "topic") {
			$topic = $Value;
	}

	if ($Name eq "Email") {
			$Email = $Value;
			$Email =~tr/A-Z/a-z/; 
	}
	if ($Name eq "URL") {
			$URL = &CleanThis($Value);
			$URL = &PipeCleaner($URL);
	}
	if ($Name eq "Permissions") {
			$Permissions = $Value;
	}
	if ($Name eq "Occupation") {
			$Occupation = &CleanThis($Value);
			$Occupation = &PipeCleaner($Occupation);
	}
	if ($Name eq "Location") {
			$Location = &CleanThis($Value);
			$Location = &PipeCleaner($Location);
	}
	if ($Name eq "TotalPosts") {
		$TotalPosts = $Value;
	}
	if ($Name eq "Status") {
		$Status = $Value;
	}
	if ($Name eq "Interests") {
			$Interests = &CleanThis($Value);
			$Interests = &PipeCleaner($Value);
	}
		if ($Name eq "sendto") {
			$sendto = $Value;
	}
}  # end FOREACH $row

if ($VariablesPath eq "") {
	$VariablesPath = $CGIPath;
}


		$SubjectCoded = &HTMLIFY($TopicSubject);
		$SubjectCoded =~ tr/ /+/;

if (@in == 0) {
&Intro;
}
 
if ($in{'action'} eq "intro") {
 &Intro;
 }  


if ($in{'action'} eq "noncoppareg") {
	   &Agree;
}

if ($in{'action'} eq "agree") {

	if ($COPPACheck eq "ON"){
	   &COPPACheck;
	}
	else {
	   &Agree;	
	}
 } 

 if ($in{'action'} eq "email") {
 &DoEmail($in{'ToWhom'});
 }  

  
if ($in{'action'} eq "register") {
 	&Register;
 }  
 
if ($in{'action'} eq "showcoppaform") {
 &PrintCOPPARegistrationHTML;
} 
 
if ($in{'action'} eq "rules") {
 &Rules;
 }  
 
if ($in{'action'} eq "lostpw") {
	if ($UseEmail eq "ON") {
 &LostPW;
 }  else {
 &StandardHTML("Sorry, but this feature is not available, per your administrator's directions.  Use your back button to return to the BB.");
 }
 }  
 

 ## INTRO PAGE SUBROUTINES ####
 
sub Intro {

	&GetDateTime;

&ForumsTopHTML;


open (FORUMFILE, "$VariablesPath/forums.cgi");
	@forums = <FORUMFILE>;
close (FORUMFILE);
@forums = grep(/\|/, @forums);

@sortforums = @forums;

for (@sortforums) {
@thisforuminfo = split(/\|/, $_);
chomp($thisforuminfo[8]);
$x = "$thisforuminfo[8]";

$GetHour = "";
$GetMinute = "";
$MilHour = "";
$TheDate = "";
$LatestTime = "";

## Get Forum Data from lastnumber.file(s)
open (FORUMDATA, "$ForumsPath/Forum$x/lastnumber.file"); 
 my @data = <FORUMDATA>;
close (FORUMDATA);
$TotalTopics = $data[1];
chomp($TotalTopics);
$TotalPosts = $data[2];
chomp($TotalPosts);

if ($TotalTopics eq "") {
	$TotalTopics = "0";
	}
	
if ($TotalPosts eq "") {
	$TotalPosts = "0";
	}

if ($TotalTopics > 0) {
#open lasttime.file for forum
open (LTime, "$ForumsPath/Forum$x/lasttime.file"); 
    @lasttime = <LTime>;
close (LTime);

$LastDate = $lasttime[0];
$LastTime = $lasttime[1];
chomp($LastDate);
chomp($LastTime);
#split time/date
($GetHour, $GetMinute) = split(/:/, $LastTime);
($GetMinute, $AMpm) = split(/ /, $GetMinute);
chomp($AMpm);
($GetMonth, $GetDate, $GetYear) = split(/-/, $LastDate);
$CheckThisYear = length($GetYear);
	if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$GetYear = ("19" . "$GetYear");
		}  else {
		$GetYear = $GetYear - 100;
		$GetYear = sprintf ("%2d", $GetYear);
		$GetYear =~tr/ /0/;
		$GetYear = ("20" . "$GetYear");
		}
	}

	
	&MilitaryTime2;
	$MilTime = "$MilHour:$GetMinute";

if ($TimeFormat eq "24HR") {
	$LatestTime = "$MilTime";
} else {
		$LatestTime = "$LastTime";
	}
	
if ($DateFormat eq "Euro") {
$TheDate = "$GetDate-$GetMonth-$GetYear";
$DateWording = "All dates are in DD-MM-YY format.";
}  else {
$TheDate = "$GetMonth-$GetDate-$GetYear";
$DateWording = "All dates are in MM-DD-YY format.";
}
}  else {
$GetMonth = "";
$GetDate= "";
$GetYear = "";
$LatestTime = "";
$TheDate = "";
}

@thisforum = &GetForumRecord($x);

$ForumName = $thisforum[1];
$Moderator = ("Forum" . "$x" . "Moderator");
$Moderator = $$Moderator;
$ForumDesc = $thisforum[2];
$OnOff = $thisforum[3];
chomp($OnOff);

$ForumCoded = &HTMLIFY($ForumName);
$ForumCoded =~ tr/ /+/;
$ForumDesc =~ s/&quot;/"/g;

if ($ForumDescriptions eq "no") {
	$ForumDesc = "";
}

if ($GetMonth ne "") {

# Compare Last Login Time to Last Post Time.. 

$LPMonth = $GetMonth;
		
$CheckThisYear = length($GetYear);

	if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$JYear = ("19" . "$GetYear");
		}  else {
		$GetYear = $GetYear - 100;
		$GetYear = sprintf ("%2d", $GetYear);
		$GetYear =~tr/ /0/;
		$JYear = ("20" . "$GetYear");
		}
	} else  {
		$JYear = "$GetYear";
	}
	
} # end if/else month ne ""


if ($OnOff eq "On") {
&ForumsGutsHTML;
} ## End IF ONOFF Conditional
}

&ForumsBottomHTML;
}  #END INTRO SR ###


sub ForumsTopHTML {
print <<INTROHTML;
<HTML>
<HEAD><TITLE>$BBName - powered by Infopop Ultimate Bulletin Board</title>
<link REL="SHORTCUT ICON" href="$NonCGIURL/ubbfavicon.ico">
</head>
 <BODY bgcolor="$BGColor"  text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<FONT FACE="$FontFace" SIZE="2">
<center>
<table border=0 width=95%>
<tr>
<TD align=left>

<A HREF="Ultimate.cgi"><IMG SRC="$NonCGIURL/$BBTitle"  BORDER=0></A>

</td>
<td>
<CENTER>
<B><FONT SIZE="3" FACE="$FontFace" COLOR="$LinkColor">$BBName</FONT></B>
<br><FONT SIZE="1" FACE="$FontFace">
<A HREF="$CGIURL/ubbmisc.cgi?action=editbio&Browser=$Browser&DaysPrune=$DaysPrune"><ACRONYM TITLE="Click here to edit your profile.">profile</ACRONYM></A> | <A HREF="$CGIURL/Ultimate.cgi?action=agree"><ACRONYM TITLE="Registration is free!">register</ACRONYM></A> | <A HREF="$NonCGIURL/faq.html" target=_blank><ACRONYM TITLE="Frequently Asked Questions">faq</ACRONYM></A>
</FONT>
</CENTER>
</td></TR>
</table>
<table border=0 width=95%>
<TR>
<tr BGCOLOR="$TableColorStrip">
<td valign=bottom>
<FONT SIZE="1" FACE="$FontFace" COLOR="$TableStripTextColor">Forum</FONT>
</td>
<td NOWRAP valign=bottom align=center>
<FONT SIZE="1" FACE="$FontFace" COLOR="$TableStripTextColor">Posts</FONT>
</td>
<td NOWRAP valign=bottom align=center>
<FONT SIZE="1" FACE="$FontFace" COLOR="$TableStripTextColor">Last Post</FONT>
</td>
<td valign=bottom>
<FONT SIZE="1" FACE="$FontFace" COLOR="$TableStripTextColor">Moderator</FONT>
</td></tr>
INTROHTML
}  ## END FORUMS TOP HTML

sub ForumsGutsHTML {
print <<ForumSummary;
<TR>
<TD BGCOLOR="$AltColumnColor1" valign=top><FONT SIZE='2' FACE='$FontFace'><B>
<A HREF="$CGIURL/forumdisplay.cgi?action=topics&forum=$ForumCoded&number=$x&DaysPrune=$DaysPrune&LastLogin=$LastLogin">$ForumName</A></B><BR>
$ForumDesc
</FONT>
</td>
<td BGCOLOR="$AltColumnColor2" align=center valign=top NOWRAP>
<FONT SIZE='2' FACE="$FontFace">$TotalPosts</FONT>
</td><td BGCOLOR="$AltColumnColor1" NOWRAP valign=top align=center>
<FONT SIZE='2' FACE="$FontFace">$TheDate <FONT COLOR="$LinkColor" SIZE="2" FACE="$FontFace">$LatestTime</FONT>
</td><td BGCOLOR="$AltColumnColor2" valign=top>
<FONT SIZE='2' FACE="$FontFace">$Moderator</FONT></td></tr>
ForumSummary
}  ## END FORUMS GUTS HTML

sub ForumsBottomHTML {
print <<BOTTOMhtml;
</table>
</center>
<P>
<FONT SIZE="1" FACE="$FontFace" COLOR="#8C9A7A">All times are $TimeZone.  $DateWording</FONT>
<P>
<P><center></font>
BOTTOMhtml

&PageBottomHTML;
}  ## END Forums Bottom HTML subroutine


### END Intro Page Subroutines ####
 


sub Agree {
print <<Agreement;
<HTML>
 <BODY bgcolor="$BGColor" text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<FONT SIZE="2" FACE="$FontFace">
<table border=0><TR><TD>
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle"  BORDER=0></A></TD><TD align=center><FONT SIZE="+1" FACE="$FontFace" COLOR="$LinkColor"><B>$BBName Rules</B></FONT></td></tr></table> 
<br><BR>
<FONT SIZE="2" FACE="$FontFace">
Registration for this bulletin board is completely free!  If you agree to our rules below, you should press the "Agree" button, which will enable you to register.  If you do not agree, press the "Cancel" button.
<HR width=95%>
<CENTER><B><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$BBName Rules & Policies</B></CENTER>
<P>
<Blockquote>
$BBRules</FONT>
</blockquote>
<HR width=90%><CENTER>
<FORM ACTION="Ultimate.cgi" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="register">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Agree">
</FORM>
<FORM ACTION="Ultimate.cgi" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="intro">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Cancel">
</FORM>
</CENTER>
</FONT>
<p></font>
</BODY></HTML>
Agreement
}

sub Register {

print<<RegHTML;
<HTML>
<HEAD>
	<TITLE>$BBName Registration</TITLE>
</HEAD>
 <BODY bgcolor="$BGColor"  text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<FONT SIZE="3" FACE="$FontFace">
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle" BORDER=0></A>
<FONT SIZE="3" FACE="$FontFace" COLOR="$LinkColor"><B>
Bulletin Board Registration
</B></FONT>
<P>
<table border=0>
<tr>
<td colspan=2>
<FONT SIZE="2" FACE="$FontFace">
<B>In order to post messages on this Bulletin Board, you must first register.  
<BR><BR>
UserNames can be up to 25 characters and passwords can be a maximum of 13 characters.  Please use only letters and numbers.  Passwords are case-sensitive.  This means that "Howard" is distinct from "HOWARD."
<BR><BR>
Note: all of the information provided on this page (with the exception of your password) will be viewable by anyone visiting the bulletin board.  Thus, if you don't feel comfortable about completing certain fields, just leave them blank.  In addition, your passwords are not encrypted and can be seen by the BB administrators.  Do not use a password that you would be afraid to reveal to anyone.  Required fields are marked by an asterisk.
<br><br></B></FONT>
</td></tr>
<tr>
<FORM NAME="Register" METHOD=POST ACTION="ubbmisc.cgi">

<TD BGCOLOR="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>User Name*</B></FONT></TD>
<TD><INPUT TYPE="TEXT" NAME="UserName" VALUE="" SIZE=25 MAXLENGTH=25>
 </TD>
</TR>
<TR><TD BGCOLOR="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace"><B>Password*</B></FONT></TD><TD><INPUT TYPE="PASSWORD" NAME="Password" VALUE="" SIZE=13 MAXLENGTH=13> </TD></TR><TR><TD><FONT SIZE="2" FACE="$FontFace"><B>Enter Password Again*</B></FONT></TD><TD><INPUT TYPE="PASSWORD" NAME="PasswordConfirm" VALUE="" SIZE=13 MAXLENGTH=13></TD></tr>

<TR>
	<TD BGCOLOR="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Email*</B></FONT></TD>
	<TD><INPUT TYPE="TEXT" NAME="Email" VALUE="" SIZE=30 MAXLENGTH=50>
 </TD>
</TR>
<TR>
	<TD BGCOLOR="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace"><B>City, State, Country</B></FONT></TD>
	<TD><INPUT TYPE="TEXT" NAME="Location" VALUE="" SIZE=30 MAXLENGTH=50>
 </TD></tr>

<TR>
	<TD BGCOLOR="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Occupation</B></FONT></TD>
	<TD><INPUT TYPE="TEXT" NAME="Occupation" VALUE="" SIZE=30 MAXLENGTH=50>
 </TD>
</TR>

<TR>
	<TD BGCOLOR="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace"><B>Homepage</B></FONT></TD>
	<TD><INPUT TYPE="TEXT" NAME="URL" VALUE="http://" SIZE=30 MAXLENGTH=100>
 </TD></tr>
<TR>
	<TD BGCOLOR="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Interests</B></FONT></TD>
	<TD><INPUT TYPE="TEXT" NAME="Interests" VALUE="" SIZE=30 MAXLENGTH=200>
 </TD></tr>
</TABLE>
<P>

<BR><BR>
<CENTER>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="RegSubmit">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit">
<INPUT TYPE="RESET" NAME="Reset" VALUE="Reset">
</FORM>
<BR><BR>
</center><BR></font></BODY>
</HTML>
RegHTML
}  ## END Register SR ##

sub PrintCOPPARegistrationHTML {
	
print <<"COPPA"
<html>
<head>
<title>Permission to Participate at $BBName</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<BODY bgcolor=$BGColor text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<body bgcolor="$BGColor" >
<table width="$TableWidth" border="0" cellspacing="1" cellpadding="3" align=center>
  <tr > 
    <td > 
      <A HREF="$CGIURL/Ultimate.cgi?action=intro&bypasscookie=true"><IMG SRC=$NonCGIURL/$BBTitle border=0></a>
      <td align=center><h4> <font face="$FontFace">Permission to Participate 
        at $BBName</font></h4>
    </td>
  </tr>
  
    <tr bgcolor=$CategoryStripColor> 
    <td colspan="2"> 
      <p><font face="$FontFace" size="2" color="$CategoryStripTextColor"><h5>Instructions for a Parent or Guardian</h></font></p>
    </td>
  </tr>
 
  
  <tr bgcolor=$AltColumnColor1> 
    <td colspan="2"> 
      <p><font face="$FontFace" size="2">$COPPAInstructions</font></p>
    </td>
  </tr>
  <tr bgcolor=$CategoryStripColor> 
    <td colspan="2"> 
      <p><font size="2" face="$FontFace" color="$CategoryStripTextColor"><b>Here is the <u>required</u> information supplied with this registration request:</b></font></p>
    </td>
  </tr>
  
 <tr bgcolor=$AltColumnColor2>
<TD width=22%><FONT SIZE="$TextSize" FACE="$FontFace"><B>User Name</B></FONT></TD>
<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$UserName</font>
 </TD>
</tr>

<tr bgcolor=$AltColumnColor1>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace"><B>Password</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$RegWording2</font>
 </TD>
</tr>
<tr bgcolor=$AltColumnColor2>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace"><B>Email</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$Email</font>
 </TD>
</TR>
<tr bgcolor=$CategoryStripColor>
	<TD colspan="2"><FONT SIZE="$TextSize" FACE="$FontFace" color="$CategoryStripTextColor"><B><p>Information supplied below is <u>optional</u>. Please review it carefully.</p></B></FONT></TD>
</TR>
<tr bgcolor=$AltColumnColor2>
	<TD colspan="2"><p><FONT SIZE="$TextSize" FACE="$FontFace">Please add any other information you approve to the profile information below.</p></TD>
</TR>
<tr bgcolor=$AltColumnColor1>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace"><B>City, State, Country</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$Location</font>
 </TD>
</TR>
<tr bgcolor=$AltColumnColor2>
	<td><FONT SIZE="$TextSize" FACE="$FontFace"><B>Occupation</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$Occupation</font>
 </TD>
</tr>
<tr bgcolor=$AltColumnColor1>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace"><B>Interests</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$Interests</font>
 </TD>
</tr>
<tr bgcolor=$AltColumnColor2>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace"><B>Homepage</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$URL</font>
 </TD>
</tr>

<tr bgcolor=$AltColumnColor1>
	<TD  valign=top><FONT SIZE="$TextSize" FACE="$FontFace"><B>Keep your email address viewable to other users when you post notes?</B></FONT></TD>
	<TD ><FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$LinkColor">$in{'EmailView'}</font>
 </TD>
</tr>

<tr bgcolor=$AltColumnColor1>
	<TD valign=top>&nbsp;</TD>
	<TD >&nbsp;</font>
 </TD>
</tr>

   <tr bgcolor=$CategoryStripColor> 
    <td colspan="2"> 
      <p><font face="$FontFace" size="2" color="$CategoryStripTextColor"><b>Please sign the form below and send it to us.</b> [see instructions above]</font></font></p>
    </td>
  </tr>
  <tr bgcolor=$AltColumnColor1>
    <td colspan="2"><p><font face="$FontFace" size="2"><b>YES:</b>
 I have reviewed the information my child has supplied and I have read the <a href="$PrivacyURL">Privacy 
        Policy</a> for the web site. I understand that the profile information 
        may be changed by $UserName using a password. I understand that I may 
        ask for this registration profile be removed entirely.</font></p>   
    </td>
  </tr>
  <tr bgcolor=$AltColumnColor2> 
    <td> 
      <p><font face="$FontFace" size="2">Parent/Guardian 
        Full Name</font></p>
    </td>
    <td> 
<br><hr>
    </td>
  </tr>
    <tr bgcolor=$AltColumnColor2> 
    <td> 
      <p><font size="2" face="$FontFace">Signature 
        </font></p>
    </td>
    <td> 
      <br><hr> </td>
  </tr>
  <tr bgcolor=$AltColumnColor1> 
    <td> 
      <p><font size="2" face="$FontFace">Relation 
        to Child</font></p>
    </td>
    <td> 
      <p><font size="2"><br><hr>
    </td>
  </tr>
  <tr bgcolor=$AltColumnColor2> 
    <td> 
      <p><font size="2" face="$FontFace">Telephone</font></p>
    </td>
    <td> 
      <br><hr>  </td>
  </tr>
  <tr bgcolor=$AltColumnColor1> 
    <td> 
      <p><font size="2" face="$FontFace">Email Address</font></p>
    </td>
    <td> 
      <br><hr>    </td>
  </tr>
  <tr bgcolor=$AltColumnColor1> 
    <td><font size="2" face="$FontFace">Date </font>
         </td>
    <td> 
     <br><hr>   </td>
  </tr>
  <tr bgcolor=$AltColumnColor2> 
    <td><font size="2" face="$FontFace">Online Request Date</font></td>
    <td> 
     <font size="2" face="$FontFace">$HyphenDate <font size=-1>[available for online registration only]</font></font></td>
  </tr>
  <tr bgcolor=$CategoryStripColor> 
    <td colspan="2"> 
      <p><font size="2" face="$FontFace" color="$CategoryStripTextColor">Please contact 
        $BBEmail with any questions</font></p>
    </td>
  </tr>
</table>

<center><p><B><FONT SIZE="$TextSize" FACE="$FontFace">
<A HREF="mailto:$BBEmail">Email Grant</A> | <A HREF="$HomePageURL" target=_top>$MyHomePage</A> | <A HREF="$PrivacyURL">Privacy Statement</A>
</B></FONT>
<P>
<FONT COLOR="$CopyrightTextColor" size="1" FACE="$FontFace">$YourCopyrightNotice
<P>
$infopopcopy<br>
Ultimate Bulletin Board Freeware 2000c
<br><br>
</FONT>
</CENTER></font>
</p>
</body>
</html>
	
COPPA
} # end SR

sub COPPACheck { # age check
	&GetDateTime;	
	@months = ("blank" , "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December");
	$COPPADate = "$mday $months[$JSMonth] " . ($JSYear-13);

print <<COPPACheck;
<HTML>
<HEAD>$HeaderInsert</HEAD>
 <BODY bgcolor=$BGColor text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor" marginheight=0 marginwidth=0 topmargin=0 leftmargin=0 rightmargin=0>
<FONT SIZE="$TextSize" FACE="$FontFace" COLOR="$TextColor">
$Header
<P><center>
<TABLE BORDER=0 width=95%>
<TR><TD>
<A HREF="$CGIURL/Ultimate.cgi?action=intro&BypassCookie=true"><IMG SRC="$NonCGIURL/$BBTitle"  BORDER=0></A></TD><TD align=center><FONT SIZE="+1" FACE="$FontFace" COLOR="$BBTitleFontColor"><B>$BBName</B></FONT></td></tr></table> 
<P>
<table border=0 cellpadding=4 border=0 cellspacing=1 width=95%>
  <tr BGCOLOR=$TableColorStrip> 
    <td><b><FONT SIZE="$TextSize" FACE="$FontFace" color="$TableStripTextColor">Registration 
      - Age Verification</font></b></td>
  </tr>
  <tr> 
    <td BGCOLOR=$AltColumnColor1><FONT SIZE="$TextSize" FACE="$FontFace">
      <p>Please click the link that describes your age: </p>
      <p><b>Born <A HREF=$CGIURL/Ultimate.cgi?action=noncoppareg>On or Before $COPPADate</a></b></p>
      <p><b>Born <A HREF=$CGIURL/Ultimate.cgi?action=showcoppaform>After $COPPADate</a></b><br> &nbsp;</p>
    </td>
  </tr>
  <tr BGCOLOR=$CategoryStripColor> 
    <td><b><FONT SIZE="$TextSize" FACE="$FontFace"color="$CategoryStripTextColor">Privacy Information</font></b></td>
  </tr>
  <tr> 
    <td BGCOLOR=$AltColumnColor1><FONT SIZE="$TextSize" FACE="$FontFace">
    <p>The Federal Trade Commission's Children's Online Privacy Protection Act 
        of 1998 (COPPA) is intended to protect the privacy of children using the 
        Internet. As of April 21, 2000, many Web sites are required to obtain parental consent 
        before collecting, using, or disclosing personal information from children 
        under 13.</p>
    
      <p>See <A HREF=http://www.ftc.gov/opa/1999/9910/childfinal.htm>COPPA News Release</a> and 
Full Text of Federal Register Notice <A HREF=http://www.ftc.gov/os/1999/9910/64fr59888.pdf>[PDF 270K]</A></p>
<p>Please read <A HREF=$PrivacyURL>$BBName Privacy Statement</a></font>
    </td>
  </tr>
  <tr BGCOLOR=$CategoryStripColor> 
    <td><b><FONT SIZE="$TextSize" FACE="$FontFace"color="$CategoryStripTextColor">Permission Form</font></b></td>
  </tr>
  <tr> 
    <td BGCOLOR=$AltColumnColor1> <FONT SIZE="$TextSize" FACE="$FontFace">
      <p>A parent or guardian must mail or fax a signed <A HREF="Ultimate.cgi?action=showcoppaform">permission form</a> to the administrator of $BBName 
        before a user under age 13 can complete the registration.</p></font>
      </td>
  </tr>
  <tr BGCOLOR=$CategoryStripColor> 
    <td><b><FONT SIZE="$TextSize" FACE="$FontFace" color="$CategoryStripTextColor">Contact Information</font></b></td>
  </tr>
  <tr BGCOLOR=$AltColumnColor1> 
    <td><FONT SIZE="$TextSize" FACE="$FontFace">For further information contact <A HREF="mailto:$BBEmail">$BBEmail</a>.</font></td>
  </tr>
  <tr BGCOLOR=$AltColumnColor1> 
    <td>&nbsp;</td>
  </tr>
</table>

<P>
<center><p><B><FONT SIZE="$TextSize" FACE="$FontFace">
<A HREF="mailto:$BBEmail">Email Grant</A> | <A HREF="$HomePageURL" target=_top>$MyHomePage</A> | <A HREF="$PrivacyURL">Privacy Statement</A>
</B></FONT>
<P>
<FONT COLOR="$CopyrightTextColor" size="1" FACE="$FontFace">$YourCopyrightNotice
<P>
<BR><BR>Powered by <A HREF="http://infopop.com"><FONT COLOR="$CopyrightTextColor">Infopop</font></A> Ultimate Bulletin Board Freeware 2000c
<br><br>
</FONT>
</CENTER></font>
</p>
$Footer</FONT></BODY></HTML>
COPPACheck

}
