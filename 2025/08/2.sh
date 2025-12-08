#!/bin/bash

boxDir=$( mktemp -d )
sortedSpans=$( sort -n "${1}" )
cd "${boxDir}"
mkdir "${boxDir}"/sets

function dedupe() {
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
}

# Initialize all the sets.  Start with 1 box per set.
for x in {0..999}; do
  mkdir -p "${boxDir}"/sets/${x}
  touch "${boxDir}"/sets/${x}/${x}
done


i=0
while true; do
  i=$((i+1))

  echo "$(date +'%F_%T') Creating link number ${i} of ????"
  # Grab the i-closest pair
  read distance boxA boxB <<<$( head -n ${i} <<<"${sortedSpans}" | tail -n 1 )

  # Check to see if I'm already in any sets
  aSet=$( printf '%s\n' sets/*/"${boxA}" 2>/dev/null |
            head -n 1 | cut -d/ -f2 )
  bSet=$( printf '%s\n' sets/*/"${boxB}" 2>/dev/null |
            head -n 1 | cut -d/ -f2 )
  if [[ "${aSet}" != "*" ]]; then
    touch sets/${aSet}/${boxB}
  fi
  if [[ "${bSet}" != "*" ]]; then
    touch sets/${bSet}/${boxA}
  fi

  if [[ ${i} -gt 1000 ]]; then
    dedupe
    if [[ $(ls -1 sets | wc -l) -le 1 ]]; then
      echo "${boxA} & ${boxB} (0-based) were the last two connected"
      echo "Run this:"
      echo "  sed -n -e '$((boxA+1))p' -e '$((boxB+1))p' data |"
      echo "    cut -d, -f1 | paste -sd\* | bc"
      break
    fi
  fi
done



# Now de-dupe the sets

