#!/bin/bash

input=$( cat "${1}" )

vals=$( grep -P '^[ \d]+$' <<<"${input}" )
set -o noglob
ops=( $(grep '+\|*' <<<"${input}") )

declare -A grid

numCols=$(( $(head -n 1 <<<"${vals}" | wc -c) - 1 ))
numRows=$( wc -l <<<"${vals}" )

# Shove all the characters into a 2d array
row=0
while IFS='' read LINE; do
  for i in $( seq 0 $((numCols-1)) ); do
    char=$( echo "${LINE:${i}:1}" )
    grid["${row},${i}"]="${char}"
  done
  row=$(( row + 1 ))
done <<<"${vals}"

# Print the 2d array transposed
transposed=$( 
  for x in $( seq 0 $((numCols-1)) ); do
    str=""
    for y in $( seq 0 $((numRows-1)) ); do
      str="${str}${grid["${y},${x}"]}"
    done
    echo -n "${str} "
    grep -qP '^\s*$' <<<"${str}" && echo
  done
)

x=0
while read LINE; do
  op=${ops[${x}]}
  xargs -n 1 echo <<<"${LINE}" | paste -sd"${op}" | bc
  x=$((x+1))
done <<<"${transposed}" | \
 paste -sd+ | bc



