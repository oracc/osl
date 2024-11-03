#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";
use ORACC::XML;

use Getopt::Long;

GetOptions(
    );

my %lak = ();
my %list = ();
my %sl = ();

open(SL, '/home/oracc/osl/02pub/sl/sl.tsv') || die;
while (<SL>) {
    if (/;uchar/) {
	chomp;
	my($o,$c) = split(/\t/);
	$o =~ s/;uchar//;
	$sl{$o} = $c;
    }
}
close(SL);
    
open(L,'LAK-ucp.tsv') || die;
while (<L>) {
    chomp;
    my($l,$u) = split(/\t/, $_);
    my $cp = $u; $cp =~ tr/,/./;
    my $sset = $l; $sset =~ s/^.*?,// || ($sset = '');
    my $lsub = $l; $lsub =~ s/,.*$//;
    my $base = $lsub; $base =~ s/[a-z]$//; $base =~ s/\@.*$//;
    push @{$lak{$base}}, [ $lsub , $sset , $cp ];
}
close(L);

open(LL, 'list-lak.tsv') || die;
while (<LL>) {
    chomp;
    my($l,$o,$s,$n,$u) = split(/\t/, $_);
    my $base = $l; $base =~ s/[a-z]$//; $base =~ s/\@.*$//;
    ${$list{$base}}{$l} = [ $o , $s, $n , $u ];
}
close(LL);

print "<lak>\n";
foreach my $k (sort keys %lak) {
    my $lk = '';
    print "<entry l=\"$k\"";
    if (${$list{$k}}{$k}) {
	$lk = ${$list{$k}}{$k};
	my $xn = xmlify($$lk[2]);
	print " oid=\"$$lk[0]\" n=\"$xn\"";
    }	
    print ">\n";
    my @s = @{$lak{$k}};
    foreach my $s (sort { $$a[0] cmp $$b[0] } @s) {
	my $u = $$s[2];
	$u =~ s/\.\d+$//;
	if ($u =~ s/^U\+//) {
	    $u = chr(hex("0x$u"));
	} else {
	    $u = $sl{$$lk[0]};
	}
	if ($$s[1]) {
	    print "<sub l=\"$$s[0]\" sset=\"$$s[1]\" cp=\"$$s[2]\" utf8=\"$u\"/>";
	} else {
	    print "<sub l=\"$$s[0]\" cp=\"$$s[2]\" utf8=\"$u\"/>\n";
	}
    }
    print "</entry>\n";
}
print "</lak>\n";

1;
