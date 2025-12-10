#!/bin/bash

input=$( cat "${1}" )
declare -a reds
declare -A redsI
while read LINE; do
  redsI[${LINE}]=${#reds[@]}
  reds[${#reds[@]}]="${LINE}"
done <<<"${input}"


function area() {
  local ax ay bx by
  local dx dy
  read ax ay <<<"${1//,/ }"
  read bx by <<<"${2//,/ }"
  dx=$(( ax - bx ))
  dy=$(( ay - by ))
  echo $(( (${dx#-}+1) * (${dy#-}+1) ))
}

function isOrdered() {
  [[ ${1} -le ${2} ]] && return 0
  return 1
}

#
# Store horizontal & vertical lines in separate arrays
declare -a hLines
declare -a vLines
# Function takes 2 points & adds a line to the proper array
# Line format: 4,2-7  or 2-6,8
function genLine() {
  local ix iy jx jy
  read ix iy <<<"${1/,/ }"
  read jx jy <<<"${2/,/ }"
  local lo hi
  if [[ ${ix} -eq ${jx} ]]; then
    # Vertical line
    if isOrdered ${iy} ${jy}; then
      lo=${iy}; hi=${jy}
    else
      lo=${jy}; hi=${iy}
    fi
    #vLines[${#vLines[@]}]="$((hi-lo)) ${ix},${lo}-${hi}"
    vLines[${#vLines[@]}]="${ix},${lo}-${hi}"
  else
    # Horizontal
    if isOrdered ${ix} ${jx}; then
      lo=${ix}; hi=${jx}
    else
      lo=${jx}; hi=${ix}
    fi
    #hLines[${#hLines[@]}]="$((hi-lo)) ${lo}-${hi},${iy}"
    hLines[${#hLines[@]}]="${lo}-${hi},${iy}"
  fi
}
for k in $( seq 0 $((${#reds[@]}-2)) ); do
  genLine ${reds[${k}]} ${reds[$((k+1))]}
done
genLine ${reds[0]} ${reds[$((${#reds[@]}-1))]}
# Now sort each array by line-length
IFS=$'\n' hLines=( $(sort <<<"${hLines[*]}") )
IFS=$'\n' vLines=( $(sort <<<"${vLines[*]}") )
unset IFS
# End line generation
#

function isInvalid() {
  local ix iy jx jy
  read ix iy <<<"${1/,/ }"
  read jx jy <<<"${2/,/ }"
  local ytop ybot xl xr
  if isOrdered ${iy} ${jy}; then
    ytop=${iy}; ybot=${jy}
  else
    ytop=${jy}; ybot=${iy}
  fi
  if isOrdered ${ix} ${jx}; then
    xl=${ix}; xr=${jx}
  else
    xl=${jx}; xr=${ix}
  fi
  # Test vertical lines for intersection of top/bottom edge
  for line in ${vLines[@]}; do
    # If line is L or R of box, we can short-circuit
    read x y <<<${line/,/ }
    [[ ${x} -le ${xl} ]] && continue # Vertical line left of box
    [[ ${x} -ge ${xr} ]] && continue # Vertical line right of box
    # Line is above/below box - see if it intersects
    read y1 y2 <<<${y/-/ }
    if [[ ${y1} -le ${ytop} ]]; then
      if [[ ${y2} -gt ${ytop} ]]; then
        #echo "Line ${line} intersects top edge (${ytop}) of box ${ix},${iy}:${jx},${jy}" >&2
        return 0 # Intersects top edge
      fi
      continue # Line stays above box
    fi
    if [[ ${y2} -ge ${ybot} ]]; then
      if [[ ${y1} -lt ${ybot} ]]; then
        #echo "Line ${line} intersects top edge (${ytop}) of box ${ix},${iy}:${jx},${jy}" >&2
        return 0 # Intersects bottom edge
      fi
      continue # Line stays below box
    fi
  done
  # Test horizontal lines for intersection of right/left edge
  for line in ${hLines[@]}; do
    read x y <<<${line/,/ }
    [[ ${y} -le ${ytop} ]] && continue # Horizontal line above the box
    [[ ${y} -ge ${ybot} ]] && continue # Horizontal line under the box
    # Line is abouts the box - see if it intersects
    read x1 x2 <<<${x/-/ }
    if [[ ${x1} -le ${xl} ]]; then
      if [[ ${x2} -gt ${xl} ]]; then 
        #echo "Line ${line} intersects left edge (${xl}) of box ${ix},${iy}:${jx},${jy}" >&2
        return 0 # Intersects left edge
      fi
      continue # Line stays left of box
    fi
    if [[ ${x2} -ge ${xr} ]]; then
      if [[ ${x1} -lt ${xr} ]]; then
        #echo "Line ${line} intersects right edge (${xr}) of box ${ix},${iy}:${jx},${jy}" >&2
        return 0 # Intersects right edge
      fi
      continue # Line stays right of box
    fi
  done
  # Not invalid, I guess.
  return 1
}



# Generate all boxes first.
# Sort by size - check in that order, so as soon as we find one that's valid, we're done.
areas=$( 
  for i in $( seq 0 $((${#reds[@]}-1)) ); do
    for j in $( seq $((i+1)) $((${#reds[@]}-1)) ); do
      area=$( area ${reds[${i}]} ${reds[${j}]} )
      echo "${area} ${reds[${i}]} ${reds[${j}]}"
    done
  done | sort -nr
)

# Invalid boxes have an edge intersected by a line (hLines,vLines)
while read area pt1 pt2; do
  echo "Testing ${pt1}:${pt2} with area ${area}"
  if isInvalid ${pt1} ${pt2}; then
    echo "Invalid"
    continue
  fi
  echo "${area} ${pt1}:${pt2}"
  break
done <<<"${areas}"

