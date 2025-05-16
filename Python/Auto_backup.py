import shutil
import os
from datetime import datetime

def create_backup(source_dir, backup_dir="backup"):
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup_path = os.path.join(backup_dir, f"backup_{timestamp}")

    try:
        shutil.copytree(source_dir, backup_path)
        print(f"Backup created at: {backup_path}")
    except FileNotFoundError:
        print(f"Error: Source directory '{source_dir}' not found.")
    except FileExistsError:
        print(f"Error: Backup directory '{backup_path}' already exists.")
    except Exception as e:
        print(f"An error occurred during backup: {e}")

if __name__ == "__main__":
    # Create a dummy source directory for testing
    if not os.path.exists("source_data"):
        os.makedirs("source_data")
        with open(os.path.join("source_data", "file1.txt"), "w") as f:
            f.write("This is file 1.")
        with open(os.path.join("source_data", "file2.txt"), "w") as f:
            f.write("This is file 2.")

    create_backup("source_data")