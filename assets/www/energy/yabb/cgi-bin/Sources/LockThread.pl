###############################################################################
# LockThread.pl                                                               #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub LockThread {
	if($username ne "$boardmoderator" && $settings[7] ne "Administrator") { &fatal_error("$txt{'93'}"); }
	open (F, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(F);
	@threads = <F>;
	&unlock(F);
	close (F);
	open (F, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(F);
	for ($a = 0; $a < @threads; $a++) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$a]);
		$mstate =~ s/\n//g;
		$mstate =~ s/\r//g;
		if ($mnum == $INFO{'thread'}) {
			if($mstate==1) { $mstate=0; } else { $mstate=1; }
			print F 	"$mnum\|$msub\|$mname\|$memail\|$mdate\|$mreplies\|$musername\|$micon\|$mstate\n";
		} else { print F "$threads[$a]"; }
	}
	&unlock(F);
	close(F);
	print "Location: $cgi\&action=display\&num=$INFO{'thread'}\n\n";
	exit;
}

1;