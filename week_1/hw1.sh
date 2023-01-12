#!/bin/bash
main="/pub/jenyuw/EE283/week_1"

wget https://wfitch.bio.uci.edu/~tdlong/problem1.tar.gz
tar -xvf problem1.tar.gz
cd $main/problem1

head -n 10 p.txt|tail -n 1 | tee -a output.txt

cat f.txt | tee -a output.txt

