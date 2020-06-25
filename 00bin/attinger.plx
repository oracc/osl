#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use lib "$ENV{'ORACC_BUILDS'}/lib";

# Common Short Forms table
#
# Create a simple table giving "short form"<tab>"long form" pairs, e.g., du₁₁ dug₄.
#
# This script deliberately treats the entire set of forms within a sign as a single
# group because the values given with a form are often only a subset of the full
# set of a sign's values and it's better to map them in this more fuzzy way.

my @o = `cat 00lib/ogsl.asl`; chomp @o;
open(C,'>00etc/attinger.tab') || die;
for (my $i = 0; $i <= $#o; ++$i) {
    $_ = $o[$i];
    if (/^\@v\s+(\S+)$/) {
	my $v = $1;
	if ($o[$i+1] =~ /ttinger ~ (\S+)/) {
	    my $e = $1;
	    print C "$v\t$e\n";
	} elsif ($v =~ /[⁻⁺]$/) {
	    my $vv = $v;
	    $vv =~ s/[⁻⁺]$//;
	    print C "$v\t$vv\n";
	}
    }
}
close(C);

1;
