#!/bin/bash

# Set the desired count for scaling up
DESIRED_COUNT=2 # Adjust this value as needed

# Get a list of all services in the cluster
SERVICES=$(aws ecs list-services --cluster <YOUR_CLUSTER_NAME> --query 'serviceArns[]' --output text)

# Iterate through each service and update its desired count
for SERVICE in $SERVICES; do
  aws ecs update-service --cluster <YOUR_CLUSTER_NAME> --service "$SERVICE" --desired-count "$DESIRED_COUNT"
done
# shows all services scaled up
echo "All services in cluster <YOUR_CLUSTER_NAME> scaled up to $DESIRED_COUNT instances."