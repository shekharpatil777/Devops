import paramiko

#This script uses the paramiko library (install with pip install paramiko) to connect to a remote server via SSH and run package updates.

def update_remote_packages(hostname, port, username, password):
    try:
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy()) # For testing, not recommended for production
        client.connect(hostname=hostname, port=port, username=username, password=password)

        command = "sudo apt update && sudo apt upgrade -y"
        stdin, stdout, stderr = client.exec_command(command)

        print(f"Executing command on {hostname}: {command}")
        for line in stdout:
            print(f"  STDOUT: {line.strip()}")
        for line in stderr:
            print(f"  STDERR: {line.strip()}")

    except paramiko.AuthenticationException:
        print(f"Authentication failed for {username}@{hostname}")
    except paramiko.SSHException as e:
        print(f"Could not establish SSH connection to {hostname}: {e}")
    finally:
        if client:
            client.close()

if __name__ == "__main__":
    # Replace with your server details
    SERVER_HOST = "your_server_ip"
    SERVER_PORT = 22
    SERVER_USERNAME = "your_username"
    SERVER_PASSWORD = "your_password"

    # WARNING: Storing passwords in code is insecure. Use more secure methods like SSH keys.
    update_remote_packages(SERVER_HOST, SERVER_PORT, SERVER_USERNAME, SERVER_PASSWORD)