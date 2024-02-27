#!/usr/bin/perl
use warnings; use strict; use open 'utf8'; use utf8; use feature 'unicode_strings';
binmode STDIN, ':utf8'; binmode STDOUT, ':utf8'; binmode STDERR, ':utf8';
binmode $DB::OUT, ':utf8' if $DB::OUT;

use Data::Dumper;

use Getopt::Long;

GetOptions(
    );

# This script drops existing @link and adds afresh

my %ebl = ();
my %wik = ();

my @tok = `cat 00etc/ebl-signs.lst`; chomp @tok;
foreach (@tok) {
    $ebl{$_} = [ $_ , "https://www.ebl.lmu.de/signs/$_" ]; # todo: urlify $_ for URL
}
@tok = `cat 00etc/wikidata.tsv`; chomp @tok;
foreach (@tok) {
    my($q,$u) = split(/\t/,$_);
    $wik{$u} = [ $q , "http://www.wikidata.org/entity/$q" ];
}
my $curr_sign;
my $curr_form;
my $curr_ucode;

my @sign_links = ();
my @form_links = ();

while (<>) {
    if (/^\@sign\s+(\S+)\s*$/) {
	$curr_sign = $1;
	$curr_form = '';
	$curr_ucode = '';
	@sign_links = ();
	@form_links = ();
	if ($ebl{$curr_sign}) {
	    push @sign_links, ['eBL', @{$ebl{$curr_sign}}];
	}
    } elsif (/^\@form\s+(\S+)\s*$/) {
	$curr_form = $1;
	if ($ebl{$curr_form}) {
	    push @form_links, ['eBL', @{$ebl{$curr_form}}];
	}
    } elsif (/^\@list\s+(U\+\S+)\s*$/) {
	$curr_ucode = $1;
	if ($wik{$curr_ucode}) {
	    if ($curr_form) {
		push @form_links, ['Wikidata', @{$wik{$curr_ucode}}];
	    } else {
		push @sign_links, ['Wikidata', @{$wik{$curr_ucode}}];
	    }
	}
    }
    if (/^\@form/ && @sign_links) {
	@sign_links = print_links(@sign_links);
    } elsif (/^\@\@/ && @form_links) {
	@form_links = print_links(@form_links);
    } elsif (/^\@end\s+sign/ && @sign_links) {
	if (@form_links) {
	    @form_links = print_links(@form_links);
	    print "\@\@\n";
	}
	@sign_links = print_links(@sign_links);
    }
    if (!/^\@link\s/) {
	print;
    }
}

sub print_links {
    foreach my $l (@_) {
	my($name,$label,$url) = @$l;
	print "\@link $name $label $url\n";
    }
    return ();
}

1;
