$npconfigversion = 3;
# npconfig.pl
# This file is designed to make advanced customizations easier.
# The various settings in this file control most aspects of NewsPro.
# To change the style of your news, edit ndisplay.pl.

# NOTE: This file used to contain the Advanced Settings definition.
# This has been moved to newspro.cgi as of version 2.

sub SubmitFormFields {
# This sets the different fields in newsdat.txt that you can submit via the Submit News
# page.
# To add a field, add its internal name (no spaces or odd characters) to 
# @formfields.
# You will probably want to give the field a nicer name (spaces allowed):
# $FormFields{'internal_form_name'} = "Full form name.";
# where internal_form_name is the same as in @formfields.

# Normally, a standard text field will be used for that field. If you need
# to use different HTML, use the following:
# $FormFieldsCustom{'internal_form_name'} = qq~ The HTML you want ~;
# Note: the main news text box cannot be configured this way, it's hard-coded.

# While custom HTML will not apply in Modify News, there is the option to use
# a multi-line text box (<textarea>) rather than a single-line text box. Use:
# $FormFieldsModifySize{'internal_form_name'} = 1;

# To have a form field convert newlines (when you press Enter) into <br>, use:
# $FormFieldsNewlines{'internal_form_name'} = 1;
# This is only useful if you also use custom HTML for a multi-line text box, e.g.
# $FormFieldsCustom{'uservar1'} = qq~ <textarea name="uservar1" wrap="virtual"></textarea> ~;

# To use the built-in empty user variables, simply add 'uservar1' and 'uservar2' to
# the end of @formfields. Uservar1 and uservar2 are already included in the database, however
# if you need to add any of your own variables to the database, edit
# SplitDataFile and JoinDataFile as well.
# Example:
# @formfields = ('newsname','newsdate','newsemail','newssubject','uservar1','uservar2');

# $DisableModify{'internal_form_name'} controls whether a field can be modified.
# If it is set to 1, the field cannot be modified.
# If it is set to 2, basic users cannot modify it (webmaster users and users with full remove can)

@formfields = ('newsname','newsdate','newsemail','newssubject');
$FormFieldsName{'newsname'} = "Name";
$FormFieldsCustom{'newsname'} = $Cookies{'uname'};
$DisableModify{'newsname'} = 1;
$FormFieldsName{'newsdate'} = "Date";
$FormFieldsCustom{'newsdate'} = GetTheDate();
$DisableModify{'newsdate'} = 1;
$FormFieldsName{'newsemail'} = "E-mail";
$FormFieldsCustom{'newsemail'} = qq~<input type="text" name="newsemail" value="$Email{$Cookies{'uname'}}" size="45">~;
$FormFieldsName{'newssubject'} = "Subject";
}
sub SplitDataFile {
# Splits an entry from newsdat.txt into its different variables. You can edit this if you need 
# to add fields to the database. Make sure to edit JoinDataFile as well.
# In general, don't change the separator (``x).
# Do NOT change the order of the existing items, or place any new variables
# before the existing items. You can only add items to the END of the list.
local ($splitdatafile) = @_;
# Remove all newlines from string.
$splitdatafile =~ s/\n//g;
# The following is the line you want to edit if you need to change database fields:
($uservar3, $newstext, $newsname, $newsemail, $newssubject, $newsid, $uservar1, $uservar2) = split(/``x/, $splitdatafile);
@newsarray = split(/``x/, $splitdatafile);
return @newsarray;
}
sub JoinDataFile {
# Like SplitDataFile above, except joins different variables before printing them to newsdat.txt
# as one line.
# The order of items must be the same as in SplitDataFile.
$joinline = join('``x',$uservar3, $newstext, $newsname, $newsemail, $newssubject, $newsid, $uservar1, $uservar2);
return $joinline;
}
1;
