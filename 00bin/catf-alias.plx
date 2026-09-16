#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %fixed_aliases = (
    'saga' => "saga sig₅ sag₁₀ saga₁₀",
    );

my @tsv = `cat cdli-sign-osl-in.tsv`; chomp @tsv;
my @c = ();
my %c = ();
my @sign_only = ();
foreach (@tsv) {
    my @f = split(/\t/, $_);
    next if $f[0] eq '2000';
    if ($f[6]) {
	my $c = $f[6];
	$c{$c} = [ @f ];
    } else {
	push @sign_only, [ @f ];
    }
}
my %seen = ();

my @a = `cat 00etc/alias-flat.txt`; chomp @a;
foreach my $fa (values %fixed_aliases) {
    push @a, $fa;
}
foreach (@a) {
    my @x = split(/\s/, $_);
    my @n = ();
    my @mapped = ();
    foreach my $x (@x) {
	if (exists $c{$x}) {
	    unshift @n, $x;
	    push @mapped, $x;
	    ++$seen{$x};
	} else {
	    push @n, $x;
	}
    }
    if ($#mapped < 0) {
	warn "no CDLI values in @n\n";
    } elsif ($#mapped > 0) {
	warn "CDLI values @mapped all occur in @n\n";
	foreach my $m (@mapped) {
	    $seen{$m} = 0;
	}
    } else {
	push @{$c{$mapped[0]}}, "@n";
    }
}

foreach my $c (sort { ${$c{$a}}[0] <=> ${$c{$b}}[0]} keys %c) {
    my @f = @{$c{$c}};
    push @f, '_' if $#f < 7;
    print join("\t", @f), "\n";
}

#foreach my $c (keys %c) {
#    warn "self\t$c\n" unless $seen{$c};
#}

#foreach my $f (keys %fixed_aliases) {
#    print "$f @{$fixed_aliases{$f}}\n";
#}



1;

################################################################################

