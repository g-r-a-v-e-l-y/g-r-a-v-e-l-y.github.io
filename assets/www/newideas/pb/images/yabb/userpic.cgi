#!/usr/bin/perl

print "Content-type: text/html\n\n";

print qq(
<html><head><title>Datei hochladen</title>
<body bgcolor="#FFFFFF" text="#000000" link="#FF0000" vlink="#0000FF" alink="#00FF00"></head>
<CENTER><BR>
You have now the possibility to upload an image.<br>
<FORM ENCTYPE="multipart/form-data" ACTION="upload.cgi" METHOD="POST">
<INPUT TYPE="FILE" NAME="file-to-upload-01" SIZE="35">
<P>
<INPUT TYPE="SUBMIT" VALUE="Upload"><P>
</CENTER>
</body></html>
);