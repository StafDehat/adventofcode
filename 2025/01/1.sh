#!/bin/bash


sum=50
count=0
while read val; do
  sum=$(( sum + val ))
  if [[ $(( sum%100 )) -eq 0 ]]; then
    count=$(( count+1 ))
  fi
done < <(sed -e 's/L/-/' -e 's/R//' data)
echo $count
