#!/usr/local/bin/perl
#
# FileMan Version 1.01
#
# A Perl file management script to allow file and directory administration
# via a web browser.
#
# COPYRIGHT NOTICE:
#
# Copyright 1998 Gossamer Threads Inc.  All Rights Reserved.
#
# This program is being distributed as shareware.  It may be used and
# modified free of charge for personal, academic or non-profit
# use, so long as this copyright notice and the header above remain intact.
# Any commercial use should be registered.  By using this program
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


# Required Libraries
# --------------------------------------------------------  
#   use strict;     # File uploads don't work with use strict in place, although script compiles with use strict.
    use vars qw(%config %icons $in);
    use CGI  qw(:cgi);
    $in = new CGI;

# Configuartion
# --------------------------------------------------------
    %config = (
                root_dir                => "/usr/local/www/data/pb/newspro/",
                logfile                 => "/usr/local/www/data/pb/newspro/fileman.log",
                password_dir            => "/usr/local/www/data/pb/newspro/pass",
                root_url                => "http:129.100.108.56/pb/",             
                script_url              => "http://129.100.108.56/pb/newspro/fileman.cgi",              
                icondir_url             => 'http://129.100.108.56/apacheicons',                
                use_flock               => 1,
                allowed_space           => 200000,
                max_upload              => 100,
                show_size               => 0,
                show_date               => 1,
                show_perm               => 1,
                show_icon               => 0,
                show_pass               => 0,
                version                 => '1.0'
    );

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
# --------------------------------------------------------  

# --------------------------------------------------------
# Run the program and trap fatal errors.
    eval { &main; };
    if ($@) { &cgierr ("Fatal Error: $@"); }
# --------------------------------------------------------

sub main {
# ==========================================================================================
# 1. Get the form input, and print the HTTP headers.
#
    $|++;                       # Flush Output
    print $in->header('text/html');
    
    my ($working_dir) = $in->param('wd');               # Our current working directory.
    my ($filename)    = $in->param('fn');               # Filename to edit, delete, etc.
    my ($name)        = $in->param('name');             # Org. filename to rename.
    my ($newname)     = $in->param('newname');          # New filename in rename.
    my ($directory)   = $in->param('dir');              # Directory to make/delete/change to.
    my ($newperm)     = $in->param('newperm');          # New permissions to set.
    my ($action)      = $in->param('action');           # Action to take.
    my ($user)        = $in->param('user');             # Username to add to password list.
    my ($pass)        = $in->param('pass');             # Password to add to password list.

# 2. Validate the form input. This makes sure any passed in information is valid. After this
#    the information is assumed safe.
    my ($error);
    ($working_dir, $error) = &is_valid_dir  ($working_dir); $error and &user_error ("Invalid Directory: '$working_dir'. Reason: $error", "$config{'root_dir'}/$working_dir");
    ($filename,    $error) = &is_valid_file ($filename);    $error and &user_error ("Invalid Filename: '$filename'. Reason: $error", "$config{'root_dir'}/$working_dir");
    ($name,        $error) = &is_valid_file ($name);        $error and &user_error ("Invalid Filename: '$name'. Reason: $error", "$config{'root_dir'}/$working_dir");
    ($newname,     $error) = &is_valid_file ($newname);     $error and &user_error ("Invalid Filename: '$newname'. Reason: $error", "$config{'root_dir'}/$working_dir");
    ($newperm,     $error) = &is_valid_perm ($newperm);     $error and &user_error ("Invalid Permissions: '$newperm'. Reason: $error", "$config{'root_dir'}/$working_dir");
    ($user,        $error) = &is_valid_user ($user);        $error and &user_error ("Invalid Username: '$user'. Reason: $!", "$config{'root_dir'}/$working_dir");
    ($pass,        $error) = &is_valid_user ($pass);        $error and &user_error ("Invalid Password: '$pass'. Reason: $!", "$config{'root_dir'}/$working_dir");

# New directory name is special. It has to pass both a filename, and directory test.
    ($directory, $error)   = &is_valid_dir  ($directory);   $error and &user_error ("Invalid Directory: '$directory'. Reason: $error", "$config{'root_dir'}/$working_dir");
    ($directory, $error)   = &is_valid_file ($directory);   $error and &user_error ("Invalid Directory: '$directory'. Reason: $error", "$config{'root_dir'}/$working_dir");

# 3. Set the current working directory, and current working url.
    my ($dir, $url);
    if ($working_dir) {
        $dir        = "$config{'root_dir'}/$working_dir";
        $url        = "$config{'root_url'}/$working_dir";
    }
    else {
        $dir        = $config{'root_dir'};
        $url        = $config{'root_url'};
    }

# 4. Print HTML intro.

# Javascript form validation.
    my $javascript = qq~
<script language="Javascript">
<!-- Hide from old browsers
    function validateFileEntry(validString, field) {
        var isCharValid = true;
        var i, invalidChar;
        for (i=0; i<validString.length; i++) {
            if (validString.charAt(0) == '.') {
                isCharValid = false;
                validString = validString.substr(1, validString.length-1);
                i = validString.length;
            }
            if (validateCharacter(validString.charAt(i)) == false) {
                isCharValid = false;
                invalidChar = validString.charAt(i);
                validString = validString.substr(0, i) + validString.substr(i+1, validString.length-1);
                i = validString.length;
            }
        }
        if (i < 1) { return false; }
        if (isCharValid == false) {
            if (invalidChar) alert("Invalid filename. Can't contain '" + invalidChar + "'. Filename adjusted.");
            else alert('Invalid filename. Filename adjusted.');
            if (field) {
                field.value = validString;
                field.focus();
                field.select();
            }
            return false;
        }
        return true;
    }

    function validateCharacter(character) {
       if ((character >= 'a' && character <= 'z') || ( character >='A' && character <='Z') || ( character >= '0' && character <= '9') || ( character =='-') || ( character == '.') || ( character == '_')) return true; 
       else return false;
    }

    function isNum(passedVal) {
        if (!passedVal) { return false  }
        for (i=0; i<passedVal.length; i++) {
            if (passedVal.charAt(i) < "0") { return false }
            if (passedVal.charAt(i) > "7") { return false }
        }
        return true
    }

    function renameFile ( name ) {
        var newname = window.prompt("Rename '" + name + "' to: ",'')
        if (newname != null) {
            if (validateFileEntry(newname)) {
                window.location.href = "$config{'script_url'}?action=rename&name=" + name + "&newname=" + newname +"&wd=$working_dir"
            }
        }
    }

    function deleteFile ( name ) {
        if (window.confirm("Are you sure you want to delete '" + name + "'")) {
            window.location.href = "$config{'script_url'}?action=delete&fn=" + name + "&wd=$working_dir"
        }
    }

    function deleteDir ( name ) {   
        if (window.confirm("Are you sure you want to delete the directory '" + name + "'")) {
            window.location.href = "$config{'script_url'}?action=removedir&dir=" + name + "&wd=$working_dir"
        }
    }   

    function changePermissions ( name ) {
        var newperm = window.prompt("Change file permissions for '" + name + "' to: ",'')
        if (newperm == null) {  return; }
        if (!isNum(newperm) || (newperm == "") || (length.newperm > 2)) {
            alert ("Three digits only please! Enter the permissions in octal. EG 766.")
        }
        else {
            window.location.href = "$config{'script_url'}?action=permissions&name=" + name + "&newperm=" + newperm +"&wd=$working_dir"
        }
    }
    
    function serverFileName() {
        var fileName = window.document.Upload.data.value.toLowerCase();
        window.document.Upload.fn.value = fileName.substring(fileName.lastIndexOf("\\\\") + 1,fileName.length);
    }
    
// -->
</script>
    ~;      

# Text to be displayed if the user does not have Javascript turned on.
    my $nojavascript = qq~  
        <noscript>
        <table border=0 bgcolor="#FFFFFF" cellpadding=5 cellspacing=3 width=100% valign=top>
        <tr>
        <td><font color="red"><B>Stop:&nbsp;&nbsp; </B></font><FONT COLOR="black">

        Your browser must have <font color="red"><b>JavaScript turned off</b></font> -- FileMan uses JavaScript.
        Please open your browser preferences, and <b>enable JavaScript</b>. You can then click on the <b>Reload</b> button and use FileMan.
        </FONT></td></tr></table>
        </noscript>
    ~;

# Print the HTML Header.
    print qq~
<html>
<head>
<title>File Manager $config{'version'}</title>
$javascript 
<LINK REL="STYLESHEET" TYPE="text/css" HREF="../style.css" media="screen">
<style type="text/css">
<!--
a:link    
{ color:#000000;
text-decoration: none
}

a:visited 
{ color:#000000;
text-decoration: none
}

a:active  
{ color:#000000
 }

a:hover  
{ text-decoration: underline
}
//-->
</STYLE>

</head>      
<body bgcolor="#606060">
<center>
     <table border=0 bgcolor="#FFFFFF" cellpadding=2 cellspacing=1 width="630" align=center valign=top>
       <tr> <td bgcolor="white" align=left><a href="javascript:history.go(-1)">Back</a></td>
            <td bgcolor="#606060"  align=center width=90% valign="middle"><div style="{font-size: 22px; color: white}">File Manager $config{'version'}</div></td>
            <td bgcolor="white" align=right><a href="$config{'script_url'}">Root</b></td>
       </tr>
     </table>

<table border="0" bgcolor="#FFFFFF" cellpadding="2" cellspacing="1" width="630" align="center" valign="top">
        <tr><td>
~;

# 5. Figure out what to do. 
    my ($result, @disk_space);
    CASE: {
        ($action eq 'write')        and do {
                                                @disk_space = &checkspace($config{'root_dir'});
                                                if ($disk_space[0] < 50) { &delete_only_error; }
                                                else {
                                                    $result = &write ($dir, $filename, $in->param('data'), $url);
                                                    &list_files ($result, $working_dir, $url, @disk_space);
                                                }
                                                &log_action ($result, $dir) if ($config{'logfile'});
                                                last CASE;
                                            };
        ($action eq 'delete')       and do {
                                                $result = &delete ($dir, $filename);
                                                @disk_space = &checkspace ($config{'root_dir'});
                                                &list_files ($result, $working_dir, $url, @disk_space);
                                                &log_action ($result, $dir) if ($config{'logfile'});
                                                last CASE;
                                            };
        ($action eq 'makedir')      and do {
                                                @disk_space = &checkspace($config{'root_dir'});
                                                if ($disk_space[0] < 50) { &delete_only_error; }
                                                else {
                                                    $result = &makedir    ($dir, $directory);
                                                    &list_files ($result, $working_dir, $url, @disk_space);
                                                    &log_action ($result, $dir) if ($config{'logfile'});
                                                }                                               
                                                last CASE;
                                            };
        ($action eq 'removedir')    and do {
                                                @disk_space = &checkspace($config{'root_dir'});
                                                $result = &removedir  ($dir, $directory);
                                                &list_files ($result, $working_dir, $url, @disk_space);
                                                &log_action ($result, $dir) if ($config{'logfile'});
                                                last CASE;
                                            };
        ($action eq 'rename')       and do {
                                                @disk_space = &checkspace($config{'root_dir'});
                                                $result = &rename_file ($dir, $name, $newname);
                                                &list_files   ($result, $working_dir, $url, @disk_space);
                                                &log_action ($result, $dir) if ($config{'logfile'});
                                                last CASE;
                                            };
        ($action eq 'edit')         and do {
                                                @disk_space = &checkspace($config{'root_dir'});
                                                if ($disk_space[0] < 50) { &delete_only_error; }
                                                else { &edit ($dir, $filename, $working_dir, $url); }
                                                last CASE;
                                            };
        ($action eq 'upload')       and do {
                                                @disk_space = &checkspace($config{'root_dir'});
                                                if ($disk_space[0] < 50) { &delete_only_error; }                                            
                                                else {
                                                    my $file_space;
                                                    ($file_space, $result) = &upload ($dir, $in->param('data'), $filename, $disk_space[0]);
                                                    $disk_space[0] -= $file_space; $disk_space[2] += $file_space;
                                                    &list_files ($result, $working_dir, $url, @disk_space);
                                                    &log_action ($result, $dir) if ($config{'logfile'});
                                                }
                                                last CASE;
                                            };
        ($action eq 'permissions')  and do {
                                                if ($config{'show_perm'}) {
                                                    @disk_space = &checkspace($config{'root_dir'});
                                                    $result = &change_perm ($dir, $name, $newperm);
                                                    &list_files ($result, $working_dir, $url, @disk_space);
                                                    &log_action ($result, $dir) if ($config{'logfile'});
                                                    last CASE;
                                                }
                                            };
        ($action eq 'protect_form') and do {                                                
                                                if ($config{'show_pass'}) {
                                                    &protect_form ($working_dir, $directory, '');                                                   
                                                    last CASE;
                                                }
                                            };      
        ($action eq 'add_user')     and do {
                                                if ($config{'show_pass'}) {
                                                    $result = &add_user ($user, $pass, $working_dir, $directory);
                                                    &protect_form ($working_dir, $directory, $result);
                                                    &log_action ($result, $dir) if ($config{'logfile'});
                                                    last CASE;
                                                }
                                            };      
        ($action eq 'remove_user')  and do {
                                                if ($config{'show_pass'}) {
                                                    $result = &remove_user ($user, $working_dir, $directory);
                                                    &protect_form ($working_dir, $directory, $result);
                                                    &log_action ($result, $dir) if ($config{'logfile'});
                                                    last CASE;
                                                }
                                            };                                                  
# Default Case
        do {
                @disk_space = &checkspace($config{'root_dir'});
                print $nojavascript;
                &list_files ('File and Directory Listing.', $working_dir, $url, @disk_space);
        };
    };

# 6. Wrap up and print the last of the HTML.
    print qq~
                </td></tr>
                        </table>
        </body>
</html>
    ~;
}
# ==========================================================================================

sub list_files {
# -----------------------------------------------------
# Displays a list of files for a given directory.
#
    my ($message, $working_dir, $url, @disk_space) = @_;
    my ($directory)   = "$config{'root_dir'}/$working_dir";
    my ($diskUsage)   = "'Disk Usage:\\n\\nAllowed disk space:&nbsp; $disk_space[1] kb\\nDisk space used:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $disk_space[2] kb\\n\\nDisk space free:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; $disk_space[0] kb'";

# Print out table header with free disk space.
    print qq~
        <P>
        <table border=0 bgcolor="#FFFFFF" cellpadding=5 cellspacing=3 width=100% valign=top>
            <tr>
                <td><B>Contents of:&nbsp;&nbsp; <a href="$url">$url</A></B></td>
                <td align="right"><B><a href="javascript:alert($diskUsage)">Disk usage</a></B></td>
            </tr>
            <tr>
                <td><b>Action: <font color=red>$message</font><br></td>
                <td align="right"><b><B>Free space: $disk_space[0] kb </B></td>
            </tr>
        </table>
    </td></tr>
    <tr><td>
        <P>
        <table border=0 bgcolor="#FFFFFF" cellpadding=5 cellspacing=3 width=100% valign=top>
    ~;

# Get the list of files using readdir.
    opendir (DIR, $directory) or &cgierr ("Can't open dir: '$directory'.\nReason: $!");
    my @ls = readdir(DIR);
    closedir (DIR);

# Then go through the results of ls and work out the files..
    my (%directory, %text, %graphic);
    my ($temp_dir, $newdir, @nest, $fullfile, $filesize, $filedate, $fileperm, $fileicon, $file);

    FILE: foreach $file (@ls) {
# Skip the "." entry and ".." if we are at root level.
        next FILE if  ($file eq '.');
        next FILE if (($file eq '..') and ($directory eq "$config{'root_dir'}/"));

# Get the full filename, file size, file modification date and file permissions.
        $fullfile = "$directory/$file";
        ($filesize, $filedate, $fileperm) = (stat($fullfile))[7,9,2];
        $fileperm = &print_permissions ($fileperm)      if ($config{'show_perm'});
        $filesize = &print_filesize    ($filesize)      if ($config{'show_size'});
        $filedate = &get_date($filedate)                if ($config{'show_date'});

        if (-d $fullfile ) {
# Let's work out the relative path if it is a directory.        
            if ($file eq '..') {
                @nest = split (/\//, $working_dir);
                (pop (@nest)) ? 
                    ($newdir = "$config{'script_url'}?wd=" . join ("/", @nest)) :
                    ($newdir = "$config{'script_url'}");                
            }
            else {
                $working_dir ? ($temp_dir = "$working_dir%2F$file") : ($temp_dir = "$file");
                $newdir   = "$config{'script_url'}?wd=$temp_dir";
            }
            $newdir = $in->escapeHTML($newdir);
# .. directory
            if ($file eq '..') {
                $fileicon = "$config{'icondir_url'}/$icons{'parent'}"  if ($config{'show_icon'});
                $directory{$file}  = qq~ <tr>\n~;
                $directory{$file} .= qq~     <td><b><a href="$newdir"><img src="$fileicon" align=middle border=0></a></td> \n~ if ($config{'show_icon'});
                $directory{$file} .= qq~     <td><a href="$url/$file">$file</a></b></td> \n~;
                $directory{$file} .= qq~     <td><b><tt><a href="javascript:changePermissions('$file')"><font color="gray" size=2>$fileperm</font></a></b></td> \n~ if ($config{'show_perm'});
                $directory{$file} .= qq~     <td><b><tt><font size=1>$filedate</font></tt></b></td> \n~ if ($config{'show_date'});
                $directory{$file} .= qq~     <td></td>~;
                $directory{$file} .= qq~     <td><b><a href="$newdir"><font color=black>chdir</font></a></B></td>
                                             <td><br></td></tr>
                                    ~;          
            }
# Regular directory.
            else {
                $fileicon = "$config{'icondir_url'}/$icons{'folder'}"  if ($config{'show_icon'});;
                $directory{$file}  = qq~ <tr>\n~;
                $directory{$file} .= qq~     <td><b><a href="$newdir"><img src="$fileicon" align=middle border=0></a></td> \n~ if ($config{'show_icon'});
                $directory{$file} .= qq~     <td><a href="$url/$file">$file</a></b></td> \n~;
                $directory{$file} .= qq~     <td><b><tt><a href="javascript:changePermissions('$file')"><font color="gray" size=2>$fileperm</font></a></b></td> \n~ if ($config{'show_perm'});
                $directory{$file} .= qq~     <td><b><tt><font size=1>$filedate</font></tt></b></td> \n~ if ($config{'show_date'});
                $directory{$file} .= qq~     <td></td>~;
                $directory{$file} .= qq~     <td><b><a href="$newdir"><font color=black>chdir</font></a></b></td>\n~;
                $directory{$file} .= qq~     <td><b><a href="javascript:deleteDir('$file')"><font color=red>rmdir</font></A></b></td>\n~;
                $directory{$file} .= qq~     <td><b><a href="$config{'script_url'}?action=protect_form&wd=$working_dir&dir=$file"><font color=brown>pass</font></A></b></td>\n~ if ($config{'show_pass'});
                $directory{$file} .= qq~ </tr>\n~;              
            }
        }
# Text Files.
        elsif (-T $fullfile) {
            $fileicon = &get_icon($fullfile) if ($config{'show_icon'});
            $text{$file}  = qq~  <tr>\n~;
            $text{$file} .= qq~      <td><b><a href="$url/$file"><img src="$fileicon" align=middle border=0></a></td> \n~ if ($config{'show_icon'});
            $text{$file} .= qq~      <td><a href="$url/$file">$file</a></b></td> \n~;
            $text{$file} .= qq~      <td><b><tt><a href="javascript:changePermissions('$file')"><font color="gray" size=2>$fileperm</font></a></b></td> \n~ if ($config{'show_perm'});
            $text{$file} .= qq~      <td><b><tt><font size=1>$filedate</font></tt></b></td> \n~ if ($config{'show_date'});
            $text{$file} .= qq~      <td><b><tt><font size=1>$filesize</font></tt></b></td> \n~ if ($config{'show_size'});
            ($disk_space[0] > 50) ?
                ($text{$file} .= qq~
                                    <td><b><a href="$config{'script_url'}?action=edit&fn=$file&wd=$working_dir"><font color=green>edit</font></a></b></td>
                ~) :
                ($text{$file} .= qq~
                                    <td><br></td>
                ~);
            $text{$file} .= qq~
                                    <td><b><a href="javascript:deleteFile('$file')"><font color=red>delete</font></a></b></td>
                                    <td><b><a href="javascript:renameFile('$file')"><font color=purple>rename</font></a></b></td></tr>
            ~;
        }
# Binary Files.
        else {
            $fileicon = &get_icon($fullfile) if ($config{'show_icon'});
            $graphic{$file}  = qq~  <tr>\n~;
            $graphic{$file} .= qq~      <td><b><a href="$url/$file"><img src="$fileicon" align=middle border=0></a></td> \n~ if ($config{'show_icon'});
            $graphic{$file} .= qq~      <td><a href="$url/$file">$file</a></b></td>              \n~;
            $graphic{$file} .= qq~      <td><b><tt><a href="javascript:changePermissions('$file')"><font color="gray" size=2>$fileperm</font></a></b></td> \n~ if ($config{'show_perm'});
            $graphic{$file} .= qq~      <td><b><tt><font size=1>$filedate</font></tt></b></td> \n~ if ($config{'show_date'});
            $graphic{$file} .= qq~      <td><b><tt><font size=1>$filesize</font></tt></b></td> \n~ if ($config{'show_size'});
            $graphic{$file} .= qq~      <td><br></td>
                                        <td><b><a href="javascript:deleteFile('$file')"><font color=red>delete</font></a></b></td>
                                        <td><b><a href="javascript:renameFile('$file')"><font color=purple>rename</font></a></b></td></tr>
            ~;
        }
    }
    foreach (sort keys %directory) {
        print $directory{$_};
    }
    foreach (sort keys %text) {
        print $text{$_};
    }
    foreach (sort keys %graphic) {
        print $graphic{$_};
    }

# Print the footer.
    if ($disk_space[0] < 50) {
        print qq~
            </table>
            <p><blockquote>
            <b>You are running out of disk space. Please delete some files before
            creating new ones.</b></blockquote></p>~;
    }
    else {
        print qq~
            </table>
        </td></tr>
        <tr><td>            
            <table border=0 cellpadding=5 cellspacing=3 width=80% valign=top>
                <tr><td align="left" valign="top" width=50%>
                    <form method=post action="$config{'script_url'}" name="createfile">
                        <input type=hidden name="action" value="edit">
                        <input type=hidden name="wd"     value="$working_dir">
                        <font color="black"><B>Create a new document:</B><br>
                            Filename:<br> <input type=text name="fn" onBlur="validateFileEntry(this.value, this)" ><br>
                        <input type=submit value="Create file"></font>
                    </form>
                </td><td align="left" rowspan=2 valign="top" width=50%>
                    <form method=post action="$config{'script_url'}">
                        <input type=hidden name="action" value="makedir">
                        <input type=hidden name="wd"     value="$working_dir">
                        <font color="black"><B>Create a new directory:</B><br>
                            Name:<br> <input type=text name="dir" onBlur="validateFileEntry(this.value, this)" >
                        <input type=submit value="Make new directory"></font>
                    </form>
                </td></tr><tr><td valign="top" align="left">
                    <form method=post action="$config{'script_url'}" NAME="Upload" ENCTYPE="multipart/form-data">
                        <input type=hidden name="wd"     value="$working_dir">
                        <input type=hidden name="action" value="upload">
                        <font color="black"><B>Upload a File:</B><br>
                            Local filename:
                            <INPUT NAME="data" TYPE="file" onBlur="serverFileName()"><br>
                            Remote filename:<br> <INPUT NAME="fn" onFocus="select()" onBlur="validateFileEntry(this.value, this)">
                        <input type="submit" value="Upload"></font>
                    </form>
                </td></tr>
            </table>
        ~;
    }
} # End List Files Procedure.

sub delete {
# -----------------------------------------------------
# Begin Delete File Procedure:
#
    my ($directory, $filename) = @_;
    my ($fullfile);

# Check to make sure a file name was entered.
    (!$filename) and return "Delete File: No filename was entered!";

# Get the full path to the file.
    ($directory =~ m,/$,) ? ($fullfile = "$directory$filename") : ($fullfile = "$directory/$filename");

# Delete it if it exists.
    if (&exists($fullfile)) {
        unlink ($fullfile) ?
            return "Delete File: '$filename' was removed." :
            return "Delete File: '$filename' could not be deleted. Check file permissions.";
    }
    else {
        return "Delete File: '$filename' could not be deleted. File not found.";
    }
}

sub edit {
# -----------------------------------------------------
# Begin Edit Text File Procedure:
#
    my ($directory, $filename, $working_dir, $url) = @_;
    my ($lines, $fullfile, $full_url);

# Check to make sure a file name was entered.
    (!$filename) and return "Edit File: No filename was entered!";

# Build full file name and full url.
    ($directory =~ m,/$,) ? ($fullfile = "$directory$filename") : ($fullfile = "$directory/$filename");
    $full_url   = "$url/$filename";

# Either load the contents from a file..
    if (&exists($fullfile)) {
        open (DATA, "<$fullfile") or &cgierr ("Can't open '$fullfile'\nReason: $!");
        $lines = join ("", <DATA>);
        $lines =~ s/<\/TEXTAREA/<\/TEXT-AREA/ig;
        close DATA;
        print qq!<p>Modify <a href="$full_url"><B>$filename</B></A> as needed:</p>!;
    }
    else {
# Or use the following as a template.
        $lines = qq~
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<HTML>
<HEAD>
<TITLE></TITLE>
</HEAD>
    
<BODY BGCOLOR="#FFFFFF" TEXT="#000000" LINK="#FF0000" VLINK="#800000" ALINK="#FF00FF">
    
</BODY>
</HTML>
        ~;
        print "<p>This is a new file. Input your HTML below:</p>";
    }

# Print out the editing and saving options.
    print qq~
        <p><blockquote>
            After editing, select "Save Document" to save <B>$filename</B> and return to
            the main menu.
        </blockquote></p>

        <form method=post action="$config{'script_url'}">
        <textarea name="data" rows=40 cols=60 wrap=virtual>$lines</textarea>

        <p>Alternate Filename:
            <input type=text name="fn" value="$filename"><br>
                (entering an alternate filename will leave <B>$filename</B>
                untouched and will place the text above into a file with the
                alternate name. Note that if a file already exists with the alternate
                filename, you will overwrite it completely.)<P>
            <input type=hidden name="action" value="write">
            <input type=hidden name="wd"     value="$working_dir">
            <input type=submit               value="Save Document">
        </form>
        </p>        
    ~;
}

sub write {
# -----------------------------------------------------
# Begin Write Text File Procedure:
#
    my ($directory, $filename, $data, $url) = @_;
    my ($fullfile, $new);

# Make sure a filename was passed in.
    (!$filename) and return "Edit File: No filename was entered!";  

# Get the full path.
    ($directory =~ m,/$,) ? ($fullfile = "$directory$filename") : ($fullfile = "$directory/$filename");

# Check to see if this is a new or existing file.
    $new = 1;
    (&exists($fullfile)) and ($new = 0);

# Fix textarea tags.
    $data =~ s,</TEXT-AREA,</TEXTAREA,ig;

# Write the file to the system.
    open(FILE,">$fullfile") or &cgierr ("Can't open: '$fullfile'.\nReason: $!");
        print FILE $data;
    close(FILE);

    if (&exists($fullfile)) {
        ($new eq 'yes') ?
            return ("Edit File: '$filename' has been created.") :
            return ("Edit File: '$filename' has been edited.");
    }
    else {
        return  ("Edit File: Cannot save '$filename'. Check permissions.");
    }
}

sub upload {
# -----------------------------------------------------
# Begin Upload File Procedure:

    my ($directory, $data, $filename, $free_space) = @_;
    my ($bytesread, $buffer, $fullfile, $file_size);

# Make sure we have a filename to upload.
    (!$filename) and return (0, "Upload: No filename was entered!");

# Get the full file name.
    ($directory =~ m,/$,) ?
        ($fullfile = "$directory$filename") :
        ($fullfile = "$directory/$filename");
    $file_size = 0;

# Open the output file and save the upload. We abort if the file is
# to big, or not enough free disk space.
    open    (OUTFILE, ">$fullfile") or &cgierr ("Can't open: '$fullfile'.\nReason: $!");
    binmode (OUTFILE);  # For those O/S that care.
    while ($bytesread=read($data,$buffer,1024)) {
        ($fullfile =~ /cgi|pl$/) and ($buffer =~ s/\r//g);
        print OUTFILE $buffer;
        $file_size += 1024;
        if (($file_size / 1000) > $free_space) {
            close OUTFILE;
            unlink ($fullfile) or &cgierr ("Can't unlink: $fullfile. Reason: $!");
            return (0, "Upload: Not enough free space to upload that file. Space left: $free_space kb.");
        }
        if (($file_size / 1000) > $config{'max_upload'}) {
            close OUTFILE;
            unlink ($fullfile) or &cgierr ("Can't unlink: $fullfile. Reason: $!");
            return (0, "Upload: Aborted as your file is larger then the maximum uploadable file size of $config{'max_upload'} kb!");
        }
    }
    close OUTFILE;
    &exists($fullfile) ?
        return (int($file_size / 1000), "Upload: '$filename' uploaded.") :
        return (int($file_size / 1000), "Upload: Cannot upload '$filename'. Check permissions.");
}

sub makedir {
# -----------------------------------------------------
# Begin Make Directory Procedure:
#
    my ($root, $new) = @_;
    my ($fulldir);

# Make sure we have a directory name.
    (!$new) and return "Make Directory: You forgot to enter in a directory name!";

# Get the full path.
    ($root =~ m,/$,) ? ($fulldir = "$root$new") : ($fulldir = "$root/$new");

# Create the directory unless it already exists.
    if (&exists($fulldir)) {
        return "Make Directory: '$new' already exists.";
    }
    else {
        mkdir ($fulldir, 0755) ?
            return "Make Directory: '$new' directory created." :
            return "Make Directory: Unable to create the directory. Check permissions.";
    }
}

sub removedir {
# -----------------------------------------------------
# Removes a directory.
#
    my ($root, $new) = @_;
    my ($fulldir);

# Make sure we have a directory name to delete.
    (!$new) and return "Remove Directory: No directory name was entered!";

# Get the full directory.   
    ($root =~ m,/$,) ? ($fulldir = "$root$new") : ($fulldir = "$root/$new");

# Then remove if possible.
    if (!&exists($fulldir)) {
        return "Remove Directory: '$new' does not exists.";
    }
    else {
        rmdir($fulldir) ?
            return "Remove Directory: '$new' has been removed." :
            return "Remove Directory: '$new' was <B>not</B> removed. Check that the directory is empty.";
    }
}

sub rename_file {
# -----------------------------------------------------
# Renames a file using perls rename() function.
#
    my ($directory, $oldfile, $newfile) = @_;

# Make sure we have both an old name and a new name.
    (!$oldfile or !$newfile) and return "Rename: Both a source and destination file must be entered!";

# Get the full path of each file.
    my ($full_oldfile, $full_newfile);
    ($directory =~ m,/$,) ?
        ($full_oldfile = "$directory$oldfile"  and $full_newfile = "$directory$newfile") :
        ($full_oldfile = "$directory/$oldfile" and $full_newfile = "$directory/$newfile");

# Make sure the oldfile exists, and the new file doesn't.
    (&exists($full_oldfile)) or  return "Rename: Old file '$oldfile' does not exist.";
    (&exists($full_newfile)) and return "Rename: New file '$newfile' already exists.";

# Rename.
    rename ($full_oldfile, $full_newfile) or &cgierr("Unable to rename '$full_oldfile' to '$full_newfile'. Reason: $!");
    return "Rename: '$oldfile' has been renamed '$newfile'.";
}

sub change_perm {
# --------------------------------------------------------
# Changes the permission attributes of a file
#
    my ($directory, $file, $newperm) = @_;
    my ($full_filename, $octal_perm);
    
# Make sure we have both a filename and a permission.
    (!$file)    and return "Change Permissions: No file entered!";
    (!$newperm) and return "Change Permissions: No new permissions entered!";

# Check to make sure the file exists.
    $full_filename = "$directory/$file";
    (&exists($full_filename)) or return "Change Permissions: '$file' does not exist.";

# Permissions have to be in octal.
    $octal_perm = oct($newperm);
    chmod ($octal_perm, $full_filename) or &cgierr("Unable to change permissions for '$file' to '$newperm'. Reason: $!");
    return "Change Permissions: '$file' permissions have been changed.";
}

sub print_permissions {
# --------------------------------------------------------
# Takes permissions in octal and prints out in ls -al format.
#
    my $octal  = shift;
    my $string = sprintf "%lo", ($octal & 07777);
    my $result = '';
    foreach (split(//, $string)) {
        if    ($_ == 7) { $result .= "rwx "; }
        elsif ($_ == 6) { $result .= "rw- "; }
        elsif ($_ == 5) { $result .= "r-x "; }
        elsif ($_ == 4) { $result .= "r-- "; }
        elsif ($_ == 3) { $result .= "-wx "; }
        elsif ($_ == 2) { $result .= "-w- "; }
        elsif ($_ == 1) { $result .= "--x "; }
        elsif ($_ == 0) { $result .= "--- "; }
        else            { $result .= "unkown '$_'!"; }
    }
    return $result;
}

sub protect_form {
# --------------------------------------------------------
# Presents the users with form to protect directory.
#
    my ($working_dir, $directory, $result) = @_;    

# Set the working directory and get the password file.
    my ($pass_file);
    $working_dir ? ($pass_file = "$working_dir/$directory.pass") : ($pass_file = "$directory.pass");
    $pass_file =~ s,/,_,g; $pass_file = "$config{'password_dir'}/$pass_file";

# Get the user list, and print out the forms.   
    my (@users)     = &load_users ($pass_file);
    my ($user_list);
    my ($local_dir) = "$working_dir/$directory"; $local_dir =~ s,^/,,;
    print qq~<p>Password protection for <i><b><a href="$config{'root_url'}/$local_dir">$directory</a></b></i> : </p>~;
    print qq~<p>Result: <font color=red>$result</font></p>~ if ($result);   
    print qq~
                    <form action="$config{'script_url'}" method="post">
                        <input type=hidden name="action" value="add_user">
                        <input type=hidden name="wd" value="$working_dir">
                        <input type=hidden name="dir" value="$directory">                   
                        Add a new user, name: <input name="user" size=10> pass: <input name="pass" size=10> <input type=submit value="Add">                 
                    </form>     
    ~;
    if ($#users > -1) {
        foreach (@users) {
            $user_list .= qq~<option value="$_">$_\n~;
        }
        print qq~
                    <form action="$config{'script_url'}" method="post">
                        <input type=hidden name="action" value="remove_user">
                        <input type=hidden name="wd" value="$working_dir">
                        <input type=hidden name="dir" value="$directory">
                        Delete an authorized user: <select name='user'>$user_list</select> <input type=submit value="Delete">   
                    </form>
        ~;
    }   
}                   
    
sub add_user {
# --------------------------------------------------------
# Protects directory with htacces files.
#
    my ($user, $pass, $working_dir, $directory) = @_;

# Set the working directory and get the password file.
    my ($pass_file);
    $working_dir and ($directory = "$working_dir/$directory");
    $pass_file = "$directory.pass";
    $pass_file =~ s,/,_,g; $pass_file = "$config{'password_dir'}/$pass_file";
    
# Make sure we have a username and password.
    if (length($user) < 3) { return "Add User: Username '$user' too short."; }
    if (length($pass) < 3) { return "Add User: Password '$pass' too short."; }

# Encrypt the password. 
    my @salt_chars = ('A' .. 'Z', 0 .. 9, 'a' .. 'z', '.', '/');
    my $salt = join '', @salt_chars[rand 64, rand 64];
    my $encrypted = crypt($pass, $salt);            
    
# Add/modify the user.
    my ($output, $found);
    if (&exists($pass_file)) {
        open (PASS, "<$pass_file") or &cgierr("Unable to open password file '$pass_file'. Reason: $!");
        while (<PASS>) {
            next unless (/^([^:]+)/);
            if ($user eq $1) {
                $output .= "$user:$encrypted\n";
                $found = 1;
            }
            else {
                $output .= $_;
            }
        }
        close PASS;
        if (!$found) { $output .= "$user:$encrypted\n"; }
    }
    else {
        $output = "$user:$encrypted\n";
    }
    open (PASS, ">$pass_file") or &cgierr("Unable to open password file '$pass_file'. Reason: $!");
    print PASS $output;
    close PASS;

# Create the .htaccess file if neccessary.
    &create_htaccess ($directory, $pass_file);

    return "Add User: '$user' added to password file.";
}

sub remove_user {
# --------------------------------------------------------
# Removes a user from the .htaccess file and the password file.
#
    my ($user, $working_dir, $directory) = @_;
    my ($output);

# Set the working directory and get the password file.
    my ($pass_file);
    $working_dir and ($directory = "$working_dir/$directory");
    $pass_file = "$directory.pass";
    $pass_file =~ s,/,_,g; $pass_file = "$config{'password_dir'}/$pass_file";

# Make sure we have a username and password.
    if (length($user) < 3) { return "Remove User: '$user' too short or not specified."; }

# Update the password file.
    open (PASS, "<$pass_file") or &cgierr("Unable to open password file '$pass_file'. Reason: $!");
    while (<PASS>) {
        next if (/^\Q$user\E:/gio);
        $output .= $_;
    }
    close PASS;

# If we have users left, rewrite the password file. Otherwise, remove the password file
# and the .htaccess file.
    if ($output) {
        open (PASS, ">$pass_file") or &cgierr("Unable to open password file '$pass_file'. Reason: $!");
            print PASS $output;
        close PASS;
    }
    else {
        unlink ("$config{'root_dir'}/$directory/.htaccess") or &cgierr("Can't remove htaccess file '$config{'root_dir'}/$directory/.htaccess'. Reason: $!");
        unlink ("$pass_file")                               or &cgierr("Can't remove password file '$pass_file'. Reason: $!");
    }
    return "Remove User: '$user' removed successfully.";
}

sub create_htaccess {
# --------------------------------------------------------
# Writes an .htaccess file in the specified directory.
#
    my ($directory, $pass_file) = @_;
    my $fulldir = "$config{'root_dir'}/$directory";
    
    if (!&exists("$fulldir/.htaccess")) {
        open (PASS, ">$fulldir/.htaccess") or &cgierr ("Unable to open htaccess file: '$directory/.htaccess'. Reason: $!");
        print PASS qq~
AuthUserFile $pass_file
AuthGroupFile /dev/null
AuthName 'Protected Area'
AuthType Basic

<limit GET PUT POST>
require valid-user
</limit>
~;
        close PASS;
    }
}

sub load_users {
# --------------------------------------------------------
# Loads the list of valid users from the password file.
#
    my $pass_file = shift;
    my (@users, $user, $pass);
    
    if (&exists("$pass_file")) {
        open (PASS, "<$pass_file") or &cgierr("Unable to open password file '$pass_file'. Reason: $!");
        while (<PASS>) {
            ($user, $pass) = split (/:/);
            push (@users, $user);
        }
        close PASS;
    }
    return @users;
}

sub print_filesize {
# --------------------------------------------------------
# Prints out the file size.
    
    my $size = shift;
    my $formatted_size = int($size / 1000) . " kb";
    $formatted_size == 0 ?
        return "$size bytes" :
        return $formatted_size;
}

sub checkspace {
# -----------------------------------------------------
# Check for allowed disk space to determine whether we can allow
# editing or uploads.
#
    use File::Find;

    my ($directory)     = shift;
    my ($size, $used_space, $free_space) = 0;

    &find ( sub { $size += -s }, $directory );
    $used_space = int ($size / 1024);
    $free_space = ($config{'allowed_space'} - $used_space);

    return ($free_space, $config{'allowed_space'}, $used_space);
}

sub exists {
# -----------------------------------------------------
# Checks to see if a file exists.
#   
    return -e shift;
}

sub get_icon {
# --------------------------------------------------------
# Get the associated icon based on a files extension
#
    my ($file) = lc(shift);
    my ($ext)  = $file =~ /\.([^.]+)$/;
    if (!$ext) { return "$config{'icondir_url'}/$icons{'unknown'}"; }
    foreach (keys %icons) {
        next if (/folder/);
        next if (/unknown/);
        next if (/parent/);
        ($_ =~ /$ext/i) and return "$config{'icondir_url'}/$icons{$_}";
    }
    return "$config{'icondir_url'}/$icons{'unknown'}";
}

sub get_date {
# --------------------------------------------------------
    my $time = shift;
    $time or ($time = time);
    my @months = qw!Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec!;

    my ($min, $hr, $day, $mon, $yr) = (localtime($time))[1,2,3,4,5];
    $yr = $yr + 1900;
    ($min < 10) and ($min = "0$min");
    ($hr  < 10) and ($hr  = "0$hr");
    ($day < 10) and ($day = "0$day");

    return "$day-$months[$mon]-$yr $hr:$min";
}

sub is_valid_file {
# -----------------------------------------------------
# Checks to see if a file is valid (proper form).
#
    my ($file, $okfile) = "";
    $file = shift;

    ($file =~ m,^([A-Za-z0-9\-_.]*)$,) ?
        ($okfile = $1) :
        (return ($file, "Illegal Characters in Filename. Please use letters, numbers, -, _ and . only."));

    ($file =~ m,\.\.,)   and return ($file, "No double .. allowed in file names.");
    ($file =~ m,^\.,)    and return ($file, "no leading '.' in file names.");
    (length($file) > 20) and return ($file, "File name is too long. Please keep it to under 20 characters.");

    return ($okfile, "");
}

sub is_valid_dir {
# -----------------------------------------------------
# Checks to see if a file is valid (proper form).
#
    my ($dir, $okdir, $last_dir) = "";
    $dir = shift;

    my (@size) = split (/\//, $dir);
    $last_dir  = pop (@size);

    ($dir =~ m,^([A-Za-z0-9\-_/]*)$,) ?
        ($okdir = $1) :
        (return ($dir, "Illegal Characters in Directory. Please use letters, numbers, - and _ only."));

    ($dir =~ m,^/,)          and return ($dir, "No leading / in directory names.");
    ($dir =~ m,/$,)          and return ($dir, "No trailing / in directory names.");
    ($#size > 4)             and return ($dir, "Directory level too deep.");
    (length($last_dir) > 15) and return ($dir, "Directory Name too Long. Please keep it to less then 15 characters.");

    return ($okdir, "");
}

sub is_valid_user {
# -----------------------------------------------------
# Makes sure a username is ok.
#
    my ($user) = shift;
    (!$user) and return ($user, ""); 
    ($user =~ /^([A-Za-z0-9-_]+)$/) ? 
        return ($1, "") :
        return ($user, "Can only contain letters, numbers and -, _");   
}

sub is_valid_perm {
# -----------------------------------------------------
# Makes sure entered permissions are ok.
#
    my ($perm) = shift;
    (!$perm)                        and return ($perm, "");
    ($perm =~ /^([0-7][0-7][0-7])$/) or return ($perm, "Permissions must be three digits only, 0 to 7.");   
    return ($1, "");
}

sub log_action {
# -----------------------------------------------------
# Logs an action to the log file. Format is:
#   time ip remotehost referer working_dir action
#
    my ($action, $wd) = @_;
    open (LOG, ">>$config{'logfile'}") or &cgierr ("Unable to open logfile: $config{'logfile'}. Reason: $!", 1);
    if ($config{'use_flock'}) {
        flock (LOG, 2) or &cgierr ("Unable to get exlcusive lock: $config{'logfile'}. Reason: $!", 1);
    }
    print LOG join ("\t",
        scalar(localtime()),
        $ENV{'REMOTE_ADDR'},
        $ENV{'REMOTE_HOST'},
        $ENV{'HTTP_REFERER'},
        $wd,
        $action,
        "\n"
    );
    close LOG;
}

sub delete_only_error {
# -----------------------------------------------------
# Prints out an error message if the user tries to add anything when he is running
# out of disk space.
#
    print qq~
        <BLOCKQUOTE>
        <FONT FACE="arial" SIZE=4>
        This action was aborted, because your disk space allotment is
        full or near full (less than thirty kilobytes).<P>
        Please delete some files or directories before proceeding. Alternately,
        you may ask the webmaster to allocate more disk space to this
        account.</BLOCKQUOTE><br><br><br>
    ~;
}

sub user_error {
# --------------------------------------------------------
# Displays a message about illegal filenames and whatsuch.
#
    my ($error, $wd) = @_;

    print qq|
<html>
<head>
    <title>File Manager $config{'version'}</title>
</head>

<body bgcolor="#DDDDDD">
    <center>
         <table border=1 bgcolor="#FFFFFF" cellpadding=2 cellspacing=1 width="630" align=center valign=top>
            <tr> <td bgcolor="white" align=left><a href="javascript:history.go(-1)"><font face="Verdana, Arail" size=2><b>Back</b></font></a></td>
                <td bgcolor="navy"  align=center width=90%><font color="white" face="Verdana, Arail" size=3><b>File Manager $config{'version'}</b></font></td>
                <td bgcolor="white" align=right><a href="$config{'script_url'}"><font face="Verdana, Arail" size=2><b>Root</b></font></a></td>
            </tr>
            <tr><td colspan=3>
                <p><b>Error!</b> The following error occured: </p>
                <p><blockquote><font color=red><b>$error</b></font></blockquote></p>
                <p>Please press <a href="javascript:history.go(-1)">back</a> on your browser to fix the problem.</p>
            </td></tr>
            <tr><td colspan=3>
                <table border=0 width=100%>
                    <tr><td align=left><a href="http://www.gossamer-threads.com"><b><font color="#888888" size=1 face="Verdana, Arial">Powered By: FileMan v. $config{'version'}<br>
                           &copy; 1998 Gossamer Threads Inc.</font></b></a></td>
                        <td align=right><a href="http://www.gossamer-threads.com"><img src="http://www.gossamer-threads.com/images/powered.gif" width=100 height=31 alt="Powered by Gossamer Threads Inc." border=0></a></td>
                    </tr>
                </table>
            </td></tr>
        </table>
    </center>
</body>
</html>
    |;
    &log_action ("Form Input Error: $error", $wd) if ($config{'logfile'});
    exit;
}

sub cgierr {
# --------------------------------------------------------
# Displays any errors and prints out FORM and ENVIRONMENT
# information. Useful for debugging.
#
    my ($key, $env);
    my ($error, $nolog) = @_;
    print "</td></tr></table>";
    print "</td></tr></table></center></center>";
    
    print "<PRE>\n\nCGI ERROR\n==========================================\n";
    $error    and print "Error Message       : $error\n";
    $0        and print "Script Location     : $0\n";
    $]        and print "Perl Version        : $]\n";
    
    print "\nConfiguration\n-------------------------------------------\n";
    foreach $key (sort keys %config) {
        my $space = " " x (20 - length($key));
        print "$key$space: $config{$key}\n";
    }
    
    print "\nForm Variables\n-------------------------------------------\n";
    foreach $key (sort $in->param) {
        my $space = " " x (20 - length($key));
        print "$key$space: " . $in->param($key) . "\n";
    }
    print "\nEnvironment Variables\n-------------------------------------------\n";
    foreach $env (sort keys %ENV) {
        my $space = " " x (20 - length($env));
        print "$env$space: $ENV{$env}\n";
    }
    print "\n</PRE>";
    &log_action ("CGI ERROR: $error") if (!$nolog and $config{'logfile'});
    exit;
}
