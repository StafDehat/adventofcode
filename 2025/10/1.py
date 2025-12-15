#!/usr/bin/env python3
  
import sys
import itertools

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

# True if pressing every 'buttons' solves goal
def isSolution(goal, buttons):
  result = 0
  for button in buttons:
    result=result^button
  if ( result == goal ):
    return True
  return False

# Return a list of all possible combinations of >1 button(s)
def combinations(buttons):
  result = []
  for x in range(1,len(buttons)+1):
    result.extend(list(itertools.combinations(buttons,x)))
  return result

# Get all possible solutions to goal, not just the fewest pushes
def solutions(goal, buttons):
  result = []
  for attempt in combinations(buttons):
    if isSolution(goal,attempt):
      result.append(attempt)
  return result

# Binarify a button string
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
total=0
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
  combos=solutions(goal, buttons)
  print("All solutions:")
  print(combos)

  print("Best solution:")
  print(min([len(x) for x in combos]))
  total+=min([len(x) for x in combos])

print(total)




