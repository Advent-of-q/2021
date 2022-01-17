## [Day 6: Lanternfish](https://adventofcode.com/2021/day/6)

In solving today’s challenge we

* start with a naive strategy then get smarter
* use the Do iterator
* overcompute rather than iterate twice or write test logic


### Ingestion

Download: [`day6.txt`](./data/day6.txt)

```txt
2,3,1,3,4,4,1,5,2,3,1,1,4,5,5,3,5,5,4,1,2,1,1,1,1,1,1,4,1,1,1,4 ...
```
The first line of the text file is an integer vector. It does not get easier than this.

```q
lf:value first read0`:day6.txt
```


### Part 1

It’s tempting to model the lanternfish population as presented: as a vector of timer states, subtracting 1 on each day, resetting each 0 to 6 and appending an 8.
That lets us model progress day by day.
```q
q)lf:3 4 3 1 2  / lanternfish: test data
q)3{,[;sum[n]#8] (x-1)+7*n:x=0}\lf
3 4 3 1 2
2 3 2 0 1
1 2 1 6 0 8
0 1 0 5 6 7 8
```
And count them after 18 and 80 days.
```q
q)count 18{,[;sum[n]#8] (x-1)+7*n:x=0}/lf
26
q)count 80{,[;sum[n]#8] (x-1)+7*n:x=0}/lf
5934
```

### Part 2

But all this quickly gets out of hand. 
Each append to the vector entails making a copy.
Over 256 days the count exceeds 26 billion. 

A vector is an *ordered* list, but we do not need the lanternfish in any order. We need only represent how many fish have their timers in a given state. 
We could do this with a dictionary. 
```q
q)count each group lf
3| 2
4| 1
1| 1
2| 1
```
But even this is more information than we need. There are only nine possible timer values. 
A vector of nine integers will number the fish at each timer state.
```q
q)show lf:@[9#0;;1+]lf  / lanternfish school
0 1 1 2 1 0 0 0 0
```
Notice in the application of [Amend At](https://code.kx.com/q/ref/amend/) above the index vector `3 4 3 1 2` contains two 3s. 
The unary third argument of Amend At, `1+`, is applied twice at index 3. 
The iteration is implicit in Amend At and need not be specified. 

Now we can represent a day’s action with a `1 rotate`, which happily rotates the fish with expired timers round to position 8. 
But position 8 represents newly spawned fish: we also need to reset their parents’ timers by adding them at position 6.
```q
q)3 {@[1 rotate x;6;+;first x]}\ lf
0 1 1 2 1 0 0 0 0
1 1 2 1 0 0 0 0 0
1 2 1 0 0 0 1 0 1
2 1 0 0 0 1 1 1 1
```
After the required iterations, count the fish with `sum`.
```q
q)sum 256{@[1 rotate x;6;+;x 0]}/ lf
26984457539
```

## Solution

```q
lf:@[9#0;;1+] value first read0`:day6.txt
a[`$("6-1";"6-2")]:sum each @[;80 256] 256{@[1 rotate x;6;+;first 0]}\lf
```
Above, rather than run the same iteration first 80 then 256 times with Over, we have run it 256 times with Scan, then selected the 80th and 256th state vectors from the result. 

---
==>
[Day 7: The Treachery of Whales](./07-treachery-whales.md) 