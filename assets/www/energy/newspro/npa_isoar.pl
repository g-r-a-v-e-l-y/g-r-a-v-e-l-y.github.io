# by plushpuffin@hotmail.com
# http://plushpuffin.virtualave.net
# ISoar Addon v3.0
push(@Addons_Loaded, 'ISoar 3.0');
push(@Addons_PageHandler, 'ISoarPageHandler');
push(@Addons_MainPage, 'ISoar_MainPage');
push(@Addons_NPHTMLFoot, 'ISoar_HTMLFoot');
push(@Addons_LoadHelp, 'ISoar_LoadHelp');
$Addons_List{'ISoar 3.0'} = ['npa_isoar.pl', "Change newspro's colors so you don't feel like you're tripping. NOW WITH JAVASCRIPT!"];

sub ISoar_LoadHelp {
	if( $Help{'isoar'} ) { return; }
	$Help{'isoar'} = qq~
	ISoar lists all the hexadecimal color values it found in newspro.cgi<br><br>
	DO NOT make these values "black" or "blue" or whatever. ALWAYS USE HEXADECIMAL<br>
	DO NOT use a # in the field.<br>
	You can see some nice colors at: <a href="http://www.users.interport.net/%7Egiant/COLOR/1ColorSpecifier.html">HYPE's Color Specifier</a><br>
	Again, don't use the NAMES of the colors, only the HEXADECIMAL values:<br><br>
	eg:<br>
	Snow 255 250 250 #FFFAFA<br>
	use the FFFAFA part, not the name!<br><br><br><br>
	a good hint: if you want to make items in ISoar the SAME color, you should try to distinguish them so that you can make them both different colors later on. Do this by using a combination of uppercase and lowercase letters.<br><br>
	eg:<br>
	FFFAFA CCCCCC<br>
	change to: FFAAAA fFAAAA<br><br>
	a single letter difference in capitalization is all it takes!<br><br>
	If the color you're choosing is all digits, such as 000000, simply make the color the next one up: 000001<br>
	The difference isn't really noticeable.<br><br>
	<HR width="75%"><br><br>
	Version 2.0 of ISoar has a few new features.<br><br>
	For Internet Explorer users, the colors of the preview boxes change right away when you edit the text fields!<br>
	Netscape users can click the PREVIEW button to see the changes, since this doesn't work in Netscape.<br><br>
	There is now a DEMO button, too..so you can see what your main page will look like with the new colors...just click DEMO to see it, and click the back button on your browser when you're done.<br><br>
	After using the DEMO button and returning to the ISoar page, you must sometimes click on the PREVIEW button, since the page kind of &quot;forgets&quot; which colors go where...<br><br>
	On a side note, there is now a RESET button which resets all the text boxes to their default values.<br><br>
	<HR width="75%"><br>
	<br><br><br>ISoar, by <a href="mailto:plushpuffin\@hotmail.com">plushpuffin</a><br>
	<a href="http://plushpuffin.virtualave.net">plushpuffin's addon zoo</a><br><br><br><HR width="75%"><br>
	<br><br><br>javascripting by <a href="mailto:gogetassj4\@dragonworld.com.ar">GogetaSSJ4</a><br>
	<a href="http://www.dragonworld.com.ar">GogetaSSJ4's site: www.dragonworld.com.ar</a>
	~;
}

sub ISoarPageHandler {
	if (query_string() eq "isoar") {
		&ISoarMain;
		exit;
	}
	elsif( query_string() eq "help/isoar" ) {
		&ISoarHelp;
		exit;
	}
}

sub ISoarHelp {
	&NPHTMLHead("ISoar Help");
	&ISoar_LoadHelp;
	print $Help{'isoar'};
	&NPHTMLFoot;
}

sub ISoar_HTMLFoot {
	if ($up == 3) {
		print qq~ <a href="$scripturl?isoar" class="navlink">ISoar</a> |~;
	}
}

sub ISoar_MainPage {
	if ($up == 3) {
		print qq~
		<b><a href="$scripturl?isoar">ISoar</a>:</b> Rewrite NewsPro's interface to prevent your eyes from bugging out. NOW WITH JAVASCRIPT!<br><br>
		~;
	}
}

sub ISoar_Load {
	my ($results, $npfile) = @_;
	my @cursor;
	my $icolor;
	NPopen('NPF', $npfile);
	while( <NPF> ) {
		if( $_ eq "\n" ) { next; }
		@cursor = $_ =~ m~#([\w]{6})\W~g;
		if( @cursor ) {
			foreach $icolor (@cursor) {
				unless( $$results{$icolor} ) {
					$$results{$icolor} = 1;
				}
			}
		}
	}
	close( NPF );
}

sub ISoar_LoadAll {
	my ($results, $npfile) = @_;
	my @cursor;
	my $icolor;
	NPopen('NPF', $npfile);
	while( <NPF> ) {
		if( $_ eq "\n" ) { next; }
		@cursor = $_ =~ m~#([\w]{6})\W~g;
		if( @cursor ) {
			foreach $icolor (@cursor) {
				push( @$results, $icolor );
			}
		}
	}
	close( NPF );
}

sub ISoarDoReplace {
	my ($chfile,$modfile,$oldfile) = @_;
	my $errorcheck = 0;
	my ( $key, $value, %colors, @cursor, $errormsg );
	while( ($key, $value) = each(%in) ) {
		if( $key =~ m~isoarv(.*)~ ) {
			if( $1 ne $value ) { $colors{"$1"} = $value; }
			unless( $value =~ m~[\d|a-f|A-F]{6}~ ) { $errorcheck = 1; $errormsg .= qq~Invalid character in color value: "$value"<br><br>~; }
		}
	}
	if( $errorcheck ) { NPdie( qq~<br><br><font size="+2" style="font-size: 1.5em">$errormsg<br><br>
		You may only use the digits '0' through '9' and <br>the letters 'A' through 'F' or 'a' through 'f'<br><br>
Valid characters include : 0123456789abcdefABCDEF</font><br><br><br><hr>~ ); }
	&NPopen('NPF', "$chfile");
	&NPopen('NPFNew', ">$modfile");

	while( <NPF> ) {
		if( $_ eq "\n" ) { print $_; next; }
		@cursor = $_ =~ m~#([\w]{6})\W~g;
		if( @cursor ) {
			foreach $icolor (@cursor) {
				if( $colors{$icolor} ) {
					$_ =~ s~$icolor~$colors{$icolor}~g;
				}
			}
		}
		print NPFNew $_;
	}
	close( NPF );
	close( NPFNew );
	if( -e $oldfile ) {
		unlink( $oldfile );
	}
	chmod 0755, $modfile;
	rename($chfile, $oldfile);
	rename($modfile, $chfile);

}

sub ISoarDeathRays {
	my $scriptname = $ENV{'SCRIPT_NAME'};
	$scriptname =~ s~.*/(.*)~$1~;
	$scriptname ||= q~newspro.cgi~;
	my $chfile = $scriptname;
	my $modfile = "n$chfile";
	my $oldfile = "o$chfile";
	&ISoarDoReplace( $chfile, $modfile, $oldfile );
	&NPHTMLHead("ISoar");
		print qq~<br>$chfile was renamed $oldfile, and the modified $modfile was renamed to take its place.<br>
	The changes will appear the next time you refresh the page.<br>
	If the server no longer works, you may have to reset permissions on the new file $chfile.<br>
	This addon has already attempted to reset the permissions to 0755, so you might not have to bother...~;
	&NPHTMLFoot;
	exit;
}

sub ISoarDemoColors {
	my $errorcheck = 0;
	my ( $key, $value, %colors, @colors, $icolor, $errormsg );
	while( ($key, $value) = each(%in) ) {
		if( $key =~ m~isoarv(.*)~ ) {
			if( $1 ne $value ) { $colors{"$1"} = $value; }
			unless( $value =~ m~[\d|a-f|A-F]{6}~ ) { $errorcheck = 1; $errormsg .= qq~Invalid character in color value: "$value"<br><br>~; }
		}
	}
	if( $errorcheck ) { NPdie( qq~<br><br><font size="+2" style="font-size: 1.5em">$errormsg<br><br>
		You may only use the digits '0' through '9' and <br>the letters 'A' through 'F' or 'a' through 'f'<br><br>
Valid characters include : 0123456789abcdefABCDEF</font><br><br><br><hr>~ ); }
	my @colors = keys %colors;
	my $fbf = '';
	tie *$fbf, 'Tie::FHRS', \$fbf;
	my $innertube = select $fbf;
	&MainPage;
	select $innertube;
	untie $fbf;
	$fbf =~ s~<a\s~<a onClick="return false;" ~gio;
	$fbf =~ s~<form\s~<form onSubmit="return false;" ~gio;
	foreach $icolor (@colors) {
		if( $colors{$icolor} ) {
			$fbf =~ s~$icolor~$colors{$icolor}~g;
		}
	}
	print $fbf;
	exit;
}

sub ISoarConvert {
	my $depth = $in{'isoarconvertw'} || 0;
	$depth++;
	&NPHTMLHead(qq~ISoar Conversion Wizard : step $depth~);
	print qq~<div align="center"><form name="convw" action="$scripturl?isoar" method="POST">~;
	if( $depth == 1 ) {
		print qq~<h3>Welcome to ISoar's newspro conversion wizard</h3><BR>
This will help you migrate to a new version of newspro.cgi while still maintaining your color settings.<BR><BR>
Here is what you should do:<BR>
<div align="left"><ul><ul><ul><ul>
<li>Rename your old, customized newspro file to o_newspro.cgi or whatever you want.</li>
<li>Install the new, ugly newspro file. You should not rename this new file.<BR>
Some servers, however, require that CGI programs be named newspro.pl - So go ahead and use that.</li>
<li>Run the ISoar Conversion wizard from the ugly newspro.</li>
</ul></ul></ul></ul></div><BR><HR>
Do not proceed until you have accomplished this.<BR><BR>
<HR size="5"><BR>
<b>Please note:</b> if you combined two colors into one in your custom newspro.cgi then this wizard might screw up.<BR>
<b>We apologize for the inconvenience.</b><BR><BR>
<input type="submit" name="isnextstep" value="Continue">
~;
	}
	elsif( $depth == 2 ) {
		print qq~<h3>Choose the old file with the customized colors</h3><BR>
Please specify the relative location of your OLD newspro.cgi installation, with the custom colors.<BR>
If you used a name other than the one ISoar recommended, fill it in here.<BR>
<input type="text" name="oldnploc" value="o_newspro.cgi"><BR><BR>
<input type="submit" name="isnextstep" value="Continue">
~;
	}
	elsif( $depth == 3 ) {
		my $scriptname = $ENV{'SCRIPT_NAME'};
		$scriptname =~ s~.*/(.*)~$1~;
		$scriptname ||= q~newspro.cgi~;
		print qq~<h3>Choose the new file with the default colors</h3><BR>
Please specify the relative location of your NEW newspro.cgi installation. (the one with the ugly default colors)<BR>
ISoar has attempted to fill this in for you, but may not have been entirely successful.<BR>
(this should be the name of the newspro script that you are running right now)<BR>
<input type="hidden" name="oldnploc" value="$in{'oldnploc'}">
<input type="text" name="newnploc" value="$scriptname"><BR><BR>
<input type="submit" name="isnextstep" value="Continue">
~;
	}
	elsif( $depth == 4 ) {
		my (@badcolors, @goodcolors,$custompro,$updatepro,$i,$icolor,$changecolor,$counter,%colors);
		$updatepro = $in{'newnploc'};
		$custompro = $in{'oldnploc'};
		print qq~
<h3>ISoar is now attempting to pass your custom colors to the new newspro.cgi file</h3><BR>
old newspro: $in{'oldnploc'}<BR>
new newspro: $in{'newnploc'}<BR><HR size="5"><BR>
~;
		&ISoar_LoadAll( \@badcolors, $updatepro );
		&ISoar_LoadAll( \@goodcolors, $custompro );
		for( $i = 0; $i < @badcolors; $i++ ) {
			unless( $#goodcolors >= $i ) { last; }
			$colors{$badcolors[$i]} = $goodcolors[$i];
		}
		print qq~<table width="100%"><tr>~;
		$counter = 1;
		while( $icolor = each(%colors) ) {
			$changecolor = $colors{$icolor};
				print qq~
			<td width="64">#$icolor</td><td bgcolor="#$icolor">&nbsp&nbsp&nbsp</td>
			<td bgcolor="#$changecolor" id="IS$icolor">&nbsp&nbsp&nbsp</td>
			<td>
			<input type="text" name="isoarv$icolor" value="$changecolor" size="8" maxlength="6"
				onChange="document.all.IS$icolor.bgColor=(isoarv$icolor.value)">
			</td>
			~;
			$counter++;
			if( $counter % 2 ) { print "</tr><tr>"; }
		}
		print qq~</table><br><br>
<input type="submit" name="isoarpreview" value="PREVIEW"><br>
Netscape users must click here to PREVIEW colors<br><br><br>
<input type="submit" name="isoardemo" value="DEMO"><br>
ALL BROWSERS - Click here for a DEMO...then click your browser's back button to return to ISoar<br><br><br><br>
<input type="submit" name="isoarsubmit" value="Save Changes">
<input type="submit" name="isoarreset" value="Reset All"><BR><BR>
~;
		print qq~<BR><HR size="5"><h3>Colors from your old newspro.cgi have been loaded into the form. You may
now work with them as you would normally. Have a <u><b><i>nice</i></b></u> day</h3>~;
	}
	else {
		print qq~Holy Crap. How did you get to this page? Out! Out, damn spot!~;
	}
	if( $depth != 4 ) {
		print qq~<input type="hidden" name="isoarconvertw" value="$depth">~;
	}
	print qq~</form></div>~;
	&NPHTMLFoot;
	exit;
}

sub ISoarMain {
	unless ($UserPermissions{$Cookies{'uname'}} == 3) {
		&NPdie('You are not authorized to access this');
	}
	my $ispreview = 0;
	if( $in{'isoarpreview'} ) {
		$ispreview = 1;
	}
	if( $in{'isoarsubmit'} ) {
		&ISoarDeathRays;
	}
	if( $in{'isoardemo'} ) {
		&ISoarDemoColors;
	}
	if( $in{'isoarconvert1'} || $in{'isoarconvertw'} ) {
		&ISoarConvert;
	}
	my %colors;
	my $scriptname = $ENV{'SCRIPT_NAME'};
	$scriptname =~ s~.*/(.*)~$1~;
	$scriptname ||= q~newspro.cgi~;
	&ISoar_Load( \%colors, $scriptname );
	&NPHTMLHead("ISoar");

	print qq~<div style="color: #aabbaa; background: #234567">
	<table width="100%"><tr><td align="left">
	written by <a href="mailto:plushpuffin\@hotmail.com">plushpuffin</a><br>
	<a href="http://plushpuffin.virtualave.net" target="window1">plushpuffin's addon zoo</a></td>
	<td align="right">
	javascripting by <a href="mailto:gogetassj4\@dragonworld.com.ar">GogetaSSJ4</a><br>
	<a href="http://www.dragonworld.com.ar" target="window2">Dragon World</a></td></tr></table><br><br><br>
	<form name="colorsel" action="$scripturl?isoar" method="POST">
	~;

	print qq~
	<div align="center"><h3>NewsPro ISoar Colors</h3><br>
	by plushpuffin<br><br><a href="$scripturl?help/isoar" target="window">Help on ISoar</a><br><br><br>
	<table width="100%"><tr>
	~;

	my $counter = 1;
	my ( $icolor, $key, $value, $changecolor );
	while( $icolor = each(%colors) ) {
		$changecolor = $icolor;
		if( $ispreview ) { $changecolor = $in{"isoarv$icolor"}; }
		print qq~
		<td width="64">#$icolor</td><td bgcolor="#$icolor">&nbsp&nbsp&nbsp</td>
		<td bgcolor="#$changecolor" id="IS$icolor">&nbsp&nbsp&nbsp</td>
		<td>
		<input type="text" name="isoarv$icolor" value="$changecolor" size="8" maxlength="6"
			onChange="document.all.IS$icolor.bgColor=(isoarv$icolor.value)">
		</td>
		~;
		$counter++;
		if( $counter % 2 ) { print "</tr><tr>"; }
	}
	print qq~</table><br><br>
	<input type="submit" name="isoarpreview" value="PREVIEW"><br>
	Netscape users must click here to PREVIEW colors<br><br><br>
	<input type="submit" name="isoardemo" value="DEMO"><br>
	ALL BROWSERS - Click here for a DEMO...then click your browser's back button to return to ISoar<br><br><br><br>
	<input type="submit" name="isoarsubmit" value="Save Changes">
	<input type="submit" name="isoarreset" value="Reset All"><BR><BR>
	<HR size="5"><BR>
	<input type="submit" name="isoarconvert1" value="Convert NewsPro After Upgrade">
	</form><br></div></div>
	~;
	&NPHTMLFoot;
}
1;
#####################################################
package Tie::FHRS;
sub TIEHANDLE {
	my $class = shift;
	my $self = shift;

	return bless $self, $class;
}

sub PRINT {
	my $self = shift;
	$$self .= join('', @_);
	return 1;
}
1;
#####################################################