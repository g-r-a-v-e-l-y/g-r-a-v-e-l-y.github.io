###############################################################################
# LockThread.pl                                                               #
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

$lockthreadplver="1 Gold Beta4";

sub LockThread {

	if((!exists $moderators{$username}) && $settings[7] ne "Administrator") { &fatal_error("$txt{'93'}"); }

	open (F, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(F);
	@threads = <F>;
	&unlock(F);
	close (F);
	open (F, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(F);
	for ($a = 0; $a < @threads; $a++) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/,$threads[$a]);
		$mstate =~ s/[\n\r]//g;
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