#!/usr/bin/perl
# Functions.pm
#   Diablo Bot IRC Function
#   Modules

###########################
# Modules
sub terminate {
        sockwrite($sock,"QUIT :$ver : terminated");
        close($sock);
        close($jsock);
        unlink("$ENV{HOME}/.diablo.pid");
        console("*** terminated\n");
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

sub urlencode {
        $string = $_[0];
        $string =~ s/ /\+/g;
        @chars = split(//,$string);
        $output = "";
        foreach $char (@chars) {
                if ($char !~ /[a-zA-Z0-9\+ ]/) {
                        $output .= sprintf("%%%02x",ord($char));
                }
                else {
                        $output .= $char;
                }
        }
        return $output;
}

