#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use lib "$ENV{'ORACC_BUILDS'}/lib";

# Attinger table

# Create a simple table mapping Attinger values to epsd2 values,
# when they are given in the @inote Attinger line or the Attinger
# value is a super +/- one

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
my @add = `cat 00etc/add-attinger.tab`;
print C @add;
close(C);

1;
