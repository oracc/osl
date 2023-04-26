#!/usr/bin/perl
use warnings; use strict;
use File::Copy;

my %oid = ();
open(O, '/home/ogsl/archnames/f23.oid') || die;
while (<O>) {
    chomp;
    my($f,$o) = split(/\t/,$_);
    $oid{$f} = $o;
}
close(O);

print "<html><head>\n";
print '<meta http-equiv="content-type" content="text/html; charset=UTF-8"></head><body>', "\n";
print "<h1>Proto-Cuneiform Signs from CDLI with Oracc OIDs</h1>";
print "<h2>Ideographic Signs</h1>\n";
print "<table>\n";
while (<>) {
    chomp; s#^/##;
    my $orig = $_;
    my $b = $_; $b =~ s/\&amp;/&/g;
    $b =~ s/.jpg$//;
    if ($orig eq '1(N01)') {
	print "</table>\n";
	print "<h2>Numerical Signs</h2>\n";
    }
    if ($oid{$b}) {
	print "<tr><td><img src=\"$oid{$b}.jpg\" alt=\"digital drawing of sign $orig\"/></td><td>$orig</td><td>$oid{$b}</td></tr>\n"
    } else {
	warn "no OID for $_\n";
    }
}

print "</table>\n";
print '</body></html>', "\n";

1;
