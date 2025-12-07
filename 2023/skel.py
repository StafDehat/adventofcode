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

# Nuke those newlines
lines = [line.strip() for line in lines]

# Debug function, for easier printing
def print_r(lst):
  length_list = [len(str(element)) for row in lst for element in row]
  column_width = max(length_list)
  for row in lst:
    row = "".join(str(element).rjust(column_width + 2) for element in row)
    print(row)
#end print_r()


#
# The Meat

