###############################################################################
# BoardIndex.pl                                                               #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub MoveThread {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'134'}"); }
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'132'}";
	$boardlist="";
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
				$boardlist="$boardlist<option>$curboard";
			}
		}
	}
	############################
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'132'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<form action="$cgi&action=movethread2&thread=$INFO{'thread'}" method="POST">
<b>$txt{'133'}:</b> <select name="toboard">$boardlist</select>
<input type=submit value="Move">
</form>
</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub MoveThread2 {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'134'}"); }
	$thread="$INFO{'thread'}";
	open (FILE, "$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close (FILE);
	open (FILE, ">$boardsdir/$currentboard.txt") || &fatal_error("$txt{'23'} $currentboard.txt");
	&lock(FILE);
	for ($a = 0; $a < @threads; $a++) {
		($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mattach) = split(/\|/,$threads[$a]);
		$mattach =~ s/\n//g;
		$mattach =~ s/\r//g;
		if ($mnum ne "$thread") { print FILE "$threads[$a]"; }
		else { $linetowrite="$threads[$a]"; }
	}
	&unlock(FILE);
	close(FILE);
	
	open (FILE, "$boardsdir/$FORM{'toboard'}.txt") || &fatal_error("$txt{'23'} $INFO{'toboard'}.txt");
	&lock(FILE);
	@threads = <FILE>;
	&unlock(FILE);
	close (FILE);
	open (FILE, ">$boardsdir/$FORM{'toboard'}.txt") || &fatal_error("$txt{'23'} $FORM{'toboard'}.txt");
	&lock(FILE);
	print FILE "$linetowrite";
	foreach $line (@threads) {
		print FILE "$line";
	}
	&unlock(FILE);
	close(FILE);
	
	print "Location: $boardurl/YaBB.pl\?board=$FORM{'toboard'}\&action=display\&num=$INFO{'thread'}\n\n";
	exit;

}

1;