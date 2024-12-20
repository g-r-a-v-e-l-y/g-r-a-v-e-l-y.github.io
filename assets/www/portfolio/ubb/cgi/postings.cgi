#!/usr/bin/perl

#
###                   FREEWARE UBB SCRIPT                ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation, 1998-1999.
#
#       ------------ postings.cgi -------------
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

	if ($Name eq "category") {
			$category = $Value;
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
	
if ($in{'action'} eq "reply") {
 &Reply;
 }  

if ($in{'action'} eq "postreply") {
 &PostReply;
 }  
 
if ($in{'action'} eq "newtopic") {
 &NewTopic;
 }  
 
if ($in{'action'} eq "posttopic") {
 &PostTopic;
 }  

  
sub Reply {
#open thread message
@threadguts = &OpenThread("$topic");
$statline = $threadguts[0];
@stats = split(/\|\|/, $statline);

# if thread is closed, say so
if ($stats[1] =~ /X/) {
&StandardHTML("Sorry, but this thread is closed.  No additional replies are permitted on this topic.  You are free to start a new topic, however.<P>Use your back button to return.");
}  else {

@thisforum = &GetForumRecord($number);

#chomp the last field to remove carriage returns
$UBBImages = "$thisforum[10]";

&CheckCoding;

&ReplyFormHTML;
&GenerateThread;
&ReplyFormBottom;

} #end if/else thread is closed
}  ## END Reply SR #####


sub PostReply {
#verify that forum fields are complete

if (($in{'UserName'} eq "") || ($in{'Password'} eq "") || ($in{'ReplyMessage'} eq "")) {
	&StandardHTML("You did not complete all required form fields! Please go back and re-enter.");
	}  else {

@thisforum = &GetForumRecord($number);

$UBBCodeAllow = $thisforum[5];
$HTMLAllow = $thisforum[4];
$UBBImages = $thisforum[10];
$ForumStatus = $thisforum[3];

	$NameFound = "no";
	if (-e "$MembersPath/$UserNameFile.cgi") {
      $NameFound = "yes";
	} 

if ($NameFound ne "yes") {
	&StandardHTML("Sorry, but we have no record of the UserName you entered.  Please try again. Use your Back button.");
}  else {
	#open User's profile
	@theprofile = &OpenProfile("$UserName.cgi");
			#check password
			if ($in{'Password'} eq "$theprofile[1]") {
				&DoPostTheReply;

				}  else {
					&StandardHTML("Sorry, but the password you entered was not correct. Please try again. Use your Back button.");
				}
	} #end if username found block
} # end if/else missing fields

}  ## END Post Reply SR

sub DoPostTheReply {

##get current date/time
&GetDateTime;
				$Email = &PipeCleaner("$theprofile[2]");
				$UserName = &PipeCleaner("$theprofile[0]");
				$TotalPosts = "$theprofile[7]";
				$Permission = "$theprofile[4]";
				$Password = &PipeCleaner("$theprofile[1]");
				$URL = &PipeCleaner("$theprofile[3]"); 
				$Occupation = &PipeCleaner("$theprofile[5]");
				$Location = &PipeCleaner("$theprofile[6]");
				$Status = &PipeCleaner("$theprofile[8]");
				$Interests = &PipeCleaner("$theprofile[9]");
				$DateRegistered = &PipeCleaner("$theprofile[10]");
				$EmailView = "$theprofile[11]";

&CheckPermissions;

   if ($PermissionToWrite eq "true") {

##create filenumber for reply 
@replier = &OpenThread("$topic");
@revreplier = reverse(@replier);

$statline = $replier[0];
$fatherline = $replier[1];
@papa = split(/\|\|/, $fatherline);
@stats = split(/\|\|/, $statline);

$replytotal = $stats[2];
$replytotal++;               #add one to reply total

$lastpost = $revreplier[0];
@lastpost = split(/\|\|/, $lastpost);

$lastnumber = $lastpost[1];
$lastnumber++;  #add 1 to last post number
$newreplynum = sprintf("%6d", $lastnumber);
$newreplynum =~tr/ /0/;

#now we have to add the new message to the thread file

## IF HTML is not allowed, render HTML useless
if ($HTMLAllow eq "is not") {
		$ReplyMessage =~ s/</&lt;/g;
		$ReplyMessage =~ s/>/&gt;/g;
 }
 

$ReplyMessage2 = "$ReplyMessage";

#convert newlines/carriage returns to HTML
$ReplyMessage = &ConvertReturns("$ReplyMessage");

#UBB Code-ify (if allowed)
if ($UBBCodeAllow eq "is") {
$ReplyMessage = &UBBCode("$ReplyMessage");
} #END UBB CODE 


($ThreadNo, $junk) = split(/\./, $topic);

## if email should not be displayed, don't
if (($EmailBlock eq "ON") || ($EmailView eq "no")) {
$PostEmail = "";
}  else {
$PostEmail = "$Email";
}

$ReplyLine = ("Z||$newreplynum||$UserName||$HyphenDate||$Time||$PostEmail||$ReplyMessage");

push(@replier, $ReplyLine);

foreach $line(@replier) {
chomp($line);
if ($line =~ /^A/) {
	chomp($stats[4]);
	$newstats = "A||$stats[1]||$replytotal||$stats[3]||$stats[4]";
	push(@updated, $newstats);
} else {
	push(@updated, $line);
}
}

#check to make sure files are writeable!!

unless (-w "$MembersPath/$UserNameFile.cgi") {
chmod (0777, "$MembersPath/$UserNameFile.cgi");
}
unless (-w "$ForumsPath/Forum$number/$topic")  {
chmod (0777, "$ForumsPath/Forum$number/$topic");
}

if (-w "$ForumsPath/Forum$number/$topic")  {
#if topic file is writeable---

&Forward("$NonCGIURL/Forum$number/HTML/$ThreadNo.html", "Thanks for posting your message, $UserName!  We are now sending you back automatically to the thread list for this topic.");

&Lock("lock.file");
open (REPLY, ">$ForumsPath/Forum$number/$topic");
foreach $post(@updated) {
chomp($post);
print REPLY ("$post\n");
}
close (REPLY);
&Unlock("lock.file");
chmod (0666, "$ForumsPath/Forum$number/$topic");


##Add reply to user's profile (total posts)
$TotalPosts++;
#Bump user up to Member if Total Posts reaches $MemberMinimum
if (($TotalPosts >= $MemberMinimum)  && ($Status eq "Junior Member")) {
$Status = "Member";
}

&Lock("lock.file");
open (MEMBERSHIP, ">$MembersPath/$UserNameFile.cgi") or die(&StandardHTML("Unable to write to a Members file. $!"));
	print MEMBERSHIP ("$UserName|");
	print MEMBERSHIP ("$Password|");
	print MEMBERSHIP ("$Email|");
	print MEMBERSHIP ("$URL|");
	print MEMBERSHIP ("$Permission|");
	print MEMBERSHIP ("$Occupation|");
	print MEMBERSHIP ("$Location|");
	print MEMBERSHIP ("$TotalPosts|");
	print MEMBERSHIP ("$Status|");
	print MEMBERSHIP ("$Interests|");
	print MEMBERSHIP ("$DateRegistered|");
	print MEMBERSHIP ("$EmailView|");
	print MEMBERSHIP (" \n");
close (MEMBERSHIP);
&Unlock("lock.file");
chmod (0777, "$MembersPath/$UserNameFile.cgi");

#update last time file
&Lock("lock.file");
open (LASTTIME, ">$ForumsPath/Forum$number/lasttime.file") or die(&StandardHTML("Unable to write a Forum$number LastTime.file $!"));
print LASTTIME ("$HyphenDate\n");
print LASTTIME ("$Time\n");
close (LASTTIME);
&Unlock("lock.file");
chmod (0666, "$ForumsPath/Forum$number/lasttime.file");

#update threads summary file
&CurrentDate;
&UpdateForumSummary($number, $topic);

##CREATE HTML FILE FOR NEW THREAD
&CreateThreadHTML("Forum$number", "$topic");

##determine last topic number and increment by 1

open (FORUMCOUNT, "$ForumsPath/Forum$number/lastnumber.file"); 
    @forumcounter = <FORUMCOUNT>;
close (FORUMCOUNT);

$lastthreadnum = $forumcounter[0];
chomp($lastthreadnum);
$totthreadcount = $forumcounter[1];
chomp($totthreadcount);
$totpostcount = $forumcounter[2];
chomp($totpostcount);

$totpostcount++;

&Lock("lock.file");
open (FORUMCOUNT, ">$ForumsPath/Forum$number/lastnumber.file"); 
print FORUMCOUNT ("$lastthreadnum\n");
print FORUMCOUNT ("$totthreadcount\n");
print FORUMCOUNT ("$totpostcount\n");
close (FORUMCOUNT);
&Unlock("lock.file");
chmod (0666, "$ForumsPath/Forum$number/lastnumber.file");


}  else {
#if topic file is still not writeable,
# then web host may be preventing writing new files-- don't process then

&StandardHTML("Sorry, we could not post your reply to this topic.  Contact your bulletin board administrator and inform them that they may have may run out of available disk space.  Their web host may be preventing them from posting new files.");
}

} else {

&StandardHTML("Sorry, but you do not have permission to post a note on the bulletin board.  Either the administrator of the BB or one of the moderators has removed your posting privileges.");

} #END Check Permission block
} # end Do Post The Reply


sub NewTopic {
@thisforum = &GetForumRecord($number);
$CustomTitle = "$thisforum[9]";
$UBBImages = "$thisforum[10]";

if ($CustomTitle eq "") {
$CustomTitle = "$BBTitle";
}

&CheckCoding;
&TopicFormHTML;

}  ## END NEWTOPIC SR ##

sub PostTopic {


## Verify form input
if (($in{'UserName'} eq "") || ($in{'Password'} eq "") || ($in{'TopicSubject'} eq "") || ($in{'Message'} eq "")) {
		&StandardHTML("You did not complete all required form fields!  Please go back and re-enter.");
	}  else {

@thisforum = &GetForumRecord($number);
$UBBCodeAllow = $thisforum[5];
$HTMLAllow = $thisforum[4];
$UBBImages = $thisforum[10];
$ForumStatus = $thisforum[3];

	   &DoPostTheTopic;

} #end if/else field check
}  ## END POST TOPIC SR ###


 
sub DoPostTheTopic {

##get current date/time

&GetDateTime;

##verify user name/password
$match = "no";
$verified = "false";
if (-e "$MembersPath/$UserNameFile.cgi") {
      $match= "yes";
} 

if ($match eq "yes") {
	@profilestats2 = &OpenProfile("$UserName.cgi");
	
	if ($profilestats2[1] eq "$in{'Password'}") {
				$verified = "true";
				$Location = "$profilestats2[6]";
				$Occupation = "$profilestats2[5]";
				$Email = "$profilestats2[2]";
				$Status = "$profilestats2[8]";
				$EmailView = "$profilestats2[11]";
				$TotalPosts = "$profilestats2[7]";
				$Interests = "$profilestats2[9]";
				$URL = "$profilestats2[3]";
				$Permission = "$profilestats2[4]";
				$DateRegistered = "$profilestats2[10]";
				$EmailView = "$profilestats2[11]";
	}  #END IF profilestats
} #END IF match eq yes
	
if ($match eq "no") {
&StandardHTML("Sorry, but we have no one registered with the UserName you typed.  Please try again.  Use your Back button.");
}

if ($match eq "yes" && $verified eq "false") {
&StandardHTML("Sorry, but the password you entered was not correct.  Please try again.  Use your Back button.");
}

if ($match eq "yes" && $verified eq "true") {
&CheckPermissions;
if ($PermissionToWrite eq "true") {

##determine last topic number and increment by 1

open (FORUMCOUNT, "$ForumsPath/Forum$number/lastnumber.file"); 
    @forumcounter = <FORUMCOUNT>;
close (FORUMCOUNT);

$lastthreadnum = $forumcounter[0];
chomp($lastthreadnum);
$totthreadcount = $forumcounter[1];
chomp($totthreadcount);
$totpostcount = $forumcounter[2];
chomp($totpostcount);

$count = $lastthreadnum + 0;

	$Notes = "";


if ($count > 0) {
$lastthreadnum++;
$newtopic = sprintf("%6d", $lastthreadnum);
$newtopic =~tr/ /0/;
}  else {
$newtopic = "000001";
}
##create filenumber for new topic
$newtopicfile = ("$newtopic.ubb");

#now we have to add the message to the forum directory

## IF HTML is not allowed, render HTML useless
if ($HTMLAllow eq "is not") {
		$Message =~ s/</&lt;/g;
		$Message =~ s/>/&gt;/g;
 }
	

#convert newlines/carriage returns to <br> and <p> html tags
$Message = &ConvertReturns("$Message");
	
#UBB Code-ify (if allowed)
if ($UBBCodeAllow eq "is") {
$Message = &UBBCode("$Message");
} #end if UBB Code allowed

## if email should not be displayed, don't
if (($EmailBlock eq "ON") || ($EmailView eq "no")) {
$PostEmail = "";
}  else {
$PostEmail = "$Email";
}

#create file lines
$StatsLine = "A||$Notes||0||$UserName||$TopicSubject";

$FatherLine = "Z||000000||$UserName||$HyphenDate||$Time||$PostEmail||$Message";

### test to make sure member file is writeable!

unless (-w "$MembersPath/$UserNameFile.cgi") {
chmod (0777, "$MembersPath/$UserNameFile.cgi");
}

&Forward("$CGIURL/forumdisplay.cgi?action=topics&forum=$ForumCoded&number=$number&DaysPrune=$DaysPrune", "Thanks for posting your message, $UserName!  We are now taking you back automatically to the topic list for $Forum.");


&Lock("lock.file");
open (FORUM, ">$ForumsPath/Forum$number/$newtopicfile"); 
print FORUM ("$StatsLine\n");
print FORUM ("$FatherLine\n");
close (FORUM);
&Unlock("lock.file");

chmod (0666, "$ForumsPath/Forum$number/$newtopicfile");

##CREATE HTML FILE FOR NEW THREAD
&CreateThreadHTML("Forum$number", "$newtopicfile");

##Add reply to user's profile (total posts)
$TotalPosts++;
#Bump user up to Member if Total Posts reaches $MemberMinimum
if (($TotalPosts == $MemberMinimum)  && ($Status eq "Junior Member")) {
$Status = "Member";
}
&Lock("lock.file");
open (MEMBERS, ">$MembersPath/$UserNameFile.cgi") or die(&StandardHTML("Unable to write new data to a Member file. $!"));
	print MEMBERS ("$UserName|");
	print MEMBERS ("$in{'Password'}|");
	print MEMBERS ("$Email|");
	print MEMBERS ("$URL|");
	print MEMBERS ("$Permission|");
	print MEMBERS ("$Occupation|");
	print MEMBERS ("$Location|");
	print MEMBERS ("$TotalPosts|");
	print MEMBERS ("$Status|");
	print MEMBERS ("$Interests|");
	print MEMBERS ("$DateRegistered|");
	print MEMBERS ("$EmailView|");
	print MEMBERS (" \n");
close (MEMBERS);
&Unlock("lock.file");
chmod (0777, "$MembersPath/$UserNameFile.cgi");

#update last time file
&Lock("lock.file");
open (LASTTIME, ">$ForumsPath/Forum$number/lasttime.file") or die(&StandardHTML("Unable to write a Forum$number LastTime.file  $!"));
print LASTTIME ("$HyphenDate\n");
print LASTTIME ("$Time\n");
close (LASTTIME);
&Unlock ("lock.file");
chmod (0666, "$ForumsPath/Forum$number/lasttime.file");

#update last number file for forum
$totthreadcount++;
$totpostcount++;

&Lock("lock.file");
open (FORUMCOUNT, ">$ForumsPath/Forum$number/lastnumber.file"); 
print FORUMCOUNT ("$newtopic\n");
print FORUMCOUNT ("$totthreadcount\n");
print FORUMCOUNT ("$totpostcount\n");
close (FORUMCOUNT);
&Unlock ("lock.file");
chmod (0666, "$ForumsPath/Forum$number/lastnumber.file");

#update threads summary file
&CurrentDate;
&AppendForumSummary($number, $newtopicfile);


} else {
&StandardHTML("Sorry, but we cannot post this topic due to a permissions problem on one of the files.  Please inform your bulletin board administrator that there is a problem with one or more of the files used to run this bulletin board.");
}

}


} #end do post the topic sr

sub GenerateThread {
# @threadguts contains the thread info

	$PostFolder = "$NonCGIURL/posticon.gif";
	$TopicSubject = $stats[4];
	chomp ($TopicSubject);
	
	&ThreadReplyTop;
	$AlternateColor = "$AltColumnColor1";
	foreach $post(@threadguts) {
		unless ($post =~ /^A/) {
		@thispost = split(/\|\|/, $post);
		
$UNCoded = $thispost[2];
$UNCoded =~ tr/ /+/;

$theDate = "$thispost[3]";
#format date
if ($DateFormat eq "Euro") {
@datearray = split(/-/, $theDate);
chomp($datearray[2]);
$ThisDate = "$datearray[1]-$datearray[0]-$datearray[2]";
}  else {
$ThisDate = "$theDate";
}
$theTime = "$thispost[4]";

#format time option 1
	if ($TimeFormat eq "24HR")  {
		@timearray = split(/ /, $theTime);
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
		$FormatTime = "$theTime";
	}

	$Author = $thispost[2];
	$ReplyMess = $thispost[6];
	chomp($ReplyMess);
	
	&ThreadReplyLoop;
	if ($AlternateColor eq "$AltColumnColor2") {
		$AlternateColor = "$AltColumnColor2";
	}  else {
		$AlternateColor = "$AltColumnColor2";
	}
}
}

}  ## end Generate Thread sr


### HTML CODE ####

sub ReplyFormHTML {
print <<REPLYFORM;
<HTML><HEAD><TITLE>$BBName - Reply to Topic</TITLE>
</HEAD>
 <BODY bgcolor="$BGColor"  text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<table border=0>
<TR><TD>
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle" BORDER=0></A></td>
<td valign=top>
<FONT SIZE="2" FACE="$FontFace" color="$TextColor">
<B>
Forum: <FONT COLOR="#800080">$Forum </FONT>
<BR>
Topic: <FONT COLOR="#800080">$TopicSubject</FONT>
</B>
</FONT>
</td></tr></table>
<CENTER>$LWADisclaimer
<p><FONT SIZE="2" FACE="$FontFace" COLOR="$CopyrightTextColor">
Note: You must be registered in order to post a topic or reply. <br>
To register, <A HREF="$CGIURL/Ultimate.cgi?action=agree">click here</A>.  Registration is FREE!
</FONT>
</CENTER>
<ul>
<FORM ACTION="postings.cgi" NAME="REPLIER" METHOD="POST">
<table border=0>
<tr><td NOWRAP>
<FONT SIZE="2" FACE="$FontFace" COLOR="$TextColor"><B>Your UserName:</B></FONT></td>
<td>
<INPUT TYPE="TEXT" NAME="UserName" VALUE="" SIZE=25 MAXLENGTH=25>
</td>
</tr>
<tr>
<td NOWRAP>
<FONT SIZE="2" FACE="$FontFace" COLOR="$TextColor"><B>Your Password:</B></FONT></td>
<td><INPUT TYPE="PASSWORD" NAME="Password" VALUE="" SIZE=13 MAXLENGTH=13>
</td></tr>
<TR><TD valign=top NOWRAP>
<FONT SIZE="2" FACE="$FontFace" COLOR="$TextColor"><B>Your Reply:</B></FONT>
<p><BR>
<FONT SIZE="1" FACE="$FontFace" COLOR="#800080">
$ISHTML<BR>
$ISUBB<BR>
$UBBImagesWording</p></font>
</td>
<td>
<TEXTAREA NAME="ReplyMessage" ROWS=20 COLS=55 WRAP="VIRTUAL"></TEXTAREA>
</td></tr>
</table>
<p>

<INPUT TYPE="HIDDEN" NAME="action" VALUE="postreply">
<INPUT TYPE="HIDDEN" NAME="TopicSubject" VALUE="$TopicSubject">
<INPUT TYPE="HIDDEN" NAME="forum" VALUE="$Forum">
<INPUT TYPE="HIDDEN" NAME="number" VALUE="$number">
<INPUT TYPE="HIDDEN" NAME="topic" VALUE="$topic">
<CENTER>

<p>
<INPUT TYPE="Submit" NAME="SUBMIT" VALUE="Submit Reply">
<INPUT TYPE="RESET" NAME="RESET" VALUE="Clear Fields">
</form>
<P>
<FONT SIZE="1" FACE="$FontFace" COLOR="#FF0000">*If HTML and/or <A HREF="$NonCGIURL/ubbcode.html" target=_new>UBB Code</A> are enabled, this means you can use use HTML and/or UBB Code in your message.</FONT>
</center>
<br></ul><center>
REPLYFORM
} # end ReplyFormHTML


sub ReplyFormBottom {
print<<REPLYFORMBOTTOM;
</table>

<P><center>
REPLYFORMBOTTOM

&PageBottomHTML;
}  ## END Reply Form Bottom sr

sub TopicFormHTML {
print <<FORM;
<HTML>
<HEAD>
<TITLE>$BBName - Post New Topic</TITLE>
</HEAD>
 <BODY bgcolor="$BGColor" text="$TextColor" link="$LinkColor" alink="$ActiveLinkColor" vlink="$VisitedLinkColor">
<FONT SIZE="2" FACE="$FontFace" color="$TextColor">

</font>
<table border=0 cellpadding=10>
<TR><TD>
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/$BBTitle"  BORDER=0></A></td>
<td><FONT SIZE="2" FACE="$FontFace">
<B>Post New Topic for Forum:<br>&nbsp;&nbsp;&nbsp;<FONT COLOR="$LinkColor">$Forum</FONT></FONT></B>
</td></tr></table>
<CENTER>
<p><FONT SIZE="2" FACE="$FontFace" COLOR="$CopyrightTextColor">
Note: You must be registered in order to post a topic or reply. <br>
To register, <A HREF="$CGIURL/Ultimate.cgi?action=agree">click here</A>.  Registration is FREE!
</FONT>
</CENTER>
</FONT>
<UL><FORM ACTION="postings.cgi" METHOD="POST" NAME="PostTopic">
<table border=0>
<tr>
<td NOWRAP>
<FONT SIZE="2" FACE="$FontFace"><B>Your UserName:</B></FONT></td><td><INPUT TYPE="TEXT" NAME="UserName" SIZE=25 MAXLENGTH=25>
</td></tr>
<tr>
<td NOWRAP>
<FONT SIZE="2" FACE="$FontFace"><B>Your Password:</B></FONT></td><td><INPUT TYPE="PASSWORD" NAME="Password" SIZE=13 MAXLENGTH=13></td></tr>
$LWAField
<TR>
<td NOWRAP>
<FONT SIZE="2" FACE="$FontFace"><B>Subject:</B></FONT></td>
<td><INPUT TYPE="TEXT" NAME="TopicSubject" VALUE="" SIZE=40 MAXLENGTH=85></td></tr>
<tr><td valign=top NOWRAP>
<FONT SIZE="2" FACE="$FontFace"><B>Message:</B></FONT>
<p><BR>
<FONT SIZE="1" FACE="$FontFace" COLOR="#800080">
$ISHTML<BR>
$ISUBB<BR>$UBBImagesWording</p></font>
</td>
<td>
<TEXTAREA NAME="Message" ROWS=20 COLS=55 WRAP="VIRTUAL">
</TEXTAREA></td></tr></table>
<BR>
<P>
<INPUT TYPE="HIDDEN" NAME="number" VALUE="$number">
<INPUT TYPE="HIDDEN" NAME="forum" VALUE="$Forum">
<INPUT TYPE="HIDDEN" NAME="action" VALUE="posttopic">
<CENTER>
<INPUT TYPE="SUBMIT" NAME="Submit" VALUE="Submit New Topic">
<INPUT TYPE="RESET" NAME="Reset" VALUE="Clear Fields">
</form></center>
<br></ul>


<FONT SIZE="1" FACE="$FontFace" COLOR="#800080">*If HTML and/or <A HREF="$NonCGIURL/ubbcode.html" target=_new>UBB Code</A> are enabled, this means you can use use HTML and/or UBB Code in your message.</FONT>
<P>
<center>
<FONT SIZE="2" FACE="$FontFace">
</ul>
<P>
FORM
&PageBottomHTML;
}  ## END Topic Form LWA HTML

sub ThreadReplyTop {
print<<otherHTML;
<center>
<table width=95% border=0 cellpadding=5>
<TR bgcolor="$TableColorStrip">
<TD valign=top width=18%>
<FONT SIZE="1" face="$FontFace" color="$LinkColor"><B>Name</B></FONT>
</TD>
<TD valign=top>
<FONT SIZE="1" face="$FontFace" color="$LinkColor"><B>Post</B></FONT>
</TD>
</TR>
otherHTML
}  

sub ThreadReplyLoop {
print <<REPLYhtml;
<tr bgcolor="$AlternateColor">
	<TD width=18% valign=top>
	<FONT SIZE="2" face="$FontFace"><B>$Author</B></FONT>
</td>
<TD>
<IMG SRC="$PostFolder" BORDER=0 ALT="">
<FONT SIZE="2" FACE="$FontFace">
<FONT SIZE="1" color="$LinkColor" face="$FontFace">posted $ThisDate $FormatTime $TimeZone 
</FONT>
<HR>$ReplyMess
</FONT>
</td></tr>
REPLYhtml
}  ## END Thread Disply within Reply Form 


sub CheckCoding {

if ($thisforum[4] eq "is") {
	$ISHTML = "*HTML is ON";
	$HTMLAllowed = "yes";
}  else {
	$ISHTML = "*HTML is OFF";
	$HTMLAllowed = "no";
}
 
if ($thisforum[5] eq "is") {
	$ISUBB = "*UBB Code is ON";
	$UBBAllowed = "yes";
}  else {
	$ISUBB = "*UBB Code is OFF";
	$UBBAllowed = "no";
}

if (($UBBImages eq "OFF") && ($UBBAllowed eq "yes")) {
	$UBBImagesWording = qq([IMG] UBB Code Not Allowed!);
}

}

sub AppendForumSummary {
$number = shift;
$ThreadFile = shift;

##### create new day summary file, if necessary
unless (-e "$ForumsPath/Forum$number/$RunOnDate.threads") {
my $CreateThreadFile = "yes";
&ForumSummary($number);
}  # end UNLESS THREADS SUMMARY EXISTS
##########

if ($CreateThreadFile ne "yes") {
($threadnum, $junk) = split(/\./, $ThreadFile);
	
		#parse topic date
		($MonthOfMessage, $DayOfMessage, $YearOfMessage) = split(/-/, $HyphenDate);	
			
$CheckThisYear = length($YearOfMessage);

	
	if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$YearOfMessage = ("19" . "$YearOfMessage");
		}  else {
		$YearOfMessage = $YearOfMessage - 100;
		$YearOfMessage = sprintf ("%2d", $YearOfMessage);
		$YearOfMessage =~tr/ /0/;
		$YearOfMessage = ("20" . "$YearOfMessage");
		}
}

$threadtime = "$Time";

($GetHour, $GetMinute) = split(/:/, $threadtime);
($GetMinute, $AMpm) = split(/ /, $GetMinute);
chomp($AMpm);

	&MilitaryTime2;
	$MilTime = "$MilHour$GetMinute";

$DateTime = "$YearOfMessage$MonthOfMessage$DayOfMessage$MilTime";
$CompareTime = (2400 - $MilTime);
$CompareTime = sprintf ("%4d", $CompareTime);
$CompareTime =~ tr/ /0/;
$DateTimeCompare = "$YearOfMessage$MonthOfMessage$DayOfMessage$CompareTime";

	$newline = ("000|^|$DateTimeCompare|^|$DateTime|^|$threadnum.html|^|$TopicSubject|^|0|^|$UserName|^|no");	

# append to thread summary file
&Lock("lock.file");
open (THREADS, ">>$ForumsPath/Forum$number/$RunOnDate.threads") or die(&StandardHTML("Unable to write to Forum$number thread summary file $!"));
print THREADS ("$newline\n");
close (THREADS);
&Unlock("lock.file");

chmod (0666, "$ForumsPath/Forum$number/$RunOnDate.threads");
} #end if day's thread summary does not have to totally created
}  # end ForumSummaryAppend sr

