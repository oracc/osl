#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my $curr = '';
my $ignoring = 0;
my %ucun = ();

my @osl = `cat 00lib/osl.asl`; chomp @osl;
for (my $i = 0; $i < $#osl; ++$i) {
    if ($osl[$i] =~ /^\@(?:sign|form)\s+(\S+)\s*$/) {
	$curr = $1;
    } elsif ($osl[$i] =~ /^\@ucun/) {
	++$ucun{$curr};
    }
}

for (my $i = 0; $i < $#osl; ++$i) {
    if ($osl[$i] =~ /^\@sign\s(\S+)\s*$/) {
	$curr = $1;
	$ignoring = 0;
    } elsif ($osl[$i] =~ /^\@form\s(\S+)\s*$/) {
	$curr = $1;
	if ($ignoring == 2) {
	    $ignoring = 0;
	}
    } elsif ($osl[$i] =~ /^\@v\s+(\S+)\s*$/) {
	my $v = $1;
	unless ($ignoring) {
	    if ($v =~ /\(/) {
		warn "$i: $curr: $v\n"
		    unless $ucun{$curr};
	    }
	}
    } elsif ($osl[$i] =~ /^\@sign-/) {
	$ignoring = 1;
    } elsif ($osl[$i] =~ /^\@form-/) {
	$ignoring = 2;
    }
}

1;
