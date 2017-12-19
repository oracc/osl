#!/usr/bin/perl
use warnings; use strict; use open 'utf8';

open(N,'>new.asl'); select N;
open(S,'00lib/ogsl.asl');
while (<S>) {
    if (/^\@ucode/) {
	chomp;
	s/^(\S+)\s+(\S+)\s+\S+$/$1\t$2\n/;
	print;
    } else {
	print;
    }
}
close(S);
close(N);

1;
