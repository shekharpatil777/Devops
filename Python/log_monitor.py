import time

def monitor_log(log_file="application.log"):
    try:
        with open(log_file, "r") as f:
            f.seek(0, os.SEEK_END) # Go to the end of the file
            while True:
                line = f.readline()
                if line.strip():
                    if "ERROR" in line:
                        print(f"Error found: {line.strip()}")
                time.sleep(0.1)
    except FileNotFoundError:
        print(f"Error: Log file '{log_file}' not found.")

if __name__ == "__main__":
    # Create a dummy log file for testing
    with open("application.log", "w") as f:
        f.write("INFO: Application started\n")
        f.write("ERROR: Something went wrong!\n")
        f.write("DEBUG: More details here\n")
        f.write("ERROR: Another issue occurred.\n")

    monitor_log()