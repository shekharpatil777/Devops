import subprocess

command = ["ls", "-l"]
try:
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    print(result.stdout)
except subprocess.CalledProcessError as e:
    print(f"Error executing command: {e}")
    print(e.stderr)