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

def getButton(digits, txt):
  bits = []
  for x in range(digits):
    if str(x) in txt:
      bits.append(1)
    else:
      bits.append(0)
  return bits

def listDiff(lst1, lst2):
  return [x-y for x,y in zip(lst1,lst2)]


def solve(inCount, inGoal, inButtons):
  print()
  print("Goal:")
  print(inGoal)
  print("Buttons:")
  [print(button) for button in inButtons]

  queue=list()
  queue.append( [inCount, inGoal, inButtons] )

  while True:
    fdsa=queue.pop(0)
    count=fdsa[0]
    goal=fdsa[1]
    buttons=fdsa[2]

    # Impossible state?
    if ( any(x<0 for x in goal) ):
      continue
    # Already solved?
    if (sum(goal) == 0):
      print(count)
      return count

    # Shortcut
    # If any columns have only a single '1', short-circuit that first
    heatmap=[sum(x) for x in zip(*buttons)]
    if 1 in heatmap:
      # Which column is fulfilled by only 1 button
      col=heatmap.index(1)
      # How many times to push the button
      presses=goal[col]
      # Which button to push
      for button in buttons:
        if (button[col]==1):
          queue.append( [count+presses,
                         [x-y*presses for x,y in zip(goal,button)],
                         [x for x in buttons if x != button]] )
          break
    #End Shortcut

#    # Branch on whichever non-zero column has the fewest contributing buttons
#    col=heatmap.index( min([x for x in heatmap if x>1]) )
#    for button in [button for button in buttons if button[col] == 1]:
#      queue.append( [count+1,
#                     [x-y for x,y in zip(goal,button)],
#                     buttons] )


    # Branch on whichever column has the smallest sum
    col=goal.index( min([x for x in goal if x > 0]) )
    for button in [button for button in buttons if button[col] == 1]:
      queue.append( [count+1,
                     [x-y for x,y in zip(goal,button)],
                     buttons ] )


#    # Branch on combination of the two?
#    #col=goal.index( min([x for x in goal if x > 0]) )
#    # Smallest sum:
#    smol=min([x for x in goal if x > 0])
#    cols=[i for i, x in enumerate(goal) if x == smol]
#    # Pick a column
#    smol=min([x for i,x in enumerate(heatmap) if i in cols])
#    for button in [button for button in buttons if button[col] == 1]:
#      queue.append( [count+1,
#                     [x-y for x,y in zip(goal,button)],
#                     [button for button in buttons if button[col]!=0] ] )

    

  # Optimization notes:
  # Would it be helpful to identify the max possible presses of each button?
  # It's probably best to branch on whichever column has the fewest contributing buttons
  # Should I branch on...
  #  * whichever column has the smallest sum?
  #  * whichever column has the fewest contributing buttons? <<Extension of Shortcut, above
  #  * whichever button contributes to the most columns?     <<No.  That button may be unused.
  #  * just a BFS?  Push a button, queue result, repeat for each button? <<No.  Too slow.
  return 0
#end solve()

#
# The Meat
total=0

for line in lines:
  # Convert 'goal' to a list of ints
  goal = list(map(int,line[line.find('{'):-1].replace("{","").split(",")))

  # Convert buttons to lists of ints
  digits = len(goal)
  buttons = list()
  for txt in line.split()[1:-1]:
    buttons.append(getButton(digits,txt))


  # Solve
  total+=solve(0, goal, buttons)

print(total)

#print([x+y for x,y in zip(lst1,lst2)])


