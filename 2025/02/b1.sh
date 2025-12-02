#!/bin/bash

input=$( cat "${1}" )

sum=0
while read min max; do
  echo "Processing: ${min}-${max}"
  for x in $(seq ${min} ${max}); do
    grep -qP '^(\d+)\1$' <<<"${x}" && \
      sum=$((sum+x))
  done
done < <(sed -e 's/-/ /g' -e 's/,/\n/g' <"${1}")
echo ${sum}


