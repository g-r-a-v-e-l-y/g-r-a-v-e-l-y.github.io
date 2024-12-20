# ack hook

add_command_hook("ack","ack");

sub hook_ack {
	$text = $_[0];

	if($text =~ /^ack$/) {
                $alevel{0} = "\2Default Access\2";
                $alevel{1} = "\2Default Access\2";
                $alevel{2} = "\2Aop\2";  
                $alevel{3} = "\2Sop\2";  
                $alevel{4} = "\2Admin\2";
                $alevel{5} = "\2Owner\2";
		sockwrite($sock,"PRIVMSG $uchan :Current ack level is: \2$ack\2 \(\2$alevel{$ack}\2\)");
		return 1;
	}

	elsif($text =~ /^ack ([^ ]+)$/) {
	     	$seta = lc($1);
		$unk = 0;
		if($nnick eq $unick && $ack <= $ulevel{$unick}) {
			$alevel{0} = "\2Default Access\2";
			$alevel{1} = "\2Default Access\2";
			$alevel{2} = "\2Aop\2";
			$alevel{3} = "\2Sop\2";
			$alevel{4} = "\2Admin\2";
			$alevel{5} = "\2Owner\2";
		     	if ($seta eq "normal" || $seta eq "all" || $seta eq "def") {$seta = "0";}
		     	elsif ($seta eq "aop") {$seta = "2";}
		     	elsif ($seta eq "sop") {$seta = "3";}
		     	elsif ($seta eq "admin") {$seta = "4";}
		     	elsif ($seta eq "owner") {$seta = "5";}
		     	elsif ($seta > 0 && $seta <= 5) { $seta = $seta; }
		     	else {
				$unk = 1;
				$seta = $ack;
				sockwrite($sock,"PRIVMSG $uchan :Unknown ack level, leaving ack at level: $ack \($alevel{$ack}\)");
			}
		
			if ($seta == $ack && $unk != 1) {
				sockwrite($sock,"PRIVMSG $uchan :Ack level unchanged from: $ack \($alevel{$ack}\)");
			}
			elsif ($seta <= $ulevel{$unick} && $unk != 1) {
				$ack = $seta;
				sockwrite($sock,"PRIVMSG $uchan :Ack level now set at: $ack \($alevel{$ack}\)");
			}
			elsif ($unk != 1) {
				$temp = $ulevel{$unick};
				sockwrite($sock,"PRIVMSG $uchan :To set the ack level $alevel{$ack}, access level $alevel{$ack++} is required. Access for account $unick is only $alevel{$temp}.");
			}
		        return 1;
		}
		else {
			return -1;
		}
	}

	return 0;
}
