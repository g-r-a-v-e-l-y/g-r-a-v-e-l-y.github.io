#!/usr/bin/perl
# Hooks.pm
#   Modules necessary for dealing with hooks
#    - Add command hook
#    - Del command hook
#    - Process command hook
#    - Check command hook

sub add_command_hook {
	$hook = $_[0];
	$sub = $_[1];
	$sub = "hook_" . $sub;

	undef($temp);
	$temp = check_command_hook($hook);
	if($temp == -1) {
		push(@command_hooks,"$hook");
		push(@command_hook_handlers,"$sub");
	}
}

sub del_command_hook {
	$hook = $_[0];

	undef($temp);
	$temp = check_command_hook($hook);
	if($temp != -1) {
		splice(@command_hooks, $temp, 1, ());
		splice(@command_hook_handlers, $temp, 1, ());
	}
}

sub process_command_hook {
	$hook = $_[0];
	$text = $_[1];

	# be friendly to eval()...
	$text =~ s/\@/\\\@/g;
	$text =~ s/\"/\\\"/g;
	$text =~ s/\'/\\\'/g;
	$text =~ s/\$/\\\$/g;
	$text =~ s/\)/\\\)/g;
	$text =~ s/\(/\\\(/g;
	$text =~ s/\\/\\\\/g;
	$text =~ s/\#/\\\#/g;
	$text =~ s/\%/\\\%/g;
	$text =~ s/\&/\\\&/g;
	$text =~ s/\*/\\\*/g;
	$text =~ s/\-/\\\-/g;
	$text =~ s/\+/\\\+/g;
	$text =~ s/\=/\\\=/g;

	$temp = check_command_hook($hook);
	if($temp != -1) {
		$run_hook = $command_hook_handlers[$temp];
		$run_hook .= "\(\"$text\"\)";
		if($debugmode eq "1") {
			sockwrite($sock,"PRIVMSG $uchan :Hook: $run_hook");
		}
		$status = eval("$run_hook");
		if($debugmode eq "1") {
			sockwrite($sock,"PRIVMSG $uchan :Status: $status");
		}
		if($status eq "-1") {
			sockwrite($sock,"PRIVMSG $uchan :No access.");
		}
		elsif($status eq "0") {
			sockwrite($sock,"PRIVMSG $uchan :Invalid Syntax.");
		}
		return 1;
	}
	else {
		return 0;
	}
}

sub check_command_hook {
	$hook = $_[0];

	$i=0;
	foreach $key (@command_hooks) {
		if($key eq $hook) {
			return $i;
		}
		$i++; # must be after return!
	}
	return -1;
}

