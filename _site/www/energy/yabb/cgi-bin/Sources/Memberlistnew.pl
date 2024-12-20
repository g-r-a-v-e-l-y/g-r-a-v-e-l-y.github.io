###############################################################################
# Memberlist.pl                                                               #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Andy Tomaka                                  #
###############################################################################
$TopAmmount = "25";
#$MembersPerPage = "40";

if($INFO{'start'} eq "") { $start=0; } else { $start="$INFO{'start'}"; }
$numshown=0;

if($action eq "mlall") { $Sort .= qq(View All Users | ); } else { $Sort .= qq(<a href="$cgi&action=mlall"><font color="$color{'titletext'}">View All Users</font></a> | ); }
if($action eq "mlletter") { $Sort .= qq(View By Letter | ); } else { $Sort .= qq(<a href="$cgi&action=mlletter"><font color="$color{'titletext'}">View By Letter</font></a> | ); }
if($action eq "mltop") { $Sort .= qq(Top $TopAmmount Posters); } else { $Sort .= qq(<a href="$cgi&action=mltop"><font color="$color{'titletext'}">Top $TopAmmount Posters</font></a>); }

if($action eq "mlletter") {
	$page = "a";
	while($page ne "z") {
		$LetterLinks .= qq(<a href="YaBB.pl?action=mlletter&letter=$page">$page</a> );
		$page++;
	}
	$LetterLinks .= qq(<a href="YaBB.pl?action=mlletter&letter=z">z</a> );
}

$TableHeader .= qq(
<table border=0 width=600 cellspacing=1 cellspacing="4" bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}" colspan="7"><b><font color="$color{'titletext'}">$Sort</font></b></td>
</tr>
);
if($LetterLinks ne "") {
	$TableHeader .= qq(<tr>
		<td bgcolor="$color{'catbg'}" colspan="7"><b>$LetterLinks</td>
	</tr>
	);
}
$TableHeader .= qq(<tr>
	<td bgcolor="$color{'catbg'}"><b>Username</b></td>
	<td bgcolor="$color{'catbg'}"><b>Email</b></td>
	<td bgcolor="$color{'catbg'}"><b>Website</b></td>
	<td bgcolor="$color{'catbg'}"><b>Posts</b></td>
	<td bgcolor="$color{'catbg'}"><b>Function</b></td>
	<td bgcolor="$color{'catbg'}"><b>ICQ</b></td>
	
</tr>
);

$TableFooter = qq~</table>~;

sub MLAll {
	&header;
	print qq~<br><br>$TableHeader~;
	open(MEMBERSLISTREAD,"$memberdir/memberlist.txt");
		while(chomp($membername=<MEMBERSLISTREAD>)) {
			@member = ();
			$Bar = "";
			$ICQ = "";
			open(MEMBERFILEREAD,"$memberdir/$membername.dat");
				@member = <MEMBERFILEREAD>;
			close(MEMBERFILEREAD);
			chomp @member;
		$Bar = qq~<img src="$imagesdir/bar1.gif" width=100 height=15 alt="" border="0">~;
		if($member[6] > 50) { $Bar = qq~<img src="$imagesdir/bar2.gif" width=100 height=15 alt="" border="0">~; }
		if($member[6] > 100) { $Bar = qq~<img src="$imagesdir/bar3.gif" width=100 height=15 alt="" border="0">~; }
		if($member[6] > 250) { $Bar = qq~<img src="$imagesdir/bar4.gif" width=100 height=15 alt="" border="0">~; }
		if($member[6] > 500) { $Bar = qq~<img src="$imagesdir/bar5.gif" width=100 height=15 alt="" border="0">~; }
		$member[8] =~ s/\n//g;
		$member[8] =~ s/\r//g;

		if($member[8] ne "") { $ICQ = qq~<a href="http://www.icq.com/$member[8]" target=_blank><img src="http://wwp.icq.com/scripts/online.dll?icq=$member[8]&img=5" alt ="$member[8]" border=0></a>~; }

			print qq(
<tr>
	<td bgcolor="$color{'windowbg'}"><a href="$cgi&action=viewprofile&username=$membername">$member[1]</a></td>
	<td bgcolor="$color{'windowbg2'}"><a href="mailto:$member[2]">$member[2]</a></td>
	<td bgcolor="$color{'windowbg'}"><a href="$member[4]" target="$member[3]">$member[3]</a></td>
	<td bgcolor="$color{'windowbg2'}">$member[6]</td>
	<td bgcolor="$color{'windowbg'}">$member[7]</td>
	<td bgcolor="$color{'windowbg2'}">$ICQ</td>
	
</tr>					
			);
		}
	close(MEMBERSLISTREAD);
	print qq~$TableFooter~;
	&footer;
	exit;
}

sub MLByLetter {
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
		$Bar = qq~<img src="$imagesdir/bar1.gif" width=100 height=15 alt="" border="0">~;
		if($member[6] > 50) { $Bar = qq~<img src="$imagesdir/bar2.gif" width=100 height=15 alt="" border="0">~; }
		if($member[6] > 100) { $Bar = qq~<img src="$imagesdir/bar3.gif" width=100 height=15 alt="" border="0">~; }
		if($member[6] > 250) { $Bar = qq~<img src="$imagesdir/bar4.gif" width=100 height=15 alt="" border="0">~; }
		if($member[6] > 500) { $Bar = qq~<img src="$imagesdir/bar5.gif" width=100 height=15 alt="" border="0">~; }
		$member[8] =~ s/\n//g;
		$member[8] =~ s/\r//g;

		if($member[8] ne "") { $ICQ = qq~<a href="http://www.icq.com/$member[8]" target=_blank><img src="http://wwp.icq.com/scripts/online.dll?icq=$member[8]&img=5" alt ="$member[8]" border=0></a>~; }

		print qq(
<tr>
	<td bgcolor="$color{'windowbg'}"><a href="$cgi&action=viewprofile&username=$membername">$member[1]</a></td>
	<td bgcolor="$color{'windowbg2'}"><a href="mailto:$member[2]">$member[2]</a></td>
	<td bgcolor="$color{'windowbg'}"><a href="$member[4]" target="$member[3]">$member[3]</a></td>
	<td bgcolor="$color{'windowbg2'}">$member[6]</td>
	<td bgcolor="$color{'windowbg'}">$member[7]</td>
	<td bgcolor="$color{'windowbg2'}">$ICQ</td>
	<td bgcolor="$color{'windowbg'}">$Bar</td>
</tr>					
		);
	}
	print qq~$TableFooter~;
	&footer;
	exit;
}

sub MLTop {
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
			$Bar = qq~<img src="$imagesdir/bar1.gif" width=100 height=15 alt="" border="0">~;
			if($member[6] > 50) { $Bar = qq~<img src="$imagesdir/bar2.gif" width=100 height=15 alt="" border="0">~; }
			if($member[6] > 100) { $Bar = qq~<img src="$imagesdir/bar3.gif" width=100 height=15 alt="" border="0">~; }
			if($member[6] > 250) { $Bar = qq~<img src="$imagesdir/bar4.gif" width=100 height=15 alt="" border="0">~; }
			if($member[6] > 500) { $Bar = qq~<img src="$imagesdir/bar5.gif" width=100 height=15 alt="" border="0">~; }
			$member[8] =~ s/\n//g;
			$member[8] =~ s/\r//g;

			if($member[8] ne "") { $ICQ = qq~<a href="http://www.icq.com/$member[8]" target=_blank><img src="http://wwp.icq.com/scripts/online.dll?icq=$member[8]&img=5" alt ="$member[8]" border=0></a>~; }

			print qq(
	<tr>
		<td bgcolor="$color{'windowbg'}"><a href="$cgi&action=viewprofile&username=$membername">$member[1]</a></td>
		<td bgcolor="$color{'windowbg2'}"><a href="mailto:$member[2]">$member[2]</a></td>
		<td bgcolor="$color{'windowbg'}"><a href="$member[4]" target="$member[3]">$member[3]</a></td>
		<td bgcolor="$color{'windowbg2'}">$member[6]</td>
		<td bgcolor="$color{'windowbg'}">$member[7]</td>
		<td bgcolor="$color{'windowbg2'}">$ICQ</td>
		<td bgcolor="$color{'windowbg'}">$Bar</td>
	</tr>					
			);
		}
	}
	print qq~$TableFooter~;
	&footer;
	exit;
}

1;