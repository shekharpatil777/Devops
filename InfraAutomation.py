import boto3
import time
import logging

# Configure logging
logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)
handler = logging.StreamHandler()
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler)

# AWS Credentials (Replace with your actual credentials)
AWS_ACCESS_KEY_ID = "YOUR_AWS_ACCESS_KEY_ID"
AWS_SECRET_ACCESS_KEY = "YOUR_AWS_SECRET_ACCESS_KEY"
REGION_NAME = "your-region"

# Terraform Configuration
TERRAFORM_DIR = "path/to/your/terraform/directory" 

# Function to check if EC2 instances are running
def check_ec2_instances(instance_ids):
    """
    Checks if the specified EC2 instances are running.

    Args:
        instance_ids: A list of EC2 instance IDs.

    Returns:
        A list of instance IDs that are not running.
    """
    ec2 = boto3.client('ec2', aws_access_key_id=AWS_ACCESS_KEY_ID, 
                       aws_secret_access_key=AWS_SECRET_ACCESS_KEY, 
                       region_name=REGION_NAME)
    not_running_instances = []
    for instance_id in instance_ids:
        try:
            response = ec2.describe_instances(InstanceIds=[instance_id])
            instance_status = response['Reservations'][0]['Instances'][0]['State']['Name']
            if instance_status != 'running':
                not_running_instances.append(instance_id)
        except Exception as e:
            logger.error(f"Error describing instance {instance_id}: {e}")
    return not_running_instances

# Function to recreate resources using Terraform
def recreate_infrastructure():
    """
    Recreates infrastructure using Terraform.
    """
    import subprocess
    try:
        logger.info("Running Terraform init...")
        subprocess.run(["terraform", "init"], cwd=TERRAFORM_DIR)
        logger.info("Running Terraform plan...")
        subprocess.run(["terraform", "plan"], cwd=TERRAFORM_DIR)
        logger.info("Running Terraform apply...")
        subprocess.run(["terraform", "apply", "-auto-approve"], cwd=TERRAFORM_DIR)
        logger.info("Infrastructure recreated successfully.")
    except subprocess.CalledProcessError as e:
        logger.error(f"Terraform execution failed: {e}")

# Main function
def main():
    # Get list of instance IDs from Terraform output (modify as per your output)
    try:
        with open(f"{TERRAFORM_DIR}/.terraform/outputs.tfstate", 'r') as f:
            # Parse the output file to extract instance IDs 
            # (This part needs to be adjusted based on your Terraform output structure)
            instance_ids = extract_instance_ids_from_output(f.read()) 
    except FileNotFoundError:
        logger.error("Terraform output file not found. Did you run 'terraform apply' initially?")
        return

    while True:
        not_running_instances = check_ec2_instances(instance_ids)
        if not_running_instances:
            logger.warning(f"The following instances are not running: {not_running_instances}")
            logger.info("Recreating infrastructure using Terraform...")
            recreate_infrastructure()
        else:
            logger.info("All instances are running.")
        time.sleep(60)  # Check every 60 seconds

# Helper function to extract instance IDs from Terraform output (placeholder)
def extract_instance_ids_from_output(output_data):
    # This is a placeholder. You need to implement this function 
    # to extract the instance IDs from your Terraform output file.
    # For example, if your output file contains:
    # "outputs": {
    #     "instance_ids": {
    #         "value": ["i-1234567890abcdef0", "i-0123456789abcdef1"]
    #     }
    # }
    # You could use:
    import json
    data = json.loads(output_data)
    return data['outputs']['instance_ids']['value']

if __name__ == "__main__":
    main()