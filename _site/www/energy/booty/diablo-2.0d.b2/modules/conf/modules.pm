# Diablo Module Loader

sub insmod {
	$mod = $_[0];

	open(MOD,"./$mod");
	while(<MOD>) {
		chomp;
		$line = $_;
		if($line ne "" && $line !~ /^\;(.*)$/) {
			$ins = './' . $line;
	                do $ins;
		}
	}
	close(MOD);
}
