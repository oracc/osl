#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my @eq = '';
my $invalues = 0;
my $sn = '';
my $snline = 0;

open(SL, '>atfu.tab') || die;
while (<>) {
    next if /^\s*$/;
    if (/^(?:GN|Professions|PN|Realia|Text|Traces)/) {
	$invalues = 0;
    } elsif (/^[A-ZŠḪĜ]/) {
	if (/^[A-Z][a-zšḫĝʾ]/) {
	    # sign value like Larsa
	} elsif (/^(\S+)\s*$/) {
	    my $newsn = $1;
	    next if $invalues;
	    # sign name
	    if ($sn) {
		if ($#eq >= 0) {
		    foreach my $eq (@eq) {
			print SL "$sn\t$eq\n";
		    }
		    @eq = ();
		} else {
		    print "atfu.dump:$snline: no = after sign $sn discovered at $newsn\n";
		}
	    }
	    $sn = $newsn;
	    $snline = $.;
	    $invalues = 0;
	} else {
	    print "atfu.dump:$.: multiword  upper: $_";
	}
    } elsif (/^=/) {
	if (/^=\s+(S\.\s+(\S+)\??)(?:\s+|$)/) {
	    my $bau = $1;
	    push @eq, $1;
	} elsif (/^=\s+(?:ZATU|LAK)\d+\s*$/) {
	    chomp;
	    push @eq, $_;
	} elsif (/^=$/) {
	    chomp;
	    push @eq, $_;
	} else {
	    print "atfu.dump:$.: $_";
	}
	$invalues = 1;
    } elsif (/^[a-zšḫĝʾ]/) {
	$invalues = 0 if /\s(?:GN|Professions|PN|Realia|Text|Traces)/;
    } elsif (/^#/) {
    } else {
	print "atfu.dump:$.: $_";
    }
}
close(SL);

1;
