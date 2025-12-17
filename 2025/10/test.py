#!/usr/bin/env python3

import sys


solution=[6, 28]
digits=5
binSol=[list(format(x,"0"+str(digits)+"b")) for x in solution]
binSol=[list(map(int,x)) for x in binSol]
print([sum(x) for x in zip(*binSol)])


def int2bitlist(num, digits):
  return list(map(int,list(format(num,"0"+str(digits)+"b"))))

print(int2bitlist(5,4))


#zip([list(format(x,"0"+str(digits)+"b")) for x in solution])



