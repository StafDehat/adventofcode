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
numInc = 0
newDepth = 0
oldDepth = int(lines[0])

debug("Starting at depth: " + str(oldDepth))

for line in lines[1:]:
  newDepth = int(line)
  if newDepth > oldDepth:
    numInc += 1
    debug(str(newDepth) + " (increased)")
  else:
    debug(str(newDepth) + " (decreased)")
  #end if
  oldDepth = newDepth
#end for

print("Total increases: ", str(numInc))
