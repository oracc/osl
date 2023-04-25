#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8;
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use Data::Dumper;
use lib "$ENV{'ORACC'}/lib";
use ORACC::ATF::Unicode;
use Getopt::Long;
GetOptions(
    );

my %a16 = ();
my %a23 = ();
my %m16v23 = ();

open(A, 'arch-16u.lst') || die;
while (<A>) {
    chomp;
    my($f,$a) = split(/\t/, $_);
    $a16{$a} = $f;
}
close(A);

open(A, 'arch-23u.lst') || die;
while (<A>) {
    chomp;
    my($f,$a) = split(/\t/, $_);
    $a23{$a} = $f;
}
close(A);

foreach my $k23 (keys %a23) {
    if ($a16{$k23}) {
	$m16v23{$k23} = $k23;
    } else {
	my $kp23 = "|$k23|";
	if ($a16{$kp23}) {
	    $m16v23{$k23} = $kp23;
	} else {
	    warn "arch-2023 $k23 not in arch-2016\n";
	}
    }
}

print "arch-23u\tarch-16u\n";
foreach my $k23 (sort keys %m16v23) {
    print "$k23\t$m16v23{$k23}\n";
}

1;

