---
title: 'Day 1: Sonar Sweep | Advent of q
description: Solutions in q to Day 1 of the 2022 Advent of Code competition
author: Stephen Taylor
date: January 2022
---
# Day 1: Sonar Sweep


[![Sonar sweep](./img/sonar.jpg)](https://wiki.seg.org/wiki/Marine_geophysics)<br>
<small>_Image: Society of Exploration Geophysicists_</small>

Our [first puzzle](https://adventofcode.com/2021/day/1) shows off how easily q converts a text file to tractable data in memory, and explores some subtleties of the Each Prior iterator, including the mysteries of why you sometimes need to parenthesise a derived function.

## Ingestion

Every puzzle starts by ingesting a text file.

:arrow-down:
[`test1.txt`](./test/test1.txt)

```txt
199
200
208
210
200
207
240
269
260
263
```
[Tok](https://code.kx.com/q/ref/tok/) and [`read0`](https://code.kx.com/q/ref/read0/) eat that up.
```q
q)show d:"J"$read0 `:test1.txt
199 200 208 210 200 207 240 269 260 263
```

## Part 1

Question: **How many of these depth measurements are larger than the previous measurement?**

The [Each Prior](https://code.kx.com/q/ref/maps/#each-prior) iterator applied to the Greater Than operator `>` derives a function Greater Than Each Prior that tells us exactly that. Notice that the iterator `':` is applied *postfix*; that is, its argument, the Greater Than operator, is written on its left:  
```q
>':
```
A function derived this way (with postfix syntax) has *infix* syntax. We apply it with a zero left argument for the first comparison.
```q
q)0>':d
1111011101b
```
We’re not interested in the first comparison, so we discard it and count the remaining hits.
```q
q)sum 1_ 0>':d
7
```
Because we are not interested in the first comparison, the 0 could be any integer.
Perhaps better to get rid of it entirely.

Functions derived from Each Prior are [variadic](https://code.kx.com/q/basics/glossary/#variadic), which is to say that for a binary `f` you can apply `f':` as either a binary (as above) or as a unary, using either bracket or prefix syntax.
```q
q)sum 1_ >':[d] / bracket
7i
q)sum 1_ (>':)d / prefix
7i
```
### Detail: Those parentheses

Any function can be applied with bracket notation. So `>':` can be applied that way as a unary like any other unary, i.e. as `>':[d]`. Why can’t we apply it prefix like other unaries? For example, as `>':d`? 

The answer is above: applying the iterator *postfix*, derives a function `>':` that has *infix* syntax, which the parser won’t apply prefix. However, with parentheses round it, it has *noun* syntax – like a list – and, like any list, *can* be applied prefix.

### Extra detail

*Any function can be applied with bracket notation.* 
Iterators are functions too and the rule applies to them as well. 
Normal practice is to apply an iterator postfix, but Greater Than Each Prior can also be written `':[>]`. 
(Not recommended: the unusual syntax is likely to confuse a reader.) 
Written this way, it is still variadic, but no longer has infix syntax, and so *can* be applied prefix as a unary.

```q
q)':[>][0;d]  / applied as binary (bracket)
1111011101b
q)':[>]d      / applied as unary (prefix)
1111011101b
```

Applying it as a unary, without the 0 left argument, q has its own rules for what to compare the first item of `d` to. 
In this problem, we don’t care, but you can read about these [defaults](https://code.kx.com/q/ref/maps/#each-prior).

Because we are applying Greater Than Each Prior as a unary, we could instead use the [`prior`](https://code.kx.com/q/ref/prior) keyword.
```q
q)sum 1 _ (>) prior d
7i
```
Using keywords is better q style, and perhaps the coolest way to write the solution. 

Note the parens in `(>)`, which give it noun syntax. 
The parser reads it as the left argument of `prior` and does not try to apply it. 


## Part 2

With this as a model, [part 2](https://adventofcode.com/2021/day/1#part2) looks simple. 

Question: **Count the number of times the sum of measurements in this sliding window increases from the previous sum.**

We want the 3-point moving sums of `d`, of which we ignore the first two.


## Solution

:arrow-down:
[`day1.txt`](./test/day1.txt)

```q
a:()!"j"$() / answers
d:"J"$read0`:day1.txt`
a[`$"1-1"]:sum 1 _ (>) prior d
a[`$"1-2"]:sum 1 _ (>) prior 2 _ 3 msum d
```

### Oleg’s solution

Oleg Finkelshteyn has a simpler (and faster) solution to Part 2 that baffles me.
```q
sum(3_d)>-3_d
```
Why does comparing `d[i]` to `d[i-3]` give the same result as comparing the moving sums?








---
:point-right:
[Day 2: Dive](./02-dive.md)