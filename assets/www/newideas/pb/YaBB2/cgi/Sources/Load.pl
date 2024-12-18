###############################################################################
# Security.pl                                                                 #
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

$loadplver="1 Gold Beta4";

sub LoadBoard {
	if($currentboard ne "") {
		open(FILE, "$boardsdir/$currentboard.dat");
		&lock(FILE);
		@boardinfo=<FILE>;
		&unlock(FILE);
		close(FILE);

		$boardinfo[0] =~ s/[\n\r]//g;
		$boardinfo[2] =~ s/[\n\r]//g;
		$boardname = "$boardinfo[0]";

		# Create Hash %moderators with all Moderators of the current board
		foreach(split(/\|/,$boardinfo[2])) {
			open(MODERATOR, "$memberdir/$_.dat");
			&lock(MODERATOR);
			@modprop = <MODERATOR>;
			&unlock(MODERATOR);
			close(MODERATOR);
			$modprop[1] =~ s/[\n\r]//g;
			$moderators{$_} = $modprop[1];
		}

		if ($INFO{'num'} ne "") {
			$check = "0";
			open(FILE, "$boardsdir/$currentboard.txt");
			&lock(FILE);
			@board_data=<FILE>;
			&unlock(FILE);
			close(FILE);

			if ($FORM{'caller'} ne "" || $action eq "imsend") { $check = "1"; }
			foreach $board_data2 (@board_data) {
				($threadnum, $dummy) = split(/\|/,$board_data2);
				if ($threadnum eq $INFO{'num'}) { $check = "1"; }
			}
			if ($check eq "0") { &fatal_error("$txt{'472'}"); }
		}
	}
}

sub LoadUserSettings {
	if($username ne 'Guest') {
		open(FILE, "$memberdir/$username.dat");
		&lock(FILE);
		@settings=<FILE>;
		&unlock(FILE);
		close(FILE);
		for( $_ = 0; $_ < @settings; $_++ ) {
			$settings[$_] =~ s~[\n\r]~~g;
		}
		$spass=crypt("$settings[0]",$pwseed);
		if($spass ne $password && $password ne $settings[0]) {
			if($action ne "logout") { &fatal_error("$txt{'39'}"); }
		}
		$realname = $settings[1];
		$realemail = $settings[2];
	}
}

sub LoadUser {
	my $user = $_[0];
	unless( exists $userprofile{$user} ) {
		open(FILEAUSER, "$memberdir/$user.dat") || return;
		&lock(FILEAUSER);
		@{$userprofile{$user}} = <FILEAUSER>;
		&unlock(FILEAUSER);
		close(FILEAUSER);
		for( $_ = 0; $_ < @{$userprofile{$user}}; $_++ ) {
			chomp $userprofile{$user}->[$_];
		}
	}
}

sub LoadCookie {
	foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
		$_ =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		($cookie,$value) = split(/=/);
		$yyCookies{$cookie} = $value;
	}
	$username = $yyCookies{$cookieusername} || 'Guest';
	$password = $yyCookies{$cookiepassword} || '';
}

sub loadfiles {
	require "$sourcedir/Admin.pl";
	require "$sourcedir/BoardIndex.pl";
	require "$sourcedir/Display.pl";
	require "$sourcedir/ICQPager.pl";
	require "$sourcedir/InstantMessage.pl";
	require "$sourcedir/LockThread.pl";
	require "$sourcedir/LogInOut.pl";
	require "$sourcedir/Maintenance.pl";
	require "$sourcedir/ManageBoards.pl";
	require "$sourcedir/ManageCats.pl";
	require "$sourcedir/Memberlist.pl";
	require "$sourcedir/MessageIndex.pl";
	require "$sourcedir/ModifyMessage.pl";
	require "$sourcedir/MoveThread.pl";
	require "$sourcedir/Notify.pl";
	require "$sourcedir/Post.pl";
	require "$sourcedir/Profile.pl";
	require "$sourcedir/Recent.pl";
	require "$sourcedir/Register.pl";
	require "$sourcedir/RemoveOldThreads.pl";
	require "$sourcedir/RemoveThread.pl";
	require "$sourcedir/Search.pl";
	require "$sourcedir/Security.pl";
	#require "$sourcedir/SearchResult.pl";
	require "$sourcedir/Subs.pl";
	#require "Printpage.pl";
	#require "Reminder.pl";
}

1;