#!/usr/bin/perl

$id = $ARGV[0];
print "$id\n";

@head = split /\|/, <STDIN>;

$originator = $head[6];
$topic = $head[8];
chomp $topic;

print "$originator\n";
print "$topic\n";

open(THREAD, ">$id.txt")||die "couldnt open $id.txt\n";
open(HEAD, ">>thread.lst")||die "couldnt open thread.lst\n";

$count=-1;
while(<STDIN>){
        ($a, $b, $user, $date, $time, $f, $msg) = split /\|\|/;
    print "$user\n"; 
        print "$date\n";
        print "$time\n";
        print "$msg\n";

        $dtime = $date . " at " . $time;
        print THREAD "$topic|$user||$dtime|$user|xx|0|127.0.0.1|$msg";

        $count++;
}

print HEAD "$id|$topic|$originator||$dtime|$count||xx|0\n";

close(THREAD);
close(HEAD);
