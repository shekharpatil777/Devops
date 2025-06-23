from datetime import datetime

# Get current time
now = datetime.now()


current_time = now.strftime("%H:%M:%S")

print("Current Time:", current_time)
