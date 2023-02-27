#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

use Data::Dumper;

my %needx = ();
while (<>) {
    chomp;
    my($q,$v) = split(/\t/,$_);
    @{$needx{$q}} = split(/\s+/, $v);
}

# print Dumper \%needx; exit 1;

my @x = ();

open(S,'00lib/ogsl.asl');
while (<S>) {
    if (/\@sign\s+(\S+)/) {
	addx($1);
    } elsif (/\@form\s+\S+\s+(\S+)/) {
	dumpx();
	addx($1);
    } elsif (/\@end/) {
	dumpx();
    } elsif (/^\@v/) {
	dumpx();
    }
    print;
}
close(S);
foreach my $n (keys %needx) {
    print "\n\@sign\t$n\n\@inote addx\n";
    foreach my $v (@{$needx{$n}}) {
	print "\@v\t$v\n";
    }
    print "\@end sign\n";
}

sub addx  { if ($needx{$_[0]}) { @x = @{$needx{$_[0]}}; delete $needx{$_[0]} } }
sub dumpx { if ($#x >= 0) { foreach my $x (@x) { print "\@v\t$x\n"; } } @x = (); }

1;
