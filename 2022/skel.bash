#!/bin/bash

if [[ ${#} -ne 1 ]]; then
  echo "Missing argument: Input file" >&2
  exit 1
fi

INFILE="${1}"
if ! [[ -r "${INFILE}" ]]; then
  echo "Unable to read input file: ${INFILE}" >&2
  exit 1
fi

# Define some math libraries:
. ../../math.bash
