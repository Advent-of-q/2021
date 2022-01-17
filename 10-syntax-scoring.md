# [Day 10: Syntax Scoring](https://adventofcode.com/2021/day/10)

## Ingestion

Download:
[`test10.txt`](./test/test10.txt)


## Part 1


## Part 2


## Solution

Download: 
[`day10.txt`](./data/day10.txt)

```q
subsys:read0`:day10.txt
tkn:"()[]{}<>" / tokens
/(`,`$2 cut tkn),'(subsys 1#2),{sums sum x}each 1 -1*/:2 cut tkn=\:subsys 2
opn:"([{<"; cls:")]}>"
prs:{[str;stk] c:str 0; / parse string with stack
  $[c in opn;(1_str;stk,c);opn[cls?c]=last stk;(1_str;-1 _ stk);(str;stk)] }.
pr:('[prs/;(;"")]) each subsys
a[`$"10-1"]:sum (cls!3 57 1197 25137) 2 first'/pr
com:(opn!cls)reverse each{y where 0=ce x}. flip pr / completions
a[`$"10-2"]:"j"$med({y+5*x}/)each 1+cls?com
```

---
==>
[Day 11: Dumbo Octopus](./11-dumbo-octopus.md)