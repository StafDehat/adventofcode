#!/bin/bash

inFile="${1}"

sum=0
chars=0
while read -n 1 char; do
  chars=$((chars+1))
  if [[ "${char}" == "(" ]]; then
    sum=$((sum+1))
  elif [[ "${char}" == ")" ]]; then
    sum=$((sum-1))
  fi
  if [[ ${sum} -lt 0 ]]; then
    echo "${chars}"
    break
  fi
done < "${inFile}"

echo "${sum}"
