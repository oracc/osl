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
my %rows = ();
my %rseen = ();
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
    my $base = $lsub;
    if ($base ne 'LAK046a') {
	$base =~ s/[a-z]$//; $base =~ s/\@.*$//;
    }
    my $fn = "$l.svg";
    push @{$lak{$base}}, [ $lsub , $sset , $cp , $fn ];
}
close(L);

open(LL, 'list-lak.tsv') || die;
while (<LL>) {
    chomp;
    my($l,$o,$s,$n,$u) = split(/\t/, $_);
    my $base = $l;
    if ($base ne 'LAK046a') {
	$base =~ s/[a-z]$//; $base =~ s/\@.*$//;
    }
    ${$list{$base}}{$l} = [ $o , $s, $n , $u ];
}
close(LL);

my @rows = </home/stinney/orc/osl/00res/images/lak/rows/*.png>;
foreach my $r (@rows) {
    my ($n) = ($r =~ m#/(LAK.*?)\.png#);
    if ($n ne 'LAK046a') {
	$n =~ s/[a-z]$//;
    }
    if ($list{$n}) {
	push @{$rows{$n}}, $r;
    } else {	
	warn "no base for row $n\n";
    }
}

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
    if ($rows{$k}) {
	++$rseen{$k};
	print "<rows>";
	foreach (@{$rows{$k}}) {
	    s#^.*?/osl/00res#/osl#;
	    print "<row src=\"$_\"/>";
	}
	print "</rows>";
    }
    my @s = @{$lak{$k}};
    foreach my $s (sort { $$a[0] cmp $$b[0] } @s) {
	my $u = $$s[2];
	$u =~ s/\.\d+$//;

	if ($u =~ s/^U\+//) {
	    $u = chr(hex("0x$u"));
	} else {
	    $u = $sl{$$lk[0]};
	}

	my $salt = $$s[2];
	if ($salt !~ s/^U.*?\.//) {
	    $salt = 0;
	}
	    
	if ($salt) {
	    print "<sub l=\"$$s[0]\" salt=\"$salt\" cp=\"$$s[2]\" utf8=\"$u\" svg=\"/osl/images/lak/svg/$$s[3]\"/>";
	} else {
	    print "<sub l=\"$$s[0]\" cp=\"$$s[2]\" utf8=\"$u\" svg=\"/osl/images/lak/svg/$$s[3]\"/>\n";
	}
    }
    print "</entry>\n";
}

my @xrow = ();
foreach my $r (sort keys %rows) {
    push @xrow, $r unless $rseen{$r};
}
if ($#xrow >= 0) {
    print "<entry l=\"LAKXXX\">";
    foreach (@xrow) {
	s#^.*?/osl/00res#/osl#;
	print "<row src=\"$_\"/>";
    }
    print "</entry>";
}

print "</lak>\n";

1;
