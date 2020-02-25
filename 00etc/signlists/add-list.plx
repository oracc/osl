#!/usr/bin/perl
use warnings; use strict; use open 'utf8';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8';
use Getopt::Long;

my %forms = ();
my $how = '';
my @order = ();
my %O = ();
my $pad = 3;
my $sign = '';
my $which = 0;
my $verbose = 0;

GetOptions(
    'how:s'=>\$how,
    'which:i'=>\$which,
    'verbose'=>\$verbose,
    );

open(O, 'ogsl.asl') || open(O, '00lib/ogsl.asl');
while (<O>) {
    next if /^\s*$/;
    if (/^\@(?:no)?sign\s+(\S+)\s*$/) {
	$sign = $1;
	warn "$.: duplicate sign name $sign\n" if exists $O{$sign};
	push @order, $sign;
	%forms = ();
    } elsif (/^\@form/) {
	if (/\s~([a-z])/) {
	    my $form = $1;
	    warn "$.: duplicate form `$form'\n" if $forms{$form}++;
	    warn "$.: nested \@form\n" if $sign =~ s/~.*$//;
	    push @{$O{$sign}}, "!!$sign~$form";
	    $sign = "$sign~$form";
	} else {
	    warn "$.: no letter in \@form\n";
	}
    } elsif (/\@end\s+form/) {
	warn "$.: spurious \@end form\n" unless $sign =~ s/~.*$//;
    } elsif (/^\@ucode\s+(\S+)/) {
	my $u = $1;
	if ($u =~ m/^(?:\.?(?:0
			     |X
			     |xe[0-9A-F][0-9A-F][0-9A-F]
			     |x[0-9A-F][0-9A-F][0-9A-F][0-9A-F][0-9A-F]
			     |x[0-9A-F][0-9A-F][0-9A-F][0-9A-F]
			    ))+$/x) {
	    $O{$u} = $sign;
	} else {
	    warn "$.: bad ucode\n";
	}
    } elsif (/^\@list\s+(\S+)/) {
	my $l = $1;
	my ($list,$num) = ($l =~ /^([A-Z]+)(.*)$/);
	if ($list =~ /^ABZL|ELLES|HZL|KWU|LAK|MZL|REC|RSP$/) {
	    my($pre,$digits,$post) = ($num =~ /^([^0-9]*)(\d+)(.*$)$/);
	    $digits = "0$digits" if length $digits < 3;
	    $digits = "0$digits" if length $digits < 3;
	    $num = "$pre$digits$post";
	    $O{"$list$num",'list'} = $sign;
	} else {
	    warn "$.: unknown list $list\n";
	}
    } else {
    }
    push @{$O{$sign}}, $_;
}
close(O);

foreach my $list (@ARGV) {
    if (-r $list) {
	add_list($list);
    } else {
	warn "add-list.plx: can't read list `$list' to add it to ogsl.asl\n";
    }
}

dump_asl();

1;

###########################################################################

sub
add_list {
    my $list = shift;
    my $name = $list;
    $name =~ s/\..*$//;
    my $not = "not-in-$list";
    open(NOT,">$not");
    open(L, $list);
    while (<L>) {
	chomp;
	my ($num,@rest) = split(/\t/,$_);
	if ($how eq 'U') {
	    my $u = $rest[$which] || '';
	    $u =~ s/^\s*(\S+)\s*$/$1/;
	    if ($u =~ s/^U\+/x/) {
		if ($O{$u}) {
		    warn "$list:$.: U $u = sign $O{$u}\n" if $verbose;
		    insert_list($O{$u}, $name, $num)
		} else {
		    warn "$list:$.: Unicode value `$u' not in ogsl.asl\n";
		    next;
		}
	    } elsif ($u eq '') {
		print NOT "$_\n";
	    } else {
		warn "$list:$.: give Unicode as 'U+HHHHH' (H = HEX); empty or U+0 indicates sign not in Unicode\n";
	    }
	} else {
	    warn "add-list.plx: unknown value `-how $how'\n";
	}
    }
    close(L);
    close(NOT);
}

sub
dump_asl {
    foreach (@order) {
	my @lines = @{$O{$_}};
	foreach (@lines) {
	    if (/^\!!(.*?)$/) {
		my $o = $1;
		if ($o && $O{$o}) {
		    print @{$O{$o}};
		} else {
		    chomp;
		    warn "$.: bad order entry `$_'\n";
		}
	    } else {
		print;
	    }
	}
	print "\n\n";
    }
}

sub
insert_list {
    my ($sign,$name,$num) = @_;
    my $padded = pad($name,$num);
    for (my $i = 0; $i <= $#{$O{$sign}}; ++$i) {
	if (${$O{$sign}}[$i] =~ /$name/) {
	    if (${$O{$sign}}[$i] !~ /^\@list/) {
		undef $padded;
	    } else {
		warn "found ${$O{$sign}}[$i]";
		${$O{$sign}}[$i] = "\@list\t$padded\n";
		undef $padded;
	    }
	    last;
	}
    }
    if ($padded) {
	${$O{$sign}}[0] .= "\@list $padded\n";
    }
}

sub
pad {
    my($name,$num) = @_;
    $num = ('0'x($pad-length($num))).$num;
#    warn "created padded '$name$num'\n";
    "$name$num";
}

1;
