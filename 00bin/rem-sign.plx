#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %rem = (); my @rem = (<>); chomp @rem; @rem{@rem} = ();
my $sign = 0;

open(S,'00lib/osl.asl') || die;
while (<S>) {
    if (/^\@sign\s+(\S+)\s*$/) {
	++$sign;
	my $s = $1;
	if (exists $rem{$s}) {
	    while (<S>) {
		last if /^\@end\s+sign/;
	    }
	} else {
	    print "\n";
	    print;
	}
    } else {
	print unless $sign && /^\s*$/;
    }
}
close(S);

1;
