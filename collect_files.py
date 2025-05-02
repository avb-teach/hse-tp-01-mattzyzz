
import argparse
from pathlib import Path
import shutil
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

for path in input_dir.rglob("*"):
    if path.is_file():
        if args.max_depth is not None:
            depth = len(path.relative_to(input_dir).parts)
            if depth > args.max_depth:
                continue

        name = path.name
        count = name_counter[name]
        if count == 0:
            new_name = name
        else:
            new_name = f"{path.stem}{count+1}{path.suffix}"
        name_counter[name] += 1
        shutil.copy2(path, output_dir / new_name)