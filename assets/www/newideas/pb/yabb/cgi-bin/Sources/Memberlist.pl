###############################################################################
# Memberlist.pl                                                               #
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

$memberlistplver="1 Gold Beta4";

if($username eq "Guest") { &fatal_error("$txt{'223'}"); }

if($action eq "mlall") { $Sort .= qq($txt{'303'} | ); } else { $Sort .= qq(<a href="$cgi&action=mlall"><p>$txt{'303'}</p></a> | ); }
if($action eq "mlletter") { $Sort .= qq($txt{'304'} | ); } else { $Sort .= qq(<a href="$cgi&action=mlletter"><p>$txt{'304'}</p></a> | ); }
if($action eq "mltop") { $Sort .= qq($txt{'305'} $txt{'411'} $TopAmmount $txt{'306'}); } else { $Sort .= qq(<a href="$cgi&action=mltop"><p>$txt{'305'} $txt{'411'} $TopAmmount $txt{'306'}</p></a>); }

if($action eq "mlletter") {
	$page = "a";
	while($page ne "z") {
		$LetterLinks .= qq(<a href="YaBB.pl?action=mlletter&letter=$page">$page</a> );
		$page++;
	}
	$LetterLinks .= qq(<a href="YaBB.pl?action=mlletter&letter=z">z</a> );
}

$TableHeader .= qq(
<table border=0 width=100% cellspacing=1 cellspacing="4" bgcolor="$color{'bordercolor'}">
<tr>
	<td class="title1" bgcolor="$color{'titlebg'}" colspan="7"><p>$Sort</p></td>
</tr>
);
if($LetterLinks ne "") {
	$TableHeader .= qq(<tr>
		<td class="cat1" bgcolor="$color{'catbg'}" colspan="7"><p>$LetterLinks</td>
	</tr>
	);
}
$TableHeader .= qq(<tr>
	<td class="cat1" bgcolor="$color{'catbg'}" width=100><p>$txt{'35'}</p></td>
	<td class="cat1" bgcolor="$color{'catbg'}"><p>$txt{'307'}</p></td>
	<td class="cat1" bgcolor="$color{'catbg'}"><p>$txt{'96'}</p></td>
	<td class="cat1" bgcolor="$color{'catbg'}"><p>$txt{'86'}</p></td>
	<td class="cat1" bgcolor="$color{'catbg'}"><p>$txt{'87'}</p></td>
	<td class="cat1" bgcolor="$color{'catbg'}"><p>ICQ</p></td>
	<td class="cat1" bgcolor="$color{'catbg'}"><p>$txt{'21'}</p></td>
</tr>
);

$TableFooter = qq~</table>~;

sub MLAll {
	if($username eq "Guest") { &fatal_error("$txt{'223'}"); }
	# Get the number of members
	open(FILE, "$memberdir/memberlist.txt");
	&lock(FILE);
	@memberlist = <FILE>;
	&unlock(FILE);
	$memcount = @memberlist;
	@membername = @memberlist;
	close(FILE);

	if($INFO{'start'} eq "") { $start=0; } else { $start="$INFO{'start'}"; }
	$numshown=0;
	$numbegin = ($start + 1);
	$numend = ($start + $MembersPerPage);
	$b = $start;

	$yytitle = "$txt{'308'} $numbegin $txt{'311'} $numend";
	&header;

	print qq(
		<table border=0 cellspacing=0 cellpadding=1 align="center">
		<tr>
			<td bgcolor="#000000" align="center">
			<p>$txt{'308'} $numbegin $txt{'311'} $numend ($txt{'309'} $memcount $txt{'310'})</p>
			</td>
		</tr>
		</table>
	);

	print qq~<br><br>$TableHeader~;

	while(($numshown < $MembersPerPage)) {
		$numshown++;
		$c=0;
		$pages="";
		chomp(@membername);
		$tempname = $membername[$b];
		$membername[$b] =~ s/ //gi;
		$membername[$b] =~ s/\n//gi;
		$name = $membername[$b];
		$b++;

		@member = ();
		$Bar = "";
		$ICQ = "";
		open(MEMBERFILEREAD,"$memberdir/$name.dat");
		@member = <MEMBERFILEREAD>;
		close(MEMBERFILEREAD);
		chomp @member;

		$barchart = ($member[6] / 5);
		if ($barchart < 1) {$Bar = "$Bar";}
		elsif ($barchart > 100) {
			$Bar = qq~<img src="$imagesdir/bar.gif" width=100 height=15 alt="" border="0">~;
		}
		else {
			$Bar = qq~<img src="$imagesdir/bar.gif" width=$barchart height=15 alt="" border="0">~;
		}
		$member[8] =~ s/[\n\r]//g;

		if($member[8] ne "") {
			$ICQ = qq~<a href="$cgi\&action=icqpager&UIN=$member[8]" target=_blank><img src="http://wwp.icq.com/scripts/online.dll?icq=$member[8]&img=5" alt ="$member[8]" border=0></a>~;
		}
		if ($Bar eq "") { $Bar="&nbsp;"; }

		if($tempname)
		{
			print qq(
			<tr>
				<td class="form1" bgcolor="$color{'windowbg'}"><p><a href="$cgi&action=viewprofile&username=$name">$member[1]</a></p></td>
				<td class="form2" bgcolor="$color{'windowbg2'}"><p><a href="mailto:$member[2]">$member[2]</a></p></td>
				<td class="form1" bgcolor="$color{'windowbg'}"><p><a href="$member[4]" target="_blank">$member[3]</a></p>&nbsp;</td>
				<td class="form2" bgcolor="$color{'windowbg2'}"><p>$member[6]</p>&nbsp;</td>
				<td class="form1" bgcolor="$color{'windowbg'}"><p>$member[7]</p>&nbsp;</td>
				<td class="form2" bgcolor="$color{'windowbg2'}"><p>$ICQ</p>&nbsp;</td>
				<td class="form1" bgcolor="$color{'windowbg'}">$Bar</td>
			</tr>
			);
		}
	}

	print qq~$TableFooter~;

	print <<"EOT";
	<table border=0 width=100% cellpadding=0 cellspacing=0>
	<tr>
		<td><p>$txt{'139'}:
EOT
	$c=0;
	while(($c*$MembersPerPage) < $memcount) {
		$viewc = $c+1;
		$strt = ($c*$MembersPerPage);
		if($start == $strt) {
			print <<"EOT";
			$viewc
EOT
		}
		else {
			print <<"EOT";
			<a href="$cgi&action=mlall&start=$strt">$viewc</a>
EOT
		}
		++$c;
	}
	print <<"EOT";
		</td>
	</tr>
	</table>
EOT
# /Build 10

	&footer;
	exit;
}

sub MLByLetter {
	if($username eq "Guest") { &fatal_error("$txt{'223'}"); }
	$yytitle = "$txt{'312'}";
	$letter = $INFO{'letter'};
	&header;
	print qq~$TableHeader~;

	open(MEMBERSLISTREAD,"$memberdir/memberlist.txt");
		while(chomp($memberfile=<MEMBERSLISTREAD>)) {
			open(MEMBERFILEREAD,"$memberdir/$memberfile.dat");
				@member = <MEMBERFILEREAD>;
			close(MEMBERFILEREAD);
			chomp @member;

			$SearchName = $member[1];
			$SearchName = substr $SearchName,0,1;
			$SearchName = lc $SearchName;
			if($SearchName eq $letter) {

				push(@ToShow,$memberfile);
			}
		}
	close(MEMBERSLISTREAD);

	@ToShow = sort(@ToShow);

	foreach $membername(@ToShow) {
		@member = ();
		$Bar = "";
		$ICQ = "";
		open(MEMBERFILEREAD,"$memberdir/$membername.dat");
			@member = <MEMBERFILEREAD>;
		close(MEMBERFILEREAD);
		chomp @member;
		$barchart = ($member[6] / 5);
		if ($barchart < 1) {$Bar = "$Bar";}
		elsif ($barchart > 100) {$Bar = qq~<img src="$imagesdir/bar.gif" width=100 height=15 alt="" border="0">~;}
		else {
		$Bar = qq~<img src="$imagesdir/bar.gif" width=$barchart height=15 alt="" border="0">~;
		}
		$member[8] =~ s/[\n\r]//g;
		if ($Bar eq "") { $Bar="&nbsp;"; }

		if($member[8] ne "") { $ICQ = qq~<a href="$cgi\&action=icqpager&UIN=$memset[8]" target=_blank><img src="http://wwp.icq.com/scripts/online.dll?icq=$member[8]&img=5" alt ="$member[8]" border=0></a>~; }

		print qq(
<tr>
	<td class="form1" bgcolor="$color{'windowbg'}"><p><a href="$cgi&action=viewprofile&username=$membername">$member[1]</a></p></td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><p><a href="mailto:$member[2]">$member[2]</a></p></td>
	<td class="form1" bgcolor="$color{'windowbg'}"><p><a href="$member[4]" target="$member[3]">$member[3]</a></p>&nbsp;</td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><p>$member[6]</p>&nbsp;</td>
	<td class="form1" bgcolor="$color{'windowbg'}"><p>$member[7]</p>&nbsp;</td>
	<td class="form2" bgcolor="$color{'windowbg2'}"><p>$ICQ</p>&nbsp;</td>
	<td class="form1" bgcolor="$color{'windowbg'}">$Bar</td>
</tr>
		);
	}
	print qq~$TableFooter~;
	&footer;
	exit;
}

sub MLTop {
	if($username eq "Guest") { &fatal_error("$txt{'223'}"); }
	$yytitle = "$txt{'313'} $TopAmmount $txt{'314'}";
	&header;
	print qq~$TableHeader~;
	%TopMembers = ();
	open(MEMBERLISTREAD,"$memberdir/memberlist.txt");
		@member = ();
		while(chomp($membername=<MEMBERLISTREAD>)) {
			open(MEMBERFILE,"$memberdir/$membername.dat");
				@member = <MEMBERFILE>;
			close(MEMBERFILE);
			chomp @member;

			$TopMembers{$membername} = $member[6];
		}
	close(MEMBERLISTREAD);

	my @toplist = sort {$TopMembers{$a} <=> $TopMembers{$b}} keys %TopMembers;
	@toplist = reverse @toplist;
	$TopListNum = $TopAmmount - 1;

#	foreach $membername(@toplist) {
for ($i=0;$i<=$TopListNum;$i++) {
		@member = ();
		$Bar = "";
		$ICQ = "";
		$membername = @toplist[$i];
		open(MEMBERFILEREAD,"$memberdir/$membername.dat");
			@member = <MEMBERFILEREAD>;
		close(MEMBERFILEREAD);
		chomp @member;
		if($member[1] ne "") {
			$barchart = ($member[6] / 5);
			if ($barchart < 1) {$Bar = "$Bar";}
			elsif ($barchart > 100) {$Bar = qq~<img src="$imagesdir/bar.gif" width=100 height=15 alt="" border="0">~;}
			else {
			$Bar = qq~<img src="$imagesdir/bar.gif" width=$barchart height=15 alt="" border="0">~;
			}
			$member[8] =~ s/[\n\r]//g;

			if($member[8] ne "") { $ICQ = qq~<a href="$cgi\&action=icqpager&UIN=$memset[8]" target=_blank><img src="http://wwp.icq.com/scripts/online.dll?icq=$member[8]&img=5" alt ="$member[8]" border=0></a>~; }
			if ($Bar eq "") { $Bar="&nbsp;"; }

			print qq(
	<tr>
		<td class="form1" bgcolor="$color{'windowbg'}"><p><a href="$cgi&action=viewprofile&username=$membername">$member[1]</a></p></td>
		<td class="form2" bgcolor="$color{'windowbg2'}"><p><a href="mailto:$member[2]">$member[2]</a></p></td>
		<td class="form1" bgcolor="$color{'windowbg'}"><p><a href="$member[4]" target="$member[3]">$member[3]</a></p>&nbsp;</td>
		<td class="form2" bgcolor="$color{'windowbg2'}"><p>$member[6]</p>&nbsp;</td>
		<td class="form1" bgcolor="$color{'windowbg'}"><p>$member[7]</p>&nbsp;</td>
		<td class="form2" bgcolor="$color{'windowbg2'}"><p>$ICQ</p>&nbsp;</td>
		<td class="form1" bgcolor="$color{'windowbg'}">$Bar</td>
	</tr>
			);
		}
	}
	print qq~$TableFooter~;
	&footer;
	exit;
}

1;