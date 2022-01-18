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
q)" #"@seg in cs 3
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

Each note contains ten sample strings corresponding to the segments signalled for the numbers 0-9 in some order. 
It also contains four display strings.
When we can map the ten sample strings to the numbers 0-9, we can interpret the display strings. 

Four of the ten numbers can be mapped immediately to the unmistakeable numbers. 
```q
q)show as:1 4 7!(cs 1 4 7)(;)'x[`sample].[?](count'')(x`sample;cs 1 4 7)
1| "cf"   "be"
4| "bcdf" "cgeb"
7| "acf"  "edb"
```
Above we see how the canonical segments `("cf";"bcdf";"acf")` for the unmistakeable numbers 1 4 7 are permuted to `("be";"cgeb";"edb")`. 
But the order of the segments in each string does not matter: `"be"` could map to either `"cf"` or `"fc"`. 
The information in `as` does not give us the mapping – but it does restrict the search space. 

By comparing the mappings for 1 and 7 we see that `"a"` maps to `"d"`.
Similarly from 1 and 7 we see `"bd"` maps to `"cg"`.
```q
q)(as 1#1),.[except']each as(7 1;4 1)
"cf" "be"
,"a" ,"d"
"bd" "cg"
```
And we can convert these to index positions.
```q
q)show dm:sw?(as 1#1),.[except']each as(7 1;4 1)  / dictionary of mappings
2 5 1 4
0   3
1 3 2 6
```
The list above says indices 2 5 map to 1 4 or 4 1; that 0 maps to 3; and 1 3 maps to 2 6 or 6 2. 
From this we can list all the permutations for which the above is true.
Each permutation is a 7-vector. 
Infinities will hold the places for numbers yet to be determined.
We start with a list of one vector of 7 infinities. 
A function `cp` will take an item from `dm` and return a longer list.
```q
cp:{n:count x; i:(::;y 0); / crystallize permutation 
  $[count[y 0]-1; .[(2*n)#x;i;:;(1 reverse\y 1)where 2#n]; .[x;i;:;first y 1]] }
```
```q
q)cp[1 7#0W;dm 0]
0W 0W 1 0W 0W 4 0W
0W 0W 4 0W 0W 1 0W

q)(1 7#0W)cp/dm
3 2 1 6 0W 4 0W
3 2 4 6 0W 1 0W
3 6 1 2 0W 4 0W
3 6 4 2 0W 1 0W
```
If `cp` finds its right argument maps one index to another, it inserts that mapping into the list.
Otherwise the right argument will be two pairs of indexes. 
(This is not the general case, but it is so for this problem.)
The Zen monks `1 reverse\` provide both versions of the pair.

Two index positions remain unmapped, so we can use `cp` to complete the permutation list.
But we’ll use nulls instead of infinities as placeholders, so `null` finds them.
```q
q)pl:(1 7#0N)cp/dm  / permutations given by unmistakeable numbers
q)show pl:cp[pl] (where any null pl;til[count sw]except pl 0)  / complete the permutation list
3 2 1 6 0 4 5
3 2 4 6 0 1 5
3 6 1 2 0 4 5
3 6 4 2 0 1 5
3 2 1 6 5 4 0
3 2 4 6 5 1 0
3 6 1 2 5 4 0
3 6 4 2 5 1 0
```
It remains only to test these permutations.
For each permutation we can list the signal strings it would produce for the numbers 0-9.
One of them should produce all the strings in the sample.
```q
q)sw pl@\:sw?/:cs
"dcbaef" "be" "dbgaf" "dbgef" "cbge" "dcgef" "dcgaef" "dbe" "dcbgaef" "dcbgef"
"dceabf" "eb" "degaf" "degbf" "cegb" "dcgbf" "dcgabf" "deb" "dcegabf" "dcegbf"
"dgbaef" "be" "dbcaf" "dbcef" "gbce" "dgcef" "dgcaef" "dbe" "dgbcaef" "dgbcef"
"dgeabf" "eb" "decaf" "decbf" "gecb" "dgcbf" "dgcabf" "deb" "dgecabf" "dgecbf"
"dcbfea" "be" "dbgfa" "dbgea" "cbge" "dcgea" "dcgfea" "dbe" "dcbgfea" "dcbgea"
"dcefba" "eb" "degfa" "degba" "cegb" "dcgba" "dcgfba" "deb" "dcegfba" "dcegba"
"dgbfea" "be" "dbcfa" "dbcea" "gbce" "dgcea" "dgcfea" "dbe" "dgbcfea" "dgbcea"
"dgefba" "eb" "decfa" "decba" "gecb" "dgcba" "dgcfba" "deb" "dgecfba" "dgecba"

q)1 10#x`sample
"be" "cfbegad" "cbdgef" "fgaecd" "cgeb" "fdcge" "agebfd" "fecdb" "fabcd" "edb"
```
The order of segments in each string is insignificant. 
Sorting strings, casting to symbol, and sorting the symbols lets us find the sample in the list of candidates.
```q
q)(asc each `$(asc'')sw pl@\:sw?/:cs) ? asc `$asc each x`sample
2
```


### A higher-order function

We notice above the business of sorting strings, converting to symbols and sorting the symbol vectors is done to both arguments of Find, the only real difference being that it’s iterated over the items of the left argument. 
Could we write this more clearly?

One way would be to encapsulate the business in a lambda.
```q
q)ssv:{asc`$asc each x}  / sorted symbol vector
q)(ssv each sw pl@\:sw?/:cs) ? ssv x`sample
2
```
Or we could focus on the pattern with a function `f` and a pair of values `a` and `b`, where `f'` is applied to `a` and `f` to `b`.
```q
q)el:{(x'[y];x@z)}  / each on the left
q).[?] el[asc]. `$ el[asc']. (sw pl@\:sw?/:cs;x`sample)
2
```
Above we rely on atomic iteration in Cast to recurse all the way down to strings. 
```q
q)show p:pl .[?] el[asc]. `$ el[asc']. (sw pl@\:sw?/:cs;x`sample)
3 6 1 2 0 4 5
```
It remains only to use the winning permutation to decode the display strings.
```q
q)css?`$asc each sw p?sw?x`display
8 3 9 4
```

## Solution

Download: 
[`day8.txt`](./data/day8.txt)

```q
notes:flip`sample`display!" "vs''trim each("**";"|")0:read`:day8.txt
ce:count each
sw:except[;" "]distinct raze seg:6 cut" aaaa b    cb    c dddd e    fe    f gggg " / segments and display wires
cs:string css:`abcefg`cf`acdeg`acdfg`bcdf`abdfg`abdefg`acf`abcdefg`abcdfg / canonical signals
un:{lc!x?lc:where 1=ce group x} ce cs  / unmistakeable numbers: count | #
a[`$"8-1"]:sum in[;key un]raze(count'')notes`display

cp:{n:count x; i:(::;y 0); / crystallize permutation 
  $[count[y 0]-1;.[(2*n)#x;i;:;(1 reverse\y 1)where 2#n];.[x;i;:;first y 1]] }
an:{ / analyze note
  as:1 4 7!(cs 1 4 7)(;)'x[`sample].[?](count'')(x`sample;cs 1 4 7);  / analysis samples
  dm:sw?(as 1#1),.[except']each as(7 1;4 1);  / dictionary of mappings
  pl:(1 7#0N)cp/dm; / permutations given by unmistakeable numbers
  pl:cp[pl] (where any null pl;til[count sw]except pl 0); / complete the permutation list
  el:{(x'[y];x@z)};  / each on the left
  p:pl .[?] el[asc]. `$ el[asc']. (sw pl@\:sw?/:cs;x`sample); / winning permutation
  10 sv css?`$asc each sw p?sw?x`display }
a[`$"8-2"]:sum an each notes
```

---
==>
[Day 9: Smoke Basin](./09-smoke-basin.md)