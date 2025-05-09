# Configure the AWS Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "your-aws-region" # Replace with your desired AWS region (e.g., us-east-1)
}

# Data source to retrieve existing VPC and Subnets (replace with your specifics)
data "aws_vpc" "selected" {
  default = true # Or specify by ID or tags
}

data "aws_subnet_ids" "selected" {
  vpc_id = data.aws_vpc.selected.id
}

# Create an EKS Cluster
resource "aws_eks_cluster" "app_cluster" {
  name     = "my-app-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = data.aws_subnet_ids.selected.ids
  }

  depends_on = [aws_iam_role_policy_attachment.eks_cluster_policy]
}

# IAM Role for the EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# IAM Policy Attachment for EKS Cluster
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# IAM Role for EKS Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# IAM Policy Attachments for EKS Nodes
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_role.name
}

# Create an EKS Node Group
resource "aws_eks_node_group" "app_nodes" {
  cluster_name    = aws_eks_cluster.app_cluster.name
  node_group_name = "app-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = data.aws_subnet_ids.selected.ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  instance_types = ["t3.medium"] # Choose appropriate instance types

  depends_on = [
    aws_eks_cluster.app_cluster,
    aws_iam_role_policy_attachment.eks_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_ssm_policy,
  ]
}

# Configure Kubernetes Provider to interact with the EKS Cluster
provider "kubernetes" {
  host                   = aws_eks_cluster.app_cluster.endpoint
  token                  = data.aws_eks_cluster_auth.app_cluster.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.app_cluster.certificate_authority.0.data)

  depends_on = [aws_eks_node_group.app_nodes]
}

data "aws_eks_cluster_auth" "app_cluster" {
  name = aws_eks_cluster.app_cluster.name
}

# Deploy your Application using Kubernetes Resources
resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "my-app-deployment"
    labels = {
      app = "my-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "my-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "my-app"
        }
      }
      spec {
        container {
          image = "your-dockerhub-repo/your-app-image:latest" # Replace with your container image
          name  = "my-app-container"
          port {
            container_port = 8080 # Replace with your application's port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app_service" {
  metadata {
    name = "my-app-service"
    labels = {
      app = "my-app"
    }
  }
  spec {
    selector = {
      app = "my-app"
    }
    ports {
      port        = 80
      target_port = 8080 # Should match container port
      protocol    = "TCP"
    }
    type = "LoadBalancer" # Or ClusterIP, NodePort as needed
  }

  depends_on = [kubernetes_deployment.app_deployment]
}

# (Optional) Install Helm and deploy a Helm Chart
provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.app_cluster.endpoint
    token                  = data.aws_eks_cluster_auth.app_cluster.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.app_cluster.certificate_authority.0.data)
  }

  depends_on = [kubernetes_deployment.app_deployment]
}

# Example of deploying a Helm chart (replace with your chart details)
# resource "helm_release" "my_chart" {
#   name       = "my-release"
#   chart      = "stable/nginx-ingress"
#   namespace  = "kube-system"
#   values = [
#     "${file("values.yaml")}" # Optional: Load values from a YAML file
#   ]
#
#   depends_on = [aws_eks_node_group.app_nodes]
# }