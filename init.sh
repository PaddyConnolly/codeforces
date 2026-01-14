#!/bin/bash

# Check if an argument was provided
if [ -z "$1" ]; then
  echo "Usage: ./init.sh <ProblemID> (e.g., ./init.sh 4A)"
  exit 1
fi

# Extract digits (Directory) and letters (File)
# 4A -> dir: 4, file: a
dir_name=$(echo "$1" | grep -oE '[0-9]+')
file_name=$(echo "$1" | grep -oE '[a-zA-Z]+' | tr '[:upper:]' '[:lower:]')

# Check if extraction was successful
if [ -z "$dir_name" ] || [ -z "$file_name" ]; then
  echo "Error: Invalid format. Use something like '4A' or '123C'."
  exit 1
fi

# Define path
target_dir="$dir_name"
target_file="$target_dir/$file_name.rs"

# 1. Create directory if it doesn't exist
mkdir -p "$target_dir"

# 2. Copy solution.rs to the new location
if [ -f "solution.rs" ]; then
  cp "solution.rs" "$target_file"
else
  echo "Error: solution.rs not found in the current directory."
  exit 1
fi

# 3. Open in nvim
nvim "$target_file"
