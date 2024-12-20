###############################################################################
# LogInOut.pl                                                                 #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub Login {
	$title = "$txt{'34'}";
	&header;
	print <<"EOT";
<table border=0 width=300 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'34'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><form action="$cgi\&action=login2" method="POST">
<table border=0>
<tr>
	<td><b>$txt{'35'}:</b></td>
	<td><input type=text name="username" size=20></td>
</tr>
<tr>
	<td><b>$txt{'36'}:</b></td>
	<td><input type=password name="passwrd" size=20></td>
</tr>
<tr>
	<td align=center colspan=2><input type=submit value="$txt{'34'}"></td>
</tr>
<tr><td align=center colspan=2><small><small><a href="Reminder.pl?action=input_user">Forgot password?</small></small></a></td></tr>
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
	
	if(-e("$memberdir/$FORM{'username'}.dat")) {
		open(FILE, "$memberdir/$FORM{'username'}.dat");
		&lock(FILE);
		@settings = <FILE>;
		&unlock(FILE);
		close(FILE);
		$settings[0] =~ s/\n//g;
		$settings[0] =~ s/\r//g;
		if($settings[0] ne "$FORM{'passwrd'}") { &fatal_error("$txt{'39'}"); }
		$settings[0] = "$settings[0]\n";
	} else {
		&fatal_error("$txt{'40'}");
	}
#	&SetCookies('$cookieusername',$FORM{'username'});
	print 'Set-Cookie: ' . $cookieusername . '=' . $FORM{'username'} . ';';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print 'Set-Cookie: ' . $cookiepassword . '=' . $FORM{'passwrd'} . ';';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";

#	&SetCookies('$cookiepassword',$FORM{'passwrd'});
	print "Location: $cgi\n\n";
}

sub Logout {
	print 'Set-Cookie: ' . $cookieusername . '=;';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print 'Set-Cookie: ' . $cookiepassword . '=;';
	print ' expires=' . $Cookie_Exp_Date . ';';
	print "\n";
	print "Location: $cgi\n\n";
}

1;