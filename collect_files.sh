#!/usr/bin/env bash
set -euo pipefail

usage(){
  cat <<eof
usage: $0 [--max_depth n] input_dir output_dir

  --max_depth n   сохранить дерево папок до глубины n (>=1),
                  всё, что глубже, скопируется в уровень n.
  input_dir       входная директория для сбора файлов
  output_dir      целевая директория (будет создана, если не существует)
eof
  exit 1
}

max_depth=0

if [[ $# -eq 3 && $1 == "--max_depth" ]]; then
  if ! [[ $2 =~ ^[1-9][0-9]*$ ]]; then
    echo "error: --max_depth должен быть положительным целым."
    exit 1
  fi
  max_depth="$2"
  shift 2
elif [[ $# -ne 2 ]]; then
  usage
fi

input_dir=$1
output_dir=$2

if [[ ! -d $input_dir ]]; then
  echo "error: '$input_dir' не найдена или не директория."
  exit 1
fi

mkdir -p "$output_dir"

declare -A counts

find "$input_dir" -type f | while IFS= read -r file; do
  rel_path="${file#"$input_dir"/}"
  IFS='/' read -ra parts <<< "$rel_path"
  basename="${parts[-1]}"

  if (( max_depth > 0 )); then
    if (( ${#parts[@]} > max_depth )); then
      dir_path="${parts[0]}"
      for ((i=1; i<max_depth; i++)); do
        dir_path+="/${parts[i]}"
      done
    else
      dir_path="$(dirname "$rel_path")"
    fi
    mkdir -p "$output_dir/$dir_path"
    cp "$file" "$output_dir/$dir_path/$basename"
  else
    target="$output_dir/$basename"
    if [[ -e $target ]]; then
      name="${basename%.*}"
      ext="${basename##*.}"
      c=${counts["$basename"]:---1}
      (( c++ ))
      new_name="${name}_$c.${ext}"
      while [[ -e "$output_dir/$new_name" ]]; do
        (( c++ ))
        new_name="${name}_$c.${ext}"
      done
      cp "$file" "$output_dir/$new_name"
      counts["$basename"]=$c
    else
      cp "$file" "$target"
      counts["$basename"]=1
    fi
  fi
done