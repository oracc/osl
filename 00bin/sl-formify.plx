#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';

my %v = ();
while (<>) {
    if (/^\@sign/) {
	%v = ();
    } elsif (/^\@end\s+sign/ || /^\@form/) {
	%v = ();
    } elsif (/^\@v/) {
	my($v) = (/\s(\S+)/);
	if ($v =~ s/\@(.*)$//) {
	    my $mod = $1;
	    if ($v{$v}) {
		print STDERR "00lib/ogsl.asl:$.: $v\@$mod should have its own \@form\n";
	    }
	} else {
	    ++$v{$v};
	}
    }
}

1;
