###############################################################################
# Settings.pl                                                                 #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef@zefnet.com)                   #
# Software Version: YaBB 1 Gold - Beta4                                       #
# =========================================================================== #
# Software Distributed by:    www.yabb.org                                    #
# Support, News, Updates at:  www.yabb.org/cgi/support/YaBB.pl            #
# =========================================================================== #
# Copyright (c) 2000-2001 YaBB - All Rights Reserved                          #
# Software by: The YaBB Development Team                                      #
###############################################################################


########## Board Info ##########
# Note: these settings must be properly changed for YaBB to work

$maintenance = 0;					# Set to 1 to enable Maintenance mode
$language = "english.lng";                    		# Change to language pack you want to use
$mbname = "pixeljuice bulletein board";				# The name of your YaBB forum
$boardurl = "http://65.8.36.37/YaBB/cgi";	# URL of your board's folder (without trailing '/')
$Cookie_Length = 360;					# Cookies will expire after XX minutes of person logging in (they will be logged out after)
$cookieusername = "YaBBusername";			# Name of the username cookie
$cookiepassword = "YaBBpassword";			# Name of the password cookie
$mailprog = "/usr/sbin/sendmail";			# Location of your sendmail program
$webmaster_email = "lstave1@umbc.edu";		# Your e-mail address (must contain \ before @)
$smtp_server = "";					# SMTP-Server
$mailtype = 0;						# 0 - sendmail, 1 - SMTP
$timeout = 15;						# Minimum time between 2 postings from the same IP


########## Directories/Files ##########
# Note: directories other than $imagesdir do not have to be changed unless you move things

$boarddir = "."; 						# The absolute path to the board's folder (usually can be left as '.')
$datadir = "./Messages";         				# Directory with messages
$memberdir = "./Members";        				# Directory with member files
$boardsdir = "./Boards";         				# Directory with board data files
$sourcedir = "./Sources";        				# Directory with YaBB source files
$vardir = "./Variables";         				# Directory with variable files
$facesurl = "http://65.8.36.37/YaBByabbimages/avatars";		# URL to your avatars folder
$facesdir = "C:\\web\\inetpub\\wwwroot\\YaBB\\yabbimages\\avatars";	# Absolute Path to your avatars folder
$imagesdir = "http://65.8.36.37/YaBB/yabbimages";		# URL to your images directory
$helpfile = "http://65.8.36.37/YaBB/yabbhelp/index.html";	# Location of your help file


########## Colors ##########
# Note: equivalent to colors in CSS tag of template.html, so set to same colors preferrably
# for browsers without CSS compatibility and for some items that don't use the CSS tag

$color{'titlebg'} = "#ffcc00";			# Background color of the 'title-bar'
$color{'titletext'} = "#FFFFFF";		# Color of text in the 'title-bar' (above each 'window')
$color{'windowbg'} = "#cccccc";			# Background color for messages/forms etc.
$color{'windowbg2'} = "#eeeeee";		# Background color for messages/forms etc.
$color{'catbg'} = "#5d7790";			# Background color for category (at Board Index)
$color{'bordercolor'} = "#000000";		# Table Border color for some tables

########## Style Sheet settings added by Grant ###############
# Note: because the above is a hack supporting 4.0 browsers, we are going to replace it.
# you only need to have a style name, then add it in template.html :)

adminheadertable

########## Features ##########

$MenuType = 1;				# 1 for text menu or anything else for images menu
$timeselected = 1;			# Select your preferred output Format of Time and Date
$timeoffset = 0;			# Time Offset (so if your server is EST, this would be set to -1 for CST)
$TopAmmount = 10;			# No. of top posters to display on the top members list
$MembersPerPage = 25;			# No. of members to display per page of Members List - All
$maxdisplay = 25;			# Maximum of topics to display
$maxmessagedisplay = 15;		# Maximum of messages to display
$insert_original = 0;			# Set to 1 if you want the original message included when replying...
$enable_ubbc = 1;			# Set to 1 if you want to enable UBBC (Uniform Bulletin Board Code)
$max_log_days_old = 21;			# If an entry in the user's log is older than ... days remove it
					# Set to 0 if you want it disabled
$MaxMessLen = 5000;  			# Maximum Allowed Characters in a Posts (required <= 5000)

$enable_news = 1;			# Set to 1 to turn news on, or 0 to set news off
$enable_guestposting = 1;		# Set to 0 if do not allow 1 is allow.
$enable_notification = 0;		# Allow e-mail notification
$showlatestmember = 0;			# Set to 1 to display "Welcome Newest Member" on the Board Index
$Show_RecentBar = 1;			# Set to 1 to display the Recent Posts bar on Board Index
$Show_MemberBar = 1;			# Set to 1 to display the Members List table row on Board Index
$showmodify = 1;			# Set to 1 to display "Last modified: Realname - Date" under each message
$showuserpic = 1;			# Set to 1 to display each member's picture in the message view (by the ICQ.. etc.)
$showusertext = 1;			# Set to 1 to display each member's personal text in the message view (by the ICQ.. etc.)
$showgenderimage = 1;			# Set to 1 to display each member's gender in the message view (by the ICQ.. etc.)


########## NewsFader ##########

$shownewsfader = 1;					# 1 to allow or 0 to disallow NewsFader javascript on the Board Index
							# If 0, you'll have no news at all unless you put <yabb news> tag
							# back into template.html!!!
$color{'fadertext'}  = "#d0783f";			# Color of text in the NewsFader ("The Latest News" color)
$color{'fadertext2'}  = "#000000";			# Color of text in the NewsFader (news color)
$faderpath = "http://65.8.36.37/YaBB/fader.js";		# Web path to your 'fader.js'


########## UBBC JS Path ##########

$ubbcjspath = "http://65.8.36.37/YaBB/ubbc.js";		# Web path to your 'ubbc.js' REQUIRED for post/modify to work properly!


########## MemberPic Settings ##########

$userpic_width = 65;				# Set pixel size to which the selfselected userpics are resized, 0 disables this limit
$userpic_height = 65;				# Set pixel size to which the selfselected userpics are resized, 0 disables this limit
$userpic_limits = "Please note that your image has to be gif or jpg and that it will be resized!";	# Text To Describe The Limits

########## File Locking ##########

$LOCK_EX = 2;				# You can probably keep this as they are set now
$LOCK_UN = 8;				# You can probably keep this as they are set now
$use_flock = 2;				# Set to 0 if your server doesn't support file locking, 1 for *ix Systems and 2 for Win-Servers

1;
