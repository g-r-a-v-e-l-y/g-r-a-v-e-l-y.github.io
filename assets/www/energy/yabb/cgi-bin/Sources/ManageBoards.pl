###############################################################################
# ManageBoards.pl                                                             #
###############################################################################
# Yet another Bulletin Board version 1.0                                      #
# Written by Zef Hemel of Significon, 2000                                    #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

sub ManageBoards {
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'41'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}" width=10>&nbsp;</td>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}" size=1><b>$txt{'20'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" nowrap><font color="$color{'titletext'}" size=1><b>$txt{'12'}</b></font></td>
	<td bgcolor="$color{'titlebg'}" nowrap><font color="$color{'titletext'}" size=1><b>$txt{'42'}</b></font></td>
</tr>
EOT
	foreach $curcat (@categories) {
		$curcat =~ s/\n//g;
		$curcat =~ s/\r//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$curcatname="$catinfo[0]";
		print <<"EOT";
<tr>
	<td bgcolor="#c0c0c0" width=10 valign=top><img src="$imagesdir/cat.gif" width=18 height=18 alt="" border="0"></td>
	<td colspan=3 bgcolor="#c0c0c0"><a href="$cgi&action=reorderboards&cat=$curcat"><b>$curcatname</b></a></td>
</tr>
EOT
		foreach $curboard (@catinfo) {
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/\n//g;
				$curboard =~ s/\r//g;
				open(BOARD, "$boardsdir/$curboard.dat");
				&lock(BOARD);
				@boardinfo = <BOARD>;
				&unlock(BOARD);
				close(BOARD);
				$curboardname="$boardinfo[0]";
				$descr="$boardinfo[1]";
				open(BOARDDATA, "$boardsdir/$curboard.txt");
				&lock(BOARDDATA);
				@messages = <BOARDDATA>;
				&unlock(BOARDDATA);
				close(BOARDDATA);
				($dummy, $dummy, $dummy, $dummy, $dummy, $lp) = split(/\|/, $messages[0]);
				$boardinfo[2] =~ s/\n//g;
				$boardinfo[2] =~ s/\r//g;
				$moderator = "$modprop[1]";
				print <<"EOT";
<tr>
	<td bgcolor="#e0e0e0" width=10 valign=top><img src="$imagesdir/board.gif" width=16 height=16 alt="" border="0"></td>
	<td bgcolor="#e0e0e0" width=* valign=top>
	<form action="$cgi&action=modifyboard" method="POST">
	<input type=hidden name="id" value="$curboard">
	<input type=hidden name="cat" value="$curcat">
	<input type=text name="boardname" value="$curboardname" size=30><br>
	<textarea name=descr cols=50 rows=3>$descr</textarea></td>
	<td bgcolor="#e0e0e0" valign=top width=20%><input type=text name=moderator value="$boardinfo[2]" size=15></td>
	<td bgcolor="#e0e0e0" valign=top width=20%><input type=submit name="moda" value="$txt{'17'}">
	<input type=submit name="moda" value="$txt{'31'}"></form></td>
</tr>
EOT
			}
		}
		print <<"EOT";
<tr>
	<td bgcolor="#e0e0e0" width=10 valign=top><img src="$imagesdir/board.gif" width=16 height=16 alt="" border="0"></td>
	<td bgcolor="#e0e0e0" width=* valign=top>
	<form action="$cgi&action=addboard" method="POST">
	<b>$txt{'43'}: </b><input type=text name="id" value="" size=15>
	<b>$txt{'44'}: </b><input type=text name="boardname" size=30><br>
	<textarea name=descr cols=50 rows=3></textarea></td>
	<td bgcolor="#e0e0e0" valign=top width=20%><input type=text name=moderator value="" size=15>
	<input type=hidden name="cat" value="$curcat"></td>
	<td bgcolor="#e0e0e0" valign=top width=20%><input type=submit value="$txt{'45'}"></form></td>
</tr>
EOT
	}
	print "</table>";
	&footer;
	exit;
}

sub ReorderBoards {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	open(FILE, "$boardsdir/$INFO{'cat'}.cat");
	&lock(FILE);
	@allboards = <FILE>;
	&unlock(FILE);
	close(FILE);
	$title = "$txt{'46'}";
	$boardlist="";
	foreach $cboard (@allboards) {
		$cboard =~ s/\n//g;
		$cboard =~ s/\r//g;
		if($cboard ne "$allboards[0]" && $cboard ne "$allboards[1]") { $boardlist="$boardlist\n$cboard"; }
	}
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'46'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}" width=140 valign=top>
<form action="$cgi&action=reorderboards2" method="POST">
<b>$txt{'47'}:</b><br>
<textarea name="boards" cols="40" rows="4">$boardlist</textarea><br>
<input type=hidden name="firstline" value="$allboards[0]">
<input type=hidden name="secondline" value="$allboards[1]">
<input type=hidden name="cat" value="$INFO{'cat'}">
<input type=submit value="$txt{'46'}">
</form>
	</td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ReorderBoards2 {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$FORM{'boards'} =~ s/\r//g;
	$FORM{'firstline'} =~ s/\n//g;
	$FORM{'secondline'} =~ s/\n//g;
	open(FILE, ">$boardsdir/$FORM{'cat'}.cat");
	&lock(FILE);
	print FILE "$FORM{'firstline'}\n";
	print FILE "$FORM{'secondline'}\n";
	print FILE "$FORM{'boards'}";
	&unlock(FILE);
	close(FILE);
	print "Location: $cgi\&action=reorderboards\&cat=$FORM{'cat'}\n\n";
	exit;
}

sub ModifyBoard {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	if($FORM{'moda'} eq "$txt{'17'}") {
		open(FILE, ">$boardsdir/$FORM{'id'}.dat");
		&lock(FILE);
		print FILE "$FORM{'boardname'}\n";
		$FORM{'descr'} =~ s/\n/ /g;
		$FORM{'descr'} =~ s/\r//g;
		print FILE "$FORM{'descr'}\n";
		print FILE "$FORM{'moderator'}\n";
		&unlock(FILE);
		close(FILE);
		print "Location: $cgi\&action=manageboards\n\n";
	} else {
		open(FILE, "$boardsdir/$FORM{'cat'}.cat");
		&lock(FILE);
		@categories = <FILE>;
		&unlock(FILE);
		close(FILE);
		$title = "$txt{'48'}";
		$newcatlist="";
		foreach $curboard (@categories) {
			$curboard =~ s/\n//g;
			if($curboard ne "$FORM{'id'}") { $newcatlist="$newcatlist$curboard\n"; }
		}
		open(FILE, ">$boardsdir/$FORM{'cat'}.cat");
		&lock(FILE);
		print FILE "$newcatlist";
		&unlock(FILE);
		close(FILE);
		&header;
	
		$curboard="$FORM{'id'}";
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
		unlink("$boardsdir/$curboard.dat");
		unlink("$boardsdir/$curboard.txt");
		print "$txt{'50'}<br>";
		print "$txt{'51'}";
		&footer;
	}
	exit;
}

sub CreateBoard {
	if($settings[7] ne "Administrator") { &fatal_error("$txt{'1'}"); }
	$id="$FORM{'id'}";
	open(FILE, "$boardsdir/$FORM{'cat'}.cat");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$boardsdir/$FORM{'cat'}.cat");
	&lock(FILE);
	foreach $curboard (@categories) {
		$curboard =~ s/\n//g;
		$curboard =~ s/\r//g;
		print FILE "$curboard\n";
	}
	print FILE "$id";
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$boardsdir/$id.dat");
	print FILE "$FORM{'boardname'}\n";
	$FORM{'descr'} =~ s/\n/ /g;
	$FORM{'descr'} =~ s/\r//g;
	print FILE "$FORM{'descr'}\n";
	print FILE "$FORM{'moderator'}\n";
	close(FILE);
	open(FILE, ">$boardsdir/$id.txt");
	print FILE "";
	close(FILE);
	print "Location: $cgi\&action=manageboards\n\n";
	exit;
}


1;