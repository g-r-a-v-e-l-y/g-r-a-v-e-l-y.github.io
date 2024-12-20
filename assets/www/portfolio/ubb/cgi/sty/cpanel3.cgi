#!/usr/bin/perl

#
###                  FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998-1999.
#
#       ------------ cpanel3.cgi -------------
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
require "UltBB.setup";
require "ubb_library.pl";
require "ubb_library2.pl";
require "Styles.file";
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
	
	if ($Name eq "ViewEntire") {
			$ViewEntire = $Value;
		}
	if ($Name eq "NN") {
			$SearchName = $Value;
			$SearchName =~tr/A-Z/a-z/; 
			}
	if ($Name eq "BBEmail") {
			$BBEmail = $Value;
			$BBEmail =~ s/@/\\@/;
			}
			
	if ($Name eq "Forum1") {
			$Forum1 = $Value;
			$Forum1 =~ s/"/&quot;/g;
		}
	
	if ($Name eq "BBRules") {
			$BBRules = $Value;
			$BBRules =~ s/"/&quot;/g;
			$BBRules =~ s/\@/\\@/g;
			$BBRules = &ConvertReturns($BBRules);
			}
	
	if ($Name eq "ForumStatus1") {
			$ForumStatus1 = $Value;
			}
	
	
	if ($Name eq "MyHomePage") {
			$MyHomePage = $Value;
			}
	
	if ($Name eq "HomePageURL") {
			$HomePageURL = $Value;
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
				if ($Name eq "action") {
			$action = $Value;
			}
			
} #end foreach loop

if ($VariablesPath eq "") {
	$VariablesPath = "$CGIPath";
}

if ($action eq "forums") {
&Forums;
}
if ($action eq "sendforums") {
&SendForums;
}

sub Forums {
# Verify that user is ADMIN first!
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
	   &DoForums;
	   }  else {
	   &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again.  Use your Back button.");
	}
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. Use your Back button.");
}  ##END IF/ELSE NAME CHECK BLOCK
} #end Forums sr

sub DoForums {
# check to see how many forums are currently listed
	open (FORUMFILE, "$VariablesPath/forums.cgi");
			@theforums = <FORUMFILE>;
	close (FORUMFILE);
		
		@forums = grep(/\|/, @theforums);
				
$PageTitle = "Set Forum Variables";
&HEADER2HTML;

if ($UserNameCheck ne "") {
$UserNameFill = "$UserNameCheck";
}  else {
$UserNameFill = "$UserName";
}
$UserNameFill =~ tr/ /+/;

if ($PasswordCheck ne "") {
$PasswordFill = "$PasswordCheck";
}  else {
$PasswordFill = "$Password";
}
$PasswordFill =~ tr/ /+/;


print<<ForumHTML;
<B>
<FONT SIZE="1" FACE="$FontFace">You can easily assign/change forum names, descriptions, and properties through this control panel.  The Freeware Version of the UBB only supports 9 forums.  Note that the <A HREF="http://www.ultimatebb.com" target=_blank>licensed version</A> offers unlimited forums and many more configuration options (including private forums)!</FONT>
<P>
</B>
<FORM ACTION="cpanel3.cgi" METHOD="POST" NAME="THEFORM">
<center>
<table border=0 width=95%>
<TR><TD>
<B><FONT SIZE="3" FACE="$FontFace" COLOR="#800000">Set Forum Variables Below</FONT></B></td><TD align=center><FONT SIZE="2" FACE="$FontFace">[<A HREF="$NonCGIURL/forumterms.html" target=_new>forum variable terms</A>]</FONT></td></TR></table>
<P>
<table border=0 cellpadding=0 cellspacing=0 width="95%"><TR><td bgcolor="$TextColor">

<table border=0 cellpadding=4 border=0 cellspacing=1 width=100%>
ForumHTML

	$ForumCounter = 0;
	
	for $forumline(@forums) {
	$ForumCounter++;
	my $ForumActive = "";
	my $ForumInactive = "";
	my $HTMLOn = "";
	my $HTMLOff = "";
	my $UBBOn = "";
	my $UBBOff = "";
	my $UBBImagesOn = "";
	my $UBBImagesOff = "";


		@thisforum = split(/\|/, $forumline);
		chomp($thisforum[11]);
		chomp($thisforum[12]);
		if ($thisforum[3] eq "On") {
			$ForumActive = "CHECKED";
		}  else {
			$ForumInactive = "CHECKED";
		}
		if ($thisforum[4] eq "is") {
			$HTMLOn = "CHECKED";
		}  else {
			$HTMLOff = "CHECKED";
		}
		if ($thisforum[5] eq "is") {
			$UBBOn = "CHECKED";
		}  else {
			$UBBOff = "CHECKED";
		}
if ($thisforum[10] eq "OFF") {
			$UBBImagesOff = "CHECKED";
		}  else {
			$UBBImagesOn = "CHECKED";
		}


### If UBB Code is off, UBB Code for Images must also be off! ###
	if ($UBBOff eq "CHECKED") {
			$UBBImagesOn = "";
			$UBBImagesOff = "CHECKED";
		}
####

 
print<<ForumGuts;
<tr bgcolor="#B0BB9D">
<td colspan=2 valign=top>
<FONT SIZE="2" FACE="$FontFace">
<B>Forum $ForumCounter</B>
<TR bgcolor="#C7C6BA">
<TD><FONT SIZE="1" FACE="$FontFace"><B>Name:</B></FONT></td>
<td><INPUT TYPE="TEXT" NAME="Name||$ForumCounter" VALUE="$thisforum[1]" SIZE=30 MAXLENGTH=100></td></tr>

<TR bgcolor="#C7C6BA"><TD><FONT SIZE="1" FACE="$FontFace"><B>Status:</B></FONT></td>
<td><FONT SIZE="1" FACE="$FontFace"><B><INPUT TYPE="RADIO" NAME="Status||$ForumCounter" VALUE="On" $ForumActive> On &nbsp;&nbsp;&nbsp;&nbsp;
<INPUT TYPE="RADIO" NAME="Status||$ForumCounter" VALUE="Off" $ForumInactive> Off</B></FONT></td></tr>

<TR bgcolor="#C7C6BA"><TD><FONT SIZE="1" FACE="$FontFace"><B>HTML Allowed?</B></FONT></td><TD><FONT SIZE="1" FACE="$FontFace"><B><INPUT TYPE="RADIO" NAME="HTML||$ForumCounter" VALUE="is" $HTMLOn> Yes &nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="RADIO" NAME="HTML||$ForumCounter" VALUE="is not" $HTMLOff> No</B></FONT></td></tr>

<TR bgcolor="#C7C6BA"><TD><FONT SIZE="1" FACE="$FontFace"><B>UBB Code Allowed?</B></FONT></td><TD><FONT SIZE="1" FACE="$FontFace"><B><INPUT TYPE="RADIO" NAME="UBB||$ForumCounter" VALUE="is" $UBBOn> Yes &nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="RADIO" NAME="UBB||$ForumCounter" VALUE="is not" $UBBOff> No</B></FONT></td></tr>

<TR bgcolor="#C7C6BA" ><TD><FONT SIZE="1" FACE="$FontFace"><B>UBB Code Images Allowed?</B></FONT></td><TD><FONT SIZE="1" FACE="$FontFace"><B><INPUT TYPE="RADIO" NAME="UBBImages||$ForumCounter" VALUE="ON" $UBBImagesOn> Yes &nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="RADIO" NAME="UBBImages||$ForumCounter" VALUE="OFF" $UBBImagesOff> No</B></FONT></td></tr>
<TR bgcolor="#C7C6BA"><TD><FONT SIZE="1" FACE="$FontFace"><B>Description:</B></FONT></td><td><TEXTAREA NAME="Description||$ForumCounter" ROWS=3 COLS=30 wrap="VIRTUAL">$thisforum[2]</TEXTAREA></td></tr>
ForumGuts
} #for forumline

print<<BottomForumHTML;
</table>
</td></tr></table>
<BR>
<INPUT TYPE="HIDDEN" NAME="action" VALUE="sendforums">
<P>
<HR>
<CENTER><FONT Size="2" FACE="$FontFace" COLOR="$LinkColor"><B>Enter Your UserName & Password:</font>
<P>
<FONT Size="1" FACE="$FontFace" COLOR="#808000">(NOTE: if you are configuring your BB for the first time, type your default UserName and Password here)</font>
<p>
<FONT Size="2" FACE="$FontFace" COLOR="$LinkColor">
UserName: <INPUT TYPE="TEXT" NAME="UserNameCheck" SIZE=25 MAXLENGTH=25>&nbsp;&nbsp;&nbsp;&nbsp; Password <INPUT TYPE="PASSWORD" NAME="PasswordCheck" SIZE=13 MAXLENGTH=13></FONT></B>
<p><INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit Forum Variables Now"></form>
<P>
<FONT SIZE="1" FACE="$FontFace" COLOR="$TextColor"><A HREF="http://www.ultimatebb.com">Ultimate Bulletin Board</A>, &copy; Infopop Corporation, 1998 - 2000.</FONT>
</CENTER></font>
</BODY>
</HTML>
BottomForumHTML
}  ## END DoForums


sub HEADER2HTML {
print<<HEADER2HTML;
<HTML>
<HEAD>
	<TITLE>$BBName</TITLE>
</HEAD>
<BODY bgcolor="$BGColor" link="$LinkColor" vlink="#808000">
<BR><center>
<FONT SIZE="5" FACE="Courier New"><B>$PageTitle</B></FONT>
</center>
<p>
HEADER2HTML
} #end HEADERHTML2 sr


sub SendForums {
### CHECK USERNAME - must be an admin
##verify that this user is an administrator
$NameFound = "no";
if (-e "$MembersPath/$UserNameCheckFile.cgi") {
      $NameFound = "yes";
	} 

if ($NameFound eq "yes") {
	@profilestats = &OpenProfile("$UserNameCheck.cgi");
			
	if ($PasswordCheck eq "$profilestats[1]") {
	$Permission = "$profilestats[4]";
	&CheckPermissions;
	   if ($AdminPermission eq "true") {
	   &DoProcessForums;
	   }  else {
	    &StandardHTML("Sorry, but you are not an administrator.");
	   }
	} else {
	&StandardHTML("Sorry, but the password you entered was not correct.  Please try again. Use your Back button.");
	}
}  else {
&StandardHTML("Sorry, but we couldn't find a record for the UserName you entered.  Please try again. Use your Back button.");
}  ##END IF/ELSE NAME CHECK BLOCK

}  ##END SendForums sr


sub DoProcessForums {
### write forum info to forums.cgi
foreach $row(@in) {
	($Name, $Value) = split ("=", $row);
	$Name = &decodeURL($Name);
	$Value = &decodeURL($Value);
	
	if ($Name =~ m/Name/) {
	($Trash, $ForumNumber) = split(/\|\|/, $Name);
	push (@AdjustForums, $ForumNumber);
	}
} # end foreach $row

#read current forum data
open (FORUMFILE, "$VariablesPath/forums.cgi");
	@forums = <FORUMFILE>;
close (FORUMFILE);

@forums = grep(/\|/, @forums);

#assemble new line for each revised forum
for $num(@AdjustForums) {

	$Found = "false";
	
foreach $row2(@in) {
	($Name, $Value) = split ("=", $row2);
	$Name = &decodeURL($Name);
	$Value = &decodeURL($Value);
	
	if ($Name eq "Name||$num") {
		$ThisName = $Value;
		$ThisName =~ s/"/&quot;/g;
		$Found = "true";
	}
	if ($Name eq "Status||$num") {
		$ThisStatus = $Value;
	}
	if ($Name eq "HTML||$num") {
		$ThisHTML = $Value;
	}
	if ($Name eq "UBB||$num") {
		$ThisUBB = $Value;
	}
if ($Name eq "UBBImages||$num") {
		$ThisUBBImages = $Value;
	}
	if ($Name eq "Description||$num") {
		$ThisDescription = $Value;
		$ThisDescription =~ s/"/&quot;/g;
		$ThisDescription =~ s/\n\r\n//g;
		$ThisDescription =~ s/\n//g;
		$ThisDescription =~ s/\r//g;
		$ThisDescription =~ s/  / /g;
	}
} # end foreach $row2

$arrayrow = ($num - 1);

if ($Found eq "true") {
$forums[$arrayrow] = ("|$ThisName|$ThisDescription|$ThisStatus|$ThisHTML|$ThisUBB|no||$num||$ThisUBBImages|no\n");
}
}  #end for each @AdjustForum

#write to forums file

open (FORUMS, ">$VariablesPath/forums.cgi") or die(&StandardHTML("Unable to open forums.cgi file for writing. $!")); 
print FORUMS (@forums);
close (FORUMS);

$UserNameCoded = "$UserNameCheck";
$UserNameCoded =~ tr/ /+/;
$PasswordCoded = "$PasswordCheck";
$PasswordCoded =~ tr/ /+/;

$ConfirmLine = qq(The Ultimate Bulletin Board forums have been updated.<P>Note that in order to have these changes reflected in old threads, you need to update those threads.  You can do this using the "Update Threads" control panel option.  Depending on the number of threads you have stored on your system, the updating process can be time-consuming.  It is thus recommended that you do not update your threads until after you have made all control panel setting changes.<P>);
&ConfirmHTML;
} ## END DO PROCESS FORUMS SR

