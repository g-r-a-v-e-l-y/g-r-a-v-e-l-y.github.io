#!/usr/bin/perl 
# Walk the system and enumerate AntiVirus exclusions
# Grant Stavely
# 5/2009
#
#use strict;
#use warnings;
#use diagnostics;
use Getopt::Long;
use File::Copy;
use File::Basename;
use File::Path;
use File::Spec::Win32;
use File::Temp qw(tempdir);
use POSIX qw(strftime);
use Win32::File;
use LWP::Simple;
Getopt::Long::Configure("bundling");

my $VERSION     = "spray-eicar.pl v.1";
my $PID = $$;

# Define the eicar string
my $EICAR = 'X5O!P%@AP[4\PZX54(P^)7CC)7}$EICAR-STANDARD-ANTIVIRUS-TEST-FILE!$H+H*';

my %config = (
  verbose   => 0,
  calc_hash => 0,
  file      => 'eicar.exe',
  path      => "C:\\",
);

sub parse_cmdline($);
sub debug();
sub debug_print($);
sub verbose($);
sub walk_drive($);
sub drop_eicar($);
sub test_eicar($);
sub eicar_walker();
sub bail($);
sub store_findings();
my @findings;

### MAIN ###
parse_cmdline(\%config);

# no buffering
select(STDERR);
$| = 1;
select(STDOUT);
$| = 1;

sub parse_cmdline($) {
  my $cfg_ref = shift;

  my $cmdline_ok = GetOptions(
    'v|verbose'  => \$$cfg_ref{verbose},
    'd|debug'    => \$$cfg_ref{debug},
    'V|Version'  => \$$cfg_ref{Version},
    'p|path:s'   => \$$cfg_ref{path},
    'h|help'     => \$$cfg_ref{help},
    'f|file:s'   => \$$cfg_ref{file},
  );
}

help()
  if ($config{help});
debug()
  if ($config{debug});
eicar_walker()
  if ($config{path});

sub debug() {
  print "Debug Options:\n";
  while(my ($k, $v) = each %config ) {
    print "\t$k: $v\n" if ($v);
  }
  print "\n";
}

sub debug_print($) {
  my $message= shift; 
  print "\nDebug: $message\n" if $config{debug};
}

sub verbose($) {
  my $message = shift;
  print "$message" if $config{verbose};
}

sub walk_drive($) {
  my $path_to_walk = File::Spec::Win32->canonpath(shift);
  my @directories;
  debug_print("Walking $path_to_walk");
  opendir(PATH, $path_to_walk) || bail("Oops, can't open $path_to_walk");
  my @listings = readdir(PATH);
  @listings = File::Spec->no_upwards(@listings);
  closedir PATH;
  foreach (@listings) {
    my $finding = File::Spec::Win32->canonpath("$path_to_walk\\$_");
    debug_print("Examining $finding ");
    if (-d $finding && grep(!/^\./, $finding)) {
      push(@directories, $finding);
      debug_print("$finding looks like a directory");
      drop_eicar($finding);
      test_eicar($finding);
      walk_drive($finding);
    }
  }
  return @directories;
}

sub drop_eicar($) {
  my $directory = shift;
  my $output_file = File::Spec::Win32->catfile($directory, $config{file});
  debug_print("Dropping eicar into $output_file");
  open (EICAR, ">$output_file") or verbose("Error opening test file in $directory\n");
  print EICAR "$EICAR" || bail("Yikes, I can't write eicar to $output_file");
  close (EICAR);
}

sub test_eicar($) {
  my $directory = shift;
  my $test_file = File::Spec::Win32->catfile($directory, $config{file});
  debug_print("Testing for eicar in $test_file");
  if (-f $test_file) {
    debug_print("$test_file is still here!\n");
    print "$directory\n";
    unlink($test_file);
  }
  else {
    debug_print("$test_file is gone!");
  }
}

sub eicar_walker() {
  my @directories = walk_drive($config{path});
  foreach (@directories) {
    drop_eicar($_);
    test_eicar($_);
  }
}

sub bail($){
  my $error_message = shift;
  if (!defined($error_message) || $error_message eq "") {
   exit(0);
  }
  else {
    die("\nExiting: $error_message\n");
  }
}

sub help() {
  print <<'HELP';
Usage: spray-eicar.pl [-vd] [-p path] [-f file]
Enumerate directory level antivirus exclusions.

  -d, --debug		Print details about every action taken
  -v, --verbose		Print more information about errors
  -p, --path 'PATH'	Follow subdirectories of PATH, default is C:\		
  -f, --file 'FILE'     Use FILE as name of EICAR test file
  -V, --version		Print eicar-spray.pl version information
HELP
  exit;
}
