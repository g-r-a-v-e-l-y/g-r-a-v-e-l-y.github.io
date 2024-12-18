#!/usr/bin/perl

###############################################################################
# YaBB.pl                                                                     #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################
require "Settings.pl";
require "$sourcedir/Subs.pl";

$Cookie_Exp_Date = 'Mon, 31-Jan-3000 12:00:00 GMT';
&get_date;
&readform;
$cgi = "$boardurl/YaBB.pl\?board=$currentboard";
foreach (split(/; /,$ENV{'HTTP_COOKIE'})) {
	($cookie,$value) = split(/=/);
	if($cookie eq "$cookieusername") { $username="$value"; }
	if($cookie eq "$cookiepassword") { $password="$value"; }
}

if($username eq "") { $username = "Guest"; }

# Load user settings
if($username ne "Guest") {
	open(FILE, "$memberdir/$username.dat");
	&lock(FILE);
	@settings=<FILE>;
	&unlock(FILE);
	close(FILE);
	$settings[0] =~ s/\n//g;
	$settings[1] =~ s/\n//g;
	$settings[2] =~ s/\n//g;
	$settings[3] =~ s/\n//g;
	$settings[4] =~ s/\n//g;
	$settings[5] =~ s/\n//g;
	$settings[6] =~ s/\n//g;
	$settings[7] =~ s/\n//g;
	$settings[8] =~ s/\n//g;
	$settings[0] =~ s/\r//g;
	$settings[1] =~ s/\r//g;
	$settings[2] =~ s/\r//g;
	$settings[3] =~ s/\r//g;
	$settings[4] =~ s/\r//g;
	$settings[5] =~ s/\r//g;
	$settings[6] =~ s/\r//g;
	$settings[7] =~ s/\r//g;
	$settings[8] =~ s/\r//g;
	$realname="$settings[1]";
	$realemail = "$settings[2]";
}

# Write log
open(LOG, "$vardir/log.txt");
&lock(LOG);
@entries = <LOG>;
&unlock(LOG);
close(LOG);
open(LOG, ">$vardir/log.txt");
&lock(LOG);
$field="$username";
if($field eq "Guest") { $field = "$ENV{'REMOTE_ADDR'}"; }
print LOG "$field\|$date\n";
foreach $curentry (@entries) {
	$curentry =~ s/\n//g;
	($name, $value) = split(/\|/, $curentry);
	$date1="$value";
	$date2="$date";
	&calctime;
	if($name ne "$field" && $result <= 15) {
		print LOG "$curentry\n";
	}
}
&unlock(LOG);
close(LOG);

# Load board information
if($currentboard ne "") {
	open(FILE, "$boardsdir/$currentboard.dat");
	&lock(FILE);
	@boardinfo=<FILE>;
	&unlock(FILE);
	close(FILE);
	$boardinfo[0] =~ s/\n//g;
	$boardinfo[2] =~ s/\n//g;
	$boardname = "$boardinfo[0]";
	$boardmoderator = "$boardinfo[2]";
	open(MODERATOR, "$memberdir/$boardmoderator.dat");
	&lock(MODERATOR);
	@modprop = <MODERATOR>;
	&unlock(MODERATOR);
	close(MODERATOR);
	$moderatorname = "$modprop[1]";
	$moderatorname =~ s/\n//g;
}

# Depending on on the action field choose what to do
if ($maintenance == 1) { require "$sourcedir/Maintenance.pl"; &InMaintenance; }
if ($action eq "display") { require "$sourcedir/Display.pl"; &Display; }
if ($action eq "post") { require "$sourcedir/Post.pl"; &Post; }
if ($action eq "post2") { require "$sourcedir/Post.pl"; &Post2; }
if ($action eq "setsmp") { &setsmp; }
if ($action eq "changemode") { &setmode; }
if ($action eq "changemv") { &setmv; }
if ($action eq "setcensor") { require "$sourcedir/Admin.pl"; &SetCensor; }
if ($action eq "setcensor2") { require "$sourcedir/Admin.pl"; &SetCensor2; }
if ($action eq "movethread") { require "$sourcedir/MoveThread.pl"; &MoveThread; }
if ($action eq "movethread2") { require "$sourcedir/MoveThread.pl";	&MoveThread2; }
if ($action eq "notify") { require "$sourcedir/Notify.pl"; &Notify; }
if ($action eq "notify2") { require "$sourcedir/Notify.pl"; &Notify2; }
if ($action eq "removeoldthreads") { require "$sourcedir/RemoveOldThreads.pl"; &RemoveOldThreads; }
if ($action eq "lock") { require "$sourcedir/LockThread.pl"; &LockThread; }
if ($action eq "register") { require "$sourcedir/Register.pl"; &Register; }
if ($action eq "register2") { require "$sourcedir/Register.pl"; &Register2; }
if ($action eq "login") { require "$sourcedir/LogInOut.pl"; &Login; }
if ($action eq "login2") { require "$sourcedir/LogInOut.pl"; &Login2; }
if ($action eq "logout") { require "$sourcedir/LogInOut.pl"; &Logout; }
if ($action eq "removethread") { require "$sourcedir/RemoveThread.pl"; &RemoveThread; }
if ($action eq "removethread2") { require "$sourcedir/RemoveThread.pl"; &RemoveThread2; }
if ($action eq "modify") { require "$sourcedir/ModifyMessage.pl"; &ModifyMessage; }
if ($action eq "modify2") { require "$sourcedir/ModifyMessage.pl"; &ModifyMessage2; }
if ($action eq "profile") { require "$sourcedir/Profile.pl"; &ModifyProfile; }
if ($action eq "profile2") { require "$sourcedir/Profile.pl"; &ModifyProfile2; }
if ($action eq "viewprofile") { require "$sourcedir/Profile.pl"; &ViewProfile; }
if ($action eq "profile") { require "$sourcedir/Profile.pl"; &ModifyProfile; }
if ($action eq "managecats") { require "$sourcedir/ManageCats.pl"; &ManageCats; }
if ($action eq "modifycatorder") { require "$sourcedir/ManageCats.pl"; &ReorderCats; }
if ($action eq "removecat") { require "$sourcedir/ManageCats.pl"; &RemoveCat; }
if ($action eq "createcat") { require "$sourcedir/ManageCats.pl"; &CreateCat; }
if ($action eq "manageboards") { require "$sourcedir/ManageBoards.pl"; &ManageBoards; }
if ($action eq "reorderboards") { require "$sourcedir/ManageBoards.pl"; &ReorderBoards; }
if ($action eq "reorderboards2") { require "$sourcedir/ManageBoards.pl"; &ReorderBoards2; }
if ($action eq "modifyboard") { require "$sourcedir/ManageBoards.pl"; &ModifyBoard; }
if ($action eq "addboard") { require "$sourcedir/ManageBoards.pl"; &CreateBoard; }
if ($action eq "admin") { require "$sourcedir/Admin.pl"; &Admin; }
if ($action eq "viewmembers") { require "$sourcedir/Admin.pl"; &ViewMembers; }
if ($action eq "mailing") { require "$sourcedir/Admin.pl"; &MailingList; }
if ($action eq "editnews") { require "$sourcedir/Admin.pl"; &EditNews; }
if ($action eq "editnews2") { require "$sourcedir/Admin.pl"; &EditNews2; }
if ($action eq "modmemgr") { require "$sourcedir/Admin.pl"; &EditMemberGroups; }
if ($action eq "modmemgr2") { require "$sourcedir/Admin.pl"; &EditMemberGroups2; }
if ($action eq "im") { require "$sourcedir/InstantMessage.pl"; &IMIndex; }
if ($action eq "imremove") { require "$sourcedir/InstantMessage.pl"; &IMRemove; }
if ($action eq "imsend") { require "$sourcedir/InstantMessage.pl"; &IMPost; }
if ($action eq "imsend2") { require "$sourcedir/InstantMessage.pl"; &IMPost2; }
if ($action eq "mlall") { require "$sourcedir/Memberlist.pl"; &MLAll; }
if ($action eq "mlletter") { require "$sourcedir/Memberlist.pl"; &MLByLetter; }
if ($action eq "mltop") { require "$sourcedir/Memberlist.pl"; &MLTop; }

# In no board specified display board index
if ($currentboard eq "") { require "$sourcedir/BoardIndex.pl"; &BoardIndex; }
# No action? Show the message index
require "$sourcedir/MessageIndex.pl";
&MessageIndex;

exit;
