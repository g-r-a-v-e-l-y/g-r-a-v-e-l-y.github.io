#!/usr/bin/perl
# Change the line above the reflect the path to Perl,
# as described in readme.txt
# BY RUNNING THIS SCRIPT, YOU AGREE TO THE LICENSE
# BELOW.
# See readme.txt for setup instructions.
# ******  SETTINGS ******
# ** FILE LOCKING **
# File locking is a feature, provided by the operating system, which
# prevents possible serious problems when NewsPro is being used by
# multiple users. Almost every operating system supports this, except
# for Windows 9x. Possible settings:
# 2  Enable file locking. If you know your server supports it, set
#	UseFlock to this.
# 1  Auto-detect file locking support (default).
# 0  Disable file locking. This may result in file corruption.
$UseFlock = 1;
# If you are using Microsoft IIS, set the following to 1. If you are
# using Unix/Apache, set it to 2. Setting it 0 tries to determine
# automatically, and usually works just fine; don't change it unless
# you have problems. If you use IIS yet have 500 error problems, 
# try setting the variable to 2, then try 3.
$IIS = 0;
# It is possible to view NewsPro's configuration without logging in - this is
# a debugging and problem-solving feature. No usernames or passwords are revealed.
# It is recommended that you leave this on, but it is possible to turn this off
# by setting this to 0.
$DebugFeatures = 1;
# END OF SETTINGS (unless you encounter problems - then fill out the next section)
# SERVER PROBLEMS WORKAROUNDS
# If the script either gets its URL wrong or produces a fatal error
# about not being able to include npconfig.pl, set the following variables.
# While it won't hurt, most users don't have to.
$abspath = '';
# Set the above to the absolute path to NewsPro's directory, without
# a trailing slash. Example:
# $abspath = '/absolute/path/to/newspro';
$scripturl = '';
# Set the above to the URL to newspro.cgi. Example:
# $scripturl = 'http://www.myserver.com/newspro/newspro.cgi';
# Once again, you only need to set the above two variables if you're
# having server problems.
# END SERVER PROBLEMS WORKAROUNDS
=pod
                     ******NewsPro******                               
                       Version: 3.7.5   
                       
######### LICENSE INFORMATION ###########                       
                                                                       
Copyright Amphibian Internet.                                         
All Rights Reserved.                                                  
This software is currently FREE (of charge). 
It cannot, however be used by sites with illegal or pornographic 
content. Pricing may change in the future.
You are free to modify this script in any way you                     
please. However, you MAY NOT REDISTRIBUTE NewsPro in any form.        
This includes modified and unmodified versions, and applies whether   
or not you would charge a fee.       
Commercial sites using NewsPro MUST place a link to the NewsPro site
on their main news site. The DisplayLink setting (in Advanced Settings)
will do this occasionally, but in some scenarios the link must be added
manually.
This software is provided without warranty. Or, in legal language:
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR 
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                                                                       
Website: http://amphibian.gagames.com/newspro/                       
Email: newspro@amphibian.hypermart.net                               
######### END LICENSE INFORMATION ###########
=cut
                                    
#######
# START NEWSPRO ITSELF
#######
#######
# ERROR HANDLING
#######
unless ($JustLoadSubs) {
# This should trap just about every error.
eval { &main; };
if ($@) {
&NPdie("Untrapped Error: $@");
}
exit;
}
#######
# ADVANCED SETTINGS DEFINITION
#######
sub AdvancedSettingsLoad {
@advancedsettings = ('CommercialUser' , 'DisplayLink' , 'draw_line', 'TimeOffset', 'AutoBuild' , 'AutoLinkURL', 'ShowNewsControls', 'EnableGlossary' , 'draw_line', 'NumberLimit' , 'EnableHeadlines' , 'HeadlineNumber' , 'ArchiveNumber', 'ArcHtmlExt', 
	'EnableBROption', 'Modify_ItemsPerPage' , 'MaxSearchResults' , 'CheckFileTime' , 'CreateAnchors', 
	'draw_line', 'DisableHTML', 'BasicLayout');
$AdvDescr{'AutoBuild'} = "Automatically build news after submitting or modifying news?";
$AdvDescr{'DisplayLink'} = qq~ Display a link to the NewsPro home page after your news? Commercial users must leave this on, or add a link to their news page manually. It is completely optional for non-commercial sites (though it would be nice!). Finally, this link is only added automatically to your news.txt file. If you are a commercial user and do not use news.txt to display your news, you must manually add a link to your page.~;
$AdvDescr{'CommercialUser'} = "Commercial sites must set this to Yes. Any site which sells a product, promotes a company, or is owned and operated by a for-profit corporation is considered commercial. Ad banners placed by a web host do not make a site commercial, however any paid ads placed by the site owner do make a site commercial.";
$AdvDescr{'CheckFileTime'} = "Check if newsdat.txt has been modified between the two steps of Modify News? Set this to No if you receive &quot;file has been modified&quot; errors unnecessarily.";
$AdvDescr{'ArcHtmlExt'} = "Extension of archive HTML files. (no period, just the extension)";
$AdvDescr{'ArchiveNumber'} = "Allows you to archive by number of news items instead of by time, i.e. have each archive page have 20 items. To do this, set this setting to the number of news items on each archive page, and make sure that you have archiving enabled and set to Monthly via Change Settings. To archive normally, set this to 0.";
$AdvDescr{'EnableGlossary'} = "Enable the Glossary feature? This will result in a Edit Glossary option for Webmaster users and a Glossary On/Off button on the Submit page. The Glossary allows you to replace a certain piece of text with another automatically, i.e. the name of your site with a link to your site.";
$AdvDescr{'TimeOffset'} = "Set this to the difference in hours between you (or the time you want displayed) and your server. For instance, if you live in Boston and your server is in London, set this to -5.";
$AdvDescr{'NumberLimit'} = "If, instead of choosing which articles to display on your main news page by time, you'd like to display a certain fixed number and archive/delete the rest, set this to that number. If NumberLimit is set, it will override any NewsAge time you set on the main Change Settings page.";
$AdvDescr{'EnableHeadlines'} = "Automatically write a list of your headlines to headlines.txt when you build news? You can change the format of the headlines by editing ndisplay.pl.";
$AdvDescr{'HeadlineNumber'} = "The number of headlines to include in your headlines file. Set to 0 to include all the news on your main page.";
$AdvDescr{'Modify_ItemsPerPage'} = "The number of news items that are displayed at once on a Modify News page";
$AdvDescr{'AutoLinkURL'} = "Automatically change a URL into a link?";
$AdvDescr{'ShowNewsControls'} = "Shows some news controls at the bottom of your main news page (news.txt): search news, view all news, and if e-mail notification is enabled allows users to subscribe/unsubscribe. This does not modify the output of viewnews.cgi. While the default controls cannot be edited, you can copy the HTML for the controls into your own page and edit them there.";
$AdvDescr{'CreateAnchors'} = "Creates an &lt;a name&gt; tag with the news item's ID number along with each news item. Do not disable unless your news style somehow prevents you from using these.";
$AdvDescr{'BasicLayout'} = "Uses a very simple, black-and-white layout for NewsPro script pages. Does not affect any generated news files, only the look and feel of newspro.cgi.";
$AdvDescr{'DisableHTML'} = "Remove all HTML tags from submitted news items?";
$AdvDescr{'MaxSearchResults'} = "The maximum number of news items returned as results in a search (using viewnews.cgi).";
$AdvDescr{'EnableBROption'} = "Adds the option whether or not to convert line breaks to &lt;br&gt; upon submission to the Submit News page. If this option is off, no option will be given and line breaks will always be converted to &lt;br&gt;. (This will ONLY work on English copies of NewsPro) ";
# The following controls which settings are yes/no (1/0) and which aren't.
%AdvYesNo = ('AutoBuild' => '1',
			'DisplayLink' => '1',
			'CommercialUser' => '1',
			'CheckFileTime' => '1',
			'Display_Week_Day' => '1',
			'Display_Month' => '1',
			'Display_Month_Day' => '1',
			'Display_Year' => '1',
			'Display_Time' => '1',
			'Display_Time_Zone' => '1',
			'12HourClock' => '1',
			'EnableGlossary' => '1',
			'EnableHeadlines' => '1',
			'UseCookies' => '1',
			'ShowNewsControls' => '1',
			'WrapEmailText' => '1',
			'CreateAnchors' => '1',
			'DisableHTML' => '1',
			'BasicLayout' => '1',
			'EnableBROption' => '1',
			'AutoLinkURL' => '1');
if (@Addons_AdvancedSettingsLoad) {
	&RunAddons(@Addons_AdvancedSettingsLoad);
}
}
sub StartUp {
	# Version number. Do NOT change! Used internally!
	$npversion = '3.7.5';
	# Build number. Also, do not change!
	$npBuild = 31;
	# Auto-detect flock support, if necessary
	if ($UseFlock == 1) {
		if ($^O ne 'MSWin32') {
			$UseFlock = 1;
		}
		else {
			if ($ENV{'PATH'} =~ /WINNT/i) { # Yes, this won't work if you didn't use the default name
						       # for your Windows directory. But the alternative is loading
						       # the Win32 module, which is time-consuming.
				$UseFlock = 1;
			}
			else {
				# We appear to be on Windows 9x.
				$UseFlock = 0;
			}
		}
	}
	elsif ($UseFlock == 2) {
		$UseFlock = 1;
	}
	# Server problem workaround #1
	if ($abspath) {
		push(@INC, $abspath);
	}
	# Require npconfig.pl
	require "npconfig.pl";
	# Require nplib.pl
	require "nplib.pl";
	# Location of ndisplay.pl (required in GenHTML)
	$ndisplaypl = "ndisplay.pl";
	# Put the script's URL into $scripturl.
	# Don't if it was already set as a server problem workaround.
	unless ($scripturl) {
		$scripturl = &GetScriptURL;
	}
	# Get form input
	&ReadForm;
	unless ($npconfigversion == 3) {
		&NPdie('You are using an out-of-date version of npconfig.pl. Visit <a href="http://amphibian.gagames.com/newspro/">the NewsPro homepage</a> and download a newer version.');
	}
	unless ($nplibBuild == 8) {
		&NPdie('Your nplib.pl and newspro.cgi files are mismatched -- that is, they come from different versions or builds of NewsPro. Visit <a href="http://amphibian.gagames.com/newspro/">the NewsPro homepage</a>, download a new copy of NewsPro, and upload new versions of newspro.cgi and nplib.pl.');
	} 
	unless ($nplangversion == 3.7) {
		&NPdie('You are using an out-of-date version of nplang.pl. Visit <a href="http://amphibian.gagames.com/newspro/">the NewsPro homepage</a> and download a newer version of NewsPro.');
	}
}
sub main {
# Microsoft servers. Try and be compatible...
if ($IIS != 2) {
	if ($IIS == 0) {
		if ($ENV{'SERVER_SOFTWARE'} =~ m!IIS!) {
			$IIS = 1 
		}
	}
	if (($IIS) && ($0 =~ m!(.*)(\\|\/)!)) {
		chdir($1);
	}
	if ($IIS == 1) {
		print "HTTP/1.0 200 OK\n";
	}
}
# That's over!
StartUp();
$qstring = query_string();
# Now, look at the query string and decide what to do.
# Log the user out.
if ($qstring eq "logout") {
	&ClearCookies;
	$HeaderPrinted = 1;
	&NPHTMLHead($Messages{'Section_LogOut'});
	print $Messages{'LogOut_Message'};
	&NPHTMLFoot;
	exit;
}
# Save initial setup.
if ($qstring eq "firsttimesave") {
	&FirstTimeSave;
}
# Debugging feature: show configuration (no passwords are displayed).
if ($qstring eq "showconfig") {
	print header();
	if ($DebugFeatures) {
		&ReadConfigInfo;
		$thetime = time;
		print "<html><body>time: $thetime<br>\nversion: $npversion<br>\nbuild: $npBuild<br>\n";
		foreach $key (keys %NPConfig) {
			unless ($key eq "userdata" || $key eq "emaillist" || $key eq "glossdat") {
				print "$key: $NPConfig{$key}<br>\n";
			}
		}
		@users = split (/\|/, $NPConfig{'userdata'});
		foreach $i (@users) {
		($username, $password, $email, $permissions) = split (/~/, $i);
		$CPassword{$username} = $password;
		$Email{$username} = $email;
		$UserPermissions{$username} = $permissions;
		push (@usernames, $username);
		}
		print "<br>\n";
		print "</body></html>";
	}
	else {
		print "The debugging features have been disabled.";
	}
	exit;
}
# Debugging feature: show newsdat.txt
if ($qstring eq "shownewsdat") {
	print header();
	if ($DebugFeatures) {
		open(ND, "newsdat.txt");
		@nd = <ND>;
		close(ND);
		$nd = join('<br>', @nd);
		print $nd;
	}
	else {
		print "The debugging features have been disabled.";
	}
	exit;
}
# Check if the user is logged in. If not, display login screen.
&CheckLogin;
# Make sure that the "firsttime" variable is set to no, otherwise people can set up
# the script via the web.
if ($NPConfig{'firsttime'} eq "yes") {
&WriteConfigInfo;
}
if ($qstring eq "upgradendisp") {
	&UpgradeFrom12Finish;
}
if ($qstring eq "upnd3") {
	&UpgradeND3Save;
}
# Check to see if the user has just upgraded to a newer version.
if ($NPConfig{'currentversion'} ne $npversion || $NPConfig{'currentbuild'} ne $npBuild) {
	&UpgradeHandler;
}
# Save settings from Change Settings.
if ($qstring eq "settingssave") {
	unless ($NPConfig{'showreadme'} eq "yes") {
		print header();
	}
	&ChangeSettingsSave;
}
# Load any add-ons
&LoadAddons;
if (@Addons_PreHeader) {
	&RunAddons(@Addons_PreHeader);
}
# Print the content-type header.
print header();
# Handle any addon pages
if (@Addons_PageHandler) {
	&RunAddons(@Addons_PageHandler);
}
if ($NPConfig{'DisableNewsPro'}) {
	NPdie("NewsPro has been disabled. Reason: $NPConfig{'DisableNewsPro'}.");
}
# Submit News
if ($qstring eq "submit") {
	&DisplaySubForm;
}
# Save submitted news
elsif ($qstring eq "submitsave") {
	&SaveNews;
}
# Build News
elsif ($qstring eq "generate") {
	&GenHTML;
}
# Modify News
elsif ($qstring =~ /^remove(\d*)$/) {
	&RemoveNews($1);
}
# Save modified news
elsif ($qstring eq "removesave") {
	&RemoveNewsSave;
}
# Change settings
elsif ($qstring eq "settings") {
	&ChangeSettings;
}
# Advanced Settings
elsif ($qstring eq "advset") {
	&AdvancedSettings;
}
# Save advanced settings
elsif ($qstring eq "advsetsave") {
	&AdvancedSettingsSave;
}
# Edit Users
elsif ($qstring eq "adduser") {
	&UserAdd;
}
# Save user edits
elsif ($qstring eq "addsave") {
	&UserAddSave;
}
# Change User Info
elsif ($qstring eq "userinfo") {
	&ChangeUserInfo;
}
# Save changed user info
elsif ($qstring eq "userinfosave") {
	&ChangeUserInfoSave;
}
# Edit Glossary
elsif ($qstring eq "editgloss") {
	&EditGlossary;
}
# Save glossary changes.
elsif ($qstring eq "glosssave") {
	&EditGlossarySave;
}
# Display help
elsif ($qstring =~ /^help(\S*)/) {
	&NPhelp($1);
}
# If no query-string command is given, show the main page.
else {
	&MainPage;
}
}
#######
# BEGIN SCRIPT SUBROUTINES
#######
#######
# PAGE DISPLAY SUBS
#######
# MainPage: Displays the main NewsPro page.
sub MainPage {
	&NPHTMLHead($Messages{'Section_Main'});
	my $addons;
	if ($AddonsLoaded) { 
		if (@Addons_Loaded) {
			$addons = join(', ', @Addons_Loaded);
		} else {
			$addons = "None.";
		}
	} else {
		$addons = "Click Main Page below to load addons.";
	}
	print qq~
	<p>$Messages{'MainPage_Welcome'} $Cookies{'uname'}! $Messages{'MainPage_Choose'}<br> $Messages{'MainPage_LangWarning'}
	<b><a href="$scripturl?submit">$Messages{'Section_Submit'}</a>:</b> $Messages{'MainPage_Descriptions_Submit'}<br><br>
	<b><a href="$scripturl?generate">$Messages{'Section_Build'}</a>:</b> $Messages{'MainPage_Descriptions_Build'}
	~;
	unless ($NPConfig{'AutoBuild'}) { print	$Messages{'MainPage_Descriptions_Build_NoAuto'}; }
	print qq~ 
	<br><br>
	<b><a href="$scripturl?remove">$Messages{'Section_Modify'}</a>:</b> $Messages{'MainPage_Descriptions_Modify'} 
	~;
	if ($up == 1) { print $Messages{'MainPage_Modify_1'}; }
	else { print $Messages{'MainPage_Modify_2'}; }
	print qq~
	<br><br>
	<b><a href="$scripturl?userinfo">$Messages{'Section_UserInfo'}</a>:</b> $Messages{'MainPage_Descriptions_UserInfo'}<br><br>
	~;
	if ($up == 3) {
	print qq~
	<b><a href="$scripturl?settings">Change Settings</a>/<a href="$scripturl?advset">Advanced Settings</a>:</b> Webmaster users only. Change a wide variety of program settings.<br><br>
	<b><a href="$scripturl?adduser">Edit Users</a>:</b> Add or remove various NewsPro user accounts. You cannot remove other Webmaster users.<br><br>
	~;
	}
	if (@Addons_MainPage) {
		&RunAddons(@Addons_MainPage);
	}
	if ($NPConfig{'EnableGlossary'} && $up == 3) {
	print qq~
	<b><a href="$scripturl?editgloss">Edit Glossary</a>:</b> Edit the Glossary, which allows you to replace a certain piece of text with another while submitting.<br><br>
	~;
	} 
	
	print qq~
	<b><a href="$scripturl?logout">$Messages{'Section_LogOut'}</a>:</b> $Messages{'MainPage_Descriptions_LogOut'}<br><br>
	<small>$Messages{'MainPage_YourVersion'} $npversion (Build $npBuild) $Messages{'MainPage_CurrentVersion'} <a href="http://amphibian.gagames.com/newspro/"><img src="http://amphibian.gagames.com/newspro/npversion.cgi?$npversionfull" width="60" height="12" border="0"></a>
	~;
	if ($up == 3) {
	print qq~<a href="http://amphibian.gagames.com/upgrade.cgi?$npversion">$Messages{'MainPage_Upgrade'}</a><br>
	$Messages{'MainPage_Addons'} (<a href="http://amphibian.gagames.com/newspro/members/addons.cgi">$Messages{'MainPage_Download'}</a>): $addons<br><a href="http://amphibian.gagames.com/newspro/">Visit the NewsPro Web page</a> <a href="http://amphibian.gagames.com/newspro/faq2/">or read the FAQ</a>.
	~;
	}
	print qq~
	</small></p>
	~;
	&NPHTMLFoot;
}
# NPHTMLHead: Displays the standard HTML header used by all script pages.
# If you'd like to change the look and feel of the script, edit the following two routines.
sub NPHTMLHead {
	local $title = shift;
	print qq~
	<html>
	<head>
	<title>$Messages{'NewsPro'}: $title</title>
	$Messages{'ContentType'}
	~;
	if ($NPConfig{'BasicLayout'} == 0) {
	print qq~
	<style type="text/css">
<!--
p {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt}
.navbar {  font-family: Arial, Helvetica, sans-serif; font-size: 9pt}
.navlink {  font-family: Arial, Helvetica, sans-serif; font-size: 9pt; color: #ffffff}
td {  font-family: Arial, Helvetica, sans-serif; font-size: 10pt}
A:hover { color: #ffffff; text-decoration: none}
.nptitle { }
.npcontent { }
.npfooter { }
-->
</style>
	~;
	}
	if (@Addons_NPHTMLHead_Head) {
		&RunAddons(@Addons_NPHTMLHead_Head);
	}
	print '</head>';
	if ($NPConfig{'BasicLayout'}) {
		print qq~
		<body>
		<center><h2>$NPConfig{'SiteTitle'}: $title</h2></center>
		<table width="85%" border=1 align="center"><tr><td>
		~;
	} else {
	print q~<body bgcolor="#555555" text="#CCCCCC" link="#ffffff" vlink="#ffffff" alink="#ffffff">~;
	if (@Addons_NPHTMLHead) {
		&RunAddons(@Addons_NPHTMLHead);
	}
	print qq~
	<div align="center">
	  <table width="60%" border="1" bordercolor="#666666" cellpadding="4" cellspacing="0" align="center" class="nptitle">
	    <tr bgcolor="#aa0000"> 
	      <td>
	        <div align="center"><b><font face="Verdana, Arial, Helvetica, sans-serif" color="#ffffff">$NPConfig{'SiteTitle'}: $title</font></b></div>
	      </td>
	    </tr>
	  </table>
<br>
	  <table width="90%" border="1" bordercolor="#666666" cellpadding="8" cellspacing="0" align="center" class="npcontent">
	    <tr bgcolor="#000000"> 
      <td>
~;
	}
	$HTMLHeaderPrinted = 1;
}
# NPHTMLFoot: Displays the HTML footer used by all script pages.
sub NPHTMLFoot {
	unless ($qstring =~ /help/) {
		$qs = query_string();
		$qs =~ s/\?//g;
		print qq~ <p align="left"><small><a href="$scripturl?help$qs">$Messages{'HTMLFoot_Help'}</a></small></p> ~;
	
	}
	print qq~
	</td>
	    </tr>
	  </table>
	  <br>
	~;
	unless ($NPConfig{'BasicLayout'}) {
	print qq~<table width="60%" border="1" bordercolor="#666666" cellpadding="4" cellspacing="0" align="center" class="npfooter">
	    <tr bgcolor="#CC0000"> 
	      <td> 
	        <div align="center" class="navbar">
	~;
	} else {
		print q~<div align="center">~;
	}
	print qq~
	<a href="$scripturl" class="navlink">$Messages{'Section_Main'}</a> | <a href="$scripturl?submit" class="navlink">$Messages{'Section_Submit'}</a> | <a href="$scripturl?generate" class="navlink">$Messages{'Section_Build'}</a> | <a href="$scripturl?remove" class="navlink">$Messages{'Section_Modify'}</a> | <a href="$scripturl?userinfo" class="navlink">$Messages{'Section_UserInfo'}</a> <br>
	~;
	if ($up == 3) {
		print qq~ <a href="$scripturl?settings" class="navlink">Change Settings</a>(<a href="$scripturl?advset" class="navlink">Advanced Settings</a>) | <a href="$scripturl?adduser" class="navlink">Edit Users</a>~;
		if ($NPConfig{'EnableGlossary'} eq "1") {
			print qq~ | <a href="$scripturl?editgloss" class="navlink">Edit Glossary</a> ~;
		}
	
		print "<br>";
	}
	if (@Addons_NPHTMLFoot) {
		&RunAddons(@Addons_NPHTMLFoot);
	}
	if ($NPConfig{'SiteLink'}) {
		print " <a href=\"$NPConfig{'SiteLink'}\" class=\"navlink\">$Messages{'BackTo'} $NPConfig{'SiteTitle'}</a> |";
	}
	print qq~
			 <a href="$scripturl?logout" class="navlink">$Messages{'Section_LogOut'}</a>
	~;
	unless ($NPConfig{'BasicLayout'}) {
	print qq~</div>
	      </td>
	    </tr>
	  </table>
	  <p><small><font color="#666666">$Messages{'NewsPro'} $npversion</font></small></p>
	</div>
	~;
	} else {
	print "<p>$Messages{'NewsPro'} $npversion</p></div>";
	}
	print '</body></html>';
}
sub PrintNewsControls {
	my ($newscontrols, $vnurl);
	$vnurl = $scripturl;
	$vnurl =~ s/newspro\.(cgi|pl)/viewnews\.$1/i;
	$newscontrols = qq~
	<font size="-2"><form action="$vnurl?search" method="post">$Messages{'Controls_Search'} <input type="text" name="searchstring"><input type="submit" name="submit" value="Submit"></form>
	<a href="$vnurl?newsall">$Messages{'Controls_View'}</a></font><br>
	~;
	if ($NPConfig{'EnableEmail'}) {
		$newscontrols .= qq~
		<font size="-2">$Messages{'Controls_Email'}
		<form action="$vnurl?emaillist" method="post"><input type="text" name="npemail" value="$Messages{'Controls_EmailTextBox'}"><input type="submit" name="npsubscribe" value="$Messages{'Controls_Subscribe'}"><input type="submit" name="npunsubscribe" value="$Messages{'Controls_Unsubscribe'}">
		</font></form>
		~;
	}
	if (@Addons_NewsControls) {
		&RunAddons(@Addons_NewsControls);
	}
	return $newscontrols;
}
#######
# NEWS SUBMISSION SUBS
#######
# DisplaySubForm: Displays the Submit News page
sub DisplaySubForm {
	&GetTheDate();
	# Load form fields data from npconfig.pl
	&SubmitFormFields;
	&NPHTMLHead($Messages{'Section_Submit'});
	print qq~<form method="post" action="$scripturl?submitsave" name="submitnews">~;
	if (@Addons_DisplaySubForm) {
		&RunAddons(@Addons_DisplaySubForm);
	}
	# Display the form fields using npconfig.pl info
	print qq~
	<table width="98%" border="0" align="center">
	~;
	foreach $i (@formfields) {
		print qq~
		<tr>
	            <td width="30%"><b>
		~;
		if ($FormFieldsName{$i} ne '') {
			print $FormFieldsName{$i};
		} else {
			print $i;
		}
		print qq~:</b></td><td width="70%">~;
		if ($FormFieldsCustom{$i} ne '') {
			print $FormFieldsCustom{$i};
		} else {
			print qq~<input type="text" name="$i" size="45">~;
		}
		print "</td></tr>";
	}
	print "</table>";
	print qq~
	        <div align="center"><b>$Messages{'Submit_NewsText'}</b> <br>
	          <textarea name="newstext" cols="70" rows="15" wrap="VIRTUAL"></textarea>
	          <br>
	~;
	if (@Addons_DisplaySubForm_Post2) {
			&RunAddons(@Addons_DisplaySubForm_Post2);
	}
	# If the Glossary is enabled, show On/Off option.
	if ($NPConfig{'EnableBROption'}) {
		print qq~ Convert line breaks to &lt;br&gt;? Yes <input type="radio" name="broption" value="0" checked> No <input type="radio" name="broption" value="1">
		<br>
		~;
	}
	if ($NPConfig{'EnableGlossary'}) {
		print qq~ $Messages{'Submit_GlossaryOn'} <input type="radio" name="glossaryon" value="1" checked> $Messages{'Off'} <input type="radio" name="glossaryon" value="0">
		<br>
		~;
	}
	if (@Addons_DisplaySubForm_Post) {
		&RunAddons(@Addons_DisplaySubForm_Post);
	}
	    print qq~<br>
		<input type="submit" name="Submit" value="$Messages{'Submit'}">
	          <input type="reset" name="Submit2" value="$Messages{'Reset'}">
	        </div>~;
	if (@Addons_DisplaySubForm_Post3) {
		&RunAddons(@Addons_DisplaySubForm_Post3);
	}	
        print '</form>';
        if (@Addons_DisplaySubForm_Post4) {
		&RunAddons(@Addons_DisplaySubForm_Post4);
	}	
	&NPHTMLFoot;
}
# SaveNews: Saves a new news entry to newsdat.txt
sub SaveNews {
	SubmitFormFields();
	&loadND;
	# Strip newlines, HTML comments, and other bad things.
	foreach $key (keys %in) {
			if($NPConfig{'DisableHTML'}) {
				$in{$key} = HTMLescape($in{$key});
			}
			if (($key eq 'newstext' || $FormFieldsNewlines{$key} == 1) && $in{'broption'} != 1) {
				$in{$key} =~ s/\n/<br>/g;
			} else {
				$in{$key} =~ s/\n//g;
			}
			$in{$key} =~ s/\r//g;
			$in{$key} =~ s/``x/` ` x/g;
			$in{$key} =~ s/<!--(.|\n)*-->//g;
			${$key} = $in{$key};
	}
	# Begin glossary code
	if ($glossaryon == 1) {
		&LoadGlossary;
		foreach $i (@glossary) {
			$newstext =~ s/([^\w\d\<]|\A)\Q$i\E([^\w\d\>]|\Z)/$1$Glossary{$i}$2/g;
		}
	}
	if ($NPConfig{'AutoLinkURL'}) {
		$newstext =~ s/([\s\(]|\A|<br>)(http:\/\/|ftp:\/\/|https:\/\/)([^\s\)"'<>]+)/$1<a href="$2$3">$2$3<\/a>/gi;
	}
	# End glossary code
	$newsname = $Cookies{'uname'};
	$newstime = time;
	# Generate news ID
	$rando = int(rand(99999));
	$newsid = join(',', time, $rando, $newscat);
	$snid = join(',', time, $rando, '');
	# Ensure news ID is not already being used.
	while ($NewsID{$snid} ne '') {
		$rando = int(rand(99999));
		$newsid = join(',', time, $rando, $newscat);
		$snid = join(',', time, $rando, '');
	}
	if (@Addons_SaveNews) {
		&RunAddons(@Addons_SaveNews);
	}
	$newsline = &JoinDataFile;
	# Open the news database for append.
	NPopen('NEWSDAT',">>$NPConfig{'admin_path'}/newsdat.txt");
	print NEWSDAT "$newsline\n";
	close(NEWSDAT);
	if (@Addons_SaveNews_3) {
		&RunAddons(@Addons_SaveNews_3);
	}
	if ($NPConfig{'AutoBuild'}) {
		&GenHTML;
		exit;
	}
	&NPHTMLHead($Messages{'Save_NewsSaved'});
	print qq~
$Messages{'Save_Message'}
	~;
	if (@Addons_SaveNews_2) {
		&RunAddons(@Addons_SaveNews_2);
	}
	&NPHTMLFoot;
}
#######
# NEWS BUILDING AND ARCHIVING
#######
# GenHTML: This is the core of the Build News function.
# It generates all the various news files.
sub GenHTML {
	# This line exists for compatibility with ndisplay.pl
	$ArcHtmlExt = $NPConfig{'ArcHtmlExt'};	
	
	# Load ndisplay.pl
	require $ndisplaypl;
	
	# Check if we have a current version of ndisplay.pl
	unless ($ndisplayversion == 3) {
		if ($ndisplayversion == 2) {
			&UpgradeND3;
		}
		elsif (!$ndisplayversion) {
			NPdie("Your ndisplay.pl does not contain the required $ndisplayversion line. Restore the original ndisplay.pl");
		}
	}
	
	# Set variables to the current time and the time before which news is "old"
	$currenttime = time;
	($oldtime, $newtime) = PastDaysTime($NPConfig{'NewsAge'});
	
	# Open the links text file if we're archiving monthly.
	if ($NPConfig{'NewsArcDel'} == 2 && $NPConfig{'ArcTime'} >= 2) {
		$linktxtpath = ">$NPConfig{'archive_path'}/arclinks.txt";
		NPopen('LINKTXT', $linktxtpath);
	}
	
	# Open the main archive file if we're archiving into one file.
	if ($NPConfig{'NewsArcDel'} == 2 && $NPConfig{'ArcTime'} == 1) {
		$bigarcpath = ">$NPConfig{'archive_path'}/archive.txt";
		NPopen('BIGARC', $bigarcpath);
	}
	
	# Read in newsdat.txt
	&loadND;
	$newsnum = @NewsData;
	
	# If NumberLimit is set, change the "archive time" to the number of seconds since the
	# nth most recent article was posted, where n = NumberLimit.
	# This is a bit of a workaround, as the script was designed to archive by time.
	if ($NPConfig{'NumberLimit'}) {
		$oldnum = $newsnum - $NPConfig{'NumberLimit'};
		if ($oldnum > 0) {
			$oldtime = $NewsData[$oldnum]->{'newstime'};
		} else {
			$oldtime = $NewsData[0]->{'newstime'};
		}
	}
	
	$newsnum--;
	
	# Open the main output file, news.txt
	NPopen('NEWSHTML', ">$NPConfig{'htmlfile_path'}/news.txt");
	
	# Print out identifier comment. 
	print NEWSHTML qq~
	<!-- NP v$npversion -->
	~;
	
	if (@Addons_BuildNews_PreLoop) {
		&RunAddons(@Addons_BuildNews_PreLoop);
	}
	
	# Start processing newsdat.txt line-by-line
	NDLOOP: while ($newsnum >= 0) {
	# Split the entry into its various components
	getNDvar($newsnum);
	
	if (@Addons_BuildNews_1) {
		&RunAddons(@Addons_BuildNews_1);
	}
	
	if ($NPConfig{'NewsArcDel'} eq "0" || $newstime >= $oldtime) {
		# News goes onto the main page.
		$BeingArchived = 0;
		$FileName = "$NPConfig{'htmlfile_path'}/news.txt";
		&DoNewsHTML;
		if ($NPConfig{'CreateAnchors'}) {print NEWSHTML qq~<a name="newsitem$newsid"></a>~;}
		print NEWSHTML $newshtml;
		# Make a headline if headlines are enabled.
		if ($NPConfig{'EnableHeadlines'}) {
			&DoHeadline;
		}
	}
	elsif ($NPConfig{'NewsArcDel'} == 2 && $newstime < $oldtime) {
		# News too old to go on main page.
		$BeingArchived = 1;
		if (@Addons_BuildNews_2) {
			&RunAddons(@Addons_BuildNews_2);
		}
		if ($NPConfig{'ArcTime'} == 1) {
			# Print to the main archive file.
			$FileName = "$NPConfig{'archive_path'}/archive.txt";
			&DoArchiveHTML;
			if ($NPConfig{'CreateAnchors'}) {print BIGARC qq~<a name="newsitem$newsid"></a>~;}
			print BIGARC $newshtml;
		}
		elsif ($NPConfig{'ArchiveNumber'}) {
			$FileName = "$NPConfig{'archive_path'}/arc$ArcCounter.txt";
			&DoArchiveHTML;
			&ArcNumberHandler($newshtml);
		}
			
		elsif ($NPConfig{'ArcTime'} == 2) {
			# Print to the appropriate individual archive.
			$arcname = "arc$Month" . "-$Year";
			unless ($OpenArchive{$arcname}) {
				&DoArcFile($arcname);
			}
			$FileName = "$NPConfig{'archive_path'}/$arcname.txt";
			&DoArchiveHTML;
			if ($NPConfig{'CreateAnchors'}) {print $arcname qq~<a name="newsitem$newsid"></a>~;}
			print $arcname $newshtml;			
		}
		elsif ($NPConfig{'ArcTime'} == 3) {
			# Print to the appropriate individual archive.
			my ($arcDay, $arcMonth);
			$arcDay = "0$Day" if $Day <10;
			$arcDay = $Day if $Day >=10;
			$arcMonth = "0$ActualMonth" if $ActualMonth <10;
			$arcMonth = $ActualMonth if $ActualMonth >=10;
			$arcname = "arc-$Year$arcMonth$arcDay";
			unless ($OpenArchive{$arcname}) {
				&DoArcFile($arcname);
			}
			$FileName = "$NPConfig{'archive_path'}/$arcname.txt";
			&DoArchiveHTML;
			if ($NPConfig{'CreateAnchors'}) {print $arcname qq~<a name="newsitem$newsid"></a>~;}
			print $arcname $newshtml;
		}
		else {
			last NDLOOP;
		}
	}	
	# Entry processed, remove 1 from counter.
	$newsnum--;
	}
	# If ShowNewsControls is on, add them.
	if ($NPConfig{'ShowNewsControls'}) {
		print NEWSHTML &PrintNewsControls;
	}
	# If DisplayLink is on, add a link.
	if ($NPConfig{'DisplayLink'}) {
		# You can modify this link if you'd like.
		print NEWSHTML qq~ <i><small>$Messages{'DisplayLink'} <a href="http://amphibian.gagames.com/newspro/" target="_top">$Messages{'NewsPro'}</a>.</small></i><br> ~;
	}
	# Close news.txt
	close(NEWSHTML);
	# Close the main archive file if we archive to one big file.
	if ($NPConfig{'NewsArcDel'} == 2 && $NPConfig{'ArcTime'} == 1) {
		close(BIGARC);
	}
	# Close the individual monthly archives if we archive monthly.
	if ($NPConfig{'NewsArcDel'} == 2 && $NPConfig{'ArcTime'} >= 2) {
		# Format archive links
		&EndArcLinks;
		foreach $key (keys %OpenArchive) {
			&EndArcFile($key);
		}
	}	
	# Close the headlines file if headlines are enabled.
	if ($HeadlineFileOpen) {
		close(HEADLINES);
		$HeadlineFileOpen = 0;
	}
	
	if (@Addons_BuildNews_Post) {
		&RunAddons(@Addons_BuildNews_Post);
	}
	# Done! Print confirmation page.
	unless ($SilentBuild) {
		&NPHTMLHead($Messages{'Build_Title'});
		print $Messages{'Build_Message'};
		&NPHTMLFoot;
	}
}
# DoArcFile: Opens and prepares a monthly archive file.
sub DoArcFile {
	# Name of file is passed to it.
	local ($arcfile) = @_;
	# Get full path
	$arcfilepath = ">$NPConfig{'archive_path'}/$arcfile.txt";
	# Open (create) the file.
	NPopen($arcfile, $arcfilepath);
	$OpenArchive{$arcfile} = 1;
	if ($NPConfig{'ArcTime'} == 2) {
		$ArcDate{$arcfile} = ucfirst("$Months[$Month] $Year");
	}
	elsif ($NPConfig{'ArcTime'} == 3) {
		$ArcDate{$arcfile} = "$Day $Months[$Month] $Year";
	}
	# Add a link to this file to the archive links file.
	if ($NPConfig{'NewsArcDel'} == 2 && $NPConfig{'ArcTime'} >= 2) {
		&DoLinkHTML;
		print LINKTXT $newshtml;
	}
}
# EndArcFile: Closes a monthly archive file, and prepares the HTML version of it.
sub EndArcFile {
	# Name of archive file is passed to it.
	my $arcfile = shift;
	# Close that archive file.
	close($arcfile);
	
	# Get full paths
	$archtmlpath = ">$NPConfig{'archive_path'}/$arcfile.$NPConfig{'ArcHtmlExt'}";
	$arcfilepath = "$NPConfig{'archive_path'}/$arcfile.txt";
	
	# Open HTML archive file and HTML archive template
	my $arctxt = '';
	NPopen('ARCTXT', $arcfilepath);
	while (<ARCTXT>) {
		$arctxt .= $_;
	}
	close(ARCTXT);
	my $arctmpl = ProcessTMPL("$NPConfig{'admin_path'}/archive.tmpl", $arctxt);
	NPopen($arcfile, $archtmlpath);		
	
	# Substitute template "tags" with real values.
	$arctmpl =~ s/<InsertDate>/$ArcDate{$arcfile}/gi;
	$arctmpl =~ s/<InsertNews>/$arctxt/i;
	
	# Print HTML file and close it.
	print $arcfile $arctmpl;
	close($arcfile);
}
sub EndArcLinks {
		# Close arclinks.txt and make a HTML version
		close(LINKTXT);
		$linktxtpath = "$NPConfig{'archive_path'}/arclinks.txt";
		my $linktxt = '';
		NPopen('LINKTXT', $linktxtpath);
		while (<LINKTXT>) {
			$linktxt .= $_;
		}
		close(LINKTXT);
		my $arclprint = ProcessTMPL("$NPConfig{'admin_path'}/arclink.tmpl", $linktxt);
		$arclprint =~ s/<InsertLinks>/$linktxt/i; #Compatibility with older versions
		NPopen('ARCLHTML', ">$NPConfig{'archive_path'}/$NPConfig{'arclinkfile'}");
		print ARCLHTML $arclprint;
		close(ARCLHTML);
}
# DoHeadline: takes care of headlines.
sub DoHeadline {
	my $headfilepath = "$NPConfig{'htmlfile_path'}/headlines.txt";
	unless ($HeadlineFileOpen == 1) {
		NPopen('HEADLINES', ">$headfilepath");
		$HeadlineFileOpen = 1;
	}
	if (($HeadlineCounter < $NPConfig{'HeadlineNumber'} && $NPConfig{'HeadlineNumber'}) || $NPConfig{'HeadlineNumber'} == 0) {
	$FileName = $headfilepath;
	&DoHeadlineHTML;
	print HEADLINES $newshtml;
	}
	$HeadlineCounter++;
}
sub ArcNumberHandler {
	my $newstoarchive = shift;
	if ($NPConfig{'CreateAnchors'}) {$newstoarchive = qq~<a name="newsitem$newsid"></a>$newstoarchive~;}
	push(@newstoarchive, $newstoarchive);
	push(@newsarchivedata, $newsnum);
	if (@newstoarchive == $NPConfig{'ArchiveNumber'} || $newsnum == 0) {
		&getNDvar($newsarchivedata[@newsarchivedata - 1]);
		$ArcStartDate = "$Months[$Month] $Month_Day, $Year";
		unless (@newsarchivedata == 0) {
			&getNDvar($newsarchivedata[0]);
			$ArcEndDate = "$Months[$Month] $Month_Day, $Year";
		} else {
			$ArcEndDate = $ArcStartDate;
		}
		$arcfile = "arc$ArcCounter";
		NPopen($arcfile, ">$NPConfig{'archive_path'}/$arcfile.txt");
		$OpenArchive{$arcfile} = 1;
		print $arcfile join('', @newstoarchive);
		$ArcDate{$arcfile} = "$ArcStartDate - $ArcEndDate";
		&DoLinkHTML;
		print LINKTXT $newshtml;
		undef @newstoarchive;
		undef @newsarchivedata;
		$ArcCounter++;
	}
}
#######
# NEWS MODIFICATION
#######
# RemoveNews: Displays the main Modify News page
sub RemoveNews {
	$newsnum = shift;
	&SubmitFormFields;
	&loadND;
	if ($newsnum eq '') { $newsnum = @NewsData - 1; }
	if ($newsnum < 0 || $newsnum >= @NewsData) {
		if (@NewsData == 0) {
			NPdie("You have no news items, and therefore there's nothing for you to modify.");
		}
		else {
			&NPdie("Incorrect news number value passed to Modify News.");
		}
	}	
	# Make sure there is a value in Modify_ItemsPerPage
	# If not, set it to 15
	unless ($NPConfig{'Modify_ItemsPerPage'} > 0) {
		$NPConfig{'Modify_ItemsPerPage'} = 15;
	}
	NPHTMLHead($Messages{'Section_Modify'});
	print "<form action=\"$scripturl?removesave\" method=post>";
	if (@Addons_RemoveNews) {
		&RunAddons(@Addons_RemoveNews);
	}
	my $nncount = 0;
	MDFYLOOP: while (($nncount < $NPConfig{'Modify_ItemsPerPage'}) && ($newsnum >= 0)) {
		getNDvar($newsnum);
		if ($up >= 2 || $newsname eq $Cookies{'uname'}) {
			print qq~
			$Messages{'Modify_Posted'} $newsdate $Messages{'Modify_By'} $newsname.~;
			if (@Addons_RemoveNews2) {
				&RunAddons(@Addons_RemoveNews2);
			}
			print '<br>';	
			foreach $i (@formfields) {
				unless ($DisableModify{$i} == 1) {
					if ($up > 1 || $DisableModify{$i} != 2) {
						if ($FormFieldsName{$i}) {
							print $FormFieldsName{$i};
						} else {
							print $i;
						}
						$escapedfield = &HTMLescape(${$i});
						if ($FormFieldsModifySize{$i}) {
							if ($FormFieldsNewlines{$i}) {
								$escapedfield =~ s/\&lt;br\&gt;/\n/gi;
							}
							print qq~ <textarea name="$i--$newsnum" wrap="virtual" cols="70" rows="7" wrap="virtual">$escapedfield</textarea><br> ~;
						}
						else {
							print qq~: <input type="text" name="$i--$newsnum" value="$escapedfield" size="40"><br>~;
						}
					}
				}
			}
			$escapedfield = $newstext;
			$escapedfield =~ s/<br>/\n/gi;
			$escapedfield = &HTMLescape($escapedfield);
			print qq~
<textarea name="newstext--$newsnum" cols="70" rows="8" wrap="virtual">$escapedfield</textarea><br>
$Messages{'Modify_Keep'} <input type=radio name="chk--$newsnum" value="keep" checked>&nbsp;&nbsp;
$Messages{'Modify_Remove'} <input type=radio name="chk--$newsnum" value="remove"> <hr>
	~;
			$nncount++;
		} 
		$newsnum--;
	}
	unless ($nncount) {
		print qq~</form><div align="center"><b>You do not have permission to modify any news items.</b>~;
	}
	else {
		print qq~<div align="center"><input type=hidden name=ndage value="$nd_age">~;
		unless ($newsnum < 0) {
			print qq~
			$Messages{'Modify_Save'} $Messages{'And'}<input type="submit" name="finishmodifying" value="$Messages{'Modify_Finish'}"> $Messages{'Modify_Or'} 
			<input type="hidden" name="shownextnum" value="$newsnum">
			<input type="submit" name="shownext" value="$Messages{'Modify_Show'} $NPConfig{'Modify_ItemsPerPage'} $Messages{'Modify_Items'}">.
			~;
		} 
		else {
			print qq~
			<input type="submit" name="finishmodifying" value="$Messages{'Modify_Save'}">
			~;
		}
	}
	print "</div></form>";
	&NPHTMLFoot;
}	
# RemoveNewsSave: Performs modifications
sub RemoveNewsSave {
	SubmitFormFields();
	my $fieldName;
	foreach $key (keys %in) {
		if($NPConfig{'DisableHTML'}) {
			$in{$key} =~ s/&gt;/>/g;
			$in{$key} =~ s/&lt;/</g;
			$in{$key} =~ s/&quot;/"/g;
			$in{$key} =~ s/&amp;/&/g;
			$in{$key} = HTMLescape($in{$key});
		}
		if ($key =~ /([^\s\-]+)\-\-\d+/) {
			$fieldName = $1;
		}
		if ($FormFieldsNewlines{$fieldName} || $fieldName eq "newstext") {
			$in{$key} =~ s/\n/<br>/g;
		} else {
			$in{$key} =~ s/\n//g;
		}
		$in{$key} =~ s/\r//g;
		$in{$key} =~ s/``x/` ` x/g;
		$in{$key} =~ s/<!--(.|\n)*-->//g;
		${$key} = $in{$key};
	}
	&loadND;
	if ($nd_age != $in{'ndage'} && $NPConfig{'CheckFileTime'}) {
		&NPdie("It appears that the news database (newsdat.txt) has been modified since you first accessed the Modify News page. Click your browser's back button and reload/refresh the Modify page to continue. If you receive this error when you're certain the file hasn't been modified, change CheckFileTime via Advanced Settings.");
	}
	$totnewsnum = @NewsData;
	$newsnum = 0;
	push(@formfields,'newstext');
	if (@Addons_RemoveNewsSave) {
		&RunAddons(@Addons_RemoveNewsSave);
	}
	while ($newsnum < $totnewsnum) {
		$chknum = "chk--$newsnum";
		if ($in{$chknum} eq "remove") {
			$NewsData[$newsnum] = "del";
		} 
		elsif ($in{$chknum} eq "keep") {
			&getNDvar_nodate($newsnum);
			foreach $i (@formfields) {
				if ($DisableModify{$i} != 1 && ($DisableModify{$i} != 2 || $up > 1)) {
					if ($in{"$i--$newsnum"} ne $NewsData[$newsnum]->{$i}) {
						$NewsData[$newsnum]->{$i} = $in{"$i--$newsnum"};
						$ChangedItems{$newsnum} = 1;
					}
				}
			}
		} 
		$newsnum++;
	}
	&saveND;
	if (@Addons_RemoveNewsSave_2) {
		&RunAddons(@Addons_RemoveNewsSave_2);
	}
	if ($in{'shownext'}) {
		&RemoveNews($in{'shownextnum'});
	} else {
		if ($NPConfig{'AutoBuild'}) {
			&GenHTML;
		} else {
		&NPHTMLHead($Messages{'ModifySave_Title'});
		print $Messages{'ModifySave_Message'};
		&NPHTMLFoot;
		}
	}
}
#######
# LOGIN AND USER MANAGEMENT
#######
# CheckLogin: Checks to see if the user is logged in; if not, allow the user to log in.
sub CheckLogin {
	&ReadConfigInfo;
	$npversionfull = $npversion . '_build' . $npBuild;
	if($NPConfig{'CommercialUser'}) {
		$npversionfull .= "_com";
	}
	&GetCookies;
	my @users = split (/\|/, $NPConfig{'userdata'});
	foreach $i (@users) {
		my ($username, $password, $email, $permissions) = split (/~/, $i);
		$password =~ s/\(tilde\)/~/g;
		$password =~ s/\(pipe\)/\|/g;
		$password =~ s/\(btick\)/\`/g;
		$CPassword{$username} = $password;
		$Email{$username} = $email;
		$UserPermissions{$username} = $permissions;
		push (@usernames, $username);
	}
	$up = $UserPermissions{$Cookies{'uname'}};
	if ($qstring eq "login") {
		if (crypt ($in{'pword'}, $CPassword{$in{'uname'}}) eq $CPassword{$in{'uname'}} && length($CPassword{$in{'uname'}}) > 2) {
				SetCookies('uname',$in{'uname'},'pword',$in{'pword'});
				&NPHTMLHead("$in{'uname'} $Messages{'Login_Is'}.");
				print qq~
				$Messages{'Login_OKMessage'}<br><a href="$scripturl">$Messages{'Login_OKClick'}</a>
				~;
				&NPHTMLFoot;
				exit;
		}
		elsif ($in{'uname'} eq "setup" && $NPConfig{'firsttime'} eq "yes") {
			FirstTimePage();
			exit;
		} else {
				print header();
				&NPHTMLHead($Messages{'Login_NoTitle'});
				print qq~
				<p> $Messages{'Login_NoMessage'}</p></td></tr></table></body></html>
				~;
				exit;
		}
	}
	if (crypt ($Cookies{'pword'}, $CPassword{$Cookies{'uname'}}) ne $CPassword{$Cookies{'uname'}} || length($Cookies{'pword'}) <= 2 || length($CPassword{$Cookies{'uname'}}) <= 2 || !$up) {
		if (!$HeaderPrinted && $ENV{'HTTP_REFERER'} =~ /\?login/) {
			ClearCookies();
		}
		unless ($HeaderPrinted) {
			print header();
		}
		&NPHTMLHead($Messages{'Login_Title'});
		print qq~
		<form action="$scripturl?login" method="post">
		<p> $Messages{'Username'}: <input type="text" name="uname"><br>
		$Messages{'Password'}: <input type="password" name="pword"></p>
		<input type="submit" name=submit value="$Messages{'Login_Login'}"></form>
		~;
		if ($NPConfig{'firsttime'} eq "yes") {
			print "<br><br>To set up NewsPro, enter setup as your username and leave the password blank.";
		}
		print qq~
		</td></tr></table></body></html>
		~;
		exit;
	}
}
# FormatUserInfo: Used internally to format user data.
sub FormatUserInfo {
	foreach $i (@usernames) {
		my $convpass = $CPassword{$i};
		$convpass =~ s/\~/(tilde)/g;
		$convpass =~ s/\|/(pipe)/g;
		$convpass =~ s/\`/(btick)/g;
		my $udtemp = join ('~', $i, $convpass, $Email{$i}, $UserPermissions{$i});
		push (@userdata, $udtemp);
	}
	$NPConfig{'userdata'} = join ('|', @userdata);
}
# UserAdd: Displays Edit Users page
sub UserAdd {
	unless ($up == 3) {
			&NPdie("You are not authorized to edit this");
	}
	&NPHTMLHead("Edit Users");
	print qq~
	<form action="$scripturl?addsave" method="post">
	You may either add <b>or</b> remove a user.<br>
	<div align="center"><b>Add A User</b></div>
	<table width="85%" align="center" border="0">
	<tr><td width="50%">Username:</td><td width="50%"><input type="text" name="uname"></td></tr>
	<tr><td>Password:</td><td><input type="text" name="pword"></td></tr>
	<tr><td>E-mail (optional):</td><td><input type="text" name="email"></td></tr>
	<tr><td>User Permissions:</td><td><select name="permissions"><option value="1" selected>Standard (can post, build and edit own posts)</option>
	<option value="2">High (same as Standard, but can edit/remove all posts)</option>
	<option value="3">Webmaster (full administrative access; cannot be removed)</option></select></td></tr>
	</table>
	<br><hr width="50%" noshade><br><div align="center"><b>Remove A User</b></div>
	Select a user: 
	<select name="removeuser">
	<option value="none" selected>(None)</option>
	~;
	foreach $i (sort @usernames) {
		print "<option value=\"$i\">$i</option>\n";
	}
	print qq~
	</select><br><br>
	<strong>WARNING!</strong> Webmaster-level accounts not only have access to every setting in NewsPro, but also cannot be deleted. In general, give Webmaster access only to people to whom you would feel comfortable giving your FTP password.
	<br><br><div align="center"><input type="submit" name="submit" value="Add/Remove User"></div></form>
	~;
	&NPHTMLFoot;
}
# UserAddSave: Saves modifications from Edit Users
sub UserAddSave {
	unless ($up == 3) {
		&NPdie("You are not authorized to edit this");
	}
	if ($in{'uname'} =~ /\~/ || $in{'uname'} =~ /\|/ || $in{'uname'} =~ /\`\`x/) {
		NPdie("Username $in{'uname'} contains illegal characters. Illegal characters include the pipe | and the tilde ~.");
	}
	if ($in{'pword'} =~ /\~/ || $in{'pword'} =~ /\|/ || $in{'pword'} =~ /\`\`x/) {
			NPdie("Password $in{'pword'} contains illegal characters. Illegal characters include the pipe | and the tilde ~.");
	}
	if ($in{'email'} =~ /\~/ || $in{'email'} =~ /\|/ || $in{'email'} =~ /\`\`x/) {
			NPdie("E-mail $in{'email'} contains illegal characters. Illegal characters include the pipe | and the tilde ~.");
	}
	if ($in{'uname'} ne '') {
		unless (length($in{'uname'}) >= 2) {
			NPdie("That username is too short. It must be at least two characters.");
		}
		foreach $i (@usernames) {
			if ($i eq $in{'uname'}) {
				NPdie("Username $in{'uname'} is already in use.");
			}
		}
		$CPassword{$in{'uname'}} = crypt ($in{'pword'}, join ('', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64]));
		$UserPermissions{$in{'uname'}} = $in{'permissions'};
		$Email{$in{'uname'}} = $in{'email'};
		push(@usernames, $in{'uname'});
	}
	if ($in{'removeuser'} ne "none") {
		if ($UserPermissions{$in{'removeuser'}} == 3) {
			&NPdie("Cannot remove webmaster users.");
		}
		my $thecount = 0;
		foreach $i (@usernames) {
			if ($i eq  $in{'removeuser'}) {
				splice(@usernames, $thecount, 1);
			}
			$thecount++;
		}
	}
	&FormatUserInfo;
	&WriteConfigInfo;
	&NPHTMLHead("Users Modified");
	print "User information changes have been saved.";
	&NPHTMLFoot;
}
# ChangeUserInfo: Displays User Info screen
sub ChangeUserInfo {
	&NPHTMLHead($Messages{'Section_UserInfo'});
	print qq~
	<form action="$scripturl?userinfosave" method="post">
	<br>
	$Messages{'Password'}: <input type="text" name="pword"><br>
	$Messages{'Email'}: <input type="text" name="email" value="$Email{$Cookies{'uname'}}"><br>
	<input type="submit" name="submit" value="$Messages{'Submit'}"> </form>
	~;
	&NPHTMLFoot;
}
# ChangeUserInfoSave: Save changes made in User Info
sub ChangeUserInfoSave {
	foreach $key (keys %in) {
			$in{$key} =~ s/\n//g;
			$in{$key} =~ s/\r//g;
			$in{$key} =~ s/\|/(pipe)/g;
			$in{$key} =~ s/``x/` ` x/g;
			$in{$key} =~ s/~/(tilde)/g;
	}			
	if ($in{'pword'} ne "") {
		$CPassword{$Cookies{'uname'}} = crypt ($in{'pword'}, join '', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64]);
	}
	$Email{$Cookies{'uname'}} = $in{'email'};
	&FormatUserInfo;
	&WriteConfigInfo;
	&NPHTMLHead($Messages{'UserInfoSave_Title'});
	print $Messages{'UserInfoSave_Message'};
	&NPHTMLFoot;
}
#######
# CHANGING SETTINGS
#######
# ChangeSettings: Displays Change Settings screen
sub ChangeSettings {
	unless ($up == 3) {
		&NPdie("You are not authorized to edit this.");
	}
	if ($abspath ne '') {
		NPopen('NPC', "$abspath/ndisplay.pl");
	}
	else {
		NPopen('NPC', "ndisplay.pl");
	}
	@ndisplay = <NPC>;
	close(NPC);
	$ndisplay = join('', @ndisplay);
	$ndisp = qq~ <textarea name="ndisplay" cols="80" rows="10" wrap="VIRTUAL">~;
	unless ($ndisplay =~ /<ManualEdit>/) {
		$ndisplay =~ /<BeginEdit>(.*)\n(.*)\n([\s\S]+)\n(.*)\n(.*)<EndEdit>/;
		$ndcontent = $3;
		$ndcontent =~ s/^\s+//;
		$ndcontent =~ s/\s+$//;
		$ndcontent = HTMLescape($ndcontent);
		$ndisp .= $ndcontent;
	} else {
	$ManualEdit = 1;
	}
	$ndisp =~ s/\$newstext/&lt;InsertNews&gt;/gi;
	$ndisp =~ s/\$newsname/&lt;InsertName&gt;/gi;
	$ndisp =~ s/\$newsemail/&lt;InsertEmail&gt;/gi;
	$ndisp =~ s/\$newsdate/&lt;InsertDate&gt;/gi;
	$ndisp =~ s/\$newssubject/&lt;InsertSubject&gt;/gi;
	$ndisp =~ s/\\\$/\$/g;
	$ndisp =~ s/\\\@/\@/g;
	$ndisp =~ s/\\\%/\%/g;
	$ndisp =~ s/\n//g;
	$ndisp .= "</textarea>";
	if ($ManualEdit) {
		$ndisp = "<b>You have edited ndisplay.pl manually. You can no longer edit it via the Web.</b>";
	}
	if ($NPConfig{'admin_path'} eq "") {
		$dirname = GetDirInfo();
		$dirname =~ s/\\/\//g;
		$NPConfig{'admin_path'} = $dirname;
		$NPConfig{'htmlfile_path'} = $dirname;
		$NPConfig{'archive_path'} = $dirname;
		$NPConfig{'NewFilesDirectory'} = $dirname;
		$NPConfig{'12HourClock'} = $nplang_12Hour;
	}
	unless ($NPConfig{'DateFormat'}) {
		$NPConfig{'DateFormat'} = $nplang_DateFormat;
	}
	my $dateexample = GetTheDate();
	my %CSSelected = ();
	if ($NPConfig{'NewsArcDel'} == 1) {
		$CSSelected{'Nad1'} = "selected";
	}
	elsif ($NPConfig{'NewsArcDel'} == 2) {
		$CSSelected{'Nad2'} = "selected";
	}
	else {
		$CSSelected{'Nad0'} = "selected";
	}
	if ($NPConfig{'ArcTime'} == 2) {
		$CSSelected{'ArcT2'} = "selected";
	}
	elsif ($NPConfig{'ArcTime'} == 3) {
		$CSSelected{'ArcT3'} = 'selected';
	}
	else {
		$CSSelected{'ArcT1'} = "selected";
	}
	if ($NPConfig{'12HourClock'} == 1) {
		$CSSelected{'12H1'} = "selected";
	}
	else {
		$CSSelected{'12H0'} = "selected";
	}
	&NPHTMLHead("Change Settings");
	print qq~
	<form action="$scripturl?settingssave" method=post>
	          <p><b>General Settings</b></p>
	          <p align="left"><b>Site Name</b><br>
	            <input type="text" name="SiteTitle" size="40" value="$NPConfig{'SiteTitle'}">
	            </p>
	          <p align="left"><b>Program Files Path</b> Absolute path (NOT URL) to the directory 
	            where this script and its program files are located. Use forward slashes (/), even
	            on Windows systems. No trailing slash.<br>
	            <input type="text" name="admin_path" size="40" value="$NPConfig{'admin_path'}">
	          </p>
	          <p align="left"><b>News Files Path</b> Absolute path (NOT URL) where 
	            you'd like the news file (the one you include in your pages) to be 
	            generated. Usually same as the Admin Path, unless your admin path is in your cgi
				directory; if that is a case, make this a directory outside your cgi. 
				The directory must be world-writable; on UNIX server, this means CHMOD 777. Use forward slashes (/), even
	            on Windows systems. No trailing slash.<br>
	            <input type="text" name="htmlfile_path" size="40" value="$NPConfig{'htmlfile_path'}">
	          </p>
	          <p align="left"><b>Archive Files Path</b> Absolute path (NOT URL) where 
	            you'd like your news archives to be created. Usually same as the News File 
	            Path. Use forward slashes (/), even on Windows systems. No trailing slash.<br>
	            <input type="text" name="archive_path" size="40" value="$NPConfig{'archive_path'}">
	          </p>
	          <p align="left"><b>Site Link </b>If you'd like to have a &quot;Back 
	            to your site&quot; link on the news administration pages, enter the 
	            URL here. Leave blank otherwise.<br>
	            <input type="text" name="SiteLink" size="40" value="$NPConfig{'SiteLink'}">
	          </p>
	          <p align="center"><b>Archive Settings</b></p>
	          <p align="left"><b>Archive/Hide News?</b> Do you want to archive or 
	            hide (keep in your database, but don't display) old news? The age after which news is considered old is set 
	            in News Age, below.<br>
	            <select name="NewsArcDel"><option value="0" $CSSelected{'Nad0'}>Neither (display all news)</option>
				<option value="1" $CSSelected{'Nad1'}>Hide</option>
				<option value="2" $CSSelected{'Nad2'}>Archive</option></select>
	          </p>
	          <p align="left">If you selected Neither above, you can skip the rest 
	            of the Archive Settings.<br>
	            <b>News Age</b> After how many days will news be considered &quot;old&quot; 
	            and either hidden or archived, depending on your choice above?<br>
	            <input type="text" name="NewsAge" size="40" value="$NPConfig{'NewsAge'}">
	          </p>
	          ~;
	          if ($EnableDailyArchiving) {
			  print qq~
	          <p align="left"><b>Archive Type?</b> If you archive, would you like 
	            to have all old news in one archive, or would you like to split it 
	            into daily or monthly archives? <br>
		<select name="ArcTime"><option value="1" $CSSelected{'ArcT1'}>One Archive</option>
		<option value="2" $CSSelected{'ArcT2'}>Monthly</option>
		<option value="3" $CSSelected{'ArcT3'}>Daily</option></select>
	        	  </p>
	          	~;
		}
		else {
			print qq~
			<p align="left"><b>Archive Type?</b> If you archive, would you like 
				            to have all old news in one archive, or would you like to split it 
				            into monthly archives? <br>
					<select name="ArcTime"><option value="1" $CSSelected{'ArcT1'}>One Archive</option>
					<option value="2" $CSSelected{'ArcT2'}>Monthly</option></select>
	        	  </p>
	          	~;
	  	}
	  	print qq~
	          <p align="left"><b>Monthly Archive Links Page</b> If you archive monthly, 
	            a page will be created that links to all the different monthly archives. 
	            What would you like this page to be called (it will be created in 
	            the Archive Directory).<br>
	            <input type="text" name="arclinkfile" size="40" value="$NPConfig{'arclinkfile'}">
	          </p>
	          <p align="center"><b>Time Settings</b></p>
	          <p align="left"><b>Time Zones </b>What time zone are you in? Note: this is for display purposes only. To change the actual time displayed to reflect your time zone, use the TimeOffset setting in Advanced Settings.<br>
	            Standard: <input type="text" name="Standard_Time_Zone" size="40" value="$NPConfig{'Standard_Time_Zone'}">
				<br> Daylight: <input type="text" name="Daylight_Time_Zone" size="40" value="$NPConfig{'Daylight_Time_Zone'}">
	          </p>
			  <p align="left"><b>12/24 Hour Clock</b> Would you like to use a 12 hour (AM/PM) or 24 hour clock? <br><select name="12HourClock">
			  <option value="1" $CSSelected{'12H1'}>12 Hour Clock</option>
			  <option value="0" $CSSelected{'12H0'}>24 Hour Clock</option></select></p>
			  <p align="left"><b>Date Format</b> In the box below, enter the date format that you would like to use. &quot;Tags&quot; in the form of &lt;Field: name&gt; are replaced with the appropriate
			  information; name can be any one of <b>Year, Month_Name, Month_Number, Day, Weekday, Time_Zone, Hour, Minute, Second, </b>or<b> AMPM</b>. Note that the the field names must be capitalised properly.<br><br>An example of your current date format is: $dateexample<br><br>
			  <div align="center"><textarea name="DateFormat" cols="80" rows="3" wrap="virtual">$NPConfig{'DateFormat'}</textarea></div><br>			  
	          <p align="center"><b>News Display</b></p>
	          <p align="left">Below, you will be able to edit the HTML used to display your news. 
	            </p>
	          <p align="left">Use the following &quot;tags&quot; to include your news information:<br>
			  <b>&lt;InsertNews&gt; &lt;InsertName&gt; &lt;InsertEmail&gt; &lt;InsertDate&gt; &lt;InsertSubject&gt;</b></p>
	          <p align="center"> 
	            $ndisp
	          </p>
	          <p align="center">Note: other settings are available by editing text 
	            files. These include archive.tmpl (the 
	            template used to create your archives), arclink.tmpl (the template 
	            used to create the links page to your monthly archives), and ndisplay.pl
				(contains the HTML used to generate news and links). For more information, see the <a href="http://amphibian.gagames.com/newspro/faq2/">NewsPro FAQ</a>.</p>
	          <p align="center"> 
	            <input type="submit" name="Submit" value="Submit Settings">
	          </p>
        </form>
		~;
		if ($NPConfig{'showreadme'} eq "yes") {
			print "</td></tr></table></body></html>";
		} else {
		&NPHTMLFoot;
		}
}
# ChangeSettingsSave: Saves changes made on Change Settings screen
sub ChangeSettingsSave {
	unless ($up == 3) {
		NPdie("You are not authorized to edit this");
	}
	foreach $key (keys %in) {
		unless ($key eq "Submit" || $key eq "ndisplay") { 
			$NPConfig{$key} = $in{$key};
		}
	}
	$NPConfig{'mainpagelimit'} = $NPConfig{'NewsAge'} * 86400;
	&WriteConfigInfo;
	$in{'ndisplay'} =~ s/\r//g;
	$in{'ndisplay'} =~ s/\$/\\\$/g;
	$in{'ndisplay'} =~ s/\@/\\\@/g;
	$in{'ndisplay'} =~ s/\%/\\\%/g;
	$in{'ndisplay'} =~ s/~/\%2E/g;
	$in{'ndisplay'} =~ s/<InsertNews>/\$newstext/gi;
	$in{'ndisplay'} =~ s/<InsertName>/\$newsname/gi;
	$in{'ndisplay'} =~ s/<InsertEmail>/\$newsemail/gi;
	$in{'ndisplay'} =~ s/<InsertSubject>/\$newssubject/gi;
	$in{'ndisplay'} =~ s/<InsertDate>/\$newsdate/gi;
	if ($in{'ndisplay'}) {
	NPopen('NDS', "$NPConfig{'admin_path'}/ndisplay.pl");
	@nds = <NDS>;
	close(NDS);
	$nds = join('', @nds);
	$nds =~ /^([\s\S]+)<BeginEdit>([\s\S]+)<EndEdit>([\s\S]+)/;
	if ($abspath ne '') {
		NPopen('NPC', ">$abspath/ndisplay.pl");
	}
	else {
		NPopen('NPC', ">ndisplay.pl");
	}
	print NPC "$1<BeginEdit>\n";
	print NPC "\$newshtml = qq~\n";
	print NPC $in{'ndisplay'};
	print NPC "\n~;\n";
	print NPC "# DO NOT REMOVE THIS LINE! <EndEdit>$3";
	close(NPC);
	}
	if ($NPConfig{'showreadme'} eq "yes") {
		$NPConfig{'showreadme'} = "no";
		&WriteConfigInfo;
		print "Location: http://amphibian.gagames.com/newspro/postinstall.html\n\n";
		exit;
	}
	&NPHTMLHead("Settings Saved");
	print qq~Your settings have been saved. If you changed settings which affect your news appearance or structure, such as news style or archiving settings,
	you must <a href="$scripturl?generate">build news</a> before these settings will take effect.~;
	&NPHTMLFoot;	
	exit;
}
# AdvancedSettings: Displays Advanced Settings screen.
sub AdvancedSettings {
	unless ($up == 3) {
		&NPdie("You are not authorized to access this.");
	}
	&AdvancedSettingsLoad;
	&NPHTMLHead("Advanced Settings");
	print qq~
	<form action="$scripturl?advsetsave" method="post">
	This page contains all of NewsPro's advanced settings. Visit the <a href="http://amphibian.gagames.com/newspro/" target="_top">NewsPro
	homepage</a> for more information.<p>
	~;
	foreach $i (@advancedsettings) {
		unless ($i eq "draw_line") {
			unless ($AdvYesNo{$i}) {
				$escapedfield = HTMLescape($NPConfig{$i});
				print qq~
				<b>$i</b> $AdvDescr{$i} <input type="text" size="30" name="$i" value="$escapedfield"><br><br>
				~;
			} else {
				if ($NPConfig{$i} == 0) {
					$YesCheck = '';
					$NoCheck = 'selected';
				} else {
					$YesCheck = 'selected';
					$NoCheck = '';
				}
				print qq~
				<b>$i</b> $AdvDescr{$i} | <select name="$i"> <option value="1" $YesCheck>Yes (On)</option><option value="0" $NoCheck>No (Off)</option></select><br><br>
				~;
			}
		} else {
			print q~<hr width="80%">~;
		}
	}
	print qq~</p><p align="center"><input type="submit" name="submit" value="Submit Settings"></form></p>~;
	&NPHTMLFoot;
}
# AdvancedSettingsSave: Saves changes to advanced settings
sub AdvancedSettingsSave {
	unless ($up == 3) {
		&NPdie("You are not authorized to access this.");
	}
	&AdvancedSettingsLoad;
	foreach $i (@advancedsettings) {
		if ($i ne "draw_line") {
			$in{$i} =~ s/\n//g;
			$in{$i} =~ s/\r//g;
			$in{$i} =~ s/``x/(delim)/g;
			$NPConfig{$i} = $in{$i};
		}
	}
	&WriteConfigInfo;
	&NPHTMLHead("Advanced Settings Saved");
	print qq~
	Your settings have been saved.
	~;
	&NPHTMLFoot;
}
#######
# INITIAL SETUP
#######
# FirstTimePage: Displays initial setup & welcome page.
sub FirstTimePage {
	# Test use of crypt();
	my $cryptone = crypt("test123", "p4");
	my $crypttwo = crypt("test123", $cryptone);
	my $cryptthree = crypt("not5same", $cryptone);
	my $cryptfour = crypt('', $cryptone);
	if ($cryptone ne $crypttwo || $cryptone eq $cryptthree || $cryptone eq $cryptfour) {
		NPdie("Error in crypt() implementation: $cryptone | $crypttwo | $cryptthree | $cryptfour");
	}
	print header();
	&NPHTMLHead("Welcome!");
	print qq~ 
	<form action="$scripturl?firsttimesave" method="post">
	Welcome to NewsPro! If you're seeing this, you've properly completed the first two steps of the setup procedure.
	The first part of this third step is to set up your user info. Choose a username
	and password, and enter your e-mail address. Once you have set this up, your login
	information will be stored in a cookie, so that you won't have to type in your
	username and password again, and you will continue to the Change Settings page to set the basic configuration options.
	Once that is completed, NewsPro will be operational, and you will be given a chance to register.<br>
	<b>Username:</b> <input type="text" name="uname"><br>
	<b>Password:</b> <input type="text" name="pword"><br>
	<b>E-mail  :</b> <input type="text" name="email"><br>
	<br><br>As well, you must specify whether your site is commercial or non-commercial.
Commercial sites must set this to Yes. Any site which sells a product, promotes a company, 
or is owned and operated by a for-profit corporation is considered commercial. Ad banners 
placed by a web host do not make a site commercial, however paid ads placed by the site owner 
do make a site commercial.
<p align="center">You <b>must</b> answer this question accurately. All users must
read the above definition. In particular, sites with paid advertising of any kind are
considered commercial. The script is still available free of charge to commercial users.</p>
	<br>Commercial <input type="radio" name="CommercialUser" value="1" checked> Non-Commercial 
	<input type="radio" name="CommercialUser" value="0"><br>
	<input type=submit name=submit value="Continue...">
	</form></td></tr></table></body></html>
	~;
}
# FirstTimeSave: Saves initial username, password, and e-mail, and sends user to Change Settings.
sub FirstTimeSave {
	&ReadConfigInfo;
	if ($NPConfig{'firsttime'} ne "yes") {
		&NPdie ("Doesn't appear to be the first time this script was run.");
	}
	$NPConfig{'firsttime'} = "not";
	foreach $key (keys %in) {
		$in{$key} =~ s/\n//g;
		$in{$key} =~ s/\r//g;
		$in{$key} =~ s/\|//g;
		$in{$key} =~ s/``x/` ` x/g;
		$in{$key} =~ s/~//g;
	}			
	@usernames = ($in{'uname'});
	unless (length($in{'uname'}) >= 2) {
		NPdie("Your username is too short. It must be at least 2 characters.");
	}
	my $cryptedpass = crypt($in{'pword'}, join ('', ('.', '/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64]));
	$cryptedpass =~ s/\~/(tilde)/g;
	$cryptedpass =~ s/\|/(pipe)/g;
	$cryptedpass =~ s/\`/(btick)/g;
	$NPConfig{'userdata'} = join('~', $in{'uname'}, $cryptedpass, $in{'email'}, '3');
	$NPConfig{'CommercialUser'} = $in{'CommercialUser'};
	$NPConfig{'EmailFrom'} = $in{'email'};
	$NPConfig{'EmailTo'} = $in{'email'};
	&WriteConfigInfo;
	SetCookies('uname',$in{'uname'},'pword',$in{'pword'});
	$Cookies{'uname'} = $in{'uname'};
	$UserPermissions{$Cookies{'uname'}} = 3;
	$up = 3;
	&ChangeSettings;
	exit;
}
#######
# UPGRADING
#######
# UpgradeHandler: Checks if running an upgrade procedure is necessary.
sub UpgradeHandler {
	unless ($NPConfig{'DateFormat'}) {
		Upgrade_GTD();
	}
	if ($NPConfig{'currentversion'} =~ /^1\.1/) {
		&NPdie("You appear to have just upgraded from a very old version of NewsPro (1.x). Upgrade ability is no longer available for this version.");
	}
	if ($NPConfig{'currentversion'} =~ /^1\.2/) {
		&NPdie("You appear to have just upgraded from a very old version of NewsPro (1.x). Upgrade ability is no longer available for this version.");
	}
	if ($NPConfig{'currentversion'} =~ /&2\./) {
		&UpgradeND3;
	}
	if ($NPConfig{'currentversion'} =~ /^3\.0_(beta|alpha)/) {
		&Upgrade_NumToID;
	}
	if ($NPConfig{'currentversion'} =~ /^3\.0(1|2|3|4)/) {
		&Upgrade_30;
	}
	$NPConfig{'currentversion'} = $npversion;
	$NPConfig{'currentbuild'} = $npBuild;
	&WriteConfigInfo;
}
sub Upgrade_GTD {
	my $thedate = '';
	if ($NPConfig{'Display_Week_Day'}) {
		    $thedate .= "<Field: Weekday>";
	    if ($NPConfig{'Display_Month'}) {
	        $thedate .= ", ";
	    }
	}
	if ($NPConfig{'Display_Month'}) {
	    $thedate .= "<Field: Month_Name> ";
	}
	if ($NPConfig{'Display_Month_Day'}) {
	    $thedate .= "<Field: Day>";
	    if ($NPConfig{'Display_Year'}) {
	        $thedate .= ", ";
	    }
	}
	if ($NPConfig{'Display_Year'}) {
	    $thedate .= "<Field: Year>";
		if ($NPConfig{'Display_Time'}) {
			$thedate .= " -";
		}
	}
	if ($NPConfig{'Display_Time'}) {
	    $thedate .= " ";
	}
	elsif ($NPConfig{'Display_Time_Zone'}) {
	    $thedate .= " ";
	}
	if ($NPConfig{'Display_Time'}) {
	    $thedate .= "<Field: Hour>:<Field: Minute>";
		if ($NPConfig{'12HourClock'} == 1) {
			$thedate .= " <Field: AMPM>";
		}
	    if ($NPConfig{'Display_Time_Zone'}) {
	        $thedate .= " ";
	    }
	}
	if ($NPConfig{'Display_Time_Zone'}) {
	    $thedate .= "<Field: Time_Zone>";
	}
	$NPConfig{'DateFormat'} = $thedate;
}
sub Upgrade_30 {
	$NPConfig{'MaxSearchResults'} = 25;
}
sub Upgrade_NumToID {
	NPopen('NDISP', "$NPConfig{'admin_path'}/ndisplay.pl");
	@ndisp = <NDISP>;
	close(NDISP);
	$ndisplay = "";
	foreach $i (@ndisp) {
		$ndisplay .= $i;
	}
	$ndisplay =~ s/newsitem\$newsnum/newsitem\$newsid/gi;
	NPopen('NDISP', ">$NPConfig{'admin_path'}/ndisplay.pl");
	print NDISP $ndisplay;
	close(NDISP);
	$NPConfig{'ChannelNewsLinks'} =~ s/newsitem<InsertFieldnewsnum>/newsitem<InsertFieldnewsid>/gi;
	$NPConfig{'CreateAnchors'} = 1;
	$NPConfig{'currentversion'} = $npversion;
	$NPConfig{'currentbuild'} = $npBuild;
	&Upgrade_30;
	&WriteConfigInfo;
}
sub UpgradeND3 {
	print header();
	require $ndisplaypl;
	if ($ndisplayversion == 3) {
		&Upgrade_NumToID;
		&MainPage;
		exit;
	}
	&NPHTMLHead("Upgrading NewsPro");
	print qq~
	Welcome to version $npversion of NewsPro. Before you can use NewsPro, your ndisplay.pl file must be modified. NewsPro does this automatically, however for safety reasons it's a good idea to back up ndisplay.pl before it is modified. <br><br>
	<a href="$scripturl?upnd3">Click here to upgrade NewsPro.</a>
	~;
	&NPHTMLFoot;
	exit;
}
sub UpgradeND3Save {
	print header();
	require $ndisplaypl;
	if ($ndisplayversion >= 3) {
		MainPage();
	}
	&NdispAutoUpgrade('LoadNdispAppend3');
	NPopen('NDISP', "$NPConfig{'admin_path'}/ndisplay.pl");
	@ndisp = <NDISP>;
	close(NDISP);
	$ndisplay = join('', @ndisp);
	$ndisplay =~ s/\$linkhtml/\$newshtml/gi;
	$ndisplay =~ s/\$emailtext/\$newshtml/gi;
	$ndisplay =~ s/\$headhtml/\$newshtml/gi;
	$ndisplay =~ s/\$newfilehtml/\$newshtml/gi;
	$ndisplay =~ s/\$ndisplayversion = 2/\$ndisplayversion = 3/gi;
	NPopen('NDISP', ">$NPConfig{'admin_path'}/ndisplay.pl");
	print NDISP $ndisplay;
	close(NDISP);
	&loadND;
	&saveND;
	&Upgrade_NumToID;
	$NPConfig{'currentversion'} = $npversion;
	$NPConfig{'currentbuild'} = $npBuild;
	&WriteConfigInfo;
	&NPHTMLHead("Upgrade Complete");
	print qq~ Your ndisplay.pl file has been upgraded. NewsPro has now been fully upgraded. 
	<p>In this version of NewsPro, addon support has been introduced, and certain features have been removed from the script and are now available as addons. If you used the E-Mail Notification, NewFiles, or Netcenter Channel features, you must download the appropriate addon to use this feature. To download addons, go to the Addon Manager, available from NewsPro's main page, and then click on the Download Addons link.</p>~;
	&NPHTMLFoot;
	exit;
}
	
	
sub NdispAutoUpgrade {
	my $loadsub = shift;
	unless ($loadsub) { $loadsub = "LoadNdispAppend3"; }
	$ndispappend = &$loadsub;
	NPopen('NDISP', "ndisplay.pl");
	@ndisp = <NDISP>;
	close(NDISP);
	NPopen('NDISP', ">ndisplay.pl");
	foreach $i (@ndisp) {
		unless ($i =~ /^\s*1;/) {
			print NDISP "$i";
		} else {
			unless ($NdispModified) { 
				print NDISP $ndispappend; 
			}
			$NdispModified = 1;
			print NDISP $i;
		}
	}
	close(NDISP);
}
sub LoadNdispAppend3 {
	my $nda = q`
# Archive HTML
# The news style used when archiving.
# By default, calls DoNewsHTML. If you'd like a different style, replace this with something like
# sub DoArchiveHTML {
# $newshtml = qq~
# <p><strong><font color="#ff0000">$newssubject</font> </strong><small>Posted $newsdate by <a href="mailto:$newsemail">$newsname</a></small><br>
# $newstext
# </p>
# ~;
# }
sub DoArchiveHTML {
&DoNewsHTML;
}
# Search HTML
# Much like archive HTML - by default, uses DoNewsHTML.
sub DoSearchHTML {
&DoNewsHTML;
}
`;
	return $nda;
}
#######
# CORE INTERNAL SUBROUTINES
######
# NPdie: Generates a pretty error message with as much information as possible.
sub NPdie {
	my $msg = shift;
	if ($HeaderPrinted == 0) {
		print "Content-type: text/html\n\n";
	}
	if ($HTMLHeaderPrinted == 0) {
		&NPHTMLHead("Fatal Error");
	}
	print "<p>An error has occurred. The exact description of the error is: <b>$msg</b>";
	print qq~
	</p><p>If this error indicates a problem that you don't know how to solve, see the NewsPro documentation
	and <a href="http://amphibian.gagames.com/newspro/faq2/">FAQ</a>. If neither of these resources help, you can
	send an e-mail to <a href="mailto:newspro-help-errmsg\@amphibian.hypermart.net">Technical Support</a>.
	Include the full text of this error message (including the section below) and a description of what actions
	prompted the error.</p>
	<table width="90%" border="0" align="center"><tr><td><hr><small><b>USEFUL INFORMATION</b>\n<br>~;
	if ($!) {
		print "Perl may have generated the following error: $!\n<br>";
	}
	print "Perl Version: $]\n<br>";
	print "Script Version: $npversion\n<br>";
	print "Script Build: $npBuild\n<br>";
	print "Script URL: $scripturl\n<br>";
	($0 =~ m,(.*)/[^/]+,)   && unshift (@INC, "$1");	# Get the script location: UNIX /
	($0 =~ m,(.*)\\[^\\]+,) && unshift (@INC, "$1");	# Get the script location: Windows \
	print "Script Location (Method 1): $0\n<br>";
	$dirname = GetDirInfo();
	$dirname =~ s/\\/\//g;
	print "Script Location (Method 2): $dirname\n<br>";
	print '@INC: <ul><li>' . join('</li><li>', @INC) . '</li></ul>';
	print "<br>\n<b>ENVIRONMENT VARIABLES</b>\n<br>";
	foreach $key (keys %ENV) {
		unless ($key eq "HTTP_COOKIE") {
			print "$key: $ENV{$key}\n<br>";
		}
	}
	print "<br>\n<b>MESSAGE:</b> $msg\n<br>";
	print '</pre><hr></td></tr></table>';
	print '</td></tr></table></body></html>';
	exit;
}
# Gets our current absolute path. Needed for error messages.
sub GetDirInfo {
	my $cwd;
	eval 'use Cwd; $cwd = cwd();';
	unless ($cwd) {
		$cwd = `pwd`; chomp $pwd;
	}
	return $cwd;
}
# NPopen: opens a file. Allows for file locking and better error-handling.
sub NPopen {
	my $filehandle = shift;
	my $filename = shift;
	$filename =~ s/([\&;\`'\|\"*\?\~\^\(\)\[\]\{\}\$\n\r])/\\$1/g;
	$filename =~ s/\0//g;
	unless (open($filehandle, $filename)) {
		if ($filename =~ /^\Q>\E/) {
			$filename =~ /^>+(.*)/;
			$translatedfile = $1;
			unless (-e $translatedfile) {
				&NPdie("Could not open file $translatedfile for output (writing).<br><br> This appears to be because the file does not exist, and the script is unable to create is. Most likely, the problem is that you are using a UNIX server and this script does not have permission to write to the directory that $translatedfile is in. <br><br>To solve this, CHMOD that directory 666 or 777 (some servers only like one of those two settings, try both). Another possibility is that the directory the script is trying to write to is invalid; check the paths you've set in Change Settings and make sure they're correct.");
			} else {
				&NPdie("Could not open file $translatedfile for output (writing).<br><br> The file, however, appears to exist. The most likely problem is that this script does not have permission to write to the file. If you are on a UNIX server, to solve this problem you must CHMOD $translatedfile 666 (or 777, depending on your server). This will allow NewsPro to write to it. If you are on a Windows NT server, you must contact your system administrator.");
			}
		} else {
			unless (-e $filename) {
				# Add explanation to error message if user has forgotten to rename npconfig.dat.
				if ($filename =~ /nsettings/) {
					&NPdie("Could not open file $filename for input (reading). This appears to be because it does not exist. Check your directory settings in Change Settings and make sure the paths are correct, and check that all NewsPro files exist on your server. If you are upgrading from an older version, ensure that you have renamed npconfig.dat to nsettings.cgi.");
				}
				&NPdie("Could not open file $filename for input (reading). This appears to be because it does not exist. Check your directory settings in Change Settings and make sure the paths are correct, and check that all NewsPro files exist on your server.");
			} else {
				&NPdie("Could not open file $filename for input (reading). The file, however, appears to exist. The most likely problem is that the script does not have permission to read this file; check the file's permissions, or contact your system adminstrator.");
			}
		}
	}
	if ($UseFlock) {
		flock($filehandle, 2);
	}
}
sub LoadAddons {
	opendir(ADMINDIR,$NPConfig{'admin_path'});
		my @admindir = readdir(ADMINDIR);
	closedir(ADMINDIR);
	my $direntry;
	foreach $direntry (@admindir) {
		if ($direntry =~ /npa_\S+\.pl/) {
			eval { require "$NPConfig{'admin_path'}/$direntry"; };
			if ($@) {
				&NPdie("Error loading addon $direntry. If you continue to experience this error, delete the file $direntry from your NewsPro directory. The exact error produced was: $@.");
			}
		}
	}
	$AddonsLoaded = 1;
}
sub RunAddons {
	my @addonslist = @_;
	my $AddonSub;
	foreach $AddonSub (@addonslist) {
		unless ($AddonFailure) {
			eval { &$AddonSub; };
			if ($@) {
				$AddonFailure = 1;
				&NPdie("Error running addon subroutine $AddonSub. If you continue to experience this error, remove the appropriate addon. Error: $@");
			}
		}
	}
}
sub CheckBuild {
	my $requiredBuild = shift;
	if ($requiredBuild > $npBuild) {
		my $addonName = shift;
		my $addonFile = shift;
		NPdie("An installed addon, $addonName, is not compatible with this version of NewsPro. You must either get a newer version of NewsPro or remove this addon by deleting $addonFile.");
	}
}
#######
# GLOSSARY
#######
# LoadGlossary: Loads the glossary into memory, as @glossary, %Glossary, @glossconv, and %GlossConv
sub LoadGlossary {
	# Load glossary entries in %Glossary
	# Split glossdat into individual glossary pairs.
	@glossentries = split (/\|\|\|/, $NPConfig{'glossdat'});
	foreach $i (@glossentries) {
		# Split the pairs into key and value.
		($key, $value) = split(/\|~\|/, $i);
		# Add entry to %Glossary and @glossary (@glossary used to keep order)
		$Glossary{$key} = $value;
		push (@glossary, $key);
		# HTMLize the glossary entries so they can be displayed in a form.
		$key = &HTMLescape($key);
		$value = &HTMLescape($value);
		# Add HTMLized entries to %Glossary and @glossary
		$GlossConv{$key} = $value;
		push (@glossconv, $key);
	}
}
# FormatGlossary: Turn %Glossary (ordered by @glossary) into delimited & writable format
sub FormatGlossary {
	foreach $i (@glossary) {
		$glossentry = join('|~|', $i, $Glossary{$i});
		push(@glossentries, $glossentry);
	}
	$NPConfig{'glossdat'} = join('|||', @glossentries);
}
# EditGlossary: Display Edit Glossary page
sub EditGlossary {
	unless ($up == 3) {
		&NPdie("You are not authorized to access this.");
	}
	&LoadGlossary;
	&NPHTMLHead("Edit Glossary");
	print qq~
	You may edit the following glossary entries. When submitting news, if the Glossary is enabled,
	text that matches the text you enter in Replace Text will be replaced with what you entered in
	the corresponding Replace Text field. To add a new entry, use the blank fields provided at the bottom.
	(If you fill the available blank fields, click Submit Changes and then choose Edit Glossary again. New
	blank fields will be available.)
	To delete an entry, delete everything in the Replace Text field.
	<form action="$scripturl?glosssave" method="post">
	<table width="100%" border="0">
	<tr>
	<td width="35%"><b>Replace Text</b></td>
	<td width="65%"><b>Replace With</b></td>
	</tr>
	~;
	$glossnum = 0;
	foreach $i (@glossconv) {
		$glossnum++;
		print qq~
		<tr>
		<td width="35%"><input type="text" name="glosstext$glossnum" value="$i" size="16"></td>
		<td width="65%"><input type="text" name="glossreplace$glossnum" value="$GlossConv{$i}" size="38"></td>
		</tr>
		~;
	}
	$glossnum++;
	print qq~
		<tr>
			<td width="35%"><input type="text" name="glosstext$glossnum" size="16"></td>
			<td width="65%"><input type="text" name="glossreplace$glossnum" size="38"></td>
		</tr>
	~;
	$glossnum++;
	print qq~
		<tr>
			<td width="35%"><input type="text" name="glosstext$glossnum" size="16"></td>
			<td width="65%"><input type="text" name="glossreplace$glossnum" size="38"></td>
		</tr>
	~;
	$glossnum++;
	print qq~
		<tr>
			<td width="35%"><input type="text" name="glosstext$glossnum" size="16"></td>
			<td width="65%"><input type="text" name="glossreplace$glossnum" size="38"></td>
		</tr>
	</table>
	<br><div align="center">
	<input type="submit" name="submit" value="Submit Changes">
	</div>
	</form>
	~;
	&NPHTMLFoot;
}
# EditGlossarySave: Saves changes made in EditGlossary
sub EditGlossarySave {
	unless ($up == 3) {
		&NPdie("You are not authorized to access this.");
	}
	foreach $i (keys %in) {
		$in{$i} =~ s/``x//g;
		$in{$i} =~ s/\|//g;
		if ($i =~ /glosstext(\d+)/) {
			push(@glossnumbers, $1);
		}
	}
	foreach $glossnum (sort @glossnumbers) {
        if ($in{"glosstext$glossnum"} ne "") {	
		$Glossary{$in{"glosstext$glossnum"}} = $in{"glossreplace$glossnum"};
		push(@glossary, $in{"glosstext$glossnum"});
		}
	}
	FormatGlossary();
	&WriteConfigInfo;
	&NPHTMLHead("Glossary Saved");
	print qq~ Your changes to the Glossary have been saved. ~;
	&NPHTMLFoot;
}
#######
# HELP
#######
# Displays the actual help page.
sub NPhelp {
	local ($helptopic) = @_;
	&LoadHelp;
	&NPHTMLHead("Help");
	print q~
	<b>General NewsPro Help</b>
	<p> To access the various functions of NewsPro, you must use the navigation bar at the bottom
	of every page. All options available to you are displayed there. If you can't find a solution to a problem 
	or question, there are many places to look. The first place to look is the <a href="http://amphibian.gagames.com/newspro/faq2/">FAQ</a>. Other resources include 
	the <a href="http://amphibian.gagames.com/newspro/advanced.html" target="_top">Advanced Usage</a> page,
	the latest <a href="http://amphibian.gagames.com/newspro/readme.txt">readme.txt</a> file, and the <a href="http://amphibian.gagames.com/newspro/forum/forum.cgi">NewsPro forum</a>.
	</p>
	~;
	print qq~
	<b>Help on: $helptopic</b>
	<p>
	~;
	if ($Help{$helptopic}) {
		print $Help{$helptopic};
	} else {
		print "No help exists on this topic.";
	}
	print "</p>";
	&NPHTMLFoot;
}
# Loads all the help topics.
sub LoadHelp {
	%Help = (
	'' => q~ This is the main entrance page to NewsPro. You can't do anything on this page; choose from one of the functions at the bottom to begin using NewsPro.~,
	'logout' => q~Logs you out of NewsPro by deleting your username and password cookies. Visit any NewsPro page to log in again (you'll have to enter your username and password)~,
	'settingssave' => q~Saves the settings in Change Settings to the NewsPro data file. Visit Change Settings to change these again.~,
	'submit' => q~Allows you to submit a new news item. The standard fields are Subject (a brief subject for your news item), E-Mail (your e-mail address), and News Text (the actual news item). Note that these can be configured, and new ones added, by editing npconfig.pl. You may also see a Glossary On/Off option at the bottom, if the Glossary is enabled. The Glossary automatically replaces a certain piece of text (i.e. the name of your site) with another (i.e. a link to your site's home page). Once you've submitted the news item, it will NOT appear on your news page (unless you use the optional viewnews.cgi module, or have enabled AutoBuild). Instead, you must choose Build News to make the latest news appear on your page.~,
	'submitsave' => q~The news you've just submitted has been saved, to the newsdat.txt news database. To remove this piece of news, go to Modify News. To make the news appear on your home page, go to Build News.~,
	'generate' => q~Build News takes all the news in the newsdat.txt news database, and "builds" it. It generates the news.txt file (your news in HTML form) which is what is displayed on your news page. If you've enabled archiving, it also updates your archive and generates all necessary files. If Headlines are enabled, a file called headlines.txt will be created, with only your news headlines. Finally, if NewFiles is enabled, newfiles.txt will be created, which contains a list of new or recently modified files in a specified directory. To customize/enable any of these options, go to Advanced Settings (archiving options are in Change Settings).~,
	'remove' => q~Modify News allows you to modify or delete news items in the newsdat.txt news database. To modify a news item, simply edit it in the text boxes. To remove an item, select the appropriate option button. Depending on your permissions, you may not be able to edit/remove news items that others have posted.~,
	'removesave' => q~Saves all the changes you made in Modify News. Remember, you must Build News before the changes will appear on your news page.~,
	'settings' => q~Change the basic NewsPro settings. Information on each individual setting is included on the page.~,
	'advset' => q~Change advanced NewsPro settings. All information on individual settings is included on the Advanced Settings page. Send an e-mail or visit the NewsPro Forum with any questions.~,
	'advsetsave' => q~Saves your advanced settings to disk.~,
	'adduser' => q~Allows you to add a new user. Enter a username and password for the user (they will later be able to change their password). As well, you must choose a permission level. In general, Standard is HIGHLY recommended. Webmaster permission level is extremely dangerous; if the user is experienced enough, they will be able to delete files in your account or at the very least destroy your news if they have Webmaster status. As well, you can remove non-webmaster users using the Remove User option. It is impossible to remove a Webmaster user without reinstalling NewsPro (or, to be more specific, the nsettings.cgi configuration file). You cannot both add and remove users in one operation~,
	'userinfo' => q~Here, you can change your e-mail address and/or password.~,
	'editgloss' => q~Edit the Glossary. The Glossary is a function where, when submitting news, a certain string of text in the News Text field can be replaced by another, for example replace the name of your site with a link to your site's home page, or replace :-) with a picture of a smiling face. On the Edit Glossary pages, two blank entries are provided; you may fill these in to add a new glossary entry. You may also edit all existing glossary entries. To delete an entry, simply remove all the text from that field. When submitting news, you will have the option to turn the Glossary on or off (on is default).~,
	'glosssave' => q~Edit the Glossary. The Glossary is a function where, when submitting news, a certain string of text in the News Text field can be replaced by another, for example replace the name of your site with a link to your site's home page, or replace :-) with a picture of a smiling face. On the Edit Glossary pages, two blank entries are provided; you may fill these in to add a new glossary entry. You may also edit all existing glossary entries. To delete an entry, simply remove all the text from that field. When submitting news, you will have the option to turn the Glossary on or off (on is default).~);
	if (@Addons_LoadHelp) {
		&RunAddons(@Addons_LoadHelp);
	}
}
# The End
1;	
	
