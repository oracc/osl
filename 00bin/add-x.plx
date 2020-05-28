#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

my %needx = ();
while (<>) {
    chomp;
    my($v,$s) = split(/\s+/,$_);
    $needx{$s} = $v;
}

my $x;
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
    print "\n\@sign\t$n\n\@inote addx\n\@v\t$needx{$n}\n\@end sign\n";
}

sub addx  { if ($needx{$_[0]}) { $x = $needx{$_[0]}; delete $needx{$_[0]} } }
sub dumpx { if ($x) { print "\@v\t$x\n"; $x = undef; } }

1;
