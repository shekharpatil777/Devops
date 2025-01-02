#!/bin/bash

# Set the interval in seconds (e.g., 300 seconds = 5 minutes)
INTERVAL=300

# Name of the service to restart
SERVICE_NAME="your_service_name"

while true; do
  # Restart the service
  sudo systemctl restart $SERVICE_NAME

  # Sleep for the specified interval
  sleep $INTERVAL
done