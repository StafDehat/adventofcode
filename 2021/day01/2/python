#!/usr/bin/env python3

import sys

# Debug function
def debug(output):
  print(output)
#end debug()

# CLI arg, input file
if len(sys.argv) != 2:
  print("ERR: Expect =1 arg; the file containing input")
  exit(1)
#end if
try:
  with open(sys.argv[1], 'r') as input:
    lines = input.readlines()
except:
  print("ERR: Failed to open input file (%s)" % sys.argv[1])
  exit(1)
#end try

#
# The Meat

# Convert the list of str to int, up front
lines = list(map(int, lines))

# Start by building a list of 3-item sums (aka:triads)
triad = 0
triads = []
for index in range(0,len(lines)-2):
  triads.append( sum(lines[index:index+3]) )
#end for

# Now do the same counting, using our new list
numInc = 0
newSum = 0
oldSum = triads[0]

debug("Starting at triad: " + str(oldSum))

for triad in triads[1:]:
  newSum = triad
  if newSum > oldSum:
    numInc += 1
    debug(str(newSum) + " (increased)")
  elif newSum < oldSum:
    debug(str(newSum) + " (decreased)")
  else:
    debug(str(newSum) + " (no change)")
  #end if
  oldSum = newSum
#end for

print("Total increases: ", str(numInc))
