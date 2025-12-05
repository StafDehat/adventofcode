#!/bin/bash

input=$( cat "${1}" )

ranges=$( grep -- - <<<"${input}" )
ingredients=$( grep -P '^\d+$' <<<"${input}" )

freshAvail=0
for ingredient in ${ingredients}; do
  while IFS='-' read min max; do
    [[ ${ingredient} -lt ${min} ]] && continue
    [[ ${ingredient} -gt ${max} ]] && continue
    freshAvail=$(( freshAvail + 1 ))
    break
  done <<<"${ranges}"
done

echo "${freshAvail} fresh ingredients"

