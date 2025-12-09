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

for i in {1..1000}; do
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
done

# Find the 3 largest sets
for x in sets/*; do
  find "${x}" -type f | wc -l
done | sort -n | tail -n 3 | paste -sd\* | bc

cd
rm -rf "${boxDir}"

