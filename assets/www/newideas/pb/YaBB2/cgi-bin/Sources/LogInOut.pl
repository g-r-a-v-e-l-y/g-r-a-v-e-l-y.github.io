###############################################################################
# LogInOut.pl                                                                 #
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

$loginoutplver="1 Gold Beta4";

sub Login {
	$yytitle = "$txt{'34'}";
	&header;
	print <<"EOT";
<table border=0 width=400 cellspacing=1 bgcolor="$color{'bgcolor'}" align="center">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}">$txt{'34'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><form action="$cgi\&action=login2" method="POST">
<table border=0 align="center">
<tr>
	<td align="right">$txt{'35'}:</td>
	<td><input type=text name="username" size=20></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'36'}:</font></td>
	<td><font size=2><input type=password name="passwrd" size=20></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'497'}:</font></td>
	<td><font size=2><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"></font></td>
</tr>
<tr>
	<td align="right"><font size=2>$txt{'508'}:</font></td>
	<td><font size=2><input type=checkbox name="cookieneverexp"></font></td>
</tr>
<tr>
	<td align=center colspan=2><BR><input type=submit value="$txt{'34'}"></td>
</tr>
<tr><td align=center colspan=2><small><small><a href="Reminder.pl?action=input_user">$txt{'315'}</small></small></a></td></tr>
</table></form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub Login2 {
	&fatal_error("$txt{'37'}") if($FORM{'username'} eq "");
	&fatal_error("$txt{'38'}") if($FORM{'passwrd'} eq "");
	$FORM{'username'} =~ s/\s/_/g;
	$username = $FORM{'username'};
	&fatal_error("$txt{'240'}") if($username !~ /^[\s0-9A-Za-z#%+,-\.:=?@^_]+$/);
	&fatal_error("$txt{'337'}") if($FORM{'cookielength'} !~ /^[0-9]+$/);

	if(-e("$memberdir/$username.dat")) {
		open(FILE, "$memberdir/$username.dat");
		&lock(FILE);
		@settings = <FILE>;
		&unlock(FILE);
		close(FILE);
		$settings[0] =~ s/[\n\r]//g;
		if($settings[0] ne "$FORM{'passwrd'}") { &fatal_error("$txt{'39'}"); }
		$settings[0] = "$settings[0]\n";
	}
	else { &fatal_error("$txt{'40'}"); }

	if($FORM{'cookielength'} < 1 || $FORM{'cookielength'} > 6000) { $FORM{'cookielength'} = $Cookie_Length; }
	if($FORM{'cookieneverexp'} ne "on") {
		&SetCookieExp;
		$Cookie_Length = $FORM{'cookielength'};
	}
	else { $Cookie_Exp_Date = 'Sun, 17-Jan-2038 00:00:00 GMT'; }
	$password = crypt("$FORM{'passwrd'}",$pwseed);

	print 'Set-Cookie: ' . $cookieusername . '=' . $username . ';';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print 'Set-Cookie: ' . $cookiepassword . '=' . $password . ';';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	$ENV{'HTTP_COOKIE'} = qq~$cookieusername=$username; $cookiepassword=$password~;
	### Load user settings ###
	&LoadUserSettings;
	### Write log ###
	&WriteLog;

}

sub Logout {
	# Write log
	open(LOG, "$vardir/log.txt");
	&lock(LOG);
	@entries = <LOG>;
	&unlock(LOG);
	close(LOG);
	open(LOG, ">$vardir/log.txt");
	&lock(LOG);
	$field="$username";
	foreach $curentry (@entries) {
	        $curentry =~ s/\n//g;
     		($name, $value) = split(/\|/, $curentry);
	        if($name ne "$field") {
	                print LOG "$curentry\n";
	        }
	}
	&unlock(LOG);
	close(LOG);

	print 'Set-Cookie: ' . $cookieusername . '=;';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print 'Set-Cookie: ' . $cookiepassword . '=;';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	$username = 'Guest';
	$password = '';
	@settings = ();
	$realname = '';
	$realemail = '';
	$ENV{'HTTP_COOKIE'} = '';
	### Write log ###
	&WriteLog;
}

1;