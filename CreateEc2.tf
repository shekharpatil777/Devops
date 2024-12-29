# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create an EC2 Instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.medium"

  tags = {
    Name = "Jenkins-Server"
  }

  # Open port 8080 for Jenkins
  vpc_security_group_ids = [aws_security_group.allow_jenkins.id]
}

# Create a Security Group
resource "aws_security_group" "allow_jenkins" {
  name       = "allow_jenkins"
  description = "Allow Jenkins access"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from anywhere (for testing)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Get the AMI ID for Amazon Linux 2
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
  }
}

# Install Java, Jenkins, Git, and Docker on the instance (using user data)
resource "aws_instance" "example" {
  # ... (other configurations as above) ...

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install java-openjdk11 -y
    sudo yum install -y git
    sudo yum install -y docker
    sudo systemctl enable docker
    sudo systemctl start docker

    # Download and install Jenkins
    curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
    sudo yum install -y jenkins

    # Start Jenkins service
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    EOF
}