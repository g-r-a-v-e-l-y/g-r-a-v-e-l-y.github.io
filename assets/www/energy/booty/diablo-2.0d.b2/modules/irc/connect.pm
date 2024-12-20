#!/usr/bin/perl
# Connect.pm
#   IRC Socket and connection perl
#   modules file.

##################################
# socket modules
sub sockwrite {
        my $sck = $_[0];
        $outln = $_[1];
        select($sck); $| = 1;
        print $sck "$outln\n";
        select(STDOUT);
}



sub getline {
	my $line = "";
	while (1) {
 		if ($sock) {
			$buf = ' ';
			if ($sock->sysread($buf,1) <= 0) { last; }
			if ($buf eq "\n") {
				return $line;
			}
  			elsif ($buf ne "\r") {
				$line.=$buf;
			}
  		}
 	}
}

##################################
# Modules
sub serverconnect {
	$konnekted = false;
 	while ($konnekted eq false) {
  		$servers[$curserver] =~ /([^:]*)[:]?(.*)/;
  		$server=$1;
		if ($2 eq "") { $port="6667"; } else { $port=$2; }
  		$curserver++;
  		if ($curserver > $#servers) { $curserver=0; }
  		$nick = $nicks[$curnick];
		$konnekted = jumptoserver();
  	}
}

sub fhbits {
 	my(@fhlist) = split(' ',$_[0]);
 	my($bits);
	for (@fhlist) {
  		vec($bits,fileno($_),1) = 1;
  	}
 	$bits;
}

sub jumptoserver {
 	console("*** connecting to $server:$port\n");
# 	$sock = konnekt($server,$port);
	$peer = $server . ":" . $port;
	$sock = IO::Socket::INET->new(PeerAddr => $peer, Timeout => 50);
 	if ($sock) {
  		sockwrite($sock,"USER $ident dummy dummy :$username");
  		sockwrite($sock,"NICK $nick");
  		console("*** done\n");
  	}
 	else {
  		return false;
  	}
 	return true;
}

sub konnekt {
 	($server, $port) = @_;
 	local *SOCK;
	$iaddr = inet_aton($server);
 	$paddr = sockaddr_in($port,$iaddr);
 	$proto = getprotobyname('tcp');
 	socket(SOCK, PF_INET, SOCK_STREAM, $proto) or die "socket failed: $!";
 	$sockaddr = 'S n a4 x8';
 	if (!connect(SOCK,$paddr)) { 
		console("*** connect failed: $!\n"); 
		return 0; 
	}
 	return *SOCK;
}

sub httpget {
 	$sockette = konnekt($_[0],$_[1]);
 	sockwrite($sockette,"GET $_[2] HTTP/1.0\n");
 	undef($data);
 	while (!eof($sockette)) {
  		$line = <$sockette>;
  		$data .= $line;
  	}
 	return $data;
}

