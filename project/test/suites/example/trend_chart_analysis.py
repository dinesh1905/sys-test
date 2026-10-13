import shutil
import sys
import os

def move_and_overwrite(source_path, destination_path):
    shutil.copy2(source_path, destination_path)
    os.remove(source_path)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python move.py <source_path> <destination_path>")
        sys.exit(1) 
    source_path = sys.argv[1]
    destination_path = sys.argv[2]
    if not os.path.isfile(source_path):
        print(f"Source file does not exist: {source_path}")
        sys.exit(1)
    move_and_overwrite(source_path, destination_path)
