#!/usr/bin/perl

###############################################################################
# printpage.pl     by Matthew Mecham                                          #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.org)                            #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Matthew Mecham                               #
###############################################################################

require "Settings.pl";
require "$sourcedir/Subs.pl";

&readform;
##

$board = $INFO{'board'};
$num = $INFO{'num'};

	print "Content-type: text/html\n\n";
	$title = "Print Page";
	
### open up the txt file to set some variables
	
	open(FILE, "$boardsdir/$board.txt") || &donoopen;
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);
	
		foreach $line (@messages) { #start checking
		
		($messagenumber, $messagetitle, $poster, $email, $date, $trash, $trash, $trash) = split (/\|/,$line);
		
			if ($num eq $messagenumber) { # start if
		
			$startedby = $poster;
			$startedon = $date;
		
			} # end if
		
		} # end checking
		
		
### open up the dat file to get the forum name	
	
	open(DATA, "$boardsdir/$board.dat") || &donoopen;
	&lock(DATA);
	@boarddata = <DATA>;
	&unlock(DATA);
	close(DATA);
	
	$boardtitle = @boarddata[0];
	

### Lets open up the thread file itself.
	
	open(THREADS, "$datadir/$num.txt") || &donoopen;
	&lock(THREADS);
	@threads = <THREADS>;
	&unlock(THREADS);
	close(THREADS);
	


### lets out put all that info.



print qq~
<html><head><title>$title</title></head>
<body bgcolor=#ffffff>

<font face=verdana size=3>-$mbname</font><br>
<font face=verdana size=3>--$boardtitle</font><br>
<p>
<font face=verdana size=3>$txt{'195'}: <b>$startedby</b> $txt{'176'} <b>$startedon</b>
<p><p>

~;
	
### Split the threads up so we can print them.	
	
	foreach $thread (@threads) { # start foreach
	
	($threadtitle, $threadposter, $trash, $threaddate, $trash, $trash, $trash, $trash, $threadpost) = split (/\|/,$thread);


	if ($threadpost =~ /^\#nosmileys/ ) { 
		$threadpost =~ s/^\#nosmileys//; 
	} else { 
		$threadpost =~ s/\:\)/\<img src=$imagesdir\/smiley\.gif\>/g;
		$threadpost =~ s/\:\-\)/\<img src=$imagesdir\/smiley\.gif\>/g;
		$threadpost =~ s|\;\)|\<img src=$imagesdir\/wink.gif\>|g;
		$threadpost =~ s|\;\-\)|\<img src=$imagesdir\/wink.gif\>|g;
		$threadpost =~ s|\:D|\<img src=$imagesdir\/cheesy.gif\>|g;
		$threadpost =~ s|\;D|\<img src=$imagesdir\/grin.gif\>|g;
		$threadpost =~ s|\)\:\(|\<img src=$imagesdir\/angry.gif\>|g;
		$threadpost =~ s|\:\-\(|\<img src=$imagesdir\/sad.gif\>|g;
		$threadpost =~ s|\:\(|\<img src=$imagesdir\/sad.gif\>|g;
		$threadpost =~ s|\:o|\<img src=$imagesdir\/shocked.gif\>|g;
		$threadpost =~ s|8\)|\<img src=$imagesdir\/cool.gif\>|g;
		$threadpost =~ s|\?\?\?|\<img src=$imagesdir\/huh.gif\>|g;
	}
	
	$threadpost =~ s|\[\[|\{\{|g;
	$threadpost =~ s|\]\]|\}\}|g;
	$threadpost =~ s|\n\[|\[|g;
	$threadpost =~ s|\]\n|\]|g;
	$threadpost =~ s|<br>| <br>|g;
	$threadpost =~ s|\[hr\]\n|\<hr width=40\% align=left>|g;
	$threadpost =~ s|\[hr\]|\<hr width=40\% align=left>|g;

	$threadpost =~ s/\[url\](\S+?)\[\/url\]/<a href=\"$1\"\ target=\"_blank\">$1<\/a>/isg;
	
	$threadpost =~ s/\[url=http:\/\/(\S+?)\]/<a href=\"http:\/\/$1\"\ target=\"_blank\">/isg;
	$threadpost =~ s/\[url=(\S+?)\]/<a href=\"http:\/\/$1\"\ target=\"_blank\">/isg;
	$threadpost =~ s/\[\/url\]/<\/a>/isg;
	$threadpost =~ s/\ http:\/\/(\S+?)\ / <a href=\"http:\/\/$1\"\ target=\"_blank\">http\:\/\/$1<\/a> /isg;
	$threadpost =~ s/<br>http:\/\/(\S+?)\ /<br><a href=\"http:\/\/$1\"\ target=\"_blank\">http\:\/\/$1<\/a>/isg;
	$threadpost =~ s/^http:\/\/(\S+?)\ /<a href=\"http:\/\/$1\"\ target=\"_blank\">http\:\/\/$1<\/a>/isg;

	$threadpost =~ s/\[b\]/<b>/isg;
	$threadpost =~ s/\[\/b\]/<\/b>/isg;

	$threadpost =~ s/\[i\]/<i>/isg;
	$threadpost =~ s/\[\/i\]/<\/i>/isg;

	$threadpost =~ s/\[u\]/<u>/isg;
	$threadpost =~ s/\[\/u\]/<\/u>/isg;
	
	
	$threadpost =~ s/\[img\](.+?)\[\/img\]/<img src=\"$1\">/isg;
	
	$threadpost =~ s/\[color=(\S+?)\]/<font color=\"$1\">/isg;
	$threadpost =~ s/\[\/color\]/<\/font>/isg;
	
	$threadpost =~ s/\[quote\]<br>(.+?)<br>\[\/quote\]/<blockquote><hr>$1<hr><\/blockquote>/isg;
	$threadpost =~ s/\[quote\](.+?)\[\/quote\]/<blockquote><hr><b>$1<\/b><hr><\/blockquote>/isg;

	$threadpost =~ s/\\http:\/\/(\S+)/<a href=\"http:\/\/$1\"\ target=\"_blank\">http:\/\/$1<\/a>/isg;
	
	$threadpost =~ s/\[fixed\]/<font face=\"Courier New\">/isg;
	$threadpost =~ s/\[\/fixed\]/<\/font>/isg;

	$threadpost =~ s/\[sup\]/<sup>/isg;
	$threadpost =~ s/\[\/sup\]/<\/sup>/isg;

	$threadpost =~ s/\[sub\]/<sub>/isg;
	$threadpost =~ s/\[\/sub\]/<\/sub>/isg;

	$threadpost =~ s/\[center\]/<center>/isg;
	$threadpost =~ s/\[\/center\]/<\/center>/isg;

	$threadpost =~ s/\[list\]/<ul>/isg;
	$threadpost =~ s/\[\*\]/<li>/isg;
	$threadpost =~ s/\[\/list\]/<\/ul>/isg;

	$threadpost =~ s/\[pre\]/<pre>/isg;
	$threadpost =~ s/\[\/pre\]/<\/pre>/isg;

	$threadpost =~ s/\[code\](.+?)\[\/code\]/<blockquote><font size=\"1\" face=\"Courier New\">code:<\/font><hr><font face=\"Courier New\"><pre>$1<\/pre><\/font><hr><\/blockquote>/isg;

	$threadpost =~ s/\\(\S+?)\@(\S+)/<a href=\"mailto:$1\@$2\"\>$1\@$2<\/a>/ig;

	$threadpost =~ s/\[email=(\S+?)\]/<a href=\"mailto:$1\">/isg;
	$threadpost =~ s/\[\/email\]/<\/a>/isg;

	$threadpost =~ s|\{\{|\[|g;
	$threadpost =~ s|\}\}|\]|g;
	
	####
	
print qq~

<hr size=2><p>
<font face=verdana size=3>$txt{'196'} <b>$threadtitle</b> - $txt{'197'}: <b>$threadposter</b> $txt{'176'} <b>$threaddate</b>
<hr>
$threadpost</font><p>
~;	
	
	} # end for each.
	
	
print qq~

<p><p><font face=verdana size=3><b><i>$txt{'198'}</i></b></font>
</body></html>

~;

##############

sub donoopen {

print qq~

<html><head><title>$txt{'199'}</title></head>
<body bgcolor=#ffffff>
<center>$txt{'199'}</center>
</body></html>

~;

}

############



	
	


################
    	
exit;
