#!/store/bin/perl
# @(#)RELEASE VERSION 'limit.cgi v1.00' 21-Nov-98 Delete old gb entries
#######################################################################
#                                                                     #
#                   To be used on the datafiles of                    #
#                                                                     #
#                  Lars Ellingsen's Guestbook System                  #
#                 www.stud.ntnu.no/~larsell/guestbook                 #
#                                                                     #
#                            written by                               #
#                                                                     #
#                          Lars Ellingsen                             #
#                     www.stud.ntnu.no/~larsell                       #
#                         Copyright © 1998                            #
#                                                                     #
#######################################################################
#                                                                     #
# DESCRIPTION:                                                        #
# ~~~~~~~~~~~~                                                        #
# This program deletes the oldest entries in the specified data-file  #
# so that the data-file contains the x most recent entries only.      #
#                                                                     #
# USAGE:                                                              #
# ~~~~~~                                                              #
# This script is to be run from shell prompt, not from web!           #
#                                                                     #
# Just enter the name of the datafile you want limited into the       #
# variable "$datafile" below, and specify the maximum number of       #
# entries that is to be left by the program in the variable "$limit". #
#                                                                     #
# WARNING:                                                            #
# ~~~~~~~~                                                            #
# There is no undo-function on this one, so be careful!               #
# The data that is removed is lost forever.                           #
#                                                                     #
# DISCLAIMER:                                                         #
# ~~~~~~~~~~~                                                         #
# There is no warranty on this software, us it "as is".               #
#                                                                     #
#######################################################################

# The name of the datafile to be limited:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

   $datafile  = "guestbook.data";


# The maximum number of entries to be left in the datafile:
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


   $limit = 2000;


#######################################################################
# The program:
#######################################################################

print "\nLimit Guestbook Datafile v1.00 1998-11-21\n";
print "-----------------------------------------\n\n";

if (open(DATAFILE,"<$datafile")) {
    undef $/;
    $data = <DATAFILE>;
    close(DATAFILE);

    @entryarray = split (/<STARTSIG>/, $data);
    shift (@entryarray);

    if ($data !~ /<STARTSIG>/) {
	die " \"".$datafile."\" is no guestbook data-file!\n\n-------------------------------------------\n\n";
    }

    if ($limit =~ /^\d*$/) {
	$max_save = $limit;
        @temparray = @entryarray;
        undef @entryarray;
        $length = @temparray - 1;

	print " Number of entries in datafile = ".($length+1)."\n";
	print " Number of entries wanted      = ".($limit)."\n";

	die "\n Nothing to delete...\n\n-----------------------------------------\n\n" if $length < $limit;

        while ($limit > 0) {
	    @entryarray[$limit--] = @temparray[$length--];
	}

	foreach $entry (@entryarray) {
	    $entry = "<STARTSIG>".$entry;
	}
	shift (@entryarray);

	if (open(DATAFILE,">$datafile")) {
	    print DATAFILE @entryarray;
	    close(DATAFILE);
	} else {
	    die "\n Couldn't write to the datafile!\n\n-------------------------------------------\n\n";
	}

	print " Number of entries deleted     = ".(@temparray - $max_save)."\n";
	print "\n Remaining entries in datafile = $max_save\n";
	print "\n-------------------------------------------\n\n";
	print " Operation successful.\n\n-------------------------------------------\n\n";
    } else {
	print " Limit not specified correctly.\n";
	print " Nothing deleted...\n\n";
	print "-------------------------------------------\n\n";
    }
} else {
    die " Couldn't read from the datafile!\n\n-------------------------------------------\n\n";
}

exit 1;
