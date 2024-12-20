# ==========================================================================
# FileMan Version 1.01
#
# A Perl file management script to allow file and directory administration
# via a web browser.
#
# COPYRIGHT NOTICE:
#
# Copyright 1998 Gossamer Threads Inc.  All Rights Reserved.
#
# This program is being distributed as shareware.  Please see the
# Readme for registration details. By using this program
# you agree to indemnify Gossamer Threads Inc. from any liability.
#
# Selling the code for this program without prior written consent is
# expressly forbidden.  Obtain permission before redistributing this
# program over the Internet or in any other medium.  In all cases
# copyright and header must remain intact.
#
# Contact Information:
#
# Authors: Alex Krohn, and Patrick Krohn
# Email: alex@gossamer-threads.com  or patrick@gossamer-threads.com
#
# For registration information, visit our website at:
#             http://www.gossamer-threads.com/scripts/register
# ==========================================================================

I. Revision History:
-------------------------------------------------------------------------
    January   24, 1998: Version 1.01 Released
        - &cgierr bug fixed.
        - Javascript replaced, thanks to Wayne Peterson
        - Uploads in ASCII mode any file with .cgi or .pl extension.
    October   24, 1998: Version 1.0 Released
        - Logging capabilities.
        - Enhanced javascript.
        - Lots of bug fixes.
        
    September 12, 1998: Version 0.9 Released
        - First public release.
        
II. Introduction
-------------------------------------------------------------------------
    FileMan is a Perl script that allows webserver files to be managed via
a web browser. All functions such as copying, deleting, moving and
renaming files is done via the browser. This has a number of advantages
for user management of webserver files - For instance: Users do not
have to know FTP or have FTP accounts; Remote administration can be
done over proxy and firewall security systems where network
administrators have limited FTP services for security reasons; FileMan
is operating system independent.

There are two versions of FileMan: a single and multi-user version. The
difference between the two versions is that the multi-user version
allows for a group of users to administer files in separate directories
or folders. The single user version could be used by a webmaster to
administer files on a webserver while the multi-user version is
designed for a group of users who require to manage files in their own
directories.

PLEASE READ THE SECURITY CONSIDERATIONS IN SECTION V.

FileMan is based on an idea by Genesis
(http://www.xav.com/scripts/genesis/index.html) however the script was
written from scratch and bears little relation to the original.

III. Requirements.
-------------------------------------------------------------------------
    FileMan will work on any system capable of running CGI scripts
and with Perl 5 and CGI.pm installed. The only system specific function
is the password protection feature. Currently this is only supported for
Apache based server authentication. If you are on another web server, you 
should disable this feature by setting show_pass = 0 in the config.

IV. Installation.
-------------------------------------------------------------------------
    The following files are included in the archive:

fileman.cgi     The main Script
fileman.log     A log file
Readme.txt      This document

The icons used in the program are available for download separately, from
the website. they are the standard icons distributed with Apache.

You will need to configure several options in fileman.cgi. Open it up in
a good text editor (I recommend Textpad available at http://www.textpad.com/).

You need to set at least:

root_dir       => "/u/web/user/demo",
  - This should be set to the full directory path of the files that are
    to be managed by FileMan. For a single user version of the script
    this parameter might be set to the document root of your webserver.
    Something like '/u/web/docs'. FileMan will not be able to affect
    any files outside of this folder. This folder must be writable
    by the web server, so unless you are using CGIwrap (see Security
    considerations below), you must set the permissions on this
    directory to 0777 (drwxrwxrwx). 

password_dir   => "/u/web/user/cgi-bin/fileman/pass",
  - FileMan can handle Apache based server authentications files. This
    parameter is the directory where it will store all it's password
    files. Gossamer Threads recommends, for security reasons, that this
    directory is outside the document root tree of your webserver. If
    you are unsure where to place this directory, install it under your
    webserver's 'cgi-bin'. Again, unless you are using CGIwrap, this
    directory must be writable by the server so you will need to set
    the permissions to 0777 (drwxrwxrwx). 

root_url       => "http://www.server.com/demo",
  - This is the url of the parameter 'root_dir' defined above.

script_url     => "http://www.server.com/cgi-bin/fileman/fileman.cgi",
  - This is the url of the FileMan script - 'fileman.cgi'. If you
    intend to place the script in your cgi-bin directory then this
    url would be: http://www.server.com/cgi-bin/fileman.cgi

icondir_url    => '/icons',
  - This is the url to find icons. Can be relative (as above) or a full
    url 'http://www.server.com/icons'. However try to use relative as it
    reduces the amount of html sent to the browser.

The following options are optional.

allowed_space  => 500,
  - This is the maximum allowable space in kilobytes you are allowed.

max_upload     => 75,
  - This is the maximum upload size in kilobytes.

The following options can be turned off by setting them to '0'
show_size      => 1,
  - Show file size in the directory listing
show_date      => 1,
  - Show the file's change date
show_perm      => 1,
  - Show/Allow changes to file permissions
show_icon      => 1,
  - Use Icons
show_pass      => 1
  - Use the password feature.

You should now ftp your files up in ASCII mode (except the icons)
and set permissions as follows (assuming the above url's and paths):

    /cgi-bin
    /cgi-bin/fileman
    /cgi-bin/fileman/pass               (777) drwxrwxrwx
    /cgi-bin/fileman/fileman.cgi        (755) -rwxr-xr-x
    /cgi-bin/fileman/fileman.log        (666) -rw-rw-rw-
    /demo                               (777) drwxrwxrwx    

NOTE: You should now password protect the fileman dir to prevent other 
      users on the web from accessing your files.

You can set up icons as well. The default is:

    %icons = (
                'gif jpg jpeg bmp'      => 'image2.gif',
                'txt'                   => 'quill.gif',
                'cgi pl'                => 'script.gif',
                'zip gz tar'            => 'uuencoded.gif',
                'htm html shtm shtml'   => 'world1.gif',
                'wav au mid mod'        => 'sound1.gif',
                folder                  => 'folder.gif',
                parent                  => 'back.gif',
                unknown                 => 'unknown.gif'
    );

The format is:

    'space separated list of extensions' => 'image name in icons dir to use'
    
with three special ones: 'folder' for directories, 'parent' to indicate a
parent directory and 'unknown' for any file that doesn't match the above
extension.

V. Security Considerations
-------------------------------------------------------------------------
    This script has been designed as safe as possible, however if not set
up properly, it can leave your website open to attack. Here are three
security rules to follow:
    
    1. Always, always, always password protect the directory fileman.cgi
       is in. Leaving it not password protected is a major security risk!
    2. If you don't trust the user of the program 100% (i.e. it is for someone
       else, not your own use) then make sure FileMan can not edit itself. The
       FileMan root (/demo in above example) must not contain the fileman.cgi
       program. Otherwise the user could simply edit the program and change
       the setting!
    3. If you don't tryst the user of the program 100%, make sure show_perm is
       set to 1. Otherwise the user will be able to run any program he likes 
       on your account!

Another point to be aware of is: FileMan will run as the web server! This can
have some annoying consequences. For instance, all files created by FileMan will
be owned by the web user (often a user called 'nobody') and you may not have
permission to delete the file via FTP. FileMan works best when run under a
program like CGIWrap that execute CGI scripts under your own userid. Ask your
ISP if you have it installed!

VI. Support
-------------------------------------------------------------------------
    If you are having problems with the script, please visit the Gossamer
Threads support forum at:

    http://www.gossamer-threads.com/scripts/forum/
    
That's the best way to get a quick reply!

Cheers,

Alex