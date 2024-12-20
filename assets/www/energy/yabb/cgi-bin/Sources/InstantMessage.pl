###############################################################################
# InstantMessage.pl                                                           #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
# =========================================================================== #
# History:                                                                    #
#                                                                             #
# 07/28/2000 (001) Christian Land     - NF: Added MessageID to saved          #
#                                           messages                          #
#                                     - NF: Deletion by MessageID             #
#                                     - BF: ICQ-Icon will only be displayed   #
#                                           if Field-Content is numeric       #
#                                                                             #
###############################################################################
# $field[0] = From (username only)
# $field[1] = Subject
# $field[2] = Date
# $field[3] = Message
# $field[4] = MessageID

sub IMIndex 
{
	if ($username eq "Guest") 
	{ 
		&fatal_error("$txt{'147'}"); 
	}
	
	open(FILE, "$memberdir/$username.msg");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);
	
	$title = "$txt{'143'}";
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);
	
	&header;
	open(CENSOR, "$vardir/censor.txt");
	&lock(CENSOR);
	@censored = <CENSOR>;
	&unlock(CENSOR);
	close(CENSOR);
	
	##################
	
	print <<"EOT";

 <b><a href="$boardurl/YaBB.pl">$mbname</a>:
    <a href="$cgi&action=im">$txt{'144'}</a></b>
</font>
<table border=0 width=500 cellspacing=1 bgcolor="#ffffff">
<tr>
 <td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}">&nbsp;<b>$txt{'29'}</b></font></td>
 <td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'118'}</b></font></td>
</tr>
EOT

	if(@messages==0) 
	{
		print <<"EOT";
<tr>
	<td colspan=2 bgcolor="$color{'windowbg'}">$txt{'151'}</td>
</tr>
EOT
	}
	$second="$color{'windowbg2'}";
	for ($a = 0; $a < @messages; $a++) 
	{
		if($second eq "$color{'windowbg'}") 
		{ 
			$second="$color{'windowbg2'}"; 
		}
		else 
		{ 
			$second="$color{'windowbg'}"; 
		}
		
		($musername[$a], $msub[$a], $mdate[$a], $mmessage[$a], $messageid[$a]) = split(/\|/,$messages[$a]);

                # Lets set ID to $a if we've got an old message
                
                if ($messageid[$a] < 100)
                {
			$messageid[$a] = $a;      	
                }

		$subject = "$msub[$a]";

		if($subject eq "") 
		{ 
			$subject="$txt{'24'}"; 
		}
		
		$mmessage[$a] =~ s/\n//g;
		$mmessage[$a] =~ s/\r//g;
		$message="$mmessage[$a]";
		$name = "$mname[$a]";
		$date = "$mdate[$a]";
		$ip = "$mip[$a]";
		$postinfo="";
		$signature="";
		$viewd="";
		$icq="";
		$star="";
		
		open(FILE, "$memberdir/$musername[$a].dat");
		&lock(FILE);
		@memset = <FILE>;
		&unlock(FILE);
		close(FILE);
		
		$postinfo = "$txt{'26'}: $memset[6]<br>";
		$viewd = " \| <a href=\"$cgi\&action=viewprofile\&username=$musername[$a]\">$txt{'27'}</a><br>";
		$memberinfo = "$membergroups[2]";
		$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
		if($memset[6] > 50) {
			$memberinfo = "$membergroups[3]";
			$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
		}
		if($memset[6] > 100) {
			$memberinfo = "$membergroups[4]";
			$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
		}
		if($memset[6] > 250) {
			$memberinfo = "$membergroups[4]";
			$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
		}
		if($memset[6] > 500) {
			$memberinfo = "$membergroups[4]";
			$star=<<"EOT";
<img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0"><img src="$imagesdir/star.gif" width=13 height=12 alt="" border="0">
EOT
		}
		if($boardmoderator eq "$musername[$a]") { $memberinfo = "$membergroups[1]"; }
		if($memset[7] ne "\n") { $memberinfo = "$memset[7]"; }
		if($memberinfo eq "Administrator\n") { $memberinfo = "$membergroups[0]"; }
		$signature = "$memset[5]";
		$signature =~ s/\&\&/<br>/g;
		$signature = "<hr width=40\% align=left>$signature";
		$memset[8] =~ s/\n//g;
		$memset[8] =~ s/\r//g;
		if($memset[8] ne "") {
                if(!($memset[8] =~ /\D/)) { 
			$icq = "<a href=\"http://www.icq.com/$memset[8]\" target=_blank><img src=\"http://wwp.icq.com/scripts/online.dll?icq=$memset[8]&img=5\" alt =\"$memset[8]\" border=0></a>";
		}
		}
		$message = "$message\n$signature";
		if($enable_ubbc) {
			require "$sourcedir/Display.pl";
			&DoUBBC;
		}
		$url="";
		if($memset[3] ne "\n" && $musername[$a] ne "Guest") {
			$url= "<a href=\"$memset[4]\">WWW</a> \| ";
		}
		##################
		foreach $censor (@censored) {
			$censor =~ s/\n//g;
			($word, $censored) = split(/\=/, $censor);
			$message =~ s/$word/$censored/g;
			$subject =~ s/$word/$censored/g;
		}
		##################
		print <<"EOT";
<tr>
	<td bgcolor="$second" width=140 valign=top rowspan=2>
	<b>$memset[1]</b><br>
	<font size=1>$memberinfo<br>
	$star<br><br>
	$postinfo<br>
	$icq
	</font></td>
	<td bgcolor="$second" valign=top>
	<table border=0 cellspacing=0 cellpadding=0 width=500>
<tr>
	<td><font size=1>&nbsp;<b>$subject</b></font></td>
	<td align=right nowrap><font size=1><b>$txt{'30'}:</b> $date</font></td>
</tr>
</table>
	<hr></font>
<p>
$message
</p></td>
</tr>
<tr>
	<td bgcolor="$second"><table border=0 cellspacing=0 cellpadding=0><tr><td><font size=1>
$url<a href="mailto:$memail[$a]">E-Mail</a>$viewd
</font></td><td align=right>
<font size=1><a href="$cgi&action=imsend&num=$a&quote=1&to=$musername[$a]">$txt{'145'}</a> | <a href="$cgi&action=imsend&to=$musername[$a]&num=$a">$txt{'146'}</a> | <a href="$cgi&action=imremove&id=$messageid[$a]"><b>$txt{'154'}</b></a></font></td></tr></table></td>
</tr>
EOT
;
	}
print <<"EOT";
</table>
<a href="$cgi&action=imsend">$txt{'148'}</a>
EOT
	&footer;
	exit;
}

sub IMRemove
{
   if($username eq "Guest")
   { 
      &fatal_error("$txt{'147'}"); 
   }
   open(FILE, "$memberdir/$username.msg");
   &lock(FILE);
   @messages = <FILE>;
   &unlock(FILE);
   close(FILE);
   open(FILE, ">$memberdir/$username.msg");
   &lock(FILE);
   for ($a = 0; $a < @messages; $a++) 
   {
      # ONLY delete MSG with correct ID
      ($musername, $msub, $mdate, $mmessage, $messageid) = split(/\|/,$messages[$a]);

      if ($messageid < 100 )
      {
         if($a ne $INFO{'id'})
         { 
            print FILE "$messages[$a]"; 
         }
      }
      else
      {
         #if($messageid ne "$INFO{'id'}")
         if(!($messageid =~ /$INFO{'id'}/))
         { 
            print FILE "$messages[$a]"; 
         }
      }
   }
   &unlock(FILE);
   close(FILE);
   print "Location: $cgi\&action=im\n\n";
}

sub IMPost 
{

        # Create Message ID - currently it's time/date 
        # Probably this could be changed to something better? If two messages are
        # sent at the same time !BOTH! they'll get the same ID 
        # Solution: Add 1/1000s or 1/100s to the timestamp!? 

        $mid=time; 

        # ---

	if($username eq "Guest") 
	{ 
	 	&fatal_error("$txt{'147'}"); 
	}

	open(FILE, "$memberdir/$username.msg");
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	$title="$txt{'148'}";
	&header;
	if($INFO{'num'} ne "") {
		($mfrom, $msubject, $mdate, $mmessage) = split(/\|/,$messages[$INFO{'num'}]);
		$msubject =~ s/Re: //g;
		$form_subject = "Re: $msubject";

		if($INFO{'quote'} == 1) {
			$form_message =~ s/\[quote\](\S+?)\[\/quote\]//isg;
			$form_message =~ s/\[(\S+?)\]//isg;
			$mmessage =~ s/<br>/\n/g;
			$form_message = "\n\n\[quote\]$mmessage\[/quote\]";
		}
	}

        # Added Hidden-Field "messageid"
 
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'148'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<form action="$cgi&action=imsend2" method=post>
<input name="messageid" value="$mid" type=hidden>
<table border=0>
<tr>
	<td><b>$txt{'150'}:</b></td>
	<td><input type=text name="to" value="$INFO{'to'}" size="20" maxlength="50"></td>
</tr>
<tr>
	<td><b>$txt{'70'}:</b></td>
	<td><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></td>
</tr>
<tr>
	<td valign=top><b>$txt{'72'}:</b></td>
	<td><textarea name=message rows=10 cols=50 wrap=virtual>$form_message</textarea></td>
</tr>
<tr>
	<td align=center colspan=2><input type=submit value="$txt{'148'}">
	<input type=reset value="Reset Form"></td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub IMPost2 
{

   # Get the Message ID
   $messageid = $FORM{'messageid'};
   # ---
   $subject = $FORM{'subject'};
   $message = $FORM{'message'};

   &fatal_error("$txt{'77'}") unless($subject);
   &fatal_error("$txt{'78'}") unless($message);

   $subject =~ s/\&/\&amp;/g;
   $message =~ s/\&/\&amp;/g;
   $subject =~ s/"/\&quot;/g;
   $message =~ s/"/\&quot;/g;
   $subject =~ s/  / \&nbsp;/g;
   $message =~ s/  / \&nbsp;/g;

   $subject =~ s/</&lt;/g;
   $subject =~ s/>/&gt;/g;
   $message =~ s/</&lt;/g;
   $message =~ s/>/&gt;/g;
   $message =~ s/\t/ \&nbsp; \&nbsp; \&nbsp;/g;
   $message =~ s/\cM//g;
   $message =~ s/\n/<br>/g;
   $message =~ s/\|//g;

   if(-e("$memberdir/$FORM{'to'}.dat")) { } else { &fatal_error("$txt{'149'}"); }

   open (FILE, "$memberdir/$FORM{'to'}.msg");
   &lock(FILE);
   @messages = <FILE>;
   &unlock(FILE);
   close (FILE);
   open (FILE, ">$memberdir/$FORM{'to'}.msg");
   &lock(FILE);
   # Added the MessageID field
   print FILE "$username\|$subject\|$date\|$message\|$messageid\n";
   foreach $curm (@messages) 
   {
      print FILE "$curm";
   }
   &unlock(FILE);
   close(FILE);
   print "Location: $cgi\&action=im\n\n";
   exit;
}


1;