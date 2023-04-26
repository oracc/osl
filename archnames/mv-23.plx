#!/usr/bin/perl
use warnings; use strict;
use File::Copy;

my %oid = ();
open(O, '/home/ogsl/archnames/f23.oid') || die;
while (<O>) {
    chomp;
    my($f,$o) = split(/\t/,$_);
    $oid{$f} = $o;
}
close(O);

while (<>) {
    chomp;
    my $b = $_;
    $b =~ s/.jpg$//;
    if ($oid{$b}) {
	copy($_,"oid/$oid{$b}.jpg");
    } else {
	warn "no OID for $_\n";
    }
}

1;
