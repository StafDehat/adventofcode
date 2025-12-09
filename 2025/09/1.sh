#!/bin/bash

input=$( cat "${1}" )
declare -a reds
declare -A redsI
while read LINE; do
  redsI[${LINE}]=${#reds[@]}
  reds[${#reds[@]}]="${LINE}"
done <<<"${input}"

function area() {
  local aX aY bX bY
  local dX dY
  read aX aY <<<"${1//,/ }"
  read bX bY <<<"${2//,/ }"
  dX=$(( aX - bX ))
  dY=$(( aY - bY ))
  echo $(( (${dX#-}+1) * (${dY#-}+1) ))
}

for i in $( seq 0 $((${#reds[@]}-1)) ); do
  for j in $( seq $((i+1)) $((${#reds[@]}-1)) ); do
    area=$( area ${reds[${i}]} ${reds[${j}]} )
    echo "${area} ${reds[${i}]} ${reds[${j}]}"
  done
done | sort -n | tail -n 1

