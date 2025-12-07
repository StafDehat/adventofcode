#!/bin/bash

input=$( cat "${1}" )

function sum() {
  local input
  if [[ "${#}" -gt 0 ]]; then
    input=${@}
  else
    input=$( cat )
  fi
  {
    echo -n "0";
    for x in ${input}; do
      echo -n " + ${x}"
    done;
    echo;
  } | bc -l
}

while read min max; do
  seq ${min} ${max} | grep -P '^(\d+)\1+$'
done < <(sed -e 's/-/ /g' -e 's/,/\n/g' <"${1}") \
 | sum



