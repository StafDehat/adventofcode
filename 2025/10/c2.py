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

def solvePattern(goal, ibuttons):
  queue = []
  queue.append( (0, goal, 0, ibuttons) )
  while True:
    next=queue.pop(0)
    numPushes=next[0]
    goal=next[1]
    panel=next[2]
    buttons=next[3]
    if ( panel == goal ):
      print(numPushes)
      buttonsPushed = [x for x in ibuttons if x not in buttons]
      return [ numPushes, buttonsPushed ]
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

def solve(goal, buttons):
  # Already solved?
  if all(x==0 for x in goal):
    return 0

  # Make "panel" from the odd numbers in the goal
  tmp=''.join(['0' if x%2==0 else '1' for x in goal])
  oddMask=int(tmp,2)
  print("Odds: %s (%s)" % (oddMask,tmp))

  print("Buttons:")
  print(buttons)

  # Solve 1 step
  result = solvePattern(oddMask, buttons)
  numPushed=result[0]
  butPushed=result[1]
  print("Buttons pushed: %s" % (numPushed))
  print(butPushed)
  #sum+=result[0]

  # newGoal = ( goal - buttonsPushed ) / 2
  digits=len(goal)
  deductions=format(sum(result[1]),"0"+str(digits)+"b")[-digits:]
  newGoal=[int((x-int(y))/2) for x,y in zip(goal,deductions)]

  print(list(deductions))
  print(newGoal)

  return numPushed + 2*solve(newGoal, buttons)


#
# The Meat
total=0
for line in lines:
  # Convert 'goal' to decimal-represented bitStr
  goal = list(map(int,line[line.find('{'):-1].replace("{","").split(",")))
  print("Goal:   %s" % (goal))

  # Convert buttons to decimal-represented bitStrs
  digits = len(goal)
  buttons = list()
  for txt in line.split()[1:-1]:
    buttons.append(getButton(digits,txt))

  # Solve
  total+=solve(goal, buttons)

print(total)




