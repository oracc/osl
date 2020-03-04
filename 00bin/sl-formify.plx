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
	my $orig_v = $v;
	if ($v =~ s/\@([^)]+)//) {
	    my $mod = $1;
	    if ($v{$v}) {
		print STDERR "00lib/ogsl.asl:$.: $orig_v should have its own \@form\n";
	    } else {
		# warn "v = $v ; mod = $mod \n";
	    }
	} else {
	    ++$v{$v};
	}
    }
}

1;
