
import argparse
import shutil
from pathlib import Path
from collections import defaultdict

parser = argparse.ArgumentParser()
parser.add_argument("input_dir")
parser.add_argument("output_dir")
parser.add_argument("--max_depth", type=int, default=None)
opts = parser.parse_args()

src_dir = Path(opts.input_dir).resolve()
dst_dir = Path(opts.output_dir).resolve()
dst_dir.mkdir(parents=True, exist_ok=True)

seen_counts = defaultdict(int)

for item_path in src_dir.rglob("*"):
    if not item_path.is_file():
        continue

    segments = item_path.relative_to(src_dir).parts
    if opts.max_depth:
        tail_parts = segments[-opts.max_depth:]
    else:
        tail_parts = [segments[-1]]

    sub_dirs = tail_parts[:-1]
    orig_name = item_path.name
    dup_count = seen_counts[orig_name]

    if dup_count == 0:
        final_name = tail_parts[-1]
    else:
        base = item_path.stem
        ext = item_path.suffix
        final_name = f"{base}{dup_count+1}{ext}"

    seen_counts[orig_name] += 1

    target_dir = dst_dir.joinpath(*sub_dirs) if sub_dirs else dst_dir
    target_dir.mkdir(parents=True, exist_ok=True)
    shutil.copy2(item_path, target_dir / final_name)