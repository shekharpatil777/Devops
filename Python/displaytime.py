from datetime import datetime

# Get current time
now = datetime.now()

# Format time as HH:MM:SS
current_time = now.strftime("%H:%M:%S")

print("Current Time:", current_time)
