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

# Strip those damn trailing newlines
lines = [line.strip() for line in lines]


#
# The Meat

def create_getXthChar(x):
  def getXthChar(str):
    return str[x]
  return getXthChar
#end create_getXthChar

def getModeBit(lst, pos):
  from statistics import multimode
  # Prefer the larger-value mode (ie: 1 over 0)
  return int(max(multimode(
           list(map(create_getXthChar(pos),lst))
         )))
#end getModeBit()

# O2 follows numbers matching the *most* bits
def getO2rating(lst):
  return r_getO2rating(lst, 0)
def r_getO2rating(lst, pos):
  # Stop conditions
  if len(lst) <= 1:
    return lst[0]
  # Prep for next iteration
  o2bit = getModeBit(lst, pos)
  sublst = [line.strip() for line in lst if int(line[pos]) == o2bit]
  # Recurse
  return r_getO2rating(sublst, pos+1)
#end r_getO2rating()

# CO2 follows numbers matching the *least* bits
def getCO2rating(lst):
  return r_getCO2rating(lst, 0)
def r_getCO2rating(lst, pos):
  # Stop conditions
  if len(lst) <= 1:
    return lst[0]
  # Prep for next iteration
  co2bit = not getModeBit(lst, pos)
  sublst = [line.strip() for line in lst if int(line[pos]) == co2bit]
  # Recurse
  return r_getCO2rating(sublst, pos+1)
#end r_getCO2rating()

o2 = getO2rating(lines)
co2 = getCO2rating(lines)

print("O2 Rating: ", o2)
print("CO2 Rating:", co2)
print("Life Support Rating:", int(o2,2)*int(co2,2))
