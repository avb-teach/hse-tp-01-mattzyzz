#!/usr/bin/env python3
import sys
import shutil
from pathlib import Path
import argparse
from collections import defaultdict

parser = argparse.ArgumentParser()
parser.add_argument("input_dir")
parser.add_argument("output_dir")
parser.add_argument("--max_depth", type=int, default=None)
args = parser.parse_args()

input_dir = Path(args.input_dir).resolve()
output_dir = Path(args.output_dir).resolve()
output_dir.mkdir(parents=True, exist_ok=True)

name_counter = defaultdict(int)

for file_path in input_dir.rglob("*"):
    if file_path.is_file():
        if args.max_depth is not None:
            depth = len(file_path.relative_to(input_dir).parts)
            if depth > args.max_depth:
                continue

        base_name = file_path.name
        count = name_counter[base_name]

        if count == 0:
            target_name = base_name
        else:
            stem = file_path.stem
            suffix = file_path.suffix
            target_name = f"{stem}{count + 1}{suffix}"

        name_counter[base_name] += 1
        target_path = output_dir / target_name
        shutil.copy2(file_path, target_path)