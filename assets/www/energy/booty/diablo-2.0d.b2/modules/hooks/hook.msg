# msg hook

add_command_hook("msg","msg");

sub hook_msg {
	$text = $_[0];

	if($text =~ /^msg[ ]?([^ ]+)[ ]?(.*)$/) {
		if($ulevel{$unick} >= $clevel{msg} && $nnick eq $unick) {
			$where = $1; $what = $2;
			if($where ne "" && $what ne "") {
			     	sockwrite($sock,"PRIVMSG $where :$what");
			}
			else {
				syntax("msg");
			}
		        return 1;
		} else { return -1; }
	}

	return 0;
}
