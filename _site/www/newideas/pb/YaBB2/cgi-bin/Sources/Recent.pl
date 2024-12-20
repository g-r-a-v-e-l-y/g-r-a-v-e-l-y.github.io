###############################################################################
# Recent.pl                                                                   #
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

$recentplver="1 Gold Beta4";

sub LastPost {
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);

	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
	}
	&unlock(FILE);
	close(FILE);

	%data= ();
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		$curcatname = <CAT>;
		$curcataccess = <CAT>;
		@catboards = <CAT>;
		&unlock(CAT);
		close(CAT);
		chomp $curcatname;
		chomp $curcataccess;
		%membergroups = ();
		foreach(split(/\,/,$curcataccess)) {
			$membergroups{$_} = $_;
		}
		if($curcataccess) {
			if($settings[7] ne 'Administrator' && !exists $membergroups{$settings[7]}) { next; }
		}
		foreach $curboard (@catboards ) {
			chomp $curboard;
			open(BOARDDATA, "$boardsdir/$curboard.txt");
			&lock(BOARDDATA);
			$message = <BOARDDATA>;
			&unlock(BOARDDATA);
			close(BOARDDATA);

			($mnum, $msub, $dummy, $dummy, $datetime) = split(/\|/, $message);
			$mydatetime = &timeformat($datetime);

			foreach (@censored) {
				($tmpa,$tmpb) = @{$_};
				$message =~ s~\Q$tmpa\E~$tmpb~gi;
				$msub =~ s~\Q$tmpa\E~$tmpb~gi;
			}
			$post = qq~$txt{'234'} "<a href="$cgi$curboard&action=display&num=$mnum">$msub</a>" $txt{'235'} ($mydatetime)<br></font></td>\n~;
			$totaltime = stringtotime($datetime);
			$data{$totaltime}= $post;
		}
	}

	@num = sort {$b <=> $a } keys %data;
	print "$data{$num[0]}";
}

sub RecentPosts {
	$yytitle = "$txt{'214'}";
	&header;
	$display = 10;

	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);

	open(FILE,"$vardir/censor.txt");
	&lock(FILE);
	while( chomp( $buffer = <FILE> ) ) {
		($tmpa,$tmpb) = split(/=/,$buffer);
		push(@censored,[$tmpa,$tmpb]);
	}
	&unlock(FILE);
	close(FILE);

	%data= ();
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		$curcatname = <CAT>;
		$curcataccess = <CAT>;
		@catboards = <CAT>;
		&unlock(CAT);
		close(CAT);
		chomp $curcatname;
		chomp $curcataccess;
		%membergroups = ();
		foreach(split(/\,/,$curcataccess)) {
			$membergroups{$_} = $_;
		}
		if($curcataccess) {
			if($settings[7] ne 'Administrator' && !exists $membergroups{$settings[7]}) { next; }
		}
		foreach $curboard (@catboards) {
			chomp $curboard;
			open(BOARDDATA, "$boardsdir/$curboard.txt");
			&lock(BOARDDATA);
			@threads = ();
			$#threads = $display - 1;
			$a = 0;
			while( $a < $display && ( $buffer = <BOARDDATA> ) ) {
				$threads[$a] = $buffer;
				$a++;
			}
			$#threads = $a - 1;
			&unlock(BOARDDATA);
			close(BOARDDATA);

			open(BOARDDATA, "$boardsdir/$curboard.dat");
			&lock(BOARDDATA);
			@boardinfo = <BOARDDATA>;
			&unlock(BOARDDATA);
			close(BOARDDATA);


			for ($a = 0; $a < @threads; $a++) {
				($mnum, $msub, $mname, $memail, $mdate, $mreplies, $musername, $micon, $mstate) = split(/\|/, $threads[$a]);
				$mydatetime = &timeformat($mdate);
				open (TEXT, "$datadir/$mnum.txt");
				@temp = <TEXT>;
				close(TEXT);
				open (LAST, "$datadir/$mnum.data");
				$tmpa = <LAST>;
				close(LAST);

				chomp $tmpa;
				($views,$lastposter) = split(/\|/, $tmpa);
				if( $lastposter =~ m~Guest-(.*)~ ) {
					$lastbyname = $1;
				}
				else {
					&LoadUser($lastposter);
					$lastbyname = $userprofile{$lastposter}->[1] || $lastposter;
				}
				if( $musername eq 'Guest' ) {
					$startedbyname = $mname;
				}
				else {
					&LoadUser($mname);
					$startedbyname = $userprofile{$mname}->[1] || $mname;
				}


				$numposts = @temp;
				chomp $temp[$numposts-1];
				@text = split(/\|/, $temp[$numposts-1]);
				$message = $text[8];

				foreach (@censored) {
					($tmpa,$tmpb) = @{$_};
					$message =~ s~\Q$tmpa\E~$tmpb~gi;
					$msub =~ s~\Q$tmpa\E~$tmpb~gi;
				}

				if($enable_ubbc) { &DoUBBC; }

				$post=<<"EOT";
<li><div align=left>
[ $curcatname / $boardinfo[0] ] <a href="$cgi$curboard&action=display&num=$mnum">$msub</a><br><br>
<font face="Verdana, Arial" size=1>$txt{'109'} $startedbyname<br>
Last post on $mdate, by $lastbyname<br>
<br><font color="#999999">--------------</font><br>
<br>$message<br>
<br><font color="#999999">--------------</font><br>
<br><a href="$cgi$curboard&action=post&num=$mnum&title=Post+reply">$txt{'146'}</a> |
<a href="$cgi$curboard&action=post&num=$mnum&quote=0&title=Post+reply">$txt{'145'}</a> |
<a href="$cgi$curboard&action=notify&thread=$mnum">$txt{'125'}</a><br>
<img src="/images/spacer.gif" width=1 height=9 border=0><br>
<hr width="50%"></font><br></div></li>
EOT
				$totaltime = stringtotime($mdate);
				$data{$totaltime}= $post;
			}
		}
	}

	print qq~<font face="Verdana, Arial" size=2>\n<ol>\n~;

	@num = sort {$b <=> $a } keys %data;
	$j=0;
	while( $j<$display ) {
		print $data{$num[$j]};
		++$j;
	}

	print qq~</ol>\n</font>\n\n<font face="Verdana, Arial" size=1><a href="$cgi">$txt{'236'}</a>\n$txt{'237'}<br></font>~;

	&footer;
	exit;
}

1;
