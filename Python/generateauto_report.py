import psutil
from datetime import datetime

#This script fetches CPU and memory usage and generates a simple text report.

def generate_system_report(report_file="system_report.txt"):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    cpu_percent = psutil.cpu_percent()
    mem = psutil.virtual_memory()
    mem_percent = mem.percent

    report_content = f"""
System Report - {timestamp}

CPU Usage: {cpu_percent}%
Memory Usage: {mem_percent}%
"""

    with open(report_file, "w") as f:
        f.write(report_content)

    print(f"System report generated at: {report_file}")

if __name__ == "__main__":
    generate_system_report()