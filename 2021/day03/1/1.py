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

def create_getXthChar(x):
  def getXthChar(str):
    return str[x]
  return getXthChar
#end create_getXthChar

# Gamma = most common bit
def getGamma(diag):
  from statistics import mode
  gamma = []
  for pos in range(0,len(diag[0].strip())):
    gamma.append(
      mode( list(
        map(create_getXthChar(pos),diag))
      )
    )
  #end for  
  return ''.join(gamma)
#end getGamma()

# Epsilon = least common bit
#    aka: ~gamma
def getEpsilon(gamma):
  return ''.join([str(int(char,2)^1) for char in gamma])
#end getEpsilon()

gamma = getGamma(lines)
epsilon = getEpsilon(gamma)

print("Gamma:  ", gamma)
print("Epsilon:", epsilon)

print( "Power Consumption:",
       int(gamma,2)*int(epsilon,2) )



