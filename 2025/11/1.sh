#!/bin/bash

input=$( cat "${1}" )

tmpdir=$(mktemp -d)
cd "${tmpdir}"

while read src dsts; do
  mkdir ${src}
  cd "${src}"
  for dst in ${dsts}; do
    ln -s ../${dst}
  done
  cd ..
done <<<"${input//:/}"

find -L you -name out | wc -l

cd
rm -rf "${tmpdir}"
