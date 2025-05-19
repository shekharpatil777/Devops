import boto3
import os

#This script uploads files from a local directory to an AWS S3 bucket. You'll need Boto3 installed and AWS credentials configured.

def deploy_to_s3(local_dir, bucket_name):
    s3 = boto3.client('s3')
    for root, _, files in os.walk(local_dir):
        for filename in files:
            local_path = os.path.join(root, filename)
            relative_path = os.path.relpath(local_path, local_dir)
            s3_key = relative_path.replace("\\", "/") # Ensure forward slashes for S3

            try:
                s3.upload_file(local_path, bucket_name, s3_key)
                print(f"Uploaded {local_path} to s3://{bucket_name}/{s3_key}")
            except Exception as e:
                print(f"Error uploading {local_path}: {e}")

if __name__ == "__main__":
    # Create a dummy website directory for testing
    if not os.path.exists("website"):
        os.makedirs("website")
        with open(os.path.join("website", "index.html"), "w") as f:
            f.write("<h1>Hello from my static website!</h1>")
        with open(os.path.join("website", "style.css"), "w") as f:
            f.write("body { font-family: sans-serif; }")

    BUCKET_NAME = "your-s3-bucket-name" # Replace with your S3 bucket name
    deploy_to_s3("website", BUCKET_NAME)