#!/bin/bash

# gawk transpose function
function tp() {
  awk '{for(i=1;i<=NF;i++)a[i][NR]=$i}END{for(i in a)for(j in a[i])printf"%s"(j==NR?RS:FS),a[i][j]}' "${1+FS=$1}";
}

input=$( tp <"${1}" )

sum=0
while read LINE; do
  op=$( awk '{print $NF}' <<<"${LINE}" )
  result=$( grep -Po '\d+' <<<"${LINE}" | paste -sd"${op}" | bc )
  sum=$(( sum + result ))
done <<<"${input}"
echo "${sum}"
