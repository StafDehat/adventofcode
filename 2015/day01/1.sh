#!/bin/bash

inFile="${1}"

echo $(( $(grep -o '(' ${inFile} | wc -l) - $(grep -o ')' ${inFile} | wc -l) ))
