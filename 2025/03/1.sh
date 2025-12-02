#!/bin/bash

input=$( cat "${1}" )

while read min max; do
 
done < <(sed -e 's/-/ /g' -e 's/,/\n/g' <<<"${input}")

