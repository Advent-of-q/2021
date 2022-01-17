# [Day 4: Giant Squid](https://adventofcode.com/2021/day/4)

In solving today’s problem we shall

* represent matrices as vectors, finding vectors more tractable
* work with a 3-dimensional array
* rather than looping and testing, we’ll do a classic array-language ‘overcompute’ and analyse the results


## Ingestion

The bingo boards are nicely readable in the text file, but will be more tractable as vectors.

Download: [`test4.txt`](./test/test4.txt)

```txt
14,30,18,8,3,10,77,4,48,67,28,38,63,43,62,12,68,88,54,32,17,21,83,64,97,53,24,2,60,96,86,23,20,93,65,34,45,46,42,49,71,9,61,16,31,1,29,40,59,87,95,41,39,27,6,25,19,58,80,81,50,79,73,15,70,37,92,94,7,55,85,98,5,84,99,26,66,57,82,75,22,89,74,36,11,76,56,33,13,72,35,78,47,91,51,44,69,0,90,52

13 62 38 10 41
93 59 60 74 75
79 18 57 90 28
56 76 34 96 84
78 42 69 14 19

96 38 62  8  7
78 50 53 29 81
88 45 34 58 52
33 76 13 54 68
59 95 10 80 63

36 26 74 29 55
...
```

Empty lines in the text file show us where to divide it into matrices.
```q
q)q:read0`:test4.txt
q)show nums:value first q
7 4 9 5 11 17 23 2 0 14 21 24 10 16 13 6 15 25 12 22 18 20 8 19 3 26 1
q)show boards:value each" "sv'(where 0=count each q)cut q
22 13 17 11 0  8  2  23 4  24 21 9 14 16 7  6  10 3  18 5 1  12 20 15 19
3  15 0  2  22 9  18 13 17 5  19 8 7  25 23 20 11 10 24 4 14 21 16 12 6
14 21 17 24 4  10 16 15 9  19 18 8 23 26 20 22 11 13 6  5 2  0  12 3  7
```

## Part 1

A perfectly sensible looping approach would follow real life. We would call each number and see if any board has won. 

We’re not going to do that. We’re going to call all the numbers and see where the wins occur.
```q
s:(or\')boards=/:\:nums  / states: call all the numbers in turn
```
The derived function `=/:\:` (Equal Each Right Each Left) gives us a Cartesian product on the Equal operator. The list `boards` is a matrix; list `nums` is a vector; the Cartesian product has three dimensions. Put another way, `boards` has rank 2; `nums` rank 1; so their Cartesian product has rank 3. 

The list `boards=/:\:nums` has an item for each board. Each item is a boolean matrix: the rows correspond to the called numbers, the columns to the board numbers. Here’s the first board: 1s flag the matches as they are called.
```q
q)first boards=/:\:nums
0000000000000010000000000b
0000000010000000000000000b
0000000000010000000000000b
0000000000000000000100000b
0001000000000000000000000b
0010000000000000000000000b
..
```
That 1 in the top row should correspond to the first number called.
```q
q)boards[0]where first first board=/:\:nums
,7
q)first nums
7
```
Bingo.

Of course, once a number is called, it stays called.
```q
q)(or\)first boards=/:\:nums
0000000000000010000000000b
0000000010000010000000000b
0000000010010010000000000b
0000000010010010000100000b
0001000010010010000100000b
0011000010010010000100000b
..
```
That is just the first board. We want the same for every board.
```q
s:(or\')boards=/:\:nums  / states: call all the numbers in turn
```
The transformation above is a useful pattern. 
Use the first item of a list to figure out what (function) to apply to an item  (here it is `(or\)`); then drop the `first` and Each the function. 

How to tell if a board has won? 
Here is the state of board 0 after nine numbers have been called. 
```q
q)s[0;9;]
0011101110011010000100000b
```
Has it won?
```q
q)5 cut s[0;9;]
00111b
01110b
01101b
00001b
00000b
```
No: that would require all 1s on at least one row. Or a column.
```q
q)any all each {x,flip x}5 cut s[0;9;]
0b
```
Now we can flag the wins.
```q
q)show w:{any all each {x,flip x} 5 cut x}''[s]
000000000000011111111111111b
000000000000001111111111111b
000000000001111111111111111b
```
From this we can see that the third board is the first to win and the second is 
the last to win. 
Also that they win on (respectively) the 11th and 14th numbers called. 
```q
q)sum each not w
13 14 11i
```
So the state of the winning board is `s[2;11;]`
```q
q)5 cut s[2;11;]
11111b
00010b
00100b
01001b
11001b
q)sum boards[2] where not s[2;11;] / sum the unmarked numbers
188
q)nums[11]*sum boards[2] where not s[2;11;] / board score
4512
```

## Part 2

For Part 2 we want the state of the losing board when it finally ‘wins’. That is board 1 after the 14th number.
```q
q)nums[14]*sum boards[1] where not s[1;14;]
1924
```


## Solution

Download: [`day4.txt`](./data/day4.txt)

```q
q:read0`:day4.txt
nums:value first q
boards:value each" "sv'(where 0=count each q)cut q

s:(or\')boards=/:\:nums                             / states: call all the numbers in turn
w:sum each not{any all each b,flip b:5 cut x}''[s]  / flag wins
bs:{nums[x]*sum boards[y] where not s[y;x;]}        / score for board y after xth number
a[`$"4-1"]:bs . {m,x?m:min x} w                     / winning board score
a[`$"4-2"]:bs . {m,x?m:max x} w                     / losing board score
```
This is a nice example of the ‘overcomputing’ characteristic of vector languages. 
Clearly, an efficient algorithm could stop when it reached the first win. 
Or, for Part 2, the last win. 

But sometimes it is convenient to calculate all the results and search them. 
And, with vector operations, sometimes it is faster as well. 

---
==>
[Day 5: Hydrothermal Venture](./05-hydrothermal-venture.md)
