import sys             
from pathlib import Path 
import shutil


input_dir = Path(sys.argv[1])
output_dir = Path(sys.argv[2])


output_dir.mkdir(parents=True, exist_ok=True)

for file in input_dir.rglob("*"):
    if file.is_file():
        shutil.copy2(file, output_dir / file.name)