#!/usr/bin/perl

$id = shift @ARGV;

open(HEAD, ">thread.lst")||die "couldnt open thread.lst\n";
close(HEAD);

foreach $ubb (@ARGV){
        $id++;
        `./ubb2yabb.pl $id < $ubb`;
}

`./revThreads`;

