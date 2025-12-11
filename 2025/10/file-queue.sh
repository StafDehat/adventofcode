#!/bin/bash

input=$( cat "${1}" )

# File-based queue
queueFile=$( mktemp )
function push() {
  echo "${@}" >> "${queueFile}"
}
function pop() {
  head -n 1 "${queueFile}"
  sed -i '1d' "${queueFile}"
}

while read LINE; do
  unset goal buttons
  # Convert light-panel goal into a decimal bitmask:
  tmp=$( grep -Po '\[.*\]' <<<"${LINE}" | tr -d '[]' | tr '\.#' '01' ) # Make binary
  digits=$(($(wc -c <<<"${tmp}")-1))
  goal=$(( 2#${tmp} )) # Convert to decimal
  # Convert buttons into decimal bitmasks:
  for button in $( grep -Po '\([^\)]*\)' <<<"${LINE}" ); do
    unset binNum
    for i in $( seq 0 $((digits-1)) ); do
      # There are never >10 lights.  Safe to assume single-digits.
      [[ "${button}" =~ ${i} ]] && binNum="${binNum}1" || binNum="${binNum}0"
    done
    buttons[${#buttons[@]}]=$((2#${binNum}))
  done

  # Initialize the queue
  >"${queueFile}"
  push 0 ${goal} 0 ${buttons[@]}
  # BFS
  while true; do
    read numPushes goal panel other < <(pop)
    unset buttons
    buttons=( ${other} )
    if [[ ${panel} -eq ${goal} ]]; then
      echo "Solved.  Unpressed buttons: ${other}" >&2
      echo ${numPushes}  # Print solution
      break
    fi
    for i in $( seq 0 $((${#buttons[@]}-1)) ); do
      button=${buttons[${i}]}
      unset buttons[${i}]
      push $((numPushes+1)) ${goal} $((panel^button)) ${buttons[@]}
      buttons[${i}]=${button}
    done
  done
done <<<"${input}" | paste -sd+ | bc

rm -f "${queueFile}"

