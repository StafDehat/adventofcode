#!/bin/bash

input=$( cat "${1}" )

function getLargestDigit() {
  fold -b1 <(echo "${1}") | sort -n | tail -n 1
}

function getMaxJoltage() {
  local input="${1}"
  local a b aPos
  # The furthest-right digit *can't* be the first choice, or we wouldn't have anything
  #   left to be the second choice.
  a=$( getLargestDigit "${input::-1}" )
  # Second digit must occur right-of the first
  aPos=$( grep -bo "${a}" <<<"${LINE}" | head -n 1 | cut -d: -f1 )
  b=$( getLargestDigit "${input:$((aPos+1))}" )
  echo "${a}${b}"
}

while read LINE; do
  getMaxJoltage "${LINE}"
done <<<"${input}" \
 | paste -sd+ | bc

