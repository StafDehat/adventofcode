#!/bin/bash

input=$( cat "${1}" )

tmpdir=$(mktemp -d)
cd "${tmpdir}"

while read src dsts; do
  mkdir ${src}
  cd "${src}"
  for dst in ${dsts}; do
    touch ${dst}
  done
  cd ..
done <<<"${input//:/}"

# Initialize each 'out' to =1 path
for x in */out; do echo 1 > $x; done

queueFile=$(mktemp)
function push() {
  echo "${@}" >> ${queueFile}
}
function pop() {
  head -n 1 ${queueFile}
  sed -i '1d' ${queueFile}
}


push out
while true; do
  # If everything in you is known, we're done:
  if [[ $(find you -type f -size 0 | wc -l) -eq 0 ]]; then
    break
  fi

  next=$(pop)
  for x in */${next}; do
    paths=$( cat $(dirname ${x})/* | paste -sd+ | bc )
    for y in */$(dirname ${x}); do
      echo "${paths}" > ${y}
    done
    push $(dirname ${x})
  done
done

cat you/* | paste -sd+ | bc


cd
rm -rf "${tmpdir}"

