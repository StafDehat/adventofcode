#!/bin/bash

input=$( cat "${1}" )

dialPre=50
dialPost=0
count=0

#while read val; do
#  # Eliminate full 360-loops:
#  count=$(( count + ${val#-}/100 ))
#  val=$(( val%100 ))
#
#  dialPost=$(( dialPre+val ))
#  if [[ ${dialPost} -ge 100 ]]; then
#    count=$(( count+1 ))
#    dialPost=$(( dialPost - 100 ))
#  elif [[ ${dialPost} -eq 0 ]]; then
#    count=$(( count+1 ))
#  elif [[ ${dialPost} -lt o ]]; then
#    count=$(( count+1 ))
#    dialPost=$(( 100 + dialPost ))
#  fi
#  dialPre=${dialPost}
#done < <(sed -e 's/L/-/' -e 's/R//' <<<"${input}")
#echo "${count}"
#echo

while read val; do
  # Eliminate full 360-loops:
  loops=$(( ${val#-}/100 ))
  count=$(( count + loops ))
  val=$(( val%100 ))
  # Now we're guaranteed to only cross 0 at-most, 1 more time

  # Where do we end up?
  dialPost=$(( dialPre + val ))

  # If we're negative now, we crossed 0
  if [[ ${dialPost} -lt 0 ]]; then
    if [[ ${dialPre} -ne 0 ]]; then
      count=$(( count + 1 ))
    fi
    dialPost=$(( 100 + dialPost ))
  elif [[ ${dialPost} -eq 0 ]]; then
    count=$(( count + 1 ))
  elif [[ ${dialPost} -ge 100 ]]; then
    count=$(( count + 1 ))
    dialPost=$(( dialPost-100 ))
  fi

  echo "Start:${dialPre}, Change:${val}, End:${dialPost}, Count:${count}"

  dialPre=${dialPost}
done < <(sed -e 's/L/-/' -e 's/R//' <<<"${input}")
echo $count



