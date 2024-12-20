#!/usr/bin/perl
# List.pm
#   Diablo Bot List Functions

#############################
# User Modules
sub loadusers {
 	open(FILE,"$datadir/user.db");
 	while (!eof(FILE)) {
  		$uline = <FILE>;
  		if ($uline =~ /(.*):(.*):(.*):(.*):(.*):(.*)/) {
   			$uhosts{lc($1)}=$2;
   			$ulevel{lc($1)}=$3;
  			$uchans{lc($1)}=$4;
 		  	$uzip{lc($1)}=$5;
			$upass{lc($1)}=$6
   		}
  	}
 	close(FILE);
 	console("*** loaded users\n");
	saveusers();
}

sub saveusers {
 	open(FILE,">$datadir/user.db");
 	foreach $key (keys %uhosts) {
  		if ($key ne $nick && $uhosts{$key} ne "" && defined($ulevel{$key}) && defined($uchans{$key})) { 
			printf FILE "$key:$uhosts{$key}:$ulevel{$key}:$uchans{$key}:$uzip{$key}:$upass{$key}\n";
		}
  	}
 	close(FILE);
 	console("*** saved users\n");
}

sub loadchannels {
 	undef(%channels);
 	open(FILE,"$datadir/chan.db");
 	while (!eof(FILE)) {
	  	$uline = <FILE>;
	  	$uline =~ /^([^ ]*) (.*)$/;
	  	$chan = lc($1);
	  	$chanflags{$chan} = $2;
  		proccesschanflags($chan,$2);
  	}
 	close(FILE);
 	console("*** loaded channels\n");
}

sub savechannels {
 	open(FILE,">$datadir/chan.db");
 	foreach $key (keys %channels) {
  		$key = lc($key);
  		printf FILE "$key $chanflags{$key}\n";
  	}
 	close(FILE);
	console("*** saved channels\n");
}

sub loadfiles {
 	$quotes = "./data/quotes";
 	do "$quotes";
}
