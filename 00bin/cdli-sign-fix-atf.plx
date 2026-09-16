#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my $legacy = 0;

GetOptions(
    l=>\$legacy
    );

while (<>) {
    chomp;
    if ($legacy) {
	s/\t/.\t/;
	if (/x$/) {
	    my($s) = (/\t(.*?)\t/);
	    s/x$/x\($s\)/;
	}
    } else {
	if (/×$/) {
	    my($s) = (/\t(.*?)\t/);
	    s/×$/ₓ\($s\)/;
	} elsif (/ₓ/) {
	    warn "ₓ in $_\n";
	}
	s/KWU₄₇₅/KWU475/;
    }
    print $_, "\n";
}

1;

################################################################################

