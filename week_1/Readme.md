# Homework_1

In this homework, the output was printed to the screen and redirected to a file, `output.txt`. 
Everything was contained in the directory, `/pub/jenyuw/EE283/week_1`.

The script is called, `hw1.sh`.
First, the tarred file was downloaded and extracted. Then, we moved to the extracted folder, `problem1`. 
We used `head -n 10` and `tail -n 1` to extract the tenth line of `p.txt`.  
We used the same way to treat `f.txt`. After each treatment, the texts were directed to the `output.txt` by `tee`.

The output on the screen is shown below.

```bash
[jenyuw@login-i17:/pub/jenyuw/EE283/week_1] $./hw1.sh
--2023-01-15 01:25:36--  https://wfitch.bio.uci.edu/~tdlong/problem1.tar.gz
Resolving wfitch.bio.uci.edu (wfitch.bio.uci.edu)... 128.200.71.64
Connecting to wfitch.bio.uci.edu (wfitch.bio.uci.edu)|128.200.71.64|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 284 [application/x-gzip]
Saving to: ‘problem1.tar.gz’

problem1.tar.gz                         100%[=============================================================================>]     284  --.-KB/s    in 0.01s

2023-01-15 01:25:36 (21.8 KB/s) - ‘problem1.tar.gz’ saved [284/284]

problem1/
problem1/p.txt
problem1/f.txt
3
55

```
