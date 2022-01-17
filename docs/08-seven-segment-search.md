# [Day 8: Seven Segment Search](https://adventofcode.com/2021/day/8)

Today’s problem is all about mappings.
That’s encouraging, because q is all about mappings.
A function is a mapping from its argument domain/s to its range – all its possible results. 
```q
q)sqrf:{x*x}  / squares: function
q)sqrf 4 9 3
16 81 9
q)sqrl:0 1 4 16 25 36 49 64 81  / squares: list
q)sqrl 4 9 3
16 81 9
q)sqrd:12 9 0 5 4 3!144 81 0 25 16 9  / squares: dictionary
q)sqrd 4 9 3
16 81 9
```
So we have all the tools we need. 

A 7-segment display maps signal wires to segments
```q
q)show seg:6 cut" aaaa b    cb    c dddd e    fe    f gggg " / segments and signal wires
" aaaa "
"b    c"
"b    c"
" dddd "
"e    f"
"e    f"
" gggg "
```
So the mapping from 0-9 to segments is (as symbols and strings)
```q
q)cs:string css:`abcefg`cf`acdeg`acdfg`bcdf`abdfg`abdefg`acf`abcdefg`abcdfg / canonical signals
q)" #"seg in cs 3
" #### "
"     #"
"     #"
" #### "
"     #"
"     #"
" #### "
```
The signal wires are 
```q
sw:"abcdefg"  / signal wires
``` 
but the submarine permutes them, for example signalling `"bg"` instead of `"cf"`.
We can represent this permutation as indexes into `sw`, that is permutations of `til 7`.
The canonical (unpermuted) mapping is thus `0 1 2 3 4 5 6`.


## Ingestion

Download: 
[`test8.txt`](./test/test8.txt)

Read the text file as a CSV with two columns, then partition each column on the spaces. 
```q
q)show notes:flip`sample`signal!" "vs''trim each("**";"|")0:read`:day8.txt
q)notes
sample                                                                                            signal
-----------------------------------------------------------------------------------------------------------------------------------------
"be"      "cfbegad" "cbdgef"  "fgaecd"  "cgeb"    "fdcge"   "agebfd" "fecdb"  "fabcd"   "edb"     "fdgacbe" "cefdb"   "cefbgd"  "gcbe"
"edbfga"  "begcd"   "cbg"     "gc"      "gcadebf" "fbgde"   "acbgfd" "abcde"  "gfcbed"  "gfec"    "fcgedb"  "cgb"     "dgebacf" "gc"
"fgaebd"  "cg"      "bdaec"   "gdafb"   "agbcfd"  "gdcbef"  "bgcad"  "gfac"   "gcb"     "cdgabef" "cg"      "cg"      "fdcagb"  "cbg"
"fbegcd"  "cbd"     "adcefb"  "dageb"   "afcb"    "bc"      "aefdc"  "ecdab"  "fgdeca"  "fcdbega" "efabcd"  "cedba"   "gadfec"  "cb"

..
```


## Part 1

The unmistakeable numbers each use a unique number of segments, so we can spot them easily. 
```q
q)show un:{lc!x?lc:where 1=ce group x} ce cs  / unmistakeable numbers: count | #
2| 1
4| 4
3| 7
7| 8
```
It remains only to count the signals with `key un` signal wires.
```q
q)sum in[;key un]raze(count'')notes`signal
26i
```

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