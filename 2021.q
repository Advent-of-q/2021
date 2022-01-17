TEST:0b
read:{read0`$":",$[TEST;"test";"day"],string[x],".txt"}


a:()!"j"$() / answers
/ Day 1
d:"J"$read 1
a[`$"1-1"]:sum 1 _ (>) prior d 
a[`$"1-2"]:sum 1 _ (>) prior 2 _ 3 msum d

/ Day 2
forward:1 0*; down:0 1*; up:0 -1*
c:value each read 2
a[`$"2-1"]:prd sum c
a[`$"2-2"]:prd sum {x*1,'sums y}. flip c

/ Day 3
dg:"1"=read 3
a[`$"3-1"]:prd 2 sv'1 not\(sum dg)>=(count dg)%2
fltr:{x=(sum x)>=(count x)%2}
filter:{x$[count i:where z not/fltr y x;i;::]}
rating:{y first(til count y)filter[;;x]/flip y}
OGCS:0 1 / O2 generator; CO2 scrubber
a[`$"3-2"]:prd 2 sv'OGCS rating\:dg

/ Day 4
q:read 4
nums:value first q
boards:value each" "sv'(where 0=count each q)cut q

s:(or\')boards=/:\:nums  / states: call all the numbers in turn
w:sum each not{any all each b,flip b:5 cut x}''[s]  / find wins
bs:{nums[x]*sum boards[y] where not s[y;x;]} / score for board y after xth number
a[`$"4-1"]:bs . {m,x?m:min x} w / winning board score
a[`$"4-2"]:bs . {m,x?m:max x} w / losing board score

/ Day 5
vents:{value"(",ssr[;"->";";"]x,")"}each read 5
range:{r:(::;reverse).[>]x;r{x+til y-x-1}. r x}
rng:{(0 1 .[=]x)first/range x}  / range: atom for .[=]x
pts:{.[,']rng each flip x}  / points of a vent
plot:{count each group raze pts each x}
chp:{count where 1<x}  / count hot points

a[`$"5-1"]:chp plot vents where {any .[=]x} each vents
a[`$"5-2"]:chp plot vents

/ Day 6
lf:@[9#0;;1+] value first read 6
a[`$("6-1";"6-2")]:sum each @[;80 256] 256{@[1 rotate x;6;+;first x]}\lf

/ Day 7
/ cp:16 1 2 0 4 2 7 1 2 14 / crab positions
/ cp:value first read0`:day7.txt
/ a[`$"7-1"]:min sum abs til[1+max cp]-/:cp
/ a[`$"7-2"]:min sum((sum 1+til@)'')abs til[1+max cp]-/:cp

cd:count each group value first read 7  / crab distribution
frd:(min;max)@\:key cd  / full range of destinations
fc:{sum(value x)*y abs z-key x}[cd;;] / fuel cost of moving to position z
bs:{?[;y;m]1 not\.[<]x each 0 1+m:floor med y}  / halve range y with fn x
sl:{[f;n;r]{neg[x]>.[-]y}[n;] bs[f;]/r}  / short list
a[`$"7-1"]:min fc[::] each rng sl[fc[::];5;] frd
fm:sums til 1+max frd
a[`$"7-2"]:min fc[fm] each rng sl[fc[fm];5;] frd

/ Day 8
notes:flip`sample`signal!" "vs''trim each("**";"|")0:read 8
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

/ Day 9
hm:read 9  / heightmap
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

/ Day 10
subsys:read 10
tkn:"()[]{}<>" / tokens
/(`,`$2 cut tkn),'(subsys 1#2),{sums sum x}each 1 -1*/:2 cut tkn=\:subsys 2
opn:"([{<"; cls:")]}>"
prs:{[str;stk] c:str 0; / parse string with stack
  $[c in opn;(1_str;stk,c);opn[cls?c]=last stk;(1_str;-1 _ stk);(str;stk)] }.
pr:('[prs/;(;"")]) each subsys
a[`$"10-1"]:sum (cls!3 57 1197 25137) 2 first'/pr
com:(opn!cls)reverse each{y where 0=ce x}. flip pr / completions
a[`$"10-2"]:"j"$med({y+5*x}/)each 1+cls?com

/ Day 11
o:"0123456789"?raze oct:read 11 / octopus vector 
off:except[;enlist 0 0]{x cross x}til[3]-1 / neighbor offsets
nbr:{c:off+\:y;x sv/:c where all flip[c]within'0,'x-1}[shp oct]each .[cross]til each shp oct / neighbor indexes for o
flash:{i:where[x>9]except y; (@[x;raze nbr i;1+];y,i)}. / flash x where hot except at y
step:{({x*x<10};'[y+;count])@'flash over (x+1;0#0)}.  / [energy;# accumulated flashes]
a[`$"11-1"]:@[;1] 100 step/(o;0)
a[`$"11-2"]:-[;1] count {any 0<first x} step\(o;0)

/ Day 12
/ map:delete end from group .[!]flip{x,reverse each x}`$"-"vs/:read 12
map:.[!](key;'[except'[;`start];value])@\:delete end from group .[!]flip{x,reverse each x}`$"-"vs/:read 12
/ xplr:{[m;sc;r] / explore map; small caves; routes
/   (r where`end=last each r),raze r,/:'(m last each r)except'r inter\:sc
/   } [map; {x where(first each string x)in .Q.a}key map] / explore
/ a[`$"12-1"]:count (xplr/) 2 enlist/`start

sc:{x where(first each string x)in .Q.a}key[map]except`start / small caves
xplr:{[m;sc;f;r] / explore map; small caves; routes
  (r where`end=last each r),raze r,/:'(m last each r)except'r f\:sc
  } [map;sc;] / explore
a[`$"12-1"]:count (xplr[inter]/) 1 1#`start
a[`$"12-2"]:count (xplr[{$[2 in(ce group x)@y;x inter y;()]}]/) 1 1#`start

/ Day 13
`pts`folds set'('[reverse;value]';1_)@'{(0,where 0=ce x)_ x}read 13
p1:((1+max pts)#0b) .[;;:;1b]/pts  / page one
fold:{f:(::;flip)@"yx"?y@11;n:value 13_y;f .[or](::;reverse)@'(1 neg\n)#\:f x} / fold x according to y
a[`$"13-1"]:sum raze fold[p1;first folds]

/ Day 14
`pt`pir set'(first;2_)@\:read 14 / polymer template; polymer insertion rules
ird:.[!]flip{(x 0 1;lower[x 6],x 1)}each pir / insertion rules dictionary
air:{upper 1_raze {$[count r:ird o:y,x;r;o]} prior x} / apply insertion rules
a[`$"14-1"]:.[-](max;min)@\:ce group 10 air/pt
/ a[`$"14-2"]:.[-](max;min)@\:ce group 40 air/pt  // ouch

/ solution by András Dőtsch
//1
pairs:2#'-2_(1_)\  / composition
pm:{x!x}pairs pt
pm,:(!). flip pir@\:(0 1;0 6 1)
f:{""{(-1_x),pm y}/pairs x}
ws:count@'group@
score:(-).(max;min)@\:
a[`$"14-1a"]:score ws 10 f/ pt
//2
T:ws pairs pt
PM:{x!{(1#x)!1#1}@'x}pairs pt
PM,:{x!1 1}@' (!). flip pir@\:(0 1;(0 6;6 1))
F:{value[x] wsum PM key x}
WS:{div[;2] (ws(first pt;last pt)) + value[x] wsum ws@'key x}
a[`$"14-2a"]:score WS 40 F/ T 

/ Day 15
rm:read 15 / risk map

show a
-1 "13-2:";
-1 ".#"p1 fold/folds;

/
/-------------------------------------------------