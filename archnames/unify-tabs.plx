#!/usr/bin/perl
use warnings; use strict;
use open 'utf8';

my %oid = ();
my %f16_to_u16 = ();
my %f23_to_u16 = ();
my %u23_to_u16 = ();

open(O, 'a16u.oid') || die;
while (<O>) {
    chomp;
    my($a,$o) = split(/\t/,$_);
    $oid{$a} = $o;
}
close(O);

open(A, 'arch-16u.lst') || die;
while (<A>) {
    chomp;
    my($f,$u) = split(/\t/,$_);
    $f16_to_u16{$f} = $u;
}
close(A);

open(A, '23-to-16.tab') || die;
while (<A>) {
    chomp;
    my($u23,$u16) = split(/\t/,$_);
    $u23_to_u16{$u23} = $u16;
}
close(A);

open(A, 'arch-23u.lst') || die;
while (<A>) {
    chomp;
    my($f,$u) = split(/\t/,$_);
    $f23_to_u16{$f} = $u23_to_u16{$u};
}
close(A);

foreach my $f (sort keys %f16_to_u16) {
    print "$f\t$oid{$f16_to_u16{$f}}\n";
}

#foreach my $f (sort keys %f23_to_u16) {
#    print "$f\t$oid{$f23_to_u16{$f}}\n";
#}

1;
