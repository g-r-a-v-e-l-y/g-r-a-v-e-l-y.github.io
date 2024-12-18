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

$securityplver="1 Gold Beta4";

sub is_admin {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
}

sub is_admin2 {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'134'}"); }
}

sub banning {
	$remote_ip = "$ENV{'REMOTE_ADDR'}";
	open(BAN, "$vardir/ban.txt" );
	@entries = <BAN>;
	close(BAN);
	foreach $ban_ip (@entries) {
   		chop($ban_ip);
   		$str_len = length($ban_ip);
   		$comp_ip = substr($remote_ip,0,$str_len);
   		if ($comp_ip eq $ban_ip) {
      			open(LOG, ">>$vardir/ban_log.txt" );
      			&lock(LOG);
      			print LOG "$remote_ip\n";
      			&unlock(LOG);
     			close(LOG);
      			print "Content-type: text/html\n\n";
      			print "<html>";
      			print "<body>";
      			print "<H2>Sorry, ";
      			print "$remote_ip";
      			print " $txt{'430'}!";
      			print "</H2>";
      			print "</body>";
      			print "</html>";
      			exit;
      		}
	}
}

sub CheckIcon {
	$icon =~ s/[^A-Za-z]//g;
	unless($icon eq "xx" || $icon eq "thumbup" || $icon eq "thumbdown" || $icon eq "exclamation") {
		unless($icon eq "question" || $icon eq "lamp" || $icon eq "smiley" || $icon eq "angry") {
			unless($icon eq "cheesy" || $icon eq "laugh" || $icon eq "sad" || $icon eq "wink") {
				$icon = "xx";
			}
		}
	}
}

1;