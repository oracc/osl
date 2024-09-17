#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %m = (); my @m = `cat pc-sl.map`; chomp @m;
foreach (@m) { my($pc,$ed) = split(/\t/,$_); $m{$pc} = $ed; }
#print Dumper \%m;
while (<>) {
    chomp;
    my $ed = '';
    my($sl,$usn,$slsn,$uhex,$uname) = split(/\t/, $_);
    if ($usn =~ /^(.*?)\((N.*?)\)$/) {
	my($rep,$us) = ($1,$2);
#	warn "$usn=>$rep $us\n";
	if ($m{$us}) {
	    $ed = "$rep\($m{$us}\)";
#	    warn "$usn -> $ed\n";
	}
    }
    print "$sl\t$usn\t$ed\t$slsn\t$uhex\t$uname\n";
}

1;
