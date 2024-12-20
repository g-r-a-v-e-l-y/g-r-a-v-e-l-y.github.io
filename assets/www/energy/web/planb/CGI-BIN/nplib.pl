# NPLIB.pl
# Common routines for NewsPro scripts and addons.
# Version: 3.7.5 build 31
# See newspro.cgi for license information.

# Location of nsettings.cgi.
# It is important that your nsettings.cgi is not visible over the Web.
# One way of accomplishing it is to move it to a different directory,
# and give it another name. You can set the following option to the new
# path of nsettings.cgi. Use an absolute path (no trailing slash).
# Example:
# $nsettingspath = '/usr/home/me/securefiles/newspro-settings-5432.cgi';
$nsettingspath = '';



# Lifespan of cookies, in seconds.
# 7776000 seconds is equal to 90 days.
$cookieExpLength = 7776000;

# END OF SETTINGS
###########################################################

# Build number. DO NOT CHANGE!
$nplibBuild = 8;

require "nplang.pl";

@Abbrev_Week_Days = ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
@Abbrev_Months = ('Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec');

# Load values for computing times
$SEC  = 1;
$MIN  = 60 * $SEC;
$HR   = 60 * $MIN;
$DAY  = 24 * $HR;
$epoch = (localtime(2*$DAY))[5];	# Allow for bugs near localtime == 0.
$YearFix = ((gmtime(946684800))[5] == 100) ? 100 : 0;

# Get necessary localtime information into variables.
sub BasicDateVars {
	my $thetime = shift;
	($Second,$Minute,$Hour,$Month_Day, $Month,$Year,$Week_Day,$IsDST) = (localtime($thetime))[0,1,2,3,4,5,6,8]; 
	$ActualMonth = $Month + 1;
	$Year = $Year + 1900;
}

sub GetTheDate {
	my $thetime = shift;
	unless ($thetime) {
		$thetime = time;
		if ($NPConfig{'TimeOffset'}) {
			$thetime += (3600 * $NPConfig{'TimeOffset'});
		}
	}
	my $thedate = $NPConfig{'DateFormat'};
	BasicDateVars($thetime);
	if ($IsDST == 1) {
	    $Time_Zone = $NPConfig{'Daylight_Time_Zone'};
	}
	else {
   		$Time_Zone = $NPConfig{'Standard_Time_Zone'};
	}
	if ($Second < 10) {
	    $Second = "0$Second"; 
	}
	if ($Minute < 10) {
	    $Minute = "0$Minute"; 
	}
	if ($Hour == 0) {
		if ($NPConfig{'12HourClock'}) {$Hour = "12";}
		$AMPM = "AM";
	}
	elsif ($Hour < 12) {
		$AMPM = "AM";
	}
	elsif ($Hour == 12) {
		$AMPM = "PM";
	}
	else {
		if ($NPConfig{'12HourClock'}) {$Hour = $Hour - 12;}
		$AMPM = "PM";
	}
	$Month_Name = $Months[$Month];
	$Month_Number = $ActualMonth;
	$Weekday = $Week_Days[$Week_Day];
	$Day = $Month_Day;
	$thedate =~ s/<Field: ([^>]+)>/${$1}/gi;
	return $thedate;
}

	
# DoGMTTime: Return date in GMT text format. Used for HTTP expiry dates
# WARNING: Does not take time into account, always returns time of 00:00:00 (midnight)
sub DoGMTTime {
	my $thetime = shift;
	my $thedate;
	my ($Second,$Minute,$Hour,$Month_Day, $Month,$Year,$Week_Day,$IsDST) = (localtime($thetime))[0,1,2,3,4,5,6,8];	
	if ($Month_Day < 10) {
		$Month_Day = "0$Month_Day";
	}
	$Year = $Year + 1900;
	$thedate = "$Abbrev_Week_Days[$Week_Day], $Month_Day-$Abbrev_Months[$Month]-$Year 00:00:00 GMT";
	return $thedate;
}

# YMDtoUNIX
# Turns a date of form 1999-7-13 (July 13, 1999) into UNIX time.
# Uses time of midnight.
sub YMDtoUNIX {
	my ($textyear, $textmonth, $textday) = @_;
	my $unixtime;
	$textyear = $textyear - 1900;
	$textmonth = $textmonth - 1;
	$unixtime = timelocal(0,0,0, $textday, $textmonth, $textyear);
	return $unixtime;
}
	
# WriteConfigInfo: Saves %NPConfig settings to nsettings.cgi
sub WriteConfigInfo {
	my $nsetpath = $nsettingspath;
	if ($abspath && !$nsetpath) {
		$nsetpath = "$abspath/nsettings.cgi";
	}
	$nsetpath = 'nsettings.cgi' unless $nsetpath;
	NPopen('NPCFG', ">$nsetpath");
	$NPConfig{'firsttime'} = "no";
	foreach $key (keys %NPConfig) {
		$NPConfig{$key} =~ s/^\s+//;
		$NPConfig{$key} =~ s/\s+$//;
		$NPConfig{$key} =~ s/\n//g;
		$NPConfig{$key} =~ s/\r//g;
		if ($key ne '' && $NPConfig{$key} ne '') {
			print NPCFG "$key``x$NPConfig{$key}\n";
		}
	}
	close(NPCFG);
}

# ReadConfigInfo: Reads configuration from nsettings.cgi into %NPConfig
sub ReadConfigInfo {
	my $nsetpath = $nsettingspath;
	if ($abspath && !$nsetpath) {
		$nsetpath = "$abspath/nsettings.cgi";
	}
	$nsetpath = 'nsettings.cgi' unless $nsetpath;
	NPopen('NPCFG', $nsetpath);
	my @npconfig = <NPCFG>;
	close(NPCFG);
	foreach $i (@npconfig) {
		($varname, $varvalue) = split(/``x/, $i);
		$varvalue =~ s/^\s+//;
		$varvalue =~ s/\s+$//;
		$varvalue =~ s/\n//g;
		$NPConfig{$varname} = $varvalue;
	}
}

# Gets our ful URL. Needed for error messages.
sub GetScriptURL {
	my $url = 'http://' . ($ENV{'HTTP_HOST'} ? $ENV{'HTTP_HOST'} : $ENV{'SERVER_NAME'}) .  
	($ENV{'SERVER_PORT'} != 80 ? ":$ENV{'SERVER_PORT'}" : '') .
	$ENV{'SCRIPT_NAME'};
	return $url;
	
}

# header: A convenience that returns the full Content-type header.
sub header {
	unless ($HeaderPrinted) {
		$HeaderPrinted = 1;
		return "Content-type: text/html\n\n";
	}
	else {
		return '';
	}
}

# ReadForm: Reads in POSTed form values to %in
sub ReadForm {
	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
	my @pairs = split(/&/, $buffer);
	foreach $pair (@pairs) {
	($name, $value) = split(/=/, $pair);
		$value =~ tr/+/ /;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
		unless($in{$name}) {$in{$name} = $value;}
		else {
			$in{$name} .= "|x|$value";
		}
	}
}


# GetCookies: Reads in HTTP Cookies to %Cookies
sub GetCookies {
	# Load Encode/Decode Data
	@Cookie_Encode_Chars = ('\%', '\+', '\;', '\,', '\=', '\&', '\:\:', '\s');
	
	%Cookie_Encode_Chars = ('\%',   '%25',
	                        '\+',   '%2B',
	                        '\;',   '%3B',
	                        '\,',   '%2C',
	                        '\=',   '%3D',
	                        '\&',   '%26',
	                        '\:\:', '%3A%3A',
	                        '\s',   '+');
	
	@Cookie_Decode_Chars = ('\+', '\%3A\%3A', '\%26', '\%3D', '\%2C', '\%3B', '\%2B', '\%25');
	
	%Cookie_Decode_Chars = ('\+',       ' ',
	                        '\%3A\%3A', '::',
	                        '\%26',     '&',
	                        '\%3D',     '=',
	                        '\%2C',     ',',
	                        '\%3B',     ';',
	                        '\%2B',     '+',
	                        '\%25',     '%');
	local($cookie,$value);
	if ($ENV{'HTTP_COOKIE'}) {
	foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
		($cookie,$value) = split(/=/);
		foreach $char (@Cookie_Decode_Chars) {
			$cookie =~ s/$char/$Cookie_Decode_Chars{$char}/g;
			$value =~ s/$char/$Cookie_Decode_Chars{$char}/g;
		}
		$Cookies{$cookie} = $value;
	}
	}
}

# SetCookies: Prints a HTTP header, setting any cookies passed to it.
# WARNING: Must be run after GetCookies
sub SetCookies {
	local(@cookies) = @_;
	local($cookie,$value,$char);
	print "Content-type: text/html\n";
	while ( ($cookie,$value) = @cookies ) {
		foreach $char (@Cookie_Encode_Chars) {
			$cookie =~ s/$char/$Cookie_Encode_Chars{$char}/g;
			$value =~ s/$char/$Cookie_Encode_Chars{$char}/g;
		}
	
		print 'Set-Cookie: ' . $cookie . '=' . $value . ';';
		$exptime = time + $cookieExpLength;
		$CookieExpires = DoGMTTime($exptime);
		print ' expires=' . $CookieExpires . ';';
		print "\n";
		shift(@cookies); shift(@cookies);
	}
	print "\n";
	$HeaderPrinted = 1;
}

sub ClearCookies {
	print "Content-type: text/html\n";
	print "Set-Cookie: uname=x; expires=Thu, 03-Feb-2000 00:00:00 GMT;\n";
	print "Set-Cookie: pword=x; expires=Thu, 03-Feb-2000 00:00:00 GMT;\n\n";
	$HeaderPrinted = 1;
}

sub query_string {
	return $ENV{'QUERY_STRING'};
}

# Is this news item from a different date than the last one?
sub isNewDate {
	my $isNewDate;
	my $mdy = "$Month_Day$Month$Year";
	if ($isNewDate{$FileName} ne $mdy) {
		$isNewDate = 1;
	} else {
		$isNewDate = 0;
	}
	$isNewDate{$FileName} = $mdy;
	return $isNewDate;
}
#######
# NEWS DATABASE LOAD/SAVE
######

# Loads newsdat.txt, and reads news data into a variety of places.
sub loadND {
	undef @NewsData;
	
	# Get form field information, add certain hard-coded ones (mainly date & time)
	&SubmitFormFields;
	my @ffields = @formfields;
	@ffield_add = ('newstext', 'newsid', 'newstime', 'newsrand', 'newscat');
	if (@Addons_loadND_1) {
		&RunAddons(@Addons_loadND_1);
	}
	push(@ffields, @ffield_add);	
	
	# Declare variables
	my $newsnum = 0;
	my $newsline;
	my $formfield;
	
	# Open newsdat.txt
	&NPopen('NEWSDAT', "$NPConfig{'admin_path'}/newsdat.txt");
	$nd_age = (stat(NEWSDAT))[9];

	# Begin line-by-line processing of newsdat.txt
	LOADLOOP: while (<NEWSDAT>) {
		# Remove ending newline character
		chomp($_);
		# Split news item into component variables, using npconfig.pl definition
		&SplitDataFile($_);
		# Split the news ID # into component variables.
		($newstime, $newsrand, $newscat) = split(/\,/, $newsid);
		# Remove the news category from the news ID, so that the category can change.
		$newsid = join(',', $newstime, $newsrand, '');
		# Check if we want to use TimeOffset
		if ($NPConfig{'TimeOffset'}) {
			$newstime += (3600 * $NPConfig{'TimeOffset'});
		}
		if (@Addons_loadND_2) {
			&RunAddons(@Addons_loadND_2);
		}
		# Go through each defined form field.
		foreach $formfield (@ffields) {
			# Load that particular news variable into the appropriate place in @NewsData
			$NewsData[$newsnum]->{$formfield} = ${$formfield};
		}
		# Establish a hash of news IDs
		$NewsID{$newsid} = $newsnum;
		# Increment $newsnum to continue the processing.
		$newsnum++;
	}
	if (@Addons_loadND_3) {
		&RunAddons(@Addons_loadND_3);
	}
	close(NEWSDAT);
}

# Saves newsdat.txt from @NewsData, which is set by &loadND
sub saveND {
	my ($ndentry, $joinline, $key, $value);
	if (@Addons_saveND_Pre) {
		&RunAddons(@Addons_saveND_Pre);
	}
	NPopen('NEWSDAT', ">$NPConfig{'admin_path'}/newsdat.txt");
	SAVELOOP: foreach $ndentry (@NewsData) {
		unless ($ndentry eq 'del') {
			while (($key, $value) = each %{$ndentry}) {
				${$key} = $value;
			}
			if (@Addons_saveND_Loop) {
				&RunAddons(@Addons_saveND_Loop);
			}
			if ($NPConfig{'TimeOffset'}) {
				$newstime -= (3600 * $NPConfig{'TimeOffset'});
			}
			$newsid = join(',', $newstime, $newsrand, $newscat);
			$joinline = &JoinDataFile;
			$joinline =~ s/\n//g;
			print NEWSDAT $joinline . "\n";
		}
	}
	close(NEWSDAT);
	if (@Addons_saveND_Post) {
		&RunAddons(@Addons_saveND_Post);
	}
}	

# Gets the news variables for a particular item.
sub getNDvar {
	my $nn = shift;
	my $ff;
	foreach $ff (keys %{$NewsData[$nn]}) {
		${$ff} = $NewsData[$nn]->{$ff};
	}
	$newsdate = GetTheDate($newstime);
}	

# Gets the news variables for a particular item.
# Does not generate date information.
sub getNDvar_nodate {
	my $nn = shift;
	my $ff;
	foreach $ff (keys %{$NewsData[$nn]}) {
		${$ff} = $NewsData[$nn]->{$ff};
	}
}	


sub HTMLescape {
	my $text = shift;
	$text =~ s/&/&amp;/g;
	$text =~ s/</&lt;/g;
	$text =~ s/>/&gt;/g;
	$text =~ s/"/&quot;/g;
	return $text;
}

sub PrintSelectValues {
	my @values = @_;
	if ($values[0] eq 'same') {
		shift @values;
		foreach $i (@values) {
			print qq~
			<option value="$i">$i</option>~;
		}
	} else {
		my $count = 1;
		foreach $i (@values) {
			print qq~
			<option value="$count">$i</option>~;
			$count++
		}
	}
}

# Mainly for debugging purposes. Defines a simple NPopen subroutine for cases when a full one isn't being included.
sub MiniNPopen {
	my $npopendef = 'sub NPopen { my ($handle, $file) = @_; my $status = open($handle, $file); return $status; }';
	eval $npopendef;
}

sub PastDaysTime {
	my $pastdays = shift;
	&BasicDateVars(time);
	my $enddate = &YMDtoUNIX($Year, $ActualMonth, $Month_Day);
	$enddate = $enddate + 86399;
	my $startdate = $enddate - ($pastdays * 86400);
	$startdate = $startdate + 1;
	return ($startdate, $enddate);
}

# Used to process some .tmpl (HTML Template files)
sub ProcessTMPL {
	my $tmplpath = shift;
	my $tmplcontent = shift;
	my $tmpltitle = shift;
	unless ($tmplpath) { return 0; }
	unless ($TemplateCache{$tmplpath}) {
		NPopen(TMPLFILE, $tmplpath);
		while (<TMPLFILE>) {
			$TemplateCache{$tmplpath} .= $_;
		}
		close(TMPLFILE);
	}
	my $theresult = $TemplateCache{$tmplpath};
	$theresult =~ s/<!--INSTRUCTIONS[\s\S]+?END INSTRUCTIONS-->//g;
	$theresult =~ s/<TextField\: ([^\s\>\{\[]+)>/${\(HTMLtoText(${$1}))}/g;
	$theresult =~ s/<TextField\: ([^\s\>\{]+)\{[\'\"]([^\s\>\}\'\"]+)[\'\"]\}>/${\(HTMLtoText(${$1}{$2}))}/g;
	$theresult =~ s/<TextField\: ([^\s\>\[]+)\[(\d+)\]>/${\(HTMLtoText(${$1}[$2]))}/g;
	$theresult =~ s/<Field\: ([^\s\>\{\[]+)>/${$1}/gi;
	$theresult =~ s/<Field\: ([^\s\>\{]+)\{[\'\"]([^\s\>\}\'\"]+)[\'\"]\}>/${$1}{$2}/g;
	$theresult =~ s/<Field\: ([^\s\>\[]+)\[(\d+)\]>/${$1}[$2]/g;	
	$theresult =~ s/<InsertContent>/$tmplcontent/gi;
	$theresult =~ s/<InsertTextContent>/${\(HTMLtoText($tmplcontent))}/g;
	$theresult =~ s/<InsertTitle>/$tmpltitle/gi;
	if (@Addons_ProcessTMPL) {
		&RunAddons(@Addons_ProcessTMPL);
	}
	return $theresult;
}

sub HTMLtoText {
	my $html = shift;
	$html =~ s/<br>/\n/gi;
	$html =~ s/<\/*(blockquote|ul|li|p)[^<>]*>/\n\n/gi;
	$html =~ s/<a href=\"*([^\s<>\"]+)\"*[^>]*>([\s\S]+?)<\/a>/$2 (link: $1)/gi;
	$html =~ s/<[^>]+>//g;
	$html =~ s/\"/&quot;/g;
	return $html;
}
	


# The following three subroutines are from the Perl Time::Local module.
sub timegm {
    $ym = pack(C2, @_[5,4]);
    $cheat = $cheat{$ym} || &cheat;
    return -1 if $cheat<0 and $^O ne 'VMS';
    $cheat + $_[0] * $SEC + $_[1] * $MIN + $_[2] * $HR + ($_[3]-1) * $DAY;
}

sub timelocal {
    my $t = &timegm;
    my $tt = $t;

    my (@lt) = localtime($t);
    my (@gt) = gmtime($t);
    if ($t < $DAY and ($lt[5] >= 70 or $gt[5] >= 70 )) {
      # Wrap error, too early a date
      # Try a safer date
      $tt = $DAY;
      @lt = localtime($tt);
      @gt = gmtime($tt);
    }

    my $tzsec = ($gt[1] - $lt[1]) * $MIN + ($gt[2] - $lt[2]) * $HR;

    my($lday,$gday) = ($lt[7],$gt[7]);
    if($lt[5] > $gt[5]) {
	$tzsec -= $DAY;
    }
    elsif($gt[5] > $lt[5]) {
	$tzsec += $DAY;
    }
    else {
	$tzsec += ($gt[7] - $lt[7]) * $DAY;
    }

    $tzsec += $HR if($lt[8]);
    
    $time = $t + $tzsec;
    return -1 if $cheat<0 and $^O ne 'VMS';
    @test = localtime($time + ($tt - $t));
    $time -= $HR if $test[2] != $_[2];
    $time;
}

sub cheat {
    $year = $_[5];
    $year -= 1900
    	if $year > 1900;
    $month = $_[4];
    NPdie("Month '$month' out of range 0..11")	if $month > 11 || $month < 0;
    NPdie ("Day '$_[3]' out of range 1..31")	if $_[3] > 31 || $_[3] < 1;
    NPdie("Hour '$_[2]' out of range 0..23")	if $_[2] > 23 || $_[2] < 0;
    NPdie("Minute '$_[1]' out of range 0..59")	if $_[1] > 59 || $_[1] < 0;
    NPdie("Second '$_[0]' out of range 0..59")	if $_[0] > 59 || $_[0] < 0;
    $guess = $^T;
    @g = gmtime($guess);
    $year += $YearFix if $year < $epoch;
    $lastguess = "";
    $counter = 0;
    while ($diff = $year - $g[5]) {
	NPdie("Can't handle date (".join(", ",@_).")") if ++$counter > 255;
	$guess += $diff * (363 * $DAY);
	@g = gmtime($guess);
	if (($thisguess = "@g") eq $lastguess){
	    return -1; #date beyond this machine's integer limit
	}
	$lastguess = $thisguess;
    }
    while ($diff = $month - $g[4]) {
	NPdie("Can't handle date (".join(", ",@_).")") if ++$counter > 255;
	$guess += $diff * (27 * $DAY);
	@g = gmtime($guess);
	if (($thisguess = "@g") eq $lastguess){
	    return -1; #date beyond this machine's integer limit
	}
	$lastguess = $thisguess;
    }
    @gfake = gmtime($guess-1); #still being skeptic
    if ("@gfake" eq $lastguess){
	return -1; #date beyond this machine's integer limit
    }
    $g[3]--;
    $guess -= $g[0] * $SEC + $g[1] * $MIN + $g[2] * $HR + $g[3] * $DAY;
    $cheat{$ym} = $guess;
}
1;
