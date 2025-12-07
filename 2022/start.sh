#!/bin/bash

# Input validation
DAY="${1}"
if ! grep -qP '^-?\d+$' <<<"${DAY}"; then
  echo "Arg1 is not numeric"
  exit 1
fi
if [[ ${DAY} -lt 1 ]] || [[ ${DAY} -gt 25 ]]; then
  echo "Arg1 is >=1 and <=25"
  exit 1
fi

# Pad with leading zeros
DAY=$( printf "%02d" ${DAY} )

# Create directory structure
mkdir -p day${DAY}{,/1,/2}
touch day${DAY}/{input,sample}
( cd day${DAY}/1; ln -s ../input; ln -s ../sample )
( cd day${DAY}/2; ln -s ../input; ln -s ../sample )

cp ./skel.py   day${DAY}/1/python
cp ./skel.bash day${DAY}/1/bash
cp ./skel.go day${DAY}/1/1.go
chmod +x day${DAY}/1/{python,bash}

#cp ./skel.py   day${DAY}/2/python
#cp ./skel.bash day${DAY}/2/bash
#chmod +x day${DAY}/2/*

# Can't wget without identifying user
#wget https://adventofcode.com/2022/day/1/input


