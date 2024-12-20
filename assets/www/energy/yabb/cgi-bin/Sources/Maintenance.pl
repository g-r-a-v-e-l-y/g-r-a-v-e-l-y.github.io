###############################################################################
# Maintenance.pl                                                              #
###############################################################################
# Yet another Bulletin Board (http://www.yabb.com.ru)                         #
# Open Source project started by Zef Hemel (zef@zefnet.com)                   #
# =========================================================================== #
# Copyright (c) The YaBB Programming team                                     #
# =========================================================================== #
# This file has been written by: Christian Land                               #
###############################################################################

sub InMaintenance 
{
    $title = "$txt{'155'}";
    &header;
    print <<"EOT";

<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
 <tr>
  <td bgcolor="$color{'titlebg'}">
   <font color="$color{'titletext'}"><b>$txt{'156'}</b></font>
  </td>
 </tr>
 <tr>
  <td bgcolor="$color{'windowbg'}">
   
    <br>
    $txt{'157'}
    <br>&nbsp;
     </td>
 </tr>
</table>
EOT

    &footer;
    exit;
}

1;