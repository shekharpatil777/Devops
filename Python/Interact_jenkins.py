import requests
from requests.auth import HTTPBasicAuth

jenkins_url = "http://your-jenkins-url:8080"
job_name = "your-job-name"
auth = HTTPBasicAuth('your_username', 'your_api_token')

# Trigger a Jenkins job
response = requests.post(f"{jenkins_url}/job/{job_name}/build", auth=auth)
if response.status_code == 201:
    print(f"Jenkins job '{job_name}' triggered successfully.")
else:
    print(f"Failed to trigger Jenkins job. Status code: {response.status_code}")