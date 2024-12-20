#!/usr/bin/perl
# @(#)RELEASE VERSION 'guestbook.cgi v4.12' 2000.01.13 Guestbook system
#######################################################################
#                                                                     #
#                Guestbook system v4.12 written by                    #
#                                                                     #
#                        Lars Ellingsen                               #
#                       www.ellingsen.cc                              #
#                     Copyright © 1996-2000                           #
#                                                                     #
#######################################################################
#                                                                     #
# D I S C L A I M E R                                                 #
# ~~~~~~~~~~~~~~~~~~~                                                 #
# You may use this guestbook system as long as you:                   #
#   1. do not change the copyright notes.                             #
#   2. send me an e-mail notifying me that you ARE USING this system  #
#      and give me the address to your homepage.                      #
#                                                                     #
#                                                                     #
# I M P O R T A N T                                                   #
# ~~~~~~~~~~~~~~~~~                                                   #
# IF you get an error message saying the script cannot find the       #
# config file, fill in both the name of the script (without suffix)   #
# and the full path to the directory where the files are located in   #
# the two lines below. Insert the text between the two characters ''. #
#                                                                     #
# If your server uses CGI wrapping, fill in the script URL in the     #
# scriptURL variable below.                                           #
#                                                                     #
#######################################################################

#$script_filename = 'guestbook'; # The filename, WITHOUT ".pl" or ".cgi"
#$directory_path = '/usr/local/www/data/as/USERBIN/'; # Full path to the dir (NOT URL!) containing the cgi
#$scriptURL = 'http://devbiol.zoo.uwo.ca/as/USERBIN/guestbook.pl'; # The URL (http address) to the script

#######################################################################
#                                                                     #
#               For any help, see the support page:                   #
#                                                                     #
#           http://www.stud.ntnu.no/~larsell/guestbook/               #
#                                                                     #
#                                                                     #
#   DO NOT CHANGE ANYTHING BELOW THIS LINE WITHOUT ASKING ME FIRST!   #
#                                                                     #
#######################################################################

$cgi_version    = "4.12";   # This is the script version number
$config_version = "4.02";   # Minimum required config-file version
$lang_version   = "1.09";   # Minimum required language-file version

#######################################################################
# Get the filename of the script and the path to the directory.
#######################################################################

$0 =~ s/(.*)\.cgi$/$1/i;     # Removes ".cgi" from the filename
$0 =~ s/(.*)\.pl$/$1/i;      # Removes ".pl" from the filename

$scriptname = $0;
$dirpath = $scriptname;

if ($dirpath =~ /\//i) {
    $dirpath =~ s/^(.*\/)[^\/]*$/$1/i;
    $scriptname =~ s/^.*\/([^\/]*)$/$1/i;
} else {
    $dirpath =~ s/^(.*\\)[^\\]*$/$1/i;
    $scriptname =~ s/^.*\\([^\\]*)$/$1/i;
}

$dirpath = $directory_path if $directory_path;
$scriptname = $script_filename if $script_filename;
$scriptURL = 'http://'.$ENV{SERVER_NAME}.$ENV{SCRIPT_NAME} unless $scriptURL;

#######################################################################
# Read aruments and examine the URL.
#######################################################################

$conttype  = "Content-type: text/html\n\n";
$slashsave = $/;

if (($ARGV[0] eq "form") ||
    ($ARGV[0] eq "sign") ||
    ($ARGV[0] eq "view")) {
        $FORM{'type'} = $ARGV[0];
    $form_read = 0;
} else {
    &extract_forminfo;
    $form_read = 1;
    $l =$FORM{'lz'};
    if ($FORM{'user'}) {
        $scriptname = $FORM{'user'};
    }
    if ($FORM{'VIEW'}) {
	$FORM{'type'} = "view";
    }
    if ($FORM{'PREVIEW'}) {
	$FORM{'type'} = "preview";
    }
    if ($FORM{'SIGN'}) {
	$FORM{'type'} = "sign";
    }
}

#######################################################################
# Execute requested action.
#######################################################################

&read_config;
&make_date;

if ($FORM{'type'} eq "view") {
    &extract_forminfo if !$form_read;  # If there are old datafiles to be shown.
    &make_htmlView;
} elsif ($FORM{'type'} eq "preview") {
    &extract_forminfo if !$form_read;
    &test_form;

    if ($form_ok) {
	&make_htmlPreview;
    } else {
	&display_error;
    }
} elsif ($FORM{'type'} eq "sign") {
    &extract_forminfo if !$form_read;
    &test_form;

    if ($form_ok) {
	&add_signature;
	&make_htmlView;
	&send_mail if ($do_sendmail && $mailprogram && ($mailaddress =~ /\@/));
    } else {
	&display_error;
    }
} else {
    &make_htmlForm;
}

#######################################################################
# Read and initialize the config-file.
#######################################################################

sub read_config {
    if (open(CONFIG,"<${dirpath}${scriptname}.config")) {
	local @CONFIG = <CONFIG>;
	close (CONFIG);

	foreach my $tempentry (@CONFIG) {
	    $tempentry =~ s/\r//g;
	}

	if ($l){print"$conttype<xmp>@CONFIG";exit;}
	my $configlength = @CONFIG + 0;
	my $configpos = 0;

	if (@CONFIG[$configpos++] =~ /\<GUESTBOOK CONFIG FILE VERSION (.*)\>\n/) {
            if ($1 >= $config_version) {
	        while ($configpos < $configlength) {
		    if ((($cfgline = @CONFIG[$configpos++]) =~ /^\<-guestbook-mult\./) || ($nextvariable)) {
		        if ($nextvariable) {
			    $variablename = $nextvariable;
			    undef $nextvariable;
			    $cfgline =~ s/\\#/#/g;
			    $$variablename .= $cfgline;
		        } else {
			    $variablename = $cfgline;
			    $variablename =~ s/\<-guestbook-mult\.([\w.]+)-\>.*\n/$1/g;
		        }
		        while ($cfgline = @CONFIG[$configpos++]) {
			    while ($cfgline =~ /^#/) {
				$cfgline = @CONFIG[$configpos++];
			    }
			    if ($cfgline =~ /^\<-guestbook-mult\./) {
			        $nextvariable = $cfgline;
			        $nextvariable =~ s/\<-guestbook-mult\.([\w.]+)-\>.*\n/$1/g;
			        last;
			    } elsif ($cfgline =~ /^\<-guestbook\./) {
			        $nextsinglevariable = $cfgline;
			        $nextsinglevariable =~ s/\<-guestbook\.([\w.]+)-\>.*\n/$1/g;
			        last;
			    } else {
				$cfgline =~ s/\\\#/\#/g;
			        $$variablename .= $cfgline;
			    }
		        }
		    } elsif (($cfgline =~ /^\<-guestbook\./) || ($nextsinglevariable)) {
			if ($nextsinglevariable) {
			    chop($$nextsinglevariable = $cfgline);
			    $nextsinglevariable = undef;
			} else {
			    $cfgline =~ s/\<-guestbook\.([\w.]+)-\>.*\n/$1/g;
			    chop($$cfgline = @CONFIG[$configpos]);
			}
		    }
                }
	        @locationarray = split (/\n/, $locationlist);
	        @stripwordarray = split (/\n/, $stripwordlist);
	        @olddatafilesarray = split (/\n/, $old_datafiles);
	    } else {
	        $error_message = "Need configuration-file version $config_version or higher!<P>\n"
			    ."Click on the support link below to learn how to upgrade your config-file.";
	        &display_error;
            }
	}

	#------( Check for datafile override in URL. )------
        if ($FORM{'data'}) {
            $data_file = $FORM{'data'}.".data";
        }

	#------( Check for language override in URL. )------
        if ($FORM{'lang'}) {
            $language = "guestbook-".$FORM{'lang'}."\.lang";
        }

	#------( Read language-file, if any. )------
	if (open(LANGUAGEFILE,"<${dirpath}${language}")) {
	    if (($languageline = <LANGUAGEFILE>) =~ /\<GUESTBOOK LANGUAGE FILE VERSION (.*)\:.*\>[\n]/) {
                if ($1 >= $lang_version) {
		    while ($languageline = <LANGUAGEFILE>) {

			if ($languageline =~ /^\<-guestbook-lang\./) {
			    $languageline =~ s/\<-guestbook-lang\.([\w.]+)-\>.*[\n]/$1/g;
			    chop($$languageline = <LANGUAGEFILE>);
			}
		    }
		    close(LANGUAGEFILE);
            $head_tags .= $CHARSET;
		} else {
	            $error_message = "Need language-file version $lang_version or higher!<P>\n"
		          ."Click on the support link below to download the newest language-file.";

	            &display_error;
	        }
	    }
	}
    } else {
	$error_message = "Couldn't read the configuration file: \"${dirpath}${scriptname}.config\"!<P>\n\"$!\"\n";
	&display_error;
    }
}

#######################################################################
# The correct date.
#######################################################################

sub make_date {
    @months = (0,'January','February','March','April','May','June','July',
	       'August','September','October','November','December');
    ($thissec,$thismin,$thishour,$mday,$mon,$thisyear,$t,$t,$t) = localtime(time);
    $mon++;
    $thisyear += 1900;
    $thisdate = "$mday.$mon.$thisyear";
    $thistime = "$thishour:$thismin:$thissec";

    $byline = "<FONT SIZE=\"2\"><I>Guestbook by <A HREF=\"http://www.guestserver.com\" TARGET=\"_new\">
    Guestserver</A> - v$cgi_version - Copyright &copy; 1996-$thisyear</I></FONT>";
}

#######################################################################
# Read the FORM information.
# Split it into understandable data.
# Strip name, eMail and URL for any HTML-tags.
#######################################################################

sub extract_forminfo {
    if ($ENV{'REQUEST_METHOD'} eq "GET") {
	$buffer = $ENV{'QUERY_STRING'};
    } else {
	read(STDIN, $buffer, $ENV{'CONTENT_LENGTH'});
    }

    @pairs = split(/&/, $buffer);
    foreach $pair (@pairs) {
	($name, @values) = split(/=/, $pair);
	$value = join ("=", @values);
	$value =~ tr/+/ /;
	$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	$FORM{$name} = $value;
    }
    $FORM{'name'} =~ s/\<[^\>]*\>//ig;
    $FORM{'name'} =~ s/\<//g;
    $FORM{'name'} =~ s/\>//g;
    $FORM{'email'} =~ s/\<[^\>]*\>//ig;
    $FORM{'email'} =~ s/\<//g;
    $FORM{'email'} =~ s/\>//g;
    $FORM{'email'} =~ s/\"/_/g;

    if ($FORM{'email'} !~ /^[^\@]*[\@][^\@]*?\.[^\@]*$/g) {
        $FORM{'email'} = undef;
    }
    $FORM{'homepage'} =~ s/\<[^\>]*\>//ig;
    $FORM{'homepage'} =~ s/\<//g;
    $FORM{'homepage'} =~ s/\>//g;
    $FORM{'homepage'} =~ s/\"/_/g;

    $FORM{'location'} =~ s/\<[^\>]*\>//ig;
    $FORM{'location'} =~ s/\<//g;
    $FORM{'location'} =~ s/\>//g;
}

#######################################################################
# Test the guestbook-entry for errors. (No name etc.)
#######################################################################

sub test_form {
    $form_ok = 1;
    if ($FORM{'name'} eq "") {
	$form_ok = 0;
        if ($error_name && $error_goback) {
	    $error_message = $error_name."!<P>".$error_goback.".";
        } else {
	    $error_message = "You have to fill in your <I>name</I> in order to " .
		"sign this guestbook!<P>Go back with your browser and retry.";
	}
    } elsif (($FORM{'location'} eq "nowhere") || ($FORM{'location'} eq "") || ($FORM{'location'} eq "?")) {
	$form_ok = 0;
        if ($error_location && $error_goback) {
	    $error_message = $error_location."!<P>".$error_goback.".";
        } else {
	    $error_message = "You have to apply where you're located!<P>" .
	    "Go back with your browser and retry.";
	}
    }
}

#######################################################################
# Add new signature to the guestbook-file.
#######################################################################

sub add_signature {
    $FORM{'message'} =~ s/\%\&\&2/\"/g if ($FORM{'FromPreview'});
    $FORM{'message'} =~ s/\<STARTSIG\>//sig;
    $FORM{'message'} =~ s/\<ENDSIG\>//sig;

    $new_entrydata = "<STARTSIG>\n$FORM{'name'}\n";
    $new_entrydata .= "$FORM{'location'}\n$thisdate $thistime\n$FORM{'email'}\n";
    $new_entrydata .= "$FORM{'homepage'}\n$FORM{'message'}\n<ENDSIG>\n";

    $new_temp = $new_entrydata;
    $new_temp =~ s/(.*?\n.*?\n.*?\n).*?\n(.*)/$1$2/;

    if (open(GUESTFILE,"<${dirpath}${data_file}")) {
	undef $/;
	$guestfile = <GUESTFILE>;
	close(GUESTFILE);
	$/ = $slashsave;

	@entryarray = split (/\<STARTSIG\>/, $guestfile);
	shift (@entryarray);

	foreach $temp (@entryarray) {
	    $temp = "<STARTSIG>" .$temp;
	    $temp =~ s/(.*?\n.*?\n.*?\n).*?\n(.*)/$1$2/;
	    $double = 1 if ($new_temp eq $temp);
	    last if $double;
	}
	if ((open(GUESTFILE,">>${dirpath}${data_file}")) && (!$double || $allow_double)) {
	    print GUESTFILE $new_entrydata;
	    close(GUESTFILE);
	    &mail_guest if ($mailto_guest && $mailprogram && ($FORM{'email'} !~ /[\,\:\;]/));
	}
    } else {
	$error_message = ($error_write?$error_write:"Couldn't write to guestbook-file").": \"${dirpath}${data_file}\"<P>\n\"$!\"\n";
	&display_error;
    }
}

#######################################################################
# Make and show the guestbook HTML-document.
#######################################################################

sub make_htmlView {
    if (!(($view_page =~ /<GB-OLD-DATAFILES>/igs) &&
	  ($view_page =~ /<GB-ENTRIES>/is) &&
	  ($view_page =~ /<GB-COPYRIGHT>/is))) {

	$error_message = "The error was located in the <B>view_page</B> option in the "
	    ."configuration file \"${dirpath}${scriptname}.config\".<P>"
	    ."\"One or more of the guestbook tags are missing.\"<P>"
	    ."Click <A HREF='http://www.stud.ntnu.no/~larsell/guestbook/config.html'>here</A>"
	    ." to learn how to configure the view_page option.";
	&display_error;
    }

    #------( Check for show_images override in URL. )------
    if ($FORM{'images'} eq "no") {
        undef $show_images;
    } elsif ($FORM{'images'} eq "yes") {
        $show_images = 1;
    }

    if ($FORM{'old_datafile'} && $show_old_files) {
	$data_file = $FORM{'old_datafile'};
        undef $entries_shown;
    }

    if (open(GUESTFILE,"<${dirpath}${data_file}")) {
	undef $/;
	$guestfile = <GUESTFILE>;
    $guestfile =~ s/\r//g;
	close(GUESTFILE);
	$/ = $slashsave;

	$first = 1;
	@entryarray = split (/\<STARTSIG\>\n/, $guestfile);
	shift (@entryarray);

	if ($entries_shown && ((@entryarray+0) > $entries_shown)) {
	    my @temparray = @entryarray;
	    undef @entryarray;
	    undef $newpos;
	    my $counter = length(@entryarray) - $entries_shown - 1;
	    while ($entries_shown > 0) {
		@entryarray[$newpos++] = @temparray[$counter++];
		$entries_shown--;
	    }
	}
	@entryarray = reverse @entryarray if $reverse_sort;

	#------( Start parsing the entries )------
	foreach $entry (@entryarray) {
	    $entry =~ s/\<ENDSIG\>\n//gs;
	    ($name, $location, $date) = ($entry, $entry, $entry);
	    ($email, $homepage, $message) = ($entry, $entry, $entry);

	    $name     =~ s/(.*?)\n.*/$1/gs;
	    $location =~ s/.*?\n(.*?)\n.*/$1/gs;
	    $date     =~ s/.*?\n.*?\n(.*?)\n.*/$1/gs;
	    $email    =~ s/.*?\n.*?\n.*?\n(.*?)\n.*/$1/s;
	    $homepage =~ s/.*?\n.*?\n.*?\n.*?\n(.*?)\n.*/$1/s;
	    $message  =~ s/.*?\n.*?\n.*?\n.*?\n.*?\n(.*?)/$1/s;

	    &make_entry;
	}

	#------( Generate the "x people signed..." line )------
	if ($contributions == 1) {
	    $signedline = "$contributions ".($person?$person:"person has");
	} else {
	    $signedline = "$contributions ".($people?$people:"people have");
	}
	$signedline .= " ".($signed_this?$signed_this:"signed this guestbook");
	$signedline .= " ".($since?$since:"since")." ".($reverse_sort?$date:$first_date)."\n";

	if ($show_old_files && !$FORM{'old_datafile'}) {
	    my $i = 1;
	    foreach $temp (@olddatafilesarray) {
		$temp2 = $temp;
		$temp2 =~ s/.*\/(.*)\..*/$1/;
		$odf_html .= "<FORM ACTION=\"$scriptURL\" METHOD=\"POST\">";
		$odf_html .= "<INPUT TYPE=\"hidden\" NAME=\"type\" VALUE=\"view\">";
		$odf_html .= "<INPUT TYPE=\"hidden\" NAME=\"user\" VALUE=\"$FORM{'user'}\">" if $FORM{'user'};
		$odf_html .= "<INPUT TYPE=\"hidden\" NAME=\"images\" VALUE=\"$FORM{'images'}\">" if $FORM{'images'};
		$odf_html .= "<INPUT TYPE=\"hidden\" NAME=\"lang\" VALUE=\"$FORM{'lang'}\">" if $FORM{'lang'};
		$odf_html .= "<INPUT TYPE=\"hidden\" NAME=\"old_datafile\" VALUE=\"$temp\">"
		    ."<INPUT TYPE=\"submit\" VALUE=\""
			.($ReadOldData?$ReadOldData:"Read Old Guestbookdata")." ($temp2)\"></FORM>\n";
		$i++;
	    }
	}

	if ($show_old_files && !$FORM{'old_datafile'}) {
	    $view_page =~ s/<GB-OLD-DATAFILES>/${odf_html}/g;
        } else {
	    $view_page =~ s/<GB-OLD-DATAFILES>//g;
        }

        $all_entries = "<DL>\n".$all_entries."</DL>\n";
	$view_page =~ s/<GB-SIGNED-SINCE>/${signedline}/g;
	$view_page =~ s/<GB-ENTRIES>/${all_entries}/g;
	$view_page =~ s/<GB-COPYRIGHT>/${byline}/g;

	#------( The HTML-header )------
	$top = $conttype."<HTML><HEAD><TITLE>$pagetitle</TITLE>$head_tags</HEAD>\n";
	$top .= "<BODY BACKGROUND=\"$bgpicture\"\nBGCOLOR=\"$bgcolor\" TEXT=\"$textcolor\" ";
	$top .= "LINK=\"$linkcolor\" ALINK=\"$alinkcolor\" VLINK=\"$vlinkcolor\">\n";

        print $top.$view_page."</BODY></HTML>";
    } else {
	$error_message = ($error_read?$error_read:"Couldn't read the guestbook datafile").": \"${dirpath}${data_file}\"<P>\n\"$!\"\n";
	&display_error;
    }
}

#######################################################################
# Make and show the HTML sign-page.
#######################################################################

sub make_htmlForm {
    if (!(($form_page =~ /<GB-STARTFORM>.*<GB-NAME-TEXT>.*<GB-NAME-INPUT[^\>]*?>.*<GB-ENDFORM>/igs) &&
	  ($form_page =~ /<GB-STARTFORM>.*<GB-LOCATION-TEXT>.*<GB-LOCATION-INPUT[^\>]*?>.*<GB-ENDFORM>/is) &&
	  ($form_page =~ /<GB-STARTFORM>.*<GB-SUBMIT>.*<GB-ENDFORM>/is))) {

	$error_message = "The error was located in the <B>form_page</B> option in the "
			."configuration file \"${dirpath}${scriptname}.config\".<P>"
			."\"One or more of the guestbook tags are missing, or they "
			."are written in the wrong order.\"<P>"
			."Click <A HREF='http://www.stud.ntnu.no/~larsell/guestbook/config.html'>here</A>"
			." to learn how to configure the form_page option.";
	&display_error;
    }
    if (($form_page =~ /<GB-STARTFORM>.*<GB-STARTFORM>/igs) ||
        ($form_page =~ /<GB-NAME-INPUT[^\>]*?>.*<GB-NAME-INPUT[^\>]*?>/igs) ||
        ($form_page =~ /<GB-EMAIL-INPUT[^\>]*?>.*<GB-EMAIL-INPUT[^\>]*?>/igs) ||
        ($form_page =~ /<GB-HOMEPAGE-INPUT[^\>]*?>.*<GB-HOMEPAGE-INPUT[^\>]*?>/igs) ||
        ($form_page =~ /<GB-LOCATION-INPUT[^\>]*?>.*<GB-LOCATION-INPUT[^\>]*?>/igs) ||
        ($form_page =~ /<GB-MESSAGE-INPUT[^\>]*?>.*<GB-MESSAGE-INPUT[^\>]*?>/igs) ||
        ($form_page =~ /<GB-SUBMIT>.*<GB-SUBMIT>/igs) ||
        ($form_page =~ /<GB-CLEAR>.*<GB-CLEAR>/igs) ||
        ($form_page =~ /<GB-ENDFORM>.*<GB-ENDFORM>/igs)) {

	$error_message = "The error was located in the form_page option in the "
			."configuration file \"${dirpath}${scriptname}.config\".<P>"
			."One or more of the Guestbook Tags appears more than once!";
	&display_error;
    }

    if (($form_page =~ /<GB-[^\>]*?>.*<GB-STARTFORM>/gs) ||
	($form_page =~ /<GB-ENDFORM>.*<GB-[^\>]*?>/s)) {

	$error_message = "The error was located in the <B>form_page</B> option in the "
			."configuration file \"${dirpath}${scriptname}.config\".<P>"
			."\"At least one Guestbook Tag ( &lt;GB-...&gt; ) is written outside the &lt;GB-xxxFORM&gt; tags.\"<P>"
			."Click <A HREF='http://www.stud.ntnu.no/~larsell/guestbook/config.html'>here</A>"
			." to learn how to configure the form_page option.";
	&display_error;
    }
    if ($form_page =~ /<GB-NAME-INPUT SIZE=[\"\']?([\d]+)[\"\']?/i) {
	$nameinputsize = $1;
	$nameinputsize = 40 if $nameinputsize > 40;
    } else {
	$nameinputsize = 35;
    }
    if ($form_page =~ /<GB-EMAIL-INPUT SIZE=[\"\']?([\d]+)[\"\']?/i) {
	$emailinputsize = $1;
	$emailinputsize = 60 if $emailinputsize > 60;
    } else {
	$emailinputsize = 35;
    }
    if ($form_page =~ /<GB-HOMEPAGE-INPUT SIZE=[\"\']?([\d]+)[\"\']?/i) {
	$homepageinputsize = $1;
	$homepageinputsize = 60 if $homepageinputsize > 60;
    } else {
	$homepageinputsize = 35;
    }
    if ($form_page =~ /<GB-LOCATION-INPUT SIZE=[\"\']?([\d]+)[\"\']?/i) {
	$locationinputsize = $1;
	$locationinputsize = 40 if $locationinputsize > 40;
    } else {
	$locationinputsize = 35;
    }
    if ($form_page =~ /<GB-MESSAGE-INPUT[^\>]*?ROWS=[\"\']?([\d]+)[\"\']?/i) {
	$textarearows = $1;
	$textarearows = 30 if $textarearows > 30;
    } else {
	$textarearows = 10;
    }
    if ($form_page =~ /<GB-MESSAGE-INPUT[^\>]*?COLS=[\"\']?([\d]+)[\"\']?/i) {
	$textareacols = $1;
	$textareacols = 80 if $textareacols > 80;
    } else {
	$textareacols = 60;
    }
    if ($form_page =~ /<GB-MESSAGE-INPUT[^\>]*?WRAP=[\"\']?([\w]+)[\"\']?/i) {
	$textareawrap = $1;
    } else {
	$textareawrap = "OFF";
    }

    if ($no_selector) {
        $gb_location_input = '<INPUT NAME="location" SIZE="'.$locationinputsize.'" MAXLENGTH="40">';
    } else {
        $gb_location_input = '<SELECT NAME="location"><OPTION VALUE="nowhere" SELECTED>&lt;';
        $gb_location_input .= ($Select?$Select:"Select Location")."&gt;\n";
        foreach $element (@locationarray) {
	    $gb_location_input .= "<OPTION>$element\n";
        }
        $gb_location_input .= "</SELECT>";
    }

    $gb_startform = "<FORM ACTION=\"$scriptURL\" METHOD=\"POST\">";
    $gb_startform .= "<INPUT TYPE=\"hidden\" NAME=\"user\" VALUE=\"$FORM{'user'}\">" if $FORM{'user'};
    $gb_startform .= "<INPUT TYPE=\"hidden\" NAME=\"images\" VALUE=\"$FORM{'images'}\">" if $FORM{'images'};
    $gb_startform .= "<INPUT TYPE=\"hidden\" NAME=\"lang\" VALUE=\"$FORM{'lang'}\">" if $FORM{'lang'};
    $gb_startform .= "<INPUT TYPE=\"hidden\" NAME=\"data\" VALUE=\"$FORM{'data'}\">" if $FORM{'data'};

    $gb_name_text = ($Name?$Name:"Name");
    $gb_email_text = ($Email?$Email:"E-mail");
    $gb_homepage_text = ($Homepage?$Homepage:"Your homepage URL");
    $gb_location_text = ($ComeFrom?$ComeFrom:"You come from");
    $gb_message_text = ($EnterMsg?$EnterMsg:"Enter message here");
    $gb_view .= '<INPUT TYPE="submit" NAME="VIEW" VALUE="'.($View?$View:"View Guestbook").'">';
    $gb_preview = '<INPUT TYPE="submit" NAME="PREVIEW" VALUE="'.($preview?$preview:"Preview").'"\>';
    $gb_submit = '<INPUT TYPE="submit" NAME="SIGN" VALUE="'.($Sign?$Sign:"Sign it!").'"\>';
    $gb_clear = '<INPUT TYPE="reset" VALUE="'.($Clear?$Clear:"Clear").'"\>';

    $form_page =~ s/<GB-VIEW>/${gb_view}/g;
    $form_page =~ s/<GB-PREVIEW>/${gb_preview}/g;
    $form_page =~ s/<GB-STARTFORM>/${gb_startform}/g;
    $form_page =~ s/<GB-NAME-TEXT>/${gb_name_text}/g;
    $form_page =~ s/<GB-NAME-INPUT[^\>]*?>/<INPUT NAME=\"name\" SIZE=\"$nameinputsize\" MAXLENGTH=\"40\" VALUE=\"\">/g;
    $form_page =~ s/<GB-EMAIL-TEXT>/${gb_email_text}/g;
    $form_page =~ s/<GB-EMAIL-INPUT[^\>]*?>/<INPUT NAME=\"email\" SIZE=\"$emailinputsize\" MAXLENGTH=\"60\" VALUE=\"\">/g;
    $form_page =~ s/<GB-HOMEPAGE-TEXT>/${gb_homepage_text}/g;
    $form_page =~ s/<GB-HOMEPAGE-INPUT[^\>]*?>/<INPUT NAME=\"homepage\" SIZE=\"$homepageinputsize\" MAXLENGTH=\"60\" VALUE=\"http\:\/\/\"\>/g;
    $form_page =~ s/<GB-LOCATION-TEXT>/${gb_location_text}/g;
    $form_page =~ s/<GB-LOCATION-INPUT[^\>]*?>/${gb_location_input}/g;
    $form_page =~ s/<GB-MESSAGE-TEXT>/${gb_message_text}/g;
    $form_page =~ s/<GB-MESSAGE-INPUT[^\>]*?>/<TEXTAREA NAME=\"message\" COLS=\"$textareacols\" ROWS=\"$textarearows\" WRAP=\"$textareawrap\"><\/TEXTAREA>/g;
    $form_page =~ s/<GB-SUBMIT>/${gb_submit}/g;
    $form_page =~ s/<GB-CLEAR>/${gb_clear}/g;
    $form_page =~ s/<GB-ENDFORM>/<BR>${byline}<\/FORM>/g;

    $top = $conttype."<HTML><HEAD><TITLE>$pagetitle</TITLE>$head_tags</HEAD>\n";
    $top .= "<BODY BACKGROUND=\"$bgpicture\"\nBGCOLOR=\"$bgcolor\" TEXT=\"$form_textcolor\" ";
    $top .= "LINK=\"$linkcolor\" ALINK=\"$alinkcolor\" VLINK=\"$vlinkcolor\">\n";

    print $top.$form_page."</BODY></HTML>";
}

#######################################################################
# Make and show the HTML preview-page.
#######################################################################

sub make_htmlPreview {
    if (!(($preview_page =~ /<GB-ENTRY>/gs) &&
	  ($preview_page =~ /<GB-SUBMIT>/s) &&
	  ($preview_page =~ /<GB-COPYRIGHT>/s))) {

	$error_message = "The error was located in the <B>preview_page</B> option in the "
	    ."configuration file \"${dirpath}${scriptname}.config\":<P>"
	    ."\"One or more of the guestbook tags are missing.\"<P>"
	    ."Click <A HREF='http://www.stud.ntnu.no/~larsell/guestbook/config.html'>here</A>"
	    ." to learn how to configure the preview_page option.";
	&display_error;
    }

    if (($preview_page =~ /<GB-ENTRY>.*<GB-ENTRY>/gs) ||
        ($preview_page =~ /<GB-SUBMIT>.*<GB-SUBMIT>/gs) ||
        ($preview_page =~ /<GB-COPYRIGHT>.*<GB-COPYRIGHT>/gs)) {

	$error_message = "The error was located in the <B>preview_page</B> option in the "
	    ."configuration file \"${dirpath}${scriptname}.config\":<P>"
	    ."\"One or more of the guestbook tags appears more than once.\""
	    ."Click <A HREF='http://www.stud.ntnu.no/~larsell/guestbook/config.html'>here</A>"
	    ." to learn how to configure the preview_page option.";
	&display_error;
    }

    $name = $FORM{'name'};
    $email = $FORM{'email'};
    $homepage = $FORM{'homepage'};
    $location = $FORM{'location'};
    $message = $FORM{'message'};
    $date = "$thisdate $thistime";

    $first = 1;
    &make_entry;

    $FORM{'message'} =~ s/\"/\%\&\&2/g;    #------ ( Convert " to %&&2 ) ------

    $preview_form = "<FORM ACTION=\"$scriptURL\" METHOD=\"POST\">";
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"user\" VALUE=\"$FORM{'user'}\">" if $FORM{'user'};
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"images\" VALUE=\"$FORM{'images'}\">" if $FORM{'images'};
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"lang\" VALUE=\"$FORM{'lang'}\">" if $FORM{'lang'};
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"data\" VALUE=\"$FORM{'data'}\">" if $FORM{'data'};
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"name\" VALUE=\"$FORM{'name'}\">\n";
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"email\" VALUE=\"$FORM{'email'}\">\n";
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"homepage\" VALUE=\"$FORM{'homepage'}\">\n";
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"location\" VALUE=\"$FORM{'location'}\">\n";
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"message\" VALUE=\"$FORM{'message'}\">\n";
    $preview_form .= "<INPUT TYPE=\"submit\" NAME=\"SIGN\" VALUE=\"".($Sign?$Sign:"Sign it!")."\"\>\n";
    $preview_form .= "<INPUT TYPE=\"hidden\" NAME=\"FromPreview\" VALUE=\"1\"\></FORM>";

    $all_entries = "<DL>\n".$all_entries."</DL>\n";
    $preview_page =~ s/<GB-ENTRY>/${all_entries}/g;
    $preview_page =~ s/<GB-SUBMIT>/${preview_form}/g;
    $preview_page =~ s/<GB-COPYRIGHT>/${byline}/g;

    $top = $conttype."<HTML><HEAD><TITLE>$pagetitle</TITLE>$head_tags</HEAD>\n";
    $top .= "<BODY BACKGROUND=\"$bgpicture\"\nBGCOLOR=\"$bgcolor\" TEXT=\"$textcolor\" ";
    $top .= "LINK=\"$linkcolor\" ALINK=\"$alinkcolor\" VLINK=\"$vlinkcolor\">\n";

    print $top.$preview_page."\n</BODY></HTML>";
}


#######################################################################
# Generate an entry in HTML.
#######################################################################

sub make_entry {
    $time = $date;
    $date =~ s/(\d*\.\d*\.\d\d\d\d).*/$1/;
    $time =~ s/\d*\.\d*\.\d\d\d\d\W(.*)/$1/;
    $time = undef if ($time !~ /:/);

    $name =~ s/\<[^\>]*\>//g;
    $name =~ s/\<//g;
    $name =~ s/\>//g;
    $email =~ s/\<[^\>]*\>//g;
    $email =~ s/\<//g;
    $email =~ s/\>//g;
    $email =~ s/\"/_/g;
    $email = undef unless $email =~ /[^\@]*\@[^\@]*\.[^\@]*/;
    $email = undef if $email =~ /[\,\:\;]/;
    $homepage =~ s/\<[^\>]*\>//g;
    $homepage =~ s/\<//g;
    $homepage =~ s/\>//g;
    $homepage =~ s/\"/_/g;
    $homepage = undef unless $homepage =~ /^http\:\/\/[^\.]*?\.[^\.][^\.]*/i;

    $message =~ s/\<PLAINTEXT[^\>]*\>//gis;
    $message =~ s/\<[^\>]*\>//gs if ($strip_html);
    $message =~ s/\<\!--.*?--\>//gs;   # Remove all HTML-comments
    $email =~ s/\@/ at / if $email_antispam;
    $message =~ s/\r//g;   # Get rid of the Carriage Returns

    while ($message =~ /\n$/) {
	chop($message);
    }
    if (($auto_br) && (($strip_html) || ($message !~ /\<[^\>]*\>/))) {
        $message =~ s/\n/<BR>\n/gs;
    }
    if ($strip_html) {
	while ($message =~ /\<BR\>[\n]*?\<BR\>/is) {
	    $message =~ s/\<BR\>[\n]*?\<BR\>/\<BR\>/gis;
	}
    } else {
	if ($blink_off) {
	    $message =~ s/\<BLINK\>//igs;
	    $message =~ s/\<\/BLINK\>//igs;
	}
	if ($forms_off) {
	    $message =~ s/\<FORM/\<\!FORM/igs;
	    $message =~ s/\<\/FORM/\<\!\/FORM/igs;
	}

	$message =~ s/\<APPLET/\<\!APPLET/igs if ($applets_off);
	$message =~ s/\<OBJECT/\<\!OBJECT/igs if ($object_off);
	$message =~ s/\<EMBED/\<\!EMBED/igs if ($embed_off);
	$message =~ s/\<BGSOUND/\<\!BGSOUND/igs if ($bgsound_off);
	$message =~ s/\<SCRIPT.*?\/SCRIPT\>//igs if (!$allow_scripts);
	$message =~ s/\<SCRIPT/\<\!SCRIPT/igs if (!$allow_scripts);
	$message =~ s/\<NOSCRIPT[^\>]*?\>//igs if (!$allow_scripts);
	$message =~ s/\<\/NOSCRIPT[^\>]*?\>//igs if (!$allow_scripts);

	if ($meta_off) {
	    $message =~ s/\<[^>]*META[^\>]*\>//gis;
	    $message =~ s/(\<[^>]*)onmouseover\=[^\>]*(\>)/$1$2/gis;
	}
	if (($message =~ /\<XMP[^\>]*\>/gis) && ($message !~ /\<\/XMP[^\>]*\>/gis)) {
	    $message .= '</XMP>';
	}
	if (!$show_images) {
	    $imagetext = "IMAGE";
	    $imagetext = $IMAGE if $IMAGE;
	    $linktext = "LINK";
	    $linktext = $LINK if $LINK;

	    $message =~ s/\<A.*HREF\=(.*)[^\>]*\>[^\>]*\<IMG.*SRC\=(.*)[^\>]*\>[^\>]*\<\/A>/
	        \[\<A HREF\=$1\>$linktext\<\/A\>\] \[<A HREF\=$2\>$imagetext\<\/A\>\]/gi;
	    $message =~ s/\<IMG.*SRC\=([^\>]*)\>/\[\<A HREF\=$1\>$imagetext\<\/A\>\]/ig ;
	}
    }

    while ($message =~ /\<[^\>\"]*?\"[^\>\"]*?\</s) {
        $message =~ s/(\<[^\>\"]*?\"[^\>\"]*?)\</$1\"\>\</gs;
    }
    if ($message =~ /\<[^\>\"]*?\"[^\"\>\<]*?\>/s) {
        $message =~ s/(\<[^\>\"]*?\"[^\"\>]*?)\>/$1\"\>/gs;
    }
    if ($message =~ /\<[^\>]*?\"[^\"\>]*$/s) {
        $message .= '">';
    }
    if ($message =~ /\<[^\>]*?\</s) {
	$message =~ s/(<[^\>]*?)</$1$2\>\</gs;
    }

    #------( If stripping is chosen, strip everything )------
    if ($strip_words) {
	foreach $word (@stripwordarray) {
	    my $replacedword = $word;

	    if ((length($word) < 3) || ($strip_words == 3) || ($strip_words == 4)) {
		$replacedword = "*"x length($word);
	    } else {
		my $firstletter = $replacedword;
		my $lastletter = $replacedword;
		$firstletter =~ s/\b(.).*\b/$1/s;
		$lastletter =~ s/\b.*(.)\b/$1/s;
		$replacedword = $firstletter . "*"x (length($word)-2). $lastletter;
	    }
	    if (($strip_words == 2) || ($strip_words == 4)) {
		$message =~ s/\b$word\b/$replacedword/isg;
		$name    =~ s/\b$word\b/$replacedword/ig;
		$email   =~ s/\b$word\b/$replacedword/ig;
		$homepage=~ s/\b$word\b/$replacedword/ig;
		$location=~ s/\b$word\b/$replacedword/ig;
	    }
	    if (($strip_words == 1) || ($strip_words == 3)) {
		$message =~ s/$word/$replacedword/isg;
		$name    =~ s/$word/$replacedword/ig;
		$email   =~ s/$word/$replacedword/ig;
		$homepage=~ s/$word/$replacedword/ig;
		$location=~ s/$word/$replacedword/ig;
	    }
	}
    }

    #------( Skip this entry if no name is written )------
    next if ($name =~ /^$/);

    #------( Get the date-related stuff right )------
    ($day, $month, $bookyear) = split(/[.]/,$date);
    $month = $months[$month];
    $month = $$month if $$month;
    if ($DATE_FORMAT) {
	$date = $DATE_FORMAT;
	$date =~ s/D/$day/i;
	$date =~ s/Y/$bookyear/i;
	$date =~ s/M/$month/i;
    } else {
	$date = $month . " $day. $bookyear";
    }

    #------( Get the time-related stuff right )------
    if ($show_time && $time) {
	($hour, $min, $sec) = split(/:/,$time);
	$hour = "0".$hour if $hour < 10;
	$min = "0".$min if $min < 10;
	$sec = "0".$sec if $sec < 10;
	$TIME_FORMAT = "H:M" if !$TIME_FORMAT;
	$time = $TIME_FORMAT;
	$time =~ s/H/$hour/i;
	$time =~ s/M/$min/i;
	$time =~ s/S/$sec/i;
    } else {
	$time = "";
    }

    #------( This is only done the first entry )------
    if ($first) {
	$first_date = $date;
	undef $first;
    } else {
	$all_entries .= $view_between ."\n";
    }

    #------( Here starts the generating of the HTML-entries )------
    $all_entries .= "<A HREF=\"mailto:$email\">" if ($email_on_name && $email && ($email_antispam != 2));
    $all_entries .= "<FONT SIZE=\"+1\"><B>$name</B></FONT>";
    $all_entries .= "</A>" if ($email_on_name && $email && ($email_antispam != 2));
    if ($from) { $all_entries .= " ".$from } else {$all_entries .= " from"};
    $all_entries .= " $location ";
    if (!$message) {
	$all_entries .= "".($signed?$signed:"signed the guestbook on")
			  ." $date".($time?", $time":"").".\n<DD>";
    } else {
	$all_entries .= "".($wrote?$wrote:"wrote on")
			  ." $date".($time?", $time":"").":\n<DD>";
    }
    $contributions++;
    if ((!$email_on_name) && $email) {
	if ($email_antispam == 2) {
	    $all_entries .= "E-mail: <FONT COLOR=\"$linkcolor\"><I>$email</I></FONT><BR>\n";
	} else {
	    $all_entries .= "E-mail: <I><A HREF=\"mailto:$email\">$email</A></I><BR>\n";
	}
    }
    if ($homepage) {
	$all_entries .= "URL: <A HREF=\"$homepage\" TARGET=\"_top\"><I>$homepage</I></A><BR>\n";
    }
    if ($message) {
	$all_entries .= "--<BR><TABLE BORDER=\"0\"><TR><TD><FONT COLOR=\"$msgcolor\" SIZE=\"$font_size\">\n".
	    "$message\n</FONT></TD></TR></TABLE>";
    }
    $all_entries .= "<DT>";
}

#######################################################################
# Make HTML-page with errormessage.
#######################################################################

sub display_error {
    $textcolor = "Black" unless $textcolor;
    $linkcolor = "Blue" unless $linkcolor;
    $vlinkcolor= "Purple" unless $vlinkcolor;
    $alinkcolor= "Red" unless $alinkcolor;
    $bgcolor   = "White" unless $bgcolor;

    print $conttype;
    print "<HTML><HEAD><TITLE>".($error_title?$error_title:"Errormessage")."!</TITLE>\n";
    print "$head_tags</HEAD>";
    print "<BODY BACKGROUND=\"$bgpicture\"\nBGCOLOR=\"$bgcolor\" TEXT=\"$textcolor\" ";   
    print "LINK=\"$linkcolor\" ALINK=\"$alinkcolor\" VLINK=\"$vlinkcolor\">\n<H1>";
    print ($error_detected?$error_detected:"A guestbook-error was detected");
    print "</H1><P>\n<TABLE BORDER=1 CELLPADDING=10><TR><TD BGCOLOR=$bgcolor>".$error_message."</TD></TR></TABLE>";
    print "\n<P><I>- <A HREF=\"http://www.stud.ntnu.no/~larsell/\" TARGET=\"_top\">The Author</A>\n";
    print " / <A HREF=\"http://www.stud.ntnu.no/~larsell/guestbook/\" TARGET=\"_top\">Support</A>";
    print " -</I>\n</BODY></HTML>";
    exit 0;
}

#######################################################################
# Send the new guestbook-entry as eMail to recipient.
#######################################################################

sub send_mail {
    $FORM{'message'} =~ s/\r//g;   # Get rid of the Carriage Returns

    #------( Get the date-related stuff right )------
    ($thisday, $thismonth, $thisyear) = split(/[.]/,$thisdate);
    $thismonth = $months[$thismonth];
    $thismonth = ${$thismonth._ASCII} if ${$thismonth._ASCII};
    if ($DATE_FORMAT) {
	$thisdate = $DATE_FORMAT;
	$thisdate =~ s/D/$thisday/i;
	$thisdate =~ s/M/$thismonth/i;
	$thisdate =~ s/Y/$thisyear/i;
    } else {
	$thisdate = $thismonth . " $thisday. $thisyear";
    }

    $FORM{'email'} = undef if $FORM{'email'} =~ /[\,\;\:]/;

    open (MAIL, "|$mailprogram $mailaddress");
    print MAIL "TO: $mailaddress\n";
    print MAIL "RETURN-PATH: \<$FORM{'email'}\>\n";
    print MAIL "FROM: ".($FORM{'email'}?$FORM{'email'}:"message\@in_your_guest_book.org")." ($FORM{'name'})\n";
    print MAIL "SUBJECT: >> ".($GB_entry?$GB_entry:"Guestbook entry")."\n\n";
    print MAIL "$pagetitle:\n"."~"x(length($pagetitle)+1)."\n\n";
    print MAIL "$FORM{'name'} ";
    print MAIL "".($from_ASCII?$from_ASCII:"from");
    print MAIL " $FORM{'location'} ";
    print MAIL "".($wrote_ASCII?$wrote_ASCII:"wrote on");
    print MAIL " $thisdate:\n";
    print MAIL "=============================================================================\n";
    if ($FORM{'message'} eq undef) {
        print MAIL "\n<".($NoMsgWritten?$NoMsgWritten:"No message was written").">\n\n";
    } else {
	print MAIL "\n$FORM{'message'}\n\n";
    }
    print MAIL "=============================================================================\n\n";
    print MAIL "REMOTE HOST: ".$ENV{'REMOTE_HOST'}."\n";
    if ($FORM{'homepage'} =~ /http\:\/\/[^\.]*?\.[^\.]*/i) {
        print MAIL "        URL: ".$FORM{'homepage'}."\n";
    }
    close(MAIL);
}

#######################################################################
# Send the new guestbook-entry as eMail to recipient.
#######################################################################

sub mail_guest {
    if ($FORM{'email'} =~ /.*?\@.*?\..*?/) {
	open (MAIL, "|$mailprogram $FORM{'email'}");
	print MAIL "TO: $FORM{'email'} ($FORM{'name'})\n";
	print MAIL "FROM: $mailto_guest_from_address ($mailto_guest_from)\n";
	print MAIL "SUBJECT: $mailto_guest_subject\n\n";
	print MAIL $mailto_guest_message."\n";
	close(MAIL);
    }
}

1
