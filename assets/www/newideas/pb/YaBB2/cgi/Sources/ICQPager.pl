###############################################################################
# ICQPager.pl                                                                 #
###############################################################################
# YaBB: Yet another Bulletin Board                                            #
# Open-Source Project started by Zef Hemel (zef@zefnet.com)                   #
# Software Version: YaBB 1 Gold Beta4                                         #
# =========================================================================== #
# Software Distributed by:    www.yabb.org                                    #
# Support, News, Updates at:  www.yabb.org/cgi-bin/support/YaBB.pl            #
# =========================================================================== #
# Copyright (c) 2000-2001 YaBB - All Rights Reserved                          #
# Software by: The YaBB Development Team                                      #
###############################################################################

$icqpagerplver="1 Gold Beta4";

sub IcqPager
{
	print "Content-type: text/html\n\n";
	print <<"EOT";

    <html><head><title>$mbname - $txt{'513'} $txt{'514'}</title></head>
    <body topmargin=10 leftmargin=0>
    <table width=95% cellpadding=0 cellspacing=1 border=0 align=center bgcolor="$color{'bordercolor'}">
    <tr>
	<td>
	<form action="http://wwp.mirabilis.com/scripts/WWPMsg.dll" method="post">
	<input type="hidden" name="subject" value="$mbname"><input type="hidden" name="to" value="$INFO{'UIN'}">
	<table width=100% cellpadding=5 cellspacing=1 border=0>
	    <tr>
	        <td  class="title1" bgcolor="$color{'titlebg'}" align=center valign=middle colspan=2>
	            <font color="$color{'titletext'}" size=2><b>$mbname - $txt{'513'} $txt{'514'}</b></font>
	            </td>
	        </tr>
	        <tr>
	            <td bgcolor="$color{'windowbg2'}" align=left valign=top>
	            <font size=2>$txt{'335'}</font>
	        </td>
	            <td bgcolor="$color{'windowbg2'}" align=left valign=middle>
	            <input type="text" name="from" size="20" maxlength="40">
	        </td>
	        </tr>
	        <tr>
	            <td bgcolor="$color{'windowbg'}" align=left valign=top>
	            <font size=2>$txt{'336'}</font>
	        </td>
	            <td bgcolor="$color{'windowbg'}" align=left valign=middle>
	            <input type="text" name="fromemail" size="20" maxlength="40">
	        </td>
	        </tr>
	        <tr>
	            <td bgcolor="$color{'windowbg'}" align=left valign=top>
	            <font size=2>$IP_yourmess</font>
	        </td>
	            <td bgcolor="$color{'windowbg'}" align=left valign=middle>
	            <textarea name="body" rows="3" cols="30" wrap="Virtual"></textarea>
	        </td>
	        </tr>
	        <tr>
	        <td bgcolor="$color{'windowbg2'}" align=center valign=middle colspan=2>
	        <input type="submit" name="Send" value="$txt{'339'}"></form>
	        </td>
	        </tr>
	    </table>
	</td></tr>
    </table>
    </body>
    </html>
EOT
exit;
}

1;