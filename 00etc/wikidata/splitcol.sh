for a in 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 ; do
    cut -f15 <../../00raw/Script.tsv >meszl.col
    cut -f1,2,$a <../../00raw/Script.tsv >tmp
    n=`head -1 tmp | cut -f3 | tr -d '\n' | tr ' /' _-`
    rocox -C312 <tmp >$n.lst
    /bin/echo -n "$n.lst: " ; grep -c '^[0-9]' $n.lst
    paste meszl.col $n.lst >m-$n.lst
done
