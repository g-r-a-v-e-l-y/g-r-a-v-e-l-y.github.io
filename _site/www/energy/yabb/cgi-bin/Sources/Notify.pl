###############################################################################
# Notify.pl                                                                   #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub Notify {
	if($username eq "Guest") { &fatal_error("$txt{'138'}"); }
	$title = "$txt{'125'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'125'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
$txt{'126'}<br>
<b><a href="$cgi&action=notify2&thread=$INFO{'thread'}">Yes</a> - <a href="$cgi&action=display&num=$INFO{'thread'}">No</a></b>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub Notify2 {
	if($username eq "Guest") { &error("$txt{'138'}"); }
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
		$curmail =~ s/\n//g;
		$curmail =~ s/\r//g;
		if($settings[2] ne "$curmail") { print FILE "$curmail\n"; }
	}
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=display\&num=$thread\n\n";
	exit;
}

1;