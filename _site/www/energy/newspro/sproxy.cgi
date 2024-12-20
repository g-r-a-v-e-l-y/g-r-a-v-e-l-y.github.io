#!/usr/bin/perl
# Set the above to the path to Perl as in newspro.cgi.

print "Content-type: text/html; charset=iso-8859-1\n\n<html>";

use CGI;

$cgiobject = new CGI; 

$data{"text"} = $cgiobject->param('text');
$data{"text"} =~ s/\"/&quot;/g;
$data{"text"} =~ s/\r/&#13;/g;
$data{"text"} =~ s/\n/&#10;/g;
$data{"txt_ctrl"} = $cgiobject->param('txt_ctrl');

$template = "<html>
<head>

<script>

function doload() {
	var f_src = document.forms[0];
	var f_dst = parent.opener.document.forms[0];
	var ctrl = eval(
		'parent.opener.' + 
		f_src.txt_ctrl.value);
	ctrl.value = f_src.msg_body.value;
	parent.close();
}

</script>

</head>
<body bgcolor=white onload=\"doload();\">
<center>
<form>
<input type=hidden name=msg_body value=\"<#text#>\">
<input type=hidden name=txt_ctrl value=\"<#txt_ctrl#>\">
</form>
</body></html>";

$template =~ s/<#(\w+)#>/$data{$1}/g;

print $template;


