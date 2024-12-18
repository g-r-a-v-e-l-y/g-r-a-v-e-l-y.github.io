###############################################################################
# Maintenance.pl                                                              #
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

$maintenanceplver="1 Gold Beta4";

sub InMaintenance 
{
    $yytitle = "$txt{'155'}";
    &header;
    print <<"EOT";

<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
 <tr>
  <td class="title1" bgcolor="$color{'titlebg'}">
   <font size=2 class="text1" color="$color{'titletext'}">$txt{'156'}</font>
  </td>
 </tr>
 <tr>
  <td class="form1" bgcolor="$color{'windowbg'}">
   <font size=2>
    <br>
    $txt{'157'}
    <br>&nbsp;
   </font>
  </td>
 </tr>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
 <tr>
  <td bgcolor="$color{'titlebg'}"><font size=2 color="$color{'titletext'}"> $txt{'114'}</font></td>
 </tr>
 <tr>
  <td bgcolor="$color{'windowbg'}"><font size=2><form action="$cgi\&action=login2" method="POST">
   <table border=0>
    <tr>
     <td><font size=2>$txt{'35'}:</font></td>
     <td><input type=text name="username" size=20></font></td>
     <td><font size=2>$txt{'497'}:</font></td>
     <td><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"></td>
     <td><font size=2>$txt{'36'}:</font></td>
     <td><input type=password name="passwrd" size=20></td>
     <td align=center><input type=submit value="$txt{'34'}"></td>
    </tr>
   </table></form></font>
  </td>
 </tr>
</table>
EOT

    &footer;
    exit;
}

1;