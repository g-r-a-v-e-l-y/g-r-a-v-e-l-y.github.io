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
   <p>$txt{'156'}</p>
  </td>
 </tr>
 <tr>
  <td class="form1" bgcolor="$color{'windowbg'}">
   <p>
    <br>
    $txt{'157'}
    <br>&nbsp;
   </p>
  </td>
 </tr>
</table>
<table border=0 width=100% cellspacing=1 bgcolor="$color{'bordercolor'}">
 <tr>
  <td bgcolor="$color{'titlebg'}"><p> $txt{'114'}</p></td>
 </tr>
 <tr>
  <td bgcolor="$color{'windowbg'}"><p><form action="$cgi\&action=login2" method="POST">
   <table border=0>
    <tr>
     <td><p>$txt{'35'}:</p></td>
     <td><input type=text name="username" size=20></p></td>
     <td><p>$txt{'497'}:</p></td>
     <td><input type=text name="cookielength" size=4 maxlength="4" value="$Cookie_Length"></td>
     <td><p>$txt{'36'}:</p></td>
     <td><input type=password name="passwrd" size=20></td>
     <td align=center><input type=submit value="$txt{'34'}"></td>
    </tr>
   </table></form></p>
  </td>
 </tr>
</table>
EOT

    &footer;
    exit;
}

1;