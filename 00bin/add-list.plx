#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

GetOptions(
    );

my %l = ();
open(L, $ARGV[0]) || die;
while (<L>) {
    next if /^[=#]/ || /#/;
    chomp;
    my @f = split(/\t/, $_);
    push @{$l{$f[1]}}, "\@list\t$f[0]\n";
}
close(L);
open(P, '00lib/ogsl.asl') || die;
while (<P>) {
    chomp;
    if (/\@(?:sign|form)\s+(\S+)/) {
        my $s = $1;
        print "$_\n";
        if ($l{$s}) {
            # warn "$s => $l{$s}\n";
            my @l = @{$l{$s}};
            print @l;
        }
    } else {
        print "$_\n";
    }    
}
close(P);

1;
