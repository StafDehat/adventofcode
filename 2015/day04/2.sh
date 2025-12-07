#!/bin/bash

hash=ckczppom
x=1
while true; do
  [[ $(( ${x}%1000 )) -eq 0 ]] && echo "Testing $x"
  if grep -q '^00000' <<<"$(echo -n "${hash}${x}" | md5sum)"; then
    echo $x
    break;
  fi
  x=$((x+1))
done

echo "${x}"
echo -n "${hash}${x}" | md5sum
