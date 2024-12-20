#!/usr/bin/perl
# Diablo Log Modules
#   console - major functions
#   irc - connection
#   diablo - commands

#############################
# Start Logs
	open(CONSOLELOG,">>./logs/console.log");
	printf CONSOLELOG "\n[start] -=- diablo bot\n";

	open(IRCLOG,">>./logs/irc.log");
	printf IRCLOG "\n[start] -=- connection log\n";

	open(DIABLOLOG,">>./logs/diablo.log");
	printf DIABLOLOG "\n[start] -=- command log\n";

############################
# Log Subroutines
sub console {
	($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime(time());
   	$text = sprintf("%02d/%02d/%2d %02d:%02d:%02d %s",$day,$mon,$year,$hour,$min,$sec,$_[0]);
        select(CONSOLELOG); 
	$| = 1;
   	print CONSOLELOG "$text";
   	select(STDOUT);
}

sub irclog {
        ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime(time());
        $text = sprintf("%02d/%02d/%2d %02d:%02d:%02d %s",$day,$mon,$year,$hour,$min,$sec,$_[0]);
        select(IRCLOG); 
	$| = 1;
        print IRCLOG "$text";
        select(STDOUT);
}

sub diablolog {
        ($sec,$min,$hour,$day,$mon,$year,$wday,$yday,$isdst) = localtime(time());
        $text = sprintf("%02d/%02d/%2d %02d:%02d:%02d %s",$day,$mon,$year,$hour,$min,$sec,$_[0]);
        select(DIABLOLOG); $
	| = 1;
        print DIABLOLOG "$text:;
        select(STDOUT);
}
