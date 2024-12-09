#	Kremlin : "News Categories Permissions" for UserGroups
#		((requires the UserGroups Addon))
#	by plushpuffin@yahoo.com
#	http://plushpuffin.virtualave.net
#

push(@Addons_Loaded, 'Kremlin 3.7');
unshift(@Addons_PreHeader, 'KremlinPreLoad');
push(@Addons_RemoveNewsSave, 'KremlinRemoveNewsSaveCheck');
push(@Addons_UGEditSettings, 'KremlinEditSettings');
push(@Addons_UGSaveSettings, 'KremlinSaveSettings');
$Addons_List{'Kremlin 3.7'} = ['npa_kremlin.pl', 'Restrict user access to categories'];

##############################################
# Define the CAT property for both groups and users
#
$uField{'CAT'} = q~Permitted Categories~;
$gField{'CAT'} = q~Permitted Categories~;

##############################################
# Specify that the CAT property should collect
# all CAT properties for a user into a list
# instead of just getting the first one it finds
#
$ugGetProperty{'CAT'} = q~ugGetProperties~;

##############################################
# Make sure that the form elements for CAT
# are displayed on the User and Groups editing pages
#
push(@Addons_UGEditGroup, q~KremlinUGEditPerm~);
push(@Addons_UGEditUser, q~KremlinUGEditPerm~);

##############################################
# Make sure that Kremlin's category restriction
# properties can only be edited by webmasters
#
# (This is not strictly necessary, since the
# EditLevels are assumed to be 3 if they are
# not specified, but I am giving an example.)
#
$gMinEditLevel{'CAT'} = 3;
$uMinEditLevel{'CAT'} = 3;

##############################################
# The default 'safe' category that all users
# are allowed to post to
#
$KREMLINSAFECATEGORY = '(default)';


##############################################
# Generate a 'permission denied' message.
#
sub KremlinDenyPermission {
	my $deniedcat = shift || '(default)';
	my $safecat = $NPConfig{'KremlinSafeCat'} || '(default)';
	my $allsafecats = '<ul>' . join( "\n<BR>\n", sort keys %perms ) . '</ul>';
	return qq~<BR><BR><h3>
	You are not permitted to post news to the $deniedcat category.
	The offending news item(s) have been changed to the $safecat category.</h3><BR>
	You may post only to the following categories: $allsafecats<BR>
	~;
}

##############################################
# Load inherited properties for a user
#
sub KremlinLoadPermissions {
	unless( &KremlinCheckNewsCatLoaded ) { return 1; }
	&KremlinNewsCatLoadConfig;
	my $ug = shift;
	my @perms = split(/\|x\|/, &inheritedVar($ug,'CAT'));
	my ($i, %perms);
	foreach $i (@perms) {
		$perms{$i} = 'selected';
	}
	$perms{$NPConfig{'KremlinSafeCat'} || '(none)'} = 'selected';
	delete $perms{'(none)'};
	return %perms;
}

##############################################
# Display the form element for user/group permissions
# This is printed on both the user and group edit pages
#
sub KremlinUGEditPerm {
	if( &MinEditLevel( $CPassword{$ug}, 'CAT' ) > $up ) { return 1; }
	unless( &KremlinCheckNewsCatLoaded ) { return 1; }
	&KremlinNewsCatLoadConfig;
	my @perms = split(/\|x\|/, &ugVar($ug,'CAT'));
	my ($i, %perms);
	foreach $i (@perms) {
		$perms{$i} = 'selected';
	}
	my $safecat = $NPConfig{'KremlinSafeCat'} || '(default)';
	print qq~<tr><td>
	$uField{'CAT'}<BR><BR>The $safecat category is always permitted.<BR>
	The &quot;safe category&quot; can be changed in &quot;Edit Various UserGroups Settings&quot;</td><td>
	<select name="CAT" size="10" multiple>
	<option value="AllCategories" $perms{'AllCategories'}>(All Categories)</option>
	<option value="(default)" $perms{'(default)'}>(Default Category)</option>
	<option value="(none)" $perms{'(none)'}>(none selected)</option>
	~;

	foreach $i (@newscategories) {
		print qq~
		<option value="$i" $perms{$i}>$i</option>~;
	}

	print qq~
	</select></td></tr>
	~;
}

##############################################
# Check to make sure that either the 'News Categories' addon or
# the 'Teaser' addon is installed. If so, then categories should
# be regulated. If not, then don't bother.
#
sub KremlinCheckNewsCatLoaded {
	my $testaddons;
	my $newscatloaded = 0;
	foreach $testaddons (@Addons_Loaded) {
		if( $testaddons =~ /News Categories/i ) {
			$newscatloaded += 1;
		}
		elsif( $testaddons =~ /Teaser/i ) {
			$newscatloaded += 10;
		}
	}
	return $newscatloaded;
}

##############################################
# Remove the subroutine hooks for News Categories
# and Teaser that display the select field for categories
# Instead, use Kremlin's own custom subroutines for that.
# (Muhahhaha)
#
sub KremlinPreLoad {
	&ugCheckBuild( 10, 'Kremlin 2.0', 'npa_kremlin.pl' );
	$kcnc = &KremlinCheckNewsCatLoaded;
	unless ( $kcnc ) { return 1; }
	my $i;
	push( @Addons_Loaded, 'News Categories managed by Kremlin' );
		#
		# This keeps Teaser from trying to load
		# since Teaser checks for "News Categories" in @Addons_Loaded
		#
	for( $i = 0; $i < @Addons_RemoveNews2; $i++ ) {
		if( $Addons_RemoveNews2[$i] =~ m~.*NewsCatRemoveNews2.*~i ) {
			splice( @Addons_RemoveNews2, $i, 1 );
			$i--;
		}
	}
	for( $i = 0; $i < @Addons_RemoveNewsSave; $i++ ) {
		if( $Addons_RemoveNews2[$i] =~ m~.*NewsCatRemoveNewsSave.*~i ) {
			splice( @Addons_RemoveNewsSave, $i, 1 );
			$i--;
		}
	}
	for( $i = 0; $i < @Addons_DisplaySubForm; $i++ ) {
		if( $Addons_DisplaySubForm[$i] =~ m~.*NewsCatSubForm.*~i ) {
			splice( @Addons_DisplaySubForm, $i, 1 );
			$i--;
		}
	}
	push( @Addons_RemoveNews2, q~KNewsCatRemoveNews2~ );
	push( @Addons_DisplaySubForm, q~KNewsCatSubForm~ );
	if( $qstring eq "submitsave" ) { &KremlinSaveNewsCheck; }
}

##############################################
# This is the select field for news categories
# which appears on the DisplaySubForm page. It
# contains special provisions for dealing with
# permissions.
#
sub KNewsCatSubForm {
	local %perms = &KremlinLoadPermissions( $Cookies{'uname'} );
	my @perms = keys %perms;
	$perms{''} = $perms{'(default)'};
	push(@formfields, 'newscat');
	$FormFieldsName{'newscat'} = "News Category (managed by Kremlin)";
	if( @perms == 1 && $perms[0] ne 'AllCategories' ) {
		if( $perms[0] eq '(default)' ) { $perms[0] = ''; }
		$FormFieldsCustom{'newscat'} = qq~$perms[0]
		<input type="hidden" name="newscat" value="$perms[0]">~;
		return;
	} elsif( @perms == 0 ) {
		print q~<div align="center"><h3>
		You have not been granted permission to post to any news categories.</h3><BR>
		news category restrictions managed by KREMLIN<BR>
		written by <a href="mailto:plushpuffin@hotmail.com">plushpuffin</a><BR>
		<a href="http://plushpuffin.virtualave.net">plushpuffin's addon garden</a>
		</div>~;
		&NPHTMLFoot;
		exit;
	}
	my @NCats = split(/\|x\|/, $NPConfig{'NewsCategories'});
	$FormFieldsCustom{'newscat'} = q~<select name="newscat">~;
	my $issel = 'selected';
	if( $perms{''} || $perms{'AllCategories'} ) {
		$FormFieldsCustom{'newscat'} .= qq~
		<option value="" $issel>(default)</option>~;
		$issel = '';
	}
	my $ncat;
	foreach $ncat (sort @NCats) {
		if( $perms{$ncat} || $perms{'AllCategories'} ) {
			$FormFieldsCustom{'newscat'} .= qq~
			<option value="$ncat" $issel>$ncat</option>~;
			$issel = '';
		}
	}
	$FormFieldsCustom{'newscat'} .= q~
	</select>~;
}

##############################################
# This is the select field for news categories
# which appears on the Remove/Modify News page.
# It contains special provisions for dealing
# with permissions.
#
sub KNewsCatRemoveNews2 {
	local %perms = &KremlinLoadPermissions( $Cookies{'uname'} );
	my @perms = keys %perms;
	$perms{''} = $perms{'(default)'};
	if( @perms == 1 && $perms[0] ne 'AllCategories' ) {
		$newscatname = $newscat ? $newscat : '(default)';
		print qq~ Category (managed by Kremlin): $newscatname
		<input type="hidden" name="newscat--$newsnum" value="$newscat">~;
		return;
	}
	my @NCats = split(/\|x\|/, $NPConfig{'NewsCategories'});
	print qq~ Category (managed by Kremlin):
	<select name="newscat--$newsnum">~;
	my $issel = $newscat ? '' : 'selected';
	my ($nci,$dontdeselectme,$dontdeselectwarning);
	if( $perms{''} || $issel || $perms{'AllCategories'} ) {
		$dontdeselectme = ( $perms{''} || $perms{'AllCategories'} ) ?
				q~~ : q~ (restricted by kremlin)~;
		print qq~
		<option value="" $issel>(default)</option>
		~;
		if( $dontdeselectme ) {
				$dontdeselectwarning = q~<BR>
	<table align="right" border="3" cellpadding="5"><tr><td width="300">
	Your access to the selected category is restricted by Kremlin.
	If you change the category, you will not be
	able to reselect it later.</td></tr></table>~;
		}
	}
	foreach $nci (@NCats) {
		$issel = ($newscat eq $nci) ? 'selected' : '';
		if( $perms{$nci} || $issel || $perms{'AllCategories'} ) {
			$dontdeselectme = ( $perms{$nci} || $perms{'AllCategories'} ) ?
				q~~ : q~ (restricted by kremlin)~;
			print qq~
	<option value="$nci" $issel>$nci$dontdeselectme</option>
			~;
			if( $dontdeselectme ) {
				$dontdeselectwarning = q~<BR>
	<table align="right" border="3" cellpadding="5"><tr><td width="300">
	Your access to the selected category is restricted by Kremlin.
	If you change the category, you will not be
	able to reselect it later.</td></tr></table>~;
			}
		}
	}
	print "</select>$dontdeselectwarning";
}

##############################################
# Check to make sure that the user has permission to
# 'Submit News' to the specified category.
#
sub KremlinSaveNewsCheck {
	unless ( $qstring eq "submitsave" && &KremlinCheckNewsCatLoaded ) { return 1; }
	SubmitFormFields();
	local %perms = &KremlinLoadPermissions( $Cookies{'uname'} );
	my @perms = keys %perms;
	$perms{''} = $perms{'(default)'};
	if( @perms == 0 ) {
		&NPHTMLHead("Kremlin denies access to $in{'newscat'}");
		print q~<div align="center"><h3>
		You have not been granted permission to post to any news categories.</h3><BR>
		news category restrictions managed by KREMLIN<BR>
		written by <a href="mailto:plushpuffin@hotmail.com">plushpuffin</a><BR>
		<a href="http://plushpuffin.virtualave.net">plushpuffin's addon garden</a>
		</div>~;
		&NPHTMLFoot;
		exit;
	}
	unless( $perms{$in{'newscat'}} || $perms{'AllCategories'} ) {
		$Messages{'Save_Message'} .= &KremlinDenyPermission($in{'newscat'});
		$Messages{'Build_Message'} .= &KremlinDenyPermission($in{'newscat'});
		$in{'newscat'} = $NPConfig{'KremlinSafeCat'};
	}
}

##############################################
# Check to make sure that the user has permission to
# 'Modify News' to the specified category.
#
sub KremlinRemoveNewsSaveCheck {
	unless( &KremlinCheckNewsCatLoaded ) { return 1; }
	local %perms = &KremlinLoadPermissions( $Cookies{'uname'} );
	$perms{''} = $perms{'(default)'};
	my ($nn,$newscat_denied,%newscat_denied);
	push(@formfields,'newscat');
	for( $nn = 0; $nn < $totnewsnum; $nn++ ) {
		unless ($DisableModify{'newscat'} != 1 && ($DisableModify{'newscat'} != 2 || $up > 1)) { next; }
		unless ($in{"chk--$nn"} eq 'keep') { next; }
		unless($perms{$in{"newscat--$nn"}} ||
				$in{"newscat--$nn"} eq $NewsData[$nn]->{'newscat'} ||
				$perms{'AllCategories'}) {
			$newscat_denied{$in{"newscat--$nn"} || '(default)'} = 1;
			$newscat_denied = 1;
			$in{"newscat--$nn"} = $NPConfig{'KremlinSafeCat'};
			$ChangedItems{$nn} = 1;
		}
	}
	if( $newscat_denied ) {
		my $newscat_denied = ' [ ' . join( ' or ', sort keys %newscat_denied ) . ' ] ';
		$Messages{'ModifySave_Message'} .= &KremlinDenyPermission($newscat_denied);
		$Messages{'Build_Message'} .= &KremlinDenyPermission($newscat_denied);
	}
}

##############################################
# Display the Edit Settings page for Kremlin
#
sub KremlinEditSettings {
	unless( &KremlinCheckNewsCatLoaded && $up > 2 ) { return 1; }
	&KremlinNewsCatLoadConfig;
	print q~
		<tr><td><h4><center>KREMLIN</center></h4>
			The 'Safe' Category is the one which is chosen
			when the user is denied access to another category.
		</td><td><select name="SAFECAT" size="10">
	~;
	my ($i, $selected);
	$selected = $NPConfig{'KremlinSafeCat'} eq '(default)' ? 'selected' : '';
	print qq~<option value="(default)" $selected>(Default Category)</option>~;
	$selected = $NPConfig{'KremlinSafeCat'} eq '(none)' ? 'selected' : '';
	print qq~<option value="(none)" $selected>(none selected)</option>~;
	foreach $i (@newscategories) {
		if( $NPConfig{'KremlinSafeCat'} eq $i ) { $selected = 'selected'; }
		else { $selected = ''; }
		print qq~<option value="$i" $selected>$i</option>~;
	}
	print q~</select></td></tr>
	~;
}

##############################################
# Save Settings for Kremlin
#
sub KremlinSaveSettings {
	unless( $up > 2 && exists $in{'SAFECAT'} ) { return 1; }
	$NPConfig{'KremlinSafeCat'} = $in{'SAFECAT'};
	print qq~<tr><td>Kremlin:SafeCategory = $NPConfig{'KremlinSafeCat'}</td></tr>~;
}

##############################################
# Try to load the News Categories
#		this can be done either through the News Categories addon or TEASER
#
sub KremlinNewsCatLoadConfig {
	eval {&NewsCatLoadConfig; };
	if( $@ ) {
		eval { &NewsCatLoadConfigTeaser; };
		if( $@ ) {
			&NPdie( "<h3>The addon Kremlin requires that
			either News Categories or Teaser be installed in order for
			Kremlin to work at all.<BR><BR>Either install one or both of the
			aforementioned addons, or delete Kremlin.</h3>" );
		}
	}
}
1;