#!C:/web/perl/bin

###############################################################################
# Printpage.pl                                                                #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef@zefnet.com)                   #
# Software Version: YaBB 1 Gold Beta4                                         #
# =========================================================================== #
# Software Distributed by:    www.yabb.org                                    #
# Support, News, Updates at:  www.yabb.org/cgi-bin/support/YaBB.pl            #
# =========================================================================== #
# Copyright (c) 2000-2001 YaBB - All Rights Reserved                          #
# Software by: The YaBB Development Team                                      #
###############################################################################

if( $ENV{'SERVER_SOFTWARE'} =~ /IIS/ ) {
	$yyIIS = 1;
	$0 =~ m~(.*)(\\|/)~;
	$yypath = $1;
	$yypath =~ s~\\~/~g;
	chdir($yypath);
	push(@INC,$yypath);
	print "HTTP/1.0 200 OK\n";
}

require "Settings.pl";
require "$language";
require "$sourcedir/Subs.pl";
require "$sourcedir/Load.pl";
require "$sourcedir/Security.pl";

$printpageplver="1 Gold Beta4";

### Set the Cookie Exp. Date and the Current Date###
$Cookie_Exp_Date = "Mon, 31-Jan-3000 00:00:00 GMT"; # default just in case
&SetCookieExp;
&get_date;

&readform;

#if ($INFO{'catsearch'} !~ /^[\s0-9A-Za-z#%+,-\.:=?@^_]+$/){ &fatal_error("$txt{'399'}" ); }
if ($FORM{'catsearch'} =~ /\//){ &fatal_error("$txt{'397'}" ); }
$cgi = "$boardurl/YaBB.pl\?board=$currentboard";

### Load the user's cookie (or set to guest) ###
&LoadCookie;

### Load user settings ###
&LoadUserSettings;

if ($INFO{'board'} =~ /\//){ &fatal_error("$txt{'399'}" ); }
if ($INFO{'board'} =~ /\\/){ &fatal_error("$txt{'400'}" ); }
if ($INFO{'board'} !~ /^[\s0-9A-Za-z#%+,-\.:=?@^_]+$/){ &fatal_error("$txt{'399'}" ); }

$board = $INFO{'board'};
$num = $INFO{'num'};

	$currentboard = "$board";
	if($currentboard ne "") { &DPPrivate; }

	print "Content-type: text/html\n\n";
	$yytitle = "Print Page";

### open up the txt file to set some variables
	open(FILE, "$boardsdir/$board.txt") || &donoopen;
	&lock(FILE);
	@messages = <FILE>;
	&unlock(FILE);
	close(FILE);

	foreach $line (@messages) {
		($messagenumber, $messagetitle, $poster, $email, $date, $trash, $trash, $trash) = split (/\|/,$line);
		if ($num eq $messagenumber) {
			$startedby = $poster;
			$startedon = $date;
		}
	}

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

### Lets output all that info.
print qq~
<html>
<head>
<title>$yytitle</title>
</head>

<body bgcolor="#FFFFFF" text="#000000">


<pre>
<font face="verdana" size="3">
    <b>$mbname</B>
         $boardtitle
           <B>$txt{'195'}: $startedby $txt{'176'} $startedon</b>
</pre>
~;

### Split the threads up so we can print them.
	foreach $thread (@threads) { # start foreach
	($threadtitle, $threadposter, $trash, $threaddate, $trash, $trash, $trash, $trash, $threadpost) = split (/\|/,$thread);

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
<hr size=2 width="100%">
<font face=verdana size=2>$txt{'196'}: <b>$threadtitle</b>
<BR>$txt{'197'}: <b>$threadposter</b> $txt{'176'} <b>$threaddate</b>
<hr>
$threadpost</font><p>
~;

	}

print qq~
</body></html>
~;

sub donoopen {

print qq~
<html><head><title>$txt{'199'}</title></head>
<body bgcolor=#ffffff>
<center>$txt{'199'}</center>
</body></html>

~;
}

exit;