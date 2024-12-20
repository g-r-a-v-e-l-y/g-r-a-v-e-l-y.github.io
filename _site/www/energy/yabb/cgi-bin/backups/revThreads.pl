i#!/usr/bin/perl

open(HEAD, "thread.lst")||die "couldnt open thread.lst\n";
@LINES=<HEAD>;
close(HEAD);
$SIZE=@LINES;

open(HEAD, ">thread.lst")||die "couldnt open thread.lst\n";
for ($i=$SIZE;$i>=0;$i--) {
        $_=$LINES[$i];
        print HEAD $_;
}
