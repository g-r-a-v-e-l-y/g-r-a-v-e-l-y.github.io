###############################################################################
# ManageCats.pl                                                               #
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

$managecatsplver="1 Gold Beta4";

sub ManageCats {
	&is_admin;
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'52'}";
	$catsdropdown="";
	$catlist="";
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		$catsdropdown="$catsdropdown<option>$curcat";
		$catlist="$catlist\n$curcat";
	}
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><p>$txt{'52'}</p></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" width=140 valign=top><p>
<form action="$cgi&action=modifycatorder" method="POST">
$txt{'53'}:<br>
<textarea name="cats" cols="40" rows="4">$catlist</textarea><br>
<input type=submit value="$txt{'54'}">
</form>
<form action="$cgi&action=removecat" method="POST">
$txt{'55'}:<select name="cat">$catsdropdown</select><input type=submit value="$txt{'31'}">
</form>
<form action="$cgi&action=createcat" method="POST">
$txt{'56'}:<br>
$txt{'43'}: <input type=text size=15 name="catid"><br>
$txt{'44'}: <input type=text size=40 name="catname"><br>
$txt{'57'}: <input type=text size=40 name="memgroup"> ($txt{'58'})<br>
<input type=submit value="$txt{'59'}">
</form>
	</p></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ReorderCats {
	&is_admin;
	$FORM{'cats'} =~ s/\r//g;
	open(FILE, ">$vardir/cat.txt");
	&lock(FILE);
	print FILE "$FORM{'cats'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=managecats\n\n";
	exit;
}

sub CreateCat {
	&is_admin;
	$catid="$FORM{'catid'}";
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$vardir/cat.txt");
	&lock(FILE);
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		print FILE "$curcat\n";
	}
	print FILE "$catid";
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$boardsdir/$catid.cat");
	print FILE "$FORM{'catname'}\n";
	print FILE "$FORM{'memgroup'}\n";
	close(FILE);
	print "Location: $cgi\&action=managecats\n\n";
	exit;
}

sub RemoveCat {
	&is_admin;
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'60'}";
	$newcatlist="";
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		if($curcat ne "$FORM{'cat'}") { $newcatlist="$newcatlist$curcat\n"; }
	}
	open(FILE, ">$vardir/cat.txt");
	&lock(FILE);
	print FILE "$newcatlist";
	&unlock(FILE);
	close(FILE);
	&header;
	$curcat="$FORM{'cat'}";

	open(CAT, "$boardsdir/$curcat.cat");
	&lock(CAT);
	@catinfo = <CAT>;
	&unlock(CAT);
	close(CAT);
	$curcatname="$catinfo[0]";
	foreach $curboard (@catinfo) {
		$curboard =~ s/[\n\r]//g;
		if($curboard ne "$catinfo[0]") {
			open(BOARDDATA, "$boardsdir/$curboard.txt");
			&lock(BOARDDATA);
			@messages = <BOARDDATA>;
			&unlock(BOARDDATA);
			close(BOARDDATA);
			foreach $curmessage (@messages) {
				($id, $dummy) = split(/\|/, $curmessage);
				unlink("$datadir/$id\.txt");
				unlink("$datadir/$id\.mail");
				print "$txt{'49'} $id<br>";
			}
		}
		unlink("$boardsdir/$curboard.txt");
		unlink("$baordsdir/$curboard.mail");
		unlink("$boardsdir/$curboard.dat");
		print "$txt{'50'}<br>";
	}
	unlink("$boardsdir/$curcat.cat");
	print "$txt{'61'}<br>";
	print "$txt{'51'}";
	&footer;
	exit;
}

1;