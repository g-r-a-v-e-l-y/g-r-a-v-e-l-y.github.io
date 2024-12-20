#!/usr/bin/perl
#

#
###                  FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998 - 2000.
#
#       ------------ cpanel.cgi -------------
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
#If you are running UBB on IIS,
#you may need to add the following line
#if so, just remove the "#" sign before the print line below
#print "HTTP/1.0 200 OK\n";

print ("Content-type: text/html\n\n");
eval {
  ($0 =~ m,(.*)/[^/]+,)   && unshift (@INC, "$1"); # Get the script location: UNIX / or Windows /
  ($0 =~ m,(.*)\\[^\\]+,) && unshift (@INC, "$1"); # Get the script location: Windows \
 
#substitute all require files here for the file

require "UltBB.setup";
require "mods.file";
require "ubb_library.pl";
require "ubb_library2.pl";

};

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

	if ($Name eq "action") {
			$action = $Value;
	}
	if ($Name eq "ViewEntire") {
			$ViewEntire = $Value;
			}
	
	if ($Name eq "NN") {
			$NN = $Value;
			$NN =~tr/A-Z/a-z/;   
			}
	if ($Name eq "Email") {
			$Email = $Value;
			$Email =~tr/A-Z/a-z/;  
		}
	if ($Name eq "UserName") {
			$UserName = $Value;
		}
	if ($Name eq "Password") {
			$Password = $Value;
		}
} #end foreach loop

if ($VariablesPath eq "") {
			$VariablesPath = $CGIPath;
		}
if ($action eq "setmods") {
   &SetMods;
}
if ($action eq "UpdateThreads") {
   &UpdateThreads;
}
if ($action eq "styles") {
   &StandardHTML("Sorry, but this feature is not available in the freeware version.  The freeware version is a function-limited version of the licensed version of the UBB.  Other features not included in the freeware version, but found in the licensed version, include:<ul><LI>Full text search<LI>Email features<LI>Lost password auto email for members<LI>Censor words option<LI>Edit/prune of messages<LI>Announcements<LI>Private Forums<LI>Unlimited Forums<LI>Archives<LI>Session tracking using cookies, so that users can visibly see new threads by color-coded icons<LI>Ability to close threads<LI>Smilies- automatic conversion of typed smilies :) to colorful graphics<LI>Many more graphic sets<LI>Ability of users to edit there own messages<LI>Many other customizations, including custom headers and footers.</ul><br>For more information on the licensed version, including current pricing, please visit: <A HREF=\"http://www.ultimatebb.com\">www.ultimatebb.com</A>");
}
if ($action eq "prune") {
   &StandardHTML("Sorry, but this feature is not available in the freeware version.  The freeware version is a function-limited version of the licensed version of the UBB.  Other features not included in the freeware version, but found in the licensed version, include:<ul><LI>Full text search<LI>Email features<LI>Lost password auto email for members<LI>Censor words option<LI>Style customizations (change fonts, colors, graphics through the control panel)<LI>Announcements<LI>Session tracking using cookies, so that users can visibly see new threads by color-coded icons<LI>Ability to close threads<LI>Smilies- automatic conversion of typed smilies :) to colorful graphics<LI>Many more graphic sets<LI>Ability of users to edit there own messages<LI>Many other customizations, including custom headers and footers.</ul><br>For more information on the licensed version, including current pricing, please visit: <A HREF=\"http://www.ultimatebb.com\">www.ultimatebb.com</A>");
}
if ($action eq "variables") {
   &Variables;
}

if ($action eq "permissions") {
   &Permissions;
}

if ($action eq "env") {
   &Env;
}

if ($action eq "logintoforums") {
   &LogIntoForums;
}

if ($action eq "getbio4admin") {
   &GetBio4Admin;
}


sub UpdateThreads {
$PageTitle = "Update Threads";
&HEADERHTML;

print<<Threads;
<FONT SIZE="2" FACE="Verdana, Arial" COLOR="#FF0000">Note: only administrators may update HTML threads. <P>
After you make changes to your control panel settings, these changes take affect immediately for all new pages.  Older HTML pages, however, are not updated until you update them here.  You should run this function after you have made all changes to your control panel settings.
</FONT>
<FORM ACTION="cpanel2.cgi" METHOD="POST" NAME="THEFORM">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="doupdate">
<table border=0>
<TR>
<TD>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Your User Name</B></FONT>
</td>
<td><INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td>
<TR>
<td>
<B><FONT SIZE="2" FACE="Verdana, Arial">Your Password</FONT></B>
</td>
<td>
<INPUT TYPE="PASSWORD" NAME="Password" SIZE=13 MAXLENGTH=13>
</td>
</table>
<p>
<center>
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Update Threads Now!">
</CENTER>

</FORM>
</BODY></HTML>
Threads

}  ## END UpdateThreads SR ##



sub LogIntoForums {
$PageTitle = "Set Forum Variables";
&HEADERHTML;

print<<ForumLoginHTML;
To set forum variables, you must be an administrator.  Please identify yourself below.
<P><center>
<FORM ACTION="cpanel3.cgi" METHOD="POST" NAME="THEFORM">
<table border=1>
<TR>
<TD>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Your User Name</B></FONT>
</td>
<td><INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td>
<TR>
<td>
<B><FONT SIZE="2" FACE="Verdana, Arial">Your Password</FONT></B>
</td>
<td>
<INPUT TYPE="PASSWORD" NAME="Password" SIZE=13 MAXLENGTH=13>
</td>
</table>
<P>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="forums">
<INPUT TYPE="HIDDEN" NAME="StartPoint" VALUE="0">
<CENTER><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Identification Now">
</center>
</FORM>
<BR><BR><BR>
<FONT SIZE="1" FACE="Verdana, Arial" COLOR="#000000">Powered by the <A HREF="http://www.ultimatebb.com">Ultimate Bulletin Board</A><BR>Copyright, Infopop Corporation, 1998 - 2000.
</FONT>
</CENTER>
</BODY>
</HTML>
ForumLoginHTML

}  # end logintoforums sr


sub Env {
print<<TOP;
<HTML><BODY BGCOLOR="#FFFFFF">
<BR><BR>
<CENTER><FONT SIZE="5" FACE="Courier New" ><B>Your Environmental Variables</b></FONT></CENTER>
<P>
<font face="Verdana, Arial" size="2">
Use these to help you figure out your absolute file paths, and other system information.<P>
<FONT face="Verdana, Arial" size="2" COLOR="#800000"><B>Perl Info:</b></FONT><BR>
You are using <b>Perl Version $]</b>
<P>
<FONT face-"Verdana, Arial" size="2" COLOR="#800000"><B>Your Environmental Variables:</b></FONT>
<BR>
<FONT SIZE="1" FACE="Verdana, Arial" COLOR="#008080">Note: "DOCUMENT_ROOT" shows your absolute path to your root web directory.  "SCRIPT_FILENAME" shows you absolute path of your CGI directory.  If your SCRIPT_FILENAME shows "/www/whatever/whatever/cgi-bin/cpanel.cgi", your Absolute Path variable for your CGI directory would be "/www/whatever/whatever/cgi-bin".</FONT><P>
TOP
for $key (keys(%ENV)) {
printf("%-10.20s: <b>$ENV{$key}</B><BR>", $key);
}

print<<BOTTOM;
</FONT></BODY></HTML>
BOTTOM
}  # END ENV SR


sub Permissions {
$PageTitle = "Permissions Center";
&HEADERHTML;

print<<permissHTML;
If you are an authorized administrator, you can change the access permissions for any BB user.   Enter information for at least one of the fields below to conduct a search for a user.  Search is not case-sensitive.
<P>
<FORM ACTION="cpanel2.cgi" METHOD="POST" NAME="THEFORM">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="getmatches">
<BLOCKQUOTE>
<FONT SIZE="2" face="Verdana, Arial"><B>Identify Yourself Below (case sensitive)</B></FONT><BR>
<TABLE BORDER=0>
<tr bgcolor="#DEDFDF"><td><FONT SIZE="2" FACE="Verdana, Arial"><B>Your User Name</B></FONT></td>
<td><INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td>
</tr>
<tr bgcolor="#dedfdf">
<td>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Your Password</B></FONT></td>
<td><INPUT TYPE="PASSWORD" NAME="Password" SIZE=15 MAXLENGTH=15></td>
</tr>
</table>
<P>
<FONT SIZE="2" face="Verdana, Arial"><B>Conduct Member Search:</B></FONT>
<TABLE BORDER=1>
<TR bgcolor="#CCCC99">
<TD WIDTH=200 VALIGN=TOP><FONT SIZE="2" FACE="Verdana, Arial"><B>User Name</B></FONT></td>
<td><INPUT TYPE="TEXT" NAME="NN" VALUE="" SIZE=25 MAXLENGTH=25></td></tr>
<TR bgcolor="#CCCC99">
<TD WIDTH=200 VALIGN=TOP><FONT SIZE="2" FACE="Verdana, Arial"><B>Email Address</B></FONT></td>
<td><INPUT TYPE="TEXT" NAME="Email" VALUE="" SIZE=30 MAXLENGTH=70></td></tr>
<TR bgcolor="#CCCC99">
<TD WIDTH=200 VALIGN=TOP><FONT SIZE="2" FACE="Verdana, Arial"><B>Number of Posts</B></FONT></td>
<td><SELECT NAME="Math">
	<OPTION VALUE="GT"> \>=
	<OPTION VALUE="LT"> \<=
	<OPTION VALUE="EQ"> ==

</SELECT>
<INPUT TYPE="TEXT" NAME="Posts" VALUE="" SIZE=3 MAXLENGTH=5></td></tr>
</table>
<BR>
<table border=2>
<tr>
<td width=25 bgcolor="#CCCC99"><INPUT TYPE="CHECKBOX" NAME="ViewEntire" VALUE="Yes"></td>
<td bgcolor="#dedfdf">
<FONT SIZE="2" face="Verdana, Arial"><B>If you want to view the entire list of users rather than conduct a search, check this box (not recommended for large membership sites since it could take a long time to process).</B></FONT></td></tr></table>
</BLOCKQUOTE>
<br><br>
<CENTER><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Search Now">
<INPUT TYPE="RESET" NAME="Reset" VALUE="Erase Search Fields">
</CENTER></form>
<br><br>
<CENTER><B><A HREF="$NonCGIURL/controlpanel.html">Control Panel</A>  |  <A HREF="$CGIURL/Ultimate.cgi?action=intro">Bulletin Board</A></B>
<br><br><FONT SIZE="1" FACE="Verdana">Powered by: <A HREF="http://www.ultimatebb.com">Ultimate Bulletin Board</A>, 
&copy; Infopop Corporation, 1998-2000.
</FONT></CENTER>
</FONT>
</BODY>
</HTML>
permissHTML
} ## END Permissions ##

sub Variables {
$PageTitle = "Set Variables";
&HEADERHTML;



if ( (-e "$CGIPath/cpanel.cgi") && (-d "$MembersPath")  && (-d "$NonCGIPath/Forum3") ) {


print<<VARHTML;
As an authorized administrator, you may customize your bulletin board on the fly, without having to edit a variable file by hand.  There are many different kinds of variables, all customizable by you, but they fall into three primary groups: general variables, forum variables, and style variables.
<p>
Your Bulletin General Settings are configured. To revise existing variables, you must first identify yourself, so that we can verify your status as an administrator.

<P><center>
<FORM ACTION="cpanel2.cgi" METHOD="POST" NAME="THEFORM">
<table border=1>
<TR>
<TD>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Your User Name</B></FONT>
</td>
<td><INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td>
<TR>
<td>
<B><FONT SIZE="2" FACE="Verdana, Arial">Your Password</FONT></B>
</td>
<td>
<INPUT TYPE="PASSWORD" NAME="Password" SIZE=13 MAXLENGTH=13>
</td>
</table>
<P>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="sendvarID">
<CENTER><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Identification Now">
</center>
</FORM>
<BR><BR><BR>
<FONT SIZE="1" FACE="Verdana, Arial" COLOR="#000000">Copyright, Infopop Corporation, 1998 - 2000.
</FONT>
</CENTER>
</BODY>
</HTML>

VARHTML

}

else {
print<<VARHTML;

<p>&nbsp;</p>
<p align=center><FONT SIZE="2" FACE="Verdana, Arial"><b>Your absolute paths need to be configured before you use the bulletin board.</b></FONT>
<P>

<p align=center><FONT SIZE="2" FACE="Verdana, Arial"><B>Please <A HREF="cpanel2.cgi?action=DoGenVars">click here now.</a></b>
</p>
<BR><BR><BR>
<center><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#000000">Ultimate Bulletin Board $Version<br>Powered by Infopop &copy; 2000.
</FONT></CENTER></BODY></HTML>
VARHTML


}




}


sub SetMods {
$PageTitle = "Set Moderators";
&HEADERHTML;

print<<ModTOP;

<FONT SIZE="2" FACE="Verdana, Arial" COLOR="#FF0000">Note: only administrators may set moderators.  Identify yourself below.</FONT>
<FORM ACTION="cpanel2.cgi" METHOD="POST" NAME="THEFORM">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="mods">
<table border=0>
<TR>
<TD>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Your User Name</B></FONT>
</td>
<td><INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td>
<TR>
<td>
<B><FONT SIZE="2" FACE="Verdana, Arial">Your Password</FONT></B>
</td>
<td>
<INPUT TYPE="PASSWORD" NAME="Password" SIZE=13 MAXLENGTH=13>
</td>
</table>
<p>
<center>
<table border=0 width=95% cellpadding=5>
<TR bgcolor="#EFF5F3">
<TD>
<FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080"><B>Forum Name</B></FONT>
</td>
<td>
<FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080"><B>Current Moderator</B></FONT>
</td>
<td>
<FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080"><B>Change to:</B></FONT>
</td>
ModTOP

#get current moderator info
$ForumTotal = &GetTotalForums;

for ($x = 1; $x <= $ForumTotal; $x++) {

@thisforum = &GetForumRecord($x);

$ForumName = "$thisforum[1]";
$Moderator = ("Forum" . "$x" . "Moderator");
$Moderator = $$Moderator;

print<<MIDMOD;
<TR bgcolor="#F7F7F7">
<TD>
<FONT SIZE="2" FACE="Verdana, Arial"><B>$ForumName</B></FONT>
</td>
<td>
<FONT SIZE="2" FACE="Verdana, Arial">$Moderator</FONT>
</td>
<td>
<INPUT TYPE="HIDDEN" NAME="OldMod$x" VALUE="$Moderator">
<INPUT TYPE="TEXT" NAME="NewMod$x" VALUE="$Moderator" SIZE=25 MAXLENGTH=25>
</td>
MIDMOD

} ##END FOREACH $line


print<<TRUEBOTTOM;
</table>
<P>
<CENTER>

<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Changes">
</CENTER>

</FORM>
</BODY></HTML>
TRUEBOTTOM

}  ## END SET MODS SR ##



sub HEADERHTML {
print<<HEADER;
<HTML>
<HEAD>
	<TITLE>$BBName</TITLE>
</HEAD>
<BODY bgcolor="#FFFFFF" link="#000080" vlink="#808000">
<BR>
<center>
<FONT SIZE="5" FACE="Courier New"><B>$PageTitle</B></FONT>
</center>
<FONT SIZE="2" FACE="Verdana, Arial">
<p>
HEADER
} #end HEADERHTML sr

sub GetBio4Admin {

@thisprofile = &OpenProfile("$UserName.cgi");

$EmailField = "<A HREF=\"mailto:$thisprofile[2]\">$thisprofile[2]</A>";

&ViewBioCPHTML;
}  ## END GET BIO sr


sub ViewBioCPHTML {

print <<BioHTML;
<HTML>
 <BODY bgcolor="#FFFFFF"   text="#000000" link="#000080" vlink="#800080">
<FONT SIZE="2" FACE="Verdana, Arial"><B>Profile for $thisprofile[0]</B></FONT>
<HR>
<BLOCKQUOTE>
<table border=0>
<tr><td>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Date Registered:</B></FONT></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$DateRegistered</FONT>
</td></tr>
<tr><td>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Status:</B></FONT></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$thisprofile[8]</FONT>
</td></tr>
<tr><td>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Total Posts:</B></FONT></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$thisprofile[7]</FONT>
</td></tr>
<tr><td>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Current Email:</B></FONT></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$EmailField</FONT>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="Verdana, Arial"><B>Homepage:</B></font></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080"><A HREF="$thisprofile[3]" target=_top>$thisprofile[3]</A></font>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="Verdana, Arial"><B>Occupation:</B></font></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$thisprofile[5]</font>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="Verdana, Arial"><B>Location:</B></font></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$thisprofile[6]</font>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="Verdana, Arial"><B>Interests:</B></font></td>
<td><FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">$thisprofile[9]</font>
</td></tr>
</table>
</BLOCKQUOTE>
<HR>
</BODY></HTML>
BioHTML
}  ## END View BIO HTML sr
