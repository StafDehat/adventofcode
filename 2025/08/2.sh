#!/bin/bash

boxDir=$( mktemp -d )
sortedSpans=$( sort -n "${1}" )
cd "${boxDir}"
mkdir "${boxDir}"/sets

# Start with every box in its own size-1 set:
for i in {0..999}; do
  mkdir sets/${i}
  touch sets/${i}/${i}
done

i=0
while true; do
  i=$((i+1))
  echo "$(date +'%F_%T') Creating link number ${i} of 1000"
  # Grab the i-closest pair
  read distance boxA boxB <<<$( head -n ${i} <<<"${sortedSpans}" | tail -n 1 )

  # Identify the set containing each box
  aSet=$( find sets -type f -name "${boxA}" | cut -d/ -f2 )
  bSet=$( find sets -type f -name "${boxB}" | cut -d/ -f2 )
  if [[ "${aSet}" == "${bSet}" ]]; then
    # Already in the same set - don't create a new junction
    continue
  fi
  # In different sets - merge the sets
  echo "Merging sets ${aSet} & ${bSet} into ${aSet}"
  mv sets/${bSet}/* sets/${aSet}/
  rmdir sets/${bSet}
  # Are we down to just one set now?
  if [[ $(find sets -type d | wc -l) -le 2 ]]; then
    echo "${boxA} & ${boxB} (0-based) were the last two connected"
    echo "Run this:"
    echo "  sed -n -e '$((boxA+1))p' -e '$((boxB+1))p' data |"
    echo "    cut -d, -f1 | paste -sd\* | bc"
    break
  fi
done

