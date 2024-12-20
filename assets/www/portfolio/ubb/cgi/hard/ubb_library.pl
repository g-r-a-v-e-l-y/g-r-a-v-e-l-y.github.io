## UBB COMMON ROUTINE LIBRARY

sub GetMemberListArray {

opendir (MEMBERDIR, "$MembersPath"); 
    @members = readdir(MEMBERDIR);
closedir (MEMBERDIR);

	@members = grep(/cgi/, @members);
}  # end Get Member List Array sr

sub ConvertTo24Hour {
if ($TheAMPM eq "PM") {		
		if ($gethr < 12) {
			$gethr = ($gethr  + 12);
		}
}
	if ($TheAMPM eq "AM") {		
		if ($gethr == 12) {
			$gethr = "0";
		}
	}
	$gethr = sprintf ("%2d", $gethr);
	$gethr =~tr/ /0/;
	$getmin = sprintf ("%2d", $getmin);
	$getmin =~tr/ /0/;

} # end convert to 24 hour format sr

sub decodeURL  {

$_ = shift;
tr/+/ /;
s/%(..)/pack('c', hex($1))/eg;
return($_);
}

sub GetForumRecord {
open (FORUMFILE, "$VariablesPath/forums.cgi");
	@forums = <FORUMFILE>;
close (FORUMFILE);

$forumnumber = shift;
$forumnumber = $forumnumber - 1;
@requestedforum = split(/\|/, $forums[$forumnumber]);
return (@requestedforum);
}


sub GetForumSelectList {
open (FORUMFILE, "$VariablesPath/forums.cgi");
	@forums = <FORUMFILE>;
close (FORUMFILE);

for $each2(@forums) {
	@ForumLine = split(/\|/, $each2);
	chomp($ForumLine[8]);
		if (($ForumLine[3] eq "On") && ($number == $ForumLine[8])) {
print<<SelectHTML;
<OPTION value="$ForumLine[8]" SELECTED>$ForumLine[1]
SelectHTML
		}
	if (($ForumLine[3] eq "On") && ($number != $ForumLine[8])) {
print<<SelectHTML;
<OPTION value="$ForumLine[8]">$ForumLine[1]
SelectHTML
		} #end if/else
}  #end for loop

}  ## End GetForumSelectList


sub GetCategoryList {
open (FORUMFILE, "$VariablesPath/forums.cgi");
@forumlist = <FORUMFILE>;
close (FORUMFILE);

for $line(@forumlist) {
@forumline = split(/\|/, $line);
$dupe = "no";
	for $checkdupe(@categories) {
		if ($forumline[0] eq "$checkdupe") {
			$dupe = "yes";
		}
	}
if ($dupe eq "no") {
	push(@categories, $forumline[0]);
}
}

# @categories contains all categories
}  # End GetCategoryList




sub GotError {
$ErrorLine = shift;
print<<THAT;
<HTML><BODY>
<BR>
<blockquote>
$ErrorLine
</blockquote>
</BODY></HTML>
THAT
}

sub HTMLIFY {
$_ = shift;
$_ =~ s/&quot;/\|QUT\|/g;
$_ =~ s/&/\|AMP\|/g;
$_ =~ s/"/\|QUT\|/g;
$_ =~ s/\?/\|QUS\|/g;
$_ =~ s/=/\|EQUL\|/g;
$_ =~ s/'/\|APO\|/g;
$_ =~ s/\+/\|PLS\|/g;
$_ =~ s/\#/\|NMB\|/g;
return($_);
}
sub OpenProfile {
$FormattedProfile = shift;
$FormattedProfile =~ s/ /_/g; #convert spaces  
		open (CHECKPROFILE, "$MembersPath/$FormattedProfile");
			@foundprofile = <CHECKPROFILE>;
		close (CHECKPROFILE);
		
	@profileinfo = split (/\|/, $foundprofile[0]);
	
	return (@profileinfo);
} # end Open Profile

sub UNHTMLIFY {
$_ = shift;
$_ =~ s/\|AMP\|/\&/g;
$_ =~ s/\|QUT\|/&quot;/g;
$_ =~ s/\|QUS\|/\?/g;
$_ =~ s/\|EQUL\|/=/g;
$_ =~ s/\|APO\|/'/g;
$_ =~ s/\|PLS\|/\+/g;
$_ =~ s/\|NMB\|/\#/g;
return($_);
}

sub Lock {
local ($lockname) = @_;
local ($endtime);
$endtime = 15;
$endtime = time + $endtime;
while (-e $lockname && time < $endtime) {
open (LOCKFILE, ">$lockname");
} #end lock sr

sub Unlock {
local ($lockname) = @_;
close (LOCKFILE);
unlink ($lockname);
} 
} # end Unlock sr

sub PageBottomHTML {

if ($ShowPrivacyLink eq 'ON') {
$PrivacyLink = "| <A HREF=\"$PrivacyURL\">Privacy Policy</A>";	
}

print<<BOTTOM;
<B><FONT SIZE="2" FACE="Verdana, Arial">
<A HREF="mailto:$BBEmail">Email Grant</A> | <A HREF="$HomePageURL">$MyHomePage</A> $PrivacyLink
</B></FONT>
<p><FONT SIZE="2" FACE="Verdana, Arial" color="#000000">

<P></font>
<FONT COLOR="#000000" size="1" FACE="Verdana, Arial">
<P>
Powered by Infopop: 
<A HREF="http://www.ultimatebb.com">Ultimate Bulletin Board</A>, Freeware Version 2000c<BR>Purchase our Licensed Version- which adds many more features! <BR>&copy; Infopop Corporation</A>, 1998 - 2000.
<br><br>
</FONT>
</CENTER>
</body></html>
BOTTOM
}  # end PageBottomHTML sr

sub DateCompare {
#used for the announcements
my $StartDate = shift;
my $EndDate = shift;

#convert dates to Julian dates
my $StartMonth = substr($StartDate, 0, 2);
my $StartDay = substr($StartDate, 2, 2);
my $StartYear = substr($StartDate, 4, 4);
my $EndMonth = substr($EndDate, 0, 2);
my $EndDay = substr($EndDate, 2, 2);
my $EndYear = substr($EndDate, 4, 4);

$StartJulian = &jday($StartMonth, $StartDay, $StartYear);
$EndJulian = &jday($EndMonth, $EndDay, $EndYear);

#$EndJulian = ($EndJulian + .99);
#get current date
&GetDateTime;
#current Julian time is $LastLoginJulian
if (($StartJulian <= $LastLoginJulian) && ($EndJulian >= $LastLoginJulian)) {
	$Live = "true";
}
if ($EndJulian < $LastLoginJulian)  {
$Dead = "true";
}
} #end DateCompare sr


sub GetDateTime  {
if ($TimeZoneOffset) {
if (($TimeZoneOffset ne "") || ($TimeZoneOffset ne "0")) {
$adjustTime = time() + ($TimeZoneOffset * 3600);
}  else {
$adjustTime = time();
}
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime ($adjustTime);

} else {

($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime (time);

}

$mon++;


$JSMonth = $mon;

$JSYear = $year + 1900;


$LastLoginJulian = &jday($JSMonth, $mday, $JSYear);
$hour = sprintf ("%2d", $hour);
$hour =~tr/ /0/;
$min = sprintf ("%2d", $min);
$min =~tr/ /0/;
$JSTime = ("$hour" . "$min");
$LastLoginJulian = ($LastLoginJulian + ($JSTime * 0.0001));

&NormalTime;

$min = sprintf ("%2d", $min);
$min =~tr/ /0/;
$mon = sprintf ("%2d", $mon);
$mon =~tr/ /0/;
$mday = sprintf ("%2d", $mday);
$mday =~tr/ /0/;


$HyphenDate = ("$mon" . "-" . "$mday" . "-" . "$JSYear");
$EuroDate = ("$mday" . "-" . "$mon" . "-" . "$JSYear");
$RunonDate = ("$mon$mday$year");
$Time = ("$hour" . ":" . "$min" . " " . "$AMPM");


$LastLoginDT = ("$HyphenDate $Time");

}  #end GetDateTime sr
		
sub NormalTime {		
if ($hour < 12) {
$AMPM = "AM";
}

if ($hour > 12) {
	$hour = $hour - 12;
	$AMPM = "PM";
	}  	
if ($hour == 12) {
	$AMPM = "PM";
	}  	
	
if ($hour == 0) {
	$hour = "12";
	}
	
$hour = sprintf ("%2d", $hour);
$hour =~tr/ /0/;
}

		
sub MilitaryTime {
	if ($AMpm eq "PM") {		
		if ($hour < 12) {
			$hour = ($hour  + 12);
		}
	}
	if ($AMpm eq "AM") {		
		if ($hour == 12) {
			$hour = "0";
		}
	}
	$hour = sprintf ("%2d", $hour);
	$hour =~tr/ /0/;
	$min = sprintf ("%2d", $min);
	$min =~tr/ /0/;
}

		
sub MilitaryTime2 {
	if ($AMpm eq "PM") {		
		if ($GetHour < 12) {
			$MilHour = ($GetHour  + 12);
		}  else {
			$MilHour = $GetHour;
		}	
	}
	if ($AMpm eq "AM") {		
		if ($GetHour == 12) {
			$MilHour = "0";
		}  else {
			$MilHour = $GetHour;
		}	
	}
	$MilHour = sprintf ("%2d", $MilHour);
	$MilHour =~tr/ /0/;
	$GetMinute = sprintf ("%2d", $GetMinute);
	$GetMinute =~tr/ /0/;
}

sub PullTimes {
$FoundIt = "";
($ThreadNum, $ReplyNum, $DaterMatch, $Replies) = split(/-/, $_);
		($RepliesString, $Extension) = split(/\./, $Replies);
$Replies = substr($RepliesString, 0, 6);
	if ($Replies eq "000000") {
		$OpenThis = "$_";
		$FoundIt = "true";
		}  else {
		$OpenThis = ("$ThreadNum-$Replies-$DaterMatch-000000");
		$FoundIt = "false";
	}
	
	if ($FoundIt ne "true") {
@foundit = grep(/^$OpenThis/, @forummsgs);
$OpenThis = $foundit[0];
chomp($OpenThis);
	}
	
	open (TIMEX, "$ForumsPath/Forum$x/$OpenThis");
		@messageopen = <TIMEX>;
	close (TIMEX);

		chomp($messageopen[2]);
		($TheTime, $AMpm) = split(/ /, $messageopen[2]);
		($hour, $min) = split(/:/, $TheTime);
		&MilitaryTime; #converts hours to military format
		$MilitaryTime = ("$hour" . ":" . "$min");

}  # end Pull Times sr

sub ConvertToJulian {
	($TheMonth, $TheDay, $TheYear) = split(/-/, $theDate);		($TheTime, $AMpm) = split(/ /, $theTime);
		($hour, $min) = split(/:/, $TheTime);
		&MilitaryTime; #converts hours to military format
		
		
$CheckThisYear = length($TheYear);

if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$TheYear = ("19" . "$TheYear");
		}  else {
		$TheYear = $TheYear - 100;
		$TheYear = sprintf ("%2d", $TheYear);
		$TheYear =~tr/ /0/;
		$TheYear = ("20" . "$TheYear");
		}
}
	
$ThisPostJulian = &jday($TheMonth, $TheDay, $TheYear);
$CJTime = ("$hour" . "$min");
$ThisPostJulian = ($ThisPostJulian + ($CJTime * 0.0001));
return ($ThisPostJulian);
}


sub CleanThis {
my $CleanThis = shift;
	$CleanThis =~ s/\n\r\n//sg;
	$CleanThis =~ s/\n//sg;
	$CleanThis =~ s/\r//sg;
	$CleanThis =~ s/\t//sg;
	$CleanThis =~ s/\\v//sg;
	$CleanThis =~ s/\f//sg;
		$CleanThis =~ s/\b//sg;
return ($CleanThis);
} #end CleanThis

sub PipeCleaner {
$Pipe = shift;
$Pipe =~ s/\|/\+/sg;
return($Pipe);
} #end pipe cleaner sr


sub UBBCode {

my $ThePost = shift;

$ThePost =~ s/(\[URL\])(http:\/\/\S+?)(\[\/URL\])/ <A HREF="$2" TARGET=_blank>$2<\/A> /isg;

$ThePost =~ s/(\[URL\])(\S+?)(\[\/URL\])/ <A HREF="http:\/\/$2" TARGET=_blank>$2<\/A> /isg;

$ThePost =~ s/(\[EMAIL\])(\S+\@\S+?)(\[\/EMAIL\])/ <A HREF="mailto:$2">$2<\/A> /isg;

if (($UBBImages eq "ON") && ($OverrideImages ne "yes")) {
$ThePost =~ s/(\[IMG\])(\S+?)(\[\/IMG\])/ <IMG SRC="$2"> /isg;
}


$ThePost =~ s/(\[QUOTE\])(.+?)(\[\/QUOTE\])/ <BLOCKQUOTE><font size="1" face="Verdana, Arial">quote:<\/font><HR>$2<HR><\/BLOCKQUOTE>/isg;

$ThePost =~ s/(\[i\])(.+?)(\[\/i\])/<i>$2<\/i>/isg;

$ThePost =~ s/(\[b\])(.+?)(\[\/b\])/<b>$2<\/b>/isg;

return ($ThePost);

}

sub EditUBBConvert {
my $EditThis = shift;
$EditThis =~ s/(<A HREF="http:\/\/)(\S+)(" TARGET=_blank>)(\S+)(<\/A>)/\[URL\]$2\[\/URL\]/isg;
$EditThis =~ s/(<A HREF="mailto:)(\S+)(">)(\S+)(<\/A>)/\[EMAIL\]$2\[\/EMAIL\]/isg;
$EditThis =~ s/(<BLOCKQUOTE><font size="1" face=".+?">quote:<\/font><HR>)(.+?)(<HR><\/BLOCKQUOTE>)/\[QUOTE\]$2\[\/QUOTE\]/isg;
$EditThis =~ s/(<i>)(.+?)(<\/i>)/\[i\]$2\[\/i\]/isg;

$EditThis =~ s/(<b>)(.+?)(<\/b>)/\[b\]$2\[\/b\]/isg;

if ($UBBImages ne "OFF") {
$EditThis =~ s/(<IMG SRC=")(\S+)(">)/\[IMG\]$2\[\/IMG\]/isg;
}
return ($EditThis);
}  #end EditUBBConvert

sub ConvertReturns {
my $ConvertReturns = shift;
$ConvertReturns =~ s/\n\r\n/<p>/sg;
$ConvertReturns =~ s/\n\n/<p>/sg;
$ConvertReturns =~ s/\n/<br>/sg;
$ConvertReturns =~ s/\r//sg;
return ($ConvertReturns);
}

sub EliminateReturns {
my $ConvertReturns = shift;
$ConvertReturns =~ s/\n\r\n//g;
$ConvertReturns =~ s/\n//g;
$ConvertReturns =~ s/\r//g;
return ($ConvertReturns);
}


sub DoEmail {
$EmailTo = shift;
@theprofile = &OpenProfile("$EmailTo.cgi");  
$EmailAddress = "$theprofile[2]";
$EmailView = "$theprofile[11]";

if (($EmailBlock ne "ON") && ($EmailView ne "no")) {

chomp($EmailAddress);

print<<EMail;
<HTML><HEAD><TITLE>Send Email to $EmailTo</TITLE></HEAD>
 <BODY bgcolor="#FFFFFF"   text="#000000" link="#000080" vlink="#800080">
<FONT SIZE="2" FACE="Verdana, Arial">
<center>
<B>The email address for $EmailTo is: <A HREF="mailto:$EmailAddress">$EmailAddress</A>.
<P>
Click on the email address above to send an email now.</B>
</CENTER>
</font>
</BODY></HTML>
EMail
}  else {
print<<EMail;
<HTML><HEAD><TITLE>Can't send email to $in{'ToWhom'}  </TITLE></HEAD>
 <BODY bgcolor="#FFFFFF"   text="#000000" link="#000080" vlink="#800080">
<FONT SIZE="2" FACE="Verdana, Arial">
<BR><BR><blockquote>
<B>Sorry, but either the administrator of $BBName is not permitting email addresses to be accessed at this time or that user does not wish for the email address to be shown.</B>
</blockquote>
</font>
</BODY></HTML>
EMail
}
} #end DoEmail sr


sub StandardHTML {
my $TextToPrint = shift;

print<<TheHTML;
<HTML>
<HEAD>
<TITLE>$BBName</TITLE>
</HEAD>
<BODY bgcolor="#FFFFFF" text="#000000" link="#000080" vlink="#800080">
<A HREF="Ultimate.cgi?action=intro"><IMG SRC="$NonCGIURL/bbtitle5.jpg" BORDER=0></a>
<P><BR><blockquote>
<B><FONT FACE="Verdana, Arial" size=2>$TextToPrint
</FONT></B></blockquote>
</BODY></HTML>
TheHTML
}

sub StandardTopHTML {
print<<TheTop;
<HTML>
<HEAD>
<TITLE>$BBName</TITLE>
</HEAD>
<BODY bgcolor="#FFFFFF"  text="#000000" link="#000080" vlink="#800080">
TheTop
}

sub Forward {
my $ForwardURL = shift;
my $ForwardText = shift;

print<<ForwardHTML;
<HTML><HEAD>
<meta http-equiv="Refresh" content="2; URL=$ForwardURL">
</HEAD>
 <BODY bgcolor="#FFFFFF"   text="#000000" link="#000080" vlink="#800080">
<br><br>
<ul>
<FONT SIZE="2" FACE="Verdana, Arial" COLOR="#000080">
<B>$ForwardText  Please wait two seconds.
<P></font><FONT SIZE="1" FACE="Verdana, Arial" COLOR="#000080">
<A HREF="$ForwardURL">Click here if you do not want to wait any longer (or if your browser does not automatically forward you).</A>
</B><br><br>
</FONT>
</ul>
</body></html>
ForwardHTML
} #end Forward sr


# READ PARSE DIE IS TAKEN FROM cgi-lib.pl by Steven E. Brenner
# S.E.Brenner@bioc.cam.ac.uk
# $Id: ubb_library.pl,v 1.1 2000/06/13 22:02:46 outerbod Exp outerbod $
#
# Copyright (c) 1996 Steven E. Brenner

sub ReadParse {

$cgi_lib'version = sprintf("%d.%02d", q$Revision: 1.1 $ =~ /(\d+)\.(\d+)/);


# Parameters affecting cgi-lib behavior
# User-configurable parameters affecting file upload.
$cgi_lib'maxdata    = 131072;    # maximum bytes to accept via POST - 2^17
$cgi_lib'writefiles =      0;    # directory to which to write files, or
                                 # 0 if files should not be written
$cgi_lib'filepre    = "cgi-lib"; # Prefix of file names, in directory above

# Do not change the following parameters unless you have special reasons
$cgi_lib'bufsize  =  8192;    # default buffer size when reading multipart
$cgi_lib'maxbound =   100;    # maximum boundary length to be encounterd
$cgi_lib'headerout =    0;    # indicates whether the header has been printed
  local (*in) = shift if @_;    # CGI input
  local (*incfn,                # Client's filename (may not be provided)
	 *inct,                 # Client's content-type (may not be provided)
	 *insfn) = @_;          # Server's filename (for spooled files)
  local ($len, $type, $meth, $errflag, $cmdflag, $perlwarn, $got);
	
  $perlwarn = $^W;
  $^W = 0;

  binmode(STDIN);   # we need these for DOS-based systems
  binmode(STDOUT);  # and they shouldn't hurt anything else 
  binmode(STDERR);
	
  # Get several useful env variables
  $type = $ENV{'CONTENT_TYPE'};
  $len  = $ENV{'CONTENT_LENGTH'};
  $meth = $ENV{'REQUEST_METHOD'};
  
  if ($len > $cgi_lib'maxdata) { #'
      &CgiDie("cgi-lib.pl: Request to receive too much data: $len bytes\n");
  }
  
  if (!defined $meth || $meth eq '' || $meth eq 'GET' || 
      $type eq 'application/x-www-form-urlencoded') {
    local ($key, $val, $i);
	
    # Read in text
    if (!defined $meth || $meth eq '') {
      $in = $ENV{'QUERY_STRING'};
      $cmdflag = 1;  # also use command-line options
    } elsif($meth eq 'GET' || $meth eq 'HEAD') {
      $in = $ENV{'QUERY_STRING'};
    } elsif ($meth eq 'POST') {
        if (($got = read(STDIN, $in, $len) != $len))
	  {$errflag="Short Read: wanted $len, got $got\n"};
    } else {
      &CgiDie("cgi-lib.pl: Unknown request method: $meth\n");
    }

    @in = split(/[&;]/,$in); 
    push(@in, @ARGV) if $cmdflag; # add command-line parameters

    foreach $i (0 .. $#in) {
      # Convert plus to space
      $in[$i] =~ s/\+/ /g;

      # Split into key and value.  
      ($key, $val) = split(/=/,$in[$i],2); # splits on the first =.

      # Convert %XX from hex numbers to alphanumeric
      $key =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;
      $val =~ s/%([A-Fa-f0-9]{2})/pack("c",hex($1))/ge;

      # Associate key and value
      $in{$key} .= "\0" if (defined($in{$key})); # \0 is the multiple separator
      $in{$key} .= $val;
    }

  } elsif ($ENV{'CONTENT_TYPE'} =~ m#^multipart/form-data#) {
    # for efficiency, compile multipart code only if needed
$errflag = !(eval <<'END_MULTIPART');

    local ($buf, $boundary, $head, @heads, $cd, $ct, $fname, $ctype, $blen);
    local ($bpos, $lpos, $left, $amt, $fn, $ser);
    local ($bufsize, $maxbound, $writefiles) = 
      ($cgi_lib'bufsize, $cgi_lib'maxbound, $cgi_lib'writefiles);


    # The following lines exist solely to eliminate spurious warning messages
    $buf = ''; 

    ($boundary) = $type =~ /boundary="([^"]+)"/; #";   # find boundary
    ($boundary) = $type =~ /boundary=(\S+)/ unless $boundary;
    &CgiDie ("Boundary not provided: probably a bug in your server") 
      unless $boundary;
    $boundary =  "--" . $boundary;
    $blen = length ($boundary);

    if ($ENV{'REQUEST_METHOD'} ne 'POST') {
      &CgiDie("Invalid request method for  multipart/form-data: $meth\n");
    }

    if ($writefiles) {
      local($me);
      stat ($writefiles);
      $writefiles = "/tmp" unless  -d _ && -r _ && -w _;
      # ($me) = $0 =~ m#([^/]*)$#;
      $writefiles .= "/$cgi_lib'filepre"; 
    }

    $left = $len;
   PART: # find each part of the multi-part while reading data
    while (1) {
      die $@ if $errflag;

      $amt = ($left > $bufsize+$maxbound-length($buf) 
	      ?  $bufsize+$maxbound-length($buf): $left);
      $errflag = (($got = read(STDIN, $buf, $amt, length($buf))) != $amt);
      die "Short Read: wanted $amt, got $got\n" if $errflag;
      $left -= $amt;

      $in{$name} .= "\0" if defined $in{$name}; 
      $in{$name} .= $fn if $fn;

      $name=~/([-\w]+)/;  # This allows $insfn{$name} to be untainted
      if (defined $1) {
        $insfn{$1} .= "\0" if defined $insfn{$1}; 
        $insfn{$1} .= $fn if $fn;
      }
 
     BODY: 
      while (($bpos = index($buf, $boundary)) == -1) {
        die $@ if $errflag;
        if ($name) {  # if no $name, then it's the prologue -- discard
          if ($fn) { print FILE substr($buf, 0, $bufsize); }
          else     { $in{$name} .= substr($buf, 0, $bufsize); }
        }
        $buf = substr($buf, $bufsize);
        $amt = ($left > $bufsize ? $bufsize : $left); #$maxbound==length($buf);
        $errflag = (($got = read(STDIN, $buf, $amt, $maxbound)) != $amt);  
	die "Short Read: wanted $amt, got $got\n" if $errflag;
        $left -= $amt;
      }
      if (defined $name) {  # if no $name, then it's the prologue -- discard
        if ($fn) { print FILE substr($buf, 0, $bpos-2); }
        else     { $in {$name} .= substr($buf, 0, $bpos-2); } # kill last \r\n
      }
      close (FILE);
      last PART if substr($buf, $bpos + $blen, 4) eq "--\r\n";
      substr($buf, 0, $bpos+$blen+2) = '';
      $amt = ($left > $bufsize+$maxbound-length($buf) 
	      ? $bufsize+$maxbound-length($buf) : $left);
      $errflag = (($got = read(STDIN, $buf, $amt, length($buf))) != $amt);
      die "Short Read: wanted $amt, got $got\n" if $errflag;
      $left -= $amt;


      undef $head;  undef $fn;
     HEAD:
      while (($lpos = index($buf, "\r\n\r\n")) == -1) { 
        die $@ if $errflag;
        $head .= substr($buf, 0, $bufsize);
        $buf = substr($buf, $bufsize);
        $amt = ($left > $bufsize ? $bufsize : $left); #$maxbound==length($buf);
        $errflag = (($got = read(STDIN, $buf, $amt, $maxbound)) != $amt);  
        die "Short Read: wanted $amt, got $got\n" if $errflag;
        $left -= $amt;
      }
      $head .= substr($buf, 0, $lpos+2);
      push (@in, $head);
      @heads = split("\r\n", $head);
      ($cd) = grep (/^\s*Content-Disposition:/i, @heads);
      ($ct) = grep (/^\s*Content-Type:/i, @heads);

      ($name) = $cd =~ /\bname="([^"]+)"/i; #"; 
      ($name) = $cd =~ /\bname=([^\s:;]+)/i unless defined $name;  

      ($fname) = $cd =~ /\bfilename="([^"]*)"/i; #"; # filename can be null-str
      ($fname) = $cd =~ /\bfilename=([^\s:;]+)/i unless defined $fname;
      $incfn{$name} .= (defined $in{$name} ? "\0" : "") . $fname;

      ($ctype) = $ct =~ /^\s*Content-type:\s*"([^"]+)"/i;  #";
      ($ctype) = $ct =~ /^\s*Content-Type:\s*([^\s:;]+)/i unless defined $ctype;
      $inct{$name} .= (defined $in{$name} ? "\0" : "") . $ctype;

      if ($writefiles && defined $fname) {
        $ser++;
	$fn = $writefiles . ".$$.$ser";
	open (FILE, ">$fn") || &CgiDie("Couldn't open $fn\n");
        binmode (FILE);  # write files accurately
      }
      substr($buf, 0, $lpos+4) = '';
      undef $fname;
      undef $ctype;
    }

1;
END_MULTIPART
    if ($errflag) {
      local ($errmsg, $value);
      $errmsg = $@ || $errflag;
      foreach $value (values %insfn) {
        unlink(split("\0",$value));
      }
      &CgiDie($errmsg);
    } else {
      # everything's ok.
    }
  } else {
    &CgiDie("cgi-lib.pl: Unknown Content-type: $ENV{'CONTENT_TYPE'}\n");
  }

  # no-ops to avoid warnings
  $insfn = $insfn;
  $incfn = $incfn;
  $inct  = $inct;

  $^W = $perlwarn;

  return ($errflag ? undef :  scalar(@in)); 
}

#  CGI DIE IS TAKEN FROM cgi-lib.pl by Steven E. Brenner
# S.E.Brenner@bioc.cam.ac.uk
# $Id: ubb_library.pl,v 1.1 2000/06/13 22:02:46 outerbod Exp outerbod $
#
# Copyright (c) 1996 Steven E. Brenner

sub CgiDie {
  local (@msg) = @_;
  &CgiError (@msg);
  die @msg;
}

sub ForumSummary {
$number = shift;

opendir (FORUMDIR, "$ForumsPath/Forum$number"); 
    @forummsgs = readdir(FORUMDIR);
closedir (FORUMDIR);

@threadfiles = grep(/\.threads/, @forummsgs);
@forummsgs = grep(/\.ubb/, @forummsgs);

## do date pruning 
#convert Closing and Current Dates to Julian Dates
$CurrentJulian = &jday($mon, $mday, $year);
$CloseJulian = $CurrentJulian - 365;

@finalarray = @blank;

#configure memo date to Julian
foreach $item(@forummsgs) {


@threadinfo = &OpenThread("$item");
@threadrev = reverse(@threadinfo);

$statline = $threadinfo[0];
$mostrecent = $threadrev[0];
@statarray = split(/\|\|/, $statline);
@lastreply = split(/\|\|/, $mostrecent);

my $Notes = $statarray[1];

	#check to see if thread is closed--
	if ($Notes =~ /X/) {
		$closed = "X";
		} else {
		$closed = "no";
		}
		
($MonthOfMessage, $DayOfMessage, $YearOfMessage) = split(/-/, $lastreply[3]);	

($ThreadNum, $junk) = split(/\./, $item);
$ThreadNumber = "$ThreadNum.html";

$TotalReplies = $statarray[2];
		
$CheckThisYear = length($YearOfMessage);



	if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$YearOfMessage = ("19" . "$YearOfMessage");
		}  else {
		$YearOfMessage = $YearOfMessage - 100;
		$YearOfMessage = sprintf ("%2d", $YearOfMessage);
		$YearOfMessage =~tr/ /0/;
		$YearOfMessage = ("20" . "$YearOfMessage");
		}
}

	$CheckJulian = &jday($MonthOfMessage, $DayOfMessage, $YearOfMessage);
		
	if ($CheckJulian >= $CloseJulian) {
		$JulianDiff = ($CurrentJulian - $CheckJulian);

$JulianDiff = sprintf ("%3d", $JulianDiff);
$JulianDiff =~ tr/ /0/;

$author = "$statarray[3]";
$subject = "$statarray[4]";
chomp($subject);
$threadtime = "$lastreply[4]";

($GetHour, $GetMinute) = split(/:/, $threadtime);
($GetMinute, $AMpm) = split(/ /, $GetMinute);
chomp($AMpm);

	&MilitaryTime2;
	$MilTime = "$MilHour$GetMinute";

$DateTime = "$YearOfMessage$MonthOfMessage$DayOfMessage$MilTime";
$CompareTime = (2400 - $MilTime);
$CompareTime = sprintf ("%4d", $CompareTime);
$CompareTime =~ tr/ /0/;
$DateTimeCompare = "$YearOfMessage$MonthOfMessage$DayOfMessage$CompareTime";

$itemline = "$JulianDiff|^|$DateTimeCompare|^|$DateTime|^|$ThreadNumber|^|$subject|^|$TotalReplies|^|$author|^|$closed";
		push (@finalarray, $itemline);
	}  
} #end FOREACH $item
@finalarray = sort(@finalarray);
############################################
# print finalarray to file

&Lock("lock.file");
open (THREADS, ">$ForumsPath/Forum$number/$RunOnDate.threads") or die(&StandardHTML("Unable to write thread summary file $!"));
foreach $one(@finalarray) {
chomp($one);
print THREADS ("$one\n");
}
close (THREADS);
&Unlock("lock.file");

chmod (0666, "$ForumsPath/Forum$number/$RunOnDate.threads");

}  # end ForumSummary sr

sub CurrentDate {
($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime (time);

$year = ($year + 1900);

$mon++;

$mon = sprintf ("%2d", $mon);
$mon =~tr/ /0/;
$mday = sprintf ("%2d", $mday);
$mday =~tr/ /0/;
$RunOnDate = "$mon$mday$year";
}

sub OpenThread {
my $ThreadFile = shift;

if ($ThreadFile =~ /\d\d\d\d\d\d\.ubb/) {
open (MESSAGE, "$ForumsPath/Forum$number/$ThreadFile");
my @mess = <MESSAGE>;
close (MESSAGE);
my @threadguts = sort(@mess);
return(@threadguts);
} else {
&PostHackDetails;
&StandardHTML("We have noted your attempt to hack this forum.  Authorities will be notified if you persist.");
exit;
}
}

sub PostHackDetails {
&GetDateTime;
open(HACKLOG, ">>$NonCGIPath/hacklog.cgi");
print HACKLOG "HACK ATTEMPT DATE: $LastLoginDT\nHackDetails\n\n:";
foreach (sort keys %ENV) {
	print HACKLOG "$ENV{$_}\n"
}
close(HACKLOG);
}

sub UpdateForumSummary {
$number = shift;
$ThreadFile = shift;

##### create new day summary file, if necessary
unless (-e "$ForumsPath/Forum$number/$RunOnDate.threads") {
my $CreateThreadFile = "yes";
&ForumSummary($number);
}  # end UNLESS THREADS SUMMARY EXISTS
##########

if ($CreateThreadFile ne "yes") {
($threadnum, $junk) = split(/\./, $ThreadFile);

#open thread summary file
open (SUMM, "$ForumsPath/Forum$number/$RunOnDate.threads");
@threadsum = <SUMM>;
close (SUMM);

foreach $checkthis(@threadsum) {
chomp($checkthis);
@checkit = split(/\|\^\|/, $checkthis);
	if ($checkit[3] eq "$threadnum.html") {
	
		@threadinfo = &OpenThread("$ThreadFile");
		@revthread = reverse(@threadinfo);
		@lastpost = split(/\|\|/, $revthread[0]);
		
		@stats = split(/\|\|/, $threadinfo[0]);
		chomp($stats[4]);
		if ($stats[1] =~ /X/) {
			$Closed = "X";
		} else {
			$Closed = "no";
		}
		
		#get dates of last post
		($MonthOfMessage, $DayOfMessage, $YearOfMessage) = split(/-/, $lastpost[3]);	
		
				
$CheckThisYear = length($YearOfMessage);

if ($CheckThisYear < 4)  {
	if ($CheckThisYear  == 2) {
		$YearOfMessage = ("19" . "$YearOfMessage");
		}  else {
		$YearOfMessage = $YearOfMessage - 100;
		$YearOfMessage = sprintf ("%2d", $YearOfMessage);
		$YearOfMessage =~tr/ /0/;
		$YearOfMessage = ("20" . "$YearOfMessage");
		}
}
	
$threadtime = "$lastpost[4]";

($GetHour, $GetMinute) = split(/:/, $threadtime);
($GetMinute, $AMpm) = split(/ /, $GetMinute);
chomp($AMpm);

	&MilitaryTime2;
	$MilTime = "$MilHour$GetMinute";

$DateTime = "$YearOfMessage$MonthOfMessage$DayOfMessage$MilTime";
$CompareTime = (2400 - $MilTime);
$CompareTime = sprintf ("%4d", $CompareTime);
$CompareTime =~ tr/ /0/;
$DateTimeCompare = "$YearOfMessage$MonthOfMessage$DayOfMessage$CompareTime";

	$newline = ("000|^|$DateTimeCompare|^|$DateTime|^|$threadnum.html|^|$stats[4]|^|$stats[2]|^|$stats[3]|^|$Closed");	
	push(@updatedts, $newline);
	}  else {
	push(@updatedts, $checkthis);
	}
}  # end foreach @threadsum

## @updated contains revised thread summary file

@updatedts = sort(@updatedts);

# print finalarray to file
&Lock("lock.file");
open (THREADS, ">$ForumsPath/Forum$number/$RunOnDate.threads") or die(&StandardHTML("Unable to write thread summary file in Forum$number $!"));
foreach $one(@updatedts) {
chomp($one);
print THREADS ("$one\n");
}
close (THREADS);
&Unlock("lock.file");

chmod (0666, "$ForumsPath/Forum$number/$RunOnDate.threads");
} #end if day's thread summary does not have to totally created
}  # end ForumSummary sr


1;
