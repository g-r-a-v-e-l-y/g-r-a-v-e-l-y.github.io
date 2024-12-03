#!/usr/bin/perl
# lets leech img directories and make gaim compatible emote themes :)
# Grant Stavely
# http://www.grantstavely.com/
# made just before diner, probably shitty code
# 10/10/07
# reqs: wget, tar
use strict;

# where the emotes are, full path
#my $emote_site = "http://secret.cc/pics/wut/";
# replace this with a command line argument, no trailing slash
# good programs are nitpicky about trailing slashses hurfdurf
my $destination_directory = "./";
# be quite, don't recurse up, don't create directories, ignore robots.txt, recurse if necessary one level, only keep gif files
#my $wget_string = "wget -q -np -nd -erobots=off -r -l1 -A gif $emote_site $destination_directory";

# ACTION

#print "Leeching emotes from $emote_site...\n";
#my $leech_emotes = `$wget_string`;

print "Generating theme file\n";
# Lets start it up!
opendir(DIR, $destination_directory);
my @files = grep(/\.gif$/,readdir(DIR));
closedir(DIR);

# dump to a 'theme' file
open(DAT,">$destination_directory/theme") || die("Cannot open file! Oh Toes!");
my $file;
foreach $file (@files) {
    #print DAT "$file\t\t";
    $file =~ /((emot-)?)(.*)(\.gif)/;
    print DAT "\" :$3:\"\t=>\t\$imga.\"$3\".\$imgb,\n";
}
close(DAT);

# this should be optional, but wtf
#print "Archiving it, so that you can just import it on a drag and drop\n";
#print "haha just kidding, have fun finding pixmaps directories.\n";
#print "Damn you Pidgin!\n";
#my $tar_it_up = `tar -czvf $destination_directory.tar.gz $destination_directory`;



