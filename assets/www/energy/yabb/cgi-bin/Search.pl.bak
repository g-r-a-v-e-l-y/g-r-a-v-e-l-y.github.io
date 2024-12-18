#!/usr/bin/perl

#######################################################################################
# search.pl       by Matt Mecham                                                      #
#######################################################################################
#                                                                                     #
# Yet another Bulletin Board (http://www.yabb.com.ru)                                 #
# Open Source project started by Zef Hemel (zef@zefnet.com)                           #
# ===========================================================================         #
# Copyright (c) The YaBB Programming team                                             #
#######################################################################################
# Slightly modified by: Kevin 'Alesis Q' Large  (alesisq@midamericascreens.com)       #
#######################################################################################

require "Settings.pl";
require "$sourcedir/Subs.pl";

$Cookie_Exp_Date = 'Mon, 31-Jan-3000 12:00:00 GMT';
&get_date;
&readform;
$cgi = "$boardurl/YaBB.pl\?board=$currentboard";
foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
	($cookie,$value) = split(/=/);
	if($cookie eq "$cookieusername") { $username="$value"; }
	if($cookie eq "$cookiepassword") { $password="$value"; }
}

if($username eq "") { $username = "Guest"; }

# Load user settings
if($username ne "Guest") {
	open(FILE, "$memberdir/$username.dat");
	&lock(FILE);
	@settings=<FILE>;
	&unlock(FILE);
	close(FILE);
	$settings[0] =~ s/\n//g;
	$settings[1] =~ s/\n//g;
	$settings[2] =~ s/\n//g;
	$settings[3] =~ s/\n//g;
	$settings[4] =~ s/\n//g;
	$settings[5] =~ s/\n//g;
	$settings[6] =~ s/\n//g;
	$settings[7] =~ s/\n//g;
	$settings[8] =~ s/\n//g;
	$realname="$settings[1]";
	$realemail = "$settings[2]";
}

# Write log
open(LOG, "$vardir/log.txt");
&lock(LOG);
@entries = <LOG>;
&unlock(LOG);
close(LOG);
open(LOG, ">$vardir/log.txt");
&lock(LOG);
$field="$username";
if($field eq "Guest") { $field = "$ENV{'REMOTE_ADDR'}"; }
print LOG "$field\|$date\n";
foreach $curentry (@entries) {
	$curentry =~ s/\n//g;
	$curentry =~ s/\r//g;
	($name, $value) = split(/\|/, $curentry);
	$date1="$value";
	$date2="$date";
	&calctime;
	if($name ne "$field" && $result <= 15) {
		print LOG "$curentry\n";
	}
}
&unlock(LOG);
close(LOG);

# Load board information
if($currentboard ne "") {
	open(FILE, "$boardsdir/$currentboard.dat");
	&lock(FILE);
	@boardinfo=<FILE>;
	&unlock(FILE);
	close(FILE);
	$boardinfo[0] =~ s/\n//g;
	$boardinfo[2] =~ s/\n//g;
	$boardinfo[0] =~ s/\r//g;
	$boardinfo[2] =~ s/\r//g;
	$boardname = "$boardinfo[0]";
	$boardmoderator = "$boardinfo[2]";
	open(MODERATOR, "$memberdir/$boardmoderator.dat");
	&lock(MODERATOR);
	@modprop = <MODERATOR>;
	&unlock(MODERATOR);
	close(MODERATOR);
	$moderatorname = "$modprop[1]";
	$moderatorname =~ s/\n//g;
}
$thisprogram = "Search.pl";

$title="Search";
&header;

&readform;

$action = $FORM{'action'};
$namesearch = $FORM{'namesearch'};
$wordsearch = $FORM{'wordsearch'};
$catsearch = $FORM{'catsearch'};
$namepostsearch = $FORM{'namepostsearch'};
$numberreturned = $FORM{'numberreturned'};
$arraytostart = $FORM{'arraytostart'};
$newnumber = $FORM{'newnumber'};

######lets trash URI

$namesearch =~ s/ //isg;
$namesearch =~ s/\|//isg;
$namesearch =~ s/\.//isg;
$namesearch =~ s/\,//isg;
$namesearch =~ s/\+//isg;
$namesearch =~ s/\;//isg;
$namesearch =~ s/\://isg;
$namesearch =~ s/\"//isg;
$namesearch =~ s/\'//isg;

$namepostsearch =~ s/ //isg;
$namepostsearch =~ s/\|//isg;
$namepostsearch =~ s/\.//isg;
$namepostsearch =~ s/\,//isg;
$namepostsearch =~ s/\+//isg;
$namepostsearch =~ s/\;//isg;
$namepostsearch =~ s/\://isg;
$namepostsearch =~ s/\"//isg;
$namepostsearch =~ s/\'//isg;

$wordsearch =~ s/ //isg;
$wordsearch =~ s/\|//isg;
$wordsearch =~ s/\.//isg;
$wordsearch =~ s/\+//isg;
$wordsearch =~ s/\;//isg;
$wordsearch =~ s/\://isg;
$wordsearch =~ s/\"//isg;
$wordsearch =~ s/\'//isg;



$searchtype = $FORM{'whichsearch'};



########################### if we are searching, call the appropriate routine, and display if needed


if ($action eq "dosearch") { #start search results



############################ name search display results


	if ($searchtype eq "user") {
	
	print qq~

<table cellspacing=1 cellpadding=0 border=0 align=center width=100%>
<tr><td>
<table cellspacing=0 cellpadding=5 border=0 align=center width=100%>
<tr>
<td valign=middle>
<font size=2 color="$color{'titletext'}"><b>$txt{'166'}</b></font>
</td></tr>

~;
	
	&namesearch("$catsearch");
	
	$totals = $mastercount - 1;
	
	if ($arraytostart eq "") { $arraytostart = "0"; }
	$arraystart = $arraytostart;
	
	$newnumber = $numberreturned + $newnumber;
	if ($newnumber > $totals) {
	$arrayend = $totals;
	$are_we_done = "<tr><td><b>$txt{'167'}</b><hr size=1 width=60% align=left><b><a href=\"$boardurl/Search.pl\">$txt{'168'}</a></b><br><br></td></tr></table></td></tr></table>";
	}
	else {
	$arrayend = ($numberreturned + $arraystart) - 1;
	$arraytostart = $arrayend + 1;
	$newnumber = $arrayend;
	$are_we_done = qq~
	
	<form action=\"$thisprogram\" method=\"post\">
	<tr><td>
	<input type=hidden name=action value=dosearch>
	<input type=hidden name=namesearch value=$namesearch>
	<input type=hidden name="whichsearch" value="user">
	<input type=hidden name=catsearch value=$catsearch>
	<input type=hidden name=arraytostart value=$arraytostart>
	<input type=hidden name=newnumber value=$newnumber>
	<input type=hidden name=numberreturned value=$numberreturned>
	<input type=submit name=submit value=\"$txt{'169'}\">
	</form>
	</td></tr>
	
	~;
	
	}
	
	
	$totaldone = $totals + 1;
	$totalstart = $arraystart + 1;
	$totalfinished = $arrayend + 1;
	
	if ($totaldone eq "0") { $resulttext = "$txt{'170'}"; }
	else { $resulttext = "$txt{'171'}: $totalstart $txt{'172'} $totalfinished"; }
	
	print "<tr><td><font size=2><b>$txt{'173'} $namesearch - $totaldone $txt{'174'}</b></font></td></tr>";
	print "<tr><td><font size=1><br>$resulttext<p></font></td></tr>";
		
		$counter2 = $arraystart;
		foreach $number (@counter[$arraystart .. $arrayend]) {
		
		$temptitle = @threadtitle_var[$counter2];
		$tempmessage = @messagenumber_var[$counter2];
		$tempmessagetitle = @messagetitle_var[$counter2];
		$tempposter = @poster_var[$counter2];
		$tempdate = @date_var[$counter2];
		
		print "<tr><td><font size=2>$txt{'178'}: <a href=\"$boardurl/YaBB.pl?board=$temptitle&action=display&num=$tempmessage\" target=\"_blank\"><b>$tempmessagetitle</b></a></font>";
		print "<br><font size=1>$txt{'175'}: <b>$tempposter</b> $txt{'176'} $tempdate<br></font>";
		print "</td></tr>";
		$counter2++;
		}
		
		print $are_we_done;
		&footer;
		exit;
	}
	
	
############################# start display of results for namepost search	
	
	if ($searchtype eq "post") {
	
	print qq~

<table cellspacing=1 cellpadding=0 border=0 align=center width=100%>
<tr><td>
<table cellspacing=0 cellpadding=5 border=0 align=center width=100%>
<tr>
<td valign=middle>
<font size=2 color="$color{'titletext'}"><b>$txt{'166'}</b></font>
</td></tr>

~;
	
	&namepostsearch("$catsearch"); 
	
	$totals = $mastercount - 1;
	
	if ($arraytostart eq "") { $arraytostart = "0"; }
	$arraystart = $arraytostart;
	
	$newnumber = $numberreturned + $newnumber;
	if ($newnumber >= $totals) {
	$arrayend = $totals;
	$are_we_done = "<tr><td><b>$txt{'167'}</b><hr size=1 width=60% align=left><b><a href=\"$boardurl/Search.pl\">$txt{'168'}</a></b><br><br></td></tr></table></td></tr></table>";
	}
	else {
	$arrayend = ($numberreturned + $arraystart) - 1;
	$arraytostart = $arrayend + 1;
	$newnumber = $arrayend;
	$are_we_done = qq~
	
	<form action=\"$thisprogram\" method=\"post\">
	<tr><td>
	<input type=hidden name=action value=dosearch>
	<input type=hidden name=namepostsearch value=$namepostsearch>
	<input type=hidden name="whichsearch" value="post">
	<input type=hidden name=catsearch value=$catsearch>
	<input type=hidden name=arraytostart value=$arraytostart>
	<input type=hidden name=newnumber value=$newnumber>
	<input type=hidden name=numberreturned value=$numberreturned>
	<input type=submit name=submit value=\"$txt{'169'}\">
	</form>
	</td></tr></table></td></tr></table>
	
	~;
	
	}
	
	
	$totaldone = $totals + 1;
	$totalstart = $arraystart + 1;
	$totalfinished = $arrayend + 1;
	
	if ($totaldone eq "0") { $resulttext = "$txt{'170'}"; }
	else { $resulttext = "$txt{'172'}: $totalstart $txt{'173'} $totalfinished"; }
	
	print "<tr><td><font size=2><b>$txt{'177'} $namepostsearch - $totaldone $txt{'174'}</b></font></td></tr>";
	print "<tr><td><font size=1><br>$resulttext<p></font></td></tr>";
		
		$counter2 = $arraystart;
		
		foreach $number (@counter[$arraystart .. $arrayend]) {
		
		$temptitle = @threadtitle_var[$counter2];
		$tempmessage = @messagenumber_var[$counter2];
		$tempmessagetitle = @messagetitle_var[$counter2];
		$tempposter = @poster_var[$counter2];
		$tempdate = @date_var[$counter2];
		$tempsnippet = @snippet_var[$counter2];
		
		$tempsnippet =~ s/\<br><br>/<br>/sg;
		
		print "<tr><td><table width=60% align=left border=0>";
		print "<tr><td><font size=2>$txt{'178'}: <a href=\"$boardurl/YaBB.pl?board=$temptitle&action=display&num=$tempmessage\" target=\"_blank\"><b>$tempmessagetitle</b></a></font>\n";
		print "<br><font size=1>$txt{'175'}: <b>$tempposter</b> $txt{'176'} $tempdate<br></font>\n";
		print "</td></tr>\n";
		print "<tr><td width=60%><b><font size=1 color=#ff0000>$txt{'179'}:</font></b><hr size=1 noshade align=left><font size=1 face=arial>$tempsnippet ...</font><br><hr size=1 noshade align=left></td></tr>\n";
		print "</table></td></tr>\n";
		$counter2++;
		}
		
		print $are_we_done;
		&footer;
		
		exit;
	
	}
	
############################# end display of results for namepost search

############################# start display of results for wordsearch
	
	if ($searchtype eq "keyword") {
	
print qq~

<table cellspacing=1 cellpadding=0 border=0 align=center width=100%>
<tr><td>
<table cellspacing=0 cellpadding=5 border=0 align=center width=100%>
<tr>
<td valign=middle>
<font size=2 color="$color{'titletext'}"><b>$txt{'166'}</b></font>
</td></tr>

~;
	
	&keywordsearch("$catsearch"); 
	$totals = $mastercount - 1;
	
	if ($arraytostart eq "") { $arraytostart = "0"; }
	$arraystart = $arraytostart;
	
	$newnumber = $numberreturned + $newnumber;
	if ($newnumber >= $totals) {
	$arrayend = $totals;
	$are_we_done = "<tr><td><b>End of results</b><hr size=1 width=60% align=left><b><a href=\"$boardurl/Search.pl\">$txt{'168'}</a></b><br><br></td></tr></table></td></tr></table>";
	}
	else {
	$arrayend = ($numberreturned + $arraystart) - 1;
	$arraytostart = $arrayend + 1;
	$newnumber = $arrayend;
	$are_we_done = qq~
	
	<form action=\"$thisprogram\" method=\"post\">
	<tr><td>
	<input type=hidden name=action value=dosearch>
	<input type=hidden name=wordsearch value=$wordsearch>
	<input type=hidden name="whichsearch" value="keyword">
	<input type=hidden name=catsearch value=$catsearch>
	<input type=hidden name=arraytostart value=$arraytostart>
	<input type=hidden name=newnumber value=$newnumber>
	<input type=hidden name=numberreturned value=$numberreturned>
	<input type=submit name=submit value=\"$txt{'169'}\">
	</form>
	</td></tr></table></td></tr></table>
	
	~;
	
	}
	
	
	$totaldone = $totals + 1;
	$totalstart = $arraystart + 1;
	$totalfinished = $arrayend + 1;
	
	if ($totaldone eq "0") { $resulttext = "Sorry, no matches were found"; }
	else { $resulttext = "$txt{'171'}: $totalstart $txt{'172'} $totalfinished"; }
	
	print "<tr><td><font size=2><b>$txt{'180'}: $wordsearch - $totaldone $txt{'174'}</b></font></td></tr>";
	print "<tr><td><font size=1><br>$resulttext<p></font></td></tr>";
		
		$counter2 = $arraystart;
		
		foreach $number (@counter[$arraystart .. $arrayend]) {
		
		$temptitle = @threadtitle_var[$counter2];
		$tempmessage = @messagenumber_var[$counter2];
		$tempmessagetitle = @messagetitle_var[$counter2];
		$tempposter = @poster_var[$counter2];
		$tempdate = @date_var[$counter2];
		$tempsnippet = @snippet_var[$counter2];
		$tempword = @foundword_var[$counter2];
		
		$tempsnippet =~ s/\<br><br>/<br>/sg;
		
		print "<tr><td><table width=60% align=left border=0>";
		print "<tr><td><font size=2>$txt{'178'}: <a href=\"$boardurl/YaBB.pl?board=$temptitle&action=display&num=$tempmessage\" target=\"_blank\"><b>$tempmessagetitle</b></a></font>\n";
		print "<br><font size=1>$txt{'175'}: <b>$tempposter</b> on $tempdate<br>$txt{'181'}: <b>$tempword</b></font>\n";
		print "</td></tr>\n";
		print "<tr><td width=60%><b><font size=1 color=#ff0000>$txt{'179'}:</font></b><hr size=1 noshade align=left><font size=1 face=arial>$tempsnippet ...</font><br><hr size=1 noshade align=left></td></tr>\n";
		print "</table></td></tr>\n";
		$counter2++;
		}
		
		print $are_we_done;
		&footer;
		exit;
	
	}



} # end search results

else { &setup; }



############################# start search request form
sub setup { # start setup

	$dirtoopen = "$boardsdir";
    opendir (DIRECTORY,"$dirtoopen"); 
    @dirdata = readdir(DIRECTORY);
    closedir (DIRECTORY);
    
    @datdata = grep(/dat/,@dirdata);
    $totalboards = @sorteddirdata;
    
    foreach $category (@datdata) { # start to open files
    
    ($grabtxtfile, $trash) = split(/\./,$category);
    
    open(FILE, "$boardsdir/$category") || next;
	&lock(FILE);
	@newcatdata = <FILE>;
	&unlock(FILE);
	close(FILE);
	
	$selecthtml .= "<option value=\"$grabtxtfile.txt\">@newcatdata[0]\n";
	
	
	} # end the foreach line
	
    
if ($numberreturned eq "") { $tempnumbox = "25"; }

print qq~

<table cellspacing=1 cellpadding=0 border=0 align=center width=100%>
<tr><td>
<table cellspacing=0 cellpadding=5 border=0 align=center width=100%>

<tr>
<td valign=middle colspan=2><font size=2 color="$color{'titletext'}"><b>$txt{'182'}</b></font></td>
</tr>

<form action="$thisprogram" method="post">


<tr>
<td valign=middle>
<font size=3 color=#00000><b>$txt{'183'}</b></font><br><font size=2 color=#ff0000>$txt{'184'}.
</font></td>
<td valign=middle>
<font size=3 color=#00000><b>$txt{'185'}</b></font></td>
</tr>


<tr><td valign=middle>
<p><p><font size=2 color=#000000>
<b>$txt{'186'}</b>
<br>
<input type=text size=50 name=namesearch>&nbsp\;<input type=radio name="whichsearch" value="user"><p>
<b>$txt{'187'}</b>
<br>
<input type=text size=50 name=namepostsearch>&nbsp\;<input type=radio name="whichsearch" value="post">
<p>
<b>Search by keyword(s)</b><br>
<input type=text size=50 name=wordsearch>&nbsp\;<input type=radio name="whichsearch" value="keyword"><p>
</td>
<td valign=middle>
<p><font size=2 color=#000000>
<b>$txt{'188'}</b><br>
$txt{'189'}<p>
<select name=\"catsearch\"><option value=\"all\">$txt{'190'} $selecthtml</select><p>
<b>$txt{'191'}</b><p>
<input type=text size=5 name=numberreturned value=$tempnumbox><p>
</td></tr>
<tr><td colspan=2 valign=middle align=center>
<input type=hidden name=action value=dosearch>
<input type=submit name=submit value=\"Search\"></center>
</form>
</td></tr>
</table></td></tr></table>

~;
&footer;
} # end routine

###################################### end search request form


######################################		
# routine for thread started by user
######################################

sub namesearch {
local($cattosearch) = @_;
	
	$test = $cattosearch;
	$mastercount = "0";
	if ($cattosearch eq "all") {
	
	$dirtoopen = "$boardsdir";
    opendir (DIRECTORY,"$dirtoopen"); 
    @dirdata = readdir(DIRECTORY);
    closedir (DIRECTORY);
	@messagesraw = grep(/txt/,@dirdata);
		
		foreach $message (@messagesraw) { # start filter for names
		($threadtitle, $trash) = split (/\./,$message);
		
		open(FILE, "$boardsdir/$message") || next;
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		
			foreach $line (@newmessagedata) { # start filtering
		
			($messagenumber, $messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$line);
		
				$poster =~ s/ //isg;
				if ($namesearch eq $poster) {
				@threadtitle_var[$mastercount] = $threadtitle;
				@messagenumber_var[$mastercount] = $messagenumber;
				@messagetitle_var[$mastercount] = $messagetitle;
				@poster_var[$mastercount] = $poster;
				@date_var[$mastercount] = $date;
				@counter[$mastercount] = $mastercount;
				$mastercount++;
				} # end poster match
				
			} # end filtering
			
		} # end filter for names
	
	} # end IF loop
	
	else {
	
		open(FILE, "$boardsdir/$cattosearch") || &fatal_error("$txt{'23'} $currentboard.txt");
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		
		($threadtitle, $trash) = split (/\./,$cattosearch);
		
			foreach $line (@newmessagedata) { # start filtering
		
			($messagenumber, $messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$line);
			$poster =~ s/ //isg;
			if ($namesearch eq $poster) {
				@threadtitle_var[$mastercount] = $threadtitle;
				@messagenumber_var[$mastercount] = $messagenumber;
				@messagetitle_var[$mastercount] = $messagetitle;
				@poster_var[$mastercount] = $poster;
				@date_var[$mastercount] = $date;
				$mastercount++;
				} # end poster match
				
			} # end filtering
			
	  } # end ELSE loop
		
	} # end name search routine

################################		
# routine for posted in by user
################################

sub namepostsearch {
	local($cattosearch) = @_;
	
	$test = $cattosearch;
	$mastercount = "0";
	if ($cattosearch eq "all") {
	
	$dirtoopen = "$boardsdir";
    opendir (DIRECTORY,"$dirtoopen"); 
    @dirdata = readdir(DIRECTORY);
    closedir (DIRECTORY);

	@messagesraw = grep(/txt/,@dirdata);

		foreach $message (@messagesraw) { # start filter for names
		($threadtitle, $trash) = split (/\./,$message);
		
		open(FILE, "$boardsdir/$message") || next;
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		
			foreach $line (@newmessagedata) { # start filtering
		
			($messagenumber, $trash, $threadstartedbyposter, $thrash, $trash, $trash, $trash, $trash, $trash, $trash) = split(/\|/,$line);
		
			open(FILE, "$datadir/$messagenumber.txt") || next;
			&lock(FILE);
			@postdata = <FILE>;
			&unlock(FILE);
			close(FILE);
			
			
				foreach $postline (@postdata) {
			
				($messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$postline);
						$poster =~ s/ //isg;
					if ($namepostsearch eq $poster) {
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $threadtitle;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = $messagetitle;
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						
						$mastercount++;
					} # end poster match
				
				} # end post text search
				
			} # end filtering
			
		} # end filter for names
		
	} # end IF loop
	
else {

		open(FILE, "$boardsdir/$cattosearch") || &fatal_error("$txt{'23'} $currentboard.txt");
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		
		($threadtitle, $trash) = split (/\./,$cattosearch);
		
		foreach $line (@newmessagedata) { # start filtering
		
			($messagenumber, $trash, $threadstartedbyposter, $thrash, $trash, $trash, $trash, $trash, $trash, $trash) = split(/\|/,$line);
		
			open(FILE, "$datadir/$messagenumber.txt") || next;
			&lock(FILE);
			@postdata = <FILE>;
			&unlock(FILE);
			close(FILE);
			
			
				foreach $postline (@postdata) {
			
				($messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$postline);
				$poster =~ s/ //isg;
					if ($namepostsearch eq $poster) {
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $threadtitle;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = $messagetitle;
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						$mastercount++;
					} # end poster match
				
				} # end post text search
				
			} # end filtering
		
	} # end ELSE loop	
	
} # end name post search routine

################################		
# routine for keywords
################################


sub keywordsearch {


	local($cattosearch) = @_;
	
	$test = $cattosearch;
	$mastercount = "0";
if ($cattosearch eq "all") {
	
	$dirtoopen = "$boardsdir";
    opendir (DIRECTORY,"$dirtoopen"); 
    @dirdata = readdir(DIRECTORY);
    closedir (DIRECTORY);
    
	@keywords = split (/,/,$wordsearch);
	@messagesraw = grep(/txt/,@dirdata);

		foreach $message (@messagesraw) { # start filter for names
		($threadtitle, $trash) = split (/\./,$message);
		
		open(FILE, "$boardsdir/$message") || next;
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		
		
		
			foreach $line (@newmessagedata) { # start filtering
		
			($messagenumber, $trash, $threadstartedbyposter, $thrash, $trash, $trash, $trash, $trash, $trash, $trash) = split(/\|/,$line);
		
			open(FILE, "$datadir/$messagenumber.txt") || next;
			&lock(FILE);
			@postdata = <FILE>;
			&unlock(FILE);
			close(FILE);
			
			
				foreach $postline (@postdata) {
			
				($messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$postline);
			
					foreach $word (@keywords) {
						if (($post =~ / $word /sgi) && ($word ne $threadstartedbyposter) && ($word ne $poster)) {
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $threadtitle;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = $messagetitle;
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						@foundword_var[$mastercount]= $word;
						$mastercount++;
						} # end keyword match
				
					} # end @keywords foreach
				
				} # end post text search
				
			} # end filtering
			
		} # end filter for names
		
	} # end IF loop
	
	
else {

		open(FILE, "$boardsdir/$cattosearch") || &fatal_error("$txt{'23'} $currentboard.txt");
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		
		@keywords = split (/,/,$wordsearch);
		
		($threadtitle, $trash) = split (/\./,$cattosearch);
		
		foreach $line (@newmessagedata) { # start filtering
		
			($messagenumber, $trash, $threadstartedbyposter, $thrash, $trash, $trash, $trash, $trash, $trash, $trash) = split(/\|/,$line);
		
			open(FILE, "$datadir/$messagenumber.txt") || next;
			&lock(FILE);
			@postdata = <FILE>;
			&unlock(FILE);
			close(FILE);
			
			
				foreach $postline (@postdata) {
			
				($messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$postline);
			
					foreach $word (@keywords) {
						if (($post =~ /$word/gi) && ($word ne $threadstartedbyposter) && ($word ne $poster)) {
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $threadtitle;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = $messagetitle;
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						@foundword_var[$mastercount]= $word;
						$mastercount++;
						} # end keyword match
				
					} # end @keywords foreach
				
				} # end post text search
				
			} # end filtering
		
		} # end ELSE loop
		
} # end keywordsearch




sub wrong {

print qq~

<table cellspacing=1 cellpadding=0 border=0 align=center width=100%>
<tr><td>
<table cellspacing=0 cellpadding=5 border=0 align=center width=100%>
<tr>
<td valign=middle>
<font size=2 color="$color{'titletext'}"><b>Search Error</b></font>
</td></tr>
<tr><td><font size=2>Please only select one option</font>
</td></tr></table></td></tr></table>
~;
print "</body></html>";
exit;

}

