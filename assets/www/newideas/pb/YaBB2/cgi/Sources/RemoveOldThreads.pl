###############################################################################
# RemoveOldThreads.pl                                                         #
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

$removeoldthreadsplver="1 Gold Beta4";

sub RemoveOldThreads {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$yytitle = "$txt{'120'} $FORM{'maxdays'}";
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$vardir/oldestmes.txt");
	&lock(FILE);
	print FILE "$FORM{'maxdays'}";
	&unlock(FILE);
	close(FILE);
	&header;
	foreach $curcat (@categories) {
		chomp $curcat;
		open(FILE, "$boardsdir/$curcat.cat");
		&lock(FILE);
		$curcatname = <FILE>;
		$curcataccess = <FILE>;
		chomp $curcatname;
		chomp $curcataccess;
		@catinfo = <FILE>;
		&unlock(FILE);
		close(FILE);
		$date2 = $date;
		foreach $curboard (@catinfo) {
			chomp $curboard;
			open(FILE, "$boardsdir/$curboard.txt");
			&lock(FILE);
			@messages = <FILE>;
			&unlock(FILE);
			close(FILE);
			open(FILE, ">$boardsdir/$curboard.txt");
			&lock(FILE);
			for ($a = 0; $a < @messages; $a++) {
				($num, $dummy, $dummy, $dummy, $date1) = split(/\|/, $messages[$a]);
				&calcdifference;
				if($result <= $FORM{'maxdays'}) {
					# If the message is not too old
					print FILE $messages[$a];
					print "$num = $result $txt{'122'}<br>";
				} else {
					print "$num = $result $txt{'122'} ($txt{'123'})<br>";
					unlink("$datadir/$num.txt");
					unlink("$datadir/$num.mail");
					unlink("$datadir/$num.data");
				}
			}
			&unlock(FILE);
			close(FILE);
			&BoardCountTotals($curboard);
		}
	}
	&footer;
	exit;
}
1;