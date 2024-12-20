###############################################################################
# Search.pl                                                                   #
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

$thisprogram = "YaBB.pl?action=dosearch";

sub SearchForm {

    $dirtoopen = "$boardsdir";
    opendir (DIRECTORY,"$dirtoopen");
    @dirdata = readdir(DIRECTORY);
    closedir (DIRECTORY);

    @datdata = grep(/dat/,@dirdata);
    $totalboards = @sorteddirdata;

	$filetoopen = "$vardir/cat.txt";
	open(FILE, "$filetoopen");
	&lock(FILE);
	@masterdata = <FILE>;
	&unlock(FILE);
	close(FILE);

	foreach $category (@masterdata) { # start to open files
		chomp $category;
		open(FILE, "$boardsdir/$category.cat");
		&lock(FILE);
		@data = <FILE>;
		&unlock(FILE);
		close(FILE);
		$data[1] =~ s/\n//g;
		if($data[1] ne "") { #begin defining private forums
			if($settings[7] ne "Administrator" && $settings[7] ne "$data[1]") {
				next;
			} # end nested if
		} # end @datainfo if


		foreach $line (@data) {
		if($line ne "$data[0]" && $line ne "$data[1]") {
			chomp $line;
			open(FILE, "$boardsdir/$line.dat") || next;
			&lock(FILE);
			@newcatdata = <FILE>;
			&unlock(FILE);
			close(FILE);

			$selecthtml .= "<option value=\"$line\">$newcatdata[0]\n";

		} # end main if (private boards)

		} # end second foreach

	} # end the main foreach

if ($numberreturned eq "") { $tempnumbox = "25"; }


$yytitle = "$txt{'183'}";
&header;

print qq~

<table width=100%>
<tr>
	<td><p><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;<A href="$boardurl/YaBB.pl">$mbname</A><br><IMG SRC="$imagesdir/tline.gif" BORDER=0><IMG SRC="$imagesdir/open.gif" BORDER=0>&nbsp;&nbsp;$txt{'182'}</p></td>
</tr>
</table>

<table border=0 width=100% cellspacing=1 cellpadding=4 bgcolor="$color{'bordercolor'}">
<tr>
  <td class="title1" bgcolor="$color{'titlebg'}"><p>$txt{'183'}</p></td>
</tr><tr><td bgcolor="$color{'windowbg'}">
<form action="$thisprogram" method="post">
<input type=text size=40 name=search><br>
<select name="dropdown">
<option value="startuser" selected>$txt{'186'}</option>
<option value="startpost">$txt{'187'}</option>
<option value="startwords">$txt{'600'}</option>
</select><br>
<br>
<p>
$txt{'189'}:<br></p>
<select name="catsearch"><option value="all">$txt{'190'} $selecthtml</select><br>
<br>
<p>
$txt{'191'}<br></p>
<input type=text size=5 name=numberreturned value=$tempnumbox><br>
<br>
<input type=hidden name=action value=dosearch>
<input type="submit" name="submit" value="$txt{'182'}"><br>
</form>
</td></tr>
</table>
~;

&footer;
exit;

}

1;