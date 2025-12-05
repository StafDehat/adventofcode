#!/bin/bash

input=$( cat "${1}" )

ranges=$( grep -- - <<<"${input}" )
ingredients=$( grep -P '^\d+$' <<<"${input}" )

numRanges=$( wc -l <<<"${ranges}" )
echo "${numRanges} ranges in list"
i=0
fresh=$(
  while IFS='-' read min max; do
    seq ${min} ${max}
    i=$((i+1))
    echo "$(date +"%F_%T") Processed range (${i}/${numRanges}): ${min}-${max}" >&2
  done <<<"${ranges}"
)
echo "$( wc -l <<<"${fresh}") fresh ingredients"
echo "$( wc -l <<<"${ingredients}") available ingredients"

freshAvail=$( 
  comm -12 <(echo "${fresh}" | sort -u) \
           <(echo "${ingredients}" | sort)
)

echo "$(wc -l <<<"${freshAvail}") fresh & available ingredients"

