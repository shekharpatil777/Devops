#!/bin/bash

# Define environment variables
ENV=$1
SERVICE=$2

# Check if environment and service are provided
if [[ -z "$ENV" || -z "$SERVICE" ]]; then
  echo "Usage: $0 <env> <service>"
  echo "  <env>: dev, qa, prod"
  echo "  <service>: ac, lending, etc."
  exit 1
fi

# Define cluster name based on environment
case "$ENV" in
  dev)
    CLUSTER_NAME="ecs-cluster-dev"
    ;;
  qa)
    CLUSTER_NAME="ecs-cluster-qa"
    ;;
  prod)
    CLUSTER_NAME="ecs-cluster-prod"
    ;;
  *)
    echo "Invalid environment: $ENV"
    exit 1
    ;;
esac

# Define task definition based on service and environment
TASK_DEFINITION_FAMILY="my-service-${SERVICE}-${ENV}" 
TASK_DEFINITION=$(aws ecs register-task-definition \
  --family $TASK_DEFINITION_FAMILY \
  --container-definitions file://container-definitions.json \
  --network-mode awsvpc \
  --requires-compatibilities EC2,Fargate \
  --execution-role-arn arn:aws:iam::<your-aws-account-id>:role/<your-execution-role> \
  --cpu "256" \
  --memory "512" \
  --output text --query "taskDefinitionArn"
)

# Deploy the service
aws ecs update-service \
  --cluster $CLUSTER_NAME \
  --service $SERVICE \
  --task-definition $TASK_DEFINITION \
  --desired-count 1 

echo "Service $SERVICE deployed to $ENV environment successfully."
