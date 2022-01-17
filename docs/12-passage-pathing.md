# [Day 12: Passage Pathing](https://adventofcode.com/2021/day/12)

## Ingestion

Download:
[`test12.txt`](./test/test12.txt)


## Part 1


## Part 2


## Solution

Download: 
[`day12.txt`](./data/day12.txt)

```q
map:.[!](key;'[except'[;`start];value])@\:delete end from group .[!]flip{x,reverse each x}`$"-"vs/:read0`:day12.txt

sc:{x where(first each string x)in .Q.a}key[map]except`start / small caves
xplr:{[m;sc;f;r] / explore map; small caves; routes
  (r where`end=last each r),raze r,/:'(m last each r)except'r f\:sc
  } [map;sc;] / explore
a[`$"12-1"]:count (xplr[inter]/) 1 1#`start
a[`$"12-2"]:count (xplr[{$[2 in(ce group x)@y;x inter y;()]}]/) 1 1#`start
```

---
==>
[Day 13: Transparent Origami](./13-transparent-origami.md)