#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %oid = ();
open(O, '/Users/stinney/orc/oid/oid.tab') || die;
while (<O>) {
    my($o,$dom,$n,@x) = split(/\t/, $_);
    $oid{$n} = $o unless $oid{$n};
}
close(O);

my $sn = '';
open(A,'00lib/osl.asl') || die;
while (<A>) {
    if (/^\@pcun\s+(\S+)\s*$/) {
	$sn = $1;
	print;
	if ($oid{$sn}) {
	    print "\@oid\t$oid{$sn}\n";
	} else {
	    warn "no oid for $sn\n";
	}
    } else {
	print;
    }
}
close(A);

1;
