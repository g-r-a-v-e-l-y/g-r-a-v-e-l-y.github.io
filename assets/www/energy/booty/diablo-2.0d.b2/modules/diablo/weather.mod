sub weather {
	$unick = $_[0];
	$zip = $_[1];
	
	# get html file
	$url = "http\:\/\/www\.weather\.com\/weather\/us\/zips\/$zip\.html";
	if(!fork()) {
		$wpid=$$;
		open(WGET,"wget $url |");
		close(WGET);
		system("mv $zip\.html tmp");
		
		# read html file
		open(WEATHER,"./tmp/$zip\.html");
		$tempvar=1;
		while(!eof(WEATHER)) {
			$line = <WEATHER>;
			if($line =~ /<TITLE>The Weather Channel - (.*), (.*) \((.*)\)<\/TITLE>/) {
				$city = $1;
				$state = $2;
				$zip = $3;
			}
			if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*)\&deg\;F<\/FONT><\/TD>/) {
			$read = $1;
				if($tempvar eq 1) {
					$temp = $read;
				}
				if($tempvar eq 2) {
					$windchill = $read;
				}
				if($tempvar eq 3) {
					$dewpoint = $read;
				}
				$tempvar++;
			}
			if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*) mph (.*)<\/FONT><\/TD>/) {
				$windspeed = $1;
				$winddir = $2;
				$wind = $windspeed . " mph " . $winddir;
			}
			if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*)\%<\/FONT><\/TD>/) {
				$read = $1;
				$humidity = $read;
			}
			if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*) inches<\/FONT><\/TD>/) {
				$barometer = $1;
			}
			if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*) am<\/FONT><\/TD>/) {
				$sunrise = $1;
			}
	                if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*) pm<\/FONT><\/TD>/) {
				$sunset = $1;
			}
			if($line =~ /<TD WIDTH=90><FONT FACE=\"Arial, Helvetica, Chicago, Sans Serif\" SIZE=2>(.*) miles<\/FONT><\/TD>/) {
				$visibility = $1;
			}
		}
		close(WEATHER);
		sockwrite($sock,"NOTICE $unick :Current weather: $city, $state");
		sockwrite($sock,"NOTICE $unick :temp - $temp\2o\2\, windchill - $windchill\2o\2");
	        sockwrite($sock,"NOTICE $unick :wind - $wind\, humidity - $humidity\%");
	        sockwrite($sock,"NOTICE $unick :dewpoint - $dewpoint\2o\2\, barometer - $barometer inches");
	        sockwrite($sock,"NOTICE $unick :sunrise - $sunrise am\, sunset - $sunset pm");
	        sockwrite($sock,"NOTICE $unick :visibilty - $visibility miles");
		system("rm -f tmp/$zip\.html");
		exit(0);
	}
}

