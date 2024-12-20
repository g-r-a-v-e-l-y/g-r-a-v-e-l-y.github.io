If you're upgrading from a previous version, see the upgrade instructions on the
NewsPro web site.

Readme - NewsPro 3.7.5
http://amphibian.gagames.com/

IMPORTANT: Before you run NewsPro, you must read and agree to the license,
which is included near the top of newspro.cgi. If you do not agree to this,
you may not run NewsPro.


****************************************************
               SERVER COMPATIBILITY
****************************************************

NewsPro will work on most Unix (& Linux & BSD) and Windows servers. It does
not appear to work properly on MacOS 9 and lower systems (with MacPerl).

Perl 5 is required; on Windows, a recent version of ActivePerl is required.

On Windows NT systems, the administrator may need to change permissions
so that newspro.cgi can write to files in its directory.

If your server requires that CGI scripts have a .pl extension, you can simply
rename newspro.cgi and viewnews.cgi to newspro.pl and viewnews.pl. No script
changes are necessary. DO NOT rename nsettings.cgi, as it is not meant to be
run.


****************************************************
               INSTALLATION SYNOPSIS
****************************************************

Already *very* experienced with Perl scripts? Then follow these instructions:

Copy all files into a world-writable directory. Make ndisplay.pl, news.txt, 
nsettings.cgi, and newsdat.txt world-writable (CHMOD 666). Make newspro.cgi
and viewnews.cgi executable (CHMOD 755). Launch newspro.cgi from browser. 

Once set up, news will be written to news.txt, which can be included into an
HTML page via any method which can include a normal text file. 
Do not use viewnews.cgi unless you have read this readme.

If you have any problems, read the full instructions below, which are about 20
times longer and more detailed.

****************************************************
                   INSTALLATION
****************************************************

Installation is a simple, 4-step procedure, but you should read these
instructions carefully. Make sure that you CHMOD all files as necessary.

Before requesting support, make sure that you have read through this whole
document and the FAQ (http://amphibian.gagames.com/newspro/faq2/).

There are some prerequisites to using NewsPro: you must be familiar with FTP,
HTML, and hopefully have some previous experience setting up CGI scripts. As
well, make sure that your web host supports CGI scripts -- many (in particular
free hosts) do not.

NewsPro will NOT work on the Tripod web hosting service.

#	Parts of these instructions which most users will not have to read are
#	labelled with # signs, like this paragraph. If you have problems, read
#	these sections.

###
# STEP 1
###

First, change the first line in newspro.cgi and viewnews.cgi. It should be #!
followed by the path to Perl 5 on your server. If you don't know the path to 
Perl 5 on your server, see your web host's support pages.

#	Some servers also have Perl 4, an older version, installed. If you have
#	problems, make sure you're pointing at Perl 5.001 or higher, as NewsPro 
#	will not work at all with Perl 4.
#
#	Users of the HyperMart web service should use #!/usr/local/bin/perl

For most users, this is all the text file editing that you have to do.



###
# STEP 2
###

Next, FTP all the files to your server IN ASCII MODE (*not* binary mode, or
auto-detect). Your FTP program should have this as an option; if not, download
WS_FTP LE (free) from http://www.wsftp.com/. They should all go in the same
directory. 

IMPORTANT: If there's already a file called .htaccess in the directory you are
uploading to, don't overwrite it.

#	Most servers require that CGI scripts have a .cgi extension. All the
#	NewsPro	CGI scripts have a .cgi extension. Many of NewsPro's files have
#	a .pl extension; these SHOULD NOT be renamed, as they are NOT CGI
#	scripts. If your server requires that CGI/Perl scripts have a .pl
#	extension, you can rename newspro.cgi and viewnews.cgi to newspro.pl and
#	viewnews.pl. DO NOT RENAME NSETTINGS.CGI! It isn't an executable CGI
#	file, despite the extension, and cannot be renamed.

Next, you must CHMOD files and directories. You should be able to CHMOD from
your FTP client; if not, get a new one, like WS_FTP (link is above).

You do NOT have to CHMOD if your server runs the Windows NT operating system. If
you're not sure of which operating system your server runs, chances are it's
UNIX, which means you do have to CHMOD files.

#	If you're using WS_FTP, use the following guide to translate CHMOD 
#	numbers to the boxes in the CHMOD dialog box:
#	666 = Read & Write for all three columns, 
#	755 = Read, Write & Execute for Owner, Read & Execute for Group & Other, 
#	777 = Read, Write & Execute for all.
#	To CHMOD in WS_FTP, right-click on a file and choose the CHMOD option.

First, CHMOD the NewsPro directory 777. (Some servers prefer 755 -- use this if 
you have problems.)


Then, you must CHMOD certain files:
- newspro.cgi   CHMOD 755 (or 777 if problems occur) 
- viewnews.cgi  CHMOD 755 (or 777 if problems occur)
- ndisplay.pl   CHMOD 666 (or 777 if problems occur) 
- nsettings.cgi CHMOD 666 (or 777 if problems occur) 
- newsdat.txt   CHMOD 666 (or 777 if problems occur) 
- news.txt      CHMOD 666 (or 777 if problems occur) 


	
###
# STEP 3
###

Now, access newspro.cgi via your web browser, i.e. at
http://www.example.com/newspro/newspro.cgi. It should display a login page.

#	IF IT DOES NOT DISPLAY A LOGIN PAGE:
#
#	- If you uploaded a file called .htaccess in Step 2, delete it. NewsPro
#	  will still work without that file.
#
#	- If it simply displays the source of the script, ensure that you have
#	CHMODded all the files correctly, and that if your server requires you
#	to place CGI scripts in a cgi-bin directory, you have done so.
#
#	- If you get the dreaded 500 Internal Server Error or 403 Forbidden,
#	then:
#		- Double-check all your CHMOD settings. Experiment with them...
#		- Ensure that the first line of newspro.cgi points to the 
#		  correct path to Perl on your server.
#		- Try running another CGI script (you can find one at
#		  http://cgi.resourceindex.com/) in the same directory.
#		- See the Installation section of the NewsPro FAQ
#		  at http://amphibian.gagames.com/newspro/faq2/
#		  
#	- E-mail newspro-help@amphibian.hypermart.net for help. Provide as many
#	details as possible; if you simple send an e-mail that says "I'm getting
#	an error!", it's impossible to help you. If you have telnet
#	(shell) access to your server, telnet in, switch to the newspro
#	directory, and type:
#	/path/to/perl/as/at/the/top/of/newspro newspro.cgi
#	(omit the #! from the path to perl in newspro.cgi)
#	and then e-mail the results to the address mentioned above.

At the login screen, type in 'setup' (no quotes) as the username, and leave
the password blank. Click Submit. The web-based setup procedure will begin, and
instructions will be provided as you go along.

You will be asked whether your site is commercial or non-commercial. Answer
this honestly!  Not doing so is a violation of the license that you agree to by
using NewsPro, and by violating the license you can be barred from using this
script at all. In particular, remember that sites with any paid advertising
placed by the owner (i.e. not required by the hosting service) are considered
commercial. NewsPro is still free for commercial sites, however they do have to
display a small link to the script on their news page.

#	One note for the web-based procedure: you will be asked for absolute
#	paths to three different NewsPro directories, the Program Files path,
#	the News Files path, and the Archive path. The Admin path is the
#	directory where you just copied all the files. If that admin path is NOT
#	a cgi-bin directory, it is generally best to make all three paths the
#	same. If, however, it is a cgi-bin directory, you may have server
#	problems if you keep your news files in it. Create another directory,
#	outside your cgi-bin, and CHMOD it 777. Set the News File and Archive
#	paths to that directory.
	
###
# STEP 4
###


At this point, the NewsPro script will have been installed. Next, you need to
set up your pages to work with NewsPro. NewsPro will write your news to the file
news.txt, in the directory you specified as your HTML directory during setup.
You must make sure this file exists and is CHMOD 666 or 777 (you should have
done this during file copying). This file must be "included" in your pages via
SSI (Server Side Includes) or any other method which can include a text file
into an HTML page.

In order to use SSI, you will probably have to give your HTML page a .shtml
extension.

To include your news in your page, insert the following code
into your page where you want the news to be:

<!--#include virtual="news.txt" -->

This assumes that news.txt is in the same directory as your page. If news.txt
is, for instance, located at
http://www.mysite.com/mypage/cgi-bin/newspro/news.txt, and the file you're
including it in is in any other directory on your site, use:

<!--#include virtual="/mypage/cgi-bin/newspro/news.txt" -->

NOTE: When using server-side includes and "#include virtual", do not use
absolute paths. Simply use the URL of the page, minus http://www.mysite.com, as
in the example above. If you do need to use absolute paths, use "#include file"
instead.

#	TROUBLESHOOTING: If you've added news, built news, and followed these
#	instructions and you still don't see the news on your page...
#		- If you don't see ANYTHING where the news should be, your
#		server is not looking for server-side includes in that file. Try
#		giving the file a .shtml extension. If that doesn't work,
#		contact your system administrator. If you can't use server side
#		includes, you can use some of the features of the script via
#		viewnews.cgi; replace your news page with a link to
#		viewnews.cgi?news. You can also use any other method of
#		including a text file into a page. For instance, try renaming
#		your news HTML file news.php3 and inserting the line
#		<?php include("/absolute/path/to/news.txt"); ?>
#		where you want the news to be.
#		
#		- If you see [an error occurred while processing this directive] 
#		or something similar, the server can't find the file it's trying 
#		to include. Try using 
#		<!--#include file="/absolute/path/to/news.txt" -->.
#		If that doesn't work, make sure that your news files directory 
#		is not inside your cgi-bin.

That's it! NewsPro is now set up for basic operation. For more advanced
information, visit the NewsPro web site at
http://amphibian.gagames.com/.



****************************************************
                        USAGE
****************************************************

This program was designed so that basic usage (adding, building, and deleting
news) wouldn't require any explanation. If that's all you need to do, and you
don't need any extensive customizations to the news style, you can probably stop
reading here. An explanation of more advanced features follows.

One important note is to be very cautious when creating new users and giving
them Webmaster privileges. A user with Webmaster privileges cannot be deleted,
and they can change all the settings. Be careful!

To edit your news style, you can simply edit via the text box in Change
Settings. Any editing of news style requires basic knowledge of HTML, by the
way; this is a prerequisite to making a decent web page in any case. Many
tutorials are available on the web if you'd like to learn. 

	More advanced editing - anything other than raw HTML - can by done by
	editing ndisplay.pl. The box in Change Settings is a simplified
	interface to the ndisplay.pl file; once you have edited it manually, you
	can no longer use Change Settings to change the style. For examples of
	editing	ndisplay.pl, see the Advanced section below.

In NewsPro, all news is kept in a database (newsdat.txt). News is never
automatically deleted from that file, even if you have auto-hide or
auto-archive enabled. If you have auto-hide enabled, that simply means that
old news will not be displayed to viewers of your page. If you later disable
auto-hide, that news will reappear.

The feature which needs the most explanation is archiving. It works as follows:
- If you choose to archive in one single file, your archive will be created in a
file in your archive directory called archive.txt. You must include this in a
page as with news.txt.

- If you choose to archive in monthly files, things get a little more
complicated. Because it would be extremely inconvenient to have to create a new
HTML file and include a text file in it each month, NewsPro will create HTML
files as well as text files.

It will create, for each month's archive, both a HTML file (arcmonth_year.html)
and a text file (arcmonth_year.txt). The text file will be like the news.txt
file: just the news. The HTML file will be based on the file archive.tmpl. You
can customize archive.tmpl to suit the look and feel of your site. Simply insert
<InsertDate> into archive.tmpl where you want the month of the archive to
appear, and <InsertNews> to insert the archived news for that month.

As well, it will create a page that links to all the different monthly archives.
This file is called, by default, archive.html. It is based on arclink.tmpl:
<InsertLinks> in this file will be replaced by the links to the monthly archive
files.

Also, remember that this archiving will ONLY be done when you choose Build News
from NewsPro.

****************************************************
                      ADVANCED
****************************************************

For much more information, and examples of customization (i.e. how to make the
date appear once above all the news for a day, how to add your own fields),
visit the following URL:

http://amphibian.gagames.com/newspro/advanced.html

The best source for information about customizations is the NewsPro forum at:

http://amphibian.gagames.com/newspro/forum/forum.cgi

Search through previous messages, and if you don't find an answer, post your
own.

***************************************************
       		VIEWNEWS.CGI
***************************************************

Viewnews.cgi is a separate script that allows your users to interact with your
news database. It is completely optional, and many users don't even install it
on their servers. While it shouldn't be too difficult, it is not
self-explanatory like newspro.cgi. It is not very well documented, but here is a
brief run-down of what it can do.

GENERAL: The script must be in the same directory as newspro.cgi, npconfig.dat,
etc. By default, the script generates very plain-looking and fairly ugly pages.
To configure the style of script pages, edit the file viewnews.tmpl. It contains
brief instructions as a comment inside; basically, it is just a HTML file with
<InsertTitle> and <InsertContent> in the appropriate places. 

** The viewnews.tmpl file applies to every page OTHER than the one generated 
** when viewnews.cgi is called directly, without any parameters. Viewnews.cgi is
** intended to be called directly only when including it into a page via
** server-side includes, and of course when including it into another page there
** is no need for a template file.

SEARCHING: The most-used function of viewnews.cgi is to allow users to search
through your news. The search function is fairly primitive, but... it works.
There are two ways of accessing it. The first is via a simple search form. The
easiest way to set up this form on your page is to access
viewnews.cgi?dispsearchform from your web browser, and cut-and-paste the HTML
code it produces. Note that the searchfield list box is completely optional, and
in fact most of the time it's better left out. The second way to access the
search function is by calling the script with ?search followed by the search
term. For instance, if you want to search for the word "strawberry", you would
use URL http://your.server/viewnews.cgi?searchstrawberry This is useful mainly
for links from your page; for instance, you could set up your news so that when
a user clicked on the name of the news author, every news item which included
that author's name would be displayed.

DYNAMICALLY GENERATED NEWS: Viewnews.cgi can be included via SSI (<!--#include
virtual="viewnews.cgi"-->) to display the latest news on your page. This behaves
almost exactly like news.txt, except it generates the news every time from
newsdat.txt (news therefore shows up as soon as it's submitted, you don't need
to build news). In general, using the standard news.txt is faster, more secure,
and easier on your server. 

E-MAIL NOTIFICATION LIST: Users can add or remove themselves from your e-mail
notification list (provided you have installed the e-mail notification addon).
For a cut-and-paste example of the form used to do this, visit
http://your.server/viewnews.cgi?emaillistform

VIEWING SPECIFIC NEWS ITEMS: Viewnews.cgi can be called in the following way to
display only certain news items: http://your.server/viewnews.cgi?newsstart0end6
which would display news items 0 through 6. Your first news item is number 0.
viewnews.cgi?newsall will display every single news item.
viewnews.cgi?newsid9278987,4563, will display the news item with ID
9278987,4563,  

VIEWING NEWS ITEMS BY DATE/TIME: viewnews.cgi?archive1998-12-20to1999-5-13
will display items in that date range (December 20, 1998 to May 13, 1999)
viewnews.cgi?archivepast3days will display items from the last 3 days.
The same results can also be achieved using a form. For cut-and-paste examples
of these forms, go to viewnews.cgi?disparchiveform

****************************************************
                    VERSION INFO
****************************************************

3.7.5 - May 31, 2000
FIXED:  Security bug with certain implementations of crypt().
FIXED:	As usual, several minor things.

3.7.4 - March 21, 2000
FIXED:  Minor problems with Modify News.
FIXED:  Minor bugs and problems.
ADDED:  The ability to specify the path to nsettings.cgi in nplib.pl.

3.7.3 - February 22, 2000
FIXED:	Problems when displaying individual news items with viewnews.cgi.

3.7.2 - February 20, 2000
FIXED:	A last minute change before the release of 3.7.1 caused occasional
	problems where users would be prompted to download a file rather than
	see the login screen.

3.7.1 - February 20, 2000
CHANGED: npconfig.dat is now known as nsettings.cgi. This is both for security
	 and to avoid confusion with npconfig.pl.
CHANGED: Modify News will now only display news modifiable by the current user.
CHANGED: This release contains a great many small tweaks and changes, too
	 numerous to list.

3.7 - October 15, 1999
CHANGED: All date settings. Completely new way of defining dates, via Change
	 Settings.
CHANGED: Translation support. Now there's a good chance that translations
	 actually will be made available.
CHANGED: Some details of addon support. Older addons are still compatible.
ADDED:   EnableBROption Advanced Setting: allows you to control whether line
	 breaks in Submit News are automatically converted into <br> (previously
	 this was always done).
FIXED:   Errors when odd characters used in glossary.
FIXED:   Errors when odd characters used in usernames.

3.6.1 - August 29, 1999
FIXED: Change Settings would not work during the setup procedure.

3.6 - August 28, 1999
FIXED: 	Search bug where the first news item would always be included (often
	multiple times) in search results.
ADDED: 	Language support. All messages visible to standard- or high-level users
	are now in a file called nplang.pl which can easily be edited.
	Translated versions of NewsPro will now be made available.
CHANGED: No longer requires the Perl Time::Local module. While this is supposed
	 to be a standard module, many servers appear not to have it.
CHANGED: Speed tweaks in news loading routine. Building news should be slightly
	 faster, modifying should be considerably faster. As well, less memory
	 is used.
FIXED: Bugs when modifying news and using the DisableHTML option.
FIXED: Problem when adding users with the ~ character in their names.


3.05 - August 4, 1999
FIXED: Endless loop when viewnews.cgi couldn't open viewnews.tmpl.
FIXED: 	Intermittent bug where NewsPro suddenly decided it was
	upgrading from version 1.0.
CHANGED: Whenever news is filtered by a number of days, the definition used is
	no longer the current time minus (days times 24 hours) but all of today
	and the	last (number) days.
CHANGED: Settings now use dropdown menus rather than radio buttons.
ADDED: 	MaxSearchResults setting (control the maximum number of search
	results displayed)
CHANGED: Search results are now sorted first by how many words in the search
	 string were matched, then by date.
CHANGED: The installation instructions in this readme have been rewritten to
	 deal with common installation problems.
CHANGED: Script colours. Figured it was time.
CHANGED: URLs updated to reflect new address for NewsPro site.
CHANGED: The news category is no longer part of the news ID number. This means
	 that news ID numbers have changed since the last version; you
	 will have to update any static links that you may have.
ADDED: 	Server problems workaround sections in newspro.cgi and viewnews.cgi;
	some variables to set in the scripts themselves to get around some
	relatively common server problems.

Older version history isn't here anymore...


Requirements:
- Perl 5.001 or higher. 99% of web servers which support CGI scripts have this.
	On Windows NT, you need Perl 5.005 or higher.
- Server Side Includes (SSI). 99% of web servers which support Perl have this.

	You may have to enable it, though only if it doesn't work at first; if
	you
	use an Apache server (60% of Web servers are Apache), create a file
	called
	.htaccess in your main directory and add the lines below (if it already
	exists, add these lines to the bottom):
		AddHandler server-parsed .html .htm .shtml
	(if it still doesn't work, then add the following below:)
		Options Includes ExecCGI
	Now, all .html, .htm, and .shtml files will support Server Side
	Includes.
	
- Browser that supports Cookies. Any recent browser will support Cookies, just
make sure you didn't disable them.



****************************************************
                     THE END
****************************************************