#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %l = (
    "ŠL/HA"	=>'SLLHA',
    ABZ	=>'ABZ',
    ABZL	=>'ABZL',
    AKS	=>'AKS',
    ATU1	=>'ATU1',
    DP	=>'DP',
    Ebs	=>'Ebs',
    ELLES	=>'ELLES',
    FOS	=>'FOS',
    HZL	=>'HZL',
    KWU	=>'KWU',
    Labat	=>'Labat',
    LAK	=>'LAK',
    LEC	=>'LEC',
    MesZL	=>'MZL',
    OAK	=>'OAK',
    Pea	=>'Pea',
    PI	=>'PI',
    REC	=>'REC',
    RSP	=>'RSP',
    SEH	=>'SEH',
    UET2	=>'BAU',
    ZATU	=>'ZATU',    
    );

my %o = ();
my %q = ();

open(L,'lists.tsv') || die;
while (<L>) {
    my($l,$o) = split(/\t/, $_);
    $o{$l} = $o if $o;
}
close(L);

#print Dumper \%o;

my @lst = grep(!/^m-/, <*.lst>);

foreach my $l (@lst) {
    open(L, $l) || die;
    my $one = <L>;
    my ($n) = split(/\t/, $one);
    if ($l{$n}) {
	my $lname = $l{$n};
	while (<L>) {
	    my($l,$q) = split(/\t/,$_);
	    if ($l) {
		my $ol = "$lname$l";
		if ($o{$ol}) {
		    ++${$q{$q}}{$o{$ol}};
		}
	    }
	}
    } else {
	warn "list $n not in list array\n";
    }
    close(L);
}

foreach my $q (sort keys %q) {
    my @o = sort keys %{$q{$q}};
    print "$q\t@o\n";
}

1;
