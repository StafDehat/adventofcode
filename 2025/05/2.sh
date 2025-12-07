#!/bin/bash

input=$( cat "${1}" )




function lowest() {
  xargs -n1 echo <<<"${@}" | sort -n | head -n 1
}
function highest() {
  xargs -n1 echo <<<"${@}" | sort -nr | head -n 1
}

#
# Return whether or not the two provided ranges overlap each other
function rangesOverlap() {
  local rangeA="${1}"
  local rangeB="${2}"
  local minA maxA minB maxB
  IFS='-' read minA maxA <<<"${rangeA}"
  IFS='-' read minB maxB <<<"${rangeB}"
  [[ ${minB} -ge ${minA} ]] && [[ ${minB} -le ${maxA} ]] && return 0
  [[ ${minA} -ge ${minB} ]] && [[ ${minA} -le ${maxB} ]] && return 0
  return 1
}

#
# Input: Two overlapping ranges
# Output: Single range - union of the two
function newRange() {
  echo "$(lowest ${@/-/ })-$(highest ${@/-/ })"
}

#
# Incorporate a new range into $newRange[], either
#   by appending a new range to the array, or by
#   adjusting the bounds of an existing range.
function incorporate() {
  local newMin=${1}
  local newMax=${2}
  local min max
  # Check if new range overlaps with any existing ranges:
  for x in $( seq 0 $((${#newRanges[@]}-1)) ); do
    IFS='-' read min max <<<"${newRanges[${x}]}"
    if rangesOverlap ${min}-${max} ${newMin}-${newMax}; then
      newRanges[${x}]=$( newRange "${min}-${max}" "${newMin}-${newMax}" )
      return 0
    fi
  done
  # If it was overlapping anything, we would have merged entries.
  # Since we got here, it's a brand-new range.  Append.
  newRanges[${#newRanges[@]}]="${newMin}-${newMax}"
}


oldRanges=$( grep -- - <<<"${input}" )
while true; do
  oldSize=$( wc -l <<<"${oldRanges}" )
  unset newRanges
  declare -a newRanges

  # Build newRanges
  while IFS='-' read min max; do
    incorporate ${min} ${max}
  done <<<"${oldRanges}"

  newSize=${#newRanges[@]}
  [[ ${oldSize} -eq ${newSize} ]] && break

  echo "Condensed list of ranges from ${oldSize} to ${newSize}"
  oldRanges=$( echo "${newRanges[@]}" | xargs -n1 echo )
done

# Print the new ranges
#echo "${newRanges[@]}" | xargs -n1 echo

freshIDs=0
for x in $( seq 0 $((${#newRanges[@]}-1)) ); do
  IFS='-' read min max <<<"${newRanges[${x}]}"
  freshIDs=$(( freshIDs + max-min+1 ))
done

echo "${freshIDs} fresh IDs in total"

