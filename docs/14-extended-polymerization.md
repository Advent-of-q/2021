# [Day 14: Extended Polymerization](https://adventofcode.com/2021/day/14)

## Ingestion

Download:
[`test14.txt`](./test/test14.txt)


## Part 1


## Part 2


## Solution

Download: 
[`day14.txt`](./data/day14.txt)

```q
`pt`pir set'(first;2_)@\:read 14 / polymer template; polymer insertion rules
ird:.[!]flip{(x 0 1;lower[x 6],x 1)}each pir / insertion rules dictionary
air:{upper 1_raze {$[count r:ird o:y,x;r;o]} prior x} / apply insertion rules
a[`$"14-1"]:.[-](max;min)@\:ce group 10 air/pt
/ a[`$"14-2"]:.[-](max;min)@\:ce group 40 air/pt  // ouch

/ solution by András Dőtsch
//1
pairs:2#'-2_(1_)\  / composition
pm:{x!x}pairs pt
pm,:(!). flip pir@\:(0 1;0 6 1)
f:{""{(-1_x),pm y}/pairs x}
ws:count@'group@
score:(-).(max;min)@\:
a[`$"14-1a"]:score ws 10 f/ pt
//2
T:ws pairs pt
PM:{x!{(1#x)!1#1}@'x}pairs pt
PM,:{x!1 1}@' (!). flip pir@\:(0 1;(0 6;6 1))
F:{value[x] wsum PM key x}
WS:{div[;2] (ws(first pt;last pt)) + value[x] wsum ws@'key x}
a[`$"14-2a"]:score WS 40 F/ T 
```

---
==>
