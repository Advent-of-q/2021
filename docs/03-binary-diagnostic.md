# [Day 3: Binary Diagnostic](https://adventofcode.com/2021/day/3)

In today’s problem we 

*    abstract from two algorithms by passing an operator as argument
*    meet the Zen monks using the Do iterators
*    use the Do iterator to repeatedly apply a filter

## Ingestion

Ingestion here is a treat. 
We rely on the atomic iteration implicit in the Equal operator. 
Comparing the file lines to `"1"` gets us a boolean matrix.
```q
q)show dg:"1"=read0`:test3.txt / diagnostic
00100b
11110b
10110b
10111b
10101b
01111b
00111b
11100b
10000b
11001b
00010b
01010b
```

## Part 1

Finding the most common bits is just comparing the the sum of `dg` to half its count.
```q
q)sum[dg]>=count[dg]%2  / gamma bits
10110b
```
And the least-common bits are… not them.
```q
q)sum[dg]<count[dg]%2  / epsilon bits
01001b
```
>— *How many Zen monks does it take to change a lightbulb?*<br>
>— *Two: one to change it, one not to change it.* 

So I think of this pattern <code>1 f\\</code> of the [Do](https://code.kx.coom/q/ref/acclmulators/#do) iterator as the Zen monks. 
```q
q)1 not\sum[dg]>=count[dg]%2  / epsilon and gamma bits
10110b
01001b
```
All that remains is to encode these two binary numbers as decimals and get their product. 
```q
q)prd 2 sv'1 not\sum[dg]>=count[dg]%2
198
```
The [`sv`](https://code.kx.com/q/ref/sv/) keyword is a bit of a ‘portmanteau’ function. The common theme is scalar (atom) from vector. In the domain of integers it interprets a vector as a number in the base of its left argument. 

## Part 2

To find the oxygen generator rating we need to filter the rows of `dg` by an aggregation (most-common bit) of its first column, and so on. 
We are going to have to specify the iteration. 

A succession of filters suggests an [Accumulator](https://code.kx.com/q/ref/accumulators/) iteration, where the result of one iteration is the argument of the next. 

We’ll use a binary filter function. One argument will be a bit vector. The other will be a comparison operator corresponding to most-common bit (`>=`) or least-common bit (`<`).
```q
fltr:{[op;bits]where bits=.[op]1 .5*(sum;count)@\:bits}
```
Using the [Apply](https://code.kx.com/q/ref/apply/) operator to apply the comparison operator between the items of a pair allows us to pass the comparison operator to `fltr` as an argument. 

To work across the columns of `dg` we’ll flip it so its columns become the items of a list.
We’ll use the Scan iterator to filter the rows of `flip dg` until the next iteration would leave no rows left. 

We start with all the rows: `til count dg`. We want some binary function `f` so our iteration is
```q
(til count dg)f/flip dg
```
The function `f` we want will take as its left argument a list of row indices. Its right argument will be a bit vector – the successive columns of `dg`. Its result will be a list of row indices to be used for the next iteration. We need it to stop filtering before the last indices are gone.
Here’s `f`:
```q
(til count dg){$[count i:fltr[>=]y x;x i;x]}/flip dg
```
Here we can see the structure of the iteration. 
The initial state `til count dg` is a list of all the rows of`dg`.
The lambda being iterated tests the first column of `dg` and returns the rows that pass the test. 
Only the rows listed in the left argument are tested, so eliminated rows stay eliminated. 

We can use the Scan form of the Do iterator to watch the rows being filtered. 
```q
q)dg(til count dg){$[count i:fltr[>=]y x;x i;x]}\flip dg
(11110b;10110b;10111b;10101b;11100b;10000b;11001b)
(10110b;10111b;10101b;10000b)
(10110b;10111b;10101b)
(10110b;10111b)
,10111b
```
That is the oxygen generator rating for the test data. 
Switching the comparison operator will give us the CO2 scrubber rating.
Let’s make the comparison operator the lambda’s third argument, and embed the iteration in a function that returns the winning row.
```q
q)analyze:{y first(til count y){$[count i:fltr[z;] y x;x i;x]}[;;x]/flip y}
q)analyze[>=] dg
10111b
```
Afterthoughts: we pass the comparison operators At Least `>=` and Less Than `<` as arguments to `analyze` to determine most-common or least-common bits. That leaves scope for extending the solution to other comparisons. 
But the problem here requires only most-common or least-common, which is At Least and its negation. 

The ternary conditional Cond is a compact way of expressing if/then/else. 
But everything else being equal, I prefer the Zen monks, who accept everything and act appropriately.

>*The Great Way is not difficult. It avoids only picking and choosing.* — [Daiyu Myokyo-ni Zenji](https://en.wikipedia.org/wiki/Myokyo-ni)

Instead of passing the operators as arguments, we could pass a 0 or 1 according to whether we want most-common or least-common bits.
It might also improve legibility to separate testing the filter results from the Do iteration. 

That leaves our complete solution:
```q
dg:"1"=read0`:day3.txt
a[`$"3-1"]:prd 2 sv'1 not\(sum dg)>=(count dg)%2
fltr:{x=(sum x)>=(count x)%2}                    / flag matches to most-common bit
filter:{x@$[count i:where z not/fltr y x;i;::]}  / filter rows
rating:{y first(til count y)filter[;;x]/flip y} 
OGCS:0 1                                         / O2 generator; CO2 scrubber
a[`$"3-2"]:prd 2 sv'OGCS rating\:dg
```

---
==>
[Day 4: Giant Squid](./04-giant-squid.md)
