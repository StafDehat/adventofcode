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

# Input: 5, 4
# Output: [ 0, 1, 0, 1 ]
def int2bitlist(num, digits):
  return list(map(int,list(format(num,"0"+str(digits)+"b"))))

# Input: (38, 59), 6
# Output: [2, 1, 1, 1, 2, 1]
def getDeductions(buttons, digits):
  return [sum(x) for x in zip(*[int2bitlist(x,digits) for x in buttons])]


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
def getSolutions(goal, buttons):
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


def solve(goal, buttons):
  # Already solved?
  if all(x==0 for x in goal):
    return 0
  # Impossible?
  if min(goal) < 0:
    return 999999


#Assessing solution:
#(62, 59, 24)
#Deductions:
#[2, 3, 3, 1, 2, 1]
#Even leftovers:
#[8, 8, 8, 4, 8, 4]
#New goal
#[4, 4, 4, 2, 4, 2]
#Odds: 0 (000000)


# If they're all even, push none & halve?


  digits=len(goal)
  # Make "panel" from the odd numbers in the goal
  tmp=''.join(['0' if x%2==0 else '1' for x in goal])
  oddMask=int(tmp,2)
  print("Odds: %s (%s)" % (oddMask,tmp))

  print("Buttons:")
  print(buttons)

  # Solve 1 step
  solves=[999999]
  print("Solutions to %s" % (tmp))
  solutions = getSolutions(oddMask,buttons)
  if len(solutions) < 1:
    return 999999
  for solution in solutions:
    print(solution)
  for solution in solutions:
    print("Assessing solution:")
    print(solution)

    deductions=getDeductions(solution,digits)
    print("Deductions:")
    print(list(deductions))

    print("Even leftovers:")
    print([int((x-int(y))) for x,y in zip(goal,deductions)])

    newGoal=[int((x-int(y))/2) for x,y in zip(goal,deductions)]
    print("New goal")
    print(newGoal)

    # Redundant, I think, due to the negative check already above
    if any(i > j for i, j in zip(deductions, goal)):
      return 999999

    solves.append(len(solution) + ( 2 * solve(newGoal, buttons) ))

  return min(solves)


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
  result=solve(goal,buttons)
  print("Solved in %s presses" % (result))
  total+=result

print(total)




