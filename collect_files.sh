if [ "$#" -ne 2 ]; then
  exit 1
fi

input_dir="$1"
output_dir="$2"
mkdir -p "$output_dir"

files=$(find "$input_dir" -type f)

for file in $files; do
  cp "$file" "$output_dir"
done