# [Day 9: Smoke Basin](https://adventofcode.com/2021/day/9)

## Ingestion

Download:
[`test9.txt`](./test/test9.txt)


## Part 1


## Part 2


## Solution

Download: 
[`day9.txt`](./data/day9.txt)

```q
hm:read0`:day9.txt  / heightmap
shp:{count@/:1 first\x} / shape of a matrix
drop:{[rc;m]rc[0]_ rc[1]_'m} / 2-D Drop
pad:{[rc;m]flip rc[0]$'flip rc[1]$m} / 2d Pad 
am:(1 0;-1 0;0 1;0 -1)  / adjacency matrix
lp:all hm</:"X"^{(shp[y]*/:-1 1 1 x+1)pad'x drop\:y}[am] hm / flag low points
a[`$"9-1"]:sum 1+"0123456789"?raze[hm] where raze lp 
/ shp[hm]vs/:where raze lp / LPs as coords

adj:{flip[c]where all(c:z+flip y)within'0,'x-1}[shp hm;am] / adjacent coords
nu:{n where (x ./:n:adj y)within(x . y),"8"}[hm] / neighbors uphill
climb:{(x,y;distinct(raze nu each y)except x)}.  / (coords x,y;new neighbors of y)
size:{count first(climb/)(();1 2#x)}  / size of basin around LP at coord x
a[`$"9-2"]:prd 3#desc size each shp[hm]vs/:where raze lp 
```

---
==>
[Day 10: Syntax Scoring](./10-syntax-scoring.md)