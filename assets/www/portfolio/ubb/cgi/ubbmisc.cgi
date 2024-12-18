#!/usr/bin/perl

#
###                   FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998-2000.
#
#       ------------ ubbmisc.cgi -------------
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
require "ubb_library2.pl";
require "Styles.file";

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
			$topic =~ s/<.+?>//g;
	}

	if ($Name eq "Email") {
			$Email = $Value;
			$Email =~tr/A-Z/a-z/; 
			$Email =~ s/<.+?>//g;
	}
	if ($Name eq "URL") {
			$URL = &CleanThis($Value);
			$URL = &PipeCleaner($URL);
			$URL =~ s/<.+?>//g;
	}
	if ($Name eq "Permissions") {
			$Permissions = $Value;
	}
	if ($Name eq "Occupation") {
			$Occupation = &CleanThis($Value);
			$Occupation = &PipeCleaner($Occupation);
			$Occupation =~ s/<.+?>//g;
	}
	if ($Name eq "Location") {
			$Location = &CleanThis($Value);
			$Location = &PipeCleaner($Location);
			$Location =~ s/<.+?>//g;
	}
	if ($Name eq "TotalPosts") {
		$TotalPosts = $Value;
	}
	if ($Name eq "Status") {
		$Status = $Value;
		$Status =~ s/<.+?>//g;
	}
	if ($Name eq "Interests") {
			$Interests = &CleanThis($Value);
			$Interests = &PipeCleaner($Value);
			$Interests =~ s/<.+?>//g;
	}
		if ($Name eq "sendto") {
			$sendto = $Value;
	}
}  # end FOREACH $row

if ($VariablesPath eq "") {
	$VariablesPath = $CGIPath;
}
$ReplyMessage = $in{'ReplyMessage'};
$Message = $in{'Message'};

		$SubjectCoded = &HTMLIFY($TopicSubject);
		$SubjectCoded =~ tr/ /+/;


  
if ($in{'action'} eq "getbio") {
 &GetBio;
 } 
 
if ($in{'action'} eq "editbio") {
 &EditBio;
 } 


if ($in{'action'} eq "checkbioid") {
&CheckBioID;
 } 
 
if ($in{'action'} eq "modifybio") {
   &ModifyBio;
 }
  
  if ($in{'action'} eq "RegSubmit") {
 &RegSubmit;
 }
 
sub GetBio {
@thisprofile = &OpenProfile("$UserName.cgi");
$EmailView = $thisprofile[11];
$Signature = $thisprofile[12];
chomp($Signature);

if (($EmailBlock eq "ON") || ($EmailView eq "no")) {
$EmailField = "Not available.";
}  else {
$EmailField = "<A HREF=\"mailto:$thisprofile[2]\">$thisprofile[2]</A>";
}
&ViewBioHTML;
}  ## END GET BIO sr

sub CheckBioID {
if (($in{'UserName'} eq "") || ($in{'Password'} eq "")) {
&StandardHTML("You did not complete all required form fields!  Please go back and re-enter.");
} else {

$NameFound = "no";
if (-e "$MembersPath/$UserNameFile.cgi") {
      $NameFound = "yes";
	} 

	if ($NameFound eq "yes") {
		#Check Password Now
		
	@thisprofile = &OpenProfile("$UserName.cgi");
	
         if ($in{'Password'} eq "$thisprofile[1]") {
		     	$pwmatch = "true";
			$Password = $thisprofile[1];
			$Email = $thisprofile[2];
			$URL = $thisprofile[3];
			$Occupation = $thisprofile[5];
			$Location = $thisprofile[6];
			$Interests = $thisprofile[9];
			$Status = $thisprofile[8];
			$TotalPosts = $thisprofile[7];
			$Permissions = $thisprofile[4];
			$DateRegistered = $thisprofile[10];
			$EmailView = $thisprofile[11];

            &ProcessEdit;
         }
    } ## END IF MEMBER = Username.cgi condition

if ($NameFound ne "yes") {
   &StandardHTML("We have no one registered with that user name.  Use your back button to try again.");
}
if (($NameFound eq "yes") && ($pwmatch ne "true")) {
   	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again. Use your Back button.");
}
} # end check for missing fields
}  ## END CheckBioID SR ###




## HTML CODE ####
  
sub EditBio {
print<<EDITbioHTML;
<HTML>
<HEAD><TITLE>$BBName - Edit Profile</TITLE>
</HEAD>
 <BODY bgcolor="$BGColor"   text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<FONT SIZE="3" FACE="$FontFace" COLOR="$TextColor">

</font>
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle" BORDER=0></A>
<FONT SIZE="3" FACE="$FontFace" COLOR="$LinkColor"><B>Modify Your Profile</B></FONT>
<p>
<FONT SIZE="2" FACE="$FontFace">
It is your responsibility to keep your profile information up-to-date.  Do not ask the administrator or moderators to do this for you.
<p>
To modify your current profile information, please identify yourself below.

<p>
<FORM ACTION="ubbmisc.cgi" METHOD="POST" NAME="EditProfile">
<table border=0>
<tr>
<td>
<FONT SIZE="2" FACE="$FontFace"><B>UserName</B></FONT>
</td>
<td>
<INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td></tr>
<tr>
<td>
<B><FONT SIZE="2" FACE="$FontFace">Password</FONT></B>
</td>
<td>
<INPUT TYPE="PASSWORD" NAME="Password" SIZE=13 MAXLENGTH=13>
</td></tr>
</table>
<center>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="checkbioid">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Identification">
<INPUT TYPE="RESET" NAME="Reset" VALUE="Clear Fields">
</center>

</form>


<P>
<center>

</center>
</FONT>
</BODY></HTML>
EDITbioHTML

}  ##END EDIT BIO SR

sub BioModifyConfirmHTML {
print<<HTML;
<HTML>
<HEAD><TITLE>
Member Profile Modification Confirmation</title>
</head>
 <BODY bgcolor="$BGColor"  text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor"><BR><BR>
<p><FONT SIZE="2" FACE="$FontFace"><B>
Thank you, $UserName.  Your profile has been successfully updated.
<P>
$ModifyWarning
<P>
<table border=0>
<TR>
<TD valign=top>
<FONT SIZE="2" FACE="$FontFace"><B>Return to:</B></FONT></td>
<td valign=top><FONT SIZE="2" FACE="$FontFace"><B>
<A HREF="Ultimate.cgi?action=intro&BypassCookie=true">Forums Summary Page</A>
<BR><A HREF="$CGIURL/ubbmisc.cgi?action=editbio">
Edit Your Profile</a>
<BR>
<A HREF="$NonCGIURL/faq.html" target=_blank>Help/FAQ</A>

</B></FONT>

</td></tr></table>
</B>
</FONT>
</body>
</html>
HTML
}  ## END Bio Modify Confirmation sr



sub ViewBioHTML {

if ($thisprofile[10] eq "") {
$DateRegistered = "Not available.";
}  else {
$DateRegistered = "$thisprofile[10]";
}

print <<BioHTML;
<HTML>
 <BODY bgcolor="$BGColor"   text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="#800080">
<FONT SIZE="2" FACE="$FontFace"><B>Profile for $thisprofile[0]</B></FONT>
<HR>
<BLOCKQUOTE>
<table border=0>
<tr><td>
<FONT SIZE="2" FACE="$FontFace"><B>Date Registered:</B></FONT></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$DateRegistered</FONT>
</td></tr>
<tr><td>
<FONT SIZE="2" FACE="$FontFace"><B>Status:</B></FONT></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$thisprofile[8]</FONT>
</td></tr>
<tr><td>
<FONT SIZE="2" FACE="$FontFace"><B>Total Posts:</B></FONT></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$thisprofile[7]</FONT>
</td></tr>
<tr><td>
<FONT SIZE="2" FACE="$FontFace"><B>Current Email:</B></FONT></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$EmailField</FONT>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="$FontFace"><B>Homepage:</B></font></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor"><A HREF="$thisprofile[3]" target=_top>$thisprofile[3]</A></font>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="$FontFace"><B>Occupation:</B></font></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$thisprofile[5]</font>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="$FontFace"><B>Location:</B></font></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$thisprofile[6]</font>
</td></tr>
<TR>
<td><FONT SIZE="2" FACE="$FontFace"><B>Interests:</B></font></td>
<td><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$thisprofile[9]</font>
</td></tr>
</table>
</BLOCKQUOTE>
<HR>
</BODY></HTML>
BioHTML
}  ## END View BIO HTML sr

sub ProcessEdit {

if ($EmailView eq "no") {
	$EVno = "CHECKED";
} else {
	$EVyes = "CHECKED";
}



print<<EditHTML;
<HTML><HEAD></HEAD>
 <BODY bgcolor="$BGColor" text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="#800080">
<FONT SIZE="3" FACE="$FontFace" COLOR="$TextColor">
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle" BORDER=0></A>
<FONT SIZE="3" FACE="$FontFace" COLOR="$LinkColor"><B>Modify Your Profile</B></FONT>
<p><FONT SIZE="2" FACE="$FontFace">
Thank you! We have confirmed your identity, $UserName ($Status).
<p>
Feel free to modify any of the fields below.
<P>
</FONT>
<FORM ACTION="ubbmisc.cgi" METHOD="POST">
<table border=0>
<tr>
<td>
<FONT SIZE="2" FACE="$FontFace"><B>Email Address</B></FONT>
</td>
<td>
<INPUT TYPE="TEXT" NAME="Email" VALUE="$Email" SIZE=30 MAXLENGTH=155>
</td></tr>
<tr>
<td>
<FONT SIZE="2" FACE="$FontFace"><B>Password</B></FONT>
</td>
<td>
<INPUT TYPE="TEXT" NAME="NewPassword" VALUE="$Password" SIZE=30 MAXLENGTH=155>
</td></tr>
<tr>
<td>
<B><FONT SIZE="2" FACE="$FontFace">Homepage</FONT></B>
</td>
<td>
<INPUT TYPE="TEXT" NAME="URL" VALUE="$URL" SIZE=30 MAXLENGTH=200>
</td></tr>
<tr>
<td>
<B><FONT SIZE="2" FACE="$FontFace">Occupation</FONT></B>
</td>
<td>
<INPUT TYPE="TEXT" NAME="Occupation" VALUE="$Occupation" SIZE=30 MAXLENGTH=100>
</td></tr>
<tr>
<td>
<B><FONT SIZE="2" FACE="$FontFace">City, State, Country</FONT></B>
</td>
<td>
<INPUT TYPE="TEXT" NAME="Location" VALUE="$Location" SIZE=30 MAXLENGTH=150>
</td></tr>
<tr>
<td>
<B><FONT SIZE="2" FACE="$FontFace">Interests</FONT></B>
</td>
<td>
<INPUT TYPE="TEXT" NAME="Interests" VALUE="$Interests" SIZE=50 MAXLENGTH=200>
</td></tr>

<tr>
<TD valign=top><FONT SIZE="2" FACE="$FontFace"><B>Keep your email address viewable to other users when you post notes?</B></FONT></TD>
<TD valign=top><CENTER><FONT SIZE="2" FACE="$FontFace"><INPUT TYPE="RADIO" NAME="EmailView" VALUE="yes" $EVyes>
 yes <INPUT TYPE="RADIO" NAME="EmailView" VALUE="no" $EVno> no</font>
</CENTER> </TD>
</TR>
</table>
<center>
<P>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="modifybio">
<INPUT TYPE="HIDDEN" NAME="UserName" VALUE="$UserName">
<INPUT TYPE="HIDDEN" NAME="Password" VALUE="$in{'Password'}">
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Modifications">
<INPUT TYPE="RESET" NAME="Reset" VALUE="Clear Fields"><center>

</center>
</form></font>
</BODY></HTML>
EditHTML
}  ##END Process Edit SR


sub RegSubmit {

if (($UseEmail eq "ON") && ($EmailVerify eq "ON")) {

	if ( ($in{'UserName'} eq "") || ($in{'Email'} eq "") || ($in{'Email'} !~ /\@/) )  {
		&StandardHTML("You did not properly complete all required form fields!  Remember that you must enter a valid email address.  Please go back and re-enter.");
		} else {
		&GoAhead;
	}

} else {

	if ( ($in{'UserName'} eq "") || ($in{'Email'} !~ /\@/) || 	($in{'Password'} eq "") || ($PasswordConfirm eq "") )  {
		&StandardHTML("You did not properly complete all required form fields!  Remember that you must enter a valid email address.  Please go back and re-enter.");
	}  else {
	
		if ($in{'Password'} eq "$PasswordConfirm") {
			&GoAhead; 
			}  else {
			&StandardHTML("Registration Failed!<P>You failed to type the same password twice on the registration form.  Please go back and try again.<P>Use your back button to try again.");
		}
	}
}
}  ## END RegSubmit SR ##


sub GoAhead  {	
#check for illegal (non alphanumeric characters)
$_ = "$UserNameFile";
if ((m/\W+/) || (m/\b[_]/) || (m/[_]\b/) || (m/_{2,}/)) {
&StandardHTML("The User Name you attempted to register is illegal for one of the following reasons:<P><blockquote>1.  You may have included an illegal character in your User Name.  You should only use letters, numbers, or spaces (apostrophes, for example, are not permitted). You may not begin or end a User Name with a space.  You may not have two or more consecutive spaces.<p>2.  You may have attempted to use a name that doesn't include any letters or numbers.</B></blockquote><p><CENTER>Use your back button to try again.</center>");
}  else {
#check to make sure Username is unique

&GetMemberListArray;

$LCUNFile = "$UserNameFile"; #Get ready to lower case it
	$LCUNFile =~ tr/A-Z/a-z/; #convert to lc for check
$duplicate = "no";


CHECKDUPES: for $checkthis(@members) {
	$checkthisLC = "$checkthis";
	$checkthisLC =~ tr/A-Z/a-z/; #convert to lc for check
	if ($checkthisLC eq "$LCUNFile.cgi") {
		$duplicate = "yes";
		&StandardHTML("Someone else has already registered that UserName.  Please try again.  Use your back button.");
		last CHECKDUPES;
	}

#CHECK to make sure email isn't a duplicate too

if (($duplicate ne "yes") && ($EmailCheck eq "true")) {

open (MEM, "$MembersPath/$checkthis") or die(&StandardHTML("Unable to read in Members directory. $!"));
@checkemail = <MEM>;
close (MEM);

	@profile = split (/\|/, $checkemail[0]);
	
	if ($Email eq "$profile[2]") {
		$duplicate = "yes";
		&StandardHTML("Someone else has already registered that email address.  Please try again.  Use your back button.");
	}
}  #END if duplicate ne yes
}  # end checkdupes loop

if ($duplicate ne "yes") {

my $Password = "$in{'Password'}";

$Password= &CleanThis($Password);

if ($Password =~ /(\W+)|\|/ ) {
	&StandardHTML("The password you have attempted to register is illegal for one of the following reasons:<P><blockquote>1.  You may have included an illegal character in your password.  You should only use letters, numbers, or spaces (apostrophes, for example, are not permitted). You may not begin or end a password with a space.  You may not have two or more consecutive spaces.<p>2.  You may have attempted to use a word that doesn't include any letters or numbers.</B></blockquote><p><CENTER>Use your back button to try again.</center>");
	exit;
}

# Get Today's Date so we can log the date of registration

&GetDateTime;

@filter_these = ("Occupation","Location","URL","Interests","Email"); # rem HTM and unclosed tags
	foreach(@filter_these){
		$$_ =~ s/<.+?>//g;
		$$_ =~ s/</&lt;/g;
	}


## APPEND NEW REGISTRATION TO REG FILE
&Lock ("lock.file");
open (MEMBERSHIP, ">$MembersPath/$UserNameFile.cgi") or die(&StandardHTML("Unable to write a new Members file. $!"));
	print MEMBERSHIP ("$UserName|");
	print MEMBERSHIP ("$Password|");
	print MEMBERSHIP ("$Email|");
	print MEMBERSHIP ("$URL|");
	print MEMBERSHIP ("Write|");
	print MEMBERSHIP ("$Occupation|");
	print MEMBERSHIP ("$Location|");
	print MEMBERSHIP ("0|");
	print MEMBERSHIP ("Junior Member|");
	print MEMBERSHIP ("$Interests|");
	print MEMBERSHIP ("$HyphenDate|");
	print MEMBERSHIP ("$in{'EmailView'}|");
	print MEMBERSHIP (" \n");
close (MEMBERSHIP);
&Unlock ("lock.file");

$RegWording1 = "You have successfully registered your User Name and Password for $BBName. ";
$RegWording2 = "$in{'Password'}";

&PrintRegistrationHTML;

} ### end if dupe ne yes
} # end if/else /m
}  # end GoAhead subroutine

sub PrintRegistrationHTML {
print <<HTML;
<HTML>
<HEAD><TITLE>
User Registration Confirmation</title></head>
 <BODY bgcolor="$BGColor"   text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="#800080">
<FONT SIZE="2" FACE="$FontFace" color="$TextColor">

<table border=0>
<tr><td colspan=2>
<FONT SIZE="2" FACE="$FontFace"><B>Congratulations!
<P>
$RegWording1  Feel free to post messages on any of our forums.  Your registration information is listed below.</B></FONT>
</td></tr>
<tr>
<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>User Name</B></FONT></TD>
<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$UserName</font>
 </TD>
</tr>

<TR>
	<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Password</B></FONT></TD>
	<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$RegWording2</font>
 </TD>
</tr>
<TR>
	<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Email</B></FONT></TD>
	<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$Email</font>
 </TD>
</TR>
<TR>
	<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>City, State, Country</B></FONT></TD>
	<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$Location</font>
 </TD>
</TR>
<TR>
	<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Occupation</B></FONT></TD>
	<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$Occupation</font>
 </TD>
</tr>
<TR>
	<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Interests</B></FONT></TD>
	<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$Interests</font>
 </TD>
</tr>
<TR>
	<TD bgcolor="$AltColumnColor1"><FONT SIZE="2" FACE="$FontFace"><B>Homepage</B></FONT></TD>
	<TD bgcolor="$AltColumnColor2"><FONT SIZE="2" FACE="$FontFace" COLOR="$LinkColor">$URL</font>
 </TD>
</tr>

</TABLE>
<p><FONT SIZE="2" FACE="$FontFace">
<A HREF="$CGIURL/Ultimate.cgi?action=intro">Click here to enter the Bulletin Board now!</A><br><br>
</FONT>
<br><br><br>
</font></body></html>
HTML
} ## END Print Registration sr



sub ModifyBio {
if (($Email eq "") || ($in{'NewPassword'} eq "") || ($Email !~ /\@/)) {
&StandardHTML("You did not complete all required form fields!  Please go back and re-enter.");
 }  else {
 
## Confirm UserName and Password to prevent hacking

&OpenProfile("$UserName.cgi");  #returns @profileinfo
$CurrentEmail = "$profileinfo[2]";
$Permissions = "$profileinfo[4]";
$TotalPosts = "$profileinfo[7]";
$Status = "$profileinfo[8]";
$DateRegistered = "$profileinfo[10]";
chomp($DateRegistered);

if ($profileinfo[1] eq "$in{'Password'}") {

## check for duplicate email addresses, if applicable

if ($EmailCheck eq "true") {
&GetMemberListArray;
$duplicate = "";

CHECKEMAIL: for $checkemails(@members) {

open (MEM, "$MembersPath/$checkemails") or die(&StandardHTML("Unable to read in Members directory $!"));
@checkemail = <MEM>;
close (MEM);

	@profileEM = split (/\|/, $checkemail[0]);
	
	if (($Email eq "$profileEM[2]") && ($UserName ne "$profileEM[0]")) {
		$duplicate = "yes";
		last CHECKEMAIL;
	}
} # end for $checkemails
}  #END if Email check eq TRUE

if ($duplicate eq "yes") { 
	&StandardHTML("You cannot use the email address you tried to use.  Another registered user is already using it.");
} else {

$Password = "$in{'NewPassword'}";

$Password= &CleanThis($Password);

if ($Password =~ /(\W+)|\|/ ) {
	&StandardHTML("The password you have attempted to register is illegal for one of the following reasons:<P><blockquote>1.  You may have included an illegal character in your password.  You should only use letters, numbers, or spaces (apostrophes, for example, are not permitted). You may not begin or end a password with a space.  You may not have two or more consecutive spaces.<p>2.  You may have attempted to use a word that doesn't include any letters or numbers.</B></blockquote><p><CENTER>Use your back button to try again.</center>");
	exit;
}


$ModifyWarning = "";


@filter_these = ("Occupation","Location","URL","Interests","Email"); # rem HTM and unclosed tags
	foreach(@filter_these){
		$$_ =~ s/<.+?>//g;
		$$_ =~ s/</&lt;/g;
	}


&Lock("lock.file");
##print profile fields to file
open (MEMBERSHIP, ">$MembersPath/$UserNameFile.cgi") || die(&StandardHTML("Unable to write a Members file. $!"));

	print MEMBERSHIP ("$UserName|");
	print MEMBERSHIP ("$Password|");
	print MEMBERSHIP ("$Email|");
	print MEMBERSHIP ("$URL|");
	print MEMBERSHIP ("$Permissions|");
	print MEMBERSHIP ("$Occupation|");
	print MEMBERSHIP ("$Location|");
	print MEMBERSHIP ("$TotalPosts|");
	print MEMBERSHIP ("$Status|");
	print MEMBERSHIP ("$Interests|");
	print MEMBERSHIP ("$DateRegistered|");
	print MEMBERSHIP ("$in{'EmailView'}|");
	print MEMBERSHIP (" \n");
close (MEMBERSHIP);
&Unlock("lock.file");
#confirm processing to user, provide links to other places

&BioModifyConfirmHTML;
}

}  else  {
&StandardHTML("Sorry, but you seem to be trying to hack into someone else's profile.  You can not edit someone's profile without knowing their password.");
}

} # end if/else complete fields
}  ## END Modify Bio SR
