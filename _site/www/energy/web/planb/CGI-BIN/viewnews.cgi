#!/usr/bin/perl
# viewnews.cgi
# NewsPro User CGI
# Version: 3.7.5 build 31
# See newspro.cgi for license information.

# SCRIPT SETTINGS

# If you are using Microsoft IIS, set the following to 1. If you are
# using Unix/Apache, set it to 2. Setting it 0 tries to determine
# automatically, and usually works just fine. If you use IIS yet have
# 500 error problems, try setting the variable to 2, then try 3.

$IIS = 0;

# ** FILE LOCKING **
# File locking is a feature, provided by the operating system, which
# prevents possible serious problems when NewsPro is being used by
# multiple users. Almost every operating system supports this, except
# for Windows 9x. Possible settings:
# 2  Enable file locking. If you know your server supports it, set
#	UseFlock to this.
# 1  Auto-detect file locking support (default).
# 0  Disable file locking. This may result in file corruption.

$UseFlock = 1;

# If you want to use a subroutine other than DoNewsHTML for viewnews.cgi functions, 
# other than search, enter the name here. e.g. 'DoHeadlineHTML'

$VNSub = 'DoNewsHTML';

# If you want to a template other than viewnews.tmpl for viewnews.cgi functions,
# enter the name here. The template file must be in your NewsPro directory
# (the same directory that viewnews.cgi is in).

$VNTmpl = 'viewnews.tmpl';

# Set this to 1 to automatically look for and load ViewNews addons.
# Generally, enable this only if you have addons installed.
# This does slow down viewnews.cgi, as it has to scan for addons
# whenever it is run.

$EnableAddons = 0;

# END OF SETTINGS (unless you encounter problems - then fill out the next section)

# SERVER PROBLEMS WORKAROUNDS
# If the script either gets its URL wrong or produces a fatal error
# about not being able to include npconfig.pl, set the following variables.
# While it won't hurt, most users don't have to.

$abspath = '';
# Set the above to the absolute path to NewsPro's directory, without
# a trailing slash. Example:
# $abspath = '/absolute/path/to/newspro';

$scripturl = '';
# Set the above to the URL to vienews.cgi. Example:
# $scripturl = 'http://www.myserver.com/newspro/viewnews.cgi';
# Once again, you only need to set the above two variables if you're
# having server problems.

# END SERVER PROBLEMS WORKAROUNDS

# The script begins...

eval { &main; };
if ($@) {
	&NPdie("Untrapped Error: $@");
}
exit;

sub main {
# Microsoft servers. Try and be compatible...
if ($IIS != 2) {
	if ($IIS == 0) {
		if ($ENV{'SERVER_SOFTWARE'} =~ m!IIS!) {
			$IIS = 1 
		}
	}
	if (($IIS) && ($0 =~ m!(.*)(\\|\/)!)) {
		chdir($1);
	}
	if ($IIS == 1) {
		print "HTTP/1.0 200 OK\n";
	}
}
# That's over!

if ($UseFlock == 1) {
	if ($^O ne 'MSWin32') {
		$UseFlock = 1;
	}
	else {
		if ($ENV{'PATH'} =~ /WINNT/i) { # Yes, this won't work if you didn't use the default name
					       # for your Windows directory. But the alternative is loading
					       # the Win32 module, which is time-consuming.
			$UseFlock = 1;
		}
		else {
			# We appear to be on Windows 9x.
			$UseFlock = 0;
		}
	}
}
elsif ($UseFlock == 2) {
	$UseFlock = 1;
}

# Server problem workaround #1
if ($abspath) {
	push(@INC, $abspath);
}

require "npconfig.pl";
require "ndisplay.pl";
require "nplib.pl";
ReadForm();
SubmitFormFields();
push(@formfields, 'newstext');

# Put the script's URL into $scripturl.
# Don't if it was already set as a server problem workaround.
unless ($scripturl) {
	$scripturl = &GetScriptURL;
}

ReadConfigInfo();
if ($EnableAddons) {&LoadAddons;}
if (@Addons_ViewNews_Handler) {
	&RunAddons(@Addons_ViewNews_Handler);
}

if (query_string() eq "dispsearchform") {
	print header();
	print qq~
	<b>News Search</b><br>
	<form action="$scripturl?search" method="post">
	<input type="text" name="searchstring" value="Search String">
	Search Field: <select name="searchfield"><option selected>All fields</option>
	~;
	foreach $i (@formfields) {
		print qq~<option value="$i">$i</option>~;
	}
	print qq~
	</select>
	<input type="submit" name="submit" value="Submit">
	</form>
	~;
}

elsif (query_string() =~ /^search/) {
	DoSearch();
}


elsif (query_string() eq "emaillist") {
	&EmailList;
}
elsif (query_string() eq "emaillistform") {
	print header();
	print qq~
	<form action="$scripturl?emaillist" method="post">
	<input type="text" name="npemail" value="your e-mail">
	<input type="submit" name="npsubscribe" value="Subscribe">
	<input type="submit" name="npunsubscribe" value="Unsubscribe">
	</form>
	~;
}
elsif (query_string() =~ /^news/) {
	&ShowNews;
}
elsif (query_string() =~ /^archive/) {
	&ShowArchivedNews;
}
elsif (query_string() eq "disparchiveform") {
	print header();
	print qq~
	<html><body>Below are three forms that can be used to view your archives. Cut and paste these
	forms from the page source.<hr>
	<!-- START ARCHIVE FORM #1 -->
	<form action="$scripturl?archive" method="post">
	View news from: <select name="year">
	<option value="" selected>Year</option>~;
	&PrintSelectValues('same','1999','2000','2001','2002','2003');
	print qq~
	</select><select name="month">
	<option value="" selected>Month</option>~;
	&PrintSelectValues('January','February','March','April','May','June','July','August','September','October','November','December');
	print qq~
	</select><select name="day">
	<option value="" selected>Day</option>~;
	&PrintSelectValues('same',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31);
	print qq~
	</select><input type="submit" name="submit" value="Submit"></form>
	<!-- END ARCHIVE FORM #1 -->
	<hr>
	<!-- START ARCHIVE FORM #2 -->
	<form action="$scripturl?archive" method="post">
	View news from <select name="year1">
	<option value="" selected>Year</option>~;
	&PrintSelectValues('same','1999','2000','2001','2002','2003');
	print qq~
	</select><select name="month1">
	<option value="" selected>Month</option>~;
	&PrintSelectValues('January','February','March','April','May','June','July','August','September','October','November','December');
	print qq~
	</select><select name="day1">
	<option value="" selected>Day</option>~;
	&PrintSelectValues('same',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31);
	print qq~
	</select> to <select name="year2">
	<option value="" selected>Year</option>~;
	&PrintSelectValues('same','1999','2000','2001','2002','2003');
	print qq~
	</select><select name="month2">
	<option value="" selected>Month</option>~;
	&PrintSelectValues('January','February','March','April','May','June','July','August','September','October','November','December');
	print qq~
	</select><select name="day2">
	<option value="" selected>Day</option>~;
	&PrintSelectValues('same',1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31);
	print qq~
	</select> <input type="submit" name="submit" value="Submit"></form>
	<!-- END ARCHIVE FORM #2 -->
	<hr>
	<!-- START ARCHIVE FORM #3 -->
	<form action="$scripturl?archive" method="post">
	View news from the past <input type="text" name="pastdays" size="4" value="7"> days. <input type="submit" name="submit" value="Submit"></form>
	<!-- END ARCHIVE FORM #3 -->
	</body></html>~;	
}
else {
	$OnlyNewNews = 1;
	print header();
	MiniGenHTML(1);
}
}
sub MiniGenHTML {
	my $printmode = shift;
	&GetCookies;
	&loadND;
	$currenttime = time;
	local ($content) = "";
	$oldtime = $currenttime - $NPConfig{'mainpagelimit'};
	$newsnum = @NewsData;
	if ($NPConfig{'NumberLimit'}) {
		$oldnum = $newsnum - $NPConfig{'NumberLimit'};
		if ($oldnum > 0) {
			$oldtime = $NewsData[$oldnum]->{'newstime'};
		} else {
			$oldtime = $NewsData[0]->{'newstime'};
		}
	}
	$newsnum--;
	NVLOOP: while ($newsnum >= 0) {
	getNDvar($newsnum);
	if ($NPConfig{'NewsArcDel'} eq "0" || $newstime >= $oldtime) {
		$BeingArchived = 0;
		$DynamicPage = 1;
		if (@Addons_ViewNews_Build) {
			&RunAddons(@Addons_ViewNews_Build);
		}
		&$VNSub;
		if ($NPConfig{'CreateAnchors'}) {$newshtml = qq~<a name="newsitem$newsid"></a>$newshtml~;}
		unless ($printmode) {
			$content .= $newshtml;
		}
		else {
			print $newshtml;
		}
	}
	$newsnum--;
	}
	if ($NPConfig{'DisplayLink'}) {
			# You can modify this link if you'd like.
			$content .= qq~ <i><small>$Messages{'DisplayLink'} <a href="http://amphibian.gagames.com/newspro/" target="_top">$Messages{'NewsPro'}</a>.</small></i><br> ~;
	}
	unless ($printmode) {
		return $content;
	}
}


sub ShowArchivedNews {
	print header();
	my $content = '';
	my $startdate;
	my $enddate;
	if (query_string() =~ /^archive(\d{4})-(\d{1,2})-(\d{1,2})to(\d{4})-(\d{1,2})-(\d{1,2})/) {
		my ($year1, $month1, $day1, $year2, $month2, $day2) = ($1, $2, $3, $4, $5, $6);
		$startdate = &YMDtoUNIX($year1, $month1, $day1);
		$enddate = &YMDtoUNIX($year2, $month2, $day2);
		$enddate = $enddate + 86399;
	} elsif (query_string() =~ /^archivepast(\d+)days/) {
		($startdate, $enddate) = &PastDaysTime($1);
	} elsif ($in{'pastdays'}) {
		($startdate, $enddate) = &PastDaysTime($in{'pastdays'});
	} elsif ($in{'year'} && $in{'day'} && $in{'month'}) {
		$startdate = &YMDtoUNIX($in{'year'}, $in{'month'}, $in{'day'});
		$enddate = $startdate + 86399;
	} elsif ($in{'year1'} && $in{'year2'} && $in{'day1'} && $in{'day2'} && $in{'month1'} && $in{'month2'}) {
		$startdate = &YMDtoUNIX($in{'year1'}, $in{'month1'}, $in{'day1'});
		$enddate = &YMDtoUNIX($in{'year2'}, $in{'month2'}, $in{'day2'});
		$enddate = $enddate + 86399;
	} else {
		&NPdie($Messages{'Viewnews_Error_1'});
	}
	my @NewNewsData;
	&loadND;
	foreach $i (@NewsData) {
		if ($i->{'newstime'} >= $startdate && $i->{'newstime'} <= $enddate) {
			push(@NewNewsData, $i);
		}
	}
	@NewsData = @NewNewsData;
	$newsnum = @NewsData;
	if ($newsnum == 0) {
		&NPdie($Messages{'Viewnews_Error_1'});
	}
	$newsnum--;
	NVLOOP: while ($newsnum >= 0) {
		&getNDvar($newsnum);
		if (@Addons_ViewNews_Archive) {
			&RunAddons(@Addons_ViewNews_Archive);
		}
		&{$VNSub};
		if ($NPConfig{'CreateAnchors'}) {$newshtml = qq~<a name="newsitem$newsid"></a>$newshtml~;}
		$content .= $newshtml;
		$newsnum--;
	}
	my $date1 = GetTheDate($startdate);
	my $date2 = GetTheDate($enddate);
	&GenPage("$Messages{'Viewnews_From'} $date1 $Messages{'Viewnews_To'} $date2", $content);
}
	
	
	

sub ShowNews {
	print header();
	local ($content) = "";
	$OnlyNewNews = 0;
	query_string() =~ /^news(\S+)/;
	$newsparam = $1;
	if ($newsparam ne "") {
		&loadND;
		$newsnum = @NewsData;
		if (@Addons_ViewNews_Show3) {
			&RunAddons(@Addons_ViewNews_Show3);
		}
		if ($newsparam eq "all") {
			$newsstart = 0;
			$newsend = $newsnum - 1;
		} elsif ($newsparam =~ /item(\d+)/) {
			$newsstart = $1;
			$newsend = $newsstart;
		} elsif ($newsparam =~ /id(\S+)/) {
			$nid = $1;
			$nid =~ s/\_/\,/g;
			$nid =~ s/[^\d,]//g;
			$newsstart = $NewsID{$nid};
			$newsend = $newsstart;
		} else {
			$newsparam =~ /start(\d+)end(\d+)/;
			$newsstart = $1;
			$newsend = $2;
		}
		if (($newsstart < 0) || ($newsstart >= $newsnum) || ($newsend < $newsstart) || ($newsend >= $newsnum) || !defined $newsstart) {
			&NPdie($Messages{'Viewnews_Error_3'});
		}
		$newscount = $newsend;
		while ($newscount >= $newsstart) {
			&getNDvar($newscount);
			$newsnum = $newscount;
			$DynamicPage = 1;
			if (@Addons_ViewNews_Show) {
				&RunAddons(@Addons_ViewNews_Show);
			}
			&{$VNSub};
			if ($NPConfig{'CreateAnchors'}) {$newshtml = qq~<a name="newsitem$newsid"></a>$newshtml~;}
			$content .= $newshtml;
			$newscount--;
		}
		if ($newsstart == $newsend) { $gptitle = $newssubject; }
		else { $gptitle = "$Messages{'Viewnews_Items'} $newsstart-$newsend"; }
		if (@Addons_ViewNews_Show2) {
			&RunAddons(@Addons_ViewNews_Show2);
		}
		&GenPage($gptitle, $content);
	} else {
		$content = MiniGenHTML();
		&GenPage($Messages{'Viewnews_Latest'}, $content);
	}
}

sub EmailList {
	@emaillist = split(/~/, $NPConfig{'emaillist'});
	if ($in{'npsubscribe'}) {
		$in{'npemail'} = lc $in{'npemail'};
		$in{'npemail'} =~ s/\n//g;
		$in{'npemail'} =~ s/\r//g;
		$in{'npemail'} =~ s/~//g;
		$in{'npemail'} =~ s/``x//g;
		$in{'npemail'} =~ s/,//g;
		my $IsDuplicate = 0;
		if ($in{'npemail'} =~ m/^(\S+)\@(\S+).(\S+)/) {
			foreach $i (@emaillist) {
				if ($in{'npemail'} eq $i) {
					$IsDuplicate = 1;
					last;
				}
			}
			unless ($IsDuplicate) {
				$NPConfig{'emaillist'} .= "~$in{'npemail'}";
				&WriteConfigInfo;
			}
			&ELPage(1, $Messages{'Viewnews_EmailAdd'});
		} else {
			&ELPage(0, "$in{'npemail'} $Messages{'Viewnews_EmailFail'}");
		}
	}
	elsif ($in{'npunsubscribe'}) {
		foreach $i (@emaillist) {
			if ($i =~ /^\Q$in{'npemail'}\E$/i) {
				$UnsubscribeSuccess = 1;
			} else {
				push(@newemaillist, $i);
			}
		}
		if ($UnsubscribeSuccess) {
			$NPConfig{'emaillist'} = join('~', @newemaillist);
			&WriteConfigInfo;
			&ELPage(1, "$in{'npemail'} $Messages{'Viewnews_EmailUnsubSuccess'}");
		} else {
			&ELPage(0, "$in{'npemail'} $Messages{'Viewnews_EmailUnsubFail'}");
		}
	} else {
		&ELPage(0, $Messages{'Viewnews_EmailIncomplete'});
	}
}
sub ELPage {
	local ($statuscode, $statusmsg) = @_;
	if ($in{'successredirect'} && $statuscode == 1) {
		print "Location: $in{'successredirect'}\n\n";
		exit;
	}
	if ($in{'failureredirect'} && $statuscode == 0) {
		print "Location: $in{'failureredirect'}\n\n";
		exit;
	}
	print header();
	if ($statuscode) {
		&GenPage("$Messages{'Viewnews_Mailing'}: $Messages{'Viewnews_Success'}", $statusmsg);
	} else {
		&GenPage("$Messages{'Viewnews_Mailing'}: $Messages{'Viewnews_Failure'}", $statusmsg);
	}
}
sub NPdie {
	unless ($HeaderPrinted) {
		print header();
	}
	my $error = shift;
	my $content = "<p><b>Error: $error</b></p>";
	if ($NPdied == 1) {
		print $content;
	} else {
		$NPdied = 1;
		&GenPage("$NPConfig{'SiteTitle'} $Messages{'Error'}", $content);
	}
	exit;
}	
sub DoSearch {
		print header();
		$content = '';
		my %SearchScore;
		&loadND;
		unless ($in{'searchstring'}) {
			query_string() =~ /^search(.*)/;
			$in{'searchstring'} = $1;
			$in{'searchstring'} =~ tr/+/ /;
			$in{'searchstring'} =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		}
		if ($in{'searchfield'}) {
			foreach $field (@formfields) {
				if ($field eq $in{'searchfield'}) {
					$FieldMatched = 1;
					last;
				}
			}
			unless ($FieldMatched) {
				$in{'searchfield'} = "";
			}
		}
		require Text::ParseWords;
		@searchstring = &Text::ParseWords::quotewords('\s+', 0, $in{'searchstring'});
		if (@Addons_ViewNews_DoSearch) {
			&RunAddons(@Addons_ViewNews_DoSearch);
		}
		$newsnum = 0;
		VNLOOP: while ($newsnum < @NewsData) {
			if (@Addons_ViewNews_DoSearch2) {
				&RunAddons(@Addons_ViewNews_DoSearch2)
			}
			if ($in{'searchfield'}) {
				&getNDvar($newsnum);
				$searchData = ${$in{'searchfield'}};
			} else {
				$searchData = join(' ', $NewsData[$newsnum]->{'newstext'}, $NewsData[$newsnum]->{'newssubject'}, $NewsData[$newsnum]->{'newsname'});
			}
			foreach $j (@searchstring) {
				if ($searchData =~ /\Q$j/i) {
					if ($SearchScore{$newsnum}) {
						$SearchScore{$newsnum}++;
					}
					else {
						push(@searchresults, $newsnum);
						push(@searchdates, $NewsData[$newsnum]->{'newstime'});
						$SearchScore{$newsnum} = 1;
					}					
				}
			}
			$newsnum++;
		}
		if (@searchresults > 0) {
			# We have results. Start sorting!
			# Build an array of search scores.
			foreach $key (sort {$a <=> $b} keys %SearchScore) {
				push(@searchscores, $SearchScore{$key});
			}
			# Array built. Now, sort by score, then date.
			@resultssorted = @searchresults [ sort { $searchdates[$a] <=> $searchdates[$b] } 0 .. $#searchdates];
			@resultssorted = @resultssorted [ sort { $searchscores[$a] <=> $searchscores[$b] } 0 .. $#searchscores];
			@resultssorted = reverse(@resultssorted);
			# Sorting is finished. Cut off number of results...
			my $maxsearch = $NPConfig{'MaxSearchResults'} - 1;
			if ($maxsearch < 0) {
				$maxsearch = 0;
			}
			my $rstotal = @resultssorted - 1;
			if ($maxsearch > $rstotal) {
				$maxsearch = $rstotal;
			}
			@resultssorted = @resultssorted[0 .. $maxsearch];
			# ... and display.
			foreach $newsnum (@resultssorted) {
				&getNDvar($newsnum);
				$SearchResult = 1;
				&DoSearchHTML;
				$content .= $newshtml;
			}
		} else {
			$content .= "<b>$Messages{'Viewnews_NoResults'}</b>";
		}
		&GenPage($Messages{'Viewnews_Results'}, $content);
}
sub GenPage {
	my $title = shift;
	my $content = shift;
	$HTTP_REFERER = $ENV{'HTTP_REFERER'};
	if ($abspath) {
		NPopen(TMPL, "$abspath/$VNTmpl");
	}
	else {
		NPopen(TMPL, $VNTmpl);
	}
	@tmpl = <TMPL>;
	close(TMPL);
	$tmpl = join('', @tmpl);
	$tmpl =~ s/<!--INSTRUCTIONS[\s\S]+?END INSTRUCTIONS-->//g; 
	$tmpl =~ s/<TextField\: ([^\s\>\{\[]+)>/${\(HTMLtoText(${$1}))}/g;
	$tmpl =~ s/<TextField\: ([^\s\>\{]+)\{[\'\"]([^\s\>\}\'\"]+)[\'\"]\}>/${\(HTMLtoText(${$1}{$2}))}/g;
	$tmpl =~ s/<TextField\: ([^\s\>\[]+)\[(\d+)\]>/${\(HTMLtoText(${$1}[$2]))}/g;
	$tmpl =~ s/<Field\: ([^\s\>\{\[]+)>/${$1}/gi;
	$tmpl =~ s/<Field\: ([^\s\>\{]+)\{[\'\"]([^\s\>\}\'\"]+)[\'\"]\}>/${$1}{$2}/g;
	$tmpl =~ s/<Field\: ([^\s\>\[]+)\[(\d+)\]>/${$1}[$2]/g;	
	$tmpl =~ s/<\!--#include file\s*?=\s*?"(\S+?)"\s*?-->/${\(VNFileLoad($1))}/gi;
	$tmpl =~ s/<InsertTitle>/$title/g;
	$tmpl =~ s/<InsertContent>/$content/;
	$tmpl =~ s/<InsertTextContent>/${\(HTMLtoText($content))}/g;
	if (@Addons_ViewNews_GenPage) {
		&RunAddons(@Addons_ViewNews_GenPage);
	}
	print $tmpl;
}

sub VNFileLoad {
	my $fname = shift;
	my $file;
	$fname =~ s/([\&;\`'\|\"*\?\~\^\(\)\[\]\{\}\$\n\r])//g;
	open(FILE, $fname) || return '[an error occured while processing this directive]';
	my @file = <FILE>;
	close(FILE);
	$file = join('', @file);
	return $file;
}

sub LoadAddons {
	opendir(ADMINDIR,$NPConfig{'admin_path'});
	my @admindir = readdir(ADMINDIR);
	closedir(ADMINDIR);
	my $direntry;
	foreach $direntry (@admindir) {
		if ($direntry =~ /vna_\S+\.pl/) {
			eval { require "$NPConfig{'admin_path'}/$direntry"; };
		}
	}
	$AddonsLoaded = 1;
}

sub RunAddons {
	my @addonslist = @_;
	my $AddonSub;
	foreach $AddonSub (@addonslist) {
		eval { &$AddonSub; };
	}
}
sub NPopen {
	my $handle = shift; my $path = shift;
	$path =~ s/([\&;\`'\|\"*\?\~\^\(\)\[\]\{\}\$\n\r\0])//g;
	open($handle, $path) || &NPdie("$Messages{'Viewnews_NoOpen'} $path");
	if ($UseFlock) {
		flock($handle, 2);
	}
	return 1;
}
