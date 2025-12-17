#!/bin/bash

# Read all input into a variable first
input=$(cat "${1}")

while read LINE; do
  unset goal buttons
  
  # --- Parsing Logic (Kept mostly the same) ---
  # Convert light-panel goal into a decimal bitmask:
  tmp=$(grep -Po '\[.*\]' <<<"${LINE}" | tr -d '[]' | tr '\.#' '01')
  digits=$(($(wc -c <<<"${tmp}") - 1))
  goal=$((2#${tmp}))
  
  # Convert buttons into decimal bitmasks:
  buttons=()
  for button in $(grep -Po '\([^\)]*\)' <<<"${LINE}"); do
    unset binNum
    for i in $(seq 0 $((digits - 1))); do
      [[ "${button}" =~ ${i} ]] && binNum="${binNum}1" || binNum="${binNum}0"
    done
    buttons+=($((2#${binNum})))
  done

  # --- BFS Initialization ---
  
  # Use a native Array as the queue
  # Format: "numPushes currentPanelState button1 button2 ..."
  queue=()
  
  # Initial push: 0 pushes, 0 (start panel), all buttons
  queue+=("0 0 ${buttons[*]}")
  
  # Pointer to current head of queue
  head_idx=0

  # --- BFS Loop ---
  while (( head_idx < ${#queue[@]} )); do
    
    # Pop state using the pointer (very fast, no file I/O)
    current_state="${queue[head_idx]}"
    ((head_idx++))

    # Parse the popped string into an array
    # state_parts[0] = numPushes
    # state_parts[1] = currentPanel
    # state_parts[2...] = remaining buttons
    state_parts=($current_state)
    
    numPushes=${state_parts[0]}
    panel=${state_parts[1]}
    
    # Check for solution
    if [[ ${panel} -eq ${goal} ]]; then
      echo "${numPushes}"
      echo "${numPushes}" >&2
      break
    fi

    # Extract remaining buttons (everything from index 2 onwards)
    current_buttons=("${state_parts[@]:2}")

    # Iterate through available buttons by INDEX
    for i in "${!current_buttons[@]}"; do
      button_val=${current_buttons[i]}
      
      # 1. Calculate new panel state
      new_panel=$((panel ^ button_val))
      
      # 2. Create new button list by slicing:
      # (All buttons BEFORE index i) + (All buttons AFTER index i)
      # This fixes the "Duplicate Value" bug
      new_buttons=( "${current_buttons[@]:0:i}" "${current_buttons[@]:i+1}" )
      
      # 3. Push to array queue
      queue+=("$((numPushes + 1)) ${new_panel} ${new_buttons[*]}")
    done
  done

done <<<"${input}" | paste -sd+ | bc
