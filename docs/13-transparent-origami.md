# [Day 13: Transparent Origami](https://adventofcode.com/2021/day/131)

## Ingestion

Download:
[`test13.txt`](./test/test13.txt)


## Part 1


## Part 2


## Solution

Download: 
[`day13.txt`](./data/day13.txt)

```q
`pts`folds set'('[reverse;value]';1_)@'{(0,where 0=ce x)_ x}read 13
p1:((1+max pts)#0b) .[;;:;1b]/pts  / page one
fold:{f:(::;flip)@"yx"?y@11;n:value 13_y;f .[or](::;reverse)@'(1 neg\n)#\:f x} / fold x according to y
a[`$"13-1"]:sum raze fold[p1;first folds]
```

---
==>
[Day 14: Extended Polymerization](./14-extended-polymerization.md)