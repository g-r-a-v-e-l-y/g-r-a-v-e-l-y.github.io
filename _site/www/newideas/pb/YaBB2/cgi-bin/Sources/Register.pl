###############################################################################
# Register.pl                                                                 #
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

$registerplver="1 Gold Beta4";

sub Register {
	$yytitle = "$txt{'97'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'97'} $txt{'517'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi\&action=register2" method="POST" name="creator">
<table border=0>
<tr>
	<td align="right"><font size=2>* $txt{'98'}: </font></td>
	<td><font size=2><input type=text name=username size=20> $txt{'520'}</font></td>
</tr>
<tr>
	<td align="right"><font size=2>* $txt{'81'}: </font></td>
	<td><font size=2><input type=password name=passwrd1 size=20></font></td>
</tr>
<tr>
	<td align="right"><font size=2>* $txt{'82'}: </font></td>
	<td><font size=2><input type=password name=passwrd2 size=20></font></td>
</tr>
<tr>
	<td align="right"><font size=2>* $txt{'68'}: </font></td>
	<td><font size=2><input type=text name=name size=30> $txt{'518'}</font></td>
</tr>
<tr>
	<td align="right"><font size=2>* $txt{'69'}: </font></td>
	<td><font size=2><input type=text name=email size=30></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'231'}: </font></td>
	<td>
	<select name="gender" size="1">
	<option value="" selected></option>
	<option value="Male">$txt{'238'}</option>
	<option value="Female">$txt{'239'}</option>
	</select>
	</td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'420'}:</font></td>
	<td><font size=2><input type=text name=age size=3 maxlength=2></font></td>
</tr>
<tr>
	<td colspan=2>
	<BR><BR><font size=2>________ $txt{'226'}: ________</font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'227'}: </font></td>
	<td><font size=2><input type=text name=location size=50></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'83'}: </font></td>
	<td><font size=2><input type=text name=websitetitle size=50></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'84'}: </font></td>
	<td><font size=2><input type=text name=websiteurl size=50 value="http://"></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'513'} #: </font></td>
	<td><font size=2><input type=text name=icq size=20></font></td>
</tr>
<tr>
	<td align="right"><font size=2>AIM-Name: </font></td>
	<td><font size=2><input type=text name=aim size=20></font></td>
</tr>
<tr>
	<td align="right"><font size=2>YIM-Name: </font></td>
	<td><font size=2><input type=text name=yim size=20></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'228'}: </font></td>
	<td><font size=2><input type=text name=usertext size=50 value="$txt{'209'}"></font></td>
</tr>
EOT
opendir(DIR, "$facesdir") || die "$txt{'230'} ($facesdir) :: $!";
@contents = readdir(DIR);
closedir(DIR);
$images = "";
foreach $line (@contents){
	($name, $extension) = split (/\./, $line);
	$checked = "";
	if ($extension eq "gif" || $extension eq "jpg"){
		if ($line eq "blank.gif") { $name = "$txt{'422'}"; $checked = "selected";}
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

&nbsp;&nbsp;<img src="$facesurl/blank.gif" name="icons" border=0 hspace=15>
</td>
<td width="150"><font size=2>$txt{'474'}<BR>$userpic_limits</font></td>
</tr>
<tr>
	<td align="right"><font size="2">$txt{'475'}</font></td>
	<td><input type="checkbox" name="userpicpersonalcheck">
	<input type="text" name="userpicpersonal" size="45" value="http://"></td>
</tr>
<tr>
      <td colspan=2><hr size=1 noshade></td>
</tr>
<tr>
	<td colspan=2>
	<font size=2>$txt{'479'}:</font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'486'}:</font></td>
	<td width="50">
EOT
if ($timeselected == 6) { $tsl6 = " selected" } elsif ($timeselected == 5) { $tsl5 = " selected" } elsif ($timeselected == 4) { $tsl4 = " selected" } elsif ($timeselected == 3) { $tsl3 = " selected" } elsif ($timeselected == 2) { $tsl2 = " selected" } else { $tsl1 = " selected" }
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
</tr>
<tr>
	<td align="right"><font size=2>$txt{'371'}:</font></td>
	<td><font size=2><input name=usertimeoffset size=5 maxlength=5> $txt{'519'}</font></td>
</tr>
<tr>
      <td colspan=2><hr size=1 noshade></td>
</tr>

<tr>
	<td align="right" valign=top><font size=2>$txt{'85'}: </font></td>
	<td><font size=2><textarea name=signature rows=4 cols=50 wrap=virtual></textarea></td>
</tr>
<tr>
	<td align=center colspan=2><input type=submit value="$txt{'97'}">
	</td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub Register2 {
	$FORM{'username'} =~ s/\A\s+//;
	$FORM{'username'} =~ s/\s+\Z//;
	$FORM{'username'} =~ s/\s/_/g;
	$FORM{'name'} =~ s/\A\s+//;
	$FORM{'name'} =~ s/\s+\Z//;
	&fatal_error("($FORM{'username'}) $txt{'37'}") if($FORM{'username'} eq "");
	&fatal_error("($FORM{'username'}) $txt{'99'}") if($FORM{'username'} eq "_" || $FORM{'username'} eq "|");
	&fatal_error("($FORM{'username'}) $txt{'213'}") if($FORM{'passwrd1'} ne "$FORM{'passwrd2'}");
	&fatal_error("($FORM{'username'}) $txt{'91'}") if($FORM{'passwrd1'} eq "");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq "");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq " ");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq "|");
	&fatal_error("($FORM{'username'}) $txt{'76'}") if($FORM{'email'} eq "");
	&fatal_error("($FORM{'username'}) $txt{'100'}") if(-e ("$memberdir/$FORM{'username'}.dat"));
	&fatal_error("$txt{'240'}") if($FORM{'username'} !~ /^[\s0-9A-Za-z#%+,-\.:?@^_]+$/);
	&fatal_error("$txt{'241'}") if($FORM{'passwrd1'} !~ /^[\s0-9A-Za-z!@#$%\^&*\(\)_\+|`~\-=\\:;'",\.\/?\[\]\{\}]+$/);
	&fatal_error("$txt{'242'}") if($FORM{'name'} !~ /^[\s0-9A-Za-z\[\]#%+,-|\.:=?@^_]+$/);
	&fatal_error("$txt{'243'}") if($FORM{'email'} !~ /^[0-9A-Za-z@\._\-]+$/);
	&fatal_error("$txt{'500'}") if(($FORM{'email'} =~ /(@.*@)|(\.\.)|(@\.)|(\.@)|(^\.)|(\.$)/) || ($FORM{'email'} !~ /^.+@\[?(\w|[-.])+\.[a-zA-Z]{2,4}|[0-9]{1,4}\]?$/));

	$FORM{'username'} =~ s/[\n\r]//g;
	$FORM{'passwrd1'} =~ s/[\n\r]//g;
	$FORM{'icq'} =~ s/[^0-9]//g;
	$FORM{'age'} =~ s/[^0-9]//g;
	$FORM{'signature'} =~ s/</&lt;/g;

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
		if (lc $check_settings[1] eq lc $FORM{'name'}) { &fatal_error("($FORM{'name'}) $txt{'473'}"); }
	}
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

	undef @members;
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@members = <FILE>;
	&unlock(FILE);
	close(FILE);

	foreach $curmem (@members) {
		$curmem =~ s/[\n\r]//g;
		$curmem = lc $curmem;
		if ($curmem eq lc $FORM{'username'}) {
			&fatal_error("$txt{'100'}");
		}
	}

	&fatal_error("$txt{'100'})") if(-e ("$memberdir/$FORM{'username'}.dat"));

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
	$reservecfg[0] =~ s/\n//g;
	$reservecfg[1] =~ s/\n//g;
	$reservecfg[2] =~ s/\n//g;
	$reservecfg[3] =~ s/\n//g;
	$reservecfg[0] =~ s/\r//g;
	$reservecfg[1] =~ s/\r//g;
	$reservecfg[2] =~ s/\r//g;
	$reservecfg[3] =~ s/\r//g;
	$matchword = $reservecfg[0];
	$matchcase = $reservecfg[1];
	$matchuser = $reservecfg[2];
	$matchname = $reservecfg[3];
	if ($matchcase ne "checked") {
	    $usercheck = lc $FORM{'username'};
		$namecheck = lc $FORM{'name'};
	}
	else {
	    $usercheck = $FORM{'username'};
		$namecheck = $FORM{'name'};
	}

	foreach $reserved (@reserve) {
		$reserved =~ s/\n//g;
		$reserved =~ s/\r//g;
		if ($matchcase eq "checked") { $reservecheck = $reserved; }
	   	    else { $reservecheck = lc $reserved; }
		if ($matchuser eq "checked") {
		    if ($matchword eq "checked") {
			    if ($usercheck eq $reservecheck && $settings[7] ne "Administrator") { &fatal_error("$txt{'244'} $reserved"); }
			}
			else {
				if ($usercheck =~ $reservecheck && $settings[7] ne "Administrator") { &fatal_error("$txt{'244'} $reserved"); }
			}
		}
		if ($matchname eq "checked") {
			if ($matchword eq "checked") {
			    if ($namecheck eq $reservecheck && $settings[7] ne "Administrator") { &fatal_error("$txt{'244'} $reserved"); }
			}
			else {
				if ($namecheck =~ $reservecheck && $settings[7] ne "Administrator") { &fatal_error("$txt{'244'} $reserved"); }
			}
		}
	}

	$offset = $FORM{'usertimeoffset'} ;
	$offset =~ tr/,/./;
	$offset =~ s/[^\d*|\.|\-|w*]//g;
	if (( $offset < -23.5) || ( $offset > 23.5)) { &fatal_error("$txt{'487'}"); }

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
	print FILE "0\n";
	print FILE "\n";
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
	print FILE "$date\n";
	print FILE "$FORM{'location'}\n";
	print FILE "$FORM{'age'}\n";
	print FILE "$FORM{'usertimeselect'}\n";
	print FILE "$offset\n";
	&unlock(FILE);
	close(FILE);
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@members = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$memberdir/memberlist.txt");
	&lock(FILE);
	foreach $curmem (@members) {
		print FILE "$curmem";
	}
	print FILE "$FORM{'username'}\n";
	&unlock(FILE);
	close(FILE);

	my $membershiptotal = @members + 1;
	open(FILE, ">$vardir/members.ttl");
	&lock(FILE);
	print FILE qq~$membershiptotal|$FORM{'username'}~;
	&unlock(FILE);
	close(FILE);

	$yytitle="$txt{'245'}";
	&header;
	print <<"EOT";
<BR><BR><BR>
<center>$txt{'431'}</center>
<BR><BR>
<table border=0 width=300 cellspacing=1 bgcolor="$color{'bordercolor'}" align="center">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'97'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" align="center"><font size=2><form action="$cgi\&action=login2" method="POST">
<input type=hidden name="username" value="$FORM{'username'}">
<input type=hidden name="passwrd" value="$FORM{'passwrd1'}">
<input type=hidden name="cookielength" value="$Cookie_Length">
<input type=submit value="$txt{'34'}"></td>
</form></font>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

1;