#!/bin/bash

# Check if argument was provided
if [ -z "$1" ]; then
  echo "Usage: ./comp.sh <ProblemID> (e.g., ./comp.sh 4a)"
  exit 1
fi

# Extract directory and filename (4a -> 4/a.rs)
dir_name=$(echo "$1" | grep -oE '[0-9]+')
file_letter=$(echo "$1" | grep -oE '[a-zA-Z]+' | tr '[:upper:]' '[:lower:]')
target_file="$dir_name/$file_letter.rs"
output_bin="$dir_name/$file_letter"

# Check if file exists
if [ ! -f "$target_file" ]; then
  echo "Error: $target_file not found."
  exit 1
fi

# Detect OS and set appropriate flags
OS_TYPE=$(uname -s)

case "$OS_TYPE" in
Linux*)
  # Linux (ELF) stack size flag
  FLAGS="-C link-arg=-Wl,-z,stack-size=268435456"
  ;;
Darwin*)
  # macOS (Mach-O) stack size flag
  FLAGS="-C link-arg=-Wl,-stack_size,0x10000000"
  ;;
CYGWIN* | MINGW32* | MSYS* | MINGW*)
  # Windows (PE/COFF) stack size flag
  FLAGS="-C link-args=/STACK:268435456"
  output_bin="$output_bin.exe"
  ;;
*)
  echo "Unknown OS: $OS_TYPE. Compiling without specific stack flags."
  FLAGS=""
  ;;
esac

echo "Compiling $target_file for $OS_TYPE..."

# Execute compilation
rustc --edition=2024 -O $FLAGS --cfg ONLINE_JUDGE "$target_file" -o "$output_bin"

if [ $? -eq 0 ]; then
  echo "Compilation successful: $output_bin"
  echo "Running..."
  echo "-----------------------------------"
  "./$output_bin"
else
  echo "Compilation failed."
fi
