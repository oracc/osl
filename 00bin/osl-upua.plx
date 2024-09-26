#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my $uage = '';

GetOptions(
    'age:s'=>\$uage
    );

my %addme = ();
my %oid = ();
my %seen = ();

load_oracc_pua();

#print Dumper \%addme;

my @osl = `cat 00lib/osl.asl`;

for (my $i = 0; $i <= $#osl; ++$i) {
    if ($osl[$i] =~ /^\@(?:sign|form)\s+(\S+)\s*$/) {
	my $n = $1;
	if ($addme{$n}) {
	    ++$seen{$n};
	    if (!pua_check($i)) {
		# insert before @v, @@, @form, or @end sign
		while ($osl[$i+1] !~ /^\@(v|\@|form|end\s+sign)/) {
		    ++$i;
		    if ($osl[$i] =~ /^\@oid\s+(\S+)\s*$/) {
			my $oid = $1;
			if ($oid ne $oid{$n}) {
			    warn "00lib/osl.asl:$i: OID mismatch: $oid{$n} in oracc-pua.tab; $oid in osl.asl\n";
			}
		    }
		}
		$osl[$i] .= $addme{$n};
	    }
	}
    }
}

foreach my $n (sort keys %addme) {
    warn "$0: never found sign/form/aka with name='$n'\n" unless $seen{$n};
}

print @osl;

#####################################################################################
#
# Load the data for Xsux only; if a uage is specified on the command
# line, load Xsux with that uage only
#
sub load_oracc_pua {
    open(P,'00etc/oracc-pua.tab') || die;
    while (<P>) {
	if (/Xsux/) {
	    chomp;
	    my ($o,$n,$p,$s,$a) = split(/\t/, $_);
	    if ($addme{$n}) {
		warn("00etc/oracc-pua.tab:$.: ignoring duplicate entry for name '$n'\n");
	    } else {
		if (!$uage || $uage eq $a) {
		    my $ucun = chr(hex($p));
		    my $data = "\@upua\tU+$p\n\@ucun\t$ucun\n\@uage\t$a\n";
		    $addme{$n} = $data;
		    $oid{$n} = $o;
		}
	    }
	}
    }
    close(P);
}

sub pua_check {
    my $j = shift;
    my $uni = 0;
    for (++$j; $j <= $#osl; ++$j) {
	last if $osl[$j] =~ /^(\@form|\@\@|\@end\s+sign)/;
	++$uni if $osl[$j] =~ /^\@(ucun|upua|useq)/;
    }
    $uni;
}

1;
