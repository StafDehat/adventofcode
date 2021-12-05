#!/usr/bin/env python3
  
import sys
import re

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

xPos = 0
yPos = 0
val = 0

for line in lines:
  val = int(re.search(r'\d+', line).group())
  if "forward" in line:
    xPos += val
    debug("Forward by " + str(val))
  elif "up" in line:
    yPos -= val
    debug("Up by " + str(val))
  elif "down" in line:
    yPos += val
    debug("Down by " + str(val))
  else:
    print("ERR: Unknown line")
  #end if
#end for

print(xPos, ", ", yPos)
print(xPos * yPos)
