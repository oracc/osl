#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use lib "$ENV{'ORACC_BUILDS'}/lib";

# Eng table
#
# Create a simple table giving eng-less forms for values which have eng in them.
#
# E.g., ŋa₂ ga₂
#

my @o = `cat 00lib/ogsl.asl`; chomp @o;
my @v = ();
open(C,'>00etc/eng.tab') || die;
foreach (@o) {
    if (/^\@end\s+sign/) {
	compute_engs();
	@v = ();
    } elsif (/^\@v\s+(\S+)$/) {
	push @v, $1;
    }
}
close(C);

#################################################################################

sub compute_engs {
    my %nonum = ();
    foreach my $v (@v) {
	my $vn = $v; $vn =~ tr/₀-₉ₓ//d;
	$nonum{$vn} = $v unless $nonum{$vn};
    }
    foreach my $v (keys %nonum) {
	if ($v =~ /ŋ/) {
	    my $vv = $v;
	    $vv =~ s/ŋ/g/g;
	    if ($nonum{$vv}) {
		print C "$nonum{$v}\t$nonum{$vv}\n";
	    } else {
		$vv = $v;
		$vv =~ s/ŋ/m/g;
		if ($nonum{$vv}) {
		    print C "$nonum{$v}\t$nonum{$vv}\n";
		}
	    }
	}
    }
}

1;
