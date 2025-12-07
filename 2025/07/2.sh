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
  for beamPos in ${!beams[@]}; do
    if [[ "${row:${beamPos}:1}" == '^' ]]; then
      splits=$((splits+1))
      beams[$((beamPos-1))]=$(( ${beams[$((beamPos-1))]} + ${beams[${beamPos}]} ))
      beams[$((beamPos+1))]=$(( ${beams[$((beamPos+1))]} + ${beams[${beamPos}]} ))
      unset beams[${beamPos}]
    fi
  done
done

# Print all the array keys
echo "Total splits: ${splits}"
echo "Beams at positions:"
for beamPos in ${!beams[@]}; do
  echo "  ${beamPos}: ${beams[${beamPos}]}"
done | sort -n
echo -n "Total paths: "
echo "${beams[@]}" | xargs -n1 | paste -sd+ | bc

