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
my @v = ();
open(C,'>00etc/csf.tab') || die;
foreach (@o) {
    if (/^\@end\s+sign/) {
	compute_csfs();
	@v = ();
    } elsif (/^\@v\s+(\S+)$/) {
	push @v, $1;
    }
}
close(C);

#################################################################################

sub compute_csfs {
    my %nonum = ();
    foreach my $v (@v) {
	my $vn = $v; $vn =~ tr/₀-₉ₓ//d;
	$nonum{$vn} = $v unless $nonum{$vn};
    }
    foreach my $v (keys %nonum) {
	my $vs = $v; $vs =~ s/.$//;
	if ($nonum{$vs}) {
	    print C "$nonum{$vs}\t$nonum{$v}\n";
	} else {
	    $vs = $v;
	    if ($vs =~ s/^(.[aeiu]).[aeiu](.)$/$1$2/) {
		if ($nonum{$vs}) {
		    print C "$nonum{$vs}\t$nonum{$v}\n";
		}
	    }
	}
    }
}

1;
