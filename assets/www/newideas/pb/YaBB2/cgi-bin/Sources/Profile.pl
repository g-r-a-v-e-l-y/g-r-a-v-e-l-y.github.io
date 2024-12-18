###############################################################################
# Profile.pl                                                                  #
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

$profileplver="1 Gold Beta4";

sub ModifyProfile {

	if ($INFO{'username'} =~ /\//){ &fatal_error("$txt{'224'}"); }
	if ($INFO{'username'} =~ /\\/){ &fatal_error("$txt{'225'}"); }

	$yytitle = "$txt{'79'}";

	if($username ne $INFO{'username'} && $settings[7] ne "Administrator") {
		&fatal_error("$txt{'80'}");
	}

	open(FILE, "$memberdir/$INFO{'username'}.dat");
	&lock(FILE);
	@memsettings=<FILE>;
	&unlock(FILE);
	close(FILE);
	$memsettings[0] =~ s/[\n\r]//g;
	$memsettings[1] =~ s/[\n\r]//g;
	$memsettings[2] =~ s/[\n\r]//g;
	$memsettings[3] =~ s/[\n\r]//g;
	$memsettings[4] =~ s/[\n\r]//g;
	$memsettings[5] =~ s/[\n\r]//g;
	$memsettings[6] =~ s/[\n\r]//g;
	$memsettings[7] =~ s/[\n\r]//g;
	$memsettings[8] =~ s/[\n\r]//g;
	$memsettings[9] =~ s/[\n\r]//g;
	$memsettings[10] =~ s/[\n\r]//g;
	$memsettings[11] =~ s/[\n\r]//g;
	$memsettings[12] =~ s/[\n\r]//g;
	$memsettings[13] =~ s/[\n\r]//g;
	$memsettings[14] =~ s/[\n\r]//g;
	$memsettings[15] =~ s/[\n\r]//g;
	$memsettings[16] =~ s/[\n\r]//g;
	$memsettings[17] =~ s/[\n\r]//g;
	$memsettings[18] =~ s/[\n\r]//g;
	$dr = "";
	if ($memsettings[14] eq "") {
		$dr = "$txt{'470'}";
	} else {
		$dr = "$memsettings[14]";
	}
	if ($memsettings[11] eq "Male") {
		$GenderMale = "selected";
	}
	if ($memsettings[11] eq "Female") {
		$GenderFemale = "selected";
	}
	$signature = "$memsettings[5]";
	$signature =~ s/\&\&/\n/g;
	$signature =~ s/\&lt;/</g;
	$signature =~ s/\&gt;/>/g;

	$memsettings[9] =~ s/\+/ /g;;

	&FromHTML($memsettings[1]);	# Name
	&FromHTML($memsettings[2]);	# eMail
	&FromHTML($memsettings[3]);	# Website-Title
	&FromHTML($memsettings[4]);	# Website-URL
	&FromHTML($memsettings[9]);	# AIM
	&FromHTML($memsettings[10]);	# YIM
	&FromHTML($memsettings[12]);	# Usertext
	&FromHTML($memsettings[13]);	# Userpic
	&FromHTML($memsettings[15]);	# Location
	&FromHTML($memsettings[16]);	# Age

	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
  <tr>
    <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'79'} $txt{'517'}</font></td>
  </tr><tr>
    <td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi\&action=profile2" method="POST" name="creator">
    <table border=0>
      <tr>
	<td align="right"><font size=2>$txt{'35'}: </font></td>
	<td><font size=2><input type=hidden name="username" value="$INFO{'username'}">$INFO{'username'}</font></td>
      </tr><tr>
	<td align="right"><font size=2>* $txt{'81'}: </font></td>
	<td><font size=2><input type=password name=passwrd1 size=20 value="$memsettings[0]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>* $txt{'82'}: </font></td>
	<td><font size=2><input type=password name=passwrd2 size=20 value="$memsettings[0]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>* $txt{'68'}: </font></td>
	<td><font size=2><input type=text name=name size=30 value="$memsettings[1]"> $txt{'518'}</font></td>
      </tr><tr>
	<td align="right"><font size=2>* $txt{'69'}: </font></td>
	<td><font size=2><input type=text name=email size=30 value="$memsettings[2]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'231'}: </font></td>
	<td>
	<select name="gender" size="1">
	 <option value=""></option>
	 <option value="Male" $GenderMale>$txt{'238'}</option>
	 <option value="Female" $GenderFemale>$txt{'239'}</option>
	</select>
	</td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'420'}:</font></td>
	<td><font size=2><input type=text name=age size=3 maxlength=2 value="$memsettings[16]"></font></td>
      </tr><tr>
	<td colspan=2>
	<BR><BR><font size=2>________ $txt{'226'}: ________</font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'227'}: </font></td>
	<td><font size=2><input type=text name=location size=50 value="$memsettings[15]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'83'}: </font></td>
	<td><font size=2><input type=text name=websitetitle size=50 value="$memsettings[3]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'84'}: </font></td>
	<td><font size=2><input type=text name=websiteurl size=50 value="$memsettings[4]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'513'} #: </font></td>
	<td><font size=2><input type=text name=icq size=20 value="$memsettings[8]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>AIM-Name: </font></td>
	<td><font size=2><input type=text name=aim size=20 value="$memsettings[9]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>YIM-Name: </font></td>
	<td><font size=2><input type=text name=yim size=20 value="$memsettings[10]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'228'}: </font></td>
	<td><font size=2><input type=text name=usertext size=50 value="$memsettings[12]"></font></td>
      </tr>

EOT
opendir(DIR, "$facesdir") || die "$txt{'230'} ($facesdir) :: $!";
@contents = readdir(DIR);
closedir(DIR);
$images = "";
foreach $line (@contents){
	($name, $extension) = split (/\./, $line);
	$checked = "";
	if ($line eq "$memsettings[13]") { $checked = "selected"; }
	if ($memsettings[13] =~ /^\http:\/\// && $line eq "blank.gif") { $checked = "selected"; }
	if ($extension eq "gif" || $extension eq "jpg"){
	if ($line eq "blank.gif") { $name = "$txt{'422'}"; }
	$images .= "<option value=\"$line\" $checked>$name\n";
}
}

print <<"EOT";
      <tr>
	<td align="right"><font size=2>$txt{'229'}:</font></td>
      <td>
<script language="javascript">
function showimage()
{
document.images.icons.src="$facesurl/"+document.creator.userpic.options[document.creator.userpic.selectedIndex].value;
}
</script>
<select name="userpic" size=6 onChange="showimage()">$images</select>
EOT
if ($memsettings[13] =~ /^\http:\/\//) { $pic = "blank.gif"; }
else { $pic = "$memsettings[13]"; }
print <<"EOT";
&nbsp;&nbsp;<img src="$facesurl/$pic" name="icons" border=0 hspace=15>
	</td>
<td width="150"><font size=2>$txt{'474'}<BR>$userpic_limits</font></td>
      </tr><tr>
EOT
if ($memsettings[13] =~ /^\http:\/\//) {
	$checked = "checked";
	$tmp = "$memsettings[13]";
}
else { $tmp = "http://"; }
print <<"EOT";
	<td align="right"><font size="2">$txt{'475'}</font></td>
	<td><input type="checkbox" name="userpicpersonalcheck" $checked>
	<input type="text" name="userpicpersonal" size="45" value="$tmp"></td>
      </tr><tr>
	<td colspan=2><hr size=1 noshade></td>
      </tr><tr>
	<td colspan=2><font size=2>$txt{'479'}:</font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'486'}:</font></td>
	<td width="50">
EOT
if ($memsettings[17] == 6) { $tsl6 = " selected" } elsif ($memsettings[17] == 5) { $tsl5 = " selected" } elsif ($memsettings[17] == 4) { $tsl4 = " selected" } elsif ($memsettings[17] == 3) { $tsl3 = " selected" } elsif ($memsettings[17] == 2) { $tsl2 = " selected" } elsif ($memsettings[17] == 1) { $tsl1 = " selected"
} elsif ($timeselected == 6) { $tsl6 = " selected" } elsif ($timeselected == 5) { $tsl5 = " selected" } elsif ($timeselected == 4) { $tsl4 = " selected" } elsif ($timeselected == 3) { $tsl3 = " selected" } elsif ($timeselected == 2) { $tsl2 = " selected" } else { $tsl1 = " selected" }
print <<"EOT";
	<select name="usertimeselect" size=1>
	 <option value="1"$tsl1>$txt{'480'}
	 <option value="5"$tsl5>$txt{'484'}
	 <option value="4"$tsl4>$txt{'483'}
	 <option value="2"$tsl2>$txt{'481'}
	 <option value="3"$tsl3>$txt{'482'}
	 <option value="6"$tsl6>$txt{'485'}
	</select>
	</td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'371'}:</font></td>
	<td><font size=2><input name=usertimeoffset size=5 maxlength=5 value=$memsettings[18]> $txt{'519'}</td>
      </tr><tr>
	<td colspan=2><hr size=1 noshade></td>
      </tr><tr>
	<td align="right" valign=top><font size=2>$txt{'85'}:</font></td>
	<td><font size=2><textarea name=signature rows=4 cols=50 wrap=virtual>$signature</textarea></td>
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
	<td align="right"><font size=2>$txt{'86'}: </font></td>
	<td><font size=2><input type=text name=settings6 size=4 value="$memsettings[6]"></font></td>
      </tr><tr>
	<td align="right"><font size=2>$txt{'87'}: </font></td>
	<td><font size=2><select name="settings7">
	 <option value="$memsettings[7]">$tt
	 <option value="$memsettings[7]">---------------
EOT
if($username eq "admin") {
	print<<"EOT";
         <option value="">
EOT
}
print<<"EOT";
	 $position
	</select></font></td>
      </tr><tr>
EOT
if($settings[7] eq "Administrator") {
print "<td align=right>";
print "<font size=2 face=\"verdana, arial, helvetica\">";
print "$txt{'233'}:<\/b>";
print "<\/td>";
print "<td>";
print "<font size=2 face=\"arial, helvetica\">";
print "<input type=text name=dr size=20 value=\"$dr\">";
print "<br>($txt{'421'})";
print "<\/td>";
}
print <<"EOT";
      </tr><tr>
	<td align=center colspan=2>
	<input type=hidden name="settings8" value="$memsettings[8]">
EOT
	} else {
		print <<"EOT";
      <tr>
	<td align=center colspan=2>
	<input type=\"hidden\" name=\"dr\" value=\"$dr\">
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
	$FORM{'name'} =~ s/\A\s+//;
	$FORM{'name'} =~ s/\s+\Z//;
	if ($INFO{'username'} =~ /\//){ &fatal_error("$txt{'224'}" ); }
	if ($INFO{'username'} =~ /\\/){ &fatal_error("$txt{'225'}" ); }
	&fatal_error("$txt{'213'}") if($FORM{'passwrd1'} ne "$FORM{'passwrd2'}");
	&fatal_error("$txt{'91'}") if($FORM{'passwrd1'} eq "");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq "");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq " ");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq "|");
	&fatal_error("$txt{'76'}") if($FORM{'email'} eq "");
	&fatal_error("$txt{'243'}") if($FORM{'email'} !~ /^[0-9A-Za-z@\._\-]+$/);
	&fatal_error("$txt{'500'}") if(($FORM{'email'} =~ /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|(\.$)/) || ($FORM{'email'} !~ /^.+@\[?(\w|[-.])+\.[a-zA-Z]{2,4}|[0-9]{1,4}\]?$/));

	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	close(FILE);
	for ($a = 0; $a < @memberlist; $a++) {
		$memberlist[$a] =~ s/[\n\r]//g;
		open(FILE2, "$memberdir/$memberlist[$a].dat");
		&lock(FILE2);
		@check_settings=<FILE2>;
		&unlock(FILE2);
		close(FILE2);
		$check_settings[1] =~ s/[\n\r]//g;
		if (lc $check_settings[1] eq lc $FORM{'name'} && $memberlist[$a] ne $username && $settings[7] ne "Administrator") {
		&fatal_error("($FORM{'name'}) $txt{'473'}"); }
	}
	open(FILE, "$vardir/reserve.txt");
	&lock(FILE);
	@reserve = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, "$vardir/reservecfg.txt");
	&lock(FILE);
	@reservecfg = <FILE>;
	&unlock(FILE);
	close(FILE);
	$reservecfg[0] =~ s/[\n\r]//g;
	$reservecfg[1] =~ s/[\n\r]//g;
	$reservecfg[2] =~ s/[\n\r]//g;
	$reservecfg[3] =~ s/[\n\r]//g;
	$matchword = $reservecfg[0];
	$matchcase = $reservecfg[1];
	$matchuser = $reservecfg[2];
	$matchname = $reservecfg[3];
	if ($matchcase ne "checked") { $namecheck = lc $FORM{'name'}; }
	else { $namecheck = $FORM{'name'}; }

	foreach $reserved (@reserve) {
		$reserved =~ s/[\n\r]//g;
		if ($matchcase eq "checked") { $reservecheck = $reserved; }
	   	    else { $reservecheck = lc $reserved; }
		if ($matchname eq "checked") {
			if ($matchword eq "checked") {
			    if ($namecheck eq $reservecheck && $settings[7] ne "Administrator") { &fatal_error("The name you tried to register contains reserved name $reserved. Please try another name."); }
			}
			else {
				if ($namecheck =~ $reservecheck && $settings[7] ne "Administrator") { &fatal_error("The name you tried to register contains reserved name $reserved. Please try another name."); }
			}
		}
	}

	if($FORM{'moda'} eq "$txt{'88'}") {
	        $FORM{'passwrd1'} =~ s/[\n\r]//g;
	        $FORM{'settings6'} =~ s/[\n\r]//g;
	        $FORM{'settings7'} =~ s/[\n\r]//g;
	        $FORM{'icq'} =~ s/[^0-9]//g;
	        $FORM{'age'} =~ s/[^0-9]//g;
	        $FORM{'signature'} =~ s/</&lt;/g;
	        $FORM{'signature'} =~ s/</&gt;/g;

	        $FORM{'aim'} =~ s/ /\+/g;
	        $FORM{'yim'} =~ s/ /\+/g;

		&ToHTML($FORM{'age'});
		&ToHTML($FORM{'location'});
		&ToHTML($FORM{'aim'});
		&ToHTML($FORM{'yim'});
		&ToHTML($FORM{'gender'});
		&ToHTML($FORM{'userpic'});
		&ToHTML($FORM{'usertext'});
		&ToHTML($FORM{'websiteurl'});
		&ToHTML($FORM{'websitetitle'});
		&ToHTML($FORM{'email'});
		&ToHTML($FORM{'name'});

		$memsettings[18] = $FORM{'usertimeoffset'} ;
		$memsettings[18] =~ tr/,/./;
		$memsettings[18] =~ s/[^\d*|\.|\-|w*]//g;
		if (( $memsettings[18] < -23.5) || ( $memsettings[17] > 23.5)) { &fatal_error("$txt{'487'}"); }

		if($settings[7] eq "Administrator") { open(FILE, ">$memberdir/$FORM{'username'}.dat"); }
		else { open(FILE, ">$memberdir/$username.dat"); }

		&lock(FILE);
		print FILE "$FORM{'passwrd1'}\n";
		print FILE "$FORM{'name'}\n";
		print FILE "$FORM{'email'}\n";
		print FILE "$FORM{'websitetitle'}\n";
		print FILE "$FORM{'websiteurl'}\n";
		$FORM{'signature'} =~ s/\n/\&\&/g;
		$FORM{'signature'} =~ s/\r//g;
		print FILE "$FORM{'signature'}\n";
	        if($settings[7] eq "Administrator") {
	            print FILE "$FORM{'settings6'}\n";
	            print FILE "$FORM{'settings7'}\n";
	        } else {
	            print FILE "$settings[6]\n";
	            print FILE "$settings[7]\n";
	        }
		print FILE "$FORM{'icq'}\n";
		print FILE "$FORM{'aim'}\n";
		print FILE "$FORM{'yim'}\n";
		print FILE "$FORM{'gender'}\n";
		$FORM{'usertext'} =~ s~(\S{15})(?=\S)~$1 ~g;
		print FILE "$FORM{'usertext'}\n";
		if( $FORM{'userpicpersonal'} =~ m/\.gif\Z/i || $FORM{'userpicpersonal'} =~ m/\.jpg\Z/i || $FORM{'userpicpersonal'} =~ m/\.jpeg\Z/i || $FORM{'userpicpersonal'} =~ m/\.png\Z/i ) {
			print FILE qq~$FORM{'userpicpersonal'}\n~;
		}
		else {
			print FILE qq~$FORM{'userpic'}\n~;
		}
		print FILE "$FORM{'dr'}\n";
		print FILE "$FORM{'location'}\n";
		print FILE "$FORM{'age'}\n";
		print FILE "$FORM{'usertimeselect'}\n";
		print FILE "$memsettings[18]\n";

		&unlock(FILE);
		close(FILE);

		if (($settings[7] eq "Administrator") && ($FORM{'username'} eq "$username")) {
			$password = crypt("$FORM{'passwrd1'}",$pwseed);
			print 'Set-Cookie: ' . $cookieusername . '=' . $FORM{'username'} . ';';
			print ' expires=' . $Cookie_Exp_Date . ';';
			print "\n";
			print 'Set-Cookie: ' . $cookiepassword . '=' . $password . ';';
			print ' expires=' . $Cookie_Exp_Date . ';';
			print "\n";
			print "Location: $cgi\&action=viewprofile\&username=$FORM{'username'}\n\n";
		}
		if($settings[7] eq "Administrator") {
	            print "Location: $cgi\&action=viewprofile\&username=$FORM{'username'}\n\n";
	        } else {
			$password = crypt("$FORM{'passwrd1'}",$pwseed);
			print 'Set-Cookie: ' . $cookieusername . '=' . $FORM{'username'} . ';';
			print ' expires=' . $Cookie_Exp_Date . ';';
			print "\n";
			print 'Set-Cookie: ' . $cookiepassword . '=' . $password . ';';
			print ' expires=' . $Cookie_Exp_Date . ';';
			print "\n";
	            	print "Location: $cgi\&action=viewprofile\&username=$username\n\n";
	        }

	} else {

		if($settings[7] eq "Administrator") {
			unlink("$memberdir/$FORM{'username'}.dat");
			unlink("$memberdir/$FORM{'username'}.msg");
			unlink("$memberdir/$FORM{'username'}.log");
	                unlink("$memberdir/$FORM{'username'}.outbox");
	                unlink("$memberdir/$FORM{'username'}.imconfig");
		} else {
			unlink("$memberdir/$username.dat");
			unlink("$memberdir/$username.msg");
			unlink("$memberdir/$username.log");
	                unlink("$memberdir/$username.outbox");
	                unlink("$memberdir/$username.imconfig");
		}

		opendir (DIRECTORY,"$datadir");
		@dirdata = readdir(DIRECTORY);
		closedir (DIRECTORY);
		@datdata = grep(/mail/,@dirdata);

		foreach $filename (@datdata) {

			open(FILE, "$datadir/$filename");
			&lock(FILE);
			@entries = <FILE>;
			&unlock(FILE);
			close(FILE);

			if($settings[7] eq "Administrator") {
				$umail=$FORM{'email'};
			} else {
				$umail=$settings[2];
			}

			open(FILE, ">$datadir/$filename");
			&lock(FILE);
			foreach $entry (@entries) {
				$entry =~ s/[\n\r]//g;
				if ($entry ne $umail) {
					print FILE "$entry\n";
				}
			}
			&unlock(FILE);
			close(FILE);

		}

		open(FILE, "$memberdir/memberlist.txt");
		&lock(FILE);
		@members = <FILE>;
		&unlock(FILE);
		close(FILE);
		open(FILE, ">$memberdir/memberlist.txt");
		&lock(FILE);
		my $memberfound = 0;
		my $lastvalidmember = '';
		foreach $curmem (@members) {
			chomp $curmem;
			if($curmem ne $FORM{'username'}) { print FILE "$curmem\n"; $lastvalidmember = $curmem; }
			else { ++$memberfound; }
		}
		&unlock(FILE);
		close(FILE);
		my $membershiptotal = @members - $memberfound;
		open(FILE, ">$vardir/members.ttl");
		&lock(FILE);
		print FILE qq~$membershiptotal|$lastvalidmember~;
		&unlock(FILE);
		close(FILE);
		if($settings[7] eq 'Administrator') {
			print "Location: $cgi\n\n";
		} else {
			print "Location: $boardurl/YaBB.pl?action=logout\n\n";
		}
	}
	exit;
}

sub ViewProfile {
	if ($INFO{'username'} =~ /\//){ &fatal_error("$txt{'224'}" ); }
	if ($INFO{'username'} =~ /\\/){ &fatal_error("$txt{'225'}" ); }
	if(!-e ("$memberdir/$INFO{'username'}.dat")){ &fatal_error("$txt{'453'}"); }
	$yytitle = "$txt{'92'} $INFO{'username'}";
	&header;
	open(FILE, "$memberdir/$INFO{'username'}.dat");
	&lock(FILE);
	@memsettings=<FILE>;
	&unlock(FILE);
	close(FILE);

	$memsettings[0] =~ s/[\n\r]//g;
	$memsettings[1] =~ s/[\n\r]//g;
	$memsettings[2] =~ s/[\n\r]//g;
	$memsettings[3] =~ s/[\n\r]//g;
	$memsettings[4] =~ s/[\n\r]//g;
	$memsettings[5] =~ s/[\n\r]//g;
	$memsettings[6] =~ s/[\n\r]//g;
	$memsettings[7] =~ s/[\n\r]//g;
	$memsettings[8] =~ s/[\n\r]//g;
	$memsettings[9] =~ s/[\n\r]//g;
	$memsettings[10] =~ s/[\n\r]//g;
	$memsettings[11] =~ s/[\n\r]//g;
	$memsettings[12] =~ s/[\n\r]//g;
	$memsettings[13] =~ s/[\n\r]//g;
	$memsettings[14] =~ s/[\n\r]//g;
	$memsettings[15] =~ s/[\n\r]//g;
	$memsettings[16] =~ s/[\n\r]//g;
	$memsettings[17] =~ s/[\n\r]//g;
	$memsettings[18] =~ s/[\n\r]//g;
	$icq = $memsettings[8];
	$dr = "";
	if ($memsettings[14] eq "") { $dr = "$txt{'470'}"; }
	else { $dr = "$memsettings[14]"; }

	open(FILE, "$vardir/membergroups.txt");
	&lock(FILE);
	@membergroups = <FILE>;
	&unlock(FILE);
	close(FILE);

	$memberinfo = "$membergroups[2]";
	if($memsettings[6] > 50) { $memberinfo = "$membergroups[3]"; }
	if($memsettings[6] > 100) { $memberinfo = "$membergroups[4]"; }
	if($memsettings[7] ne "") { $memberinfo = "$memsettings[7]"; }
	if($memsettings[7] eq "Administrator") { $memberinfo = "$membergroups[0]"; }

	print <<"EOT";
<table border=0 width=300 cellpadding=2 cellspacing=2 bgcolor="$color{'bordercolor'}" align="center">
  <tr>
    <td class="title1">
    <table border=0 cellspacing=0 cellpadding=0 width=100% bgcolor="$color{'bordercolor'}">
      <tr>
	<td class="title1"><font size=2 class="text1" color="$color{'titletext'}">$txt{'35'}: $INFO{'username'}</font></td>
	<td align="center" class="title1">
EOT
	if ($username eq $INFO{'username'} || $settings[7] eq "Administrator") {
		print <<"EOT";
	<font size=2><a href="$cgi&action=profile&username=$INFO{'username'}"><font class="text1" color="$color{'titletext'}"><< $txt{'17'} >></font></a></font>
EOT
	}
		print <<"EOT";
	</td>
	<td align="right" class="title1"><font size=2 class="text1" color="$color{'titletext'}">$txt{'232'}</font></td>
      </tr><tr height="100%">
	<td bgcolor="$color{'windowbg'}" colspan=2>
	<table border=0 width=400>
	  <tr>
	    <td align="right"><font size=2>$txt{'68'}: </font></td>
	    <td><font size=2>$memsettings[1]</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'69'}: </font></td>
	    <td><font size=2><a href="mailto:$memsettings[2]">$memsettings[2]</a></font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'231'}: </font></td>
	    <td><font size=2>
EOT
	if ($memsettings[11] eq "Male") { print "$txt{'238'}"; }
	if ($memsettings[11] eq "Female") { print "$txt{'239'}"; }

print <<"EOT";
	    </font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'420'}:</font></td>
	    <td><font size=2>$memsettings[16]</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'227'}: </font></td>
	    <td><font size=2>$memsettings[15]</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'96'}: </font></td>
	    <td><font size=2><a href="$memsettings[4]" target=_blank>$memsettings[3]</a></font></td>
	  </tr><tr>
	    <td align="right"><font size=2>ICQ: </font></td>
	    <td><font size=2><a href="$cgi&action=icqpager&UIN=$icq" target=_blank>$memsettings[8]</a></font></td>
	  </tr><tr>
	    <td align="right"><font size=2>AIM: </font></td>
	    <td><font size=2>$memsettings[9]</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>YIM: </font></td>
	    <td><font size=2>$memsettings[10]</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'86'}: </font></td>
	    <td><font size=2>$memsettings[6]</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'87'}: </font></td>
	    <td><font size=2>$memberinfo</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'233'}: </font></td>
	    <td><font size=2>$dr</font></td>
	  </tr><tr>
	    <td align="right"><font size=2>$txt{'148'}: </font></td>
	    <td><font size=2><a href="$cgi&action=imsend&to=$INFO{'username'}">[>>]</a></font></td>
	  </tr>
	</table>
	</td>
	<td width="100%" height="100%" bgcolor="$color{'windowbg'}" valign="middle">
EOT
	if ($memsettings[13] =~ /^\http:\/\// ) {
		if ($userpic_width ne 0) { $tmp_width = "width=$userpic_width"; } else { $tmp_width=""; }
		if ($userpic_height ne 0) { $tmp_height = "height=$userpic_height"; } else { $tmp_height=""; }
			print qq~<center><a href="$memsettings[13]" target="_blank" onClick="window.open('$memsettings[13]', 'ppic$INFO{username}', 'resizable,width=200,height=200'); return false;">~;
			print qq~<img src="$memsettings[13]" $tmp_width $tmp_height border=0><\/a><BR><BR>~;
		}
		else {
			print qq~<center><a href="$facesurl/$memsettings[13]" target="_blank" onClick="window.open('$facesurl/$memsettings[13]', 'ppic$INFO{username}', 'resizable,width=200,height=200'); return false;">~;
			print qq~<img src="$facesurl/$memsettings[13]" border=0></a><BR><BR>~;
		}
print <<"EOT";
	<font size=2>$memsettings[12]</font></center></td>
      </tr><tr>
	<td colspan=3>
	<table border=0 cellspacing=1 cellpadding=0 width=100%>
	  <tr>
	    <td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'459'}:</font></td>
	  </tr><tr>
	    <td width="100%" height="100%" bgcolor="$color{'windowbg'}" valign="middle" align="center">
	    <font size=2><form action="$cgi&action=usersrecentposts&username=$INFO{'username'}" method="POST">
	    $txt{'460'} <select name="viewscount" size="1">
	     <option value="5">5</option>
	     <option value="10" selected>10</option>
	     <option value="50">50</option>
	     <option value="0">$txt{'190'}</option>
	    </select> $txt{'461'} <input type=submit value="$txt{'462'}">
	    </form></font></td>
	  </tr>
	</table>
	</td>
      </tr>
    </table>
    </td>
  </tr>
</table>
EOT
	&footer;
	exit;
}

sub usersrecentposts {
	require "$sourcedir/Display.pl";
	&readform;
	$display = $FORM{'viewscount'};

	open(FILE, "$memberdir/$INFO{'username'}.dat") || &fatal_error("$txt{'23'} $INFO{'username'}.txt");
	&lock(FILE);
	@memset = <FILE>;
	&unlock(FILE);
	close(FILE);

	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);

	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
	}
	&unlock(FILE);
	close(FILE);

	%data= ();

	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/[\n\r]//g;
		foreach(split(/\,/,$catinfo[1])) {
			$membergroups{$_} = $_;
		}
		if($catinfo[1] ne "") {
			if($settings[7] ne "Administrator" && !exists $membergroups{$settings[7]}) {
				next;
			}
		}
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/[\n\r]//g;
				open(BOARDDATA, "$boardsdir/$curboard.txt");
				&lock(BOARDDATA);
				@messages = <BOARDDATA>;
				&unlock(BOARDDATA);
				close(BOARDDATA);

				open(BOARDDATA, "$boardsdir/$curboard.dat");
				&lock(BOARDDATA);
				@boardinfo = <BOARDDATA>;
				&unlock(BOARDDATA);
				close(BOARDDATA);


			for ($a = 0; $a < @messages; $a++) {
				($yytitle[0], $yytitle[1], $yytitle[2], $yytitle[3], $yytitle[4], $yytitle[5], $yytitle[6], 	$yytitle[7], $yytitle[8]) = split(/\|/, $messages[$a]);
				foreach (@censored) {
					($tmpa,$tmpb) = @{$_};
					$yytitle[1] =~ s~\Q$tmpa\E~$tmpb~gi;
				}
			#### output ####
				open (TEXT, "$datadir/$yytitle[0].txt") || &fatal_error("$txt{'23'} $yytitle[0].txt");
				@text = <TEXT>;
				close(TEXT);

				for ($c = 0; $c < @text; $c++) {
					($msub, $mname, $memail, $mdate, $musername, $micon, $mattach, $mip, $mmessage, $mns) = split(/\|/,$text[$c]);

					$message = $mmessage;


					foreach (@censored) {
						($tmpa,$tmpb) = @{$_};
						$message =~ s~\Q$tmpa\E~$tmpb~gi;
						$msub =~ s~\Q$tmpa\E~$tmpb~gi;
					}

					if($enable_ubbc) { &DoUBBC; }

					$board = "$curboard";

					$post=<<"EOT";
	<td width=75% bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=2>&nbsp;$catinfo[0] / $boardinfo[0] / <a href="$boardurl/YaBB.pl?board=$board&action=display&num=$yytitle[0]"><font class="text1" color="$color{'titletext'}" size=2>$yytitle[1]</font></a></font></td>
	<td align=right bgcolor="$color{'titlebg'}"><nobr>&nbsp;<font class="text1" color="$color{'titletext'}" size=2>$txt{'30'}: $mdate&nbsp;</font></nobr></td>
</tr>
<tr height=80>
	<td colspan=3 bgcolor="$color{'windowbg2'}" valign=top><font size=2>$message</font></td>
</tr>
<tr>
	<td colspan=3 bgcolor="$color{'catbg'}"><font size=2>
		&nbsp;<a href="$cgi$board&action=post&num=$yytitle[0]&title=Post+reply&start=0">$txt{'146'}</a> |
		<a href="$cgi$board&action=post&num=$yytitle[0]&quote=0&title=Post+reply&start=0">$txt{'145'}</a> |
		<a href="$cgi$board&action=notify&thread=$yytitle[0]">$txt{'125'}</a>
	</font></td>
</tr>
</table><br>
EOT

					($date1, $time1) = split(/ at /, $mdate);
					($month1, $day1, $year1) = split(/\//, $date1);
					($hour1, $min1, $sec1) = split (/:/, $time1);
					$totaltime1 = (($year1+2000)*365+$month1*30+$day1)*24*60*60+$hour1*60*60+$min1*60;
					if ($INFO{'username'} eq $musername) { $data{$totaltime1}= $post; }
				}
			}
			}
		}
	}

	$yytitle = "$txt{'458'} $memset[1]";
	&header;

print "\n<font face=\"Verdana, Arial\" size=2>\n";
print "<p align=left><a href=\"$cgi&action=viewprofile&username=$INFO{'username'}\"><font size=2>$txt{'92'} $memset[1]</font></a></p><p>\n";

	@num = sort {$b <=> $a } keys %data;
	$j=0;
	if ($display ne "0") {
		while ($j<$display && $data{$num[$j]} ne ""){
		$j2 = $j + 1;
		print <<"EOT";
<table border=0 width=100% cellspacing=1 $color{'bordercolor'}>
<tr>
	<td align=left bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=2>&nbsp;$j2&nbsp;</font></td>
EOT
		print "$data{$num[$j]}";
		$j++;
		}
	} else {
		while ($data{$num[$j]} ne ""){
		$j2 = $j + 1;
		print <<"EOT";
<table border=0 width=100% cellspacing=1 $color{'bordercolor'}>
<tr>
	<td align=left bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=2>&nbsp;$j2&nbsp;</font></td>
EOT
		print "$data{$num[$j]}";
		$j++;
		}
	}

print "<p align=left><a href=\"$cgi&action=viewprofile&username=$INFO{'username'}\"><font size=2>$txt{'92'} $memset[1]</font></a></p><p>\n";
print "\n</font>\n\n";

	&footer;
	exit;
}

sub ToHTML {
	@_[0] =~ s/</&lt;/g;
	@_[0] =~ s/>/&gt;/g;
	@_[0] =~ s/\|/\&#124;/g;
	@_[0] =~ s/  / \&nbsp;/g;
}

sub FromHTML {
	@_[0] =~ s/&lt;/</g;
	@_[0] =~ s/&gt;/>/g;
	@_[0] =~ s/\&#124;/\|/g;
	@_[0] =~ s/\&nbsp;/ /g;
}

sub RemoveLineFeeds {
	@_[0] =~ s/[\n\r]//g;
}

1;