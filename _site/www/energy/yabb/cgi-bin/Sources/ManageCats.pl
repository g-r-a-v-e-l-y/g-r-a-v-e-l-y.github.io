###############################################################################
# ManageCats.pl                                                               #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub ManageCats {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'52'}";
	$catsdropdown="";
	$catlist="";
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		$catsdropdown="$catsdropdown<option>$curcat";
		$catlist="$catlist\n$curcat";
	}
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'52'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}" width=140 valign=top>
<form action="$cgi&action=modifycatorder" method="POST">
<b>$txt{'53'}:</b><br>
<textarea name="cats" cols="40" rows="4">$catlist</textarea><br>
<input type=submit value="$txt{'54'}">
</form>
<form action="$cgi&action=removecat" method="POST">
<b>$txt{'55'}:</b><select name="cat">$catsdropdown</select><input type=submit value="$txt{'31'}">
</form>
<form action="$cgi&action=createcat" method="POST">
<b>$txt{'56'}:</b><br>
$txt{'43'}: <input type=text size=15 name="catid"><br>
$txt{'44'}: <input type=text size=40 name="catname"><br>
$txt{'57'}: <input type=text size=40 name="memgroup"> ($txt{'58'})<br>
<input type=submit value="$txt{'59'}">
</form>
	</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ReorderCats {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
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
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$catid="$FORM{'catid'}";
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$vardir/cat.txt");
	&lock(FILE);
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
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
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'60'}";
	$newcatlist="";
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
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
		$curboard =~ s/\n//g;
		$curboard =~ s/\r//g;
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