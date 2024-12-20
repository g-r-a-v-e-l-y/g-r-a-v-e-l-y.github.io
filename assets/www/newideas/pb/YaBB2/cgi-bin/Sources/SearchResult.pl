###############################################################################
# SearchResults.pl                                                            #
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

$searchplver="1 Gold Beta4";

$thisprogram = "YaBB.pl?action=search";
$thisprogram2 = "YaBB.pl?action=dosearch";

&readform;

$action = $FORM{'action'};
$search = $FORM{'search'};
$catsearch = $FORM{'catsearch'};
$numberreturned = $FORM{'numberreturned'};
$arraytostart = $FORM{'arraytostart'};
$newnumber = $FORM{'newnumber'};

$dropdown = $FORM{'dropdown'};

# ==== Begin Search Stuff =====================================================

if ($action eq "dosearch") { #start search results


open(FILE,"$vardir/censor.txt");
&lock(FILE);
while( chomp( $buffer = <FILE> ) ) {
	($tmpa,$tmpb) = split(/=/,$buffer);
	push(@censored,[$tmpa,$tmpb]);
}
&unlock(FILE);
close(FILE);

# Prints out an error message if the user leaves the search form blank

if ($search eq "") { &fatal_error("$txt{'601'}"); }

# Truncates search string
$search =~ s/ //isg;
$search =~ s/\|//isg;
$search =~ s/\+//isg;
$search =~ s/\;//isg;
$search =~ s/\://isg;
$search =~ s/\"//isg;
$search =~ s/\'//isg;

# ==== Name Search (New Thread) ===============================================

if ($dropdown eq "startuser") {

	$yytitle = "$txt{'166'}";
	&header;

	&namesearch("$catsearch");

	$totals = $mastercount - 1;

	if ($arraytostart eq "") { $arraytostart = "0"; }
	$arraystart = $arraytostart;

	$newnumber = $numberreturned + $newnumber;
	if ($newnumber > $totals) {
	$arrayend = $totals;
	$are_we_done = "<font class=\"text1\" size=2>$txt{'167'} [ <a href=\"$boardurl/$thisprogram\">$txt{'168'}</a> ]<br></font>";
	}
	else {
	$arrayend = ($numberreturned + $arraystart) - 1;
	$arraytostart = $arrayend + 1;
	$newnumber = $arrayend;
	$are_we_done = qq~

	<form action=\"$thisprogram2\" method=\"post\">
	<input type=hidden name=action value=dosearch>
	<input type=hidden name=search value=$search>
	<input type=hidden name=dropdown value="startuser">
	<input type=hidden name=catsearch value=$catsearch>
	<input type=hidden name=arraytostart value=$arraytostart>
	<input type=hidden name=newnumber value=$newnumber>
	<input type=hidden name=numberreturned value=$numberreturned>
	<input type=submit name=submit value=\"$txt{'169'}\">
	</form>

	~;

	}

	$totaldone = $totals + 1;
	$totalstart = $arraystart + 1;
	$totalfinished = $arrayend + 1;

	if ($totaldone eq "0") { $resulttext = "$txt{'170'}"; }
	else { $resulttext = "$txt{'166'}: $totalstart $txt{'311'} $totalfinished"; }

	print <<"EOT";
<table width=100%>
<tr>
	<td><font class=\"text2\" size=2><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;<A href="$boardurl/YaBB.pl">$mbname</A><br><IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;$txt{'166'}</font></td>
</tr>
</table>

<table border=0 width=100% cellspacing=1 cellpadding=4 bgcolor="$color{'bordercolor'}">
<tr>
<td colspan=\"2\" bgcolor=\"$color{'titlebg'}\"><font class=\"text2\" size=2 color=\"$color{'titletext'}\">$txt{'173'}: $search - $totaldone $txt{'174'}</font></td>
</tr><tr>
<td colspan=\"2\" bgcolor=\"$color{'windowbg'}\"><font class=\"text2\" size=2>$resulttext</font></td>
<tr>
EOT

		$counter2 = $arraystart;
		foreach $number (@counter[$arraystart .. $arrayend]) {

		$temptitle = @threadtitle_var[$counter2];
		$tempmessage = @messagenumber_var[$counter2];
		$tempmessagetitle = @messagetitle_var[$counter2];
		$tempposter = @poster_var[$counter2];
		$tempdate = @date_var[$counter2];
		$tempsnippet = @snippet_var[$counter2];
		$tempsnippet =~ s/\<br><br>/<br>/sg;
		$tempcatboard = @catboard_var[$counter2];

		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$tempsnippet =~ s~\Q$tmpa\E~$tmpb~gi;
			$tempmessagetitle =~ s~\Q$tmpa\E~$tmpb~gi;
		}


		print "<td bgcolor=\"$color{'windowbg2'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'specialtext'}\">$tempdate</font></td>";
		print "<td bgcolor=\"$color{'windowbg2'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2>&nbsp;[ $tempcatboard] <a href=\"$boardurl/YaBB.pl?board=$temptitle&action=display&num=$tempmessage\" target=\"_blank\">$tempmessagetitle</a></font></td>";
		print "</tr><tr>";
		print "<td colspan=\"2\" bgcolor=\"$color{'windowbg'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2>$txt{'197'}: <font color=\"$color{'specialtext'}\">$tempposter</font><br>$tempsnippet...</font></td>";
		print "</tr><tr>";
		$counter2++;
		}

		print "<td colspan=\"2\" bgcolor=\"$color{'titlebg'}\"><font face=\"Verdana, Arial\" color=\"$color{'titletext'}\" size=2>$are_we_done</font></td>";

print <<"EOT";
</tr>
</table>
EOT

		&footer;
		exit;
	}

# ==== Name Search (New Post) =================================================

if ($dropdown eq "startpost") {

	$yytitle = "$txt{'166'}";
	&header;

	&namepostsearch("$catsearch");

	$totals = $mastercount - 1;

	if ($arraytostart eq "") { $arraytostart = "0"; }
	$arraystart = $arraytostart;

	$newnumber = $numberreturned + $newnumber;
	if ($newnumber >= $totals) {
	$arrayend = $totals;
	$are_we_done = "<font face=\"Verdana, Arial\" class=\"text1\" size=2>$txt{'167'} [ <a href=\"$boardurl/$thisprogram\">$txt{'168'}</a> ]<br></font>";
	}
	else {
	$arrayend = ($numberreturned + $arraystart) - 1;
	$arraytostart = $arrayend + 1;
	$newnumber = $arrayend;
	$are_we_done = qq~

	<form action=\"$thisprogram2\" method=\"post\">
	<input type=hidden name=action value=dosearch>
	<input type=hidden name=search value=$search>
	<input type=hidden name=dropdown value="startpost">
	<input type=hidden name=catsearch value=$catsearch>
	<input type=hidden name=arraytostart value=$arraytostart>
	<input type=hidden name=newnumber value=$newnumber>
	<input type=hidden name=numberreturned value=$numberreturned>
	<input type=submit name=submit value=\"$txt{'169'}\">
	</form>


	~;

	}

	$totaldone = $totals + 1;
	$totalstart = $arraystart + 1;
	$totalfinished = $arrayend + 1;

	if ($totaldone eq "0") { $resulttext = "$txt{'170'}"; }
	else { $resulttext = "$txt{'166'}: $totalstart $txt{'311'} $totalfinished"; }

print <<"EOT";
<table width=100%>
<tr>
	<td><font face="Verdana,Arial" size=2><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;<A href="$boardurl/YaBB.pl">$mbname</A><br><IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;$txt{'166'}</font></td>
</tr>
</table>

<table border=0 width=100% cellspacing=1 cellpadding=4 bgcolor="$color{'bordercolor'}">
<tr>
<td colspan=\"2\" bgcolor=\"$color{'titlebg'}\"><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'titletext'}\">$txt{'177'}: $search - $totaldone $txt{'174'}</font></td>
</tr><tr>
<td colspan=\"2\" bgcolor=\"$color{'windowbg'}\"><font face=\"Verdana, Arial\" class=\"text2\" size=2>$resulttext</font></td>
<tr>
EOT

		$counter2 = $arraystart;

		foreach $number (@counter[$arraystart .. $arrayend]) {

		$temptitle = @threadtitle_var[$counter2];
		$tempmessage = @messagenumber_var[$counter2];
		$tempmessagetitle = @messagetitle_var[$counter2];
		$tempposter = @poster_var[$counter2];
		$tempdate = @date_var[$counter2];
		$tempsnippet = @snippet_var[$counter2];
		$tempcatboard = @catboard_var[$counter2];
		$tempsnippet =~ s/\<br><br>/<br>/sg;

		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$tempsnippet =~ s~\Q$tmpa\E~$tmpb~gi;
			$tempmessagetitle =~ s~\Q$tmpa\E~$tmpb~gi;
		}

		print "<td bgcolor=\"$color{'windowbg2'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'specialtext'}\">$tempdate</font></td>";
		print "<td bgcolor=\"$color{'windowbg2'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2>&nbsp;[ $tempcatboard] <a href=\"$boardurl/YaBB.pl?board=$temptitle&action=display&num=$tempmessage\" target=\"_blank\">$tempmessagetitle</a></font></td>";
		print "</tr><tr>";
		print "<td colspan=\"2\" bgcolor=\"$color{'windowbg'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2>$txt{'197'}: <font color=\"$color{'specialtext'}\">$tempposter</font><br>$tempsnippet...</font></td>";
		print "</tr><tr>";
		$counter2++;
		}

		print "<td colspan=\"2\" bgcolor=\"$color{'titlebg'}\"><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'titletext'}\">$are_we_done</font></td>";

print <<"EOT";
</tr>
</table>
EOT

		&footer;

		exit;

	}

# ==== Keyword Search =========================================================

if ($dropdown eq "startwords") {

	$yytitle = "$txt{'166'}";
	&header;

	&keywordsearch("$catsearch");
	$totals = $mastercount - 1;

	if ($arraytostart eq "") { $arraytostart = "0"; }
	$arraystart = $arraytostart;

	$newnumber = $numberreturned + $newnumber;
	if ($newnumber >= $totals) {
	$arrayend = $totals;
	$are_we_done = "<font face=\"Verdana, Arial\" class=\"text1\" size=2>$txt{'167'} [ <a href=\"$boardurl/$thisprogram\">$txt{'168'}</a> ]<br></font>";
	}
	else {
	$arrayend = ($numberreturned + $arraystart) - 1;
	$arraytostart = $arrayend + 1;
	$newnumber = $arrayend;
	$are_we_done = qq~

	<form action=\"$thisprogram2\" method=\"post\">
	<input type=hidden name=action value=dosearch>
	<input type=hidden name=search value=$search>
	<input type=hidden name=dropdown value="startwords">
	<input type=hidden name=catsearch value=$catsearch>
	<input type=hidden name=arraytostart value=$arraytostart>
	<input type=hidden name=newnumber value=$newnumber>
	<input type=hidden name=numberreturned value=$numberreturned>
	<input type=submit name=submit value=\"$txt{'169'}\">
	</form>

	~;

	}


	$totaldone = $totals + 1;
	$totalstart = $arraystart + 1;
	$totalfinished = $arrayend + 1;

	if ($totaldone eq "0") { $resulttext = "$txt{'170'}"; }
	else { $resulttext = "$txt{'166'}: $totalstart $txt{'311'} $totalfinished"; }

print <<"EOT";
<table width=100%>
<tr>
	<td><font face="Verdana,Arial" size=2><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;<A href="$boardurl/YaBB.pl">$mbname</A><br><IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;$txt{'166'}</font></td>
</tr>
</table>

<table border=0 width=100% cellspacing=1 cellpadding=4 bgcolor="$color{'bordercolor'}">
<tr>
<td colspan=\"2\" bgcolor=\"$color{'titlebg'}\"><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'titletext'}\">$txt{'180'} $search - $totaldone $txt{'174'}</font></td>
</tr><tr>
<td colspan=\"2\" bgcolor=\"$color{'windowbg'}\"><font face=\"Verdana, Arial\" class=\"text2\" size=2>$resulttext</font></td>
<tr>
EOT

		$counter2 = $arraystart;

		foreach $number (@counter[$arraystart .. $arrayend]) {

		$temptitle = @threadtitle_var[$counter2];
		if($catsearch ne "all") {$temptitle = $catsearch; }
		$tempmessage = @messagenumber_var[$counter2];
		$tempmessagetitle = @messagetitle_var[$counter2];
		$tempposter = @poster_var[$counter2];
		$tempdate = @date_var[$counter2];
		$tempsnippet = @snippet_var[$counter2];
		$tempword = @foundword_var[$counter2];
		$tempcatboard = @catboard_var[$counter2];
		$tempsnippet =~ s/\<br><br>/<br>/sg;

		foreach (@censored) {
			($tmpa,$tmpb) = @{$_};
			$tempsnippet =~ s~\Q$tmpa\E~$tmpb~gi;
			$tempmessagetitle =~ s~\Q$tmpa\E~$tmpb~gi;
		}

		print "<td bgcolor=\"$color{'windowbg2'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'specialtext'}\">$tempdate</font></td>";
		print "<td bgcolor=\"$color{'windowbg2'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2>&nbsp;[ $tempcatboard] <a href=\"$boardurl/YaBB.pl?board=$temptitle&action=display&num=$tempmessage\" target=\"_blank\">$tempmessagetitle</a></font></td>";
		print "</tr><tr>";
		print "<td colspan=\"2\" bgcolor=\"$color{'windowbg'}\" valign=top><font face=\"Verdana, Arial\" class=\"text2\" size=2>$txt{'197'}: <font color=\"$color{'specialtext'}\">$tempposter</font><br>$tempsnippet...</font></td>";
		print "</tr><tr>";
		$counter2++;
		}

		print "<td colspan=\"2\" bgcolor=\"$color{'titlebg'}\"><font face=\"Verdana, Arial\" class=\"text2\" size=2 color=\"$color{'titletext'}\">$are_we_done</font></td>";

print <<"EOT";
</tr>
</table>
EOT

		&footer;
		exit;

	}



}

else { require "$sourcedir/Search.pl"; &SearchForm;  }

# ==== "Thread Started By" Routine ============================================

sub namesearch {
	local($cattosearch) = @_;
	$test = $cattosearch;
	$mastercount = "0";
	if ($cattosearch eq "all") {

	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/\n//g;
		$catinfo[1] =~ s/\r//g;
		if($catinfo[1] ne "") {
			if($settings[7] ne "Administrator" && $settings[7] ne "$catinfo[1]") {
				next;
			}
		}
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			chomp $curboard;
			($threadtitle, $trash) = split (/\./,$catinfo);
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
			open(FILE, "$boardsdir/$curboard.txt") || &fatal_error("$txt{'23'} $curboard.txt");
			&lock(FILE);
			@newmessagedata = <FILE>;
			&unlock(FILE);
			close(FILE);
			open(FILE, "$boardsdir/$curboard.dat") || &fatal_error("$txt{'23'} $curboard.dat");
			&lock(FILE);
			@currentboard = <FILE>;
			&unlock(FILE);
			close(FILE);

				foreach $line (@newmessagedata) { # start filtering

				($messagenumber, $messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$line);
					$poster =~ s/ //isg;
					if ($poster =~ /$search/sgi) {
						$poster =~ s/($search)/$1<\/b>/sgi;
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $curboard;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = "$messagetitle";
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						@catboard_var[$mastercount] = "$catinfo[0] / $currentboard[0]";
						$mastercount++;
					} # end poster match

				} # end filtering


			}
		}
	}

	} # end IF loop

	else {

		open(FILE, "$boardsdir/$cattosearch.txt") || &fatal_error("$txt{'23'} $cattosearch.txt");
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		open(FILE, "$boardsdir/$cattosearch.dat") || &fatal_error("$txt{'23'} $cattosearch.dat");
		&lock(FILE);
		@currentboard = <FILE>;
		&unlock(FILE);
		close(FILE);

		($threadtitle, $trash) = split (/\./,$cattosearch);

			foreach $line (@newmessagedata) { # start filtering

			($messagenumber, $messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$line);
			$poster =~ s/ //isg;
			if ($poster =~ /$search/sgi) {
				$poster =~ s/($search)/$1<\/b>/sgi;
				$snippet = substr($post, 0, 200);
				@threadtitle_var[$mastercount] = $threadtitle;
				@messagenumber_var[$mastercount] = $messagenumber;
				@messagetitle_var[$mastercount] = $messagetitle;
				@poster_var[$mastercount] = $poster;
				@date_var[$mastercount] = $date;
				@snippet_var[$mastercount] = $snippet;
				@catboard_var[$mastercount] = "$currentboard[0]";
				$mastercount++;
				} # end poster match

			} # end filtering

	  } # end ELSE loop

	} # end name search routine

# ==== "Thread Posted In" Routine =============================================

sub namepostsearch {
	local($cattosearch) = @_;

	$test = $cattosearch;
	$mastercount = "0";
	if ($cattosearch eq "all") {

	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/\n//g;
		$catinfo[1] =~ s/\r//g;
		if($catinfo[1] ne "") {
			if($settings[7] ne "Administrator" && $settings[7] ne "$catinfo[1]") {
				next;
			}
		}
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			chomp $curboard;
			($threadtitle, $trash) = split (/\./,$catinfo);
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
			open(FILE, "$boardsdir/$curboard.txt") || &fatal_error("$txt{'23'} $curboard.txt");
			&lock(FILE);
			@newmessagedata = <FILE>;
			&unlock(FILE);
			close(FILE);
			open(FILE, "$boardsdir/$curboard.dat") || &fatal_error("$txt{'23'} $curboard.dat");
			&lock(FILE);
			@currentboard = <FILE>;
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
					if ($poster =~ /$search/sgi) {
						$poster =~ s/($search)/$1<\/b>/sgi;
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $curboard;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = $messagetitle;
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						@catboard_var[$mastercount] = "$catinfo[0] / $currentboard[0]";
						$mastercount++;
					} # end poster match

				} # end post text search

			} # end filtering
			} # end if($curboard

		} # end filter for names

	} # end category loop
	} # end IF loop

else {

		open(FILE, "$boardsdir/$cattosearch.txt") || &fatal_error("$txt{'23'} $cattosearch.txt");
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

			open(FILE, "$boardsdir/$cattosearch.dat") || &fatal_error("$txt{'23'} $cattosearch.dat");
			&lock(FILE);
			@currentboard = <FILE>;
			&unlock(FILE);
			close(FILE);

				foreach $postline (@postdata) {

				($messagetitle, $poster, $posteremail, $date, $trash, $trash, $trash, $trash, $post) = split(/\|/,$postline);
				$poster =~ s/ //isg;
					if ($poster =~ /$search/sgi) {
						$poster =~ s/($search)/$1<\/b>/sgi;
						$snippet = substr($post, 0, 200);
						@threadtitle_var[$mastercount] = $threadtitle;
						@messagenumber_var[$mastercount] = $messagenumber;
						@messagetitle_var[$mastercount] = $messagetitle;
						@poster_var[$mastercount] = $poster;
						@date_var[$mastercount] = $date;
						@counter[$mastercount] = $mastercount;
						@snippet_var[$mastercount] = $snippet;
						@catboard_var[$mastercount] = "$currentboard[0]";
						$mastercount++;
					} # end poster match

				} # end post text search

			} # end filtering

	} # end ELSE loop

} # end name post search routine

# ==== Keyword Routine ========================================================

sub keywordsearch {

	local($cattosearch) = @_;
	$test = $cattosearch;
	$mastercount = "0";
	if ($cattosearch eq "all") {

	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	@keywords = split (/,/,$search);
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$catinfo[1] =~ s/\n//g;
		$catinfo[1] =~ s/\r//g;
		if($catinfo[1] ne "") {
			if($settings[7] ne "Administrator" && $settings[7] ne "$catinfo[1]") {
				next;
			}
		}
		$curcatname="$catinfo[0]";
		foreach $curboard (@catinfo) {
			chomp $curboard;
			($threadtitle, $trash) = split (/\./,$catinfo);
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
			open(FILE, "$boardsdir/$curboard.txt") || &fatal_error("$txt{'23'} $curboard.txt");
			&lock(FILE);
			@newmessagedata = <FILE>;
			&unlock(FILE);
			close(FILE);
			open(FILE, "$boardsdir/$curboard.dat") || &fatal_error("$txt{'23'} $curboard.dat");
			&lock(FILE);
			@currentboard = <FILE>;
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

					$smatch=0;
					foreach $word (@keywords) {
						if (($post =~ /$word/sgi || $messagetitle =~ /$word/sgi) && ($word ne $threadstartedbyposter) && ($word ne $poster)) {
							$smatch=1;
						} # end keyword match

					} # end @keywords foreach

					if ($smatch eq "1") {
					$snippet = substr($post, 0, 200);
					foreach $word (@keywords) {
						$snippet =~ s/($word)/$1<\/b>/sgi;
					} # end @keywords foreach

					@threadtitle_var[$mastercount] = $curboard;
					@messagenumber_var[$mastercount] = $messagenumber;
					@messagetitle_var[$mastercount] = $messagetitle;
					@poster_var[$mastercount] = $poster;
					@date_var[$mastercount] = $date;
					@counter[$mastercount] = $mastercount;
					@snippet_var[$mastercount] = $snippet;
					@foundword_var[$mastercount]= $word;
					@catboard_var[$mastercount] = "$catinfo[0] / $currentboard[0]";
					$mastercount++;

					} # end $smatch

				} # end post text search

			} # end filtering
			} # end if($curboard

		} # end filter for names

	} # end category loop
	} # end IF loop

else {

		open(FILE, "$boardsdir/$cattosearch.txt") || &fatal_error("$txt{'23'} $cattosearch.txt");
		&lock(FILE);
		@newmessagedata = <FILE>;
		&unlock(FILE);
		close(FILE);
		open(FILE, "$boardsdir/$cattosearch.dat") || &fatal_error("$txt{'23'} $cattosearch.dat");
		&lock(FILE);
		@currentboard = <FILE>;
		&unlock(FILE);
		close(FILE);

		@keywords = split (/,/,$search);

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

					$smatch=0;
					foreach $word (@keywords) {
						if (($post =~ /$word/sgi || $messagetitle =~ /$word/sgi) && ($word ne $threadstartedbyposter) && ($word ne $poster)) {
							$smatch=1;
						} # end keyword match

					} # end @keywords foreach

					if ($smatch eq "1") {
					$snippet = substr($post, 0, 200);
					foreach $word (@keywords) {
						$snippet =~ s/($word)/$1<\/b>/sgi;
					} # end @keywords foreach

					@threadtitle_var[$mastercount] = $curboard;
					@messagenumber_var[$mastercount] = $messagenumber;
					@messagetitle_var[$mastercount] = $messagetitle;
					@poster_var[$mastercount] = $poster;
					@date_var[$mastercount] = $date;
					@counter[$mastercount] = $mastercount;
					@snippet_var[$mastercount] = $snippet;
					@foundword_var[$mastercount]= $word;
					@catboard_var[$mastercount] = "$currentboard[0]";
					$mastercount++;

					} # end $smatch

				} # end post text search

			} # end filtering

		} # end ELSE loop

} # End keywordsearch

1;