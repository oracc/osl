#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @c = `cut -f2,3 00etc/cdli_sign_readings.tsv`; chomp @c;
my @u = `00bin/cdli-sign-uni.sh`; chomp @u;
foreach (@u) {
    s/×$/ₓ/;
    s/KWU₄₇₅/KWU475/;
}
print \@u; exit 1;

foreach (@c) {
    my($n,$v) = split(/\t/,$_);
    my $un = uni($n);
    my $uv = uni($v);
    print "$n\t$un\t$v\t$uv\n";
}

1;

################################################################################

