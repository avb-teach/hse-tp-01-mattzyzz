input_dir="/home/input_dir"
output_dir="/home/output_dir"
mkdir -p "$output_dir"

files=$(find "$input_dir" -type f)

for file in $files; do
  cp "$file" "$output_dir"
done
