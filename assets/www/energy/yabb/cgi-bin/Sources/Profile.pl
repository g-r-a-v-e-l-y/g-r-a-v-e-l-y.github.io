###############################################################################
# Profile.pl                                                                  #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub ModifyProfile {
	$title = "$txt{'79'}";
	open(FILE, "$memberdir/$INFO{'username'}.dat");
	&lock(FILE);
	@memsettings=<FILE>;
	&unlock(FILE);
	close(FILE);
	$memsettings[0] =~ s/\n//g;
	$memsettings[1] =~ s/\n//g;
	$memsettings[2] =~ s/\n//g;
	$memsettings[3] =~ s/\n//g;
	$memsettings[4] =~ s/\n//g;
	$memsettings[5] =~ s/\n//g;
	$memsettings[6] =~ s/\n//g;
	$memsettings[7] =~ s/\n//g;
	$memsettings[8] =~ s/\n//g;
	$memsettings[0] =~ s/\r//g;
	$memsettings[1] =~ s/\r//g;
	$memsettings[2] =~ s/\r//g;
	$memsettings[3] =~ s/\r//g;
	$memsettings[4] =~ s/\r//g;
	$memsettings[5] =~ s/\r//g;
	$memsettings[6] =~ s/\r//g;
	$memsettings[7] =~ s/\r//g;
	$memsettings[8] =~ s/\r//g;
	$signature = "$memsettings[5]";
	$signature =~ s/\&\&/\n/g;
	if($settings[0] ne "$memsettings[0]" && $settings[7] ne "Administrator") {
		&fatal_error("$txt{'80'}");
	}
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'79'}</b></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><form action="$cgi\&action=profile2" method="POST">
<table border=0>
<tr>
	<td><b>$txt{'35'}:</b></td>
	<td><input type=hidden name="username" value="$INFO{'username'}">$INFO{'username'}</td>
</tr>
<tr>
	<td><b>$txt{'81'}:</b></td>
	<td><input type=password name=passwrd1 size=20 value="$memsettings[0]"></td>
</tr>
<tr>
	<td><b>$txt{'82'}:</b></td>
	<td><input type=password name=passwrd2 size=20 value="$memsettings[0]"></td>
</tr>
<tr>
	<td><b>$txt{'68'}:</b></td>
	<td><input type=text name=name size=50 value="$memsettings[1]"></td>
</tr>
<tr>
	<td><b>$txt{'69'}:</b></td>
	<td><input type=text name=email size=50 value="$memsettings[2]"></td>
</tr>
<tr>
	<td><b>$txt{'83'}:</b></td>
	<td><input type=text name=websitetitle size=50 value="$memsettings[3]"></td>
</tr>
<tr>
	<td><b>$txt{'84'}:</b></td>
	<td><input type=text name=websiteurl size=50 value="$memsettings[4]"></td>
</tr>
<tr>
	<td><b>ICQ:</b></td>
	<td><input type=text name=icq size=50 value="$memsettings[8]"></td>
</tr>
<tr>
	<td valign=top><font><b>$txt{'85'}:</b></font></td>
	<td><textarea name=signature rows=4 cols=50 wrap=virtual>$signature</textarea></td>
</tr>
EOT
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@lines = <FILE>;
	&unlock(FILE);
	close(FILE);
	if($settings[7] eq "Administrator") {
		$position="";
		foreach $curl (@lines) {
			if($curl ne "$lines[1]" && $curl ne "$lines[2]" && $curl ne "$lines[3]" && $curl ne "$lines[4]") {
				if($curl ne "$lines[0]") {
					$position="$position<option>$curl";
				} else {
					$position="$position<option value=\"Administrator\">$curl";
				}
			}
		}
		if($memsettings[7] eq "Administrator") {
			$tt = "$lines[0]";
		} else { $tt = "$memsettings[7]"; }
		print <<"EOT";
<tr>
	<td><b>$txt{'86'}:</b></td>
	<td><input type=text name=settings6 size=4 value="$memsettings[6]"></td>
</tr>
<tr>
	<td><b>$txt{'87'}:</b></td>
	<td><select name="settings7">
	<option value="$memsettings[7]">$tt
	<option value="$memsettings[7]">---------------
	$position
	</select></td>
</tr>
<tr>
	<td align=center colspan=2>
	<input type=hidden name="settings8" value="$memsettings[8]">
EOT
	} else {
		print <<"EOT";
<tr>
	<td align=center colspan=2>
	<input type=hidden name="settings6" value="$memsettings[6]">
	<input type=hidden name="settings7" value="$memsettings[7]">
	<input type=hidden name="settings8" value="$memsettings[8]">
EOT
	}
	print <<"EOT";
	<input type=submit name=moda value="$txt{'88'}">
	<input type=submit name=moda value="$txt{'89'}">
	</td>
</tr>
</table>
</form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ModifyProfile2 {
	&fatal_error("$txt{'90'}") if($FORM{'passwrd1'} ne "$FORM{'passwrd2'}");
	&fatal_error("$txt{'91'}") if($FORM{'passwrd1'} eq "");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq "");
	&fatal_error("$txt{'76'}") if($FORM{'email'} eq "");
	if($FORM{'moda'} eq "$txt{'88'}") {
		open(FILE, ">$memberdir/$FORM{'username'}.dat");
		&lock(FILE);
		print FILE "$FORM{'passwrd1'}\n";
		print FILE "$FORM{'name'}\n";
		print FILE "$FORM{'email'}\n";
		print FILE "$FORM{'websitetitle'}\n";
		print FILE "$FORM{'websiteurl'}\n";
		$FORM{'signature'} =~ s/\n/\&\&/g;
		$FORM{'signature'} =~ s/\r//g;
		print FILE "$FORM{'signature'}\n";
		print FILE "$FORM{'settings6'}\n";
		print FILE "$FORM{'settings7'}\n";
		print FILE "$FORM{'icq'}\n";
		&unlock(FILE);
		close(FILE);
		print "Location: $cgi\&action=viewprofile\&username=$FORM{'username'}\n\n";
	} else {
		unlink("$memberdir/$FORM{'username'}.dat");
		unlink("$memberdir/$FORM{'username'}.msg");
		unlink("$memberdir/$FORM{'username'}.log");
		open(FILE, "$memberdir/memberlist.txt");
		&lock(FILE);
		@members = <FILE>;
		&unlock(FILE);
		close(FILE);
		open(FILE, ">$memberdir/memberlist.txt");
		&lock(FILE);
		foreach $curmem (@members) {
			$curmem =~ s/\n//g;
			$curmem =~ s/\r//g;
			if($curmem ne "$FORM{'username'}") { print FILE "$curmem\n"; }
		}
		&unlock(FILE);
		close(FILE);
		print "Location: $cgi\n\n";
	}
	exit;
}

sub ViewProfile {
	$title = "$txt{'92'} $INFO{'username'}";
	&header;
	open(FILE, "$memberdir/$INFO{'username'}.dat");
	&lock(FILE);
	@memsettings=<FILE>;
	&unlock(FILE);
	close(FILE);
	$memsettings[0] =~ s/\n//g;
	$memsettings[1] =~ s/\n//g;
	$memsettings[2] =~ s/\n//g;
	$memsettings[3] =~ s/\n//g;
	$memsettings[4] =~ s/\n//g;
	$memsettings[5] =~ s/\n//g;
	$memsettings[6] =~ s/\n//g;
	$memsettings[7] =~ s/\n//g;
	$memsettings[8] =~ s/\n//g;
	$memsettings[0] =~ s/\r//g;
	$memsettings[1] =~ s/\r//g;
	$memsettings[2] =~ s/\r//g;
	$memsettings[3] =~ s/\r//g;
	$memsettings[4] =~ s/\r//g;
	$memsettings[5] =~ s/\r//g;
	$memsettings[6] =~ s/\r//g;
	$memsettings[7] =~ s/\r//g;
	$memsettings[8] =~ s/\r//g;
	
	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);

	$memberinfo = "$membergroups[2]";
	if($memsettings[6] > 50) {
		$memberinfo = "$membergroups[3]";
	}
	if($memsettings[6] > 100) {
		$memberinfo = "$membergroups[4]";
	}
	if($memsettings[7] ne "") { $memberinfo = "$memsettings[7]"; }
	if($memsettings[7] eq "Administrator") { $memberinfo = "$membergroups[0]"; }

	print <<"EOT";
<table border=0 width=300 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><table border=0 cellspacing=0 cellpadding=0 width=600><tr><td><font color="$color{'titletext'}"><b>$INFO{'username'}</b></font></td><td align=right><a href="$cgi&action=profile&username=$INFO{'username'}"><font color="$color{'titletext'}">$txt{'17'}</a></font></td></tr></table>
	</td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<table border=0 width=300>
<tr>
	<td><b>$txt{'68'}:</b></td>
	<td>$memsettings[1]</td>
</tr>
<tr>
	<td><b>$txt{'69'}:</b></td>
	<td><a href="mailto:$memsettings[2]">$memsettings[2]</a></td>
</tr>
<tr>
	<td><b>$txt{'96'}:</b></td>
	<td><a href="$memsettings[4]" target=_blank>$memsettings[3]</a></td>
</tr>
<tr>
	<td><b>ICQ:</b></td>
	<td>$memsettings[8]</td>
</tr>
<tr>
	<td><b>$txt{'86'}:</b></td>
	<td>$memsettings[6]</td>
</tr>
<tr>
	<td><b>$txt{'87'}:</b></td>
	<td>$memberinfo</td>
</tr>
<tr>
	<td><b>$txt{'148'}:</b></td>
	<td><a href="$cgi&action=imsend&to=$INFO{'username'}">[>>]</a></td>
</tr>
</table>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

1;