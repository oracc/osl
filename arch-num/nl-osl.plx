#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

GetOptions(
    );

my %osl = load_asl('../00lib/osl.asl');
my %pcsl = load_asl('../../pcsl/00lib/pcsl.asl');

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

my %fixed = (
    '1/8(IKU@c)'=>'F₃@c',
    '1/8(IKU@c@v)'=>'F₃@c@v',
    '1/4(IKU@c@v)'=>'F₄@c@v',
    '1/2(IKU@c@v)'=>'F₈',
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
	$uname =~ s/BAN2/BAN₂/;
	my $sn = "$n{$n}\($uname\)";
	$sn =~ s#1\(EIGHTH\s+#1/8(#;
	$sn =~ s#1\(HALF\s+#1/2(#;
	$sn =~ s#1\(QUARTER\s+#1/4(#;
	if (exists($pcsl{$sn})) {
	    print "p\t$sn\t$pcsl{$sn}\t$orig\n";
	} elsif (exists($osl{$sn})) {
	    print "o\t$sn\t$osl{$sn}\t$orig\n";
	} elsif ($fixed{$sn}) {
	    print "o\t$sn\t$fixed{$sn}\t$orig\n";
	} else {
	    print "n\t$sn\t$orig\n";
	} 
    } elsif ($uname =~ /^NINDA2/) {
    } else {
	warn
    }
}

############################################################################

sub load_asl {
    my %a = ();
    my $s = '';
    open(A,$_[0]) || die "load_asl: failed on $_[0]\n";
    while (<A>) {
	if (/^\@sign\s+(\S+)\s*/) {
	    $s = $a{$1} = $1;
	} elsif (/^\@form\s+(\S+)\s*$/) {
	    $a{$1} = "f$s";
	} elsif (/^\@aka\s+(\S+)\s*$/) {
	    $a{$1} = "=$s";
	}
    }
    close(A);
    %a;
}


1;
