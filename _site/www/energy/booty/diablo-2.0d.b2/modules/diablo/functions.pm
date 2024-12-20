#!/usr/bin/perl
# Functions.pm
#   Diablo Bot Function
#   Modules

###########################
# Modules
sub syntax {
	sockwrite($sock,"PRIVMSG $uchan :Improper syntax, \2\/msg $nick help $_[0]\2.");
}

sub restart {
    	console("*** restart by $unick\n");
    	if ($_[0] ne "") { $reason=$_[0]; } else { $reason="$restartmsg"; }
    	sockwrite($sock,"QUIT :$reason");
    	close($sock);
    	unlink("$ENV{HOME}/.diablo.pid");
        if ($log eq true) {
                printf CONSOLELOG "[end]\n";
                close(CONSOLELOG);
                printf IRCLOG "[end]\n";
                close(IRCLOG);
                printf DIABLOLOG "[end]\n";
                close(DIABLOLOG);
        }
    	exec("$_[1]");
}

sub ddie {
    	console("*** die by $unick\n");
    	if ($_[0] ne "") { $reason=$_[0]; } else { $reason="$diemsg"; }
    	sockwrite($sock,"QUIT :$reason");
    	close($sock);
    	unlink("$ENV{HOME}/.diablo.pid");
        if ($log eq true) {
                printf CONSOLELOG "[end]\n";
                close(CONSOLELOG);
                printf IRCLOG "[end]\n";
                close(IRCLOG);
                printf DIABLOLOG "[end]\n";
                close(DIABLOLOG);
        }
    	exit(0);
}

sub checkhost {
 	if ($_[0] eq $nick) { return $nick; }
 	if ($uhosts{$_[0]} ne "" && checkonehost($uhosts{$_[0]},$_[1]) eq true) { return $_[0];}
 	foreach $key (%uhosts) {
  		if ($uhosts{$key} ne "" && checkonehost($uhosts{$key},$_[1]) eq true) { return $_[0];}
  	}
 	return false;
}

sub checkident {
        if ($idhost{$_[0]} ne "" && checkonehost($idhost{$_[0]},$_[1]) eq true) { 
		return true;
	}
	else {
		$idhost{$_[0]} = "";
        	return false;
	}
}

sub checkonehost {
 	@hosts = split(' ',$_[0]);
 	undef $chost;
 	foreach $chost (@hosts) {
  		if ($_[1] =~ /$chost/) { return true; }
  	}
 	return 'false';
}

sub alarm {
	saveall();
	nsident();
	alarm 1200;
}

sub backend {
 	$news = $_[1];
 	$stories = "0";
 	sockwrite($sock,"PRIVMSG $uchan :$news Headlines:");
 	@file = split(/\n/,$_[0]);
 	undef($data);
 	for ($i=0; $i<=$#file; $i++) {
  		$line = $file[$i];
  		if ($line =~ /<item>/) {
   			$line = $file[++$i];
   			if ($line =~ /<title>(.*)<\/title>$/) {
    				$stories = $stories + 1;
    				if($stories <= 5) {
     					sockwrite($sock,"PRIVMSG $uchan :$stories) $1");
     				}
    			}
   		}
 	}
 	chop($data);
 	chop($data);
 	$data =~ s/\&amp;/\&/g;
 	$data =~ s/\&lt;/\</g;
 	$data =~ s/\&gt;/\>/g;
 	$data =~ s/\&apos;/\'>/g;
 	$data =~ s/\&quot;/\">/g;
 	return $data;
}

sub broadcast {
    	foreach $key (sort keys %channels) {
    		sockwrite($sock,"PRIVMSG $key :Broadcast from $_[1]\: $_[0]");
	}
}

sub nsident {
 	if ($_[0] ne "") { $nickpass=$_[0]; } else { $nickpass="$nickservpass"; }
 	sockwrite($sock,"PRIVMSG $nickserv :IDENTIFY $nickpass");
 	console("NICKSERV IDENTIFY by $_[1]");
}

sub pickrandom {
 	$num = rand($#_+1);
 	return $_[$num];
}

sub rquote {
    	$reply = pickrandom(@rquotes);
    	sockwrite($sock,"PRIVMSG $_[0] :$_[1], $reply");
}

sub rehash {
   	loadchannels();
   	loadusers();
}

sub saveall {
 	savechannels();
 	saveusers();
	console("*** saved all\n");
}

sub getallops {
	nsident();
     	$i = 0;
     	foreach $key (sort keys %channels) {
		$i++;
		sockwrite($sock,"PRIVMSG $chanserv :op $key $nick");
		if($i eq 4) {
			$i=0;
			sleep 1;
		}
	}
}

sub pack_com {

}

sub commands {
	$unick = $_[0];
	$uchan = $_[1];
	$utext = $_[2];
	$query = $_[3];
	do "./modules/command/general.com";
}

sub query_com {
        $unick = $_[0];
        $uchan = $_[1];
        $utext = $_[2];
        $query = $_[3];
        do "./modules/command/query.com";
}

sub chan_com {
        $unick = $_[0];
        $uchan = $_[1];
        $utext = $_[2];
        $query = $_[3];
        do "./modules/command/chan.com";
}
