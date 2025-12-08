#!/bin/bash

boxDir=$( mktemp -d )
sortedSpans=$( sort -n "${1}" )
cd "${boxDir}"
mkdir "${boxDir}"/sets
numSets=0
for i in {1..1000}; do
  echo "$(date +'%F_%T') Creating link number ${i} of 1000"
  # Grab the i-closest pair
  read distance boxA boxB <<<$( head -n ${i} <<<"${sortedSpans}" | tail -n 1 )

  # Check to see if I'm already in any sets
  aSet=$( printf '%s\n' sets/*/"${boxA}" 2>/dev/null |
            head -n 1 | cut -d/ -f2 )
  bSet=$( printf '%s\n' sets/*/"${boxB}" 2>/dev/null |
            head -n 1 | cut -d/ -f2 )
  if [[ "${aSet}" != "*" ]]; then
    touch sets/${aSet}/${boxB}
  elif [[ "${bSet}" != "*" ]]; then
    touch sets/${bSet}/${boxA}
  else
    # Neither node is already in a set - make a new set
    mkdir sets/${numSets}
    touch sets/${numSets}/{${boxA},${boxB}}
    numSets=$(( numSets+1 ))
  fi
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

