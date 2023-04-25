#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8;
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
use Data::Dumper;
use lib "$ENV{'ORACC'}/lib";
use ORACC::ATF::Unicode;
use Getopt::Long;
GetOptions(
    );
my $tokpat = 'UET2[._]405|[.x&%+]|-2|\(|\)|\||[246]\(LAGAB~a\)|[0-9]+\(N[0-9]+[A-Z]?(?:[@~][a-wyz0-9])*\)|N[0-9]+|[A-Z\'_]+[0-9]*|[@~][a-wyz0-9]+|~x';

while (<>) {
    chomp;
    next if /^.*?:/;
    s#cdli-archsigns-20160000/prc_ideographic/##;
    s/.jpg//;
    next unless length;
    print "$_\t";
    while ((my $t = tok())) {
	if ($t eq 'x') {
	    print '×';
	} elsif ($t =~ /ZATU|UET/) {
	    if ($t =~ /UET.*?405/) {
		print "BAU405";
	    } else {
		print $t;
	    }
	} elsif ($t =~ /[AEIU]/) {
	    $t = ORACC::ATF::Unicode::gconv($t);
	    print $t;
	} else {
	    print $t;
	}
    }
    print "\n";
}

sub tok {
    if (s/^($tokpat)//) {
	my $t = $1;
	unless ($t) {
	    warn "tok empty at ^$_\n";
	}
	return $t;
    } else {
	warn "$.: no match to $tokpat at ^$_\n" if length;
	s/^.//;
	return undef;
    }
}

1;

