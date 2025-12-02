#!/bin/bash

input=$( cat "${1}" )

function sum() {
  local input
  if [[ "${#}" -gt 0 ]]; then
    input=${@}
  else
    input=$( cat )
  fi
  {
    echo -n "0";
    for x in ${input}; do
      echo -n " + ${x}"
    done;
    echo;
  } | bc -l
}

function getInvalids() {
  #echo "Start getInvalids()"
  local min="${1}"
  local max="${2}"
  local minLen=$( wc -c <<<"${min}" )
  local maxLen=$( wc -c <<<"${max}" )
  # If $min & $max are same order of magnitude, just forward the call
  if [[ ${minLen} -eq ${maxLen} ]]; then
    getInvalidsInMag ${min} ${max}
    return 0
  fi
  # split range into sub-ranges, by magnitude
  local tmpMin=${min}
  local tmpMax
  for mag in $( seq $((minLen-1)) $((maxLen-1)) ); do
    tmpMax=$(( 10**${mag}-1 )) # MaxNum within Magnitude
    if [[ ${tmpMax} -gt ${max} ]]; then
      tmpMax=${max}
    fi
    getInvalidsInMag ${tmpMin} ${tmpMax}
    tmpMin=$(( 10**${mag} )) # MinNum in next Magnitude
  done
}

function getInvalidsInMag() {
  #echo "Start getInvalidsInMag()"
  local min="${1}"
  local max="${2}"
  #echo "Testing ${min}-${max}"
  local len=$( wc -c <<<"${min}" )
  # If len is odd, it can't be ${x}${x} - that'd be even
  # Invert that though, 'cause of trailing "\r"
  if [[ $((len%2)) -eq 0 ]]; then
    return 0
  fi
  #
  # Len=even, so find the invalids
  local halfLen=$((len/2)) #Integer-division drops remainder
  # Snap the front half, count up from there:
  local front
  read -n${halfLen} front <<<"${min}"
  # Full range of $front - short-circuit when ${x}y > ${max}
  # Example: min=123456 becomes $(seq 123 999)
  for x in $( seq ${front} $((10**${halfLen}-1)) ); do
    if [[ "${x}${x}" -lt ${min} ]]; then
      continue
    fi
    if [[ "${x}${x}" -gt ${max} ]]; then
      return 0
    fi
    echo "${x}${x}"
  done
}

while read min max; do
  #echo "${min}-${max}"
  getInvalids ${min} ${max}
done < <(sed -e 's/-/ /g' -e 's/,/\n/g' <"${1}") \
 | sum



