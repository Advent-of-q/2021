# Day [5: Hydrothermal Venture](https://adventofcode.com/2021/day/5)

In solving today’s challenge, we

* write a simple function (ascending range) then wrap it to handle a larger domain
* use a test to index into a list of functions: equivalent to a case expression 
* index a string with a matrix to visualise the matrix


## Ingestion

Each vent is defined by two co-ordinate pairs.

Download: [`test5.txt`](./test/test5.txt)

```q
0,9 -> 5,9
8,0 -> 0,8
9,4 -> 3,4
2,2 -> 2,1
7,0 -> 7,4
6,4 -> 2,0
0,9 -> 2,9
3,4 -> 1,4
0,0 -> 8,8
5,5 -> 8,2
```
We’ll represent the vents as a list of 2×2 matrices.
```q
q)show vents:{value"(",ssr[;"->";";"]x,")"}each read0 `:test5.txt
0 9 5 9
8 0 0 8
9 4 3 4
2 2 2 1
7 0 7 4
6 4 2 0
0 9 2 9
3 4 1 4
0 0 8 8
5 5 8 2
```


## Part 1

```q
q)first vents
0 9
5 9
```
The second coords match so this is a horizontal line through
```q
0 9
1 9
2 9
3 9
4 9
5 9
```
which we could express as `(rng 0 5),'rng 9 9` if we had a function `rng` that returns an atom for `9 9`. We need only 
```q
q)range:{r:(::;reverse).[>]x;r{x+til y-x-1}. r x}
q)rng:{(0 1 .[=]x)first/range x}
q)rng each (5 9;5 3;9 9)  / some test cases
5 6 7 8 9
5 4 3
9
```
to get the points crossed by a vent.
```q
q)pts:{.[,']rng each flip x}
q)([]v:vents;p:pts each vents)
v       p
---------------------------------------------
0 9 5 9 (0 9;1 9;2 9;3 9;4 9;5 9)
8 0 0 8 (8 0;7 1;6 2;5 3;4 4;3 5;2 6;1 7;0 8)
9 4 3 4 (9 4;8 4;7 4;6 4;5 4;4 4;3 4)
2 2 2 1 (2 2;2 1)
7 0 7 4 (7 0;7 1;7 2;7 3;7 4)
6 4 2 0 (6 4;5 3;4 2;3 1;2 0)
0 9 2 9 (0 9;1 9;2 9)
3 4 1 4 (3 4;2 4;1 4)
0 0 8 8 (0 0;1 1;2 2;3 3;4 4;5 5;6 6;7 7;8 8)
5 5 8 2 (5 5;6 4;7 3;8 2)
```
We notice with satisfaction that `pts` finds the points for diagonal vents as well as vertical and horizontal ones. 

Find the points for just horizontal and vertical vents:
```q
q)vents where{any .[=]x}each vents
0 9 5 9
9 4 3 4
2 2 2 1
7 0 7 4
0 9 2 9
3 4 1 4

q)pts each vents where{any .[=]x}each vents
(0 9;1 9;2 9;3 9;4 9;5 9)
(9 4;8 4;7 4;6 4;5 4;4 4;3 4)
(2 2;2 1)
(7 0;7 1;7 2;7 3;7 4)
(0 9;1 9;2 9)
(3 4;2 4;1 4)

q)count each group raze pts each vents where{any .[=]x}each vents
0 9| 2
1 9| 2
2 9| 2
3 9| 1
4 9| 1
5 9| 1
9 4| 1
8 4| 1
7 4| 2
6 4| 1
5 4| 1
4 4| 1
3 4| 2
2 2| 1
2 1| 1
7 0| 1
7 1| 1
7 2| 1
7 3| 1
2 4| 1
1 4| 1
```
And count the points where vents overlap.
```q
q)plot:{count each group raze pts each x}
q)chp:{count where 1<x}  / count hot points
q)chp plot vents where {any .[=]x} each vents
5
```

## Part 2

The general case simply stops excluding the diagonal vents.
```q
q)chp plot vents
12
```

## Visualisation

We can also check our work against the map.
For this we’ll represent the 10×10 map as a 100-item vector and map the co-ordinate pairs into the range 0-99. 
```q
q)d:count each group 10 sv'raze pts each vents  / coords => (0-99)
9 | 2
19| 2
29| 2
39| 1
49| 1
59| 1
80| 1
..
```
Decompose the dictionary into key and value lists.
```q
q)(key;value)@\:d
9 19 29 39 49 59 80 71 62 53 44 35 26 17 8 94 84 74 64 54 34 22 21 70 72 73 4..
2 2  2  1  1  1  1  2  1  2  3  1  1  1  1 1  1  2  3  1  2  2  1  1  1  2  1..
```
Apply to these lists this projection of [Amend At](https://code.kx.com/q/ref/amend/) `@[100#0;;:;]`.
Its two omitted arguments make it a binary function.
We use [Apply](https://code.kx.com/q/ref/apply/) `.` to apply it to a list of its two arguments.
```q
q)@[100#0;;:;].(key;value)@\:d  / map to indices
1 0 0 0 0 0 0 0 1 2 0 1 0 0 1 0 0 1 0 2 1 1 2 0 1 0 1 0 0 2 0 1 0 1 2 1 0 0 0..
```
Putting that together:
```q
q)flip " 1234"10 cut @[100#0;;:;].(key;value)@\:count each group 10 sv'raze pts each vents
"1 1    11 "
" 111   2  "
"  2 1 111 "
"   1 2 2  "
" 112313211"
"   1 2    "
"  1   1   "
" 1     1  "
"1       1 "
"222111    "
```


## Solution

Download: [`day5.txt`](./data/day5.txt)

```q
vents:{value"(",ssr[;"->";";"]x,")"}each read0`:day5.txt
range:{r:(::;reverse).[>]x;r{x+til y-x-1}. r x}
rng:{(0 1 .[=]x)first/range x}                  / range: atom for .[=]x
pts:{.[,']range each flip x}                    / points of a vent
plot:{count each group raze pts each x}
chp:{count where 1<x}                           / count hot points

a[`$"5-1"]:chp plot vents where {any .[=]x} each vents
a[`$"5-2"]:chp plot vents
```

---
==>
[Day 6: Lanternfish](./06-lanternfish.md)
