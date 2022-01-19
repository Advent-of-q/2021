toc:("**";csv)0:`:toc.csv

pg:{[day;ttl]
  md:"\n"vs"# Day",day," – "	,ttl,"\n\n## Solution\n\nby Péter Gyorok\n\n```q\n";
  md,:read0 `$":../../gyorokpeter/public/aoc2021/day",day,".q";
  md,:"\n"vs"\n```\n\n";
  tgt:`$":docs/",day,"-",lower @[ttl;where ttl=" ";:;"-"],".md";
  tgt 0: md }