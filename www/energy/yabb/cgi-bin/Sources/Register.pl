###############################################################################
# Register.pl                                                                 #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub Register {
	$title = "$txt{'97'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'97'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font><form action="$cgi\&action=register2" method="POST">
<table border=0>
<tr>
	<td><font><b>$txt{'98'}:</b></font></td>
	<td><font><input type=text name=username size=20></font></td>
</tr>
<tr>
	<td><font><b>$txt{'81'}:</b></font></td>
	<td><font><input type=password name=passwrd1 size=20></font></td>
</tr>
<tr>
	<td><font><b>$txt{'82'}:</b></font></td>
	<td><font><input type=password name=passwrd2 size=20></font></td>
</tr>
<tr>
	<td><font><b>$txt{'68'}:</b></font></td>
	<td><font><input type=text name=name size=50></font></td>
</tr>
<tr>
	<td><font><b>$txt{'69'}:</b></font></td>
	<td><font><input type=text name=email size=50></font></td>
</tr>
<tr>
	<td><font><b>ICQ:</b></font></td>
	<td><font><input type=text name=icq size=50></font></td>
</tr>
<tr>
	<td><font><b>$txt{'83'}:</b></font></td>
	<td><font><input type=text name=websitetitle size=50></font></td>
</tr>
<tr>
	<td><font><b>$txt{'84'}:</b></font></td>
	<td><font><input type=text name=websiteurl size=50 value="http://"></font></td>
</tr>
<tr>
	<td valign=top><font><b>$txt{'85'}:</b></font></td>
	<td><font><textarea name=signature rows=4 cols=50 wrap=virtual></textarea></td>
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
	&fatal_error("$txt{'37'}") if($FORM{'username'} eq "");
	&fatal_error("$txt{'99'}") if($FORM{'username'} =~ " ");
	&fatal_error("$txt{'90'}") if($FORM{'passwrd1'} ne "$FORM{'passwrd2'}");
	&fatal_error("$txt{'91'}") if($FORM{'passwrd1'} eq "");
	&fatal_error("$txt{'75'}") if($FORM{'name'} eq "");
	&fatal_error("$txt{'76'}") if($FORM{'email'} eq "");
	&fatal_error("$txt{'100'}") if(-e ("$memberdir/$FORM{'username'}.dat"));
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
	print FILE "0\n\n$FORM{'icq'}\n"; # Number of posts
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
	$title="Registration successfull";
	&header;
	print <<"EOT";
<table border=0 width=300 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'97'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font><form action="$cgi\&action=login2" method="POST">
<input type=hidden name="username" value="$FORM{'username'}">
<input type=hidden name="passwrd" value="$FORM{'passwrd1'}">
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