# [Day 8: Seven Segment Search](https://adventofcode.com/2021/day/8)

## Ingestion

## Part 1

## Part 2

## Solution

Download: 
[`day8.txt`](./data/day8.txt)

```q
notes:flip`sample`signal!" "vs''trim each("**";"|")0:read`:day8.txt
ce:count each
oa:asc each / order each string alphabetically
sw:except[;" "]distinct raze seg:6 cut" aaaa b    cb    c dddd e    fe    f gggg " / segments and signal wires
cs:string css:`abcefg`cf`acdeg`acdfg`bcdf`abdfg`abdefg`acf`abcdefg`abcdfg / canonical signals
un:{lc!x?lc:where 1=ce group x} ce cs  / unmistakeable numbers: count | #
a[`$"8-1"]:sum in[;key un]raze(count'')notes`signal
/ a[`$"8-1"]:sum @[;key un]ce group raze(count'')notes`signal

cp:{n:count x; i:(::;y 0); / crystallize permutation 
  $[count[y 0]-1;.[(2*n)#x;i;:;(1 reverse\y 1)where 2#n];.[x;i;:;first y 1]] }
an:{ / analyze note
  as:1 4 7!(cs 1 4 7)(;)'x[`sample].[?](count'')(x`sample;cs 1 4 7);  / analysis samples
  dm:sw?(as 1#1),.[except']each as(7 1;4 1);  / dictionary of mappings
  pl:(1 7#0N)cp/dm; / permutations given by unmistakeable numbers
  pl:cp[pl] (where any null pl;til[count sw]except pl 0); / complete the permutation list
  p:first pl where all each in[;css]`$(asc'')sw pl?\:sw?x`sample; / winning permutation
  10 sv css?`$oa sw p?sw?x`signal }
a[`$"8-2"]:sum an each notes
```

---
==>
[Day 9: Smoke Basin](./09-smoke-basin.md)