#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use lib "$ENV{'ORACC_BUILDS'}/lib";

use Getopt::Long;

my $asl = '../00lib/osl.asl';
my $flat = 0;
my @flat = ();

GetOptions(
    'asl:s'=>\$asl,
    flat=>\$flat,
    );

#
# This script handles adding and removing the @sys xref from osl.asl
# to PC signs.
#
# With no arguments it removes @sys pcun lines and Unicode data
# associated with signs that contain the @sys.
#
# With a file argument, it inserts @sys pcun lines and the Unicode
# data from the table.
#
# osl.asl may be sorted between insertion and removal so this can't be
# done in a single pass.
#
# Add @sys pcun N(01) to AŠ@c etc; also add Unicode data.
#

my $adding = 0;
my $removing = 0;
if ($ARGV[0]) {
    warn "adding from $ARGV[0]\n";
    $adding = 1;
} else {
    warn "removing\n";
    $removing = 1;
}

if ($flat) {
    if ($adding) {
	add_flat();
    } else {
	rem_flat();
    }
    exit 0;
}

my %data = (); load_data($ARGV[0]) if $adding;
my %seen = ();
my @o = `cat $asl`; chomp @o; my $oend = $#o;
my $sf = 0;
my $end = 0;
while (($sf,$end) = get_sign_or_form($sf)) {
    last if $sf == -1;
    #warn "sf = $sf; end=$end; oend=$oend\n";
    #print "$o[$sf] .. $o[$end]\n";
    if ($removing) {
	my $p = 0;
	if (($p = has_sys_pcun_acn($sf,$end))) {
	    rem_data($p,$sf,$end);
	}
    } else {
	my $head = $o[$sf]; $head =~ s/^.*?\s+//; $head =~ s/\s*$//;
	if ($data{$head}) {
	    add_data($head,$sf,$end);
	    ++$seen{$head};
	}
    }
    $sf = $end;
    ++$end unless $o[$end] =~ /^\@form/;
}

foreach my $k (sort keys %data) {
    warn "never found $k\n" unless $seen{$k};
}

print_osl();

#######################################################################

sub add_data {
    my($h,$i,$e) = @_;
    while ($i < $e) {
	if ($o[$i] =~ /^\@sys\s+(pcun|acn)/) {
	    die "$0: must call with no file arg to remove pcun/acn data before adding. Stop.\n";
	} else {
	    ++$i;
	}
    }
    $o[$i-1] .= "\n$data{$h}";
}

sub has_sys_pcun_acn {
    my($i,$e) = @_;
    while ($i < $e) {
	return $i if $o[$i] =~ /^\@sys\s+(acn|pcun)/;
	++$i;
    }
    return 0;
}

sub get_sign_or_form {
    my $i = shift;
    return (-1,-1) if $i >= $#o;
    while ($i <= $#o && $o[$i] !~ /^\@(sign|form)/) {
	++$i;
    }
    my $e = $i+1;
    while ($e <= $#o) {
	last if $o[$e] =~ /^\@form|\@\@|\@end\s+sign/;
	++$e;
    }
    ($i,$e);
}

sub load_data {
    open(D,$_[0]) || die "$0: can't read data file $_[0]\n";
    my $fieldrow = <D>; chomp $fieldrow;
    die unless $fieldrow =~ /^WS\tUSN\tMAP\tSLSN\tUHEX\tUNAME$/;
    while (<D>) {
	chomp;
	my($ws,$usn,$map,$slsn,$uhex,$uname) = split(/\t/,$_);
	my $ucun = chr(hex($uhex));
	my $udata = "\@list U+$uhex\n\@uname $uname\n\@uage ACN\n\@ucun $ucun";
	if ($flat) {
	    if ($usn =~ /\@f/) {
		push @flat, "\@pcun $usn\n$udata\n\@end pcun\n\n";
	    }
	} else {
	    if ($ws eq 'p' && $map) {
		my $val = "\@sys pcun $usn\n$udata";
		# warn "$map => $val";
		$data{$map} = $val;
	    } elsif ($ws eq 'o') {
		my $sn = $usn;
		$sn = $slsn unless $slsn =~ /^f/;
		my $val = "\@sys acn $usn\n$udata";
		# warn "$sn => $val";
		$data{$sn} = $val;
	    }
	}
    }
    close(D);
}

sub print_osl {
    my @out = grep(defined,@o);
    foreach (@out) {
	print $_, "\n";
    }
}

sub rem_data {
    my($p,$i,$e) = @_;
    while ($i < $e) {
	if ($o[$i] && $o[$i] =~ /^\@(uage|ucun|uname|list\s+U\+)/) {
	    $o[$i] = undef
	}
	++$i;
	$o[$p] = undef;
    }
}

### FLAT NUMS ###

sub add_flat {
    load_data($ARGV[0]);
    system 'cat', $asl;
    print "\n";
    print @flat;
}

1;
