
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

declare -A counts

if [[ -n "$max_depth" ]]; then
  maxdepth_opt=("-maxdepth" "$max_depth")
else
  maxdepth_opt=()
fi

while IFS= read -r -d '' file; do
  base=$(basename "$file")
  count=$((counts["$base"] + 1))
  counts["$base"]=$count
  if [[ $count -eq 1 ]]; then
    out_name="$base"
  else
    if [[ "$base" == *.* ]]; then
      name="${base%.*}"
      ext="${base##*.}"
      out_name="${name}$((count-1)).${ext}"
    else
      out_name="${base}$((count-1))"
    fi
  fi
  cp "$file" "$output_dir/$out_name"
done < <(find "$input_dir" "${maxdepth_opt[@]}" -type f -print0)
