#!/usr/bin/perl

require "Settings.pl";
require "grafik.pl";

eval {
        ($0 =~ m,(.*)/[^/]+,)   && unshift (@INC, "$1"); # Get the script location: UNIX / or Windows /
        ($0 =~ m,(.*)\\[^\\]+,) && unshift (@INC, "$1"); # Get the script location: Windows \
};

$SAVE_DIRECTORY = "/home/kknd2-de/htdocs/yabb/images"; # abolut path to your image folder with CHMAD 777
$SAVE_HTTP = "$imagesdir/images"; # This is the HTTP location of the saved files directory.
$MAXIMUM_UPLOAD = 20480; # File size limit, in bytes. Default is 20k. Set to 0 for no limit.
# That's all the configuration you need to do.

$| = 1;
chop $SAVE_DIRECTORY if ($SAVE_DIRECTORY =~ /\/$/);
use CGI qw(:standard);
$query = new CGI;

foreach $key (sort {$a <=> $b} $query->param()) {
        next if ($key =~ /^\s*$/);
        next if ($query->param($key) =~ /^\s*$/);
        next if ($key !~ /^file-to-upload-(\d+)$/);
        $Number = $1;

        if ($query->param($key) =~ /([^\/\\]+)$/) {
                $Filename = $1;
                $Filename =~ s/^\.+//;
                $File_Handle = $query->param($key);

                unless (($Filename =~ /\.jpg$/i) || ($Filename =~ /\.gif$/i)) {
                        print header;
                        print <<__END_OF_HTML_CODE__;
                        <HTML>
                        <HEAD>
                        <TITLE>Error: Filename Problem</TITLE>
                        <body bgcolor="$BGColor" text="$TextColor" link="$LinkColor" vlink="$VisitedLinkColor" alink="$ActiveLinkColor"></head>
                        <CENTER><IMG SRC="$imagesdir/$BBTitle"><P>
				Sorry, only .gif and .jpg images are allowed. Please go <A HREF="javascript:history.go(-1)">back</A> and select another file.
                        </CENTER>
                        </BODY>
                        </HTML>
__END_OF_HTML_CODE__

                        exit;
                        }
                } else {
                        $FILENAME_IN_QUESTION = $query->param($key);
                        print header;
                        print <<__END_OF_HTML_CODE__;
                        <HTML>
                        <HEAD>
                        <TITLE>FEHLER: Dateiname Problem</TITLE>
                        <body bgcolor="$BGColor" text="$TextColor" link="$LinkColor" vlink="$VisitedLinkColor" alink="$ActiveLinkColor"></head>
                        <CENTER><IMG SRC="$imagesdir/$BBTitle"><P>
				The name of the image is incorrect. Please go <A HREF="javascript:history.go(-1)">back</A>.
                        </CENTER>
                        </BODY>
                        </HTML>
__END_OF_HTML_CODE__

                        exit;
                }
                if (-e "$SAVE_DIRECTORY/$Filename") {
                        print header;
                        print <<__END_OF_HTML_CODE__;
                        <HTML>
                        <HEAD>
                        <TITLE>Error: Filename Problem</TITLE>
                        <body bgcolor="$BGColor" text="$TextColor" link="$LinkColor" vlink="$VisitedLinkColor" alink="$ActiveLinkColor"></head>
                        <CENTER><IMG SRC="$imagesdir/$BBTitle"><P>
				The file "$Filename" already exists on your server. Please rename the file and try it again.
                        </BODY>
                        </HTML>
__END_OF_HTML_CODE__
                        exit;
                }
                open(OUTFILE, ">$SAVE_DIRECTORY\/$Filename");
                undef $BytesRead;
                undef $Buffer;

                while ($Bytes = read($File_Handle,$Buffer,2096)) {
                        $BytesRead += $Bytes;
                binmode OUTFILE;
                        print OUTFILE $Buffer;
        }

                push(@Files_Written, "$SAVE_DIRECTORY\/$Filename");
                $TOTAL_BYTES += $BytesRead;
                $Confirmation{$File_Handle} = $BytesRead;

        close($File_Handle);
                close(OUTFILE);
    }

        $FILES_UPLOADED = scalar(keys(%Confirmation));

        if ($TOTAL_BYTES > $MAXIMUM_UPLOAD && $MAXIMUM_UPLOAD > 0) {
                foreach $File (@Files_Written) {
                        unlink $File;
                }

                print header;
                print <<__END_OF_HTML_CODE__;
                <HTML>
                <HEAD>
                <TITLE>Error: Limit Reached</TITLE>
                <body bgcolor="$BGColor" text="$TextColor" link="$LinkColor" vlink="$VisitedLinkColor" alink="$ActiveLinkColor"></head>
                <CENTER><IMG SRC="$imagesdir/$BBTitle"><P>
			File is too big. It has <B>$TOTAL_BYTES</B> bytes but only <B>$MAXIMUM_UPLOAD</B> bytes are allowed.
                </CENTER>
                </BODY>
                </HTML>
__END_OF_HTML_CODE__
                exit;
        }

if (($TOTAL_BYTES eq $null) || ($TOTAL_BYTES == 0)) {
        print header;
        print <<__END_OF_HTML_CODE__;
        <HTML>
        <HEAD>
        <TITLE>Error: Filename Problem</TITLE>
        <body bgcolor="$BGColor" text="$TextColor" link="$LinkColor" vlink="$VisitedLinkColor" alink="$ActiveLinkColor"></head>
        <CENTER><IMG SRC="$imagesdir/$BBTitle"><P>
		No file selected or file is empty.
        </BODY>
        </HTML>
__END_OF_HTML_CODE__
exit;
}


print header;
print qq(
<HTML>
<HEAD>
<TITLE>Upload Finished</TITLE>
<body bgcolor="$BGColor" text="$TextColor" link="$LinkColor" vlink="$VisitedLinkColor" alink="$ActiveLinkColor"></head>
<CENTER><IMG SRC="$imagesdir/$BBTitle"><P>
File successfully uploaded:<P>
<B><FONT SIZE="-1"><IMG SRC="$SAVE_HTTP/$Filename"></B></FONT>
</center>
</BODY>
</HTML>
);
exit;