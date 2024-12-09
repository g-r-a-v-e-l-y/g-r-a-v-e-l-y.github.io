################################################
C O N T E N T S
################################################


Instructions:

unixinstall.html - for Unix/Linux Servers

ntinstall.html   - for Windows NT Servers

Open these with your web browser and print out for reference.


pathto.asp       - for Windows IIS servers 

hello.cgi	 - these hello scripts will confirm that Perl is working
hello.pl


#################################################
USING THE TEST SCRIPTS
#################################################

hello.cgi
hello.pl

Make sure your directory set to execute scripts

Upload this script in ASCII mode to your CGI directory.

On a UNIX/Linux server, chmod the scripts 755

Call the script from your browser:
http://yourdomain/yourcgi/hello.cgi

http://yourdomain/yourcgi/hello.pl

Check that the script says 'hello' and returns a Perl version of 5 or better.
Test both hello.cgi and hello.pl.  


Troubleshooting the 'hello' scripts:

Only Text appears:  This means your server is not executing the script.  Check your ISP
documentation for help.  Be sure your script is in the location the ISP requires.

On Unix/Linux servers this may mean your have not set the chmod to 755.

500 Server error:
a) You did not upload in ASCII
b) The top line does not point to Perl 5. Try #!/usr/bin/perl5
c) Perl is not installed or the server is not correctly configured.
d) If you unzipped ubbtools on a Linux or Unix machine, did you use the
unzip -a switch to force an ASCII unzipping?

#################################################


ubb_test.cgi

This script will test basic paths and permissions and suggest
help for you.

Do NOT use this script unless the 'hello' scripts above work correctly.

Upload this script in ASCII mode to your CGI directory.

On a UNIX/Linux server, chmod the script 755

Call the script from your browser:
http://yourdomain/yourcgi/ubb_test.cgi

The script will attempt to enter an absolute path in the text box.
If it does not you will have to enter one accurately.  Servers using
perlis.dll and Netscape Servers may not automatically find the path.

You can use the pathto.asp on any Windows IIS server to tell you the
absolute path to your directory or, in some cases, to your web root.

You may have to ask the ISP for the full path to your directories.  This is a 
common question thye can answer easily.


TESTS: Checkboxes 1-4:

1) The first test will try to read, write, delete in the directory 
listed in the text box at the top.  Manually edit in a path to test if needed.
i.e.  C:/Inetpub/yourdir/ubb  or /usr/home/wwwroot/yourdir/Members

2) The second test will look for all required UBB files either in
the CGI directory or in the directory you specify.

3) The third test will test permissions of your 4 variables files 
[UltBB.setup, forums.cgi, mods.file and Styles.file]
*only* if they are installed in the directory you are testing.

4) *IF* your UBB is already configured you can test the accuracy of the paths by
selecting this option. 


TROUBLESHOOTING

Internal Server Error 500.  If the basic hello scripts work, this means that Perl 5 or its standard modules
are not installed. 

Blank Screen and no response.  Application Mappings are incorrect.

Script outputs its text and not results:  You server is not set to handle 
.cgi scripts properly or your Web provider does not allow CGI scripts.


###################################################################################

The ubb_test.cgi script is copyright Infopop Corporation 2000.  Infopop makes no warranty 
concerning the accuracy, function or results of this script.  Each server
is different and will give different results.

