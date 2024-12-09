###############################################################################
# ManageBoards.pl                                                             #
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

$manageboardsplver="1 Gold Beta4";

sub ManageBoards {
	open(FILE, "$vardir/cat.txt");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'41'}";
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" width=10><font size=2>&nbsp;</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}"><font class="text1" color="$color{'titletext'}" size=1>$txt{'20'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" nowrap><font class="text1" color="$color{'titletext'}" size=1>$txt{'12'}</font></td>
	<td class="title1" bgcolor="$color{'titlebg'}" nowrap><font class="text1" color="$color{'titletext'}" size=1>$txt{'42'}</font></td>
</tr>
EOT
	foreach $curcat (@categories) {
		$curcat =~ s/[\n\r]//g;
		open(CAT, "$boardsdir/$curcat.cat");
		&lock(CAT);
		@catinfo = <CAT>;
		&unlock(CAT);
		close(CAT);
		$curcatname="$catinfo[0]";
		print <<"EOT";
<tr>
	<td colspan=4 bgcolor="#c0c0c0"><font size=2><a href="$cgi&action=reorderboards&cat=$curcat">$curcatname</a></font></td>
</tr>
EOT
		foreach $curboard (@catinfo) {
			if($curboard ne "$catinfo[0]" && $curboard ne "$catinfo[1]") {
				$curboard =~ s/[\n\r]//g;
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
				$boardinfo[2] =~ s/[\n\r]//g;

				$boardinfo[2] =~ /^\|(.*?)\|$/;
				$multimoderators = $1 or $multimoderators = $boardinfo[2];
				$multimoderators =~ s/\|/,/g;

				$moderator = "$modprop[1]";
				print <<"EOT";
<tr>
	<td bgcolor="#e0e0e0" width=10 valign=top><img src="$imagesdir/board.gif" alt="" border="0"></td>
	<td bgcolor="#e0e0e0" width=* valign=top><font size=2>
	<form action="$cgi&action=modifyboard" method="POST">
	<input type=hidden name="id" value="$curboard">
	<input type=hidden name="cat" value="$curcat">
	<input type=text name="boardname" value="$curboardname" size=30><br>
	<textarea name=descr cols=50 rows=3>$descr</textarea></font></td>
	<td bgcolor="#e0e0e0" valign=top width=20%><input type=text name=moderator value="$multimoderators" size=25></td>
	<td bgcolor="#e0e0e0" valign=top width=20%><input type=submit name="moda" value="$txt{'17'}">
	<input type=submit name="moda" value="$txt{'31'}"></form></td>
</tr>
EOT
			}
		}
		print <<"EOT";
<tr>
	<td bgcolor="#e0e0e0" width=10 valign=top><img src="$imagesdir/board.gif" alt="" border="0"></td>
	<td bgcolor="#e0e0e0" width=* valign=top><font size=2>
	<form action="$cgi&action=addboard" method="POST">
	$txt{'43'}: <input type=text name="id" value="" size=15>
	$txt{'44'}: <input type=text name="boardname" size=30><br>
	<textarea name=descr cols=50 rows=3></textarea></font></td>
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
	&is_admin;
	open(FILE, "$boardsdir/$INFO{'cat'}.cat");
	&lock(FILE);
	@allboards = <FILE>;
	&unlock(FILE);
	close(FILE);
	$yytitle = "$txt{'46'}";
	$boardlist="";
	foreach $cboard (@allboards) {
		$cboard =~ s/[\n\r]//g;
		if($cboard ne "$allboards[0]" && $cboard ne "$allboards[1]") { $boardlist="$boardlist\n$cboard"; }
	}
	&header;
	print <<"EOT";
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}"><font size=2 class="text1" color="$color{'titletext'}">$txt{'46'}</font></td>
</tr>
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}" width=140 valign=top><font size=2>
<form action="$cgi&action=reorderboards2" method="POST">
$txt{'47'}:<br>
<textarea name="boards" cols="40" rows="4">$boardlist</textarea><br>
<input type=hidden name="firstline" value="$allboards[0]">
<input type=hidden name="secondline" value="$allboards[1]">
<input type=hidden name="cat" value="$INFO{'cat'}">
<input type=submit value="$txt{'46'}">
</form>
	</font></td>
</tr>
</table>
EOT
	&footer;
	exit;
}

sub ReorderBoards2 {
	&is_admin;
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
	&is_admin;
	if($FORM{'moda'} eq "$txt{'17'}") {
		open(FILE, ">$boardsdir/$FORM{'id'}.dat");
		&lock(FILE);

		$FORM{'descr'} =~ s/\n/ /g;
		$FORM{'descr'} =~ s/\r//g;
		$FORM{'moderator'} =~ s/\s*,\s*/|/g;
		print FILE "$FORM{'boardname'}\n";
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
		$yytitle = "$txt{'48'}";
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
	&is_admin;
	$id="$FORM{'id'}";
	open(FILE, "$boardsdir/$FORM{'cat'}.cat");
	&lock(FILE);
	@categories = <FILE>;
	&unlock(FILE);
	close(FILE);
	open(FILE, ">$boardsdir/$FORM{'cat'}.cat");
	&lock(FILE);
	foreach $curboard (@categories) {
		$curboard =~ s/[\n\r]//g;
		print FILE "$curboard\n";
	}
	print FILE "$id";
	&unlock(FILE);
	close(FILE);

	open(FILE, ">$boardsdir/$id.dat");
	&lock(FILE);

	$FORM{'descr'} =~ s/\n/ /g;
	$FORM{'descr'} =~ s/\r//g;
	$FORM{'moderator'} =~ s/\s*,\s*/|/g;
	print FILE "$FORM{'boardname'}\n";
	print FILE "$FORM{'descr'}\n";
	print FILE "$FORM{'moderator'}|\n";

	&unlock(FILE);
	close(FILE);
	open(FILE, ">$boardsdir/$id.txt");
	&lock(FILE);
	print FILE "";
	&unlock(FILE);
	close(FILE);

	print "Location: $cgi\&action=manageboards\n\n";
	exit;
}


1;