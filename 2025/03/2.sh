#!/bin/bash

input=$( cat "${1}" )

function getLargestDigit() {
  fold -b1 <(echo "${1}") | sort -n | tail -n 1
}
function getSmallestDigit() {
  fold -b1 <(echo "${1}") | sort -n | head -n 1
}

function getMaxJoltage() {
  local input="${1}"
  local -a jolts
  local leftUsed=0
  local digitsNeeded=12
  local a
  local aPos=-1
  while true; do
    # Stop building if we already have all 12:
    if [[ "${digitsNeeded}" -le 0 ]]; then
      break
    fi
    # Gotta pick digits from the substring that's:
    #  1) Right of the last-picked digit
    #  2) Left enough to leave room for the remaining picks
    if [[ "${digitsNeeded}" -gt 1 ]]; then
      a=$( getLargestDigit "${input:${leftUsed}:-$((digitsNeeded-1))}" )
    else
      a=$( getLargestDigit "${input:${leftUsed}}" )
    fi
    aPos=$( grep -bo "${a}" <<<"${LINE:${leftUsed}}" | head -n 1 | cut -d: -f1 )
    leftUsed=$(( leftUsed+aPos+1 ))
    jolts+="${a}"
    : $((digitsNeeded--))
  done
  echo "${jolts[@]}"
}

while read LINE; do
  getMaxJoltage "${LINE}"
done <<<"${input}" \
 | paste -sd+ | bc

