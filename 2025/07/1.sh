#!/bin/bash

# For starters, half these lines are just filler to stretch things vertically.
# Ignore lines with no splitters:
input=$( grep -vP '^\.+$' "${1}" )

declare -a grid
while read LINE; do
  grid[${#grid[@]}]="${LINE}"
done <<<"${input}"

splits=0
declare -A beams # Basically a set.  Keys are the index of beam locations.
# Add the first beam
pos=$(grep -bo S <<<"${grid[0]}")
beams[${pos/%:S/}]=1

# Process 1 line per loop
for row in ${grid[@]}; do
  for beam in ${!beams[@]}; do
    if [[ "${row:${beam}:1}" == '^' ]]; then
      splits=$((splits+1))
      unset beams[${beam}]
      beams[$((beam-1))]=1
      beams[$((beam+1))]=1
    fi
  done
done

# Print all the array keys
echo "Beams at positions: ${!beams[@]}"
echo "Total splits: ${splits}"
