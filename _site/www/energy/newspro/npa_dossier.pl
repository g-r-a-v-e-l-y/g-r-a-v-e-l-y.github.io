#	Dossier : "User Information" for UserGroups
#		((requires the UserGroups Addon))
#	by plushpuffin@yahoo.com
#	http://plushpuffin.virtualave.net
#

#
#
#
##############################################
#	How to use Dossier's properties
##############################################
#
#	For every property of dossier, you can
#	access it from anywhere in newspro:
#
#	$UGV_PROPERTYNAME
#	$UGP_PROPERTYNAME
#
#	UGV_ means the property for the currently
#	logged in user.
#
#	UGP_ means the property of the user whose
#	name is in the variable $newsname. You may
#	use a different variable if you don't want
#	to use $newsname - just look in the settings
#	page for UserGroups.
#
#	You should always use the UGP_ properties
#	in your DoNews subroutines, and the UGV_
#	properties when you are doing things with
#	the newspro interface itself.
#
#	The two properties defined by default
#	are ICQ and URL
#
#

push(@Addons_Loaded, 'Dossier 1.0');
$Addons_List{'Dossier 1.0'} = ['npa_dossier.pl', 'Extended User Information'];

##############################################
# Define Dossier's user information fields
#
$uField{'ICQ'} = q~ICQ Number~;
$uField{'URL'} = q~Home Page~;

##############################################
# Make sure that the form elements for Dossier
# are displayed on the User editing pages
#
push(@Addons_UGEditUser, q~DossierUGEdit~);

##############################################
# Make sure that Dossier's properties can be 
# edited by normal users
#
$uMinEditLevel{'ICQ'} = 1;
$uMinEditLevel{'URL'} = 1;

sub DossierUGEdit {
	my $temp = &ugVar( $ug, 'ICQ' );
	print qq~<tr><td>
	$uField{'ICQ'}<BR><BR>Please enter your ICQ Number.<BR>
	Current ICQ # is $temp</td><td>
	<input type="text" name="ICQ" value="$temp" size="10" maxlength="15">
	</td></tr>
	~;
	$temp = &ugVar( $ug, 'URL' );
	print qq~<tr><td>
	$uField{'URL'}<BR><BR>Please enter the URL of your home page.<BR>
	Current URL is $temp</td><td>
	<input type="text" name="URL" value="$temp" size="60">
	</td></tr>
	~;
}