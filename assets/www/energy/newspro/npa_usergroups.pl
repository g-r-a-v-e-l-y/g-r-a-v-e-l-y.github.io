#	UserGroups Addon
#	by plushpuffin@yahoo.com
#	http://plushpuffin.virtualave.net
#

$uggloaded = 0;
$upploaded = 0;
$ugBuild = 16;

push(@Addons_Loaded, qq~UserGroups Addon build $ugBuild~);
push(@Addons_PageHandler, 'UserGroups_PageHandler');
push(@Addons_PreHeader,'UGStartup');
push(@Addons_MainPage, 'UserGroups_MainPage');
push(@Addons_NPHTMLFoot, 'UserGroups_HTMLFoot');
$Addons_List{qq~UserGroups Addon build $ugBuild~} = ['npa_usergroups.pl', 'Manage users and groups - by <a href="mailto:plushpuffin@yahoo.com">plushpuffin</a>'];

####################################################
####################################################
##
##	THIS ADDON IS MEANT TO BE USED BY OTHER
##	ADDONS. IT IS OF ALMOST NO USE TO YOU BY
##	ITSELF. IF YOU WOULD LIKE TO LEARN HOW TO
##	WRITE AN ADDON WHICH USES USERGROUPS, THE
##	BEST WAY TO START IS TO FIND A USERGROUPS
##	ADDON (SUCH AS KREMLIN OR DOSSIER) AND
##	COPY IT AND CHANGE IT TO SUIT YOUR NEEDS.
##
##	MORE DETAILS ARE AVAILABLE IN THE README
##
####################################################
####################################################

##############################################
# Default properties defined for GROUPS
#

# Set DESC and USR and give their descriptions
$gField{'USR'} = q~Users~;
$gField{'DESC'} = q~Group Description~;

# Set DESC and USR to be displayed for editing
unshift(@Addons_UGEditGroup, 'UG_DESC');
unshift(@Addons_UGEditGroup, 'UG_USR');

# Set DESC and USR to webmaster-only editing
$gMinEditLevel{'USR'} = 3;
$gMinEditLevel{'DESC'} = 3;


##############################################
# Specify which field to use when determining
# UGP_PROPERTYNAME values.
#
push(@Addons_UGEditSettings, 'UGPChooseField');
push(@Addons_UGSaveSettings, 'UGPSaveField');

##############################################
# 'Fake' included addon subroutine for editing
#		the Group property "DESC"
#
sub UG_DESC {
	if( &MinEditLevel( 0, 'DESC' ) > $up ) { return 1; }
	$ugDESCval = &ugVar($ug,'DESC');
	print qq~<tr><td colspan="9">Type a nice description for this group:
	<input type="text" name="DESC" value="$ugDESCval" size="72"></td></tr>
	~;

}

##############################################
# 'Fake' included addon subroutine for editing
#		the Group property "USR"
#
sub UG_USR {
	if( &MinEditLevel( 0, 'USR' ) > $up ) { return 1; }
	my @selectedusers = split(/\|x\|/, &ugVar($ug,'USR'));
	my %selectedusers;
	foreach $i (@selectedusers) {
		$selectedusers{$i} = 'selected';
	}
	my $tall = 1 + scalar @usernames;
	$tall = $tall > 10 ? 10 : $tall;
	print qq~<tr><td valign="middle">
	<br><br>Select individual users which this group contains:
	</td><td>
	<select name="USR" size="$tall" multiple>
	<option value="AllUsers" $selectedusers{'AllUsers'}>(All Users)</option>
	~;
	foreach $i (sort @usernames) {
		print qq~
		<option value="$i" $selectedusers{$i}>$i</option>~;
	}
	print qq~
	</select></td></tr>
	~;
}

##############################################
# Get the minimum acceptable userlevel which allows
#		editing of the specified variable.
#		USAGE: &ugVar( [ 1 for USERVAR || 0 for GROUPVAR ], VARIABLENAME )
#			the first argument should be true if you're inquiring about
#			a user variable, otherwise it should be false or undefined.
#
sub MinEditLevel {
	return  ( ( $_[0] ? $uMinEditLevel{$_[1]} : $gMinEditLevel{$_[1]} ) || 3 );
}

##############################################
# Get SPECIFICALLY DECLARED property for the user or group
#		USAGE: &ugVar( GROUPNAME/USERNAME, VARIABLENAME )
#
sub ugVar {
	&UGStartup;
	my ( $thegroup, $whichvar ) = @_;
	my ($result) = $usergroups{$thegroup}->{$whichvar} =~ m~$whichvar:(.*)~;
	return $result;
}

##############################################
# Get INHERITED property for the user or group
#		USAGE: &inheritedVar( USERNAME, VARIABLENAME )
#
sub inheritedVar {
	my ($theuser, $whichvar ) = @_;
	&UGStartup;
	unless( $upploaded ) { &AssembleAllUsersProperties; }
	my ($result) = $propsusers{$theuser}->{$whichvar} =~ m~$whichvar:(.*)~;
	return $result;
}

##############################################
# Set a user or group's specified property
#		USAGE: &ugVarSetValue( GROUPNAME/USERNAME, VARIABLENAME, VARIABLE_NEW_VALUE )
#
sub ugVarSetValue {
	&UGStartup;
	my ( $ug, $whichvar, $varval ) = @_;
	if( ugVar($ug,$whichvar) eq $varval ) { return 1; }
	if( &MinEditLevel( exists $CPassword{$ug}, $whichvar ) > $up ) { return 1; }
	$upploaded = 0;
	$varval =~ s~\(\*\)~\(\*%\)~g;
	if( defined $varval ) {
		$usergroups{$ug}->{$whichvar} = "$whichvar:$varval";
	}
	else {
		delete $usergroups{$ug}->{$whichvar};
	}
	return 0;
}

##############################################
# Get the user's property for specific field from ALL groups (collective)
#		(NO PARAMATERS PASSED)
#		expects the variables $theuser and $gfield to be defined
#
sub ugGetProperties {
	&UGStartup;
	my $thegroup;
	my (%all_props,@props,$props);
	my $userfind;
	@props = split(/\|x\|/, &ugVar($theuser,$gfield));
	foreach $prop (@props) {
		$all_props{$prop} = 1;
	}
	foreach $thegroup (@groups) {
		$userfind = '|x|' . &ugVar($thegroup,'USR') . '|x|';
		unless( $userfind =~ m~\|$theuser\|~ || $userfind =~ m~\|AllUsers\|~ ) { next; }
		if( $usergroups{$thegroup}->{$gfield} ) {
			@props = split(/\|x\|/, &ugVar($thegroup,$gfield));
			foreach $prop (@props) {
				$all_props{$prop} = 1;
			}
		}
	}
	return join( '|x|', keys %all_props );
}

##############################################
# Get the user's property for specific field from the first group with that property
#		(NO PARAMATERS PASSED)
#		expects the variables $theuser and $gfield to be defined
#
sub ugGetProperty {
	&UGStartup;
	local $thegroup;
	my $userfind;
	if( exists $usergroups{$theuser}->{$gfield} ) { return &ugVar($theuser,$gfield); }
	foreach $thegroup (@groups) {
		$userfind = '|x|' . &ugVar($thegroup,'USR') . '|x|';
		unless( $userfind =~ m~\|$theuser\|~ || $userfind =~ m~\|AllUsers\|~ ) { next; }
		if( $usergroups{$thegroup}->{$gfield} ) {
			return &ugVar($thegroup,$gfield);
		}
	}
}

##############################################
# Assemble all properties for a single user by 'borrowing' from
#		the groups containing that user
#		USAGE: &assembleTheUsersProperties( USERNAME )
#
sub assembleTheUsersProperties {
	&UGStartup;
	local $theuser = shift;
	local $gfield;
	my $groupval;
	foreach $gfield (@gfields) {
		unless( $uField{$gfield} ) { next; }
		if( $ugGetProperty{$gfield} ) {
			eval { $groupval = &{$ugGetProperty{$gfield}}; };
			if ($@) {
				&NPdie("Error running addon subroutine $ugGetProperty{$gfield} from the usergroups addon. If you continue to experience this error, remove the addon which is responsible for that subroutine. Error: $@");
			}
		}
		else { $groupval = &ugGetProperty; }
		if( defined $groupval ) {
			#print qq~\n<HR>$theuser : $gfield == $groupval<BR>\n~;
			$propsusers{$theuser}->{$gfield} = "$gfield:$groupval";
			#print qq~\n$propsusers{$theuser}->{$gfield}<HR>\n~;
		}
		else {
			delete $propsusers{$theuser}->{$gfield};
		}
	}
}

##############################################
# Assemble all properties for all users
#		(NO PARAMATERS PASSED)
#
sub AssembleAllUsersProperties {
	local @gfields = sort keys %gField;
	local @groups = ();
	my $group;
	&UGStartup;
	foreach $group (sort keys %usergroups) {
		unless( $CPassword{$group} ) {
			push( @groups, $group );
		}
	}
	my $theuser;
	foreach $theuser (@usernames) {
		$propsusers{$theuser} = ();
		&assembleTheUsersProperties($theuser);
	}
	$upploaded = 1;
	foreach $gfield (keys %uField) {
		if( $gField{$gfield} ) { next; }
		$groupval = &ugVar($Cookies{'uname'},$gfield);
		${"UGV_$gfield"} = $groupval;
		tie ${"UGP_$gfield"}, 'Tie::UGPROP', $gfield, 'ugVar', $NPConfig{'UGPField'};
	}
	foreach $gfield (keys %gField) {
		unless( $uField{$gfield} ) { next; }
		$groupval = &inheritedVar($Cookies{'uname'},$gfield);
		${"UGV_$gfield"} = $groupval;
		tie ${"UGP_$gfield"}, 'Tie::UGPROP', $gfield, 'inheritedVar', $NPConfig{'UGPField'};
	}
}

##############################################
# Save properties to a Group from a web form
#		(NO PARAMATERS PASSED)
#		if the hash element $ugSaveGroup{'VARIABLENAME'} is
#		defined, execute that hash element's value as a subroutine
#		(allows other addons to act on the input before saving)
#
sub UserGroupsSaveGroup {
	local $ug = $in{'groupname'};
	local $ugval;
	# Strip newlines and other bad things.
	foreach $key (keys %gField) {
		unless( exists $in{$key} ) { next; }
		$ugval = $in{$key};
		$ugval =~ s/\n/<br>/g;
		$ugval =~ s/\r//g;
		$ugval =~ s/``x/` ` x/g;
		unless( $ugval ne &ugVar($ug,$key) ) { next; }
		if( $ugSaveGroup{$key} ) {
			eval { $ugval = &{$ugSaveGroup{$key}}; };
			if ($@) {
				&NPdie("Error running addon subroutine $ugSaveGroup{$key} from the usergroups addon. If you continue to experience this error, remove the addon which is responsible for that subroutine. Error: $@");
			}
		}
		&ugVarSetValue( $ug, $key, $ugval );
	}
	&UserGroupsSaveConfig;
}

##############################################
# Save properties to a User from a web form
#		(NO PARAMATERS PASSED)
#		if the hash element $ugSaveuser{'VARIABLENAME'} is
#		defined, execute that hash element's value as a subroutine
#		(allows other addons to act on the input before saving)
#
sub UserGroupsSaveUser {
	local $ug = $in{'username'};
	local $ugval;
	# Strip newlines and other bad things.
	foreach $key (keys %uField) {
		unless( exists $in{$key} ) { next; }
		$ugval = $in{$key};
		$ugval =~ s/\n/<br>/g;
		$ugval =~ s/\r//g;
		$ugval =~ s/``x/` ` x/g;
		unless( $ugval ne &ugVar($ug,$key) ) { next; }
		if( $ugSaveUser{$key} ) {
			eval { $ugval = &{$ugSaveUser{$key}}; };
			if ($@) {
				&NPdie("Error running addon subroutine $ugSaveUser{$key} from the usergroups addon. If you continue to experience this error, remove the addon which is responsible for that subroutine. Error: $@");
			}
		}
		&ugVarSetValue( $ug, $key, $ugval );
	}
	&UserGroupsSaveConfig;
}

##############################################
# Display the Group Properties Editing Page
#		(NO PARAMATERS PASSED)
#		The array @Addons_UGEditGroup contains a list
#		of subroutines which will be executed in this page
#		to display form elements from other addons
#
sub UserGroupsEditGroup {
	local $ug = $in{'groupname'};
	&NPHTMLHead("Edit Group $ug");

	print qq~<BR><BR><center><h2>group: $ug</h2><HR><BR>
	<table width=50% align="center"><tr><td align="center">
	To make multiple selections:<br> Windows users hold down CTRL,
	Mac users hold down Option,
	most UNIX users hold down CTRL,
	users of other operating systems see your browser's help.
	</td></tr></table>
	</center><BR><BR>
	~;

	print qq~
	<form action="$scripturl?usergroups" method="POST">
	<input type="hidden" name="groupname" value="$ug">
	<table width="90%" cellspacing="10" cellpadding="5" border="1" bordercolor="#000000" align="center">
	~;

	if (@Addons_UGEditGroup) {
		&RunAddons(@Addons_UGEditGroup);
	}

	print qq~<tr><td align="center" colspan="9"><BR><BR>
	<input type="submit" name="editgroupsave" value="Save Group">
	</td></tr></table></form>
	~;
	if( $up > 2 ) {
		print qq~
		<div align="center">
		<a target="usergroupsva" href="$scripturl?usergroups/viewall">View All User &amp; Group Properties</a><BR>
		</div>
		~;
	}
	&NPHTMLFoot;
}

##############################################
# Display the User Properties Editing Page
#		(NO PARAMATERS PASSED)
#		The array @Addons_UGEditUser contains a list
#		of subroutines which will be executed in this page
#		to display form elements from other addons
#
sub UserGroupsEditUser {
	local $ug = $in{'username'};
	&NPHTMLHead("Edit User $ug");

	print qq~<BR><BR><center><h2>user: $ug</h2><HR><BR>
	To make multiple selections:<br> Windows users hold down CTRL,
	Mac users hold down Option,
	most UNIX users hold down CTRL,
	users of other operating systems see your browser's help.
	</center><BR><BR>
	~;

	print qq~
	<form action="$scripturl?usergroups" method="POST">
	<table width="90%" cellspacing="10" cellpadding="5" border="1" bordercolor="#000000" align="center">
	<input type="hidden" name="username" value="$ug">
	~;

	if (@Addons_UGEditUser) {
		&RunAddons(@Addons_UGEditUser);
	}

	print qq~<tr><td align="center" colspan="9"><BR><BR>
	<input type="submit" name="editusersave" value="Save User">
	</td></tr>
	</table>
	</form>
	~;
	if( $up > 2 ) {
		print qq~
		<div align="center">
		<a target="usergroupsva" href="$scripturl?usergroups/viewall">View All User &amp; Group Properties</a><BR>
		</div>
		~;
	}
	&NPHTMLFoot;
}

##############################################
# Display All Properties For A User
#		(NO PARAMATERS PASSED)
#		this subroutine exists mainly for
#		debugging and informational/administrative purposes
#		(just so you can be absolutely sure what
#		someone's specific & inherited properties are
#
sub UserGroupsShowUser {
	my $ug = $in{'username'};
	&NPHTMLHead("Show User $ug");
	print qq~
	<table width="100%" align="center" cellpadding="1" cellspacing="1" border="1" bordercolor="#000000">
	<tr><td colspan="2">
	<BR><h2>Specified User Properties for $ug</h2><BR></td></tr>~;
	foreach $i (keys %uField) {
		if( &MinEditLevel( 1, $i ) > $up ) { next; }
		$_ = &ugVar( $ug, $i );
		$_ = HTMLescape($_);
		$_ =~ s/\|x\|/\n<BR>/g;
		print qq~<tr><td width="30%">
		<b>$i</b> ( $uField{$i} )</td><td width="70%">$_\n<BR><BR>
		</td></tr>~;
	}
	print qq~<tr><td colspan="2">
	<BR><h4>Properties Overridden / Inherited from Groups for $ug</h4><BR>
	</td></tr>~;
	foreach $i (keys %gField) {
		if( &MinEditLevel( 0, $i ) > $up ) { next; }
		unless( $uField{$i} ) { next; }
		$_ = &inheritedVar( $ug, $i );
		$_ = HTMLescape($_);
		$_ =~ s/\|x\|/\n<BR>/g;
		print qq~<tr><td width="30%">
		<b>$i</b> ( $uField{$i} )</td><td width="70%">$_\n<BR><BR>
		</td></tr>~;
	}
	print q~</table>~;
	if( $up > 2 ) {
		print qq~
		<div align="center">
		<a target="usergroupsva" href="$scripturl?usergroups/viewall">View All User &amp; Group Properties</a><BR>
		</div>
		~;
	}
	&NPHTMLFoot;
}

##############################################
# Display All Properties For All Users & Groups
#		(NO PARAMATERS PASSED)
#		this subroutine exists mainly for
#		debugging and informational/administrative purposes
#
sub UserGroupsViewAll {
	&NPHTMLHead("Show All User &amp; Group Properties");
	my( $ug, $ugindex );
	$ugindex = q~<table align="center" border="1" cellspacing="5" cellpadding="5"><tr><td align="center">| ~;
	foreach $ug (sort keys %usergroups) {
		if( $CPassword{$ug} ) { next; }
		$ugindex .= qq~<b><a href="#$ug">$ug</a></b> |~;
	}
	$ugindex .= q~</td></tr><tr><td align="center">| ~;
	foreach $ug (sort @usernames) {
		$ugindex .= qq~<b><a href="#$ug">$ug</a></b> |~;
	}
	$ugindex .= q~</td></tr></table><BR><BR>~;
	print $ugindex;
	foreach $ug (sort keys %usergroups) {
		if( $CPassword{$ug} ) { next; }
		print qq~<a name="$ug"></a>
		<table width="100%" align="center" cellpadding="1" cellspacing="1" border="1" bordercolor="#000000">
		<tr><td colspan="2">
		<BR><h2>Specified Group Properties for $ug</h2><BR></td></tr>~;
		foreach $i (keys %gField) {
			if( &MinEditLevel( 1, $i ) > $up ) { next; }
			$_ = &ugVar( $ug, $i );
			$_ = HTMLescape($_);
			$_ =~ s/\|x\|/\n<BR>/g;
			print qq~<tr><td width="30%">
			<b>$i</b> ( $gField{$i} )</td><td width="70%">$_<BR><BR>
			</td></tr>~;
		}
		print q~</table><BR><BR>~;
	}
	print q~<hr size="10"><BR><BR>~;
	print $ugindex;
	foreach $ug (sort @usernames) {
		print qq~<a name="$ug"></a>
		<table width="100%" align="center" cellpadding="1" cellspacing="1" border="1" bordercolor="#000000">
		<tr><td colspan="2">
		<BR><h2>Specified User Properties for $ug</h2><BR></td></tr>~;
		foreach $i (keys %uField) {
			if( &MinEditLevel( 1, $i ) > $up ) { next; }
			$_ = &ugVar( $ug, $i );
			$_ = HTMLescape($_);
			$_ =~ s/\|x\|/\n<BR>/g;
			print qq~<tr><td width="30%">
			<b>$i</b> ( $uField{$i} )</td><td width="70%">$_<BR><BR>
			</td></tr>~;
		}
		print qq~<tr><td colspan="2">
		<BR><h4>Properties Overridden / Inherited from Groups for $ug</h4><BR>
		</td></tr>~;
		foreach $i (keys %gField) {
			if( &MinEditLevel( 0, $i ) > $up ) { next; }
			unless( $uField{$i} ) { next; }
			$_ = &inheritedVar( $ug, $i );
			$_ = HTMLescape($_);
			$_ =~ s/\|x\|/\n<BR>/g;
			print qq~<tr><td width="30%">
			<b>$i</b> ( $uField{$i} )</td><td width="70%">$_<BR><BR>
			</td></tr>~;
		}
		print q~</table><BR><BR>~;
	}
	print $ugindex;
	&NPHTMLFoot;
	exit;
}

##############################################
# Main Page
#		(NO PARAMATERS PASSED)
#		Execute other subroutines if appropriate,
#		or display the list of groups and users for editing, etc
#
sub UserGroupsMain {
	&UGStartup;
	if ($in{'editgroup'}) {
		&UserGroupsEditGroup;
		exit;
	}
	elsif ($in{'editUGsettings'}) {
		&NPHTMLHead("UserGroups Edit Settings");
		print qq~Listed here are all the settings you may edit
		for addons associated with UserGroups<BR><HR width="75%"><BR>
		<form action="$scripturl?usergroups" method="POST">
		<table align="center" width="80%">~;
		if (@Addons_UGEditSettings) {
			&RunAddons(@Addons_UGEditSettings);
		}
		print q~<tr><td colspan="9" align="center">
		<input type="submit" name="saveUGsettings" value="Save All Settings">
		</td></tr></table></form>~;
		&NPHTMLFoot;
		exit;
	}
	elsif ($in{'saveUGsettings'}) {
		&NPHTMLHead("UserGroups Save Settings");
		print q~Saving all settings...<BR><HR width="75%"><BR>
		<table align="center" width="80%">~;
		if (@Addons_UGSaveSettings) {
			&RunAddons(@Addons_UGSaveSettings);
		}
		print qq~
		<tr><td align="center">
		<h3><a href="$scripturl?usergroups">Back to UserGroups</a></h3>
		</td></tr>
		</table>~;
		&WriteConfigInfo;
		&NPHTMLFoot;
		exit;
	}
	elsif ($in{'edituser'}) {
		&UserGroupsEditUser;
		exit;
	}
	elsif ($in{'showuser'}) {
		&UserGroupsShowUser;
		exit;
	}
	&NPHTMLHead("UserGroups");
	if ($in{'editusersave'}) {
		&UserGroupsSaveUser;
	}
	if ($in{'editgroupsave'}) {
		&UserGroupsSaveGroup;
	}
	if ($in{'newgroup'} && $up > 2) {
		$in{'newgroup'} =~ s/\W//g;
		unless (	exists $CPassword{$in{'newgroup'}} ||
				exists $usergroups{$in{'newgroup'}} ||
				$in{'newgroup'} eq "") {
			&ugVarSetValue($in{'newgroup'},'DESC',qq~Created by $Cookies{'uname'}~);
		}
		&UserGroupsSaveConfig;
	}
	if ($in{'removegroup'} && $up > 2) {
		if ( exists($usergroups{$in{'groupname'}}) ) {
			delete $usergroups{$in{'groupname'}};
		}
		&UserGroupsSaveConfig;
	}

	print qq~<div align="center"><form action="$scripturl?usergroups" method="POST">
	<h3>Group Manager</h3><table width="80%" border="0" bordercolor="#000000" cellpadding="10">
	~;
	my $counter = 0;
	my $selectfirst = 'checked';
	foreach $i (sort keys %usergroups) {
		if( exists $CPassword{$i} ) { next; }
		print qq~
		<td width="150"><div align="left">
			<input type="radio" name="groupname" value="$i" $selectfirst> $i</div>
		</td>
		~;
		$counter++;
		$selectfirst = '';
		unless( $counter % 3 ) { print "</tr><tr>"; }
	}

	unless( $selectfirst ) {
		my $remgrouptext = ( $up < 3 ) ? '' : q~<td width="15%" align="right"><input type="submit" name="removegroup" value="Remove Group"></td>~;
		print qq~<tr>
		<td width="100%" align="middle"><input type="submit" name="editgroup" value="Edit Properties Of The Selected Group"></td><BR><BR>
		$remgrouptext
		</tr></table>
		~;
	}
	my $addgrouptext = ( $up < 3 ) ? '' :
	q~<b>Add new group:</b>
	<input type="text" name="newgroup" value=""><input type="submit" name="addgroup" value="Add Group">
	<BR>~;
	print qq~
	$addgrouptext
	<HR width="75%"><BR><BR>
	<h3>User Manager</h3>
	<table width="80%" border="0" bordercolor="#000000" cellpadding="10" cellspacing="0" border="0"><tr>
	~;
	$counter = 0;
	$selectfirst = 'checked';
	foreach $i (sort @usernames) {
		unless( $up > 2 || $Cookies{'uname'} eq $i ) { next; }
		print qq~
		<td width="150"><div align="left">
			<input type="radio" name="username" value="$i" $selectfirst> $i</div>
		</td>
		~;
		$counter++;
		$selectfirst = '';
		unless( $counter % 3 ) { print "</tr><tr>"; }
	}
	unless( $selectfirst ) {
	print q~
		<tr><td colspan="3" align="center">
			<input type="submit" name="edituser" value="Edit Selected User">
		</td></tr>
		<tr><td colspan="3" align="center">
			<input type="submit" name="showuser" value="Show Selected User">
		</td></tr>
	~;
	}
	print q~
	</table><BR><HR width="75%"><BR>
	~;
	if( $up > 2 ) {
		print qq~
		<input type="submit" name="editUGsettings" value="Edit Various UserGroups Settings"><BR><BR>
		</form>
		<a target="usergroupsva" href="$scripturl?usergroups/viewall">View All User &amp; Group Properties</a><BR>
		</div>
		~;
	}
	&NPHTMLFoot;
}

##############################################
# Save to ugsettings.cgi
#		(NO PARAMATERS PASSED)
#
sub UserGroupsSaveConfig
{
	&UGWriteHashFile(\%usergroups,'ugsettings.cgi');
	$uggloaded = 1;
}

##############################################
# Load from ugsettings.cgi
#		(NO PARAMATERS PASSED)
#		Also, assemble all user properties for
#		faster access...
#
sub UserGroupsLoadConfig
{
	&UGReadHashFile(\%usergroups,'ugsettings.cgi');
	$uggloaded = 1;
	&AssembleAllUsersProperties;
}

##############################################
# FIRST TIME ONLY
# Call UserGroupsLoadConfig
# FIRST TIME ONLY
#
#		(NO PARAMATERS PASSED)
#
sub UGStartup
{
	unless( $uggloaded ) { &UserGroupsLoadConfig; }
}

##############################################
# Save hash to the file nsetname
#		USAGE: &UGWriteHashFile( \%HASHREFERENCE, FILENAME )
#		(*) separates properties
#		``x separates the user/group name and the list of properties
#		|x| acts as the delimiter in all lists
#
sub UGWriteHashFile
{
	my ( $hashref, $nsetname ) = @_;
	my ( $varval, $nsetpath ); 
	if ($abspath)
	{
		$nsetpath = "$abspath/";
	}
	$nsetpath .= $nsetname;
	if( -d $nsetpath ) { &NPdie(qq~UserGroups can't find or access file $nsetpath because
		there is a directory in the specified location by the same name~); }
	NPopen('NPCFG', ">$nsetpath");
	while( ($key,$value) = each(%$hashref) )
	{
		$varval = join( '(*)', values %$value );
		$varval =~ s/``x/` ` x/g;
		$varval =~ s/^\s+//;
		$varval =~ s/\s+$//;
		$varval =~ s/\n//g;
		$varval =~ s/\r//g;
		if ( defined $key ) {
			print NPCFG "$key``x$varval\n";
		}
	}
	close(NPCFG);
}

##############################################
# Read hash from the file nsetname
#		USAGE: &UGReadHashFile( \%HASHREFERENCE, FILENAME )
#		(*) separates properties
#		``x separates the user/group name and the list of properties
#		|x| acts as the delimiter in all lists
#
sub UGReadHashFile
{
	my ( $hashref, $nsetname ) = @_;
	my ( $varname, $varvalue, @varr, $nsetpath );
	if ($abspath)
	{
		$nsetpath = "$abspath/";
	}
	$nsetpath .= $nsetname;
	if( -d $nsetpath ) { &NPdie(qq~UserGroups can't find or access file $nsetpath because
		there is a directory in the specified location by the same name~); }
	unless( -e $nsetpath ) { NPopen('NPCFG', ">$nsetpath"); print NPCFG '';close(NPCFG); }
	NPopen('NPCFG', $nsetpath);
	my @gdom = <NPCFG>;
	close(NPCFG);
	foreach $i (@gdom)
	{
		($varname, $varvalue) = split(/``x/, $i);
		$varvalue =~ s/^\s+//;
		$varvalue =~ s/\s+$//;
		$varvalue =~ s/\n//g;
		$varval =~ s/` ` x/``x/g;
		@varr = split( /\(\*\)/, $varvalue );
		$$hashref{$varname} = ();
		foreach $k (@varr)
		{
			$k =~ m~(.*?):.*~o;
			$$hashref{$varname}->{$1} = $k;
		}
	}
}

##############################################
# Determine whether or not to display the UserGroups Main Page
#		(NO PARAMATERS PASSED)
#
sub UserGroups_PageHandler {
	if (query_string() eq 'usergroups') {
		&UserGroupsMain;
		exit;
	}
	elsif ( query_string() eq 'usergroups/viewall' ) {
		&UserGroupsViewAll;
	}
}

##############################################
# Display the UserGroups link at the bottom of all pages
#		(NO PARAMATERS PASSED)
#
sub UserGroups_HTMLFoot {
	print qq~ <a href="$scripturl?usergroups" class="navlink">UserGroups</a> |~;
}

##############################################
# Display the UserGroups link on the Main Page
#		(NO PARAMATERS PASSED)
#
sub UserGroups_MainPage {
	print qq~
	<b><a href="$scripturl?usergroups">UserGroups</a>:</b> Manage users as groups - not a good standalone, but can be used for a variety of purposes by other addons.<br><br>
	~;
}

##############################################
# Check the build of UserGroups to make sure it can be
#		safely used by other addons
#		USAGE: &ugCheckBuild( MINIMUM_BUILD_NUMBER, ADDONNAME, ADDONFILE )
#
sub ugCheckBuild {
	my $requiredBuild = shift;
	if ($requiredBuild > $ugBuild) {
		my $addonName = shift;
		my $addonFile = shift;
		NPdie("An installed addon, $addonName, is not compatible with this version of UserGroups. You must either get a newer version of UserGroups or remove this addon by deleting $addonFile.");
	}
}

sub UGPChooseField {
	unless( $up > 2 ) { return 1; }
	&SubmitFormFields;
	print q~
		<tr><td><h4><center>UGP PROPERTIES FIELD</center></h4>
			For most people, the UGPField should be
			"newsname" - although others may wish to specify
			another variable.<BR><BR>
			If, for example, you want to display the ICQ number
			of the user whose name appears in the field 'uservar1'
			then you would either select uservar1 from the list
			or type it in the text box.<BR><BR>
			This would cause the $UGP_ICQ variable
			to contain the ICQ number of whomever's name is
			in the uservar1 variable.<BR><BR>
		</td><td valign="middle"><select name="UGPSelect">
	~;
	my ($i, $selected);
	my $default = $NPConfig{'UGPField'} || 'newsname';
	foreach $i (@formfields) {
		if( $default eq $i ) { $selected = 'selected'; }
		else { $selected = ''; }
		print qq~<option value="$i" $selected>$i</option>~;
	}
	print qq~</select>
	<input type="text" name="UGPSpecify" value="$default"></td></tr>
	~;
}

sub UGPSaveField {
	unless( $up > 2 ) { return 1; }
	my ($spec,$sel) = ( $in{'UGPSpecify'}, $in{'UGPSelect'} );
	if( $sel && $sel ne $NPConfig{'UGPField'} ) {
		$NPConfig{'UGPField'} = $sel;
	}
	elsif( $spec ) {
		$NPConfig{'UGPField'} = $spec;
	}
	else {
		$NPConfig{'UGPField'} = 'newsname';
	}
	print qq~<tr><td>UGPField = $NPConfig{'UGPField'}</td></tr>~;
}


unless( $NPConfig{'UGPField'} ) {
	$NPConfig{'UGPField'} = 'newsname';
	&WriteConfigInfo;
}
1;
#####################################################
package Tie::UGPROP;
sub TIESCALAR {
	my $class = shift;
	my $self = [@_];
	return bless $self => $class;
}

sub FETCH {
	my $self = $_[0];
	return &{"main::$$self[1]"}( ${"main::$$self[2]"}, $$self[0] );
}

sub STORE {
	return;
}

sub DESTROY {
	my $self = $_[0];
	@$self = ();
}
1;
#####################################################