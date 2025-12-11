#!/bin/bash

input=$( cat "${1}" )

# File-based queue
queueFile="tmpfile"
touch ${queueFile}
function push() {
  #echo "Pushing: ${@}" >&2
  echo "${@}" >> "${queueFile}"
}
function pop() {
  #echo "Popping: $(head -n 1 "${queueFile}")" >&2
  head -n 1 "${queueFile}"
  sed -i '1d' "${queueFile}"
}

while read LINE; do
  unset goal buttons
  # Convert light-panel goal into a decimal bitmask:
  tmp=$( grep -Po '\[.*\]' <<<"${LINE}" | tr -d '[]' | tr '\.#' '01' ) # Make binary
  digits=$(($(wc -c <<<"${tmp}")-1))
  goal=$(( 2#${tmp} )) # Convert to decimal
  echo "$( grep -Po '\[.*\]' <<<"${LINE}" ) == ${tmp} (${goal})" >&2
  # Convert buttons into decimal bitmasks:
  for button in $( grep -Po '\([^\)]*\)' <<<"${LINE}" ); do
    unset binNum
    for i in $( seq 0 $((digits-1)) ); do
      # There are never >10 lights.  Safe to assume single-digits.
      [[ "${button}" =~ ${i} ]] && binNum="${binNum}1" || binNum="${binNum}0"
    done
    buttons[${#buttons[@]}]=$((2#${binNum}))
    echo "${button} == ${binNum} ($((2#${binNum})))" >&2
  done

  # Initialize the queue
  >"${queueFile}"
  push 0 ${goal} 0 ${buttons[@]}
  echo "Pushing initial state to queue: 0 ${goal} 0 ${buttons[@]}" >&2
  # BFS
  while true; do
    read numPushes goal panel other < <(pop)
    #echo "Popped: ${numPushes} ${goal} ${panel} ${other}" >&2
    unset buttons
    buttons=( ${other} )
    if [[ ${panel} -eq ${goal} ]]; then
      echo "Solved.  Unpressed buttons: ${other}" >&2
      echo ${numPushes}  # Print solution
      break
    fi
    for i in $( seq 0 $((${#buttons[@]}-1)) ); do
      button=${buttons[${i}]}
      other=$( echo ${buttons[@]} | sed 's/\(\s\|^\)'${button}'\(\s\|$\)/ /' )
      push $((numPushes+1)) ${goal} $((${panel}^${button})) ${other# }
      #echo "Pushed: $((numPushes+1)) ${goal} $((panel^button)) ${buttons[@]}" >&2
      #buttons[${i}]=${button}
    done
  done
done <<<"${input}" | paste -sd+ | bc

#rm -f "${queueFile}"

