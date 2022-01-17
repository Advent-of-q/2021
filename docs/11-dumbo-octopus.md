# [Day 11: Dumbo Octopus](https://adventofcode.com/2021/day/11)

## Ingestion

Download:
[`test11.txt`](./test/test11.txt)


## Part 1


## Part 2


## Solution

Download: 
[`day11.txt`](./data/day11.txt)

```q
o:"0123456789"?raze oct:read0`:day11.txt / octopus vector 
off:except[;enlist 0 0]{x cross x}til[3]-1 / neighbor offsets
nbr:{c:off+\:y;x sv/:c where all flip[c]within'0,'x-1}[shp oct]each .[cross]til each shp oct / neighbor indexes for o
flash:{i:where[x>9]except y; (@[x;raze nbr i;1+];y,i)}. / flash x where hot except at y
step:{({x*x<10};'[y+;count])@'flash over (x+1;0#0)}.  / [energy;# accumulated flashes]
a[`$"11-1"]:@[;1] 100 step/(o;0)
a[`$"11-2"]:-[;1] count {any 0<first x} step\(o;0)
```

---
==>
[Day 12: Passage Pathing](./12-passage-pathing.md)