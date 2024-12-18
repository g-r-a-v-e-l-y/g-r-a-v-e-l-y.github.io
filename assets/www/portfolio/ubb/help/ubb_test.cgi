#!/usr/bin/perl

#
### CHECK UBB SCRIPT - WRITE/DELETE FUNCTIONS ##
#
# Ultimate Bulletin Board is copyright Infopop Corporation (formerly Madrona Park, Inc.), 1997, 1998, 1999, 2000.
#
#       ------------ testperms.cgi -------------
#
#  This script tests file user permissions
#
#  T H I S  I S  A N   U N S U P P O R T E D  S C R I P T 
#
# Infopop Corporation (formerly Madrona Park, Inc.) offers no
#  warranties on this script.  The owner/licensee of the script is
#  solely responsible for any problems caused by installation of
#  the script or use of the script, including messages that may be
#  posted on the BB.
#
#  All copyright notices regarding the Ultimate Bulletin Board
#  must remain intact on the scripts and in the HTML
#  for the scripts.
#
# For more info on the Ultimate BB, 
# see http://www.UltimateBB.com
#
###############################################################
#
# I N S T R U C T I O N S
# 1) transfer this script to your UBB CGI directory
# 2) call it with your web browser i.e. http://www,mydomain.com/mycgi/ubb_test.cgi
# 3) use the options to check standard function used by UBB
# 4) you may test other directories by manually editing in a path
#  
#
###############################################################


# Do NOT modify anything below this line

$ubb_help_url = 'http://www.ultimatebb.com/cgi-bin/ubbhelp00.cgi';

@filestocheck = ('UltBB.setup','Styles.file','mods.file','ubb_library.pl','ubb_library2.pl','Date.pl','mail-lib.pl');	
@filestocheck_UBBFree = ('UltBB.setup','Styles.file','mods.file','ubb_library.pl','ubb_library2.pl','Date.pl');	
@variablesfiles = ('UltBB.setup','Styles.file','mods.file','forums.cgi');

$this_script_name = "ubb_test.cgi";
$testversion= '1.7a';
###############################################################

print ("Content-type: text/html\n\n");

use File::Basename;

  ($0 =~ m,(.*)/[^/]+,)   && unshift (@INC, "$1"); # Get the script location: UNIX / or Windows /
  ($0 =~ m,(.*)\\[^\\]+,) && unshift (@INC, "$1"); # Get the script location: Windows \
 
if ($ENV{'REQUEST_METHOD'} !~ /POST/i) {

	if ($ENV{'QUERY_STRING'} ne '') {

		($in{'action'},$DirToCheck,$commandtype) = &decode_query($ENV{'QUERY_STRING'}); # check for q and p commands

		$DirToCheck =~ s/\\/\//g; # leaning toothpicks

		if ( ($in{'action'} eq 'set_manual_paths') || ($commandtype eq 'o') ) {

			$manual_DirToCheck = $DirToCheck; # save value

			&getinfo; # get all standard ENV info but this will overwrite $DirtoCheck

			$DirToCheck = $manual_DirToCheck;
			$DirToCheck =~ s/\\/\//g; # leaning toothpicks
			$DirToCheck =~ s/\s+$//sg; # rem leading and trailing spaces
			$DirToCheck =~ s/^\s+//sg;

			if ($DirToCheck =~ /(.*)/){ # untaint
				$DirToCheck = $1;	
			}

			&CheckBadChars($DirToCheck); # no funny characters or commands
			&print_headers;
  			&print_test_form;
 			exit(0);	

		} # end if
	}
	else {
		&getinfo; # decode $ENV variables	
		$DirToCheck =~ s/\\/\//g; # leaning toothpicks
		&print_headers;
  		&print_test_form;
 		exit(0);
	}

}# end if


else { # this is POST of data from form
	&getinfo; # basic info from ENV
	&ReadParse(); # parse using same system as UBB
	$DirToCheck = $in{'absolutepath'}; # take input from form 
}

# clean up and check path supplied

$DirToCheck =~ s/\s+$//sg; # rem leading and trailing spaces
$DirToCheck =~ s/^\s+//sg;
	if ($DirToCheck =~ /(.*)/){ # untaint
		$DirToCheck = $1;	
	}
&CheckBadChars($DirToCheck); # no funny characters or commands


$ThisScriptDir = &getThisScriptDir();# get *this* CGI Script Directory path
$OrigDirToCheck = $DirToCheck; # keep a copy of this global va



&print_headers;
&print_table_top;

if($DirToCheck eq '') { # a missing path or PERLIS did not provide any path to check for
  $errortype = 'paths';
  &parse_help('paths');
  &print_result_row ('Path Missing!','There is no absolute path to check','Click back to enter an absolute path manually and submit again','paths','solution:');
  &print_table_bottom;
  #print "</table>";  #end code
  exit;
}

# or continue with selected tests

# Always Test for Existence of Directory selected

($Existence_Check_Result,$anyerrormessage,$errortype,$errorlabel) = &checkDirExistence($DirToCheck); # does it exist?
&print_result_row ('Path',$Existence_Check_Result,$anyerrormessage,$errortype,$errorlabel);


# Option 1. Test for R/W/Append, Mkdir/Rmdir in the directory selected

if ($in{'action'} eq 'dirwritetest') { # test read, write, append delete, mkdir, rmdir

  unless ($DirNotFound){ # $DirNotFound means the directory doesn't exist so don't bother with this test
	($DirToCheck_ReadWrite,$anyerrormessage,$errortype,$errorlabel)= &checkdirReadWrite($DirToCheck);
	  &print_result_row ('Directory Read/Write?',$DirToCheck_ReadWrite,$anyerrormessage,$errortype,$errorlabel);
  }# end unless

}# end of option 1  directory write test




# OPTION 2. Test for Required files *in the directory* selected

if ($in{'action'} eq 'testrequired') { # check each library or config file for availability
 	
 	&isThisFreeware(); # change @filestocheck to match Freeware 'requires'

	foreach $variablefile(@filestocheck){	
	  undef($anyerrormessage);
	  undef($errortype);
	  undef($errorlabel);
	  ($variable_file_status,$anyerrormessage,$errortype,$errorlabel) = &checkRequired_Files($variablefile);	
	  &print_result_row ($variablefile,$variable_file_status,$anyerrormessage,$errortype,'');
	}
} # end Option 2


# OPTION 3. Test for R/W, of 4 variable files *in the directory* selected
if ($in{'action'} eq 'checkreadwrite') {

 foreach $filename(@variablesfiles){
 	undef($read_write_status);
 	undef($anyerrormessage);
 	undef($errortype);
 	undef($errorlabel); 	
 	($read_write_status,$anyerrormessage,$errortype,$errorlabel) = &check_variable_file_readwrite($filename);
	&print_result_row ($filename,$read_write_status,$anyerrormessage,$errortype,$errorlabel);
 }	
} # end Option 3


# Option 4. Test Absolute paths in a UltBB.setup *if found*.

if ($in{'action'} eq 'checkabsolutes') { # check absolute paths if defined in UltBB.setup

  ($variable_file_status,$anyerrormessage,$errorlabel) = &checkRequired_Files('UltBB.setup');


 if ($anyerrormessage ne ''){
 	 $anyerrormessage = "Are you sure you are looking in the directory where UltBB.setup is ?";
 	 $errortype = "paths";
 	 $errorlabel = "comment:";
  	 &print_result_row ('UltBB.setup','not found in this directory',$anyerrormessage,'paths',$errorlabel);
 }
 
 else { # continue only if there's no problem with the 'require' UltBB.setup

	if (-e "$CGIPath/Ultimate.cgi"){
  	  &print_result_row ('CGI Directory Path OK','There is a correct path in general settings',$errormessage,$errortype);
	 }
	else {
 	  &print_result_row ('CGI Directory Path','has not been defined sucessfully in the control panel',$errormessage,'paths');	
	}

	if ($NonCGIPath ne '') {
	($DirToCheck_ReadWrite,$anyerrormessage)= &checkdirReadWrite($NonCGIPath);
 	   &print_result_row ('NonCGI Directory Path OK',$DirToCheck_ReadWrite,$anyerrormessage,$errortype);
	}
	else {
 	   &print_result_row ('NonCGI Directory Path','has not been defined sucessfully in the control panel',$anyerrormessage,'paths');	
	}

	if ($MembersPath ne '') {
  	  ($DirToCheck_ReadWrite,$anyerrormessage)= &checkdirReadWrite($MembersPath);
  	  &print_result_row ('Members Directory Path OK',$DirToCheck_ReadWrite,$anyerrormessage,$errorlabel);
	}
	else {
 	  &print_result_row ('Members Directory Path','has not been defined sucessfully in the control panel',$anyerrormessage,'paths');	
	}
	
	
	if (-e "$VariablesPath/UltBB.setup"){
  	  &print_result_row ('Variables Directory Path Found','There is a correct path in general settings',$anyerrormessage,$errortype);
	 }
	else {
 	  &print_result_row ('Variables Directory Path','has not been defined sucessfully in the control panel',$errormessage,'paths');	
	}
	

 } # end else continue if ...
	
} # end check absolute paths check


&print_result_row ('Next Action:',"<a href=javascript:history.go(-1)>go back</a>  &#149;  <a href=$ENV{'SCRIPT_NAME'}?q=0&p=$OrigDirToCheck>more tests with this path</a>  &#149; <a href=$ENV{'SCRIPT_NAME'}>full reset</a>",'','nohelp');

&print_table_bottom;


# END 

exit(0);

##############################################
# S U B R O U T I N E S  #1

sub error {
 my $message = shift;	
 print "</p>$message<p>\n\n";	
}



sub print_test_form {
	
print <<"EOF";	

<body bgcolor="#FFFFFF">
<form method="post" action="$ENV{'SCRIPT_NAME'}" name="testperms">
<table border=0 cellpadding=0 cellspacing=0 width="95%"align=center><TR><td bgcolor="#000000">
  <table width="100%" cellspacing="1" cellpadding="4" border=0>
    <tr bgcolor="Olive"> 
      <td colspan="2"><b><font color="#FFFFFF" class="title">UBB Permissions &amp; 
        Paths Diagnostic Script</font></b></td>
    </tr>
    <tr> 
      <td width="20%" bgcolor="#B8C6AE"  align="right">Server&nbsp;Type</td>
      <td width="80%" bgcolor="#FFFFFF">$serverspec &nbsp;</td>
    </tr>
    <tr> 
      <td width="20%" bgcolor="#B8C6AE" align="right">check&nbsp;path:</td>
      <td width="80%" bgcolor="#FFFFFF"> 
        <input type="text" name="absolutepath" size="60" value="$DirToCheck">
      </td>
    </tr>
        <tr>
      <td width="20%" bgcolor="#B8C6AE" align="right">1.</td>
      <td width="80%" bgcolor="#FFFFFF">
        <input type="radio" name="action" value="dirwritetest"$dirwritetest_check>
        check permission to write new files in this directory</td>
    </tr>
    <tr>
      <td width="20%" bgcolor="#B8C6AE" align="right">2.</td>
      <td width="80%" bgcolor="#FFFFFF">
        <input type="radio" name="action" value="testrequired"$testrequired_check>
        check for the 'required' files in both the CGI and <u>this</u> directory</td>
    </tr>
    <tr> 
      <td width="20%" bgcolor="#B8C6AE" align="right">3.</td>
      <td width="80%" bgcolor="#FFFFFF"> 
        <input type="radio" name="action" value="checkreadwrite"$checkreadwrite_check>
        check my read/write permissions on the 4 variables files </td>
    </tr>
    <tr> 
      <td width="20%" bgcolor="#B8C6AE" align="right">4.</td>
      <td width="80%" bgcolor="#FFFFFF">
        <input type="radio" name="action" value="checkabsolutes"$checkabsolutes_check>
        check my absolute paths in general settings if available </td>
    </tr>
    <tr> 
      <td width="20%" bgcolor="#B8C6AE">&nbsp;</td>
      <td width="80%" bgcolor="#FFFFFF">
        <input type="submit" name="Submit" value="Submit">
        <input type="reset" name="reset" value="Reset">
      </td>
    </tr>
    <tr bgcolor="Olive"> 
      <td width="20%"align="right"><font color="#FFFFFF">ver $testversion</font></td>
      <td width="80%" align="right"><font color="#FFFFFF">&copy; 2000 Infopop 
        Corporation All Rights Reserved</font></td>
    </tr>
  </table>
  </TD></TR></TABLE>
</form>
</body>
</html>

EOF
	
}


## develperms subroutines

sub getThisScriptDir { # get working directory of cgi script 

my $ThisScriptDir;

if ($ENV{'PATH_TRANSLATED'}){
$ThisScriptDir = dirname($ENV{'PATH_TRANSLATED'});	
}
elsif ($ENV{'SCRIPT_FILENAME'}){
$ThisScriptDir = dirname($ENV{'SCRIPT_FILENAME'});	
}
else {
$ThisScriptDir = $DirToCheck;	
}

$ThisScriptDir =~ s/\\/\//g; # leaning toothpicks
return $ThisScriptDir;
	
}# end SR





sub getinfo {
	
if ($ENV{'SERVER_SOFTWARE'} =~ /IIS/){ 
	$serverspec = $ENV{'SERVER_SOFTWARE'};
	$DirToCheck = dirname($ENV{'PATH_TRANSLATED'});
	$OS = 'WIN';
} 

elsif ($ENV{'SERVER_SOFTWARE'} =~ /win32/i){
	$serverspec = $ENV{'SERVER_SOFTWARE'};
	$DirToCheck = dirname($ENV{'SCRIPT_FILENAME'});
	$OS = 'WIN';
} 


elsif ($ENV{'SERVER_SOFTWARE'} =~ /Unix/i){
	$serverspec = $ENV{'SERVER_SOFTWARE'};
	$DirToCheck = dirname($ENV{'SCRIPT_FILENAME'});
	$OS = 'NIX';
} 

elsif ($ENV{'SERVER_SOFTWARE'} =~ /linux/i){
	$serverspec = $ENV{'SERVER_SOFTWARE'};
	$DirToCheck = dirname($ENV{'SCRIPT_FILENAME'});
	$OS = 'NIX';
}

elsif ($ENV{'PERLHOST'} =~ /perlis/i){
	  $serverspec = $ENV{'PERLHOST'};
	  $pathmessage = "<p>Sorry! There is not enough information in the environmental variables to do this test.<p>\n\n"; 	
	  $pathmessage .= "<p> You must edit in a full path in the box below</p>\n\n";
	  $OS = 'WIN';
} 

else {
	if ($ENV{'SERVER_SOFTWARE'}){
	  $serverspec = $ENV{'SERVER_SOFTWARE'};	
	}
	else {
	  $serverspec = 'server type not recognized';
	}

	if ($ENV{'SCRIPT_FILENAME'}){
	   $DirToCheck = dirname($ENV{'SCRIPT_FILENAME'});
	}
	elsif($ENV{'PATH_TRANSLATED'}){
	   $DirToCheck = dirname($ENV{'PATH_TRANSLATED'});
	}
	else {	
	  $pathmessage = "<p>Sorry! There is not enough information in the environmental variables to do this test."; 	
	  $pathmessage .= "You must edit in a full path in the box above";
	}  

	if ($DirToCheck =~/\:/) { # look for colon in path
	$OS = 'WIN';
	}
	elsif (($DirToCheck =~/^\//)) {
	$OS = 'NIX';		
	}
	else {
	$OS = 'unknown';		
	}

}

if ($serverspec =~/IIS/){
	$servertype = 'IIS';	
}
elsif ($serverspec =~ /Apache/){
	$servertype = 'Apache';	
}
else {
	$servertype='unknown';	
}

	
}# end SR


# READ PARSE DIE IS TAKEN FROM cgi-lib.pl by Steven E. Brenner
# S.E.Brenner@bioc.cam.ac.uk
# $Id: cgi-lib.pl,v 2.12 1996/06/19 13:46:01 brenner Exp $
#
# Copyright (c) 1996 Steven E. Brenner

sub ReadParse {

$cgi_lib'version = sprintf("%d.%02d", q$Revision: 2.12 $ =~ /(\d+)\.(\d+)/);


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
# $Id: cgi-lib.pl,v 2.12 1996/06/19 13:46:01 brenner Exp $
#
# Copyright (c) 1996 Steven E. Brenner

sub CgiDie {
  local (@msg) = @_;
  die @msg;
}





sub print_headers {

print <<"EOF";	

<html>
<head>
<title>UBB Paths and Permissions Test</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<style type="text/css">
<!--
b {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt}
td { font-family: Arial, Helvetica, sans-serif; font-size: 10pt }
p { font-family: Arial, Helvetica, sans-serif; font-size: 10pt }
.title {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11pt}
.sidebar {  font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt}
-->
</style></head>	
<body bgcolor="#FFFFFF" text="#000000" link="#0033CC" vlink="#666666" alink="#FF6600">
EOF
	
}


sub print_table_top {

print <<"EOF";	
<table border=0 cellpadding=0 cellspacing=0 width="95%" align="center"><TR><td bgcolor="#000000">
<table width="100%" cellspacing="1" cellpadding="4" border=0>
    <tr bgcolor="Olive"> 
      <td colspan="3"><b><font color="#FFFFFF" class="title">Checking $DirToCheck
      </font></b></td>
    </tr>
    
EOF


} # end SR

sub print_table_bottom {

print <<"EOF";	

    <tr bgcolor="Olive"> 
      <td align=right><font class="sidebar" color=Olive>version $testversion</font></td>
     <td align="right"colspan=2><font color="#FFFFFF"> &copy; 2000 Infopop 
        Corporation All Rights Reserved</font></td>
    </tr>
 </table>
 </td></tr></table>  
 </body></html>
 
EOF


} # end SR



sub print_result_row {
	
my $heading = shift;
my $result = shift;
my $errormessage = shift;
my $errortype = shift;
my $errorlabel = shift;

if ($errortype eq '') { ############# FIX
	$help = 'OK'
}
else {
	$help = &parse_help($errortype);	
}	

if ($errorlabel eq ''){
	$errorlabel = 'error:';	
}

print <<"EOF";	
   <tr> 
      <td bgcolor="#B8C6AE" align="right" width=20%><font class="sidebar">$heading</font></td>
      <td bgcolor="#FFFFFF">$result</td>
<td bgcolor="#FFFFFF">$help</td>
    </tr>
    
EOF
	

unless ($errormessage eq '') {

print <<"EOF";	

   <tr> 
      <td bgcolor="#B8C6AE" align="right" width=20%><font class="sidebar">$errorlabel</font></td>
      <td bgcolor="#FFFFFF">$errormessage</td>
      <td bgcolor="#FFFFFF">&nbsp;</td>
    </tr>
EOF
		
	
} #  end unless errormessage ..

}  #end SR


sub checkDirExistence { # check for path existence

	my $DirToCheck = shift;
	my $result;
	my $localerrormessage;
	my $localerrortype;
	my $localerrorlabel;

if (-d $DirToCheck) { 
	$result ="Path exists and is a directory";
}
else {
	$result = "Path does NOT exist or is not a directory";
	$DirNotFound++; # set global error flag that this test is going nowhere!!
	$localerrortype = 'paths';
	$localerrormessage = 'Click back and enter a correct absolute path';
	$localerrorlabel = 'solution:';

}
return ($result,$localerrormessage,$localerrortype,$localerrorlabel);
}# end SR



sub checkdirReadWrite {
	
	$DirToCheck = shift; # let this be global
	my $result;
	my $localerrormessage;
	my $localerrortype;
	my $localerrorlabel;
	
	my $yeswriteable =0; # 0 is 'not writeable'
	my $errorflag = 0;  # 0 is 'no error found
	
	
	
if (open TESTFILE, ">$DirToCheck/0UBBtestTQW.cgi"){
	$result = "Write, ";
	$yeswriteable++;
} 
else {
	$result = "NOT Writeable,";
	$errorflag++;
}
close (TESTFILE);


if  ($yeswriteable >= 1) {  # only check the read, append, delete if it's writeable

	if (open TESTFILE, "$DirToCheck/0UBBtestTQW.cgi"){
	  $result .= "Read, ";
	}
 	else {
	  $result .= "NOT Readable,";
	  $errorflag++;
	}

	close (TESTFILE);

	if (open TESTFILE, ">>$DirToCheck/0UBBtestTQW.cgi"){
	$result .= "Append,";
	}
	else { 
	  $result .= "Append FAILED,";
	  $errorflag++;
	} 
	
        close (TESTFILE);
 
 	if (unlink("$DirToCheck/0UBBtestTQW.cgi")){
	$result .=" Deleted OK,";
	}
	else {
	  $result .=" Delete FAILED";
	  $errorflag++;
	}


	unless ($DirToCheck eq $ThisScriptDir) { # don't test mkdir in cgi directory
 	 if (mkdir("$DirToCheck/0UBBtestmkdir", 0777)){
	   $result .=" <br>[MakeDir, ";
	 }
	 else {
	  $result .=" <br>[MakeDir FAILED, ";
	  $errorflag++;
	 }
 	 if (rmdir("$DirToCheck/0UBBtestmkdir")){
	  $result .=" RemDir: OK]";
	 }
	 else {
	   $result .= " RemDir FAILED]";
	   $errorflag++;
	 }

	}# end 'unless' exception for the CGI directory
	
}# end if 'yeswriteable' is > 0


else { # end if NOT writeable
	$localerrormessage = $!;			
}


if ($errorflag >= 1) {
	($localerrormessage,$localerrorlabel) = &parse_error($localerrormessage);
	$localerrortype = 'readwrite';
	#$localerrorlabel = 'problem';
}

return ($result,$localerrormessage,$localerrortype,$localerrorlabel); # $localerrormessage will be undef if successful

}# end checkdirReadWrite


sub checkRequired_Files { # check requires
	my $FileToCheck = shift;
	my $result= "$FileToCheck is missing in this directory or has not been uploaded in ASCII";
	my $localerrormessage;
	my $localerrortype;
	my $localerrorlabel; 

	eval {require "$FileToCheck"};

 	if ($@) { # try looking in the specified path
	eval {require "$DirToCheck/$FileToCheck"};
	}

 	if ($@) {
 	$localerrormessage = $!;
	$localerrortype = 'requires' ;
	}
	else {
 	$result = "found";
	}

   return ($result,$localerrormessage,$localerrortype,$localerrorlabel); # $localerrormessage if any
 }# end SR



sub check_variable_file_readwrite {

my $filetocheck = shift;

my $readwritestatus = 'not tested';
my $filereadOK;
my $localerrormessage;
my $localerrortype;
my $localerrorlabel;
my $result;

	if (open VARIABLEFILE, "$DirToCheck/$filetocheck") {
 	   @data = <VARIABLEFILE>;
 	   close (VARIABLEFILE);
	   $readwritestatus = "Read";
	   $filereadOK++;
	}
	else {
	   $result = "NOT Readable</font>";
	   $localerrormessage = "Are you checking in the correct directory?";	
	     unless (-e "$DirToCheck/$filetocheck") {
	       $readwritestatus = "isn't found in $DirToCheck";
		  $localerrortype = 'paths';
	       
	     }
        }# end else	

     
        
       	if ($filereadOK) { # only continue if file was readable

		if (open VARIABLEFILE, ">$DirToCheck/$filetocheck") {
 	   	  print VARIABLEFILE @data; # @data exists from earlier openforRead
 	   	  close (VARIABLEFILE);
	   	  $readwritestatus .= "/Write:OK";
		}
		else {
	   	  $readwritestatus .= "/NOT writeable";
	   	  $localerrormessage .= $!;	
		  #$localerrormessage = &parse_error($localerrormessage);
		  $localerrortype = 'readwrite';
		}
	}#  end if fileread OK
	
return ($readwritestatus,$localerrormessage,$localerrortype,'problem:');
	
}# end SR


## end subs.pl subroutines

sub parse_error {

my $errormessage = shift;
my $errorlabel;

if ($OS =~ /nix/i) {

	$mode = sprintf"%1o",((stat($DirToCheck))[2] & 07777);

	if (($mode == 755) && ($DirToCheck eq $ThisScriptDir)){ # i.e. this is the cgi dir we're checking
		$errormessage = "The mode is $mode which is normal for a CGI directory. It should not be writeable";
		$errorlabel = 'comment:';
	}
	else {
		$errormessage = "Perl cannot write new files. Directory permissions are now $mode";	
		$errorlabel = 'problem:';
	}
}

elsif($OS =~ /WIN/i) {

	if ($DirToCheck eq $ThisScriptDir) {
		$errormessage = " Your cgi directory can be Non-Writeable ONLY if the 4 variables files are made RWXD by IUSR_$ENV{'COMPUTERNAME'}.  See advanced help.";
		$errorlabel = 'warning:';
	return ($errormessage,$errorlabel);
	}
	
	elsif($ENV{'COMPUTERNAME'}){
		$errormessage .= " IUSR_$ENV{'COMPUTERNAME'} requires RWXD permissions";
		$errorlabel = 'problem:';
	}
	else {
		$errormessage .= " NT file permissions require RWXD by PERL";	
		$errorlabel = 'problem:';
	}	

}

else {
	$errormessage = " permission denied [no further information from the server]";	
	$errorlabel = 'problem:';
}


sub isThisFreeware { # change 'required' list if this is freeware
  eval{require "ubb_library.pl"};
	unless ($Version){ # only licensed UBB has this variable
	  @filestocheck = @filestocheck_UBBFree; 
	}
}# e


return ($errormessage,$errorlabel);
	
} # end SR

sub parse_help { # format help message
my $errortype = shift;

if ($errortype eq 'nohelp'){
	return '&nbsp;';
}
else {
	return "<A HREF=$ubb_help_url?OS=$OS&server=$servertype&errortype=$errortype TARGET=\"_$errortype\">help<a/>";
}

}# end SR


sub CheckBadChars { # check for | , ; .. or >< character hack attempts
	my $checkthis = shift;
		if($checkthis =~ /\||\;|<|>|\.\.|%/){ # 
		  die(&error("Invalid characters in your path.") );
		}	
return 1;
} # end SR


sub decode_query {
	my $querystring = shift;
	my($command,$path) = split(/&/,$querystring);

	if ($command =~ /^(q=|o=)/) {
	($commandtype,$command) = split(/=/,$command);
	}
	else {
	$unknown++;	
	}

	if ($path =~ /^p=/) {
	($junk,$path) = split(/=/,$path);
	}
	else {
	$unknown++;	
	}

 if ($unknown) {
 	&error("Unknown or corrupt query. Click <A HREF=$this_script_name>here</p>");
	 exit(0);	
 }

 if ($command == 1) {
 	$command = "dirwritetest";
 	$dirwritetest_check = ' checked';	
 }
 elsif ($command == 2)  {
  	$command = "testrequired";		
	$testrequired_check = ' checked';
 }
 elsif ($command == 3)  {
 	$command = "checkreadwrite";	
 	$checkreadwrite_check = ' checked';
 }
 elsif ($command == 4)  {
 	$command = "checkabsolutes";
 	$checkabsolutes_check = ' checked';	
 }
 elsif ($command == 0)  {
 	$command = "set_manual_paths";
 }
 else {
   	&error("Unknown or corrupt query: Command out of range. Click <A HREF=$this_script_name>here</p>");	
	exit(0);
 }

return ($command,$path,$commandtype);

} # end SR


exit(0);