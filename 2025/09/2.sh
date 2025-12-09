#!/bin/bash

input=$( cat "${1}" )
declare -a reds
declare -A redsI
while read LINE; do
  redsI[${LINE}]=${#reds[@]}
  reds[${#reds[@]}]="${LINE}"
done <<<"${input}"

function area() {
  local ax ay bx by
  local dx dy
  read ax ay <<<"${1//,/ }"
  read bx by <<<"${2//,/ }"
  dx=$(( ax - bx ))
  dy=$(( ay - by ))
  echo $(( (${dx#-}+1) * (${dy#-}+1) ))
}

function isInvalid() {
  local ix iy jx jy
  read ix iy <<<"${1/,/ }"
  read jx jy <<<"${2/,/ }"
  for k in $( seq 0 $((${#reds[@]}-1)) ); do
    # Are any other points $k between $i & $j?  That would invalidate $j.
    read kx ky <<<"${reds[${k}]/,/ }"
    [[ ${kx} -lt ${ix} ]] && return 1
    [[ ${ky} -lt ${iy} ]] && return 1
    [[ ${kx} -gt ${jx} ]] && return 1
    [[ ${ky} -gt ${jy} ]] && return 1
    # $j is still a candidate
    echo "Point ${kx},${ky} is within ${ix},${iy}:${jx},${jy} - invalid"
    return 0
  done
}

# For each red tile, traverse the list to find the largest-possible green box you can make
# Opposite corner needs to be red too
# Only need to test boxes stretching from ${i} to down/right
for i in $( seq 0 $((${#reds[@]}-1)) ); do
  echo "Checking for boxes with ${reds[${i}]} in top-left"
  # What's the largest green area I can form using ${i} as the top-left corner?
  read ix iy <<<"${reds[${i}]/,/ }"
  for j in $( seq 0 $((${#reds[@]}-1)) ); do
    # Don't test a red tile against itself
    [[ ${i} -eq ${j} ]] && continue

    # Any point above or left of me, I don't care
    read jx jy <<<"${reds[${j}]/,/ }"
    [[ ${jx} -lt ${ix} ]] && continue
    [[ ${jy} -lt ${iy} ]] && continue

    # Check to see if this pair is invalid due to other points within the area
    isInvalid ${reds[${i}]} ${reds[${j}]} && continue
    echo "$(area ${reds[${i}]} ${reds[${j}]}) ${reds[${i}]} ${reds[${j}]}"
  done
done


