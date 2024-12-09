#!/usr/bin/perl

### Virtual Webwerx Form-Based Upload CGI
### v1.0 (17 Feb 96) by James K. Boutcher (geewhiz@novia.net)
### Feel free to use, modify, distribute.. But remember to give some credit
### where credit is due.
###
### If you are having problems with this, or have a bug to report, just send
### me some mail


# Let's define our variables first off.. 
$| = 1;  
$upath = "D:\\inetpub\\wwwwroot\\b\\beta\\cgi\\uploads";
$uindex = "D:\\inetpub\\wwwroot\\b\\beta\\cgi\\uploads\\upload.index";
$tempfile = $upath . $ENV{'REMOTE_ADDR'};
$nofileerror = "http://24.23.47.111/b/beta/cgi/upload.html";

# The following reads in the CGI buffer, and writes it to a temporary file
# which will used later.
read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
open (x,">$tempfile");
print x $buffer;
close (x);


# Now, time to open the temporary file and process it!
open (temp,$tempfile);


# Gotta pull the MIME/multipart separator line out.. We'll keep the 15 
# digit number for later...
$_ = <temp>;
($vernum) = /(\d+)/;


# Next line of the file contains the filename in the format: 
#     filename="C:\windows\win.ini"
# We'll just keep the part inside the quotes...
$_ = <temp>;
$filetemp = $1 if (/filename=\"(.*)\"/); 


# The filename currently has the full pathname to the file in it.. We
# don't want that! .. First we grab the last word after the backslash (for
# PC systems), then we're gunna grab the last word after the forward slash
# (unix systems).. Don't worry, it works.
@pathz = (split(/\\/,$filetemp));
$filetempb = $pathz[$#pathz];
@pathza = (split('/',$filetempb));
$filename = $pathza[$#pathza];


# And, if the filename is nothing, we'll clean everything up and give them
# a pretty error message
if ($filename eq "") {
	print "Location: $nofileerror\n\n";
	close(temp);
	`rm $tempfile`;
	}


# Now that we know the name of the file, let's create it in our upload
# directory..
open (outfile, ">$upath$filename");


# Now we don't care about the Content-type of this, so we'll pass that up
$junk = <temp>; 
$junk = <temp>;


# And we're gunna read/write all the lines of our file until we come to the
# MIME-multipart separator, which we'll ignore.
while (<temp>) {
   if (!(/-{28,29}$vernum/)) {
		print outfile $_;
		}
   }

# We're done with that.. Let's close things up and remove that temp file.
close (temp);
close (outfile);
`rm $tempfile`;


# And bust da HTML
print "Content-type: text/html\n\n";
print "<html><title>Form Upload</title><body>\n";
print "<center><h1>Thank You!</h1><hr>Your file, <strong><i>$filename</i></strong>, \n";
print "has been successfully transferred to this site.<br><br>\n";
print "<a href=\"/~geewhiz/cgi-bin/uploads/\">And, for you non-believers out there...</a><br>\n";
print "</body></html>";
