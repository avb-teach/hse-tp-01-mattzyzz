#!/bin/bash
set -euo pipefail

max_depth=""
if [[ $# -ge 3 && $1 == "--max_depth" ]]; then
  max_depth="$2"
  shift 2
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 [--max_depth N] <input_dir> <output_dir>" >&2
  exit 1
fi

input_dir="$1"
output_dir="$2"

if [[ ! -d "$input_dir" ]]; then
  echo "Error: '$input_dir' is not a directory." >&2
  exit 1
fi

mkdir -p "$output_dir"

if [[ -n "$max_depth" ]]; then
  file_list=$(find "$input_dir" -maxdepth "$max_depth" -type f)
else
  file_list=$(find "$input_dir" -type f)
fi

declare -A counts
while IFS= read -r file; do
  base=$(basename "$file")
  counts["$base"]=$((counts["$base"] + 1))
  count=${counts["$base"]}
  if [[ $count -eq 1 ]]; then
    out_name="$base"
  else
    name="${base%.*}"
    ext="${base##*.}"
    suffix=$((count-1))
    out_name="${name}${suffix}.${ext}"
  fi
  cp "$file" "$output_dir/$out_name"
done <<< "$file_list"
