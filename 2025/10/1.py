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

def solve(goal, buttons):
  queue = []
  queue.append( (0, goal, 0, buttons) )
  while True:
    next=queue.pop(0)
    numPushes=next[0]
    goal=next[1]
    panel=next[2]
    buttons=next[3]
    if ( panel == goal ):
      print(numPushes)
      return numPushes
    for button in buttons:
      queue.append( ( numPushes+1, goal, panel^button, [x for x in buttons if x != button] ) )

def getButton(digits, txt):
  bitStr = ""
  for x in range(digits):
    if str(x) in txt:
      bitStr+="1"
    else:
      bitStr+="0"
  return int(bitStr,2)

#
# The Meat
sum=0
for line in lines:
  # Convert 'goal' to decimal-represented bitStr
  tmp = line[1:line.find(']')].replace('.','0').replace('#','1')
  goal = int(tmp,2)
  print("Goal:   %s (%s)" % (tmp, goal))

  # Convert buttons to decimal-represented bitStrs
  digits = len(tmp)
  buttons = list()
  for txt in line.split()[1:-1]:
    buttons.append(getButton(digits,txt))

  # Solve
  sum+=solve(goal, buttons)

print(sum)




