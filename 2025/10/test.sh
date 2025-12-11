#!/bin/bash

declare -a array
for x in {0..9}; do
  array[${x}]=${x}
done
echo "${array[@]}"

while true; do
  for x in {0..9}; do
    elem=${array[${x}]}
    unset array[${x}]
    echo "${array[@]}"
    array[${x}]=${elem}
  done
done

