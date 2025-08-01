#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

#
# 00bin/add-list.plx [LIST_TABLE]
# 
# Add list via table with
#
# LIST\tNAME
#
# If list is bare numbers use -p -lLISTNAME, e.g., -p -lASY
#

my $asl = '00lib/osl.asl';
my $lprefix = '';
my $pad = 0;
GetOptions(
    "asl:s"=>\$asl,
    "list:s"=>\$lprefix,
    pad=>\$pad,
    );

my @input = ();
my %seen = ();

my %l = ();
open(L, $ARGV[0]) || die;
while (<L>) {
    next if /^[=#]/ || /#/;
    chomp;
    my @f = split(/\t/, $_);
    if ($f[1]) {
	my $ll = $f[0];
	if ($pad) {
	    my $ln = $ll;
	    $ln =~ s/^(\d+).*$/$1/;
	    if (length($ln) == 1) {
		$ll = "00$ll";
	    } elsif (length($ln) == 2) {
		$ll = "0$ll";
	    }
	}
	if ($lprefix) {
	    $ll = "$lprefix$ll";
	}
	push @input, $f[1];
	push @{$l{$f[1]}}, "\@list\t$ll\n";
    } else {
	warn "$f[0] has no data\n";
    }
}
close(L);

open(P, $asl) || die;
while (<P>) {
    chomp;
    if (/\@(?:sign|form|aka)\s+(\S+)/) {
        my $s = $1;
        print "$_\n";
        if ($l{$s}) {
            # warn "$s => $l{$s}\n";
            my @l = @{$l{$s}};
            print @l;
	    ++$seen{$s};
        }
    } else {
        print "$_\n";
    }    
}
close(P);

foreach my $n (@input) {
    warn "add-list: $n not added to list\n"
	unless $seen{$n};
}

1;
