#!/bin/bash

input=$( cat "${1}" )

function display() {
  for row in $(seq 0 $((numRows-1)) ); do
    line=""
    for col in $(seq 0 $((numCols-1)) ); do
      if [[ "${grid["${row},${col}"]}" == 0 ]]; then
        line+='.'
      else
        line+='@'
      fi
    done
    echo "${line}"
  done
}

# Take coords - return how many neighbours are paper
function countBlock() {
  local row="${1}"
  local col="${2}"
  local y x
  local neighbours=0
  if [[ "${row}" -gt 0 ]]; then
    # Count 3 in the row above
    y=$((row-1))
    [[ ${col} -gt 0 ]] && \
      neighbours=$(( neighbours + ${grid["${y},$((col-1))"]} ))
    neighbours=$(( neighbours + ${grid["${y},${col}"]} ))
    [[ ${col} -lt $((numCols-1)) ]] && \
      neighbours=$(( neighbours + ${grid["${y},$((col+1))"]} ))
  fi
  # Count my row (left & right)
  [[ ${col} -gt 0 ]] && \
    neighbours=$(( neighbours + ${grid["${row},$((col-1))"]} ))
  [[ ${col} -lt $((numCols-1)) ]] && \
    neighbours=$(( neighbours + ${grid["${row},$((col+1))"]} ))
  # Count 3 in row below
  if [[ "${row}" -lt $((numRows-1)) ]]; then
    y=$((row+1))
    [[ ${col} -gt 0 ]] && \
      neighbours=$(( neighbours + ${grid["${y},$((col-1))"]} ))
    neighbours=$(( neighbours + ${grid["${y},${col}"]} ))
    [[ ${col} -lt $((numCols-1)) ]] && \
      neighbours=$(( neighbours + ${grid["${y},$((col+1))"]} ))
  fi
  echo "${neighbours}"
}

function demoRural() {
  local threshold="${1}"
  local numRural=0
  local neighbours
  for row in $( seq 0 $((numRows-1)) ); do
    for col in $( seq 0 $((numCols-1)) ); do
      # Don't bother counting neighbours of unoccupied spaces
      if [[ ${grid["${row},${col}"]} -eq 0 ]]; then
        continue
      fi
      neighbours=$( countBlock ${row} ${col} )
      if [[ ${neighbours} -lt ${threshold} ]]; then
        # It was a rural house - demolish it
        grid["${row},${col}"]=0
      fi
    done
  done
}

# Build our data structure - a "2d" hash
declare -A grid
numRows=$( wc -l <<<"${input}" )
numCols=$(( $( head -n 1 <<<"${input}" | wc -c ) - 1 ))
for row in $( seq 0 $((numRows-1)) ); do
  read LINE
  for col in $( seq 0 $((numCols-1)) ); do
    read -n1 char
    if [[ "${char}" == "@" ]]; then
      grid["${row},${col}"]=1
    else
      grid["${row},${col}"]=0
    fi
  done <<<"${LINE}"
done <<<"${input}"


#display


startingRolls=$( echo "${grid[@]}" | tr ' ' '+' | bc )
echo "Started with ${startingRolls} rolls of paper"

# Count buildings with <4 neighbours
while true; do
  numRollsA=$( echo "${grid[@]}" | tr ' ' '+' | bc )
  demoRural 4
  numRollsB=$( echo "${grid[@]}" | tr ' ' '+' | bc )
  echo "Removed $((numRollsA-numRollsB)) rolls this iteration - ${numRollsB} remaining"
  [[ ${numRollsA} -eq ${numRollsB} ]] && break
  numRollsA=${numRollsB}
  unset numRollsB
done

finishingRolls=$( echo "${grid[@]}" | tr ' ' '+' | bc )
echo "Finished with ${finishingRolls} rolls of paper"

echo "Total removed: $((startingRolls-finishingRolls))"

