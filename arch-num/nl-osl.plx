#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %osl = ();
my %pcsl = ();

my @osl = `cat osl.sign`; chomp @osl; @osl{@osl} = ();
my @pcsl = `cat pcsl.sign`; chomp @pcsl; @pcsl{@pcsl} = ();

my %n = (
    ONE=>'1',
    TWO=>'2',
    THREE=>'3',
    FOUR=>'4',
    FIVE=>'5',
    SIX=>'6',
    SEVEN=>'7',
    EIGHT=>'8',
    NINE=>'9',
    );

#
# read NamesList.txt and generate OSL/PCSL sign names
#
# look up sign names in osl/pcsl
#
open(N,'NamesList.txt') || die;
while (<N>) {
    next unless /^12/;
    chomp;
    my $orig = $_;
    $orig =~ s/\s+/\t/;
    my($uname) = (/\s(.*?)\s*$/);
    $uname =~ s/^CUNEIFORM NUMERIC SIGN\s+//;
    if ($uname =~ s/^(ONE|TWO|THREE|FOUR|FIVE|SIX|SEVEN|EIGHT|NINE)\s+//) {
	my $n = $1;
	$uname =~ s/\s+VARIANT FORM/\@v/;
	$uname =~ s/\s+CURVED/\@c/;
	$uname =~ s/\s+FLAT/\@f/;
	$uname =~ s/\s+TENU/\@t/;
	$uname =~ s/\s+REVERSED/\@r/;
	my $sn = "$n{$n}\($uname\)";
	$sn =~ s#1\(EIGHTH\s+#1/8(#;
	$sn =~ s#1\(HALF\s+#1/2(#;
	$sn =~ s#1\(QUARTER\s+#1/4(#;
	if (exists($osl{$sn})) {
	    print "o\t$sn\t$orig\n";
	} elsif (exists($pcsl{$sn})) {
	    print "p\t$sn\t$orig\n";
	} else {
	    print "n\t$sn\t$orig\n";
	} 
    } elsif ($uname =~ /^NINDA2/) {
    } else {
	warn
    }
}


1;
