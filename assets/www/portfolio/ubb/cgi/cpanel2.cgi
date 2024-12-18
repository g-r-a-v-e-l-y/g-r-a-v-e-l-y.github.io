#!/usr/bin/perl

#
###                  FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998-1999.
#
#       ------------ cpanel2.cgi -------------
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

require "mods.file";
require "Date.pl";
require "UltBB.setup";
require "Styles.file";
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

if ($action eq "setgenvars") { # only process for this one action

	if ($Name eq "BBName") {
		$BBName = $Value;
			}
	if ($Name eq "ForumsPath") {
		$ForumsPath = $Value;
	}
	if ($Name eq "MembersPath") {
		$MembersPath = $Value;
	}
	if ($Name eq "CGIPath") {
		$CGIPath = $Value;
	}
	if ($Name eq "VariablesPath") {
		$VariablesPath = $Value;
	}
	if ($Name eq "MembersCGIPath") {
		$MembersCGIPath = $Value;
	}
	if ($Name eq "NonCGIPath") {
		$NonCGIPath = $Value;
	}
	if ($Name eq "CGIURL") {
		$CGIURL = $Value;
	}
	if ($Name eq "NonCGIURL") {
		$NonCGIURL = $Value;
	}

	if ($Name eq "BBEmail") {
		$BBEmail = $Value;
		$BBEmail =~ s/@/\\@/;
	}
			
	if ($Name eq "BBRules") {
		$BBRules = $Value;
		$BBRules =~ s/"/&quot;/g;
		$BBRules =~ s/\@/\\@/g;
		$BBRules = &ConvertReturns($BBRules);
	}
	if ($Name eq "COPPAInstructions") {
		$COPPAInstructions = $Value;
		$COPPAInstructions =~ s/"/&quot;/g;
		$COPPAInstructions =~ s/\@/\\@/g;
		$COPPAInstructions = &ConvertReturns($COPPAInstructions);

	}


	if ($Name eq "MyHomePage") {
		$MyHomePage = $Value;
	}
	
	if ($Name eq "HomePageURL") {
		$HomePageURL = $Value;
	}

} # end if set genvars



	if ($Name eq "ViewEntire") {
		$ViewEntire = $Value;
	}
	if ($Name eq "NN") {
		$SearchName = $Value;
		$SearchName =~tr/A-Z/a-z/; 
	}

	if ($Name eq "number") {
		$number = $Value;
	}

	if ($Name eq "UpdateType") {
		$UpdateType = $Value;
	}		
	if ($Name eq "TotalForums") {
		$TotalForums = $Value;
	}

	if ($Name eq "UserNameCheck") {
		$UserNameCheck = $Value;
		$UserNameCheckFile = $UserNameCheck;
		$UserNameCheckFile =~ s/ /_/g; #remove spaces
	}
	if ($Name eq "UserName") {
		$UserName = $Value;
		$UserNameFile = $UserName;
		$UserNameFile =~ s/ /_/g; #remove spaces
	}
	if ($Name eq "Password") {
		$Password = $Value;
	}
	if ($Name eq "PasswordCheck") {
		$PasswordCheck = $Value;
	}
} #end foreach loop

if ($VariablesPath eq "") {
	$VariablesPath = "$CGIPath";
}


if ($action eq "mods") {
	&Mods;
}

if ($action eq "doupdate") {
##verify that this user is an administrator

$NameFound = "no";
  if (-e "$MembersPath/$UserNameFile.cgi") {
      $NameFound = "yes";
    } 

if ($NameFound eq "yes") {
	@profilestats = &OpenProfile("$UserName.cgi");
			
	if ($Password eq "$profilestats[1]") {
	$Permission = "$profilestats[4]";
	&CheckPermissions;
	   if ($AdminPermission eq "true") {
#determine number of total forums
open (FORUMFILE, "$VariablesPath/forums.cgi");
	@forums = <FORUMFILE>;
close (FORUMFILE);
@forums = grep(/\|/, @forums);
$TotalForums = @forums;

&ConvertForums2HTML("1", "$TotalForums", "0");
   
	   }  else {
	   &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again.  Use your Back button.");
	}
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. Use your Back button.");
}  ##END IF/ELSE NAME CHECK BLOCK
} #end do update (threads) sr

if ($action eq "setgenvars") {
	&SetGenVars;
}


if ($action eq "ContinueUpdate") {
	&ConvertForums2HTML("$number", "$TotalForums", "$in{'StartWith'}");
}


if ($action eq "getmatches") {
	&GetMatches;
}

if ($action eq "updatepermiss") {
	&UpdatePermiss;
}

if ($action eq "sendvarID") {
	&SendVarID;
}


if ($action eq "DoGenVars") {
	&DoGenVars;
}

sub SendVarID {
### CHECK USERNAME - must be an admin
##verify that this user is an administrator
$NameFound = "no";
if (-e "$MembersPath/$UserNameFile.cgi") {
      $NameFound = "yes";
	} 
if ($NameFound eq "yes") {
	@theprofile = &OpenProfile("$UserName.cgi");
	if ($Password eq "$theprofile[1]") {
	$Permission = "$theprofile[4]";
	&CheckPermissions;
	   if ($AdminPermission eq "true") {
	   &DoGenVars;
	   }  else {
	    &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again.  Use your Back button.");
	}
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. Use your Back button.");
}  ##END IF/ELSE NAME CHECK BLOCK

} # end SendVarsID sr

sub DoGenVars {
	
	$BBRules =~ s/&quot;/"/ig;
	$BBRules =~ s/<BR>/\n/ig;
	$BBRules =~ s/<p>/\n\n/ig;
	
	$COPPAInstructions =~ s/&quot;/"/ig;
	$COPPAInstructions =~ s/<BR>/\n/ig;
	$COPPAInstructions =~ s/<p>/\n\n/ig;
				
if ($ForumDescriptions eq "no") {
	$ForumDescriptionsOff = "CHECKED";
}  else {
	$ForumDescriptionsOn = "CHECKED";
}
		
if ($TimeFormat eq "24HR") {
	$Time24HR = "CHECKED";
}  else {
	$TimeAMPM = "CHECKED";
}		
if ($DateFormat eq "Euro") {
	$DateEuro = "CHECKED";
}  else {
	$DateUS = "CHECKED";
}
if ($EmailCheck eq "true") {
	$EmailTrue = "CHECKED";
}  else {
	$EmailFalse = "CHECKED";
}



if ($CGIPath eq '') {
	if($ENV{'SCRIPT_FILENAME'}){ #*nix
	 	$thiscgipath = $ENV{'SCRIPT_FILENAME'};	
	} elsif ($ENV{'PATH_TRANSLATED'}) { # Win32
		$thiscgipath = $ENV{'PATH_TRANSLATED'};
		$thiscgipath =~ s/\\/\//g; 
	}
	@cgipath = split(/\//, $thiscgipath);
	pop(@cgipath);
	$CGIPath = join("\/", @cgipath);
	$VariablesPath = $CGIPath;
	$MembersPath = ("$CGIPath" . "/Members");
	$cgiext = pop(@cgipath);
}
if ($NonCGIPath eq '') {
	$NonCGIPath = "$ENV{'DOCUMENT_ROOT'}/ubb";
	$ForumsPath = "$ENV{'DOCUMENT_ROOT'}/ubb";
}

if ($CGIURL eq '') {
	$CGIURL = "http://$ENV{'HTTP_HOST'}/$cgiext";
}

if ($NonCGIURL eq '') {
	$NonCGIURL = "http://$ENV{'HTTP_HOST'}/ubb";
}

if ($HomePageURL eq "") {
	$HomePageURL = "http://$ENV{'HTTP_HOST'}";
}

if ($BBEmail eq "") {
	$BBEmail = "$ENV{'SERVER_ADMIN'}";
}

if ($HomePageURL eq "") {
	$HomePageURL = "http://$ENV{'HTTP_HOST'}";
}

if ($MemberMinimum eq "") {
	$MemberMinimum = "31";
}
if ($EmailBlock eq "ON") {
	$EmailBlockOn = "CHECKED";
}  else {
	$EmailBlockOff = "CHECKED";
}
if ($TimeZoneOffset eq "") {
	$TimeZoneOffset = "0";
}
if ($COPPACheck eq "ON") {
	$COPPACheckON = "CHECKED";
}
   else {
	$COPPACheckOFF  = "CHECKED";
}

if ($COPPAInstructions eq '') {
	$COPPAInstructions = "The board administrator has not supplied exact instructions for how to mail or fax the COPPA permission form. Contact $BBEmail";	
}

if ($ShowPrivacyLink eq 'ON'){
$ShowPrivacyLinkON = 'CHECKED';
}
else {
$ShowPrivacyLinkOFF = 'CHECKED';	
}

$PageTitle = "Set Variables";
&HEADERHTML;

print<<THIS;
To check your environmental variables, <A HREF="cpanel.cgi?action=env">click here</A>.

<P>
<BR>
<U><B><FONT SIZE="4" FACE="COurier New" COLOR="#800000"><A NAME="GENVAR">General Settings</A></FONT></B></U>
<P>
<FORM ACTION="cpanel2.cgi" NAME="THEFORM" METHOD="POST">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="setgenvars">
<table border=0 width=100%>
<TR bgcolor="#000000"><TD COLSPAN=2 align=center><B><FONT SIZE="2" FACE="Verdana, Arial" color="#FFFF00">absolute paths</FONT></B>
</TD></TR>
<TR bgcolor="#FCF0C0">
<TD colspan=2><FONT SIZE="1" FACE="Verdana, Arial">
<B>Absolute paths reflect the physical locations of directories on a server.  They are the complete locations, not the locations from the web root, but from the server root.  Absolute paths on Win32/NT servers are displayed differently than on UNIX systems.  For instance, note the following samples for UNIX and NT:
<p>
For UNIX servers:  &nbsp;&nbsp;&nbsp;&nbsp;<FONT SIZE="1" FACE="Verdana, Arial" COLOR="#FF0000">/usr/home/yourdomain/www/cgi-bin</font>
<BR>
For Win32/NT servers:&nbsp;&nbsp;&nbsp;&nbsp; <FONT SIZE="1" FACE="Verdana, Arial" COLOR="#FF0000">C:/home/yourdomain/cgi-bin</FONT>
<P>
Note: the paths listed above are examples, not your actual paths.
<P>
If you are installing on Win32/NT, be sure to use the format above for your absolute paths (note the forward slashes, rather than backward slashes).
<BR>
If you are installing for the first time, the UBB will attempt to provide complete or partial absolute paths for you.  These paths may not be accurate or complete, but they will give you a headstart.  All absolute path fields MUST be provided for your UBB to run.</B></FONT>
</td></tr>
<tr bgcolor="#dedfdf">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Absolute Path for your UBB CGI DIRECTORY</B><br></FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="CGIPath" VALUE="$CGIPath" SIZE=40 MAXLENGTH=250>
</td></tr>

<tr bgcolor="#f7f7f7">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Absolute Path of your UBB NON CGI Directory</B><br></FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="NonCGIPath" VALUE="$NonCGIPath" SIZE=40 MAXLENGTH=250>
</td></tr>

<tr bgcolor="#dedfdf">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Absolute Path to Members Directory</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">This path should end in /Members (as in "/usr/home/yourdomain/www/cgi-bin/Members")</FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="MembersPath" VALUE="$MembersPath" SIZE=40 MAXLENGTH=250>
</td></tr>
<tr bgcolor="#f7f7f7">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Absolute Path to Directory Where Your Custom Variable Files  Reside</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial"><B>You should use the same absolute path that you used for your CGI directory above</B>.  If for some reason you cannot write to files in your CGI directory, however, you should place these files (UltBB.setup, forums.cgi, mods.file, Styles.file) in a directory below the web root so that they cannot be accessed by anyone from the browser. </FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="VariablesPath" VALUE="$VariablesPath" SIZE=40 MAXLENGTH=250>
</td></tr>
</table>
<P>
<table border=0 width=100%>
<TR bgcolor="#000000"><TD COLSPAN=2 align=center><p><B><FONT SIZE="2" FACE="Verdana, Arial" color="#FFFF00">URLs</FONT></B>
</p></TD></TR>

<TR bgcolor="#FCF0C0">
<TD colspan=2><FONT SIZE="1" FACE="Verdana, Arial"><p>
<B>Please provide the following complete hyperlinks.  Use complete hyperlinks, such as http://www.yourdomain.com/cgi-bin, rather than relative links such as "/cgi-bin"</B></FONT>
</p></td></tr>

<tr bgcolor="#dedfdf">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>URL for your UBB CGI Directory</B><br></FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="CGIURL" VALUE="$CGIURL" SIZE=40 MAXLENGTH=250>
</td></tr>

<tr bgcolor="#f7f7f7">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>URL for your UBB Non-CGI Directory</B><br></FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="NonCGIURL" VALUE="$NonCGIURL" SIZE=40 MAXLENGTH=250>
</td></tr>

<TR bgcolor="#dedfdf">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><p><B>Your Home Page URL</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">The complete URL for your home page (not the bulletin board).  This will be used for links back to your homepage.</FONT></p>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="HomePageURL" VALUE="$HomePageURL" SIZE=40 MAXLENGTH=250>
</td></tr>

THIS

&InputTextRow("#f7f7f7", "<p>Your Privacy Statement", "</b>The complete URL for your web site's privacy statement.  This will be used to describe your policies concerning user information.</p>", "PrivacyURL", "40", "250");


&InputRadioRow("#dedfdf", "<p>Display Privacy Statement Link ?", "</b>You can display the link to your Privacy Statement on every UBB page.  Check yes to include it. Note: if you check no, your Privacy URL will still appear in any Children's Online Protection routines.</p>", "<INPUT TYPE=\"RADIO\" NAME=\"ShowPrivacyLink\" VALUE=\"ON\" $ShowPrivacyLinkON> Yes<br>
<INPUT TYPE=\"RADIO\" NAME=\"ShowPrivacyLink\" VALUE=\"OFF\" $ShowPrivacyLinkOFF> No");


print qq(

</table>
<P>

<table border=0 width=100%>
<TR bgcolor="#000000"><TD COLSPAN=2 align=center><B><FONT SIZE="2" FACE="Verdana, Arial" color="#FFFF00">Display Options</FONT></B>
</TD></TR>

<TR bgcolor="#FCF0C0">
<TD colspan=2><FONT SIZE="1" FACE="Verdana, Arial">
<B>Please complete the following fields, which provide information such as your BB Name, the name of your home page, the email address to be displayed, headers and footers to use on each page, etc.</B></FONT>
</td></tr>

<TR bgcolor="#dedfdf">
<td width=50%><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Your Email Address</B></FONT><br>
<FONT SIZE="1" FACE="Verdana, Arial">This is email address that will be shown so that users can contact you</FONT></p>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="BBEmail" VALUE="$BBEmail" SIZE=30 MAXLENGTH=250>
</td></tr>

<TR bgcolor="#f7f7f7">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Name of Your Bulletin Board</B><br></FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="BBName" VALUE="$BBName" SIZE=30 MAXLENGTH=250>
</td></tr>

<TR bgcolor="#dedfdf">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><p><B>Name of Your Home Page</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial" >The name of your homepage, which will listed for links back to your homepage.</FONT></p>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="MyHomePage" VALUE="$MyHomePage" SIZE=30 MAXLENGTH=250>
</td></tr>


<tr bgcolor="#f7f7f7">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Display Forum Descriptions?</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">If you have many forums, you may not want to display your forum descriptions.  If not, check no.</FONT></td>
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><INPUT TYPE="RADIO" NAME="ForumDescriptions" VALUE="yes" $ForumDescriptionsOn> yes<br>
<INPUT TYPE="RADIO" NAME="ForumDescriptions" VALUE="no" $ForumDescriptionsOff> no
</FONT>
</td></tr>

<TR bgcolor="#dedfdf">
<td width=50% valign=top><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Bulletin Board Rules</B><BR></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">You can customize the exact wording for your bulletin board's rules.  Just edit the wording in the box to the right.</FONT></p>
</td>
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><B>$BBName Rule Wording:</B><br></FONT>
<TEXTAREA NAME="BBRules" ROWS=8 COLS=35 wrap="virtual">$BBRules
</TEXTAREA>
</td></tr>
); #end qq

&InputRadioRow("#f7f7f7", "Children's Online Privacy Protection [COPPA]", "This option must be used by all sites which expect to register users under the age of 13. Though this is an American law, it may affect non-US sites too.  Consult competent legal advice. Activating this option will ask the user's age and send him/her to a special registration page.", "<INPUT TYPE=\"RADIO\" NAME=\"COPPACheck\" VALUE=\"ON\" $COPPACheckON>  Age Check Required<br><INPUT TYPE=\"RADIO\" NAME=\"COPPACheck\" VALUE=\"OFF\" $COPPACheckOFF> Age Check Not Required");

print qq(
<tr bgcolor="#dedfdf">
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><p><B>COPPA Instructions</B><BR></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">Provide detailed instructions for how a user under 13 can mail or FAX you a parental permission form.</FONT></p>
</td>
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Instructions:</B><br></FONT>
<TEXTAREA NAME="COPPAInstructions" ROWS=8 COLS=35 wrap="virtual">$COPPAInstructions
</TEXTAREA>
</td></tr>




<TR bgcolor="#f7f7f7">
<td width=50% valign=top><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Block Public Display of User Email Addresses?</B><BR></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">The default option is to have registered user's email addresses viewable on the pages for which the user has posted a note.  You may prevent all user email addresses from being displayed by selecting "Block Email Address Display" in the field to the right.  These addresses will still be available to you if you check the user's info in the "User Info/Permissions" area of the Control Panel.</FONT></p>
</td><td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><INPUT TYPE="RADIO" NAME="EmailBlock" VALUE="ON" $EmailBlockOn> Block Public Display of User Email Addresses<BR>
<INPUT TYPE="RADIO" NAME="EmailBlock" VALUE="OFF" $EmailBlockOff> Show User Email Addresses</FONT>
</td></tr>

</table>
<P>
<table border=0 width=100%>
<TR bgcolor="#000000"><TD COLSPAN=2 align=center><B><FONT SIZE="2" FACE="Verdana, Arial" color="#FFFF00">Date/Time Display Options</FONT></B>
</TD></TR>

<TR bgcolor="#FCF0C0">
<TD colspan=2><FONT SIZE="1" FACE="Verdana, Arial">
<B>The UBB can display dates and times in a number of different formats.  Remember that the times listed are based on the location of your web server, which may be different than the time zone where you reside/work.  You can change the time zone displayed by using the Time Zone Offset field.  For instance, if you are on the East Coast of the US, but your server is on the West Coast of the US, you could use EST as your Time Zone to display, but you would have to offset the server time to reflect that (by typing a 3 in the Time Zone Offset field, reflecting the 3 hours difference).  If the Time Zone difference is negative, use a begative number (as in -2).</B></FONT>
</td></tr>

<TR bgcolor="#f7f7f7">
<td width=50%><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Time Zone</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">The time of each posting is based on the time zone where your server is located.  If you want your users to know the time zone, provide it here (e.g., ET, CT, PT, etc.).  You may also leave this blank if you would prefer not to show a time zone.  You may type a different time zone than your server uses, but if you do so be sure to provide a time zone offset in the next field.</FONT>
</p></td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="TimeZone" VALUE="$TimeZone" SIZE=20 MAXLENGTH=35>
</td></tr>


<TR bgcolor="#dedfdf">
<td width=50%><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Server Time Zone Offset</B></FONT><br>
<FONT SIZE="1" FACE="Verdana, Arial">You can offset the time drawn from your web server.  For instance, if your server time is EST (US), but you want all time to reflect Pacific Time (US), you would have to offset your server time by placing the time zone difference in this field (for this example, that would be -3.  You would place -3 in this field).  The default is for there to be no server time zone offset (0).</FONT></p>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="TimeZoneOffset" VALUE="$TimeZoneOffset" SIZE=3 MAXLENGTH=4>
</td></tr>

<TR bgcolor="#f7f7f7">
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Date Format</B></FONT><BR>
<FONT SIZE="1" FACE="Verdana, Arial">European Format is DD-MM-YR, while US format is MM-DD-YR.</FONT>
</td>
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial">
<INPUT TYPE="RADIO" NAME="DateFormat" VALUE="US" $DateUS> US Format (Month-Day-Year)<BR>
<INPUT TYPE="RADIO" NAME="DateFormat" VALUE="Euro" $DateEuro> European Format (Day-Month-Year)
</font>
</td></tr>
<TR bgcolor="#dedfdf">
<td width=50% valign=top><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Time Format</B></FONT><BR>
<FONT SIZE="1" FACE="Verdana, Arial">You can have time displayed in AM/PM format, or in 24-hour format.</FONT>
</p>
</td>
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial">
<INPUT TYPE="RADIO" NAME="TimeFormat" VALUE="AMPM" $TimeAMPM> Use AM/PM Time Format<BR>
<INPUT TYPE="RADIO" NAME="TimeFormat" VALUE="24HR" $Time24HR> User 24-Hour Format Time (eg, 23:15)
</font>
</td></tr>
</table>
<P>

<table border=0 width=100%>
<TR bgcolor="#000000"><TD COLSPAN=2 align=center><B><FONT SIZE="2" FACE="Verdana, Arial" color="#FFFF00">Miscellaneous Options</FONT></B>
</TD></TR>

<TR bgcolor="#FCF0C0">
<TD colspan=2><FONT SIZE="1" FACE="Verdana, Arial">
<B>Below are numerous configuration options for your UBB.</B></FONT>
</td></tr>


<TR bgcolor="#dedfdf">
<td width=50%><p>
<FONT SIZE="2" FACE="Verdana, Arial"><B>Email Duplicate Check</B><br></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">The default option is to require unique email addresses for each registered user.  This means that no two users can have the same email address. You can disable this requirement by checking the "Unique Email Not Required" box.</FONT></p>
</td>
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial"><INPUT TYPE="RADIO" NAME="EmailCheck" VALUE="true" $EmailTrue> Unique Email Required<br>
<INPUT TYPE="RADIO" NAME="EmailCheck" VALUE="false" $EmailFalse> Unique Email Not Required
</FONT>
</td></tr>


</table>
<P>
<br>
<CENTER><FONT Size="2" FACE="Verdana, Arial"><B>Enter your UserName & Password:</font>
<P>
<FONT Size="1" FACE="Verdana, Arial" COLOR="#808000">(NOTE: if you are configuring your BB for the first time, type your default UserName and Password here)</font>
<p>
<FONT Size="2" FACE="Verdana, Arial">
UserName: <INPUT TYPE="TEXT" NAME="UserNameCheck" SIZE=25 MAXLENGTH=25>&nbsp;&nbsp;&nbsp;&nbsp; Password <INPUT TYPE="PASSWORD" NAME="PasswordCheck" SIZE=13 MAXLENGTH=13></FONT></B></CENTER>
<p><center>
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit General Variables"></center>
</form>
</BODY></HTML>
); # end qq
}



sub UpdatePermiss {

@theprofile = &OpenProfile("$UserNameCheck.cgi");

if ($in{'PasswordCheck'} eq "$theprofile[1]") {
	$Status = "$theprofile[8]";
	&CheckStatus;
	   if ($AdminStatus eq "true") {
			&UpdateThePermissions;
		}  else {
			&StandardHTML("Sorry, but you are not authorized to perform this function.  Use your Back button.");
		} #end if adminstatus is true 
}  else {
&StandardHTML("Sorry, but the password you entered was not correct.  Please try again.  Use your Back button.");
}
}  ## END UPdatePermiss SR ###


sub GetMatches {

##verify that this user is an administrator

$NameFound = "no";
if (-e "$MembersPath/$UserNameFile.cgi") {
      $NameFound = "yes";
	} 

if ($NameFound eq "yes") {
	@theprofile = &OpenProfile("$UserName.cgi");
			
	if ($Password eq "$theprofile[1]") {
	$Permission = "$theprofile[4]";
	&CheckPermissions;
	   if ($AdminPermission eq "true") {
	   	   
if ($ViewEntire eq "Yes") {
	&GetAll;
	} else {
	&DoSearch;
	}
	   }  else {
	    &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again.  Use your Back button.");
	}
		
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. Use your Back button.");
}  ##END IF/ELSE NAME CHECK BLOCK


## if admin priviledges, conduct search


sub GetAll {
&GetMemberListArray; #returns @members array

	@members = sort(@members);
	$TotalProfiles = @members;
	
if ($TotalProfiles > 0) {	

print <<HTML_TOP;
<HTML>
<HEAD><TITLE>
Ultimate Bulletin Board - Set Permissions - All Members</title>

</head>
<body bgcolor="#FFFFFF" link="#000080" vlink="#808000">
<FONT Size="2" FACE="Verdana, Arial">
<center>
<B><FONT SIZE="5" FACE="Courier New">Ultimate Bulletin Board<br>Set Permissions </FONT></B></center>
<p>
There are currently $TotalProfiles registered bulletin board members.
Make any changes necessary and then click on "Submit" to modify any/all user records.  Check the delete box on the left for all registrations you want deleted.<br><br>

<FORM ACTION="cpanel2.cgi" METHOD="POST" NAME="PERMISS">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="updatepermiss">

<center>
<table width=600>
<tr bgcolor="#cccc99">
<td valign=bottom>
<FONT SIZE="1" FACE="Verdana, Arial">
<B>Delete?</B></font>
</td>
<td valign=bottom width=140><FONT SIZE="1" FACE="Verdana, Arial"><B>User Name<BR>Date Registered</B></FONT></td>
<td valign=bottom ><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#FF0000"><B>Able to post notes?</B></FONT></td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#FF0000"><B>Authorized Administrator?</B></FONT></td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial"><B>Status</B></FONT></td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial"><B>Total Posts</B></FONT></td>
</tr>
HTML_TOP



for $line(@members) {

@searchrow = &OpenProfile("$line");

$UNCoded = $searchrow[0];
$UNCoded =~ tr/ /+/;
$Posts = $searchrow[7];
$Permission = $searchrow[4];
&CheckPermissions;
$DateReg = $searchrow[10];
$WriteYes = "";
$WriteNo = "";
$AdminYes="";
$AdminNo="";

if ($AdminWrite eq "true") {
   $WriteYes = "CHECKED";
}  else {
   $WriteNo = "CHECKED";
}
if ($AdminPermission eq "true") {
   $AdminYes = "CHECKED";
}  else {
   $AdminNo = "CHECKED";
}
####
if ($AltColor eq "") {
	$AltColor = "#dedfdf";
}
if ($AltColor eq "#f7f7f7") {
	$AltColor = "#dedfdf";
}  else {
$AltColor = "#f7f7f7";
}

print <<GUTS;
<tr bgcolor="$AltColor">
<td align=center>
<INPUT TYPE="CHECKBOX" NAME="Delete::$searchrow[0]" VALUE="yes">
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial"><A HREF="cpanel.cgi?action=getbio4admin&UserName=$UNCoded">$searchrow[0]</A><BR>$DateReg</font></td>
<td><FONT SIZE="1" FACE="Verdana, Arial">
<INPUT TYPE="RADIO" NAME="AdminWrite::$searchrow[0]" VALUE="true" $WriteYes>Yes &nbsp;&nbsp;
<INPUT TYPE="RADIO" NAME="AdminWrite::$searchrow[0]" VALUE="false" $WriteNo>No
</FONT>
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial">
<INPUT TYPE="RADIO" NAME="AdminPermission::$searchrow[0]" VALUE="true" $AdminYes>Yes &nbsp;&nbsp;
<INPUT TYPE="RADIO" NAME="AdminPermission::$searchrow[0]" VALUE="false" $AdminNo>No
</FONT>
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial">$searchrow[8]</FONT></td>
<td><FONT SIZE="1" FACE="Verdana, Arial">$searchrow[7]</FONT></td>
</tr>
GUTS

####
} #end FOREACH

print <<ENDHTML;
</table>
</center>
<br>
<CENTER><FONT Size="2" FACE="Verdana, Arial" COLOR="#800000"><B>For security reasons, re-enter your UserName & Password: <BR>
UserName: <INPUT TYPE="TEXT" NAME="UserNameCheck" SIZE=25 MAXLENGTH=25>&nbsp;&nbsp;&nbsp;&nbsp; Password <INPUT TYPE="PASSWORD" NAME="PasswordCheck" SIZE=13 MAXLENGTH=13></FONT></B></CENTER>
<p>
<CENTER><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Permission Changes Now">
</form><FONT COLOR="#C0C0C0">
<BR><BR>Powered by: Ultimate Bulletin Board<br>
&copy; Infopop Corporation, 1998-2000.<BR><BR>.</CENTER>
</FONT>
</FONT>
</body>
</html>
ENDHTML
}  else {
&StandardHTML("Sorry, but we couldn't find any users that matched your search criteria.  Please go back and try again!");
}

}  ## END GET ALL SR ##

sub DoSearch {
&GetMemberListArray;  #returns @members array
$TotalMembers = @members;
$CheckEmail = "$in{'Email'}";
$Search = 0;

foreach $member(@members) {

@searchfile = &OpenProfile("$member");
$bad = "no";

#start UserName check block

	if ($SearchName ne "") {

		unless ($searchfile[0] =~ /$SearchName/i) {
			$bad = "yes";
		}
	} 


	if (($CheckEmail ne "") && ($bad ne "yes")) {
			unless ($searchfile[2] =~ /$CheckEmail/i) {
				$bad = "yes";
			}
	} 
	# Check number of posts
	
	if (($in{'Posts'} ne "") && ($bad ne "yes")) {
		$PostNumber = $searchfile[7];
		$Math = $in{'Math'};
		if ($Math eq "GT") {
			unless ($PostNumber >= $in{'Posts'}) {
				$bad = "yes";
		}
		}
		if ($Math eq "LT") {
			unless ($PostNumber <= $in{'Posts'}) {
				$bad = "yes";	
			}  
		}
		if ($Math eq "EQ") {
			unless ($PostNumber == $in{'Posts'}) {
				$bad = "yes";
			}
		}
		
	} 

#start validation block

if ($bad ne "yes")  {
$Search++;

$line = ("$searchfile[0]" .  "|" .  "$searchfile[2]" .  "|"  . "$searchfile[4]" . "|" . "$searchfile[8]" . "|" . "$searchfile[7]" . "|" . "$searchfile[10]");
push (@final, $line);
}  

#close validation block

}  #end FOREACH $member


if ($Search > 0) {	

@final = sort(@final);

print <<HTML_TOP;
<HTML>
<HEAD>

<TITLE>
Ultimate Bulletin Board - Set Permissions - All Members</title></head>
<body bgcolor="#FFFFFF" link="#000080" vlink="#808000">
<FONT Size="2" FACE="Verdana, Arial">

<CENTER><b>
<FONT SIZE="5" FACE="Courier New">Ultimate Bulletin Board<br>Set Permissions </FONT></B>
</center>
<p>
Total Registered Users: <FONT SIZE="2" FACE="Verdana, Arial" COLOR="#800000"><b>$TotalMembers</B></FONT><BR>
Search Matches: <FONT SIZE="2" FACE="Verdana, Arial" COLOR="#800000"><b>$Search</B></FONT>
<P>
Make any changes necessary and then click on "Submit" to modify any/all user records.  Check the delete box on the left for all registrations you want deleted.<br><br>

<FORM ACTION="cpanel2.cgi" METHOD="POST" NAME="PERMISS">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="updatepermiss">
<center>
<table width=95%>
<tr bgcolor="#cccc99">
<td valign=bottom>
<FONT SIZE="1" FACE="Verdana, Arial">
<B>Delete?</B></font>
</td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial"><B>User Name<BR>Date Registered</B></FONT></td>
<td valign=bottom ><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#FF0000"><B>Able to post notes?</B></FONT></td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#FF0000"><B>Authorized Administrator?</B></FONT></td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial"><B>Status</B></FONT></td>
<td valign=bottom><FONT SIZE="1" FACE="Verdana, Arial"><B>Total Posts</B></FONT></td>
</tr>
HTML_TOP

foreach $line2(@final) {
		
	@searchrow = split (/\|/, $line2);
	
$UNCoded = $searchrow[0];
$UNCoded =~ tr/ /+/;

$Permission = $searchrow[2];
$DateReg = $searchrow[5];
&CheckPermissions;
$WriteYes = "";
$WriteNo = "";
$AdminYes="";
$AdminNo="";

if ($AdminWrite eq "true") {
   $WriteYes = "CHECKED";
}  else {
   $WriteNo = "CHECKED";
}
if ($AdminPermission eq "true") {
   $AdminYes = "CHECKED";
}  else {
   $AdminNo = "CHECKED";
}
if ($AltColor eq "") {
	$AltColor = "#dedfdf";
}
if ($AltColor eq "#f7f7f7") {
	$AltColor = "#dedfdf";
} else {
$AltColor = "#f7f7f7"
}

print <<GUTS;
<tr bgcolor=$AltColor>
<td align=center>
<INPUT TYPE="CHECKBOX" NAME="Delete::$searchrow[0]" VALUE="yes">
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial"><A HREF="cpanel.cgi?action=getbio4admin&UserName=$UNCoded">$searchrow[0]</A><BR>$DateReg</font></td>
<td><FONT SIZE="1" FACE="Verdana, Arial">
<INPUT TYPE="RADIO" NAME="AdminWrite::$searchrow[0]" VALUE="true" $WriteYes>Yes &nbsp;&nbsp;
<INPUT TYPE="RADIO" NAME="AdminWrite::$searchrow[0]" VALUE="false" $WriteNo>No
</FONT>
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial">
<INPUT TYPE="RADIO" NAME="AdminPermission::$searchrow[0]" VALUE="true" $AdminYes>Yes &nbsp;&nbsp;
<INPUT TYPE="RADIO" NAME="AdminPermission::$searchrow[0]" VALUE="false" $AdminNo>No
</FONT>
</td>
<td><FONT SIZE="1" FACE="Verdana, Arial">$searchrow[3]</FONT></td>
<td><FONT SIZE="1" FACE="Verdana, Arial">$searchrow[4]</FONT></td></tr>
GUTS

} #end FOREACH

print <<ENDHTML;
</table>
<br>
<FONT Size="2" FACE="Verdana, Arial" COLOR="#800000"><B>For security reasons, re-enter your UserName & Password: <BR>
UserName: <INPUT TYPE="TEXT" NAME="UserNameCheck" SIZE=25 MAXLENGTH=25>&nbsp;&nbsp;&nbsp;&nbsp; Password <INPUT TYPE="PASSWORD" NAME="PasswordCheck" SIZE=13 MAXLENGTH=13></FONT></B></CENTER><P>
<CENTER><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Permission Changes Now">
</form><FONT COLOR="#C0C0C0">
<BR><BR>Powered by: <A HREF="http://www.ultimatebb.com">Ultimate Bulletin Board</A><BR>
&copy; Infopop Corporation, 1998-2000.<BR><BR>.</CENTER>
</FONT>
</FONT>
</body>
</html>
ENDHTML
}  else {
&StandardHTML("Sorry, but we couldn't find any users that matched your search criteria.  Please go back and try again!");
}
}  ##END DOSEARCH SR ###
}  #end GetMatches SR ###


sub SetGenVars {
### CHECK USERNAME - must be an admin
##verify that this user is an administrator

$NameFound = "no";
  if (-e "$MembersPath/$UserNameCheckFile.cgi") {
      $NameFound = "yes";
    } 

if ($NameFound eq "yes") {
	@profilestats = &OpenProfile("$UserNameCheck.cgi");
			
	if ($in{'PasswordCheck'} eq "$profilestats[1]") {
	$Permission = "$profilestats[4]";
	&CheckPermissions;
	   if ($AdminPermission eq "true") {
	   &DoProcessGenVars;
	   }  else {
	    &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again. Use your Back button.");
	}
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. <P>If you are configuring your bulletin board for the first time, this is probably due to the fact that you did not set the proper variable for your CGI Directory absolute path.<P>Use your Back button to try again.");
}  ##END IF/ELSE NAME CHECK BLOCK
}  ##END Set Gen Vars

sub DoProcessGenVars {

$variable1=('$BBEmail = ' . '"' . $BBEmail . '";');
$variable2=('$MembersPath = ' . '"' . $in{'MembersPath'} . '";');
$variable3=('$MyHomePage = ' . '"' . $MyHomePage . '";');
$variable4=('$HomePageURL = ' . '"' . $HomePageURL . '";');
$variable5=('$BBName = ' . '"' . $BBName . '";');
$variable6=('$ForumsPath = ' . '"' . $in{'NonCGIPath'} . '";');
$variable7=('$CGIPath = ' . '"' . $in{'CGIPath'} . '";');
$variable8=('$NonCGIPath = ' . '"' . $in{'NonCGIPath'} . '";');
$variable9=('$CGIURL = ' . '"' . $in{'CGIURL'} . '";');
$variable10=('$NonCGIURL = ' . '"' . $in{'NonCGIURL'} . '";');
$variable11=('$EmailCheck = ' . '"' . $in{'EmailCheck'} . '";');
$variable12=('$TimeZone = ' . '"' . &decodeURL($in{'TimeZone'}) . '";');
$variable13=('$BBRules = ' . '"' . $BBRules . '";');
$variable14=('$ForumDescriptions = ' . '"' . $in{'ForumDescriptions'} . '";');
$variable15=('$DateFormat = ' . '"' . $in{'DateFormat'} . '";');
$variable16=('$TimeZoneOffset = ' . '"' . $in{'TimeZoneOffset'} . '";');
$variable17=('$TimeFormat = ' . '"' . $in{'TimeFormat'} . '";');
$variable18=('$VariablesPath = ' . '"' . $VariablesPath . '";');
$variable19=('$EmailBlock = ' . '"' . $in{'EmailBlock'} . '";');
$variable20=('$PrivacyURL = ' . '"' . $in{'PrivacyURL'} . '";');
$variable21=('$ShowPrivacyLink = ' . '"' . $in{'ShowPrivacyLink'} . '";');
$variable22=('$COPPAInstructions = ' . '"' . $COPPAInstructions . '";');
$variable23=('$COPPACheck = ' . '"' . $in{'COPPACheck'} . '";');

open (FILE, ">$VariablesPath/UltBB.setup") or die(&StandardHTML("Unable to open UltBB.setup file for writing<br>Error: $!<p>Please check that absolute paths are correct in the control panel and the permissions are set properly."));
	print FILE ("$variable0\n");
	print FILE ("$variable1\n");
	print FILE ("$variable2\n");
	print FILE ("$variable3\n");
	print FILE ("$variable4\n");
	print FILE ("$variable5\n");
	print FILE ("$variable6\n");
	print FILE ("$variable7\n");
	print FILE ("$variable8\n");
	print FILE ("$variable9\n");
	print FILE ("$variable10\n");
	print FILE ("$variable11\n");
	print FILE ("$variable12\n");
	print FILE ("$variable13\n");
	print FILE ("$variable14\n");
	print FILE ("$variable15\n");
	print FILE ("$variable16\n");
	print FILE ("$variable17\n");
	print FILE ("$variable18\n");
	print FILE ("$variable19\n");
	print FILE ("$variable20\n");
	print FILE ("$variable21\n");
	print FILE ("$variable22\n");
	print FILE ("$variable23\n");
	print FILE ("1;\n");
close (FILE);

# create forum directories and set permissions on directories
unless (-e "$in{'NonCGIPath'}/Forum2") {
chmod(0777, "$in{'NonCGIPath'}");
chmod(0755, "$in{'CGIPath'}");
chmod(0777, "$in{'MembersPath'}");
chmod(0777, "$in{'MembersPath'}/Admin5.cgi");
mkdir ("$in{'NonCGIPath'}/Forum1", 0777)  or die(&StandardHTML("Unable to make new forum directory<br>Error: $!<p>Please check the path to the NonCGI directory in the control panel.<p>Also check the directory permissions again."));;
chmod(0777, "$in{'NonCGIPath'}/Forum1");
mkdir ("$in{'NonCGIPath'}/Forum2", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum2");
mkdir ("$in{'NonCGIPath'}/Forum3", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum3");
mkdir ("$in{'NonCGIPath'}/Forum4", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum4");
mkdir ("$in{'NonCGIPath'}/Forum5", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum5");
mkdir ("$in{'NonCGIPath'}/Forum6", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum6");
mkdir ("$in{'NonCGIPath'}/Forum7", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum7");
mkdir ("$in{'NonCGIPath'}/Forum8", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum8");
mkdir ("$in{'NonCGIPath'}/Forum9", 0777);
chmod(0777, "$in{'NonCGIPath'}/Forum9");
$SkipConversion = "true";
}

###############################################
## Perform diagnostic checks/update if necessary
if (-e "$NonCGIPath/ubbdiagnostic.file") {
open(DIAG, "$NonCGIPath/ubbdiagnostic.file");
@diag = <DIAG>;
close(DIAG);

foreach $diagline(@diag) {
	if ($diagline =~ m/SetLastTimes/) {
		$SLT = "true";
	}
	if ($diagline =~ m/ConvertToUBBFiles/) {
		$CTUF = "true";
	}
	if ($diagline =~ m/CreateLastForumNums/) {
		$CLFN = "true";
	}
}


if ($CTUF ne "true") {
	&RenameMess;
}

if ($SLT ne "true") {
	&SetLastTimes;
}

if ($CLFN ne "true") {
	&SetLastThreadNums;
}
}  else {

if ($SkipConversion ne "true") {
#convert message files to ubb files
&RenameMess;
#reset last time files
&SetLastTimes;
#create last thread number file in each forum
&SetLastThreadNums;
}


#create ubbdiagnostic file--
open(DIAG, ">$NonCGIPath/ubbdiagnostic.file");
print DIAG ("SetLastTimes\n");
print DIAG ("ConvertToUBBFiles\n");
print DIAG ("CreateLastForumNums\n");
close(DIAG);
chmod (0777, "$NonCGIPath/ubbdiagnostic.file");
}


## END DIAGNOSTIC CHECK/UPDATE

$UserName = "$UserNameCheck";
$UserName =~ tr/ /+/;
$Password = "$PasswordCheck";
$Password =~ tr/ /+/;

$ConfirmLine = "The Ultimate Bulletin Board General Variables have been updated.<P>
If you are setting up your UBB for the first time, be sure to also make your Style and Forum settings next!
<P>
If you are changing previous settings, you need to update those threads.  You can do this using the \"Update Threads\" control panel option.  Depending on the number of threads you have stored on your system, the updating process can be time-consuming.  It is thus recommended that you do not update your threads until after you have made all control panel setting changes.<P>";
&ConfirmHTML2;

} ## END DO PROCESS GENERAL VARS SR

sub Mods {
##verify that this user is an administrator
$NameFound = "no";
if (-e "$MembersPath/$UserNameFile.cgi") {
      $NameFound = "yes";
	} 

if ($NameFound eq "yes") {
	@profilestats = &OpenProfile("$UserName.cgi");
			
	if ($Password eq "$profilestats[1]") {
	$Permission = "$profilestats[4]";
	&CheckPermissions;
	   if ($AdminPermission eq "true") {
	   &DoProcess;
	   }  else {
	    &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again. Use your Back button.");
	}
	
	
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. Use your Back button.");
}  ##END IF/ELSE NAME CHECK BLOCK

sub DoProcess {

&GetMemberListArray;  #returns @members array

## now we have our current Member list (in filename format)

foreach $row(@in) {
	($Name, $Value) = split ("=", $row);
	if ($Name =~ m/NewMod/) {
	($Trash, $Number) = split(/Mod/, $Name);
	$Combine = ("$Number" . "::" . "$Value");
	push (@GoodMods, $Combine);
	}
} # end foreach $row

#	for (@GoodMods2) {
#		($Trash, $ModSplit) = split(/::/, $_);
#		push (@GoodMods, $ModSplit);
#	}

#now Moderator names are in order

for (@GoodMods) {
	$modmatch = "false";
	($ForumNumber, $ModName) = split(/::/, $_);
	if (($ModName ne "none") && ($ModName ne "")) {
		$ModCoded = "$ModName";
		$ModCoded =~ s/ /_/g; #convert spaces
			for $matcher(@members) {
				if ($matcher eq "$ModCoded.cgi") {
					$modmatch = "true";
$modline = ('$Forum' . "$ForumNumber" . 'Moderator = "' . "$ModName" . '"' . ";\n");
		push(@modarray, $modline);
				} #end if modcoded
			} #end for $matcher

	if ($modmatch ne "true") {
		$error = "true";
		$errorline = ("$errorline" .  "The moderator name \"$_\" is not a valid UserName.<br>");
	} # end if $modmatch
} # if not "none"
} # end for

if ($error ne "true") {
	open (MODS, ">$VariablesPath/mods.file") or die(&StandardHTML("Unable to write to  mods.file  $!"));
		print MODS (@modarray);
		print MODS ("1;\n");
	close (MODS);

## UPDATE MEMBER PROFILES FOR ALL MODERATORS

for (@GoodMods) {
	($ForumNumber, $ModName) = split(/::/, $_);
	if (($ModName ne "none") && ($ModName ne "")) {
	$ModCoded = "$ModName";
	$ModCoded =~ s/ /_/g; #convert spaces
		@modprof = &OpenProfile("$ModName.cgi");
		$Status = $modprof[8];
			&CheckStatus;
			if ($AdminStatus ne "true") {
						
				open (UPDATE, ">$MembersPath/$ModCoded.cgi");
				print UPDATE ("$modprof[0]|");
					print UPDATE ("$modprof[1]|");
					print UPDATE ("$modprof[2]|");
					print UPDATE ("$modprof[3]|");
					print UPDATE ("$modprof[4]|");
					print UPDATE ("$modprof[5]|");
					print UPDATE ("$modprof[6]|");
					print UPDATE ("$modprof[7]|");
					print UPDATE ("Moderator|");
					print UPDATE ("$modprof[9]|");
					print UPDATE ("$modprof[10]|");
					print UPDATE ("$modprof[11]|");
					print UPDATE ("$modprof[12]\n");
			close (UPDATE);
			}  ## END IF madprof
	}  # END if not "none"
} # end for


## Delete Moderator status from users who are no longer Moderators

foreach $row(@in) {
	($Name, $Value) = split ("=", $row);
	if ($Name =~ m/OldMod/) {
	push (@OldMods, $Value);
	}
} # end foreach $row

for $oldie(@OldMods) {
	$SaveOldie = "no";
	for $checkthis(@GoodMods) {
		($ForumNum, $TheGoodModName) = split(/::/, $checkthis);
		if ($oldie eq "$TheGoodModName") {
		$SaveOldie = "yes";
		}
	}
	if (($SaveOldie ne "yes") && ($oldie ne "none") && ($oldie ne "")) {
		$OldieFile = "$oldie";
		$OldieFile =~ s/ /_/g; #remove spaces
		@oldmod = &OpenProfile("$oldie.cgi");  #only change
			$Status = $oldmod[8];
			$TotalPosts = $oldmod[7];
			&CheckStatus;
			
			if ($AdminStatus ne "true") {
				if ($TotalPosts < $MemberMinimum) {
					$Status = "Junior Member";
				}  else {
					$Status = "Member";
				}
				###
				
				open (UPDATE, ">$MembersPath/$OldieFile.cgi");
					print UPDATE ("$oldmod[0]|");
					print UPDATE ("$oldmod[1]|");
					print UPDATE ("$oldmod[2]|");
					print UPDATE ("$oldmod[3]|");
					print UPDATE ("$oldmod[4]|");
					print UPDATE ("$oldmod[5]|");
					print UPDATE ("$oldmod[6]|");
					print UPDATE ("$oldmod[7]|");
					print UPDATE ("$Status|");
					print UPDATE ("$oldmod[9]|");
					print UPDATE ("$oldmod[10]|");
					print UPDATE ("$oldmod[11]|");
					print UPDATE ("$oldmod[12]\n");
			close (UPDATE);
		}  ## END IF ADMIN status ne true
	}

} 


$ConfirmLine = "The forum moderators have been successfully updated.";
&ConfirmHTML2;

} else {

print<<Error;
<HTML><BODY BGCOLOR="#FFFFFF" link="#000080" vlink="#808000">
<br><br><FONT Size="2" FACE="Verdana, Arial"><B>
Sorry, we could not process the Moderator updates, due to the following error(s).
<P>
<FONT COLOR="#FF0000">$errorline</FONT>
<p>
Use your back button to go back to the Moderator page, or use the links below.
<p>
Return to: <br>
<ul>
<A HREF="$NonCGIURL/controlpanel.html">Control Panel</A><br>
<A HREF="$CGIURL/Ultimate.cgi?action=intro">Bulletin Board</A>
</ul>
</B></FONT>
</BODY></HTML>
Error

}#end if/else error ne true
}  ## END DO PROCESS SR

}  # END MODS SR


sub CheckStatus {

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

} #end CheckStatus




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
<P>
<FONT SIZE="2" FACE="Verdana, Arial">
HEADER
} #end HEADERHTML sr

sub HEADER2HTML {
print<<HEADER2HTML;
<HTML>
<HEAD>
	<TITLE>$BBName</TITLE>
</HEAD>
<BODY bgcolor="#FFFFFF" link="#000080" vlink="#808000">
<BR><center>
<FONT SIZE="5" FACE="Courier New"><B>$PageTitle</B></FONT>
</center>
<p>
HEADER2HTML
} #end HEADERHTML2 sr


sub UpdateThePermissions {
foreach $row2(@in) {
	($Name, $Value) = split ("=", $row2);
	$Name = &decodeURL($Name);
	$Value = &decodeURL($Value);
	
		$matchAW = $row2 =~ m/AdminWrite/;
		if ($matchAW eq "1")  {
		    ($type, $UserName) = split(/::/, $Name);
			if ($Value eq "true") {
			       $Value = "Write";
				   }  else {
				      $Value = "";
			}
			
			$changeline = ("$UserName|$Value");
			$skippush = "no";
			
			if ($arraylength > 0) {
			$arrayline = 0;
			   foreach $checker(@changes) {
			       ($this, $that) = split(/\|/, $checker);
				   
				   if ($this eq "$UserName") {
				       $skippush = "yes";
				       $changes[$arrayline] = ("$UserName|$that$Value");
					} 
					$arrayline++;
			}  # foreach checker
		} ## if array length greater than 0
		
	if ($skippush eq "no") {
		    push(@changes, $changeline);
			}
          		   
			$arraylength = @changes;
			
}  ## IF match = 1

		$matchAP = $row2 =~ m/AdminPermission/;
		if ($matchAP eq "1")  {
		    ($type, $UserName) = split(/::/, $Name);
			if ($Value eq "true") {
			       $Value = "Admin";
				   }  else {
				      $Value = "";
			}
			
			$changeline = ("$UserName|$Value");
			$skippush = "no";
			
			if ($arraylength > 0) {
			$arrayline = 0;
			   foreach $checker(@changes) {
			       ($this, $that) = split(/\|/, $checker);
				   
				   if ($this eq "$UserName") {
				       $skippush = "yes";
				       $changes[$arrayline] = ("$UserName|$that$Value");
					} 
					$arrayline++;
			}  # foreach checker
		} ## if array length greater than 0
		
	if ($skippush eq "no") {
		    push(@changes, $changeline);
			}
          		   
			$arraylength = @changes;
			
}  ## IF match = 1

	$matchDelete = $row2 =~ m/Delete/;
		if ($matchDelete eq "1")  {
		    ($type, $UserName) = split(/::/, $Name);
			if ($Value eq "yes") {
			       $Value = "Delete";
				   }  else {
				      $Value = "";
			}
			
			$changeline = ("$UserName|$Value");
			$skippush = "no";
			
			if ($arraylength > 0) {
			$arrayline = 0;
			   foreach $checker(@changes) {
			       ($this, $that) = split(/\|/, $checker);
				   
				   if ($this eq "$UserName") {
				       $skippush = "yes";
				       $changes[$arrayline] = ("$UserName|$that$Value");
					} 
					$arrayline++;
			}  # foreach checker
		} ## if array length greater than 0
		
	if ($skippush eq "no") {
		    push(@changes, $changeline);
			}
          		   
			$arraylength = @changes;
			
}  ## IF match = 1
	}  # end foreach row2

##have array of changes now
##open each profile to make changes

foreach $updatename(@changes) {
($thisname, $Permission) = split(/\|/, $updatename);
$thisNameCoded = $thisname;
$thisNameCoded =~ s/ /_/g; #remove spaces

	if ($Permission =~ m/Delete/) {
			unlink("$MembersPath/$thisNameCoded.cgi");
		}  else {
		
		@theprofile = &OpenProfile("$thisname.cgi");    
	
	$Status = "$theprofile[8]";
	
		if ($Permission =~ m/Admin/) {
			$Status = "Administrator";
		} else { 
			open (MODS, "$VariablesPath/mods.file");
				@modslist = <MODS>;
			close (MODS);

			$ModsTotal = @modslist;

			for ($x = 1; $x <= $ModsTotal; $x++) {
				$GetModerator = ("Forum" . "$x" . "Moderator");
				$Moderator = $$GetModerator;
				push(@modsarray, $Moderator);
			}

			CHECKMODS: foreach (@modsarray) {
				if ($_ eq "$thisname") {
					$Status = "Moderator";
					$Modfound = "yes";
					last CHECKMODS;
				}
			}
		if ($Modfound ne "yes") {
			if ($theprofile[7] < $MemberMinimum) {
				$Status = "Junior Member";
				}  else {
					$Status = "Member";
				}
		}
	} # end if/else admin

	open (MEMBERSHIP, ">$MembersPath/$thisNameCoded.cgi") or die(&StandardHTML("Unable to write a new file in Members directory. $!"));

	print MEMBERSHIP ("$thisname|");
	print MEMBERSHIP ("$theprofile[1]|");
	print MEMBERSHIP ("$theprofile[2]|");
	print MEMBERSHIP ("$theprofile[3]|");
	print MEMBERSHIP ("$Permission|");
	print MEMBERSHIP ("$theprofile[5]|");
	print MEMBERSHIP ("$theprofile[6]|");
	print MEMBERSHIP ("$theprofile[7]|");
	print MEMBERSHIP ("$Status|");
	print MEMBERSHIP ("$theprofile[9]|");
	print MEMBERSHIP ("$theprofile[10]|");
	print MEMBERSHIP ("$theprofile[11]|");
	print MEMBERSHIP ("$theprofile[12]\n|");
close (MEMBERSHIP);
}  # END IF match del
}  ## FOREACH

$ConfirmLine = "We have made the changes you requested.";
&ConfirmHTML;

} # End UpdateThePermissions sr

sub RenameMess {

open (FORUMFILE, "$VariablesPath/forums.cgi");
	@sortforums = <FORUMFILE>;
close (FORUMFILE);

for (@sortforums) {

@thisforuminfo = split(/\|/, $_);
chomp($thisforuminfo[8]);
$x = "$thisforuminfo[8]";

opendir (FORUMDIR, "$ForumsPath/Forum$x"); 
    @thesefiles = readdir(FORUMDIR);
closedir (FORUMDIR);

@files = grep(/\.(n|m)/, @thesefiles);
@files = sort(@files);
$oldfiletotal = @files;

foreach $one(@files) {
$Notes = "";

if ($one =~ /^\d\d\d\d\d\d-000000/) {
#it is a father
open (FATHER, "$ForumsPath/Forum$x/$one");
@father = <FATHER>;
close (FATHER);

($threadnum, $junk, $junk2, $replies) = split(/-/, $one);
($replies, $junk3) = split(/\./, $replies);
$TotReplies = substr($replies, 0, 6);
$TotReplies = $TotReplies + 0;

if ($one =~ /X/) {
	$Notes = "X";
	}
if ($one =~ /n/) {
	$Notes .= "N";
	}

chomp($father[0]);
chomp($father[1]);
chomp($father[2]);
$Subject = $father[3];
chomp($Subject);
$email = $father[4];
chomp($email);
chomp($father[5]);

$StatsLine = "A||$Notes||$TotReplies||$father[0]||$Subject";

$NewFatherName = "$threadnum.ubb";
$FatherLine = "Z||000000||$father[0]||$father[1]||$father[2]||$email||$father[5]";

open (RENAMEPOP, ">$ForumsPath/Forum$x/$NewFatherName");
print RENAMEPOP ("$StatsLine\n");
print RENAMEPOP ("$FatherLine\n");
close (RENAMEPOP);


chmod (0666, "$ForumsPath/Forum$x/$NewFatherName");

unlink "$ForumsPath/Forum$x/$one";


}  else {
#add to reply file
open (REPLY, "$ForumsPath/Forum$x/$one");
@reply = <REPLY>;
close (REPLY);

($threadnum, $replynum, $junk, $junk2) = split(/-/, $one);
$NewReplyName = "$threadnum.ubb";

#put reply info on one line
$UName = $reply[0];
chomp($UName);
$Date = $reply[1];
chomp($Date);
$TheTime = $reply[2];
chomp($TheTime);
$Subject = $reply[3];
chomp($Subject);
$Email = $reply[4];
chomp($Email);
$Message = $reply[5];
chomp($Message);
$ReplyLine = ("Z||$replynum||$UName||$Date||$TheTime||$Email||$Message");

open (RENAMEPOP, ">>$ForumsPath/Forum$x/$NewReplyName");
print RENAMEPOP ("$ReplyLine\n");
close (RENAMEPOP);

chmod (0666, "$ForumsPath/Forum$x/$NewReplyName");
unlink "$ForumsPath/Forum$x/$one";
}
}

}  # end for each forum
}  # end Rename Mess sr

sub SetLastThreadNums {

open (FORUMFILE, "$VariablesPath/forums.cgi");
	@sortforums = <FORUMFILE>;
close (FORUMFILE);

for (@sortforums) {

@thisforuminfo = split(/\|/, $_);
chomp($thisforuminfo[8]);
$x = "$thisforuminfo[8]";

opendir (FORUMDIR, "$ForumsPath/Forum$x"); 
    my @files = readdir(FORUMDIR);
closedir (FORUMDIR);

my @ubbfiles = grep(/\.ubb/, @files);
my $topiccount = @ubbfiles;
#sort the ubb files
@ubbfiles = sort(@ubbfiles);
#reverse array so that largest number is first
@ubbfiles = reverse(@ubbfiles);
my $lastnumber = $ubbfiles[0];
($lastnumber, $junk) = split(/\./, $lastnumber);

$ThreadTotal = 0;
#determine number of total posts
foreach $threadfile(@ubbfiles) {
	open(THREAD, "$ForumsPath/Forum$x/$threadfile");
	@countit = <THREAD>;
close(THREAD);

@countit = grep(/^Z/, @countit);
$ThisTotal = @countit;
$ThreadTotal = $ThreadTotal + $ThisTotal;

}

#print number to lastnumber.file
open (UBB, ">$ForumsPath/Forum$x/lastnumber.file");
print UBB ("$lastnumber\n");
print UBB ("$topiccount\n");
print UBB ("$ThreadTotal\n");
close (UBB);

chmod (0666, "$ForumsPath/Forum$x/lastnumber.file");
}  # end for each forum
} #end SetLastThreadNums sr 


sub InputTextRow {
my $RowColor = shift;
my $FieldName = shift;
my $Notes = shift;
my $InputField = shift;
my $Size = shift;
my $MaxSize = shift;
if ($Notes ne "") {
	$Notes = "<BR>$Notes";
}
print<<ROW;
<tr bgcolor="$RowColor">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>$FieldName</B></FONT>
<FONT SIZE="1" FACE="Verdana, Arial"><B>$Notes</B></FONT>
</td>
<td width=50% valign=top>
<INPUT TYPE="TEXT" NAME="$InputField" VALUE="$$InputField" SIZE=$Size MAXLENGTH=$MaxSize>
</td></tr>
ROW
}


sub InputRadioRow {
my $RowColor = shift;
my $FieldName = shift;
my $Notes = shift;
my $RadioStuff = shift;

if ($Notes ne "") {
	$Notes = "<BR>$Notes";
}

print<<ROW;
<TR bgcolor="$RowColor">
<td width=50%>
<FONT SIZE="2" FACE="Verdana, Arial"><B>$FieldName</B></FONT>
<FONT SIZE="1" FACE="Verdana, Arial">$Notes</FONT></td>
<td width=50% valign=top>
<FONT SIZE="2" FACE="Verdana, Arial">
$RadioStuff
</FONT>
</td></tr>
ROW
}
