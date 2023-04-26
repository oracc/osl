#!/usr/bin/perl
use warnings; use strict;
use open 'utf8'; binmode STDOUT, ':utf8';

my %f2o = ();
my %f2u = ();

open(O, '/home/ogsl/archnames/f23.oid') || die;
while (<O>) {
    chomp;
    my($f,$o) = split(/\t/,$_);
    $f2o{$f} = $o;
}
close(O);

open(A, '/home/ogsl/archnames/arch-23u.lst') || die;
while (<A>) {
    chomp;
    my($f,$u) = split(/\t/,$_);
    $f2u{$f} = $u;
}
close(A);

print "OID\tFILENAME\tUNICODE\n";
foreach my $f (sort keys %f2o) {
    my $o = $f2o{$f};
    print "$o.jpg\t$f\t$f2u{$f}\n";
}

1;
