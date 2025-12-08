#!/bin/bash

input=$( cat "${1}" )

boxDir=$( mktemp -p /dev/shm -d )
cd "${boxDir}"

declare -a boxes
while read x y z; do
  mkdir -p "${boxDir}"/"${#boxes[@]}"/{spans,links}
  echo "${x} ${y} ${z}" > "${boxDir}"/"${#boxes[@]}"/coords
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
  echo "$(date +'%F_%T') Calculating distances for box ${boxA}"
  for boxB in $( seq $((boxA+1)) $((${#boxes[@]}-1)) ); do
    distance=$( getSpan ${boxes[${boxA}]} \
                        ${boxes[${boxB}]} )
    ( #Subshell - preserve pwd
      cd "${boxDir}"/"${boxA}"/spans
      ln -s ../../"${boxB}" "${distance}"
      cd "${boxDir}"/"${boxB}"/spans
      ln -s ../../"${boxA}" "${distance}"
    )
  done
done


# Build our "data structure" by adding links between boxes
cd "${boxDir}"
sortedSpans=$( find */spans -type l | sort -t / -nk 3 )
for i in {1..1000}; do
  echo "$(date +'%F_%T') Creating link number ${i} of 1000"
  # Grab the i-closest pair
  closest=$( head -n $((i*2)) <<<"${sortedSpans}" | tail -n 2 )
  read boxA boxB <<<$( cut -d/ -f1 <<<"${closest}" | xargs echo )

  # If we can traverse from ${boxA}/links to ${boxB}, then they're already
  #   connected somehow.  Let 'find' figure out the paths.
  isLinked=$( 
    find -L "${boxA}" -name spans -prune -o \
                      -name "${boxB}" 2>/dev/null | grep -cv spans
  )
  if [[ ${isLinked} -gt 0 ]]; then
    continue
  fi

  # Add the link
  ( #Subshell - preserve pwd
    cd "${boxDir}"/"${boxA}"/links && ln -s ../../"${boxB}"
    cd "${boxDir}"/"${boxB}"/links && ln -s ../../"${boxA}"
  )
done

# Build "sets"
mkdir "${boxDir}"/sets
numSets=0
for boxNum in $( seq 0 $((${#boxes[@]}-1)) ); do
  echo "$(date +'%F_%T') Building initial set for box ${boxNum}"
  # Check to see if I'm already in any sets
  mySet=$( printf '%s\n' sets/*/"${boxNum}" 2>/dev/null |
             head -n 1 | cut -d/ -f2 )
  if [[ "${mySet}" == "*" ]]; then
    # Make a new set
    mySet="${numSets}"
    numSets=$(( numSets+1 ))
    mkdir "${boxDir}"/sets/"${mySet}"
    touch "${boxDir}"/sets/"${mySet}"/"${boxNum}"
  fi
  # Add all your neighbours to the set too
  for x in $( printf '%s\n' "${boxNum}"/links/* | cut -d/ -f3 | grep -P '\d+' ); do
    touch "${boxDir}"/sets/"${mySet}"/"${x}"
  done
done

# Now de-dupe the sets
echo "$(date +'%F_%T') De-duping sets"
while true; do
  read count boxNum <<<$( find sets -type f | cut -d/ -f3 | sort -n | uniq -c | sort -n | tail -n 1 )
  if [[ ${count} -le 1 ]]; then
    break
  fi
  echo "$(date +'%F_%T') De-duping box ${boxNum} (in ${count} sets)"
  # Merge two sets
  read authSet dupeSets <<<$( find sets -type f -name "${boxNum}" | cut -d/ -f2 | paste -s )
  echo "Merging duplicate sets into ${authSet}: ${dupeSets}"
  for set in ${dupeSets}; do
    mv sets/${set}/* sets/${authSet}/
    rmdir sets/${set}
  done
done

# Find the 3 largest sets
cd sets
for set in *; do
  ls -1 "${set}"/ | wc -l
done | sort -n | tail -n 3 | paste -sd\* | bc

rm -rf "${boxDir}"

