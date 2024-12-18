###############################################################################
# Notify.pl                                                                   #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef@zefnet.com)                   #
# Software Version: YaBB 1 Gold Beta4                                         #
# =========================================================================== #
# Software Distributed by:    www.yabb.org                                    #
# Support, News, Updates at:  www.yabb.org/cgi-bin/support/YaBB.pl            #
# =========================================================================== #
# Copyright (c) 2000-2001 YaBB - All Rights Reserved                          #
# Software by: The YaBB Development Team                                      #
###############################################################################

$notifyplver="1 Gold Beta4";

sub Notify {
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	if($currentboard ne "") { &DPPrivate; }
	$yytitle = "$txt{'125'}";
	&header;

	# Check, if User already gets a notification

	open (FILE, "$datadir/$INFO{'thread'}.mail");
	&lock(FILE);
	@mails = <FILE>;
	&unlock(FILE);
	close(FILE);

	$isonlist = 0;

	foreach $curmail (@mails) {
		$curmail =~ s/[\n\r]//g;
		if($settings[2] eq "$curmail") { $isonlist = 1; }
	}

	if ($isonlist){
	
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'125'}</b></font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2>
$txt{'212'}<br>
<b><a href="$cgi&action=notify3&thread=$INFO{'thread'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}">$txt{'164'}</a></b>
</font></td>
</tr>
</table>
EOT

	} else
	{
	
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}"><b>$txt{'125'}</b></font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2>
$txt{'126'}<br>
<b><a href="$cgi&action=notify2&thread=$INFO{'thread'}">$txt{'163'}</a> - <a href="$cgi&action=display&num=$INFO{'thread'}">$txt{'164'}</a></b>
</font></td>
</tr>
</table>
EOT

	}

	&footer;
	exit;
}

# /Build 9

sub Notify2 {
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	if($currentboard ne "") { &DPPrivate; }
	$thread = $INFO{'thread'};
	open (FILE, "$datadir/$thread.mail");
	&lock(FILE);
	@mails = <FILE>;
	&unlock(FILE);
	close(FILE);
	open (FILE, ">$datadir/$thread.mail") || &fatal_error("$txt{'23'} $thread.mail");
	&lock(FILE);
	print FILE "$settings[2]\n";
	foreach $curmail (@mails) {
		$curmail =~ s/[\n\r]//g;
		if($settings[2] ne "$curmail") { print FILE "$curmail\n"; }
	}
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=display\&num=$thread\n\n";
	exit;
}

# Build 9

sub Notify3 {
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	if($currentboard ne "") { &DPPrivate; }
	$thread = $INFO{'thread'};
	open (FILE, "$datadir/$thread.mail");
	&lock(FILE);
	@mails = <FILE>;
	&unlock(FILE);
	close(FILE);
	open (FILE, ">$datadir/$thread.mail") || &fatal_error("$txt{'23'} $thread.mail");
	&lock(FILE);
	foreach $curmail (@mails) {
		$curmail =~ s/[\n\r]//g;
		if($settings[2] ne "$curmail") { print FILE "$curmail\n"; }
	}
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=display\&num=$thread\n\n";
	exit;
}

# /Build 9

sub Notify4 {
	
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	if($currentboard ne "") { &DPPrivate; }
	
	foreach $variable (keys %FORM) {
	 	$dummy = $FORM{$variable};

		($dummy2,$threadno) = split(/-/,$variable);

		if ($dummy2 eq "thread") {
					
			open (FILE, "$datadir/$threadno.mail");
			&lock(FILE);
			@mails = <FILE>;
			&unlock(FILE);
			close(FILE);
	
			open (FILE, ">$datadir/$threadno.mail") || &fatal_error("$txt{'23'} $threadno.mail");
			&lock(FILE);
			foreach $curmail (@mails) {
				$curmail =~ s/[\n\r]//g;
				if($settings[2] ne "$curmail") { print FILE "$curmail\n"; }
			}
			&unlock(FILE);
			close(FILE);
		
		}
	        
	}

	print "Location: $cgi\&action=shownotify\n\n";
	exit;
}

sub ShowNotifications {

	if($username eq "Guest") { &error("$txt{'138'}"); }

	my(@dirdata,@datdata,$filename,$entry,@entries,$mnum,$dummy,$msub,$mname,$memail,$mdate,$musername,$micon,$mattach,$mip,$mmessage,@messages,@found_number,@found_subject,@found_date,@found_username);
	
	# Read all .mail-Files and search for username

	opendir (DIRECTORY,"$datadir");
	@dirdata = readdir(DIRECTORY); 
	closedir (DIRECTORY); 
	@datdata = grep(/mail/,@dirdata);  

	$yytitle = "$txt{'417'}";
	&header;
	
	foreach $filename (@datdata) {        
		
		open(FILE, "$datadir/$filename");       
		&lock(FILE);       
		@entries = <FILE>;       
		&unlock(FILE);       
		close(FILE);        
		
	        foreach $entry (@entries) {             
	        	$entry =~ s/[\n\r]//g;             

	        	if ($entry eq $settings[2]) {
				($mnum, $dummy) = split(/\./,$filename);
				open(FILE, "$datadir/$mnum.txt");
				&lock(FILE);       
				@messages = <FILE>;       
				&unlock(FILE);       
				close(FILE);        
				($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip,  $mmessage) = split(/\|/,$messages[0]);
				push(@found_number,$mnum); 
				push(@found_subject,$msub); 
				push(@found_date,$mdate); 
				push(@found_username,$musername); 
				push(@found_name,$mname); 
			}

		}        		
	
	}

	# Display all Entries

	print <<"EOT";
<table border=0 width=100% cellspacing=1 cellpadding=6 bgcolor="#000000">
 <tr>
  <td bgcolor="$color{'titlebg'}">
   <font size=2 color="$color{'titletext'}"><b>$txt{'418'}</b></font>
  </td>
 </tr>
 <tr>
  <td bgcolor="$color{'windowbg'}">
   <font size=2>
    <br>
EOT


	if (@found_number==0) {
		print "$txt{'414'}<br><br>&nbsp;";
	} else {
		print "<form action=\"$cgi&action=notify4\" method=post>";
		print "<table>\n";
		print "<tr><td colspan=2><font size=2>$txt{'415'}:</font><br>&nbsp;</td></tr>";
		$counter=0;
		foreach $entry (@found_number) {        
			print "<tr><td><font size=2>";
			print "<input type=checkbox name=\"thread-$found_number[$counter]\" value=\"1\"></font></td>";
			print "<td><font size=2><b><i>$found_subject[$counter]</i></b> by <a href=\"$boardurl/YaBB.pl?board=&action=viewprofile&username=$found_username[$counter]\">$found_name[$counter]</a></font></td></tr>\n";
			$counter++;
		}
		print "<tr><td colspan=2><br><font size=2>$txt{'416'}</font><br>&nbsp;</td></tr>\n";
		print "<tr><td>&nbsp;</td><td><input type=reset value=\"$txt{'329'}\">&nbsp;&nbsp;&nbsp;<input type=submit value=\"$txt{'417'}\"></td></tr>";
		print "</table></form><br>&nbsp;\n";
	}

	print <<"EOT";
   </font>
  </td>
 </tr>
</table>
EOT
	&footer;
	exit;

}


1;