###############################################################################
# Subs.pl                                                                     #
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

$subsplver="1 Gold Beta4";

&readform;
$currentboard = "$INFO{'board'}";

sub header {
	print "Content-type: text/html\n\n";

	if($MenuType == 1) {
		$yymenu = qq~<p><a href="YaBB.pl">$txt{'103'}</a> | <a href="$helpfile" target=_blank>$txt{'119'}</a> | <a href="$cgi\&action=search">$txt{'182'}</a> | ~;
		if($settings[7] eq 'Administrator') { $yymenu .= qq~<a href="$cgi\&action=admin">$txt{'2'}</a> | ~; }
		if($username eq 'Guest') { $yymenu .= qq~<a href="$cgi\&action=login">$txt{'34'}</a> | <a href="$cgi&action=register">$txt{'97'}</a></p>~;
		} else { $yymenu .= qq~<a href="$cgi\&action=profile\&username=$username">$txt{'79'}</a> | <a href="$cgi\&action=shownotify">$txt{'419'}</a> | <a href="$cgi\&action=logout">$txt{'108'}</a></p>~; }
	}

	else {
		$yymenu = qq~<a href="YaBB.pl"><img src="$imagesdir/home.gif" alt="$txt{'103'}" border=0></a> <a href="$helpfile" target=_blank><img src="$imagesdir/help.gif" alt="$txt{'119'}" border=0></a> <a href="$cgi\&action=search"><img src="$imagesdir/search.gif" alt="$txt{'182'}" border=0></a> ~;
		if($settings[7] eq 'Administrator') { $yymenu .= qq~<a href="$cgi\&action=admin"><img src="$imagesdir/admin.gif" alt="$txt{'2'}" border=0></a> ~; }
		if($username eq 'Guest') { $yymenu .= qq~<a href="$cgi\&action=login"><img src="$imagesdir/login.gif" alt="$txt{'34'}" border=0></a> <a href="$cgi&action=register"><img src="$imagesdir/register.gif" alt="$txt{'97'}" border=0></a> ~;
		} else { $yymenu .= qq~<a href="$cgi\&action=profile\&username=$username"><img src="$imagesdir/profile.gif" alt="$txt{'79'}" border=0></a> <a href="$cgi\&action=shownotify"><img src="$imagesdir/notification.gif" alt="$txt{'419'}" border=0></a> <a href="$cgi\&action=logout"><img src="$imagesdir/logout.gif" alt="$txt{'108'}" border=0></a> ~; }
	}

	if($enable_news) {
		open(FILE, "$vardir/news.txt");
		&lock(FILE);
		@newsmessages = <FILE>;
		&unlock(FILE);
		close(FILE);
		srand;
		$yynews = "$txt{'102'}\: $newsmessages[int rand(@newsmessages)]";
	}
	if($username ne "Guest") {
		open(IM, "$memberdir/$username.msg");
		&lock(IM);
		@immessages = <IM>;
		&unlock(IM);
		close(IM);
		$mnum = @immessages;
		if($mnum eq "1") { $yyim = "$txt{'152'} <a href=\"$cgi\&action=im\">$mnum $txt{'471'}<\/a>"; }
		else { $yyim = "$txt{'152'} <a href=\"$cgi\&action=im\">$mnum $txt{'153'}<\/a>"; }
	}
	open(TEMPLATE,"$boarddir/template.html");
	&lock(TEMPLATE);
	@yytemplate = <TEMPLATE>;
	&unlock(TEMPLATE);
	close(TEMPLATE);

	$yytime = &timeformat($date);
	$yyuname = $username eq 'Guest' ? qq~$txt{'248'} $txt{'28'}. $txt{'249'}~ : qq~$txt{'247'} $realname, ~ ;
	for( $yytemplatemain = 0; $yytemplatemain < @yytemplate; $yytemplatemain++ ) {
		$curline = $yytemplate[$yytemplatemain];
		if($curline =~ /<yabb main>/) { $yytemplatemain++; last; }
		if( ! $yycopyin && $curline =~ /<yabb copyright>/ ) { $yycopyin = 1; }
		$curline =~ s~<yabb\s+(\w+)>~${"yy$1"}~g;
		print $curline;
	}
}

sub footer {
	my( $curline, $i );
	$yytime = &timeformat($date);
	for($i = $yytemplatemain; $i < @yytemplate; $i++) {
		$curline = $yytemplate[$i];
		if( ! $yycopyin && $curline =~ /<yabb copyright>/ ) { $yycopyin = 1; }
		$curline =~ s~<yabb\s+(\w+)>~${"yy$1"}~g;
		print $curline;
	}
	# Do not remove hard-coded text - it's in here so users cannot change the text easily (as if it were in .lng)
	if($yycopyin == 0) {
		print q~<center><p>Sorry, the copyright tag <yabb copyright> must be in the template.<BR>Please notify this forum's administrator that this site is using an ILLEGAL copy of YaBB!</p></center>~;
	}
}

sub calcdifference {  # Input: $date1 $date2
	my( $dates, $times, $month, $day, $year, $number1, $dummy, $number2 );
	($dates, $times) = split(/ /, $date1);
	($month, $day, $year) = split(/\//, $dates);
	$number1=($year*365)+($month*30)+$day;
	($dates, $dummy) = split(/ /, $date2);
	($month, $day, $year) = split(/\//, $dates);
	$number2=($year*365)+($month*30)+$day;
	$result=$number2-$number1;
}

sub calctime {  # Input: $date1 $date2
	my( $dummy, $times, $hour, $min, $sec, $number1, $number2 );
	($dummy, $times) = split(/ $txt{'107'} /, $date1);
	($hour, $min, $sec) = split(/\//, $times);
	$number1=($hour*60)+$min;
	($dummy, $times) = split(/ $txt{'107'} /, $date2);
	($hour, $min, $sec) = split(/\//, $times);
	$number2=($hour*60)+$min;
	$result=$number2-$number1;
}


sub fatal_error {
	local($e) = @_;
	$yytitle = "$txt{'106'}";
	&header;
	print <<"EOT";
<table border=0 width="90%" cellspacing=1 bgcolor="$color{'bordercolor'}" align="center">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><p>$txt{'106'}</p></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><p>$e</p></td>
</tr>
</table>
<center><BR><a href="javascript:history.go(-1)">$txt{'250'}</a></center>
EOT
	&footer;
	exit;

}

sub readform {
	my( @pairs, $pair, $name, $value );
	read(STDIN, $value, $ENV{'CONTENT_LENGTH'});
	@pairs = split(/&/, $value);
	foreach $pair (@pairs) {
		  ($name, $value) = split(/=/, $pair);
		  $name =~ tr/+/ /;
		  $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $value =~ tr/+/ /;
		  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $FORM{$name} = $value;
	}

	@pairs = split(/&/, $ENV{QUERY_STRING});
	foreach $pair (@pairs) {
		  ($name,$value) = split(/=/, $pair);
		  $name =~ tr/+/ /;
		  $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $value =~ tr/+/ /;
		  $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		  $value =~ s/<!--(.|\n)*-->//g;
		  $INFO{$name} = $value;
	}
	$action = $INFO{'action'};
}

sub get_date {
	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time + (3600*$timeoffset));
	$mon_num = $mon+1;
	$savehour = $hour;
	$hour = "0$hour" if ($hour < 10);
	$min = "0$min" if ($min < 10);
	$sec = "0$sec" if ($sec < 10);
	$saveyear = ($year % 100);
	$year = 1900 + $year;

	$mon_num = "0$mon_num" if ($mon_num < 10);
	$mday = "0$mday" if ($mday < 10);
	$saveyear = "0$saveyear" if ($saveyear < 10);
	$date = "$mon_num/$mday/$saveyear $txt{'107'} $hour\:$min\:$sec";
}

sub timeformat {

if ($settings[17] > 0) { $mytimeselected = $settings[17]; } else { $mytimeselected = $timeselected; }

$oldformat = $_[0];
if( $oldformat eq '' || $oldformat eq "\n" ) { return $oldformat; }

$oldmonth = substr($oldformat,0,2);
$oldday = substr($oldformat,3,2);
$oldyear = ("20".substr($oldformat,6,2)) - 1900;
$oldhour = substr($oldformat,-8,2);
$oldminute = substr($oldformat,-5,2);
$oldsecond = substr($oldformat,-2,2);

if ($oldformat ne '') {
	use Time::Local 'timelocal';

eval { $oldtime = timelocal($oldsecond,$oldminute,$oldhour,$oldday,$oldmonth-1,$oldyear); };
	if ($@) {
		return ($oldformat);
	}

	my ($newsecond,$newminute,$newhour,$newday,$newmonth,$newyear,$newweekday,$newyearday,$newisdst) = localtime($oldtime + (3600 * $settings[18]));
	$newmonth++;
	$newweekday++;
	$newyear += 1900;
	$newshortyear = substr($newyear,2,2);
	if ($newmonth < 10) { $newmonth = "0$newmonth" };
	if ($newday < 10 && $mytimeselected != 4) { $newday = "0$newday" };
	if ($newhour < 10) { $newhour = "0$newhour" };
	if ($newminute < 10) { $newminute = "0$newminute" };
	if ($newsecond < 10) { $newsecond = "0$newsecond" };
	$newtime = $newhour.":".$newminute.":".$newsecond;

	if ($mytimeselected == 1) {
		$newformat = qq~$newmonth/$newday/$newshortyear $txt{'107'} $newtime~;
		return $newformat;

	} elsif ($mytimeselected == 2) {
		$newformat = qq~$newday.$newmonth.$newshortyear $txt{'107'} $newtime~;
		return $newformat;

	} elsif ($mytimeselected == 3) {
		$newformat = qq~$newday.$newmonth.$newyear $txt{'107'} $newtime~;
		return $newformat;

	} elsif ($mytimeselected == 4) {
		$newmonth--;
		$ampm = $newhour > 11 ? 'pm' : 'am';
		$newhour2 = $newhour % 12 || 12;
		$newmonth2 = $months[$newmonth];
		if( $newday % 10 == 1 ) { $newday2 = 'st'; }
		elsif( $newday % 10 == 2 ) { $newday2 = 'nd'; }
		elsif( $newday % 10 == 3 ) { $newday2 = 'rd'; }
		else{ $newday2 = 'th'; }
		$newformat = qq~$newmonth2 $newday$newday2, $newyear $txt{'107'} $newhour2:$newminute:$newsecond$ampm~;
		return $newformat;

	} elsif ($mytimeselected == 5) {
		$ampm = $newhour > 11 ? 'pm' : 'am';
		$newhour2 = $newhour % 12 || 12;
		$newformat = qq~$newmonth/$newday/$newshortyear $txt{'107'} $newhour2:$newminute$ampm~;
		return $newformat;

	} elsif ($mytimeselected == 6) {
		$newmonth2 = $months[$newmonth-1];
		$newformat = qq~$newday. $newmonth2 $newyear $txt{'107'} $newhour:$newminute~;
		return $newformat;
	}

} else { return ''; }
}

sub lock {
	my $lock_file = $_[0];
	my $flag = 1;
	my $count = 0;
	if($use_flock==1) {
		flock($lock_file, $LOCK_EX);
	} elsif ($use_flock==2) {

		while($flag and $count < 15) {
			$flag = check_flock($lock_file);
			$count++;
		}

		unlink($lock_file) if ($count == 15);
		open(LOCK_FILE, ">$lock_file");
	}
}

sub unlock {
	my $lock_file = $_[0];

	if($use_flock==1) {
		flock($lock_file, $LOCK_UN);
	} elsif ($use_flock==2) {
		close(LOCK_FILE);
		unlink($lock_file) if (-e $lock_file);
	}
}

sub check_flock {
	my ($file) = shift;

	if (-e $file) {
		sleep (2);
		return 1;
	}
	else { return 0; }

}

sub getlog {
	if( $username eq 'Guest' ) { return; }
	my $entry = $_[0];
	unless( defined %yyuserlog ) {
		%yyuserlog = ();
		my( $name, $value, $thistime, $adate, $atime, $amonth, $aday, $ayear, $ahour, $amin, $asec );
		my $mintime = time - ( $max_log_days_old * 86400 );
		open(MLOG, "$memberdir/$username.log");
		&lock(MLOG);
		while( <MLOG> ) {
			chomp;
			($name, $value, $thistime) = split( /\|/, $_ );
			unless( $name ) { next; }
			if( $value ) {
				$thistime = stringtotime($value);
			}
			if( $thistime > $mintime ) {
				$yyuserlog{$name} = $thistime;
			}
		}
		&unlock(MLOG);
		close(MLOG);
	}
	return $yyuserlog{$entry};
}

sub modlog {
	if( $username eq 'Guest' ) { return; }
	unless( defined %yyuserlog ) { &getlog; }
	my( $entry, $dumbtime, $thistime ) = @_;
	if( $dumbtime ) {
		$thistime = stringtotime($dumbtime);
	}
	unless( $thistime ) {
		$thistime = time;
	}
	$yyuserlog{$entry} = $thistime;
}

sub dumplog {
	if( $username eq 'Guest' ) { return; }
	if( @_ ) { &modlog(@_); }
	if( defined %yyuserlog ) {
		open(MLOG, ">$memberdir/$username.log");
		&lock(MLOG);
		while( $_ = each(%yyuserlog) ) {
			unless( $_ ) { next; }
			print MLOG qq~$_||$yyuserlog{$_}\n~;
		}
		&unlock(MLOG);
		close(MLOG);
	}
}

sub stringtotime {
	unless( $_[0] ) { return 0; }
	my( $adate, $atime ) = split(m~ at ~, $_[0]);
	my( $amonth, $aday, $ayear ) = split(m~/~, $adate);
	my( $ahour, $amin, $asec ) = split (m~:~, $atime);
	--$amonth;
	$ayear += 100;
	if( $amonth < 0 || $amonth > 11 ) { &fatal_error(qq~month $amonth out of range. original date string: $_[0].~); }
	if( $aday < 1 || $aday > 31 ) { &fatal_error(qq~day $aday out of range. original date string: $_[0].~); }
	return( timelocal($asec, $amin, $ahour, $aday, $amonth, $ayear) - (3600*$timeoffset) );
}

sub jumpto {
	$filetoopen = "$vardir/cat.txt";
	open(FILE, "$filetoopen");
	&lock(FILE);
	@masterdata = <FILE>;
	&unlock(FILE);
	close(FILE);

	$selecthtml .= "<option value=\"\">$txt{'251'}:\n";

	foreach $category (@masterdata) {
		$category =~ s/\n//g;
		open(FILE, "$boardsdir/$category.cat");
		&lock(FILE);
		@data = <FILE>;
		&unlock(FILE);
		close(FILE);
		@data[1] =~ s/\n//g;
		if(@data[1] ne "") {
			if($settings[7] ne "Administrator" && $settings[7] ne "@data[1]") { next; }
		}

		$selecthtml .= "<option value=\"\">-----------------------------\n";
		$selecthtml .= "<option value=\"\">-- @data[0] --\n";
		$selecthtml .= "<option value=\"\">-----------------------------\n";

		foreach $line (@data) {
			if($line ne "@data[0]" && $line ne "@data[1]") {
				$line =~ s/\n//g;
				open(FILE, "$boardsdir/$line.dat");
				&lock(FILE);
				@newcatdata = <FILE>;
				&unlock(FILE);
				close(FILE);

				if ($action eq "display" && $line eq $currentboard) { $selecthtml .= "<option selected value=\"$line\">- @newcatdata[0]\n"; }
				else { $selecthtml .= "<option value=\"$line\">- @newcatdata[0]\n"; }
			}
		}
	}

}

sub sendmail {

	my ($to, $subject, $message) = @_;

	if ($mailtype==1) { use Socket; }

	$to =~ s/[ \t]+/, /g;
	$webmaster_email =~ s/.*<([^\s]*?)>/$1/;
	$message =~ s/^\./\.\./gm;
	$message =~ s/\r\n/\n/g;
	$message =~ s/\n/\r\n/g;
	$smtp_server =~ s/^\s+//g;
	$smtp_server =~ s/\s+$//g;

	if (!$to) { return(-8); }

 	if ($mailtype==1) {

		my($proto) = (getprotobyname('tcp'))[2];
		my($port) = (getservbyname('smtp', 'tcp'))[2];
		my($smtpaddr) = ($smtp_server =~ /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})$/) ? pack('C4',$1,$2,$3,$4) : (gethostbyname($smtp_server))[4];

		if (!defined($smtpaddr)) { return(-1); }
		if (!socket(MAIL, AF_INET, SOCK_STREAM, $proto)) { return(-2); }
		if (!connect(MAIL, pack('Sna4x8', AF_INET, $port, $smtpaddr))) { return(-3); }

		my($oldfh) = select(MAIL);
		$| = 1;
		select($oldfh);

		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-4);
		}

		print MAIL "helo $smtp_server\r\n";
		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-5);
		}

		print MAIL "mail from: <$webmaster_email>\r\n";
		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-5);
		}

		foreach (split(/, /, $to)) {
			print MAIL "rcpt to: <$_>\r\n";
			$_ = <MAIL>;
			if (/^[45]/) {
				close(MAIL);
				return(-6);
			}
		}

		print MAIL "data\r\n";
		$_ = <MAIL>;
		if (/^[45]/) {
			close MAIL;
			return(-5);
		}

	}

	if ($mailtype==0) {
		open (MAIL,"| $mailprog -t");
	}

	print MAIL "To: $to\n";
	print MAIL "from: $webmaster_email\n";
	print MAIL "X-Mailer: Perl Powered Socket Mailer\n";
	print MAIL "Subject: $subject\n\n";
	print MAIL "$message";
	print MAIL "\n.\n";

	if ($mailtype==1) {

		$_ = <MAIL>;
		if (/^[45]/) {
			close(MAIL);
			return(-7);
		}

		print MAIL "quit\r\n";
		$_ = <MAIL>;
	}

	close(MAIL);
	return(1);
}

sub spam_protection {
	unless( $timeout ) { return; }

	my($ip,$time,$flood_ip,$flood_time,$flood,@floodcontrol);
	$time = time;
	$ip = $ENV{REMOTE_ADDR};

	if (-e "$vardir/flood.txt") {
		open(FILE, "$vardir/flood.txt");
		&lock(FILE);
		push(@floodcontrol,"$ip|$time\n");
		while( <FILE> ) {
			chomp($_);
			($flood_ip,$flood_time) = split(/\|/,$_);
			if( $ip eq $flood_ip && $time - $flood_time <= $timeout ) { $flood = 1; }
			elsif( $time - $flood_time < $timeout ) { push( @floodcontrol, "$_\n" ); }
		}
		&unlock(FILE);
		close(FILE);
	}
	if ($flood) { &fatal_error("$txt{'409'} $timeout $txt{'410'}"); }
	open(FILE, ">$vardir/flood.txt");
	&lock(FILE);
	print FILE @floodcontrol;
	&unlock(FILE);
	close(FILE);
}

sub checkdomain {

	@alloweddomains[0] = $domain1;
	@alloweddomains[1] = $domain2;
	@alloweddomains[2] = $domain3;

	local($check_referer) = 0;

	if ($ENV{'HTTP_REFERER'}) {
	        foreach $referer (@alloweddomains) {
			if ($referer ne "") {
	                        if ($ENV{'HTTP_REFERER'} =~ m/htt[ps|s]:\/\/([^\/]*)$referer/i) {
	                                $check_referer = 1;
	                                last;
	                        }
			}
	        }
	}
	else { $check_referer = 1; }
	if ($check_referer != 1) { &fatal_error("$txt{'411'}$ENV{'HTTP_REFERER'}$txt{'412'}"); }
}

sub DPPrivate {

	if($settings[7] ne "Administrator") {
		open(FILE, "$vardir/cat.txt");
		&lock(FILE);
		@categories = <FILE>;
		&unlock(FILE);
		close(FILE);
		foreach $curcat (@categories) {
			$curcat =~ s/\n//g;
			open(CAT, "$boardsdir/$curcat.cat");
			&lock(CAT);
			@catinfo = <CAT>;
			&unlock(CAT);
			close(CAT);
			$catinfo[1] =~ s/[\n\r]//g;
			foreach(split(/\,/,$catinfo[1])) {
				$membergroups{$_} = $_;
			}
			if (defined($catinfo[1]) && $catinfo[1] ne "") {
				if (defined($catinfo[2]) && $catinfo[2] ne "") {
					for ($loop_index = 2; $loop_index <= $#catinfo; $loop_index ++) {
						$catinfo[$loop_index] =~ s/[\n\r]//g;
						if ($catinfo[$loop_index] eq $currentboard) {
							if (!defined($settings[7]) || $settings[7] eq "" || !exists $membergroups{$settings[7]}) {
								&fatal_error("$txt{'1'}!");
							}
						}
					}
				}
			}
		}
	}

}

sub ToHTML {
	@_[0] =~ s/</&lt;/g;
	@_[0] =~ s/>/&gt;/g;
	@_[0] =~ s/\|/\&#124;/g;
	@_[0] =~ s/  / \&nbsp;/g;
}

sub FromHTML {
	@_[0] =~ s/&lt;/</g;
	@_[0] =~ s/&gt;/>/g;
	@_[0] =~ s/\&#124;/\|/g;
	@_[0] =~ s/\&nbsp;/ /g;
}

sub RemoveLineFeeds {
	@_[0] =~ s/[\n\r]//g;
}

sub dopre {
	$_ = $_[0];
	$_ =~ s~<br>~\n~g;
	return $_;
}

sub validwidth {
	return ( $_[0] > 400 ? 400 : $_[0] );
}

sub SetCookieExp {
	# set to default if missing
	if ($Cookie_Length eq "") { $Cookie_Length = "120"; }
	$expires = ($Cookie_Length*60);

	use Time::Local 'timegm';
	($csec,$cmin,$chour,$cday,$cmon,$cyear,$cwday,$dummy,$dummy) = gmtime(time);
	$time = timegm($csec,$cmin,$chour,$cday,$cmon,$cyear);
	($csec,$cmin,$chour,$cday,$cmon,$cyear,$cwday,$dummy,$dummy) = gmtime($time + $expires); #date expires

	@cookiedays = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
	@cookiemonths = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

	$cyear = (1900 + $cyear);
	if($cmin < 10) { $cmin = "0$cmin"; }
	if($csec < 10) { $csec = "0$csec"; }
	if($chour < 10) { $chour = "0$chour"; }

	$Cookie_Exp_Date = "$cookiedays[$cwday], $cday-$cookiemonths[$cmon]-$cyear $chour:$cmin:$csec GMT";
}

sub MakeSmileys {
	$message =~ s/\Q&gt;:(\E/\<img src=$imagesdir\/angry.gif\>/g;
	$message =~ s/\Q::)\E/\<img src=$imagesdir\/rolleyes\.gif\>/g;
	$message =~ s/\Q:P\E/\<img src=$imagesdir\/tongue\.gif\>/g;
	$message =~ s/\Q:)\E/\<img src=$imagesdir\/smiley\.gif\>/g;
	$message =~ s/\Q:-)\E/\<img src=$imagesdir\/smiley\.gif\>/g;
	$message =~ s/(\W)\;\)/$1\<img src=$imagesdir\/wink.gif\>/g;
	$message =~ s/(\W)\;\-\)/$1\<img src=$imagesdir\/wink.gif\>/g;
	$message =~ s/\Q:D\E/\<img src=$imagesdir\/cheesy.gif\>/g;
	$message =~ s/(\W)\;D/$1\<img src=$imagesdir\/grin.gif\>/g;
	$message =~ s/\Q:-(\E/\<img src=$imagesdir\/sad.gif\>/g;
	$message =~ s/\Q:(\E/\<img src=$imagesdir\/sad.gif\>/g;
	$message =~ s/\Q:o\E/\<img src=$imagesdir\/shocked.gif\>/gi;
	$message =~ s/\Q8)\E/\<img src=$imagesdir\/cool.gif\>/g;
	$message =~ s/\Q???\E/\<img src=$imagesdir\/huh.gif\>/g;
	$message =~ s/\Q?!?\E/\<img src=$imagesdir\/huh.gif\>/g;
}

$MAXIMGWIDTH = 400;
$MAXIMGHEIGHT = 500;
sub restrictimage {
	my($w,$h,$s) = @_;
	$w = $w <= $MAXIMGWIDTH ? $w : $MAXIMGWIDTH;
	$h = $h <= $MAXIMGHEIGHT ? $h : $MAXIMGHEIGHT;
	return qq~<img src="$s" width="$w" height="$h">~;
}

sub DoUBBC {
	if($ns =~ "NS") {
	} else {
		if ($message =~ /^\#nosmileys/ ) { $message =~ s/^\#nosmileys//; }
		else { &MakeSmileys; }
	}
	$message =~ s~<br>~\n~ig;
	$message =~ s~\[b\](.+?)\[/b\]~$1~isg;
	$message =~ s~\[i\](.+?)\[/i\]~<i>$1</i>~isg;
	$message =~ s~\[u\](.+?)\[/u\]~<u>$1</u>~isg;
	$message =~ s~\[s\](.+?)\[/s\]~<s>$1</s>~isg;
	$message =~ s~\[move\](.+?)\[/move\]~<marquee>$1</marquee>~isg;

	$message =~ s~\[glow(.*?)\](.*?)\[shadow.*?\](.*?)\[/glow\]~\[glow$1\]$2$3\[/glow\]~isg;
	$message =~ s~\[glow(.*?)\](.*?)\[/shadow.*?\](.*?)\[/glow\]~\[glow$1\]$2$3\[/glow\]~isg;

	$message =~ s~\[shadow(.*?)\](.*?)\[glow.*?\](.*?)\[/shadow\]~\[shadow$1\]$2$3\[/shadow\]~isg;
	$message =~ s~\[shadow(.*?)\](.*?)\[/glow.*?\](.*?)\[/shadow\]~\[shadow$1\]$2$3\[/shadow\]~isg;

	$message =~ s~\[shadow=(\S+?),(.+?),(.+?)\](.+?)\[/shadow\]~q^[&table width=^ . validwidth($3) . qq^ style="filter:shadow\(color=$1, direction=$2\)"\]$4\[/\&table\]^~eisg;
	$message =~ s~\[glow=(\S+?),(.+?),(.+?)\](.+?)\[/glow\]~q^[&table width=^ . validwidth($3) . qq^ style="filter:glow\(color=$1, strength=$2\)"\]$4\[/\&table\]^~eisg;

	$message =~ s~\[color=([\w#]+)\](.*?)\[/color\]~<p>$2</p>~isg;
	$message =~ s~\[black\](.*?)\[/black\]~<p>$1</p>~isg;
	$message =~ s~\[white\](.*?)\[/white\]~<p>$1</p>~isg;
	$message =~ s~\[red\](.*?)\[/red\]~<p>$1</p>~isg;
	$message =~ s~\[green\](.*?)\[/green\]~<p>$1</p>~isg;
	$message =~ s~\[blue\](.*?)\[/blue\]~<p>$1</p>~isg;

	$message =~ s~\[font=(.+?)\](.+?)\[/font\]~<p>$2</p>~isg;
	$message =~ s~\[size=(.+?)\](.+?)\[/size\]~<p>$2</p>~isg;

	$message =~ s~\[img\](.+?)\[/img\]~<img src="$1">~isg;
	$message =~ s~\[img width=(\d+) height=(\d+)\](.+?)\[/img\]~restrictimage($1,$2,$3)~eisg;

	$message =~ s~\[tt\](.*?)\[/tt\]~<tt>$1</tt>~isg;
	$message =~ s~\[left\](.+?)\[/left\]~<p align=left>$1</p>~isg;
	$message =~ s~\[center\](.+?)\[/center\]~<center>$1</center>~isg;
	$message =~ s~\[right\](.+?)\[/right\]~<p align=right>$1</p>~isg;
	$message =~ s~\[sub\](.+?)\[/sub\]~<sub>$1</sub>~isg;
	$message =~ s~\[sup\](.+?)\[/sup\]~<sup>$1</sup>~isg;
	$message =~ s~\[fixed\](.+?)\[/fixed\]~<p>$1</p>~isg;

if($sender ne "News") {
	$message =~ s~\[\[~\{\{~g;
	$message =~ s~\]\]~\}\}~g;
	$message =~ s~\|~\&#124;~g;
	$message =~ s~\[hr\]\n~<hr width=40% align=left>~g;
	$message =~ s~\[hr\]~<hr width=40% align=left>~g;
	$message =~ s~\[br\]~<br>~ig;

	$message =~ s~([^\w\"\=\[\]]|[\A\n\b])\\*(\w+://[^<>\s\n\"]+)~$1<a href="$2" target="_blank">$2</a>~isg;
	$message =~ s~([^\"\=\[\]/\:]|[\A\n\b])\\*(www\.[^<>\s\n]+)~$1<a href="http://$2" target="_blank">$2</a>~isg;
	$message =~ s~\[url\](.+?)\[/url\]~<a href="$1" target="_blank">$1</a>~isg;
	$message =~ s~\[url=(\w+\://.+?)\](.+?)\[/url\]~<a href="$1" target="_blank">$2</a>~isg;
	$message =~ s~\[url=(.+?)\](.+?)\[/url\]~<a href="http://$1" target="_blank">$2</a>~isg;

	$message =~ s~\[email\](\S+?\@\S+?)\[/email\]~<a href="mailto:$1">$1</a>~isg;
	$message =~ s~\[email=(\S+?\@\S+?)\](.*?)\[/email\]~<a href="mailto:$1">$2</a>~isg;

	$message =~ s~\[news\](.+?)\[/news\]~<a href="$1">$1</a>~isg;
	$message =~ s~\[gopher\](.+?)\[/gopher\]~<a href="$1">$1</a>~isg;
	$message =~ s~\[ftp\](.+?)\[/ftp\]~<a href="$1">$1</a>~isg;

	$message =~ s~\[quote\s+author=(.*?)link=(.*?)\s+date=(.*?)\s*\]\n(.*?)\n\[/quote\]~<blockquote>on $3, $1 wrote:<hr>$4<hr><a href="$scripturl?action=display&$2">\($txt{'516'}\)</a></blockquote>~isg;
	$message =~ s~\[quote\s+author=(.*?)link=(.*?)\s+date=(.*?)\s*\](.*?)\[/quote\]~<blockquote>on $3, $1 wrote:<hr>$4<hr><a href="$scripturl?action=display&$2">\($txt{'516'}\)</a></blockquote>~isg;

	$message =~ s~\[quote\]\n(.+?)\n\[/quote\]~<blockquote><hr>$1<hr></blockquote>~isg;
	$message =~ s~\[quote\](.+?)\[/quote\]~<blockquote><hr>$1<\/b><hr></blockquote>~isg;

	$message =~ s~\[list\]~<ul>~isg;
	$message =~ s~\[\*\]~<li>~isg;
	$message =~ s~\[/list\]~</ul>~isg;

	$message =~ s~\[pre\](.+?)\[/pre\]~'<pre>' . dopre($1) . '</pre>'~iseg;

	$message =~ s~\[flash=(\S+?),(\S+?)\](\S+?)\[/flash\]~<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width=$1 height=$2><param name=movie value=$3><param name=play value=true><param name=loop value=true><param name=quality value=high><embed src=$3 width=$1 height=$2 play=true loop=true quality=high></embed></object>~isg;

	$message =~ s~\{\{~\[~g;
	$message =~ s~\}\}~\]~g;

	if( $message =~ m~\[table\]~i ) {
		while( $message =~ s~<marquee>(.*?)\[table\](.*?)\[/table\](.*?)</marquee>~<marquee>$1<table>$2</table>$3</marquee>~s ) {}
		while( $message =~ s~<marquee>(.*?)\[table\](.*?)</marquee>(.*?)\[/table\]~<marquee>$1\[//table\]$2</marquee>$3\[//table\]~s ) {}
		while( $message =~ s~\[table\](.*?)<marquee>(.*?)\[/table\](.*?)</marquee>~\[//table\]$1<marquee>$2\[//table\]$3</marquee>~s ) {}
		$message =~ s~\n{0,1}\[table\]\n*(.+?)\n*\[/table\]\n{0,1}~<table>$1</table>~isg;
		while( $message =~ s~\<table\>(.*?)\n*\[tr\]\n*(.*?)\n*\[/tr\]\n*(.*?)\</table\>~<table>$1<tr>$2</tr>$3</table>~is ) {}
		while( $message =~ s~\<tr\>(.*?)\n*\[td\]\n{0,1}(.*?)\n{0,1}\[/td\]\n*(.*?)\</tr\>~<tr>$1<td>$2</td>$3</tr>~is ) {}
	}
	$message =~ s~\[code\](.+?)\[/code\]~<blockquote><p>code:</p><hr><p><pre>$1</pre></p><hr></blockquote>~isg;
}
	while( $message =~ s~<a([^>]*?)\n([^>]*)>~<a$1$2>~ ) {}
	while( $message =~ s~<a([^>]*)>([^<]*?)\n([^<]*)</a>~<a$1>$2$3</a>~ ) {}
	while( $message =~ s~<a([^>]*?)&amp;([^>]*)>~<a$1&$2>~ ) {}
	while( $message =~ s~<img([^>]*?)\n([^>]*)>~<img$1$2>~ ) {}
	while( $message =~ s~<img([^>]*?)&amp;([^>]*)>~<img$1&$2>~ ) {}
	if( $message =~ m~marquee>~ && $message =~ m~\[/{0,1}\&table~ ) {
		while( $message =~ s~<marquee>(.*?)\[\&table(.*?)\](.*?)\[/\&table\](.*?)</marquee>~<marquee>$1<table$2>$3</table>$4</marquee>~s ) {}
		while( $message =~ s~<marquee>(.*?)\[\&table.*?\](.*?)</marquee>(.*?)\[/\&table\]~<marquee>$1$2</marquee>$3~s ) {}
		while( $message =~ s~\[\&table.*?\](.*?)<marquee>(.*?)\[/\&table\](.*?)</marquee>~$1<marquee>$2$3</marquee>~s ) {}
	}
	$message =~ s~\[\&table(.*?)\]~<table$1>~g;
	$message =~ s~\[/\&table\]~</table>~g;
	$message =~ s~\n~<br>~g;
}

sub WriteLog {
	open(LOG, "$vardir/log.txt");
	&lock(LOG);
	@entries = <LOG>;
	&unlock(LOG);
	close(LOG);
	open(LOG, ">$vardir/log.txt");
	&lock(LOG);
	$field="$username";
	if($field eq "Guest") { $field = "$ENV{'REMOTE_ADDR'}"; }
	print LOG "$field\|$date\n";
	foreach $curentry (@entries) {
		$curentry =~ s/\n//g;
		($name, $value) = split(/\|/, $curentry);
		$date1="$value";
		$date2="$date";
		&calctime;
		if($name ne "$field" && $result <= 15 && $result >= 0) { print LOG "$curentry\n"; }
	}
	&unlock(LOG);
	close(LOG);
}

sub BoardCountTotals {
	my $curboard = $_[0];
	unless( $curboard ) { return undef; }
	my( $postid, $tmpa, $lastposttime, $lastposter, $threadcount, $messagecount, $counter, $mreplies, @messages );
	open(FILEBTTL, "$boardsdir/$curboard.txt");
	&lock(FILEBTTL);
	@messages = <FILEBTTL>;
	&unlock(FILEBTTL);
	close(FILEBTTL);
	($postid,$tmpa,$tmpa,$tmpa,$lastposttime) = split(/\|/, $messages[0]);
	if( $postid ) {
		open(FILEBTTL, "$datadir/$postid.data");
		&lock(FILEBTTL);
		$tmpa = <FILEBTTL>;
		&unlock(FILEBTTL);
		close(FILEBTTL);
		($tmpa, $lastposter) = split(/\|/, $tmpa);
	}
	unless( $lastposter ) { $lastposter = 'N/A'; }
	unless( $lastposttime ) { $lastposttime = 'N/A'; }
	$threadcount = scalar @messages;
	$messagecount = $threadcount;
	for($counter = 0; $counter < $threadcount; $counter++ ) {
		($tmpa, $tmpa, $tmpa, $tmpa, $tmpa, $mreplies) = split(/\|/, $messages[$counter]);
		$messagecount += $mreplies;
	}
	open(FILEBTTL, ">$boardsdir/$curboard.ttl");
	&lock(FILEBTTL);
	print FILEBTTL qq~$threadcount|$messagecount|$lastposttime|$lastposter~;
	&unlock(FILEBTTL);
	close(FILEBTTL);
	if( wantarray() ) {
		return ( $threadcount, $messagecount, $lastposttime, $lastposter );
	}
	else { return 1; }
}

sub BoardCountSet {
	my ( $curboard, $threadcount, $messagecount, $lastposttime, $lastposter ) = @_;
	open(FILEBOARDSET, ">$boardsdir/$curboard.ttl");
	&lock(FILEBOARDSET);
	print FILEBOARDSET qq~$threadcount|$messagecount|$lastposttime|$lastposter~;
	&unlock(FILEBOARDSET);
	close(FILEBOARDSET);
}

sub BoardCountGet {
	if( open(FILEBOARDGET, "$boardsdir/$_[0].ttl") ) {
		&lock(FILEBOARDGET);
		$_ = <FILEBOARDGET>;
		chomp;
		&unlock(FILEBOARDGET);
		close(FILEBOARDGET);
		return split( /\|/, $_ );
	}
	else {
		return &BoardCountTotals($_[0]);
	}
}

sub MembershipGet {
	if( open(FILEMEMGET, "$vardir/members.ttl") ) {
		&lock(FILEMEMGET);
		$_ = <FILEMEMGET>;
		chomp;
		&unlock(FILEMEMGET);
		close(FILEMEMGET);
		return split( /\|/, $_ );
	}
	else {
		my @ttlatest = &MembershipCountTotal;
		return @ttlatest;
	}
}

sub MembershipCountTotal {
	my $membertotal = 0;
	my $latestmember;
	open(FILEAMEMBERS, "$memberdir/memberlist.txt");
	&lock(FILEAMEMBERS);
	while( <FILEAMEMBERS> ) {
		chomp;
		++$membertotal;
		if( $_ ) { $latestmember = $_; }
	}
	&unlock(FILEAMEMBERS);
	close(FILEAMEMBERS);
	open(FILEAMEMBERS, ">$vardir/members.ttl");
	&lock(FILEAMEMBERS);
	print FILEAMEMBERS qq~$membertotal|$latestmember~;
	&unlock(FILEAMEMBERS);
	close(FILEAMEMBERS);
	if( wantarray() ) {
		return ( $membertotal, $latestmember );
	}
	else { return $membertotal; }
}
1;