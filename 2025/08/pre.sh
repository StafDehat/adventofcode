#!/bin/bash

input=$( cat "${1}" )

declare -a boxes
while read x y z; do
  boxes[${#boxes[@]}]="${x} ${y} ${z}"
done <<<"${input//,/ }"

function getSpan() {
  local xA="${1}"
  local yA="${2}"
  local zA="${3}"
  local xB="${4}"
  local yB="${5}"
  local zB="${6}"
  local xDiff=$(( xA-xB ))
  local yDiff=$(( yA-yB ))
  local zDiff=$(( zA-zB ))
  bc -l <<<"scale=2; sqrt( ${xDiff#-}^2 + ${yDiff#-}^2 + ${zDiff#-}^2 )"
}

# Calculate distance between all points
for boxA in $( seq 0 $((${#boxes[@]}-1)) ); do
  echo "$(date +'%F_%T') Calculating distances for box ${boxA}" >&2
  for boxB in $( seq $((boxA+1)) $((${#boxes[@]}-1)) ); do
    distance=$( getSpan ${boxes[${boxA}]} \
                        ${boxes[${boxB}]} )
    echo "${distance} ${boxA} ${boxB}"
  done
done

