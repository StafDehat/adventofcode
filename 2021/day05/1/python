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


