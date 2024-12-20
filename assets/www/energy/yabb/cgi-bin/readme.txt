###############################################################################
# readme.txt                                                                  #
###############################################################################
# Yet another Bulletin Board version 1                                        #
# Written by Zef Hemel of Significon, 2000                                    #
# =========================================================================== #
# Copyright (c) 2000 Zef Hemel. All Rights Reserved.                          #
# =========================================================================== #
# Website: http://www.yabb.com.ru                                             #
###############################################################################

############## Installation guide #############################################
1.	Open YaBB.pl change the path to PERL, for example if perl is located
	at /usr/sbin/perl the first line should be #!/usr/sbin/perl
	Normally you can leave the first line as it is. On NT servers this normally is something
	like #!c:\perl\bin\perl.exe
2.	To modify the header and footer of each page, modify the template.html file also
	change the location of the included logo (you can replace it with your own). DON'T
	edit the template file with frontpage or similiar product, because quite obviously this
	will remove all <yabb> tags included, this will cause no menu.
3.	Create a directory for the board and upload all files in the following structure:

Directory    File             CHMOD            Upload as
---------    ----------       -----------      ------------
/                             777              N/A
/Boards                       777              N/A
/Boards      All files        666              ASCII
/Images                       (Leave as is)    N/A
/Images      All files        (Leave as is)    Binary
/Members                      777              N/A
/Members     admin.dat        666              ASCII
/Members     memberlist.txt   666              ASCII
/Members     .htaccess        (Leave as is)    ASCII
/Messages                     777              N/A
/Sources     All files        (Leave as is)    ASCII
/Variables                    (Leave as is)    N/A
/Variables   All files        666              ASCII
/            Settings.pl      (Leave as is)    ASCII
/            template.html    (Leave as is)    ASCII
/            YaBB.pl          755              ASCII

4.	No open Settings.pl in your Notepad or another ASCII editor. Edit all variables as
	described in there, especially don't forget the $boardurl. And reupload this file.
5.	Visit http://www.yoursite/yabbdir/YaBB.pl it should work now...
6.	Now to access the admin, you should login. Username: admin Password: admin
7.	Now you're logged in (at the menu at top right, there is an admin link), but first
	change your profile.
8.	Now you can access the admin and create cats, boards etc.

############## Frequently Asked Questions ################################
Tip: Most frequent answer to most of your questions is: RTFM (Read the F**cking Manual), so
	first make sure you uploaded everything as we say above, if you don't know how to do this
	download WS_FTP LE (from for example http://download.cnet.com), it's free and can do
	anything you want.

Q.	When I visit my board it gives me a error 500 (505) error!
A.	Mostly this is caused by one of the following:
*	You did not upload all files as ASCII (except for the images)
*	You cannot execute perl script outside your cgi-bin, move all files to this directory.
	Except for the help.html file and Images directory.
*	Something is wrong in your Settings.pl file, open it and change all variables as
	described there. Make sure that if you're using a @ you have to put a \ in front of
	it (\@).
*	Your Sources directory is not specified as it should be
*	On some free hosts you should put all paths as absolute paths so, ./directory is
	not allowed but /home/user/cgi-bin is, then change all paths to absolute paths.
*	You're not allowed to execute files that end with .pl, rename YaBB.pl to YaBB.cgi and
	change all referers in all files (yes it is a lot of work) to these files

Q.	I cannot login as admin!
A.	When you just installed YaBB the username you should login with is admin and the
	password is admin too. If this doesn't work with you, it is probably caused by one
	of the following:
*	You did not upload all files as ASCII (make sure at least the Members/admin.dat file
	has been). Also this file should be chmodded 666. If you don't know how to how to
	upload a file as ASCII, first rename these files to .txt and when they're on the server,
	rename them to their original name.
*	You have not changed the $boardurl variable in the Settings.pl file (you can check this
	by looking at the location bar, are you at the yabb site? http://www.yabb.com.ru?) change
	this.
*	Your admin.dat file is messed up, make sure that at the eighth line it says:
	Administrator

Q.	My images don't appear!
A.	You should put the Images directory outside the cgi-bin. Also you should change the
	$imagesdir to the url of your images directory. DON'T link to our images
	directory! If the logo at the top left of each page doesn't work, edit the template.html
	file to edit the location of the logo file.

Q.	My Message Index is messed up, what can I do?
A.	At the moment nothing, YaBB 1 is not meant for heavy traffic site, as yours probably is,
	we're working on a rewrite which can handle a lot of traffic.

Q.	When I access YaBB.pl it shows me the source instead of running the program
A.	You're not allowed to execute files that end with .pl, rename YaBB.pl to YaBB.cgi and
	change all referers in all files (yes it is a lot of work) to these files

Q.	Can I have multiple moderators for a board?
A.	No, in the current version you can't
