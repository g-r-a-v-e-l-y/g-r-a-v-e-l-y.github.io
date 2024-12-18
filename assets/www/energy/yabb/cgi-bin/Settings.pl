###############################################################################
# Settings.pl                                                                 #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Zef Hemel                                    #
###############################################################################

######## Board info #############
$maintenance = 0;                          # Set to 1 to enable Maintenance mode
require "english.lng";                     # Change to language pack you want
$mbname = "internal energy messageboard";                  # The name of your
$boardurl = "http://65.8.36.37:81/energy/yabb/cgi-bin"; # URL of your board (without trailing '/')
$cookieusername = "yusername";             # Name of the username cookie
$cookiepassword = "ypassword";             # Name of the password cookie
$maxdisplay = 10;                          # Maximum of threads to display
$maxmessagedisplay = 10;                   # Maximum of messages to display
$insert_original = 0;                      # Set to 1 if you want the original message included when replying...
$enable_ubbc = 1;                          # Set to 1 if you want to enable UBBC (Uniform Bulletin Board Code)
$max_log_days_old = 21;                    # If an entry in the user's log is older than ... days remove it
                                           # Set to 0 if you want it disabled
$enable_news = 1;                          # Set to 1 to turn news on, or 0 to set news off
$enable_guestposting = 1;                  # Set to 0 if do not allow 1 is allow.
$enable_notification = 0;                  # Allow e-mail notification
$mailprog = "/usr/sbin/sendmail";          # Location of your sendmail program
$webmaster_email = "lstave1\@umbc.edu";      # Your e-mail address
$helpfile = "http://65.8.36.37:81/energy/help.html"; # Location of your help file

######## Directories ############
$boarddir = 'D:\\pub\\energy\\yabb\\cgi-bin'; # . = Current directory, can be replace by absolute path (/home/user/YaBB)
$datadir = "$boarddir/Messages";         # The directory where all the messages are stored
$memberdir = "$boarddir/Members";        # Directory that contains the member files
$boardsdir = "$boarddir/Boards";         # Direcotry with board data files
$sourcedir = "$boarddir/Sources";        # Directory with YaBB source files
$vardir = "$boarddir/Variables";         # Directory with variable files

$imagesdir = "../../images/yabb";
# Path to your images directory (can also be relative)

######## Colors #################
$color{'titlebg'}    = "\#00c202";    # Background color of the 'title-bar'
$color{'titletext'}  = "\#ffffff";    # Color of text in the 'title-bar'
$color{'windowbg'}   = "\#ffffff";    # Background color for messages/forms
$color{'windowbg2'}  = "\#ffffff";    # Background color for messages/forms etc.
$color{'catbg'}      = "\#e6e6e6";    # Background color for category (at Board Index)

######## Other settings #########
$LOCK_EX = 2;                         # You can probably keep this as they are set now
$LOCK_UN = 8;                         # You can probably keep this as they are set now
$use_flock = 1;                       # Set to 0 if your server doesn't support file locking

1;
