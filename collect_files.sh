
if [ $# -ne 2 ]; then
  echo "Usage: $0 <input_dir> <output_dir>"
  exit 1
fi

input="$1"
output="$2"


mkdir -p "$output"


find "$input" -type f | while read file; do
  base=$(basename "$file")
  dest="$output/$base"
  
  if [ -e "$dest" ]; then
    name="${base%.*}"
    ext="${base##*.}"
    i=1
    while [ -e "$output/${name}_$i.$ext" ]; do
      i=$((i+1))
    done
    dest="$output/${name}_$i.$ext"
  fi
  cp "$file" "$dest"
done