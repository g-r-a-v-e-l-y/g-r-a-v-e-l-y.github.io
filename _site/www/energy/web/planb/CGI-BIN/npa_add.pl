push(@Addons_Loaded, 'Addon Manager');
$Addons_List{'Addon Manager 1.01'} = ['npa_add.pl', 'Displays a list of currently installed addons, along with download and upgrade information.', 'http://amphibian.gagames.com/addon.cgi?add&1.01'];
push(@Addons_PageHandler, 'AddonManagerHandler');
push(@Addons_MainPage, 'AddonManagerMainPage');
push(@Addons_NPHTMLFoot, 'AddonManagerHTMLFoot');
&CheckBuild(3, "Addon Manager", "npa_add.pl");


sub AddonManagerHandler {
	if (query_string() eq 'addonmanager') {
		&ShowAddonManager;
		exit;
	}
}

sub AddonManagerHTMLFoot {
	if ($up == 3) {
	print qq~
	<a href="$scripturl?addonmanager" class="navlink">Addon Manager</a> |~;
	}
}

sub AddonManagerMainPage {
	if ($up == 3) {
	print qq~
	<b><a href="$scripturl?addonmanager">Addon Manager</a>:</b> View currently installed or install new addons (small files which extend NewsPro's abilities).<br><br>
	~;
	}
}

sub ShowAddonManager {
	&NPHTMLHead("Addon Manager");
	print qq~
	<div align="center"><font size="+1"><a href="http://amphibian.gagames.com/newspro/members/addons.cgi">Download NewsPro addons here.</a></font></div>
	<p>A list of currently installed addons is below. To remove any of these, delete its file (listed along with its name below). To install new addons,
	download them from the <a href="http://amphibian.gagames.com/newspro/members/addons.cgi">NewsPro site</a> and simply copy the files into your NewsPro directory.
	</p>
	~;
	my $i;
	foreach $i (sort keys %Addons_List) {
		my $name = $i;
		my $filename = $Addons_List{$i}->[0];
		my $description = $Addons_List{$i}->[1];
		my $imageurl = $Addons_List{$i}->[2];
		if ($imageurl) {
			$imageurl = qq~<img src="$imageurl" width="85" height="13">~;
		}
		print qq~
		<p><b>$name:</b> $description<br>
		<small> Filename: $filename  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $imageurl</p>
		~;
	}
	&NPHTMLFoot;
}
1;	