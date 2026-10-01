module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"

  # Public & Private access for remote/global teams
  cluster_endpoint_public_access = true

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Core CPU Node Group for system infrastructure (ArgoCD, Prometheus, Karpenter Controller)
  eks_managed_node_groups = {
    system_nodes = {
      instance_types = ["t3.xlarge"]
      min_size     = 2
      max_size     = 5
      desired_size = 2

      labels = {
        role = "system"
      }
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    Environment = var.environment
    GithubRepo  = "terraform-eks-mlops"
  }
}
