# ICQ-Pager by Taren

sub IcqPager
{

	$font = "Arial";
	$IP_fontcolor = "#000000";
	$IP_titletext = "#ffffff";
	$IP_titlecolor = "#000066";
	$IP_backone = "#dddddd";
	$IP_backtwo = "#eeeeee";
	$IP_yourname = "Please enter your name";
	$IP_yourmail = "Please enter your email-adress";
	$IP_yourmess = "Your message";
	$IP_sendmess = "Send message";
	
	print "Content-type: text/html\n\n";
	
    print <<"EOT";
    
    <html><head><title>ICQ Pager von $mbname</title></head>
    <body topmargin=10 leftmargin=0>
    <table width=95% cellpadding=0 cellspacing=1 border=0 align=center bgcolor=$tablebordercolor>
    <tr>
        <td>
        <form action="http://wwp.mirabilis.com/scripts/WWPMsg.dll" method="post">
        <input type="hidden" name="subject" value="Von $mbname"><input type="hidden" name="to" value="$INFO{'UIN'}">
        <table width=100% cellpadding=5 cellspacing=1 border=0>
            <tr>
                <td bgcolor="$IP_titlecolor" align=center valign=middle colspan=2>
                    <font face=$font color="$IP_titletext" size=2><b>$mbname - ICQ Pager</b></font>
                    </td>
                </tr>
                <tr>
                    <td bgcolor="$IP_backtwo" align=left valign=top>
                    <font face=$font color="$IP_fontcolor" size=2>$IP_yourname</font>
                </td>
                    <td bgcolor="$IP_backtwo" align=left valign=middle>
                    <input type="text" name="from" size="20" maxlength="40">
                </td>
                </tr>
                <tr>
                    <td bgcolor="$IP_backone" align=left valign=top>
                    <font face=$font color="$IP_fontcolor" size=2>$IP_yourmail</font>
                </td>
                    <td bgcolor="$IP_backone" align=left valign=middle>
                    <input type="text" name="fromemail" size="20" maxlength="40">
                </td>
                </tr>
                <tr>
                    <td bgcolor="$IP_backone" align=left valign=top>
                    <font face=$font color="$IP_fontcolor" size=2>$IP_yourmess</font>
                </td>
                    <td bgcolor="$IP_backone" align=left valign=middle>
                    <textarea name="body" rows="3" cols="30" wrap="Virtual"></textarea>
                </td>
                </tr>
                <tr>
                <td bgcolor="$IP_backtwo" align=center valign=middle colspan=2>
                <input type="submit" name="Send" value="$IP_sendmess"></form>
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