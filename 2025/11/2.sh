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
mkdir out


function solve() {
  local node="${1}"

  # This node already solved - just return
  [[ -f ${node}/via-none ]] && return
  [[ -f ${node}/via-both ]] && return
  [[ -f ${node}/via-dac ]] && return
  [[ -f ${node}/via-fft ]] && return

  # node="out".  1 path, we're on it.  No dac or fft seen.
  if [[ "${node}" == "out" ]]; then
    echo 1 > "${node}"/via-none
    echo 0 > "${node}"/via-both
    echo 0 > "${node}"/via-dac
    echo 0 > "${node}"/via-fft
    return
  fi

  # Tell children to solve themselves
  children=$( find ${node} -type l | cut -d/ -f2 )
  for child in ${children}; do
    solve ${child}
  done

  if [[ "${node}" == "dac" ]]; then
    for child in ${children}; do
      cat ${child}/via-none ${child}/via-dac
    done | paste -sd+ | bc > ${node}/via-dac
    for child in ${children}; do
      cat ${child}/via-fft ${child}/via-both
    done | paste -sd+ | bc > ${node}/via-both
    echo 0 > ${node}/via-fft
    echo 0 > ${node}/via-none
    return
  fi

  if [[ "${node}" == "fft" ]]; then
    for child in ${children}; do
      cat ${child}/via-none ${child}/via-fft
    done | paste -sd+ | bc > ${node}/via-fft
    for child in ${children}; do
      cat ${child}/via-dac ${child}/via-both
    done | paste -sd+ | bc > ${node}/via-both
    echo 0 > ${node}/via-dac
    echo 0 > ${node}/via-none
    return
  fi

  for via in via-none via-both via-dac via-fft; do
    for child in ${children}; do
      cat ${child}/${via}
    done | paste -sd+ | bc > ${node}/${via}
  done
}

solve svr
cat svr/via-both


