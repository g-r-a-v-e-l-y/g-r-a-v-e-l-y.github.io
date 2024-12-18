
&readform;
$currentboard = "$INFO{'board'}";

sub header {
	print "Content-type: text/html\n\n";
	$text2 = "<a href=\"YaBB.pl\">home</a> <a href=\"$cgi\&action=register\">register</a> <a href=\"$helpfile\" target=_blank>help</a>";
	$text2 = "$text2 <a href=\"Search.pl\">search</a>";
	if($username ne "Guest") { $text2 = "$text2 <a href=\"$cgi\&action=profile\&username=$username\">profile</a>"; }
	if($settings[7] eq "Administrator") { $text2 = "$text2 <a href=\"$cgi\&action=admin\">admin</a>"; }
	if($username eq "Guest") { $text2 = "$text2 <a href=\"$cgi\&action=login\">login</a>";
	} else { $text2 = "$text2 <a href=\"$cgi\&action=logout\">logout</a>"; }
	
	if($enable_news) {
		open(FILE, "$vardir/news.txt");
		&lock(FILE);
		@newsmessages = <FILE>;
		&unlock(FILE);
		close(FILE);
		srand; 
		$news = "<b>$txt{'102'}\:</b><p>$newsmessages[int rand(@newsmessages)]";
	}
	open(TEMPLATE,"template.html");
	&lock(TEMPLATE);
	@template = <TEMPLATE>;
	&unlock(TEMPLATE);
	close(TEMPLATE);
	foreach $curline (@template) {
		if($curline =~ /\<yabb main\>/) { last; }
		elsif($curline =~ /\<yabb news\>/) { print "$news"; }
		elsif($curline =~ /\<yabb title\>/) { print "$title"; }
		elsif($curline =~ /\<yabb menu\>/) { print "$text2"; }
		elsif($curline =~ /\<yabb time\>/) { print "$date"; }
		elsif($curline =~ /\<yabb im\>/) {
			if($username ne "Guest") {
				open(IM, "$memberdir/$username.msg");
				&lock(IM);
				@immessages = <IM>;
				&unlock(IM);
				close(IM);
				$mnum = @immessages;
				print "$txt{'152'} <a href=\"$cgi\&action=im\">$mnum $txt{'153'}</a>";
			}
		}
		else {	print "$curline"; }
	}
}

sub footer {
	$atstart=0;
	foreach $curline (@template) {
		if($curline =~ /\<yabb main\>/) { $atstart=1; }
		if($atstart==1) {
			if($curline =~ /\<yabb news\>/) { print "$news"; }
			elsif($curline =~ /\<yabb title\>/) { print "$title"; }
			elsif($curline =~ /\<yabb menu\>/) { print "$text2"; }
			elsif($curline =~ /\<yabb time\>/) { print "$date"; }
			else {	print "$curline"; }
		}
	}
}

sub calcdifference {  # Input: $date1 $date2
	($dates, $times) = split(/ /, $date1);
	($month, $day, $year) = split(/\//, $dates);
	$number1=($year*365)+($month*30)+$day;
	($dates, $dummy) = split(/ /, $date2);
	($month, $day, $year) = split(/\//, $dates);
	$number2=($year*365)+($month*30)+$day;
	$result=$number2-$number1;
}

sub calctime {  # Input: $date1 $date2
	($dummy, $times) = split(/ $txt{'107'} /, $date1);
	($hour, $min, $sec) = split(/\//, $times);
	$number1=($hour*60)+$min;
	($dummy, $times) = split(/ $txt{'107'} /, $date2);
	($hour, $min, $sec) = split(/\//, $times);
	$number2=($hour*60)+$min;
	$result=$number2-$number1;
}

sub postform {
if($realname ne "") { $name_field = "$realname<input type=hidden name=name value=\"$realname\">"; }
else { $name_field = "<input type=text name=name size=50 value=\"$form_name\">"; }
if($realemail ne "") { $email_field = "$realemail<input type=hidden name=email value=\"$realemail\">"; }
else { $email_field = "<input type=text name=email size=50 value=\"$form_name\">"; }
print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'105'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}">
<form action="$cgi&action=post&follow=$form_followup" method=post name="creator">
<input type=hidden name=followto value=$form_followto>
<input type=hidden name=level value=$form_level>
<table border=0>
<tr>
	<td><font><b>$txt{'68'}:</b></font></td>
	<td><font>$name_field</font></td>
</tr>
<tr>
	<td><font><b>$txt{'69'}:</b></font></td>
	<td><font>$email_field</font></td>
</tr>
<tr>
	<td><font><b>$txt{'70'}:</b></font></td>
	<td><font><input type=text name="subject" value="$form_subject" size="40" maxlength="50"></font></td>
</tr>
<tr>
	<td><font><b>$txt{'71'}:</b></font></td>
	<td><script language="javascript">
function showimage()
{
//alert("$imagesdir/"+document.creator.icon.options[document.creator.icon.selectedIndex].value+".gif");
document.images.icons.src="$imagesdir/"+document.creator.icon.options[document.creator.icon.selectedIndex].value+".gif";
}
</script>
<select name="icon" onChange="showimage()">
	<option value="xx">Standard
	<option value="thumbup">Thumb Up
	<option value="thumbdown">Thumb Down
	<option value="exclamation">Exclamation point
	<option value="question">Question mark
	<option value="lamp">Lamp
	<option value="smiley">Smiley
	<option value="angry">Angry
	<option value="cheesy">Cheesy
	<option value="laugh">Laugh
	<option value="sad">Sad
	<option value="wink">Wink
        <option value="heart">Heart
	</select>
	<img src="$imagesdir/xx.gif" name="icons" width="16" height="16" border=0 hspace=15></td>
</tr>
<tr>
	<td valign=top><font><b>$txt{'72'}:</b></font></td>
	<td><font><textarea name=message rows=10 cols=50 wrap=virtual>$form_message</textarea></td>
</tr>
<tr>
	<td align=center colspan=2><input type=submit value="$txt{'105'}">
	<input type=reset value="Reset Form"></td>
</tr>
</table></form>
</td>
</tr>
</table>
EOT
}

sub fatal_error {
	local($e) = @_;
	$title = "$txt{'106'}";
	&header;
	print <<"EOT";
<table border=0 width=600 cellspacing=1 bgcolor="#ffffff">
<tr>
	<td bgcolor="$color{'titlebg'}"><font color="$color{'titletext'}"><b>$txt{'106'}</b></font></td>
</tr>
<tr>
	<td bgcolor="$color{'windowbg'}"><font>$e</font></td>
</tr>
</table>
EOT
	&footer;
	exit;

}

sub readform {

	read(STDIN, $input, $ENV{'CONTENT_LENGTH'});
	@pairs = split(/&/, $input);
	foreach $pair (@pairs) {

	        ($name, $value) = split(/=/, $pair);
	        $name =~ tr/+/ /;
	        $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $value =~ tr/+/ /;
	        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $FORM{$name} = $value;
	}

	@vars = split(/&/, $ENV{QUERY_STRING});
	foreach $var (@vars) {
	        ($v,$i) = split(/=/, $var);
	        $v =~ tr/+/ /;
	        $v =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $i =~ tr/+/ /;
	        $i =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
	        $i =~ s/<!--(.|\n)*-->//g;
	        $INFO{$v} = $i;
	}

	$action = $INFO{'action'};

}

sub get_date {

	($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

	$mon_num = $mon+1;
	$savehour = $hour;
	$hour = "0$hour" if ($hour < 10);
	$min = "0$min" if ($min < 10);
	$sec = "0$sec" if ($sec < 10);
	$saveyear = ($year % 100);
	$year = 1900 + $year;

	$mon_num = "0$mon_num" if ($mon_num < 10);
	$mday = "0$mday" if ($mday < 10);
	$saveyear = "0$saveyear" if ($saveyear < 10);
	$date = "$mon_num/$mday/$saveyear $txt{'107'} $hour\:$min\:$sec";
}

sub lock {
	local($file)=@_;
	if($use_flock) {
		flock($file, $LOCK_EX);
	}
}

sub unlock {
	local($file)=@_;
	if($use_flock) {
		flock($file, $LOCK_UN);
	}
}

sub readlog {
	local($field) = @_;
	if($username ne "Guest") {
		open(LOG, "$memberdir/$username.log");
		&lock(LOG);
		@entries = <LOG>;
		&unlock(LOG);
		close(LOG);
		foreach $curentry (@entries) {
			$curentry =~ s/\n//g;
			$curentry =~ s/\r//g;
			($name, $value) = split(/\|/, $curentry);
			if($name eq "$field") { return "$value"; }
		}
	}
}

sub writelog {
	local($field) = @_;
	if($username ne "Guest") {
		open(LOG, "$memberdir/$username.log");
		&lock(LOG);
		@entries = <LOG>;
		&unlock(LOG);
		close(LOG);
		open(LOG, ">$memberdir/$username.log");
		&lock(LOG);
		print LOG "$field\|$writedate\n";
		foreach $curentry (@entries) {
			$curentry =~ s/\n//g;
			$curentry =~ s/\r//g;
			($name, $value) = split(/\|/, $curentry);
			$date1="$value";
			$date2="$date";
			&calcdifference;
			if($name ne "$field" && $result <= $max_log_days_old) {
				print LOG "$curentry\n";
			}
		}
		&unlock(LOG);
		close(LOG);
	}
}

sub jumpto {

	$dirtoopen = "$boardsdir";
    opendir (DIRECTORY,"$dirtoopen"); 
    @dirdata = readdir(DIRECTORY);
    closedir (DIRECTORY);
    
    @datdata = grep(/dat/,@dirdata);
    $totalboards = @sorteddirdata;
    
    	foreach $category (@datdata) { # start to open files
    
    	($grabtxtfile, $trash) = split(/\./,$category);
    
    	open(FILE, "$boardsdir/$category") || next;
		&lock(FILE);
		@newcatdata = <FILE>;
		&unlock(FILE);
		close(FILE);
	
		$selecthtml .= "<option value=\"$grabtxtfile\">@newcatdata[0]\n";
	
	
	} # end the foreach line
	
}

1;
