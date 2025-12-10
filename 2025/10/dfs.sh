#!/bin/bash

input=$( cat "${1}" )

function min() {
  tr '[:blank:]' '\n' <<<"${@}" | sort -n | head -n 1
}

function solve() {
  local goal="${1}"
  local panel="${2}"
  shift 2
  local -a buttons=( ${@} )
  # Already solved.  Return 0 pushes-to-solve.
  if [[ ${goal} -eq ${panel} ]]; then
    echo "Solved" >&2
    echo 0
    return
  fi
  # No buttons left to push.  Return NULL.
  if [[ ${#buttons[@]} -le 0 ]]; then
    echo "Out of buttons" >&2
    return
  fi

  # Push each button, solve their result, return the lowest result, +1
  solutions=$(
    for button in ${buttons[@]}; do
      solve ${goal} $((panel^button)) ${buttons[@]#${button}}
    done
  )
  best=$( min ${solutions} )
  echo $((best+1))
}

while read LINE; do
  date >&2
  unset goal buttons
  # Convert light-panel goal into a decimal bitmask:
  tmp=$( grep -Po '\[.*\]' <<<"${LINE}" | tr -d '[]' | tr '\.#' '01' ) # Make binary
  digits=$(($(wc -c <<<"${tmp}")-1))
  goal=$(( 2#${tmp} )) # Convert to decimal
  # Convert buttons into decimal bitmasks:
  for button in $( grep -Po '\([^\)]*\)' <<<"${LINE}" ); do
    unset tmp
    for i in $( seq 0 $((digits-1)) ); do
      # There are never >10 lights.  Safe to assume single-digits.
      [[ "${button}" =~ ${i} ]] && tmp="${tmp}1" || tmp="${tmp}0"
    done
    buttons[${#buttons[@]}]=$((2#${tmp}))
  done

  solve ${goal} 0 ${buttons[@]}
done <<<"${input}" | paste -sd+ | bc

# xor: $(( x ^ y ))

