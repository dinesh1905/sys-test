# -*- coding: utf-8 -*-

#import shutil
#import os
#import sys


#def copy_file(source_path, destination_path):

 #   if not os.path.exists(source_path):
  #      raise FileNotFoundError(f"Source file not found: {source_path}")

   # os.makedirs(os.path.dirname(destination_path), exist_ok=True)

    #shutil.copy2(source_path, destination_path)

#    print(f"File copied from {source_path} to {destination_path}")


#if __name__ == "__main__":

 #   if len(sys.argv) < 3:
  #      print("ERROR: Missing arguments")
   #     sys.exit(1)

    #source = sys.argv[1]
    #destination = sys.argv[2]

    #print("Source:", source)
    #print("Destination:", destination)

    #copy_file(source, destination)



# -*- coding: utf-8 -*-

import shutil
import os
import sys
import time
import subprocess


def close_excel():
    """Force close all Excel instances"""
    try:
        subprocess.run(
            ["taskkill", "/F", "/IM", "EXCEL.EXE"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
        print("Closed all Excel instances")
        time.sleep(2)  # wait for OS to release file lock
    except Exception as e:
        print("Warning: Unable to close Excel:", e)


def copy_file(source_path, destination_path):

    if not os.path.exists(source_path):
        raise FileNotFoundError(f"Source file not found: {source_path}")

    # Ensure destination folder exists
    os.makedirs(os.path.dirname(destination_path), exist_ok=True)

    # 🔥 Close Excel before delete
    close_excel()

    # 🔥 Retry delete (important for automation)
    for i in range(3):
        try:
            if os.path.exists(destination_path):
                os.remove(destination_path)
                print(f"Deleted existing file: {destination_path}")
            break
        except PermissionError:
            print("File locked, retrying...")
            time.sleep(2)
    else:
        raise Exception("Unable to delete file after retries")

    # Copy new file
    shutil.copy2(source_path, destination_path)

    print(f"File copied from {source_path} to {destination_path}")


if __name__ == "__main__":

    if len(sys.argv) < 3:
        print("ERROR: Missing arguments")
        sys.exit(1)

    source = sys.argv[1]
    destination = sys.argv[2]

    print("Source:", source)
    print("Destination:", destination)

    copy_file(source, destination)