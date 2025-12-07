#!/bin/bash

input=$( cat "${1}" )

sum=0
while read min max; do
  echo "Processing: ${min}-${max}"
  for x in $(seq ${min} ${max}); do
    len=$(( $( wc -c <<<"${x}" ) - 1 ))
    # If odd length, can't be repeated
    [[ $((len%2)) -ne 0 ]] && continue
    halfLen=$(( len/2 ))
    read -n${halfLen} front <<<"${x}"
    if [[ "${x}" == "${front}${front}" ]]; then
      sum=$((sum+x))
    fi
  done
done < <(sed -e 's/-/ /g' -e 's/,/\n/g' <"${1}")
echo ${sum}


