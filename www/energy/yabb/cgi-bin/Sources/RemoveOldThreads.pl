###############################################################################
# RemoveOldThreads.pl                                                         #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub RemoveOldThreads {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$title = "$txt{'120'} $FORM{'maxdays'}";
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
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/\n//g;
		$catinfo[1] =~ s/\r//g;
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/\n//g;
				$curboard =~ s/\r//g;
				open(BOARDDATA, "$boardsdir/$curboard.txt");
				&lock(BOARDDATA);
				@messages = <BOARDDATA>;
				&unlock(BOARDDATA);
				close(BOARDDATA);
				open(BOARDDATA, ">$boardsdir/$curboard.txt");
				for ($a = 0; $a < @messages; $a++) {
					($num, $dummy, $dummy, $dummy, $lp) = split(/\|/, $messages[$a]);
					$date1 = "$lp";
					$date2 = "$date";
					&calcdifference;
					if($result <= $FORM{'maxdays'}) { # If the message is not to old
						print BOARDDATA "$messages[$a]";
						print "$num = $result $txt{'122'}<br>";
					} else { 
						print "$num = $result $txt{'122'} ($txt{'123'})<br>";
						unlink("$datadir/$num.txt");
						unlink("$datadir/$num.mail");
					}
				}
				close(BOARDDATA);
			}
		}
	}
	&footer;
	exit;
}

1;