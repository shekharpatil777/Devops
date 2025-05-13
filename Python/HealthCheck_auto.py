import psutil
import time

#This script checks the CPU usage, memory usage, and disk space of a server.
def check_server_health():
    cpu_percent = psutil.cpu_percent()
    mem = psutil.virtual_memory()
    mem_percent = mem.percent
    disk = psutil.disk_usage('/')
    disk_percent = disk.percent

    print(f"CPU Usage: {cpu_percent}%")
    print(f"Memory Usage: {mem_percent}%")
    print(f"Disk Usage: {disk_percent}%")

if __name__ == "__main__":
    while True:
        check_server_health()
        time.sleep(60) # Check every minute
