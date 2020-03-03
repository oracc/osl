#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

my %lnum = ();
my %pua = (); load_pua();
my %seen = ();
my @sl = `grep -v '^\@ucode\\sxe' 00lib/ogsl.asl`;

open(SL,'>new.sl') || die "$0: can't write new.sl\n"; select SL;
foreach (@sl) {
    if (/^\@sign\s+(\S+)/ || /^\@form\s+\S+\s+(\S+)/) {
	my $nam = $1;
	print;
	if ($pua{$nam}) {
	    print "\@ucode\t$pua{$nam}\n";
	    ++$seen{$nam};
	}
    } else {
	print;
    }
}
close(SL);

foreach my $p (sort keys %pua) {
    warn "00lib/unicode-pua.tab:$lnum{$p}: entry $p doesn't occur in 00lib/ogsl.asl\n"
	unless $seen{$p};
}

##################################################################

sub load_pua {
    my $lnum = 0;
    open(P,'00lib/unicode-pua.tab') || die "$0: No 00lib/unicode-pua.tab\n";
    while (<P>) {
	chomp;
	++$lnum;
	my($pua,$nam) = split(/\t/,$_);
	$pua{$nam} = $pua;
	$lnum{$nam} = $lnum;
    }
    close(P);
}

1;
